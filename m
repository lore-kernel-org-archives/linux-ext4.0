From: thomas <thomas@nowhere.at>
Subject: PROBLEM: cfq-iosched.c: constant sync io starves other filesystem
 operations forever
Date: Fri, 19 Feb 2016 16:02:26 +0100 (CET)
Message-ID: <Pine.LNX.4.64.1602191547120.21279@strike.wu-wien.ac.at>
Reply-To: thomas <thomas@nowhere.at>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Cc: linux-block@vger.kernel.org, linux-ext4@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from strike.wu-wien.ac.at ([137.208.89.120]:42081 "EHLO
	strike.wu.ac.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1949248AbcBSPJQ (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 19 Feb 2016 10:09:16 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

As long as there are sync requests in a queue, async request are not
dispatched and therefore any filesystem operations which depend on
these dirty data (already in a queue) being written out block forever.

>From Documentation/block/cfq-iosched.txt, I assumed that async io would be
scheduled according to its priority, class and the fifo_expire_* and
slice_* tunables. I was surprised to see that RT async io could be
blocked by BE sync io.

CCed linux-ext4, as I saw ext4 functions in the stack trace. Sorry if 
this has nothing to do with ext4 or jdb2.

Happens on stable linux 4.4.1:
Linux version 4.4.1 (thomas@gtest) (gcc version 4.9.2 (Debian 4.9.2-10) ) #1 SMP Thu Feb 18 15:09:19 CET 2016

Steps to reproduce:
ext4 file system on a block device with cfq scheduler:

1) bash$ fio --name=test --ioengine=libaio --iodepth=8 --rw=randread --bs=8k --direct=1 --size=4G --numjobs=1

2) wait until it has written out the test file, read test can be aborted.

3) bash$ sync

4) bash$ fio --name=test --ioengine=libaio --iodepth=8 --rw=randread --bs=8k --direct=1 --size=4G --numjobs=1

5) while fio read test runs, execute as follows in another terminal in a
      different directory on the same file system or another ext4 filesystem
      on the same block device:
    bash$ time ( echo "data" > a && sleep 60 && echo "data" > b )
      or even
    bash$ time ( echo "data" > a && sleep 60 && mv a b )

Expected duration is about 60 seconds, but it blocks until fio test has
finished.

Depending on the device speed, one may adjust fio's --size and --iodepth
arguments to make sure fio test runs long enough and sync io is always
inflight.

Further information:

All tests were done on an ext4 filesystem (no mdraid or lvm in place).

/dev/sda3 on /mnt/ext4-test type ext4 (rw,relatime,data=ordered)

Setting slice_idle = 0, group_idle = 0 and/or low_latency = 0 or
the devices queue depth had no effect.

I was able to reproduce this on the following kernel versions:
- upstream kernel 4.4.1 amd64
- 3.16.0-4-amd64 (debian jessie)
- 3.2.0-4-amd64 (debian wheezy)

Tests were performed with 7200 sata disks on:
- host with direct attached sata disk (queue_depth 31)
- host with raid10 (sata disks) behind a
   lsi megaraid 9361 controller (queue_depth: 256)
- qemu vm guest with sata disk on the vm host
   a) guest sata driver (queue_depth 31)
   b) guest ide driver (queue_depth 1)

The following patch mitigates the problem, but I am not sure it catches
all cases (different device queue_depths and number of active sync io
queues) and I am aware that blocking and preempting async io was put there
on purpose.

