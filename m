Return-Path: <SRS0=Ur5Y=RR=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=MAILING_LIST_MULTI,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 353D0C43381
	for <linux-ext4@archiver.kernel.org>; Thu, 14 Mar 2019 19:18:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 006172082F
	for <linux-ext4@archiver.kernel.org>; Thu, 14 Mar 2019 19:18:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727111AbfCNTSH convert rfc822-to-8bit (ORCPT
        <rfc822;linux-ext4@archiver.kernel.org>);
        Thu, 14 Mar 2019 15:18:07 -0400
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:37724 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726848AbfCNTSH (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>);
        Thu, 14 Mar 2019 15:18:07 -0400
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id 5B18F2A6CF
        for <linux-ext4@vger.kernel.org>; Thu, 14 Mar 2019 19:18:06 +0000 (UTC)
Received: by mail.wl.linuxfoundation.org (Postfix, from userid 486)
        id 4FCFA2A6D4; Thu, 14 Mar 2019 19:18:06 +0000 (UTC)
From:   bugzilla-daemon@bugzilla.kernel.org
To:     linux-ext4@vger.kernel.org
Subject: [Bug 202925] New: BUG: failure at
 fs/buffer.c:195/__find_get_block_slow()!
Date:   Thu, 14 Mar 2019 19:18:04 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: new
X-Bugzilla-Watch-Reason: AssignedTo fs_ext4@kernel-bugs.osdl.org
X-Bugzilla-Product: File System
X-Bugzilla-Component: ext4
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: jungyeon@gatech.edu
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: fs_ext4@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: bug_id short_desc product version
 cf_kernel_version rep_platform op_sys cf_tree bug_status bug_severity
 priority component assigned_to reporter cf_regression attachments.created
Message-ID: <bug-202925-13602@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=202925

            Bug ID: 202925
           Summary: BUG: failure at
                    fs/buffer.c:195/__find_get_block_slow()!
           Product: File System
           Version: 2.5
    Kernel Version: 5.0.0
          Hardware: All
                OS: Linux
              Tree: Mainline
            Status: NEW
          Severity: normal
          Priority: P1
         Component: ext4
          Assignee: fs_ext4@kernel-bugs.osdl.org
          Reporter: jungyeon@gatech.edu
        Regression: No

Created attachment 281829
  --> https://bugzilla.kernel.org/attachment.cgi?id=281829&action=edit
image&program

- Overview
After mounting crafted image and running the attached program, I got this
segmentation fault while running attached program.
I also tried to reproduce on vm, but it only failed on lkl.

LKL is Linux Kernel Library. poc_03.c is a program that calls lists of system
calls in userspace and the craft image is a potentially faulty image to test
error cases.
https://gts3.org/~jungyeon/ext4-combined
at the link above, I uploaded the executable file required for this test.

