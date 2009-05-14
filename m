From: Kevin Shanahan <kmshanah@ucwb.org.au>
Subject: Re: More ext4 acl/xattr corruption - 4th occurence now
Date: Thu, 14 May 2009 22:55:06 +0930
Message-ID: <20090514132506.GD5146@kulgan>
References: <20090513062634.GE4972@kulgan> <20090514044011.GC11352@mit.edu> <20090514110659.GA5146@kulgan>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from bowden.ucwb.org.au ([203.122.237.119]:56269 "EHLO
	mail.ucwb.org.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759274AbZENNZI (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 14 May 2009 09:25:08 -0400
Content-Disposition: inline
In-Reply-To: <20090514110659.GA5146@kulgan>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, May 14, 2009 at 08:37:00PM +0930, Kevin Shanahan wrote:
> Sure - now running with 2.6.29.3 + your patch.
> 
>   patching file fs/ext4/inode.c
>   Hunk #1 succeeded at 1040 with fuzz 1 (offset -80 lines).
>   Hunk #2 succeeded at 1113 (offset -81 lines).
>   Hunk #3 succeeded at 1184 (offset -93 lines).
> 
> I'll report any hits for "check_block_validity" in syslog.

That didn't take long:

May 14 22:49:17 hermes kernel: EXT4-fs error (device dm-0): check_block_validity: inode #759 logical block 1741329 mapped to 529 (size 1)
May 14 22:49:17 hermes kernel: Aborting journal on device dm-0:8.
May 14 22:49:17 hermes kernel: ext4_da_writepages: jbd2_start: 293 pages, ino 759; err -30
May 14 22:49:17 hermes kernel: Pid: 374, comm: pdflush Not tainted 2.6.29.3 #1
May 14 22:49:17 hermes kernel: Call Trace:
May 14 22:49:17 hermes kernel:  [<ffffffff802fdce3>] ext4_da_writepages+0x211/0x427
May 14 22:49:17 hermes kernel:  [<ffffffff8055b44f>] thread_return+0x3d/0xc3
May 14 22:49:17 hermes kernel:  [<ffffffff802fef56>] ext4_da_get_block_write+0x0/0x12d
May 14 22:49:17 hermes kernel:  [<ffffffff802757df>] do_writepages+0x20/0x2d
May 14 22:49:17 hermes kernel:  [<ffffffff802aa359>] __writeback_single_inode+0x196/0x3a4
May 14 22:49:17 hermes kernel:  [<ffffffff802542aa>] del_timer_sync+0xc/0x16
May 14 22:49:17 hermes kernel:  [<ffffffff802aa9b9>] generic_sync_sb_inodes+0x2a7/0x439
May 14 22:49:17 hermes kernel:  [<ffffffff802aacfa>] writeback_inodes+0x7d/0xcc
May 14 22:49:17 hermes kernel:  [<ffffffff8027591e>] wb_kupdate+0x9f/0x116
May 14 22:49:17 hermes kernel:  [<ffffffff802764bf>] pdflush+0x125/0x1d2
May 14 22:49:17 hermes kernel:  [<ffffffff8027587f>] wb_kupdate+0x0/0x116
May 14 22:49:17 hermes kernel:  [<ffffffff8027639a>] pdflush+0x0/0x1d2
May 14 22:49:17 hermes kernel:  [<ffffffff8025c8cc>] kthread+0x47/0x73
May 14 22:49:17 hermes kernel:  [<ffffffff80225f7a>] child_rip+0xa/0x20
May 14 22:49:17 hermes kernel:  [<ffffffff8025c885>] kthread+0x0/0x73
May 14 22:49:17 hermes kernel:  [<ffffffff80225f70>] child_rip+0x0/0x20
May 14 22:49:18 hermes kernel: Remounting filesystem read-only
May 14 22:49:18 hermes kernel: ------------[ cut here ]------------
May 14 22:49:18 hermes kernel: WARNING: at fs/ext4/inode.c:1066 check_block_validity+0xd8/0xff()
May 14 22:49:18 hermes kernel: Hardware name: S3210SH
May 14 22:49:18 hermes kernel: Pid: 3351, comm: smbd Not tainted 2.6.29.3 #1
May 14 22:49:18 hermes kernel: Call Trace:
May 14 22:49:18 hermes kernel:  [<ffffffff8024c0b0>] warn_slowpath+0xd3/0x10d
May 14 22:49:18 hermes kernel:  [<ffffffff8025cc0e>] wake_bit_function+0x0/0x23
May 14 22:49:18 hermes kernel:  [<ffffffff802afbec>] sync_dirty_buffer+0x5f/0x97
May 14 22:49:18 hermes kernel:  [<ffffffff8030589e>] ext4_commit_super+0xbc/0x103
May 14 22:49:18 hermes kernel:  [<ffffffff80307f92>] ext4_handle_error+0x83/0xa9
May 14 22:49:18 hermes kernel:  [<ffffffff803081cb>] ext4_error+0x83/0x90
May 14 22:49:18 hermes kernel:  [<ffffffff8051c5ab>] ipt_do_table+0x308/0x32d
May 14 22:49:18 hermes kernel:  [<ffffffff80245f5c>] dequeue_task_fair+0x45/0x167
May 14 22:49:18 hermes kernel:  [<ffffffff802fd222>] check_block_validity+0xd8/0xff
May 14 22:49:18 hermes kernel:  [<ffffffff802febe1>] ext4_get_blocks_wrap+0xb5/0x24f
May 14 22:49:18 hermes kernel:  [<ffffffff802fee2d>] ext4_da_get_block_prep+0x58/0x181
May 14 22:49:18 hermes kernel:  [<ffffffff802b0187>] __block_prepare_write+0x150/0x2c4
May 14 22:49:18 hermes kernel:  [<ffffffff802fedd5>] ext4_da_get_block_prep+0x0/0x181
May 14 22:49:18 hermes kernel:  [<ffffffff802701e4>] add_to_page_cache_locked+0x73/0x95
May 14 22:49:18 hermes kernel:  [<ffffffff802b0447>] block_write_begin+0x7a/0xc7
May 14 22:49:18 hermes kernel:  [<ffffffff802fce53>] ext4_da_write_begin+0x166/0x1ed
May 14 22:49:18 hermes kernel:  [<ffffffff802fedd5>] ext4_da_get_block_prep+0x0/0x181
May 14 22:49:18 hermes kernel:  [<ffffffff80270b94>] generic_file_buffered_write+0x12c/0x2e8
May 14 22:49:18 hermes kernel:  [<ffffffff80271145>] __generic_file_aio_write_nolock+0x25f/0x293
May 14 22:49:18 hermes kernel:  [<ffffffff80271928>] generic_file_aio_write+0x64/0xc4
May 14 22:49:18 hermes kernel:  [<ffffffff802f8d33>] ext4_file_write+0x93/0x118
May 14 22:49:18 hermes kernel:  [<ffffffff80292f9c>] do_sync_write+0xce/0x113
May 14 22:49:18 hermes kernel:  [<ffffffff802bc5a0>] vfs_test_lock+0x2e/0x32
May 14 22:49:18 hermes kernel:  [<ffffffff8025cbe0>] autoremove_wake_function+0x0/0x2e
May 14 22:49:18 hermes kernel:  [<ffffffff802bd116>] fcntl_setlk+0x24b/0x25c
May 14 22:49:18 hermes kernel:  [<ffffffff8029373f>] vfs_write+0xa5/0xde
May 14 22:49:18 hermes kernel:  [<ffffffff802937cf>] sys_pwrite64+0x57/0x77
May 14 22:49:18 hermes kernel:  [<ffffffff8029d8c9>] sys_fcntl+0x312/0x31e
May 14 22:49:18 hermes kernel:  [<ffffffff8022501b>] system_call_fastpath+0x16/0x1b
May 14 22:49:18 hermes kernel: ---[ end trace df4d7250236f7465 ]---
May 14 22:49:18 hermes kernel: EXT4-fs error (device dm-0) in ext4_da_write_begin: IO failure

Any clues there? I don't think I'll be able to run this during the day
if it's going to trigger and remount the fs read-only as easily as
this.

Cheers,
Kevin.
