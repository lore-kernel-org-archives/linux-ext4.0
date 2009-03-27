From: Theodore Tso <tytso@mit.edu>
Subject: Re: Once more: Recovering a damaged ext4 fs?
Date: Fri, 27 Mar 2009 18:46:16 -0400
Message-ID: <20090327224616.GD5176@mit.edu>
References: <p0624058dc5f2d7be08cc@[130.161.115.44]>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: "J.D. Bakker" <jdb@lartmaker.nl>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from THUNK.ORG ([69.25.196.29]:40658 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752475AbZC0WqU (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 27 Mar 2009 18:46:20 -0400
Content-Disposition: inline
In-Reply-To: <p0624058dc5f2d7be08cc@[130.161.115.44]>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Mar 27, 2009 at 09:41:21PM +0100, J.D. Bakker wrote:
> Hi all,
>
> My 4TB ext4 RAID-6 has been damaged again. Symptoms leading up to it  
> were very similar to the last time (see  
> http://article.gmane.org/gmane.comp.file-systems.ext4/11418 ): a process 
> attempted to delete a large (~2GB) file, resulting in a soft lockup with 
> the following call trace:
>
>  [<ffffffff80526dd7>] ? _spin_lock+0x16/0x19
>  [<ffffffff80317b49>] ? ext4_mb_init_cache+0x81c/0xa58
>  [<ffffffff80281249>] ? __lru_cache_add+0x8e/0xb6
>  [<ffffffff80279d37>] ? find_or_create_page+0x62/0x88
>  [<ffffffff80317ec2>] ? ext4_mb_load_buddy+0x13d/0x326
>  [<ffffffff80318385>] ? ext4_mb_free_blocks+0x2da/0x75e

Thanks, we've been trying to track this down.  The hint that you were
trying to delete a large (~2 GB) file may be what I need to reproduce
it locally.

If it happens again, could you try doing this:

   echo w > /proc/sysrq-trigger
   dmesg > /tmp/dmesg.txt

And send the output of dmesg.txt to us?  

> Kernel is 2.6.29-rc6. Machine is still responsive to anything that  
> doesn't touch the ext4 file system, but fails to halt. Upon power  
> cycling fsck fails with:
>
>  newraidfs: Superblock has an invalid ext3 journal (inode 8).
>  CLEARED.
>  *** ext3 journal has been deleted - filesystem is now ext2 only ***
>
>  newraidfs: Note: if several inode or block bitmap blocks or part
>  of the inode table require relocation, you may wish to try
>  running e2fsck with the '-b 32768' option first.  The problem
>  may lie only with the primary block group descriptors, and
>  the backup block group descriptors may be OK.
>
>  newraidfs: Block bitmap for group 0 is not in group.  (block 3273617603)

It's rather disturbing that there was this much damage done from what
looks like a deadlock condition.  Others who have report this soft
lockup condition haven't reported this kind of filesystem damage.  I
wonder if it might be caused by power-cycling the box; if possible, I
do recommend that people use the reset button rather than power
cycling the box; it tends to be much safer and gentler on the machine.

>  e2fsck 1.41.4 (27-Jan-2009)
>  ./e2fsck/e2fsck: Group descriptors look bad... trying backup blocks...
>  Block bitmap for group 0 is not in group.  (block 3273617603)
>  Relocate? no
>  Inode bitmap for group 0 is not in group.  (block 3067860682)
>  Relocate? no
>  Inode table for group 0 is not in group.  (block 3051956899)
>  WARNING: SEVERE DATA LOSS POSSIBLE.

I really don't know how to explain the fact that your primary and
backup superblocks are getting corrupted.  This is a real puzzler for
me.  As I think I've told you before, the kernel simply doesn't know
how write to the backup superblocks. 

> - is there a way to recover my file system? I do have backups of most  
> data,but as my remote weeklies run on Saturdays I'd still lose a lot of 
> work

Well, probably the best bet at this point is to use "mke2fs -S"; see
the man pages for more details.  You need to make sure you give
exactly the same arguments to mke2fs that you used when you first
created the filesystem.  The mke2fs.conf also needs to be exactly the
same as when the filesystem was originally created.

Given that your system seems to have this prediction to wipe out the
first part of your block group descriptors, what I would recommend is
backing up your block group descriptors like this:

	dd if=/dev/XXXX of=backup-bg.img bs=4k count=234

This will backup just your block group descriptors, and will allow you
to restore them later (although you will have to run e2fsck restoring
them).

The bigger question is how 16 4k blocks between block numbers 1 and 17
are getting overwritten by garbage.  As I mentioned, I haven't seen
anything like this except from your system.  Some others have reported
a soft lockup when doing an "rm -rf" of a large hierarchy, but they
haven't reported this kind of filesystem corruption.  I haven't been
able to replicate it yet myself.  

> - is ext4 on software raid-6 on x86_64 considered production stable? I 
> have been getting these hangs almost monthly, which is a lot worse than 
> my old ext3 software RAID.

Well, the softlockup bug you're seeing is a real one.  A lot of people
aren't seeing it, but you clearly are seeing it, and so we need to
track it down.  I guess by definition, the fact that you're seeing
this bug means it's not "production stable".  On the other hand, a lot
of poeple have been using ext4 without seeing this bug, some of them
in production situations.  The criteria for "production stable" is a
little grey; certainly no enterprise distribution is calling ext4
"production stable" yet, although it's been released as a technology
preview by some distro's.  The problem is that a lot of these problems
can only be found when it starts getting tested by a large userbase,
so this kind of early testing is critical.  

That being said, I don't want to see early testers losing data, since
that tends to scare them off from providing the testing that we so
critically need.  Hence my suggestion of using dd to backup the block
group descriptor blocks. 

And if you're not willing to take the risk, I'll completely understand
your deciding that you need to switch back to ext3.  But if you are
willing to continue testing, and helping us find the root cause
of the problem, we will be very grateful.

Best regards,

						- Ted

P.S.  You were using a completely stock kernel, correct?  No other
patches installed?

