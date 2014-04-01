From: Justin Brown <justin.brown@fandingo.org>
Subject: Re: Fsck.ext4: Memory Allocation Failed
Date: Tue, 1 Apr 2014 15:15:54 -0500
Message-ID: <CAKZK7uwC=M0F6dtYZXjo6dd9yh=0PObsg5BYvP=UjyN0Pr5H-A@mail.gmail.com>
References: <CAKZK7uwTp2cMoWLiWZSa5UfZ2dCxRaB7KLZ0PtVVSqimp=tLJA@mail.gmail.com>
	<20140401022231.GC4911@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-ext4@vger.kernel.org
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-ig0-f174.google.com ([209.85.213.174]:43552 "EHLO
	mail-ig0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751839AbaDAUPz (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 1 Apr 2014 16:15:55 -0400
Received: by mail-ig0-f174.google.com with SMTP id h18so5334579igc.7
        for <linux-ext4@vger.kernel.org>; Tue, 01 Apr 2014 13:15:54 -0700 (PDT)
In-Reply-To: <20140401022231.GC4911@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi Ted,

Thanks for the reply. I had to repeat that on a couple other blocks,
but it seems to work.

I do have one other question. The fsck has been running for several
hours now, and while it was fixing lots of errors at the beginning,
there hasn't been any output from fsck in ~2 hours. I assume that it's
still on stage 1 block and inode check. There are two interesting
things. First, memory utilization is 9GiB (not including cache) and
has been stable for a long time now, which seems quite odd that memory
utilization has remained so high. Second, I attached strace to the
fsck process. It's not particularly easy for me to tell what's
happening, but it seems like fsck is going through every inode doing a
4096 write, lseek -4096, read 4096, and then lseek off to some other
place. I'm surprised that fsck would be doing such a large number of
writes, especially given that there's no new messages on
stdout/stderr. It's more like behavior that I would expect from
defragmentation. Does this seem normal?

Cheers,
Justin

On Mon, Mar 31, 2014 at 9:22 PM, Theodore Ts'o <tytso@mit.edu> wrote:
> On Mon, Mar 31, 2014 at 03:49:29PM -0500, Justin Brown wrote:
>> Pass 1: Checking inodes, blocks, and sizes
>> Inode 14109880 has illegal block(s).  Clear? yes
>>
>> Illegal block #0 (3925875673) in inode 14109880.  CLEARED.
>> Illegal block #2 (85326080) in inode 14109880.  CLEARED.
>> Illegal block #3 (2516589529) in inode 14109880.  CLEARED.
>> Illegal block #5 (3641317099) in inode 14109880.  CLEARED.
>> Illegal block #6 (394723355) in inode 14109880.  CLEARED.
>> Illegal block #7 (2986344453) in inode 14109880.  CLEARED.
>> Illegal block #8 (3640903191) in inode 14109880.  CLEARED.
>> Illegal block #9 (463536155) in inode 14109880.  CLEARED.
>> Illegal block #11 (1275199487) in inode 14109880.  CLEARED.
>> Illegal double indirect block (2181366192) in inode 14109880.  CLEARED.
>> Illegal block #563086348 (4294967295) in inode 14109880.  CLEARED.
>> Error storing directory block information (inode=14109880, block=0,
>> num=471166008): Memory allocation failed
>
> Sorry, this is a bug in e2fsck; we should handle this kind of
> corrupted inode better.
>
> The quick workaround is this:
>
> debugfs -w -R "clri <14109880>" /dev/vg/root
>
> This will zap the contents of the offending inode, since it's been
> overwritten with garbage; unfortunately, it was garbage which was
> causing e2fsck to try to allocate too much memory, and then fail.
>
>                                       - Ted
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
