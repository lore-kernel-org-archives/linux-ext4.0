From: Theodore Tso <tytso@mit.edu>
Subject: Re: Problem mounting ext2 using ext3?
Date: Mon, 5 May 2008 18:26:23 -0400
Message-ID: <20080505222623.GA8357@mit.edu>
References: <Pine.LNX.4.64.0805052304280.3160@anakin>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org,
	Linux Kernel Development <linux-kernel@vger.kernel.org>,
	Linux/m68k <linux-m68k@vger.kernel.org>, Jan Kara <jack@suse.cz>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from www.church-of-our-saviour.ORG ([69.25.196.31]:51040 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757450AbYEEW0s (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 5 May 2008 18:26:48 -0400
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0805052304280.3160@anakin>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, May 05, 2008 at 11:11:46PM +0200, Geert Uytterhoeven wrote:
> when mounting the root file system, which is ext2 (has_journal is not set).
> Apparently it crashes in ext3_sync_fs because EXT3_SB(sb)->s_journal is NULL.
> 
> At first I thought it was an issue with the byteswapped IDE bus on Atari (a
> new and different solution to handle this just went into mainline), but if I
> disable CONFIG_EXT3 support, it boots up fine.
> 
> Is this a known problem?

I can confirm this as a regression.  You don't even need to mount it
as a root filesystem, or do this on an 68k system.  On my x86 system,
using a kernel based off of git commit: afa26be8 (6 commits after
2.6.26-rc1), mounting an ext3 filesystem, you can cause an oops by
taking an ext2 filesystem and forcing a mount as ext3, "mount -t ext3
/dev/closure/textext2fs /mnt").  (see below for my oops).  This does
not occur with a kernel based off of 2.6.25, so it's a definite
regression.

Looks like the problem is some of the recent quota cleanups.  The
problem is that ext3_fill_super is returning an error, because the
journal is missing.  get_sb_dev() calls ext3_fill_super, and upon
receiving an error, it is calling deactivate_super(), which calls:

	     DQUOT_OFF(s, 0);

(line 182 in fs/super.c, in deactivate_super(), recently modified just
after 2.6.25, at comment 0ff5af8340aa6be44220d7237ef4a654314cf795,
although I'm not sure this is actually the problem commit)).  

The blow up is happening because the because superblock was not fully
set up, and the comment in the commit involved mentioned cleaning up
what is supposed to happen when remounting a filesystem turning quota
on or off.  I'm guessing that the changes didn't take into account
that DQUOT_OFF() can get called with a partially set-up superblock,
which will happen when the filesystme specific get_sb() code refuses a
mount and returns an error.

Jan, can you take a look at this and confirm whether or not this is
the root cause of the crash?

Thanks!!

						- Ted 


Pid: 6738, comm: mount Tainted: G        W (2.6.26-rc1-01265-g1f94101 #12)
EIP: 0060:[<f8980f89>] EFLAGS: 00010286 CPU: 0
EIP is at ext3_sync_fs+0x19/0x47 [ext3]
EAX: 00000000 EBX: f619e400 ECX: f8980f70 EDX: ed029dd8
ESI: 00000001 EDI: f8990520 EBP: ed029de4 ESP: ed029dd8
 DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
Process mount (pid: 6738, ti=ed029000 task=f36eaea0 task.ti=ed029000)
Stack: f8990520 f619e400 f619e400 ed029e44 c01b4218 00000000 ffffffff f619e560 
       ed029e18 00000246 f619e514 00000246 ed029e38 f619e65c f619e664 c03ccd80 
       00000002 c03ccd90 00000246 c018890e 00000246 c03ccd80 00000000 00000000 
Call Trace:
 [vfs_quota_off+1051/1287] ? vfs_quota_off+0x41b/0x507
 [deactivate_super+51/106] ? deactivate_super+0x33/0x6a
 [vfs_quota_off+0/1287] ? vfs_quota_off+0x0/0x507
 [deactivate_super+74/106] ? deactivate_super+0x4a/0x6a
 [get_sb_bdev+230/275] ? get_sb_bdev+0xe6/0x113
 [alloc_vfsmnt+225/265] ? alloc_vfsmnt+0xe1/0x109
 [<f897fe47>] ? ext3_get_sb+0x13/0x15 [ext3]
 [<f89817c1>] ? ext3_fill_super+0x0/0x14d9 [ext3]
 [vfs_kern_mount+129/247] ? vfs_kern_mount+0x81/0xf7
 [do_kern_mount+50/186] ? do_kern_mount+0x32/0xba
 [do_new_mount+70/113] ? do_new_mount+0x46/0x71
 [do_mount+407/437] ? do_mount+0x197/0x1b5
 [down+43/47] ? down+0x2b/0x2f
 [down+43/47] ? down+0x2b/0x2f
 [sys_mount+100/156] ? sys_mount+0x64/0x9c
 [sysenter_past_esp+120/209] ? sysenter_past_esp+0x78/0xd1
 =======================
Code: 00 8b 80 c4 11 00 00 c6 42 11 00 e8 5f 20 fc ff 5d c3 55 89 e5 56 89 d6 53 89 c3 83 ec 04 c6 40 11 00 8b 80 b0 02 00 00 8d 55 f4 <8b> 80 c4 11 00 00 e8 ff 62 fc ff 85 c0 74 18 85 f6 74 14 8b 83 
EIP: [<f8980f89>] ext3_sync_fs+0x19/0x47 [ext3] SS:ESP 0068:ed029dd8
May  5 17:42:53 closure kernel: [  102.207975] ---[ end trace ac590292814c8102 ]


