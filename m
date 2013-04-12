From: Dmitry Monakhov <dmonakhov@openvz.org>
Subject: ext4 metadata reservation warnings
Date: Fri, 12 Apr 2013 20:38:02 +0400
Message-ID: <87wqs7bt79.fsf@openvz.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: lczerner@redhat.com, ext4 development <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-lb0-f182.google.com ([209.85.217.182]:59000 "EHLO
	mail-lb0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752441Ab3DLQiJ (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 12 Apr 2013 12:38:09 -0400
Received: by mail-lb0-f182.google.com with SMTP id z13so2833664lbh.27
        for <linux-ext4@vger.kernel.org>; Fri, 12 Apr 2013 09:38:06 -0700 (PDT)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


I use 9d35f846aa9 and have  a lot of warning, Lukas is it yours?
I use default mount options, just run compilebench on small fs.
EXT4-fs warning (device dm-3): ext4_da_update_reserve_space:360: ino
434401, allocated 2 with only 1 reserved metadata blocks (releasing 19
blocks with reserved 19 data blocks)
------------[ cut here ]------------
WARNING: at fs/ext4/inode.c:361
ext4_da_update_reserve_space+0x208/0x390()
Hardware name:         
Modules linked in: cpufreq_ondemand acpi_cpufreq freq_table mperf
coretemp kvm_intel kvm crc32c_intel ghash_clmulni_intel microcode sg
xhci_hcd button sd_mod crc_t10dif aesni_intel ablk_helper cryptd lrw
aes_x86_64 xts gf128mul ahci libahci pata_acpi ata_generic dm_mirror
dm_region_hash dm_log dm_mod
Pid: 763, comm: flush-253:3 Tainted: G        W    3.9.0-rc5+ #16
Call Trace:
 [<ffffffff810710c3>] warn_slowpath_common+0xc3/0xf0
 [<ffffffff8107110a>] warn_slowpath_null+0x1a/0x20
 [<ffffffff81337d98>] ext4_da_update_reserve_space+0x208/0x390
 [<ffffffff8133a651>] ? ext4_map_blocks+0x5b1/0x620
 [<ffffffff8133a44b>] ext4_map_blocks+0x3ab/0x620
 [<ffffffff8133c87f>] mpage_da_map_and_submit+0x11f/0x3d0
 [<ffffffff8133da87>] ? ext4_da_writepages+0x3f7/0x890
 [<ffffffff8133db55>] ext4_da_writepages+0x4c5/0x890
 [<ffffffff8100f8b7>] ? native_sched_clock+0x97/0xe0
 [<ffffffff811b5721>] do_writepages+0x51/0x70
 [<ffffffff8128164b>] __writeback_single_inode+0x12b/0x300
 [<ffffffff8148c04a>] ? do_raw_spin_unlock+0x1ba/0x1d0
 [<ffffffff81283066>] writeback_sb_inodes+0x356/0x520
 [<ffffffff818fd8fb>] ? _raw_spin_unlock+0x2b/0x50
 [<ffffffff812832df>] __writeback_inodes_wb+0xaf/0x160
 [<ffffffff81283a1b>] wb_writeback+0x28b/0x580
 [<ffffffff81283fdf>] wb_do_writeback+0x2cf/0x3c0
 [<ffffffff8108bc10>] ? lock_timer_base+0xf0/0xf0
 [<ffffffff81284223>] bdi_writeback_thread+0x153/0x440
 [<ffffffff812840d0>] ? wb_do_writeback+0x3c0/0x3c0
 [<ffffffff810ae6b0>] kthread+0x100/0x110
 [<ffffffff810ae5b0>] ? __init_kthread_worker+0x70/0x70
 [<ffffffff8190aaac>] ret_from_fork+0x7c/0xb0
 [<ffffffff810ae5b0>] ? __init_kthread_worker+0x70/0x70
---[ end trace ae875167efd67102 ]---
EXT4-fs warning (device dm-3): ext4_da_update_reserve_space:360: ino
213140, allocated 1 with only 0 reserved metadata blocks (releasing 42
blocks with reserved 42 data blocks)
------------[ cut here ]------------
