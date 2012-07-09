From: Greg Freemyer <greg.freemyer@gmail.com>
Subject: Re: e2defrag 0.81 released
Date: Mon, 9 Jul 2012 12:16:11 -0400
Message-ID: <CAGpXXZ+B67C9+oxH35sW4Pjg61VC-GdJEjUqwDw57AnLHdUkAw@mail.gmail.com>
References: <4FF76E37.1020001@ubuntu.com> <6642BE04-8D3A-4B15-8FB1-05DFB80CB6B9@dilger.ca>
 <4FF84D4C.1030308@ubuntu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Cc: Andreas Dilger <adilger@dilger.ca>,
	ext4 development <linux-ext4@vger.kernel.org>
To: Phillip Susi <psusi@ubuntu.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-bk0-f46.google.com ([209.85.214.46]:38818 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751218Ab2GIQQn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 9 Jul 2012 12:16:43 -0400
Received: by bkwj10 with SMTP id j10so6166726bkw.19
        for <linux-ext4@vger.kernel.org>; Mon, 09 Jul 2012 09:16:42 -0700 (PDT)
In-Reply-To: <4FF84D4C.1030308@ubuntu.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sat, Jul 7, 2012 at 10:53 AM, Phillip Susi <psusi@ubuntu.com> wrote:
> -----BEGIN PGP SIGNED MESSAGE-----
> Hash: SHA1
>
> On 07/07/2012 02:02 AM, Andreas Dilger wrote:
>> I hate to rain on your parade, but, are you aware of e4defrag?
>
> Of course.  I started working on e2fsprogs two years ago though, when e4defrag was still on the drawing board, and just haven't gotten around to polishing and announcing it until now.

e4defrag has been around more than 2 years.  It's been at least 2
years since I did a code review of how it works.

> My understanding of e4defrag is that it works essentially like tools such as shake: find a fragmented file and copy it, hoping the copy will be less fragmented.  Thus, it does nothing for free space fragmentation, file locality, etc.  Plus, it doesn't have cool ansi graphics ;)

More or less true except iirc the process is more like:

find a fragmented file.
fallocate a new donor file with uninitialized data blocks..  (ie. data
blocks get assigned, but not written to.)
if new donor file is less fragmented than orig file:
   copy data from orig_blocks to donor_blocks
   swap donor blocks with original blocks at the inode level.
end if
delete donor

At a minimum I think e4defrag should work better with sparse files and
defrag each block group separately.

Also it used to hold the file lock for the entire time the copy data /
swap donor blocks operation took place.  For a large file that could
be a very long time.  I don't know if that was ever made less
intrusive or not.  ie. defragging a 100 GB file used to require
putting a i/o lock in place for the entire time it took to copy that
100GB of blocks to the donor blocks.

Of course, even that is better than having to unmount the filesystem
like you new tool apparently requires.

>> It is already in e2fsprogs, and can be used on a mounted ext4 filesystem...
>> It also needs some lovin' to make it really robust, but would definitely
>> be a better starting point than the ancient e2defrag code...
>>
>> That's why it is always a good idea to post to the mailing list _before_
>> you start on a project, to see what else is going on...  Definitely there
>> is a need for such a tool, but I hate to see effort being spent in two
>> different directions to make two so-so tools, when it could be going in
>> the same direction to make one excellent tool.
>
> I'm hoping that eventually e4defrag will be able to do everything e2defrag can, and not too much slower, but for the moment, e2defrag already works, and I haven't seen any indication that e4defrag is planned to do free space defragging and file packing.  Perhaps having a little friendly competition will change that.

I think you're right e4defrag userspace code ignores consolidating
freespace to make bigger extents possible and I don't think userspace
has any file packing specific knowledge.

Does fallocate itself assist with either?

ie. since e4defrag uses fallocate to allocate the donor file blocks,
logically it would make sense to add the intelligence you are looking
for into fallocate.  And hopefully it is already there.

Greg
