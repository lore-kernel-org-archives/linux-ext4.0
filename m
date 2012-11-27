From: Adam Huffman <adam.huffman@gmail.com>
Subject: Re: Filesystem corruption on Fedora 17
Date: Tue, 27 Nov 2012 16:59:05 +0000
Message-ID: <CAP5prOh1VvLtCvY_iE2om2dXmgwHoD5JkkfVqu=MUtMiv9L9vg@mail.gmail.com>
References: <CAP5prOgjNXnvXr1HELuez7+Be+TW4N8t9P_AeQw8pBVYDnFHTg@mail.gmail.com>
	<20121127164745.GB7107@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-ext4 <linux-ext4@vger.kernel.org>
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-lb0-f174.google.com ([209.85.217.174]:41716 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756136Ab2K0Q7H (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 27 Nov 2012 11:59:07 -0500
Received: by mail-lb0-f174.google.com with SMTP id gi11so6833532lbb.19
        for <linux-ext4@vger.kernel.org>; Tue, 27 Nov 2012 08:59:05 -0800 (PST)
In-Reply-To: <20121127164745.GB7107@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Nov 27, 2012 at 4:47 PM, Theodore Ts'o <tytso@mit.edu> wrote:
> On Tue, Nov 27, 2012 at 01:31:18PM +0000, Adam Huffman wrote:
>>
>> On two machines now I've had severe filesystem corruption.  They are
>> both Fedora 17 machines, and they both have, at some point, run the
>> kernels that have been mentioned recently as possibly suffering from
>> ext4 corruption problems.
>
> I don't know if you followed the story that closely, but the hysteria
> over the "ext4 corruption problems" were caused by users who were
> using non-standard mount options or other ext4 features....
>

Yes, I only mentioned that "just in case".  I certainly don't have any
exotic mount options.

>> In the worst case, fsck is unable to fix the problems:
>>
>> fsck from util-linux 2.20.1
>> e2fsck 1.42.4 (12-June-2012)
>> ext2fs_check_desc: Corrupt group descriptor: bad block for block bitmap
>> fsck.ext4: Group descriptors look bad... trying backup blocks...
>> /dev/mapper/heppc128-lv_home: recovering journal
>> fsck.ext4: unable to set superblock flags on /dev/mapper/heppc128-lv_home
>
> Furthermore, this doesn't look like any of the problems that people
> have reported.  The corruption pattern looks most like what you would
> see if the blocks in the beginning (low numbered blocks) part of the
> file system have been overwritten with garbage.
>
> So first of all, if there is critical data that you want to preserve,
> the first thing I'd suggest doing is to make a image copy of the
> partition; it's only 56 GB, so hopefluly you have space to make a copy
> before you do any further experimentation to try to recover things.
>

I took a copy using dd_rescue yesterday, and that's what I've been
running fsck against.
(After that I tried mkfs.ext4 -S on the disk itself, which wasn't successful...)
The images comprises an LVM PV and VG, so I've used kpartx to make it
available, if that makes a difference.

There is one person claiming that it does:

http://j-b.livejournal.com/334065.html

> As far as the "unable to set superblock flags" error, I think I can
> see how that can happen (and in fact I've created a short test case
> which demonstrates the problem --- see attached), but that appears to
> be a one shot failure.  That is, the second time you run e2fsck, it
> should be able to make progress. is that the case for you?
>

No, I see the same error no matter how many times I run e2fsck.

> (It's also possible that there are hardware bugs which is triggering
> this problem, however, and if in fact you're seeing this happen
> repeatably, I'd have seriously suspect some kind of hardware failure.)
>

While I did suspect hardware problems, there hasn't been any sign of
them in the system logs so far.

Do you have any ideas about this error, with a different LV from the same disk?:

Pass 1: Checking inodes, blocks, and sizes
Inode 4122234 has illegal block(s).  Clear? yes

Illegal block #256918621 (1313286244) in inode 4122234.  CLEARED.
Error storing directory block information (inode=4122234, block=0,
num=78646612): Memory allocation failed

Many thanks for taking a look.

Best Wishes,
Adam

>                                             - Ted
>
> P.S.  In order to get this failure I had to basically use a block
> editor, since there are software safeguards which prevent e2fsprogs or
> ext4 from setting the needs_recovery bit on backup superblocks, and
> this is what was necessary to trigger the bug.  I'll fix this for the
> next release of e2fsprogs.  The reason why we hadn't noticed was
> because (a) it basically requires a very specific hardware-induced
> bit-flip to trigger, and (b) even when it does, the second run of
> e2fsck makes the problem go away, so typically it gets noticed when
> system fails to boot due to e2fsck blowing out, and then when the
> system administrator runs fsck a second time on the file system,
> forward progress gets made.
>
