From: Jon Derrick <jonathan.derrick@intel.com>
Subject: Re: BUG: hot removal during writes on ext4 formatted nvme device
Date: Thu, 18 May 2017 23:53:17 +0000 (UTC)
Message-ID: <6a4a158c-11fe-e8e9-9d2d-9217704aa79b@intel.com>
References: <037dd98d-595e-f96b-6241-2474bd2c3e8f@intel.com>
 <87vaoyi6nm.fsf@dmlp.sw.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org, linux-nvme@lists.infradead.org,
        Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@lst.de>,
        sagi@grimberg.me, Keith Busch <keith.busch@intel.com>
To: Dmitry Monakhov <dmonlist@gmail.com>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        Ming Lei <ming.lei@redhat.com>
Return-path: <linux-block-owner@vger.kernel.org>
Date: Tue, 23 May 2017 07:03:43 -0600
In-Reply-To: <87vaoyi6nm.fsf@dmlp.sw.ru>
Content-Language: en-US
Sender: linux-block-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Hi Ming, Dmitry,

Ming,
> Also the following patch fixes one issue in remove path.
>
> 	http://marc.info/?l=linux-block&m=149498450028434&w=2
>
> So could you test v4.12-rc1(d3cfb2a0 is merged) with the above patch?

Thanks for the suggestion but it still resulted in the same BUG.




Dmitry,
> This is common bug which happens if device dies under our feet.
> bh becomes invalidated and unmapped.
> My proposed fix is here:
> https://www.spinics.net/lists/kernel/msg2483231.html
> Full patchset was not accepted, I'll update it and try again soon.

I was able to apply 1-4 on 4.12-rc1 but 5/5 couldnt apply clean. It
looks like an optimization however so I continued with 1-4.

It did improve the reliability a bit. I was able to do my test several
times before I hit a different bug [1]. I agree with Christoph's reply
to 1 that it seems like a fix that covers up a deeper issue, but it did
help here...


