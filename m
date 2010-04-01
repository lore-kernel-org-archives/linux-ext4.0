From: Akira Fujita <a-fujita@rs.jp.nec.com>
Subject: Re: [PATCH] e2fsprogs: Fix the overflow in e4defrag with 2GB over
 	file
Date: Thu, 01 Apr 2010 17:27:19 +0900
Message-ID: <4BB458E7.9050306@rs.jp.nec.com>
References: <4BB19BBB.9010509@rs.jp.nec.com> <87f94c371003300914h16a0ed4l38d27e1313c6383c@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Theodore Tso <tytso@mit.edu>,
	ext4 development <linux-ext4@vger.kernel.org>
To: Greg Freemyer <greg.freemyer@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from TYO201.gate.nec.co.jp ([202.32.8.193]:44766 "EHLO
	tyo201.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754145Ab0DAI3e (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 1 Apr 2010 04:29:34 -0400
In-Reply-To: <87f94c371003300914h16a0ed4l38d27e1313c6383c@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi Greg,

(2010/03/31 1:14), Greg Freemyer wrote:
> On Tue, Mar 30, 2010 at 2:35 AM, Akira Fujita<a-fujita@rs.jp.nec.com>  wrote:
>> e2fsprogs: Fix the overflow in e4defrag with 2GB over file
>>
>> From: Akira Fujita<a-fujita@rs.jp.nec.com>
>>
>> In e4defrag, we use locally defined posix_fallocate interface.
>> And its "offset" and "len" are defined as off_t (long) type,
>> their upper limit is 2GB -1 byte.
>> Thus if we run e4defrag to the file whose size is 2GB over,
>> the overflow occurs at calling fallocate syscall.
>>
>> To fix this issue, I add new define _FILE_OFFSET_BITS 64 to use
>> 64bit offset for filesystem related syscalls in e4defrag.c.
>> (Also this patch includes open mode fix which has been
>> released but not been merged e2fsprogs git tree yet.
>> http://lists.openwall.net/linux-ext4/2010/01/19/3)
>>
>> Reported-by: David Calinski<david@fullrecall.com>
>> Signed-off-by: Akira Fujita<a-fujita@rs.jp.nec.com>
>> ---
>
> Akira,
>
> I haven't looked at the4defrag code since Sept, but does it still
> defrag large files in one huge effort.
>
> Thus a 100GB sparse file being used to hold VM virtual disk is
> defrag'ed all at once.
>
> And worse, when data is written to one of the holes in the sparse
> file, the entire file has to be defragged again?

Yes, but only if necessary.
The blocks which are allocated to the holes in the sparse file
are not defragged, because the target blocks to be defragged
are determined by FS_IOC_FIEMAP which is called at the beginning of e4defrag.


> If so, I think that is a broken design, and e4defrag should simply
> skip these large files for now.
>
> The proper fix being to defrag a "donor extent" at a time.
>
> ie. attempt to allocate a full 128 MB extent for the donor file.  If
> successful, replace the first partial extent in the target file with
> the donor extent.  Repeat until done.

If allocate blocks to donor file per 128MB, and then
exchange blocks with EXT4_IOC_MOVE_EXT,
fragmentation improvement is unknown till the last, in worst case.
As a result, the wast I/Os are generated.

On the other hand, current e4defrag allocates blocks with fallocate
by logical contiguous unit (the holes in the sparse file are skipped).
After allocating whole blocks, compare extents count between source file
and donor file.  If fragmentation does not seem to be improved,
no need to call EXT4_IOC_MOVE_EXT to block exchange, just skip this file.
I think this is better.
(Of course, free space same as source file is necessary, though.)

By the way, EXT4_IOC_MOVE_EXT is called per extent.
This method has not been changed so far,
the patch just fixes fallocate argument overflow.

> That way you have a few advantages:
>
> 1) You never need more than one free extent to work with.
>
> 2) Once you defrag the beginning of a file, you never have to defrag
> it again.  Thus when a sparse file gets new blocks/extents allocated,
> only the areas of the files that are truly fragmented have to be
> defragmented.
>
> The one negative I can see is that the extents may not be localized
> well with this approach.  Is that a major concern?  Is there a way to
> try to localize the new donor extent request near to the extent it
> will be following logically?
>
> For the last issue, I think you've been working on a mballoc patch
> that would give e4defrag the ability to control mballoc on a per inode
> basis.  If not, the ohsm project has a patch for something similar.  I
> haven't worked with the ohsm mballoc patch, so I'm not sure how it
> works.
>

Yes, we have been working on block allocation control patch for e4defrag.
Most of tests have been done, but it takes a little more time to release.
(Note: Andreas Dilger advised me that we should use inode PA
  instead of implementing the arule ioctl to control block allocation, before.
  And it makes sense a lot, so this patch uses inode PA to control block allocation,
  its implementation is different from the ohsm has.)

Regards,
Akira Fujita