- Produces
./lkl/tools/lkl/ext4-combined -t ext4 -i tmp.img -p poc_03.c.raw -v
(poc_03.c shows it's internal programs)

- Messages
[    0.000000] Linux version 5.0.0+ (jungyeon@copper) (gcc version 7.3.0
(Ubuntu 7.3.0-27ubuntu1~18.04)) #1 Wed Mar 13 19:57:50 EDT 2019
[    0.000000] memblock address range: 0x7fffe4000000 - 0x7fffebfff000
[    0.000000] Built 1 zonelists, mobility grouping on.  Total pages: 32319
[    0.000000] Kernel command line: mem=128M virtio_mmio.device=316@0x1000000:1
[    0.000000] Dentry cache hash table entries: 16384 (order: 5, 131072 bytes)
[    0.000000] Inode-cache hash table entries: 8192 (order: 4, 65536 bytes)
[    0.000000] Memory available: 129044k/131068k RAM
[    0.000000] SLUB: HWalign=32, Order=0-3, MinObjects=0, CPUs=1, Nodes=1
[    0.000000] NR_IRQS: 4096
[    0.000000] lkl: irqs initialized
[    0.000000] clocksource: lkl: mask: 0xffffffffffffffff max_cycles:
0x1cd42e4dffb, max_idle_ns: 881590591483 ns
[    0.000001] lkl: time and timers initialized (irq2)
[    0.000009] pid_max: default: 4096 minimum: 301
[    0.000073] Mount-cache hash table entries: 512 (order: 0, 4096 bytes)
[    0.000086] Mountpoint-cache hash table entries: 512 (order: 0, 4096 bytes)
[    0.002805] printk: console [lkl_console0] enabled
[    0.002839] clocksource: jiffies: mask: 0xffffffff max_cycles: 0xffffffff,
max_idle_ns: 19112604462750000 ns
[    0.004581] clocksource: Switched to clocksource lkl
[    0.004960] virtio-mmio: Registering device virtio-mmio.0 at
0x1000000-0x100013b, IRQ 1.
[    0.005453] workingset: timestamp_bits=62 max_order=15 bucket_order=0
[    0.015235] virtio-mmio virtio-mmio.0: Failed to enable 64-bit or 32-bit
DMA.  Trying to continue, but this might not work.
[    0.015492] virtio_blk virtio0: [vda] 32768 512-byte logical blocks (16.8
MB/16.0 MiB)
[    0.016404] random: get_random_bytes called from .LC28+0x21/0x38 with
crng_init=0
[    0.016827] Warning: unable to open an initial console.
[    0.016877] This architecture does not have kernel memory protection.
[    0.016883] Run /init as init process
[    0.019880] EXT4-fs warning (device vda): ext4_clear_journal_err:4988:
Filesystem error recorded from previous mount: Readonly filesystem
[    0.019894] EXT4-fs warning (device vda): ext4_clear_journal_err:4989:
Marking fs in need of filesystem check.
[    0.020276] EXT4-fs (vda): warning: mounting fs with errors, running e2fsck
is recommended
[    0.020464] EXT4-fs (vda): mounted filesystem with writeback data mode.
Opts: errors=remount-ro
[    0.034246] BUG: failure at fs/buffer.c:195/__find_get_block_slow()!
[    0.034264] Kernel panic - not syncing: BUG!
[    0.034268] Call Trace:
[    0.034275] (____ptrval____):  [<55555559bc94>] .LC81+0x5f/0xfb
[    0.034282] (____ptrval____):  [<5555555c6025>] major_names+0x75/0x80
[    0.034289] (____ptrval____):  [<5555555978f4>] .LC11+0x14/0x20
[    0.034296] (____ptrval____):  [<55555575e71f>]
ext4_mark_iloc_dirty+0x126f/0x1640
[    0.034303] (____ptrval____):  [<5555556a91c5>] __find_get_block+0xda5/0xdb0
[    0.034307] (____ptrval____):  [<5555555978f4>] .LC11+0x14/0x20
[    0.034314] (____ptrval____):  [<5555557f876b>]
jbd2_journal_cancel_revoke+0x2cb/0x440
[    0.034319] (____ptrval____):  [<5555557e80b9>]
do_get_write_access+0x7f9/0xc20
[    0.034324] (____ptrval____):  [<5555557e782e>]
jbd2_journal_get_write_access+0x1fe/0x290
[    0.034331] (____ptrval____):  [<55555570d542>]
__ext4_journal_get_write_access+0xa2/0x130
[    0.034341] (____ptrval____):  [<55555573f72e>] ext4_free_data+0x9e/0x450
[    0.034358] (____ptrval____):  [<555555740524>]
ext4_free_branches+0x654/0x6f0
[    0.034370] (____ptrval____):  [<5555557400ec>]
ext4_free_branches+0x21c/0x6f0
[    0.034381] (____ptrval____):  [<55555573f4bf>]
ext4_ind_truncate+0x8ff/0xad0
[    0.034391] (____ptrval____):  [<55555575e71f>]
ext4_mark_iloc_dirty+0x126f/0x1640
[    0.034402] (____ptrval____):  [<5555555978f4>] .LC11+0x14/0x20
[    0.034414] (____ptrval____):  [<5555558801b7>]
__down_write_common+0x177/0x290
[    0.034426] (____ptrval____):  [<5555555bafd4>] ___might_sleep+0x44/0x150
[    0.034436] (____ptrval____):  [<55555574ed4e>] ext4_truncate+0x93e/0xaf0
[    0.034445] (____ptrval____):  [<55555574dd7f>] ext4_evict_inode+0xbdf/0xe50
[    0.034456] (____ptrval____):  [<555555667e2c>] evict+0x20c/0x800
[    0.034464] (____ptrval____):  [<5555556621bb>] iput+0x53b/0x800
[    0.034473] (____ptrval____):  [<55555565bf16>]
dentry_unlink_inode+0x276/0x2b0
[    0.034483] (____ptrval____):  [<555555654c42>] __dentry_kill+0x3a2/0x5b0
[    0.034495] (____ptrval____):  [<555555653b7b>] dput+0x34b/0x7c0
[    0.034505] (____ptrval____):  [<55555561669d>] __fput+0x2bd/0x490
[    0.034513] (____ptrval____):  [<555555616289>] ____fput+0x39/0x40
[    0.034525] (____ptrval____):  [<5555555b24ca>] task_work_run+0xba/0xf0
[    0.034534] (____ptrval____):  [<55555559800f>] .LC2+0x3f/0x40
[    0.034543] 
[    0.034551] ---[ end Kernel panic - not syncing: BUG! ]---


- Primitive reasons
when __find_get_block_slow is call, the bdev is NULL.
I temporarily put BUG_ON to get stack trace.

 192 static struct buffer_head *
 193 __find_get_block_slow(struct block_device *bdev, sector_t block)
 194 {
 195     BUG_ON(bdev == NULL);
 196     struct inode *bd_inode = bdev->bd_inode;
 197     struct address_space *bd_mapping = bd_inode->i_mapping;
 198     struct buffer_head *ret = NULL;
 199     pgoff_t index;
 200     struct buffer_head *bh;
 201     struct buffer_head *head;
 202     struct page *page;
 203     int all_mapped = 1;
 204     static DEFINE_RATELIMIT_STATE(last_warned, HZ, 1);
 205 
 206     index = block >> (PAGE_SHIFT - bd_inode->i_blkbits);
 207     page = find_get_page_flags(bd_mapping, index, FGP_ACCESSED);
 208     if (!page)
 209         goto out;

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
