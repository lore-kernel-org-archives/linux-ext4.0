From: Masayoshi MIZUMA <m.mizuma@jp.fujitsu.com>
Subject: [BUG] ext3: cannot unfreeze a filesystem due to a deadlock
Date: Wed, 07 Sep 2011 12:29:30 +0900
Message-ID: <20110907122929.3715.61FB500B@jp.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Cc: linux-fsdevel@vger.kernel.org
To: Jan Kara <jack@suse.cz>, Andrew Morton <akpm@linux-foundation.org>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:49063 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755133Ab1IGD2j (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 6 Sep 2011 23:28:39 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi,

When I checked the freeze feature for ext3 filesystem using fsfreeze
command at 3.1.0-rc4, I think the following deadlock problem happened.

How to reproduce:
 # mkfs -t ext3 /dev/sdd1
 # mount /dev/sdd1 /MNT
 # ./fsstress -d /MNT/tmp -n 10 -p 1000 > /dev/null 2>&1 &
 # fsfreeze -f /MNT
 # fsfreeze -u /MNT

 If this deadlock is reproduced, "fsfreeze -u /MNT" does not return.

The detail of deadlock:
o [flush-8:16:1523]
  wb_do_writeback
   wb_writeback
   ...
     ext3_journalled_writepage
      journal_start
       start_this_handle
       # waiting until journal->j_barrier_count turns 0...
       # j_barrier_count was incremented by journal_lock_updates()
       # via ext3_freeze().

o [fsstress:2673]
  sys_sync
   sync_filesystems
    iterate_supers
     down_read(sb->s_umount)
     sync_one_sb
      __sync_filesystem
       writeback_inodes_sb
        writeback_inodes_sb_nr
         wait_for_completion
          wait_for_common
          # waiting for completion of [flush-8:16:1523]...

o [fsfreeze:2749]
  sys_ioctl
   do_vfs_ioctl
    thaw_super
    # waiting for down_write(sb->s_umount)...
    # [fsfreeze:2673] did down_read(sb->s_umount).

I got the following messages.
---------------------------------------------------------------------
INFO: task flush-8:16:1523 blocked for more than 120 seconds.
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
flush-8:16      D e9ab3d14     0  1523      2 0x00000000
 f0b2b030 00000046 00000002 e9ab3d14 00000001 00000000 f2c8f530 f3287600
 c0ae8600 00000000 00000000 c0ae8600 c0ae8600 c0ae8600 c0ae8600 00000000
 00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000
Call Trace:
 [<c0511dda>] ? kmem_cache_alloc_trace+0x10a/0x110
 [<c047363b>] ? prepare_to_wait+0x6b/0x70
 [<f8418b5d>] ? start_this_handle+0x21d/0x340 [jbd]
 [<c044ffd6>] ? dequeue_task_fair+0x36/0xc0
 [<c0473360>] ? wake_up_bit+0x30/0x30
 [<f8418dfa>] ? journal_start+0x9a/0xd0 [jbd]
 [<f872ceee>] ? ext3_journalled_writepage+0x8e/0x210 [ext3]
 [<c04dffe8>] ? __writepage+0x8/0x30
 [<c04e12a5>] ? write_cache_pages+0x1a5/0x3b0
 [<c04dffe0>] ? set_page_dirty+0x60/0x60
 [<c04e14ee>] ? generic_writepages+0x3e/0x60
 [<c053e9af>] ? writeback_single_inode+0xff/0x300
 [<c053eed1>] ? writeback_sb_inodes+0x171/0x200
 [<c053f128>] ? wb_writeback+0xa8/0x280
 [<c0462dd7>] ? lock_timer_base+0x27/0x50
 [<c04637d1>] ? del_timer_sync+0x21/0x40
 [<c053f37b>] ? wb_do_writeback+0x7b/0x200
 [<c0462e00>] ? lock_timer_base+0x50/0x50
 [<c053f58a>] ? bdi_writeback_thread+0x8a/0x1f0
 [<c053f500>] ? wb_do_writeback+0x200/0x200
 [<c0472fb4>] ? kthread+0x74/0x80
 [<c0472f40>] ? kthread_worker_fn+0x150/0x150
 [<c083803e>] ? kernel_thread_helper+0x6/0x10

INFO: task fsstress:2673 blocked for more than 120 seconds.
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
fsstress        D 00000000     0  2673   2645 0x00000000
 e240d030 00000082 00000000 00000000 00000000 00000000 f7353a30 f32c7600
 c0ae8600 bb9fa3df 00000168 c0ae8600 c0ae8600 c0ae8600 c0ae8600 00000001
 00000000 00000001 c0ae8600 e240d2bc e240ff3c f2cc8e80 c044db1f 00000002
Call Trace:
 [<c044db1f>] ? load_balance+0x7f/0x3e0
 [<c082f65d>] ? schedule_timeout+0x19d/0x270
 [<c082ebce>] ? schedule+0x37e/0x820
 [<c082f38d>] ? wait_for_common+0xdd/0x140
 [<c044e4c0>] ? try_to_wake_up+0x220/0x220
 [<c053e33f>] ? writeback_inodes_sb_nr+0x6f/0x90
 [<c0560510>] ? drop_dquot_ref+0x110/0x110
 [<c05432c2>] ? __sync_filesystem+0x42/0xa0
 [<c05200f8>] ? iterate_supers+0x58/0xa0
 [<c0543320>] ? __sync_filesystem+0xa0/0xa0
 [<c054334e>] ? sys_sync+0x1e/0x50
 [<c0837a9f>] ? sysenter_do_call+0x12/0x28

INFO: task fsfreeze:2749 blocked for more than 120 seconds.
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
fsfreeze        D e952ff14     0  2749   2640 0x00000000
 e9aa3a30 00000086 00000002 e952ff14 ffffff9c 00000000 f2c7f030 f3247600
 c0ae8600 fff90830 000000c0 c0ae8600 c0ae8600 c0ae8600 c0ae8600 ee226218
 00000000 c05ddfd3 e952ff60 bfab77c0 00000008 c05219ee 0000081b 00000000
Call Trace:
 [<c05ddfd3>] ? copy_to_user+0x33/0x110
 [<c05219ee>] ? cp_new_stat64+0xee/0x100
 [<c08308c5>] ? rwsem_down_failed_common+0x85/0xe0
 [<c05dd612>] ? call_rwsem_down_write_failed+0x6/0x8
 [<c083015c>] ? down_write+0x1c/0x20
 [<c052056b>] ? thaw_super+0x1b/0xb0
 [<c045fe1d>] ? ns_capable+0x1d/0x50
 [<c052d407>] ? do_vfs_ioctl+0x257/0x2b0
 [<c052d4ee>] ? sys_ioctl+0x8e/0xa0
 [<c0837a9f>] ? sysenter_do_call+0x12/0x28
---------------------------------------------------------------------

Thanks,
Masayoshi Mizuma


