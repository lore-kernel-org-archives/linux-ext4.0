From: "George Spelvin" <linux@horizon.com>
Subject: Re: Issue with bad file system
Date: 19 Nov 2012 03:32:45 -0500
Message-ID: <20121119083245.18044.qmail@science.horizon.com>
References: <CAPAnFc9axLdcQ0xsGKsqQ5jMVs13JjYv7JdJkc_Q6Kdwa56JiQ@mail.gmail.com>
Cc: linux-ext4@vger.kernel.org
To: dreusser@gmail.com, linux@horizon.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from science.horizon.com ([71.41.210.146]:57005 "HELO
	science.horizon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753146Ab2KSIcr (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 19 Nov 2012 03:32:47 -0500
In-Reply-To: <CAPAnFc9axLdcQ0xsGKsqQ5jMVs13JjYv7JdJkc_Q6Kdwa56JiQ@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

> I am running this on Linux Mint 12 .. I don't know the kernel version
> as I cannot boot so I am booting of whatever I downloaded from Mint's
> website (13 rc I think) off a pen drive to try and save my data.
> 
> mint mnt # uname -a
> Linux mint 3.5.0-17-generic #28-Ubuntu SMP Tue Oct 9 19:31:23 UTC 2012
> x86_64 x86_64 x86_64 GNU/Linux

For the benefit of other ext4 hackers, Mint 12 is based on Ubuntu 11.10
and runs a 3.0 kernel.

> I ran the cat of /proc/partitions and copied the data from previous
> emails to the linux-raid DL (which forwarded me onto this one).  Must
> have gotten it before the raid was working.  Here is an updated one.

Okay, no problem.  The failure to show up just conflicted with your
statement that the RAID worked fine, and I was wondering if there wa a
problem there.  It appears that's not the issue.

> as for the last command you asked .. can you give me more info on it?
> if you meant dumpe2fs ... here is the output.

I did; my fingers got confused; sorry about the typo.  Doubly sorry
because it is a plausible command name.

> mint mnt # dumpe2fs -h /dev/md0
> dumpe2fs 1.42.5 (29-Jul-2012)
> dumpe2fs: Bad magic number in super-block while trying to open /dev/md0
> Couldn't find valid filesystem superblock.

Well, that explains the immediate problem.

Does "dumpe2fs -h -o superblock=32768" produce anything more useful?
(That checks the first backup superblock.  There are additional backups at
98304, 163840, 229376, 294912, ...)

> Can you give me specific e2fsck commands to run which will not ruin my
> disks and data?  I have seen people online recommending re-writing the
> super blocks but I am now sure I want to write anything until I know
> it will not damage something and erase my data.

"e2fsck -n" will only print errors and not change anything.  It's
always safe.

Try "e2fsck -n -v /dev/md0" (given the dumpe2fs failure, I expect that
will not work) and then try "e2fsck -n -v -b 32768 /dev/md0".

I don't know what happened to your superblock, but if that's all that
got trashed, recovery is actually quite straightforward and there's no
risk of data loss.  e2fsck will just print a huge number of "free blocks
count wrong" messages as it fixes them.

(However, that's a pretty big "if".)


Another thing that would be useful is "dd if=/dev/md0 skip=2 count=2 | xxd"
(or od -x if you don't have xxd).  That will give a hex dump of the
primary superblock, which might show the extent of the damage.


If "e2fsck -n -b 32768" works, the way to repair it is to run it again
without the "-n", but the -n output will say how bad it is.

As a general rule of thumb, the more phases e2fsck gets through before
complaining, the less the damage.  Errors in the bitmaps found in phase 5
are not a serious problem; they only indicate things that would rapidly
*become* serious problems if you mounted the file system and tried to
write to it.

One thing I strongly recommend when e2fsck is fixing a lot of problems is
to save a log (I usually use the "script" program, but you can also use
"<command> 2>&1 | tee output") of the e2fsck run so you can refer back
to it later.