[1]:
[  331.467807] blk_update_request: I/O error, dev nvme5n1, sector 4978432
[  331.481582]
==================================================================
[  331.481596] BUG: KASAN: use-after-free in
swiotlb_unmap_sg_attrs+0x39/0x80
[  331.481601] Read of size 4 at addr ffff88025e28a398 by task
kworker/0:1/174
[  331.481603]
[  331.481610] CPU: 0 PID: 174 Comm: kworker/0:1 Not tainted
4.12.0-rc1-hr+ #68
[  331.481614] Hardware name: Intel Corporation PURLEY/PURLEY, BIOS
PLYDCRB1.86B.0121.R04.1702012027 02/01/2017
[  331.481624] Workqueue: pciehp-0 pciehp_power_thread
[  331.481627] Call Trace:
[  331.481636]  dump_stack+0x63/0x8d
[  331.481645]  print_address_description+0x7b/0x290
[  331.481651]  kasan_report+0x138/0x240
[  331.481657]  ? swiotlb_unmap_sg_attrs+0x39/0x80
[  331.481663]  ? swiotlb_unmap_sg_attrs+0x39/0x80
[  331.481673]  __asan_load4+0x61/0x80
[  331.481678]  swiotlb_unmap_sg_attrs+0x39/0x80
[  331.481686]  vmd_unmap_sg+0x9b/0xc0
[  331.481698]  nvme_pci_complete_rq+0x18b/0x250 [nvme]
[  331.481707]  __blk_mq_complete_request+0x13b/0x290
[  331.481713]  blk_mq_complete_request+0x16/0x20
[  331.481731]  nvme_cancel_request+0x7e/0xe0 [nvme_core]
[  331.481746]  ? nvme_complete_rq+0x170/0x170 [nvme_core]
[  331.481752]  bt_tags_iter+0x88/0xa0
[  331.481759]  blk_mq_tagset_busy_iter+0x18b/0x390
[  331.481774]  ? nvme_complete_rq+0x170/0x170 [nvme_core]
[  331.481790]  ? nvme_complete_rq+0x170/0x170 [nvme_core]
[  331.481799]  nvme_dev_disable+0x1c7/0x590 [nvme]
[  331.481811]  nvme_remove+0x146/0x150 [nvme]
[  331.481817]  pci_device_remove+0x61/0x110
[  331.481827]  device_release_driver_internal+0x1b6/0x2c0
[  331.481834]  device_release_driver+0x12/0x20
[  331.481841]  pci_stop_bus_device+0xc8/0xf0
[  331.481847]  pci_stop_and_remove_bus_device+0x12/0x20
[  331.481854]  pciehp_unconfigure_device+0xc3/0x2a0
[  331.481859]  ? kasan_slab_free+0x92/0xc0
[  331.481866]  pciehp_disable_slot+0x78/0x130
[  331.481872]  pciehp_power_thread+0xab/0xf0
[  331.481880]  process_one_work+0x297/0x5e0
[  331.481886]  worker_thread+0x89/0x6a0
[  331.481894]  kthread+0x18c/0x1e0
[  331.481899]  ? rescuer_thread+0x5f0/0x5f0
[  331.481905]  ? kthread_park+0xa0/0xa0
[  331.481913]  ret_from_fork+0x2c/0x40
[  331.481916]
[  331.481919] Allocated by task 762:
[  331.481927]  save_stack_trace+0x1b/0x20
[  331.481933]  save_stack+0x46/0xd0
[  331.481937]  kasan_kmalloc+0x93/0xc0
[  331.481942]  __kmalloc+0x12e/0x230
[  331.481950]  nvme_queue_rq+0x1db/0xdca [nvme]
[  331.481956]  __blk_mq_try_issue_directly+0x106/0x170
[  331.481961]  blk_mq_try_issue_directly+0x76/0x80
[  331.481966]  blk_mq_make_request+0x61a/0xa90
[  331.481972]  generic_make_request+0x1b5/0x430
[  331.481976]  submit_bio+0xb9/0x240
[  331.482092]  ext4_io_submit+0x6e/0x90 [ext4]
[  331.482169]  ext4_writepages+0x98e/0x1450 [ext4]
[  331.482177]  do_writepages+0x34/0xb0
[  331.482184]  __writeback_single_inode+0x6a/0x490
[  331.482189]  writeback_sb_inodes+0x271/0x650
[  331.482194]  __writeback_inodes_wb+0xac/0x100
[  331.482199]  wb_writeback+0x40c/0x430
[  331.482203]  wb_workfn+0x2b1/0x590
[  331.482208]  process_one_work+0x297/0x5e0
[  331.482212]  worker_thread+0x89/0x6a0
[  331.482217]  kthread+0x18c/0x1e0
[  331.482221]  ret_from_fork+0x2c/0x40
[  331.482222]
[  331.482224] Freed by task 762:
[  331.482229]  save_stack_trace+0x1b/0x20
[  331.482234]  save_stack+0x46/0xd0
[  331.482238]  kasan_slab_free+0x7c/0xc0
[  331.482244]  kfree+0x97/0x190
[  331.482252]  nvme_free_iod+0x163/0x1c0 [nvme]
[  331.482260]  nvme_queue_rq+0x406/0xdca [nvme]
[  331.482265]  __blk_mq_try_issue_directly+0x106/0x170
[  331.482270]  blk_mq_try_issue_directly+0x76/0x80
[  331.482275]  blk_mq_make_request+0x61a/0xa90
[  331.482280]  generic_make_request+0x1b5/0x430
[  331.482284]  submit_bio+0xb9/0x240
[  331.482363]  ext4_io_submit+0x6e/0x90 [ext4]
[  331.482439]  ext4_writepages+0x98e/0x1450 [ext4]
[  331.482444]  do_writepages+0x34/0xb0
[  331.482449]  __writeback_single_inode+0x6a/0x490
[  331.482454]  writeback_sb_inodes+0x271/0x650
[  331.482459]  __writeback_inodes_wb+0xac/0x100
[  331.482464]  wb_writeback+0x40c/0x430
[  331.482469]  wb_workfn+0x2b1/0x590
[  331.482473]  process_one_work+0x297/0x5e0
[  331.482477]  worker_thread+0x89/0x6a0
[  331.482482]  kthread+0x18c/0x1e0
[  331.482486]  ret_from_fork+0x2c/0x40
[  331.482487]
[  331.482492] The buggy address belongs to the object at ffff88025e28a380
[  331.482492]  which belongs to the cache kmalloc-96 of size 96
[  331.482497] The buggy address is located 24 bytes inside of
[  331.482497]  96-byte region [ffff88025e28a380, ffff88025e28a3e0)
[  331.482499] The buggy address belongs to the page:
[  331.482504] page:ffffea000978a280 count:1 mapcount:0 mapping:
 (null) index:0x0 compound_mapcount: 0
[  331.482512] flags: 0x2fffff80008100(slab|head)
[  331.482520] raw: 002fffff80008100 0000000000000000 0000000000000000
0000000180400040
[  331.482527] raw: dead000000000100 dead000000000200 ffff880275817540
0000000000000000
[  331.482528] page dumped because: kasan: bad access detected
[  331.482529]
[  331.482531] Memory state around the buggy address:
[  331.482535]  ffff88025e28a280: fb fb fb fb fb fb fb fb fb fb fb fb fc
fc fc fc
[  331.482540]  ffff88025e28a300: fb fb fb fb fb fb fb fb fb fb fb fb fc
fc fc fc
[  331.482544] >ffff88025e28a380: fb fb fb fb fb fb fb fb fb fb fb fb fc
fc fc fc
[  331.482546]                             ^
[  331.482550]  ffff88025e28a400: fc fc fc fc fc fc fc fc fc fc fc fc fc
fc fc fc
[  331.482554]  ffff88025e28a480: fc fc fc fc fc fc fc fc fc fc fc fc fc
fc fc fc
[  331.482556]
==================================================================
