From: Masayoshi MIZUMA <m.mizuma@jp.fujitsu.com>
Subject: [BUG] ext4: cannot unfreeze a filesystem due to a deadlock
Date: Mon, 07 Feb 2011 20:53:25 +0900
Message-ID: <20110207205325.FB6A.61FB500B@jp.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 8BIT
Cc: linux-fsdevel@vger.kernel.org
To: Andreas Dilger <adilger.kernel@dilger.ca>,
	"Theodore Ts'o" <tytso@mit.edu>, linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:45477 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753767Ab1BGLxF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 7 Feb 2011 06:53:05 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi,

When I checked the freeze feature for ext4 filesystem using fsfreeze command
at 2.6.38-rc3, I got the following messeges:

---------------------------------------------------------------------
Feb  7 15:05:09 RX300S6 kernel: INFO: task fsfreeze:2104 blocked for more than 120 seconds.
Feb  7 15:05:09 RX300S6 kernel: "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
Feb  7 15:05:09 RX300S6 kernel: fsfreeze        D ffff880076d5f040     0  2104   2018 0x00000000
Feb  7 15:05:09 RX300S6 kernel: ffff88005a9f3d98 0000000000000086 ffff88005a9f3d38 ffffffff00000000
Feb  7 15:05:09 RX300S6 kernel: 0000000000014d40 ffff880076d5eab0 ffff880076d5f040 ffff88005a9f3fd8
Feb  7 15:05:09 RX300S6 kernel: ffff880076d5f048 0000000000014d40 ffff88005a9f2010 0000000000014d40
Feb  7 15:05:09 RX300S6 kernel: Call Trace:
Feb  7 15:05:09 RX300S6 kernel: [<ffffffff814aa5f5>] rwsem_down_failed_common+0xb5/0x140
Feb  7 15:05:09 RX300S6 kernel: [<ffffffff814aa693>] rwsem_down_write_failed+0x13/0x20
Feb  7 15:05:09 RX300S6 kernel: [<ffffffff8122f1a3>] call_rwsem_down_write_failed+0x13/0x20
Feb  7 15:05:09 RX300S6 kernel: [<ffffffff814a9c12>] ? down_write+0x32/0x40
Feb  7 15:05:09 RX300S6 kernel: [<ffffffff81155b48>] thaw_super+0x28/0xd0
Feb  7 15:05:09 RX300S6 kernel: [<ffffffff81164338>] do_vfs_ioctl+0x368/0x560
Feb  7 15:05:09 RX300S6 kernel: [<ffffffff81157c73>] ? sys_newfstat+0x33/0x40
Feb  7 15:05:09 RX300S6 kernel: [<ffffffff811645d1>] sys_ioctl+0xa1/0xb0
Feb  7 15:05:09 RX300S6 kernel: [<ffffffff8100bf82>] system_call_fastpath+0x16/0x1b
...
Feb  7 15:07:09 RX300S6 kernel: INFO: task flush-8:0:1409 blocked for more than 120 seconds.
Feb  7 15:07:09 RX300S6 kernel: "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
Feb  7 15:07:09 RX300S6 kernel: flush-8:0       D ffff880037777a30     0  1409      2 0x00000000
Feb  7 15:07:09 RX300S6 kernel: ffff880037c95a80 0000000000000046 ffff88007c8037a0 0000000000000000
Feb  7 15:07:09 RX300S6 kernel: 0000000000014d40 ffff8800377774a0 ffff880037777a30 ffff880037c95fd8
Feb  7 15:07:09 RX300S6 kernel: ffff880037777a38 0000000000014d40 ffff880037c94010 0000000000014d40
Feb  7 15:07:09 RX300S6 kernel: Call Trace:
Feb  7 15:07:09 RX300S6 kernel: [<ffffffffa00abb85>] ext4_journal_start_sb+0x75/0x130 [ext4]
Feb  7 15:07:09 RX300S6 kernel: [<ffffffff81082fc0>] ? autoremove_wake_function+0x0/0x40
Feb  7 15:07:09 RX300S6 kernel: [<ffffffffa0097f0a>] ext4_da_writepages+0x27a/0x640 [ext4]
Feb  7 15:07:09 RX300S6 kernel: [<ffffffff81102c91>] do_writepages+0x21/0x40
Feb  7 15:07:09 RX300S6 kernel: [<ffffffff811776b8>] writeback_single_inode+0x98/0x240
Feb  7 15:07:09 RX300S6 kernel: [<ffffffff81177cfe>] writeback_sb_inodes+0xce/0x170
Feb  7 15:07:09 RX300S6 kernel: [<ffffffff81178709>] writeback_inodes_wb+0x99/0x160
Feb  7 15:07:09 RX300S6 kernel: [<ffffffff81178a8b>] wb_writeback+0x2bb/0x430
Feb  7 15:07:09 RX300S6 kernel: [<ffffffff81178e2c>] wb_do_writeback+0x22c/0x280
Feb  7 15:07:09 RX300S6 kernel: [<ffffffff81178f32>] bdi_writeback_thread+0xb2/0x260
Feb  7 15:07:09 RX300S6 kernel: [<ffffffff81178e80>] ? bdi_writeback_thread+0x0/0x260
Feb  7 15:07:09 RX300S6 kernel: [<ffffffff81178e80>] ? bdi_writeback_thread+0x0/0x260
Feb  7 15:07:09 RX300S6 kernel: [<ffffffff81082936>] kthread+0x96/0xa0
Feb  7 15:07:09 RX300S6 kernel: [<ffffffff8100cdc4>] kernel_thread_helper+0x4/0x10
Feb  7 15:07:09 RX300S6 kernel: [<ffffffff810828a0>] ? kthread+0x0/0xa0
Feb  7 15:07:09 RX300S6 kernel: [<ffffffff8100cdc0>] ? kernel_thread_helper+0x0/0x10
---------------------------------------------------------------------

I think the following deadlock problem happened:

              [flush-8:0:1409]              |          [fsfreeze:2104]
--------------------------------------------+--------------------------------
writeback_inodes_wb                         |
 pin_sb_for_writeback                       |
   down_read_trylock(&sb->s_umount)         |
 writeback_sb_inodes                        |thaw_super
   writeback_single_inode                   | down_write(&sb->s_umount)
     do_writepages                          |  # stop until flush-8:0 releases
      ext4_da_writepages                    |  # read lock of sb->s_umount...
       ext4_journal_start_sb                |
        vfs_check_frozen                    |
          wait_event((sb)->s_wait_unfrozen, |
           ((sb)->s_frozen < (level)))      |
            # stop until being waked up by  |
            # fsfreeze...                   |
--------------------------------------------+--------------------------------

Could anyone check this problem?

Thanks,
Masayoshi Mizuma


