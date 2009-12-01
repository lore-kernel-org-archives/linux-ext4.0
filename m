From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: ext3-related deadlock: suggestions for problem isolation?
Date: Tue, 01 Dec 2009 09:48:13 -0800
Message-ID: <20091201174813.GA9698@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
Mime-Version: 1.0
Content-Type: text/plain; CHARSET=US-ASCII; delsp=yes; format=flowed
Content-Transfer-Encoding: 7BIT
Cc: linux-ext@vger.kernel.org
To: sct@redhat.com, akpm@linux-foundation.com, adilger@sun.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from sca-es-mail-2.Sun.COM ([192.18.43.133]:37567 "EHLO
	sca-es-mail-2.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753667AbZLAWZq (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 1 Dec 2009 17:25:46 -0500
Received: from fe-sfbay-09.sun.com ([192.18.43.129])
	by sca-es-mail-2.sun.com (8.13.7+Sun/8.12.9) with ESMTP id nB1MPmjq009861
	for <linux-ext4@vger.kernel.org>; Tue, 1 Dec 2009 14:25:48 -0800 (PST)
Received: from conversion-daemon.fe-sfbay-09.sun.com by fe-sfbay-09.sun.com
 (Sun Java(tm) System Messaging Server 7u2-7.04 64bit (built Jul  2 2009))
 id <0KTZ00400VJ8E400@fe-sfbay-09.sun.com> for linux-ext4@vger.kernel.org; Tue,
 01 Dec 2009 14:25:48 -0800 (PST)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

[Note: resending to proper ext4 list]

Hello!

I have been encountering the deadlock situation shown below during
rcutorture/CPU-hotplug testing.  It is quite rare, being triggered less
than once per hundred hours of intensive testing.  Once the deadlock
occurs, CPU-hotplug operations are stalled, but RCU grace periods
proceed normally.  It is of course quite possible that this deadlock is
due to my recent changes, but I thought I should check with you guys
before committing unnatural debugging acts with the ext3 code.

Any suggestions for things to look at when this error occurs, or
debugging patches to help isolate the problem?  Needless to say, any
debugging patches will need to be -very- selective in their output,
given how rare the problem is.  ;-)

							Thanx, Paul

------------------------------------------------------------------------

INFO: task kjournald:1104 blocked for more than 120 seconds.
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this  
message.
Call Trace:
[c000000042d67630] [c000000042d676d0] 0xc000000042d676d0 (unreliable)
[c000000042d67800] [c000000000010d34] .__switch_to+0x160/0x1a8
[c000000042d678a0] [c00000000058e71c] .schedule+0x890/0x9f4
[c000000042d67990] [c00000000058e90c] .io_schedule+0x8c/0x118
[c000000042d67a20] [c00000000016acfc] .sync_buffer+0x68/0x80
[c000000042d67a90] [c00000000058f1b8] .__wait_on_bit+0xa0/0x114
[c000000042d67b40] [c00000000058f2c4] .out_of_line_wait_on_bit+0x98/0xc8
[c000000042d67c40] [c00000000016abe4] .__wait_on_buffer+0x30/0x48
[c000000042d67cc0] [c000000000210a20] .journal_commit_transaction 
+0xdfc/0x163c
[c000000042d67df0] [c00000000021596c] .kjournald+0xe4/0x26c
[c000000042d67ed0] [c00000000008c240] .kthread+0xa8/0xb4
[c000000042d67f90] [c0000000000272b0] .kernel_thread+0x54/0x70
INFO: task flush-8:0:2383 blocked for more than 120 seconds.
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this  
message.
Call Trace:
[c000000040402e50] [c000000040402ef0] 0xc000000040402ef0 (unreliable)
[c000000040403020] [c000000000010d34] .__switch_to+0x160/0x1a8
[c0000000404030c0] [c00000000058e71c] .schedule+0x890/0x9f4
[c0000000404031b0] [c00000000058e90c] .io_schedule+0x8c/0x118
[c000000040403240] [c0000000002c3c9c] .get_request_wait+0x158/0x1ec
[c000000040403330] [c0000000002c98c4] .__make_request+0x518/0x64c
[c0000000404033f0] [c0000000002c1ccc] .generic_make_request+0x39c/0x470
[c0000000404034e0] [c0000000002c9b68] .submit_bio+0x170/0x19c
[c0000000404035b0] [c000000000169634] .submit_bh+0x18c/0x1d8
[c000000040403640] [c00000000016c278] .__block_write_full_page 
+0x308/0x4b8
[c000000040403720] [c000000000171fc0] .blkdev_writepage+0x20/0x38
[c0000000404037a0] [c0000000000fa268] .__writepage+0x3c/0x84
[c000000040403820] [c0000000000fa71c] .write_cache_pages+0x280/0x424
[c0000000404039b0] [c0000000000fa944] .do_writepages+0x4c/0x7c
[c000000040403a20] [c0000000001621e0] .writeback_single_inode+0xdc/0x2b0
[c000000040403ad0] [c000000000162e90] .writeback_inodes_wb+0x400/0x4d8
[c000000040403bc0] [c0000000001630dc] .wb_writeback+0x174/0x218
[c000000040403cd0] [c000000000163460] .wb_do_writeback+0x1f0/0x238
[c000000040403da0] [c0000000001634e0] .bdi_writeback_task+0x38/0xe0
[c000000040403e30] [c00000000010e830] .bdi_start_fn+0xa4/0x130
[c000000040403ed0] [c00000000008c240] .kthread+0xa8/0xb4
[c000000040403f90] [c0000000000272b0] .kernel_thread+0x54/0x70
INFO: task syslogd:2766 blocked for more than 120 seconds.
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this  
message.
Call Trace:
[c0000000426f7470] [c00000000005881c] .cpuacct_update_stats+0x7c/0xa0  
(unreliable)
[c0000000426f7640] [c000000000010d34] .__switch_to+0x160/0x1a8
[c0000000426f76e0] [c00000000058e71c] .schedule+0x890/0x9f4
[c0000000426f77d0] [c000000000214c80] .log_wait_commit+0xcc/0x154
[c0000000426f78a0] [c00000000020d11c] .journal_stop+0x290/0x2fc
[c0000000426f7970] [c0000000001f5840] .ext3_force_commit+0x34/0x48
[c0000000426f79e0] [c0000000001ed3f4] .ext3_write_inode+0x4c/0x68
[c0000000426f7a50] [c000000000162244] .writeback_single_inode 
+0x140/0x2b0
[c0000000426f7b00] [c0000000001623f8] .sync_inode+0x44/0x78
[c0000000426f7ba0] [c0000000001e7f98] .ext3_sync_file+0xc4/0x114
[c0000000426f7c80] [c0000000001674c4] .vfs_fsync_range+0xb4/0x100
[c0000000426f7d30] [c0000000001675b4] .do_fsync+0x38/0x64
[c0000000426f7dc0] [c000000000167620] .SyS_fsync+0x18/0x28
[c0000000426f7e30] [c00000000000852c] syscall_exit+0x0/0x40
INFO: task updatedb:13950 blocked for more than 120 seconds.
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this  
message.
Call Trace:
[c000000042f4f0d0] [c000000042f4f170] 0xc000000042f4f170 (unreliable)
[c000000042f4f2a0] [c000000000010d34] .__switch_to+0x160/0x1a8
[c000000042f4f340] [c00000000058e71c] .schedule+0x890/0x9f4
[c000000042f4f430] [c00000000058e90c] .io_schedule+0x8c/0x118
[c000000042f4f4c0] [c00000000016acfc] .sync_buffer+0x68/0x80
[c000000042f4f530] [c00000000058efb0] .__wait_on_bit_lock+0x94/0x134
[c000000042f4f5e0] [c00000000058f0e8] .out_of_line_wait_on_bit_lock 
+0x98/0xc8
[c000000042f4f6e0] [c00000000016b06c] .__lock_buffer+0x48/0x60
[c000000042f4f760] [c00000000020d220] .do_get_write_access+0x98/0x660
[c000000042f4f860] [c00000000020d820] .journal_get_write_access 
+0x38/0x64
[c000000042f4f8f0] [c0000000001fb1d8] .__ext3_journal_get_write_access 
+0x38/0x84
[c000000042f4f990] [c0000000001ea42c] .ext3_reserve_inode_write 
+0x64/0xc4
[c000000042f4fa30] [c0000000001ea4b8] .ext3_mark_inode_dirty+0x2c/0x68
[c000000042f4faf0] [c0000000001ee2f4] .ext3_dirty_inode+0x80/0xb0
[c000000042f4fb80] [c000000000163714] .__mark_inode_dirty+0x58/0x188
[c000000042f4fc10] [c00000000015794c] .touch_atime+0x144/0x18c
[c000000042f4fcc0] [c00000000014fba8] .vfs_readdir+0xc8/0x104
[c000000042f4fd70] [c00000000014fc6c] .SyS_getdents64+0x88/0x108
[c000000042f4fe30] [c00000000000852c] syscall_exit+0x0/0x40
INFO: task fmt:14153 blocked for more than 120 seconds.
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this  
message.
Call Trace:
[c0000000200b30e0] [c0000000200b3180] 0xc0000000200b3180 (unreliable)
[c0000000200b32b0] [c000000000010d34] .__switch_to+0x160/0x1a8
[c0000000200b3350] [c00000000058e71c] .schedule+0x890/0x9f4
[c0000000200b3440] [c00000000020d4a4] .do_get_write_access+0x31c/0x660
[c0000000200b3540] [c00000000020d820] .journal_get_write_access 
+0x38/0x64
[c0000000200b35d0] [c0000000001fb1d8] .__ext3_journal_get_write_access 
+0x38/0x84
[c0000000200b3670] [c0000000001ea42c] .ext3_reserve_inode_write 
+0x64/0xc4
[c0000000200b3710] [c0000000001ea4b8] .ext3_mark_inode_dirty+0x2c/0x68
[c0000000200b37d0] [c0000000001ee2f4] .ext3_dirty_inode+0x80/0xb0
[c0000000200b3860] [c000000000163714] .__mark_inode_dirty+0x58/0x188
[c0000000200b38f0] [c0000000001576d4] .file_update_time+0x130/0x174
[c0000000200b39b0] [c0000000000f2638] .__generic_file_aio_write+0x29c/ 
0x3ec
[c0000000200b3ab0] [c0000000000f2808] .generic_file_aio_write+0x80/0xf8
[c0000000200b3b60] [c00000000013d398] .do_sync_write+0xc4/0x124
[c0000000200b3cf0] [c00000000013e088] .vfs_write+0xd8/0x1dc
[c0000000200b3d90] [c00000000013e28c] .SyS_write+0x50/0x90
[c0000000200b3e30] [c00000000000852c] syscall_exit+0x0/0x40