diff -up a/block/cfq-iosched.c b/block/cfq-iosched.c
--- a/block/cfq-iosched.c	2016-01-31 20:29:37.000000000 +0100
+++ b/block/cfq-iosched.c	2016-02-19 11:09:57.640000000 +0100
@@ -3383,12 +3383,6 @@ static bool cfq_may_dispatch(struct cfq_
  	if (cfq_should_idle(cfqd, cfqq) && cfqd->rq_in_flight[BLK_RW_ASYNC])
  		return false;

-	/*
-	 * If this is an async queue and we have sync IO in flight, let it wait
-	 */
-	if (cfqd->rq_in_flight[BLK_RW_SYNC] && !cfq_cfqq_sync(cfqq))
-		return false;
-
  	max_dispatch = max_t(unsigned int, cfqd->cfq_quantum / 2, 1);
  	if (cfq_class_idle(cfqq))
  		max_dispatch = 1;
@@ -3940,13 +3934,6 @@ cfq_should_preempt(struct cfq_data *cfqd
  	if (cfq_class_rt(cfqq) && !cfq_class_rt(new_cfqq))
  		return false;

-	/*
-	 * if the new request is sync, but the currently running queue is
-	 * not, let the sync request have priority.
-	 */
-	if (rq_is_sync(rq) && !cfq_cfqq_sync(cfqq))
-		return true;
-
  	if (new_cfqq->cfqg != cfqq->cfqg)
  		return false;


I think that at least

-- snip --
 		/*
 		 * If there is only one sync queue
 		 * we can ignore async queue here and give the sync
 		 * queue no dispatch limit. The reason is a sync queue can
 		 * preempt async queue, limiting the sync queue doesn't make
 		 * sense. This is useful for aiostress test.
 		 */
 		if (cfq_cfqq_sync(cfqq) && cfqd->busy_sync_queues == 1)
 			promote_sync = true;
-- snip --
(in cfq_may_dispatch)
must be handled differently, too.

thanks
thomas

Relevant dmesg:

bash$ time ( echo "data" > a && sleep 60 && mv a b )
gives me

[  480.606390] INFO: task kworker/u66:0:52 blocked for more than 120 seconds.
[  480.606450]       Not tainted 4.4.1 #1
[  480.606477] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[  480.606527] kworker/u66:0   D ffff88207fc15d40     0    52      2 0x00000000
[  480.606540] Workqueue: writeback wb_workfn (flush-8:0)
[  480.606545]  ffff882038b24e00 ffff8810392cafc0 ffff882038b70000 ffff882038b6f6d8
[  480.606549]  7fffffffffffffff ffff88107ffbba18 ffff882038b6f770 ffffffff81545bf0
[  480.606552]  ffffffff81545471 0000000000000000 ffffffff8154804a 7fffffffffffffff
[  480.606556] Call Trace:
[  480.606567]  [<ffffffff81545bf0>] ? bit_wait_timeout+0x70/0x70
[  480.606570]  [<ffffffff81545471>] ? schedule+0x31/0x80
[  480.606576]  [<ffffffff8154804a>] ? schedule_timeout+0x1fa/0x290
[  480.606587]  [<ffffffffa000b6b3>] ? scsi_dma_map+0x83/0xb0 [scsi_mod]
[  480.606590]  [<ffffffff81545bf0>] ? bit_wait_timeout+0x70/0x70
[  480.606593]  [<ffffffff81544ae4>] ? io_schedule_timeout+0xb4/0x130
[  480.606596]  [<ffffffff81545c07>] ? bit_wait_io+0x17/0x60
[  480.606599]  [<ffffffff81545967>] ? __wait_on_bit_lock+0x47/0xa0
[  480.606601]  [<ffffffff81545bf0>] ? bit_wait_timeout+0x70/0x70
[  480.606604]  [<ffffffff81545a2e>] ? out_of_line_wait_on_bit_lock+0x6e/0x80
[  480.606610]  [<ffffffff810aa6a0>] ? autoremove_wake_function+0x30/0x30
[  480.606618]  [<ffffffffa00b39cf>] ? do_get_write_access+0x1ff/0x460 [jbd2]
[  480.606623]  [<ffffffffa00b3c5e>] ? jbd2_journal_get_write_access+0x2e/0x60 [jbd2]
[  480.606638]  [<ffffffffa0343546>] ? __ext4_journal_get_write_access+0x36/0x70 [ext4]
[  480.606647]  [<ffffffffa0349792>] ? ext4_mb_mark_diskspace_used+0xd2/0x480 [ext4]
[  480.606656]  [<ffffffffa034ad8c>] ? ext4_mb_new_blocks+0x2dc/0x4a0 [ext4]
[  480.606665]  [<ffffffffa0340b35>] ? ext4_ext_map_blocks+0x5b5/0xcb0 [ext4]
[  480.606671]  [<ffffffff8115d28e>] ? release_pages+0xce/0x280
[  480.606675]  [<ffffffff81150001>] ? generic_file_read_iter+0x2f1/0x590
[  480.606682]  [<ffffffffa031472b>] ? ext4_map_blocks+0x11b/0x4d0 [ext4]
[  480.606687]  [<ffffffffa00b2af9>] ? jbd2__journal_start+0xe9/0x1d0 [jbd2]
[  480.606694]  [<ffffffffa0317854>] ? ext4_writepages+0x574/0xc60 [ext4]
[  480.606704]  [<ffffffff812c24a5>] ? cfq_dispatch_requests+0x1c5/0xbf0
[  480.606712]  [<ffffffffa000a10d>] ? scsi_request_fn+0x3d/0x600 [scsi_mod]
[  480.606717]  [<ffffffff811e81fd>] ? __writeback_single_inode+0x3d/0x270
[  480.606721]  [<ffffffff811e88aa>] ? writeback_sb_inodes+0x1fa/0x3c0
[  480.606726]  [<ffffffff811e8af1>] ? __writeback_inodes_wb+0x81/0xb0
[  480.606730]  [<ffffffff811e8dbe>] ? wb_writeback+0x1fe/0x270
[  480.606734]  [<ffffffff811e9523>] ? wb_workfn+0x273/0x340
[  480.606740]  [<ffffffff8108593c>] ? process_one_work+0x14c/0x3d0
[  480.606743]  [<ffffffff810862d5>] ? worker_thread+0x65/0x460
[  480.606745]  [<ffffffff81086270>] ? rescuer_thread+0x2f0/0x2f0
[  480.606753]  [<ffffffff8108b2ef>] ? kthread+0xcf/0xf0
[  480.606757]  [<ffffffff8108b220>] ? kthread_park+0x50/0x50
[  480.606763]  [<ffffffff8154920f>] ? ret_from_fork+0x3f/0x70
[  480.606767]  [<ffffffff8108b220>] ? kthread_park+0x50/0x50
[  480.606792] INFO: task jbd2/sda3-8:1672 blocked for more than 120 seconds.
[  480.606837]       Not tainted 4.4.1 #1
[  480.606865] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[  480.606914] jbd2/sda3-8     D ffff88207fdd5d40     0  1672      2 0x00000000
[  480.606918]  ffff88103514a040 ffff88103933b280 ffff881034238000 ffff881034237e60
[  480.606921]  ffff881034237dc8 ffff881034237db0 ffff88103514a040 ffff882035d34b00
[  480.606924]  ffffffff81545471 ffff88103513f8b8 ffffffffa00b509b ffff88103fd75d40
[  480.606928] Call Trace:
[  480.606931]  [<ffffffff81545471>] ? schedule+0x31/0x80
[  480.606937]  [<ffffffffa00b509b>] ? jbd2_journal_commit_transaction+0x22b/0x17e0 [jbd2]
[  480.606944]  [<ffffffff810a13da>] ? dequeue_task_fair+0x58a/0xff0
[  480.606947]  [<ffffffff810aa670>] ? wait_woken+0x90/0x90
[  480.606953]  [<ffffffffa00b9d3d>] ? kjournald2+0xcd/0x250 [jbd2]
[  480.606956]  [<ffffffff810aa670>] ? wait_woken+0x90/0x90
[  480.606960]  [<ffffffffa00b9c70>] ? commit_timeout+0x10/0x10 [jbd2]
[  480.606964]  [<ffffffff8108b2ef>] ? kthread+0xcf/0xf0
[  480.606968]  [<ffffffff8108b220>] ? kthread_park+0x50/0x50
[  480.606972]  [<ffffffff8154920f>] ? ret_from_fork+0x3f/0x70
[  480.606976]  [<ffffffff8108b220>] ? kthread_park+0x50/0x50
[  480.606979] INFO: task mv:1695 blocked for more than 120 seconds.
[  480.607018]       Not tainted 4.4.1 #1
[  480.607046] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[  480.607095] mv              D ffff88207fcf5d40     0  1695   1686 0x00000000
[  480.607098]  ffff882035402240 ffff8810392e6340 ffff882036640000 ffff88203663fb58
[  480.607101]  7fffffffffffffff ffffffff81545bf0 ffff88203663fbd8 ffff881032e994c0
[  480.607104]  ffffffff81545471 0000000000000000 ffffffff8154804a 7fffffffffffffff
[  480.607108] Call Trace:
[  480.607111]  [<ffffffff81545bf0>] ? bit_wait_timeout+0x70/0x70
[  480.607113]  [<ffffffff81545471>] ? schedule+0x31/0x80
[  480.607116]  [<ffffffff8154804a>] ? schedule_timeout+0x1fa/0x290
[  480.607123]  [<ffffffff812ccc3e>] ? radix_tree_lookup_slot+0xe/0x20
[  480.607128]  [<ffffffff8114e4f9>] ? find_get_entry+0x19/0x90
[  480.607131]  [<ffffffff81545bf0>] ? bit_wait_timeout+0x70/0x70
[  480.607134]  [<ffffffff81544ae4>] ? io_schedule_timeout+0xb4/0x130
[  480.607137]  [<ffffffff81545c07>] ? bit_wait_io+0x17/0x60
[  480.607139]  [<ffffffff815457da>] ? __wait_on_bit+0x5a/0x90
[  480.607145]  [<ffffffff811efe68>] ? __find_get_block+0xe8/0xf0
[  480.607148]  [<ffffffff81545bf0>] ? bit_wait_timeout+0x70/0x70
[  480.607150]  [<ffffffff8154587e>] ? out_of_line_wait_on_bit+0x6e/0x80
[  480.607154]  [<ffffffff810aa6a0>] ? autoremove_wake_function+0x30/0x30
[  480.607163]  [<ffffffffa031ec3f>] ? ext4_find_entry+0x15f/0x600 [ext4]
[  480.607171]  [<ffffffff811dbd54>] ? legitimize_mnt+0x14/0x30
[  480.607178]  [<ffffffffa0321edd>] ? ext4_rename+0xdd/0x850 [ext4]
[  480.607183]  [<ffffffff811c6a85>] ? terminate_walk+0x55/0xb0
[  480.607187]  [<ffffffff811c978a>] ? path_parentat+0x3a/0x80
[  480.607191]  [<ffffffff811ca427>] ? vfs_rename+0x5c7/0x890
[  480.607196]  [<ffffffff811ce779>] ? SyS_rename+0x309/0x3b0
[  480.607200]  [<ffffffff81548e76>] ? entry_SYSCALL_64_fastpath+0x16/0x75


bash$ time ( echo "data" > a && sleep 60 && echo "data" > b )
gives me

[ 2640.571655] INFO: task jbd2/sda3-8:1677 blocked for more than 120 seconds.
[ 2640.571704]       Not tainted 4.4.1 #1
[ 2640.571730] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[ 2640.571779] jbd2/sda3-8     D ffff88207fc35d40     0  1677      2 0x00000000
[ 2640.571785]  ffff881035346180 ffff8810392ca280 ffff88102d7c0000 ffff88102d7bfe60
[ 2640.571789]  ffff88102d7bfdc8 ffff88102d7bfdb0 ffff881035346180 ffff882035d14100
[ 2640.571792]  ffffffff81545471 ffff8810389830b8 ffffffffa01bc09b ffffffff811a07e7
[ 2640.571796] Call Trace:
[ 2640.571802]  [<ffffffff81545471>] ? schedule+0x31/0x80
[ 2640.571811]  [<ffffffffa01bc09b>] ? jbd2_journal_commit_transaction+0x22b/0x17e0 [jbd2]
[ 2640.571814]  [<ffffffff811a07e7>] ? kmem_getpages+0xa7/0x100
[ 2640.571820]  [<ffffffff810a13da>] ? dequeue_task_fair+0x58a/0xff0
[ 2640.571823]  [<ffffffff810aa670>] ? wait_woken+0x90/0x90
[ 2640.571828]  [<ffffffffa01c0d3d>] ? kjournald2+0xcd/0x250 [jbd2]
[ 2640.571831]  [<ffffffff810aa670>] ? wait_woken+0x90/0x90
[ 2640.571835]  [<ffffffffa01c0c70>] ? commit_timeout+0x10/0x10 [jbd2]
[ 2640.571840]  [<ffffffff8108b2ef>] ? kthread+0xcf/0xf0
[ 2640.571844]  [<ffffffff8108b220>] ? kthread_park+0x50/0x50
[ 2640.571850]  [<ffffffff8154920f>] ? ret_from_fork+0x3f/0x70
[ 2640.571855]  [<ffffffff8108b220>] ? kthread_park+0x50/0x50
[ 2640.571860] INFO: task bash:1744 blocked for more than 120 seconds.
[ 2640.571901]       Not tainted 4.4.1 #1
[ 2640.571926] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[ 2640.571975] bash            D ffff88207fdb5d40     0  1744   1662 0x00000000
[ 2640.571979]  ffff88103894a2c0 ffff881039338500 ffff881037f60000 ffff881037f5fa60
[ 2640.571982]  7fffffffffffffff ffff88107ffb1218 ffff881037f5faf8 ffffffff81545bf0
[ 2640.571986]  ffffffff81545471 0000000000000000 ffffffff8154804a 7fffffffffffffff
[ 2640.571989] Call Trace:
[ 2640.571992]  [<ffffffff81545bf0>] ? bit_wait_timeout+0x70/0x70
[ 2640.571995]  [<ffffffff81545471>] ? schedule+0x31/0x80
[ 2640.571998]  [<ffffffff8154804a>] ? schedule_timeout+0x1fa/0x290
[ 2640.572009]  [<ffffffffa02e627f>] ? ext4_ext_put_gap_in_cache+0x9f/0xd0 [ext4]
[ 2640.572012]  [<ffffffff81545bf0>] ? bit_wait_timeout+0x70/0x70
[ 2640.572015]  [<ffffffff81544ae4>] ? io_schedule_timeout+0xb4/0x130
[ 2640.572018]  [<ffffffff81545c07>] ? bit_wait_io+0x17/0x60
[ 2640.572021]  [<ffffffff81545967>] ? __wait_on_bit_lock+0x47/0xa0
[ 2640.572023]  [<ffffffff81545bf0>] ? bit_wait_timeout+0x70/0x70
[ 2640.572026]  [<ffffffff81545a2e>] ? out_of_line_wait_on_bit_lock+0x6e/0x80
[ 2640.572029]  [<ffffffff810aa6a0>] ? autoremove_wake_function+0x30/0x30
[ 2640.572035]  [<ffffffffa01ba9cf>] ? do_get_write_access+0x1ff/0x460 [jbd2]
[ 2640.572039]  [<ffffffffa01bac5e>] ? jbd2_journal_get_write_access+0x2e/0x60 [jbd2]
[ 2640.572049]  [<ffffffffa02ed546>] ? __ext4_journal_get_write_access+0x36/0x70 [ext4]
[ 2640.572057]  [<ffffffffa02bae0b>] ? __ext4_new_inode+0x43b/0x1260 [ext4]
[ 2640.572066]  [<ffffffffa02cb035>] ? ext4_create+0x105/0x180 [ext4]
[ 2640.572071]  [<ffffffff811c8be7>] ? vfs_create+0xb7/0x120
[ 2640.572074]  [<ffffffff811cbaa1>] ? path_openat+0x13b1/0x1510
[ 2640.572082]  [<ffffffff810201ec>] ? copy_fpstate_to_sigframe+0xcc/0x1d0
[ 2640.572090]  [<ffffffff81079c43>] ? recalc_sigpending+0x13/0x50
[ 2640.572094]  [<ffffffff811ccc4e>] ? do_filp_open+0x7e/0xe0
[ 2640.572098]  [<ffffffff811d912c>] ? __alloc_fd+0x3c/0x160
[ 2640.572104]  [<ffffffff811bca3a>] ? do_sys_open+0x12a/0x200
[ 2640.572108]  [<ffffffff81548e76>] ? entry_SYSCALL_64_fastpath+0x16/0x75
