From: Greg Freemyer <greg.freemyer@gmail.com>
Subject: Re: [PATCH] e2fsprogs: Fix the overflow in e4defrag with 2GB over
	file
Date: Tue, 30 Mar 2010 12:14:47 -0400
Message-ID: <87f94c371003300914h16a0ed4l38d27e1313c6383c@mail.gmail.com>
References: <4BB19BBB.9010509@rs.jp.nec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Theodore Tso <tytso@mit.edu>,
	ext4 development <linux-ext4@vger.kernel.org>
To: Akira Fujita <a-fujita@rs.jp.nec.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-vw0-f46.google.com ([209.85.212.46]:46973 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751409Ab0C3QOx (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 30 Mar 2010 12:14:53 -0400
Received: by vws20 with SMTP id 20so804114vws.19
        for <linux-ext4@vger.kernel.org>; Tue, 30 Mar 2010 09:14:52 -0700 (PDT)
In-Reply-To: <4BB19BBB.9010509@rs.jp.nec.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Mar 30, 2010 at 2:35 AM, Akira Fujita <a-fujita@rs.jp.nec.com> wrote:
> e2fsprogs: Fix the overflow in e4defrag with 2GB over file
>
> From: Akira Fujita <a-fujita@rs.jp.nec.com>
>
> In e4defrag, we use locally defined posix_fallocate interface.
> And its "offset" and "len" are defined as off_t (long) type,
> their upper limit is 2GB -1 byte.
> Thus if we run e4defrag to the file whose size is 2GB over,
> the overflow occurs at calling fallocate syscall.
>
> To fix this issue, I add new define _FILE_OFFSET_BITS 64 to use
> 64bit offset for filesystem related syscalls in e4defrag.c.
> (Also this patch includes open mode fix which has been
> released but not been merged e2fsprogs git tree yet.
> http://lists.openwall.net/linux-ext4/2010/01/19/3)
>
> Reported-by: David Calinski <david@fullrecall.com>
> Signed-off-by: Akira Fujita <a-fujita@rs.jp.nec.com>
> ---

Akira,

I haven't looked at the4defrag code since Sept, but does it still
defrag large files in one huge effort.

Thus a 100GB sparse file being used to hold VM virtual disk is
defrag'ed all at once.

And worse, when data is written to one of the holes in the sparse
file, the entire file has to be defragged again?

If so, I think that is a broken design, and e4defrag should simply
skip these large files for now.

The proper fix being to defrag a "donor extent" at a time.

ie. attempt to allocate a full 128 MB extent for the donor file.  If
successful, replace the first partial extent in the target file with
the donor extent.  Repeat until done.

That way you have a few advantages:

1) You never need more than one free extent to work with.

2) Once you defrag the beginning of a file, you never have to defrag
it again.  Thus when a sparse file gets new blocks/extents allocated,
only the areas of the files that are truly fragmented have to be
defragmented.

The one negative I can see is that the extents may not be localized
well with this approach.  Is that a major concern?  Is there a way to
try to localize the new donor extent request near to the extent it
will be following logically?

For the last issue, I think you've been working on a mballoc patch
that would give e4defrag the ability to control mballoc on a per inode
basis.  If not, the ohsm project has a patch for something similar.  I
haven't worked with the ohsm mballoc patch, so I'm not sure how it
works.

Greg
