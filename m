From: Dmitry Monakhov <dmonakhov@openvz.org>
Subject: Re: WARNING: at fs/ext4/extents.c:4434 ext4_convert_unwritten_extent
Date: Sat, 29 Sep 2012 19:07:54 +0400
Message-ID: <873920c1f9.fsf@openvz.org>
References: <87ipay9i3x.fsf@openvz.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-lb0-f174.google.com ([209.85.217.174]:35253 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755775Ab2I2PH5 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 29 Sep 2012 11:07:57 -0400
Received: by lbon3 with SMTP id n3so2881120lbo.19
        for <linux-ext4@vger.kernel.org>; Sat, 29 Sep 2012 08:07:56 -0700 (PDT)
In-Reply-To: <87ipay9i3x.fsf@openvz.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, 28 Sep 2012 21:23:30 +0400, Dmitry Monakhov <dmonakhov@openvz.org> wrote:
> I've got this on 286'th MOUNT_OPTIONS=-onoload
Ok it is not my regression. I've found the way to reproduce 
this bug on recent ext4.git/dev (b1725167c38ab)
with 269'th xfstests on MOUNT_OPTIONS=-onoload
./check 269 
result in lots of complains, so block reservation code is broken, I try
to localize the issue. 
------------[ cut here ]------------
WARNING: at fs/ext4/inode.c:362 ext4_da_update_reserve_space+0x21d/0x3a0
[ext4]()
Hardware name:         
Modules linked in: ext4 jbd2 cpufreq_ondemand acpi_cpufreq freq_table
mperf coretemp kvm_intel kvm crc32c_intel ghash_clmulni_intel microcode
sg xhci_hcd button ext3 jbd mbcache sd_mod crc_t10dif aesni_intel
ablk_helper cryptd aes_x86_64 aes_generic ahci libahci pata_acpi
ata_generic dm_mirror dm_region_hash dm_log dm_mod
Pid: 2699, comm: fsstress Tainted: G        W    3.6.0-rc1+ #87
Call Trace:
 [<ffffffff81069433>] warn_slowpath_common+0xc3/0xf0
 [<ffffffff8106947a>] warn_slowpath_null+0x1a/0x20
 [<ffffffffa03da30d>] ext4_da_update_reserve_space+0x21d/0x3a0 [ext4]
 [<ffffffffa0413aab>] ? get_reserved_cluster_alloc+0x6b/0x210 [ext4]
 [<ffffffffa041b3f0>] ext4_ext_map_blocks+0xdb0/0x12c0 [ext4]
 [<ffffffffa03da827>] ? ext4_map_blocks+0x397/0x410 [ext4]
 [<ffffffffa03da671>] ext4_map_blocks+0x1e1/0x410 [ext4]
 [<ffffffffa043e889>] mpage_da_map_and_submit+0x191/0x49a [ext4]
 [<ffffffffa040a50f>] ? ext4_journal_start_sb+0x19f/0x250 [ext4]
 [<ffffffffa03e06e3>] ext4_da_writepages+0x523/0x960 [ext4]
 [<ffffffff810c24d4>] ? local_clock+0x104/0x170
 [<ffffffff8119d0f1>] do_writepages+0x51/0x70
 [<ffffffff8118afb5>] __filemap_fdatawrite_range+0x65/0x70
 [<ffffffff8118c0af>] filemap_fdatawrite+0x1f/0x30
 [<ffffffff8118c100>] filemap_write_and_wait+0x40/0xa0
 [<ffffffff81232df0>] ioctl_fiemap+0x1b0/0x250
 [<ffffffff81233933>] do_vfs_ioctl+0x2b3/0x3c0
 [<ffffffff81233ad2>] sys_ioctl+0x92/0xe0
 [<ffffffff8175c8e9>] system_call_fastpath+0x16/0x1b
---[ end trace 2a04ef1ea147f19b ]---
EXT4-fs (dm-1): ext4_da_update_reserve_space: ino 1809, allocated 1 with
only 0 reserved metadata blocks

Or this:
WARNING: at fs/ext4/extents.c:4426
ext4_convert_unwritten_extents+0x121/0x210 [ext4]()
Hardware name:         
Modules linked in: ext4 jbd2 cpufreq_ondemand acpi_cpufreq freq_table
mperf coretemp kvm_intel kvm crc32c_intel ghash_clmulni_intel microcode
sg 
xhci_hcd button ext3 jbd mbcache sd_mod crc_t10dif aesni_intel
ablk_helper cryptd aes_x86_64 aes_generic ahci libahci pata_acpi
ata_generic dm_mi
rror dm_region_hash dm_log dm_mod
Pid: 6, comm: kworker/u:0 Tainted: G        W    3.6.0-rc1+ #87
Call Trace:
 [<ffffffff81069433>] warn_slowpath_common+0xc3/0xf0
 [<ffffffff8106947a>] warn_slowpath_null+0x1a/0x20
 [<ffffffffa041c3c1>] ext4_convert_unwritten_extents+0x121/0x210 [ext4]
 [<ffffffff810f1b69>] ? mark_held_locks+0xf9/0x130
 [<ffffffffa03e24f8>] ? ext4_end_io_work+0x138/0x190 [ext4]
 [<ffffffffa03e229e>] ext4_end_io_nolock+0x3e/0x160 [ext4]
 [<ffffffffa03e2500>] ext4_end_io_work+0x140/0x190 [ext4]
 [<ffffffff810968b9>] process_one_work+0x469/0x770
 [<ffffffff81096793>] ? process_one_work+0x343/0x770
 [<ffffffffa03e23c0>] ? ext4_end_io_nolock+0x160/0x160 [ext4]
 [<ffffffff81097d8c>] worker_thread+0x1cc/0x330
 [<ffffffff81097bc0>] ? manage_workers+0x140/0x140
 [<ffffffff810a1869>] kthread+0xc9/0xe0
 [<ffffffff8175dac4>] kernel_thread_helper+0x4/0x10
 [<ffffffff81750570>] ? retint_restore_args+0x13/0x13
 [<ffffffff810a17a0>] ? __init_kthread_worker+0x70/0x70
 [<ffffffff8175dac0>] ? gs_change+0x13/0x13
---[ end trace 2a04ef1ea147f197 ]---
EXT4-fs (dm-1): ext4_convert_unwritten_extents:4430: inode #14876: block
57: len 4: ext4_ext_map_blocks returned -28
EXT4-fs (dm-1): failed to convert unwritten extents to written
extents -- potential data loss!  (inode 14876, offset 221184, size
28672, error -2
8)


> 
> We assumes that we are protected from ENOSPC during
> ext4_convert_unwritten_extents() by passing EXT4_GET_BLOCKS_PRE_IO
> on submitting AIO which split extent via ext4_split_unwritten_extents()
> But this is not sufficient:
> 
> 
> submit_aio                              Fallocate worker
>  ->ext4_map_blocks(lblk, len)
>    ->ext4_ext_map_blocks( )
>    file: U1---------------------U2|_____EOF
>      ->ext4_split_unwritten_extents
>    file: U1------U1|U2---len----U2|_____EOF
>               
>                                        ->ext4_fallocate(lblk, len+len2)
>                                           ->ext4_map_blocks()
>                                              ->ext4_ext_map_blocks()
>                                                          U2: Grows
>                                            file: U1-------U1|U2----len+len2--U2|__EOF
>   worker_tread
>    ->ext4_end_io_work
>      ->ext4_convert_unwritten_extents
>        ->ext4_ext_handle_uninitialized_extents
>             ## Discover that new split required in order to get:
>             file: U1-------U1|U2----len----U2|U3--len2--U2__EOF
>             This procedure fail with ENOSPC
>        
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
