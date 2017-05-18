From: Dmitry Monakhov <dmonlist@gmail.com>
Subject: Re: BUG: hot removal during writes on ext4 formatted nvme device
Date: Thu, 18 May 2017 17:25:17 +0300
Message-ID: <87vaoyi6nm.fsf@dmlp.sw.ru>
References: <037dd98d-595e-f96b-6241-2474bd2c3e8f@intel.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: linux-ext4@vger.kernel.org, linux-nvme@lists.infradead.org,
        Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@lst.de>,
        sagi@grimberg.me, Keith Busch <keith.busch@intel.com>
To: Jon Derrick <jonathan.derrick@intel.com>,
        "linux-block\@vger.kernel.org" <linux-block@vger.kernel.org>
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <037dd98d-595e-f96b-6241-2474bd2c3e8f@intel.com>
Sender: linux-block-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Jon Derrick <jonathan.derrick@intel.com> writes:

> Hello,
>
> I've encountered a BUG that I've experienced during hot removal on an
> ext4-formatted nvme device undergoing writes. I have been able to verify
> that 4.5, 4.6, 4.10.12, 4.11, and 4.12-rc1 show similar issues (the v4.6
> trace below shows issues with block that have already been fixed). I'm
> using VMD hardware for my hotplug controller so 4.5 is as far back as I
> can go (maybe someone else can verify on non-VMD hardware?).
>
> To reproduce:
> 1) mkfs.ext4 <nvme>
> 2) mount <nvme> <mnt>
> 3) dd if=/dev/zero of=<mnt>/file bs=1M count=10000
> 4) Hot remove the drive while above is writing
>
> From what I can tell, the ext4 sb is trying to be committed in the error
> path. There is supposed to be a check if the device is still alive via
> block_device_ejected(), but my guess is that there is a race between the
> removal/deletion in genhd and this check. I would appreciate any help
> resolving this.
>
> Here are the traces for v4.11 and v4.6:
> v4.11:
> [  217.509412] EXT4-fs (nvme1n1): mounted filesystem with ordered data
> mode. Opts: (null)
> [  300.232914] pciehp 10000:0d:00.0:pcie204: Slot(0-1): Card not present
> [  300.241468] nvme 10000:0f:00.0: PME# disabled
> [  300.907560] nvme1n1: detected capacity change from 400088457216 to 0
> [  300.916727] VFS: busy inodes on changed media or resized disk nvme1n1
> [  300.941164] blk_update_request: I/O error, dev nvme1n1, sector 1048576
> [  300.949889] blk_update_request: I/O error, dev nvme1n1, sector 1048832
> [  300.958608] blk_update_request: I/O error, dev nvme1n1, sector 1049088
> [  300.967327] blk_update_request: I/O error, dev nvme1n1, sector 1049344
> [  300.976044] blk_update_request: I/O error, dev nvme1n1, sector 1049600
> [  300.984762] blk_update_request: I/O error, dev nvme1n1, sector 1049856
> [  300.993469] blk_update_request: I/O error, dev nvme1n1, sector 1050112
> [  301.002563] blk_update_request: I/O error, dev nvme1n1, sector 1050368
> [  301.011228] EXT4-fs warning (device nvme1n1): ext4_end_bio:313: I/O
> error -5 writing to inode 12 (offset 0 size 2101248 starting block 131328)
> [  301.028172] Buffer I/O error on device nvme1n1, logical block 131072
> [  301.036604] Buffer I/O error on device nvme1n1, logical block 131073
> [  301.045047] Buffer I/O error on device nvme1n1, logical block 131074
> [  301.053476] Buffer I/O error on device nvme1n1, logical block 131075
> [  301.061903] Buffer I/O error on device nvme1n1, logical block 131076
> [  301.070332] Buffer I/O error on device nvme1n1, logical block 131077
> [  301.078760] Buffer I/O error on device nvme1n1, logical block 131078
> [  301.122809] Buffer I/O error on device nvme1n1, logical block 131079
> [  301.165647] Buffer I/O error on device nvme1n1, logical block 131080
> [  301.208168] Buffer I/O error on device nvme1n1, logical block 131081
> [  301.250531] blk_update_request: I/O error, dev nvme1n1, sector 1050624
> [  301.292612] blk_update_request: I/O error, dev nvme1n1, sector 1050880
> [  301.333576] EXT4-fs warning (device nvme1n1): ext4_end_bio:313: I/O
> error -5 writing to inode 12 (offset 0 size 3149824 starting block 131584)
> [  301.417798] EXT4-fs warning (device nvme1n1): ext4_end_bio:313: I/O
> error -5 writing to inode 12 (offset 0 size 4198400 starting block 131840)
> [  301.506349] EXT4-fs warning (device nvme1n1): ext4_end_bio:313: I/O
> error -5 writing to inode 12 (offset 0 size 5246976 starting block 132096)
> [  301.600295] EXT4-fs warning (device nvme1n1): ext4_end_bio:313: I/O
> error -5 writing to inode 12 (offset 0 size 6295552 starting block 132352)
> [  301.697846] EXT4-fs warning (device nvme1n1): ext4_end_bio:313: I/O
> error -5 writing to inode 12 (offset 0 size 7344128 starting block 132608)
> [  301.800529] EXT4-fs warning (device nvme1n1): ext4_end_bio:313: I/O
> error -5 writing to inode 12 (offset 0 size 8388608 starting block 132864)
> [  301.908730] EXT4-fs warning (device nvme1n1): ext4_end_bio:313: I/O
> error -5 writing to inode 12 (offset 0 size 8388608 starting block 133120)
> [  302.019761] EXT4-fs warning (device nvme1n1): ext4_end_bio:313: I/O
> error -5 writing to inode 12 (offset 8388608 size 2101248 starting block
> 133376)
> [  302.135856] EXT4-fs warning (device nvme1n1): ext4_end_bio:313: I/O
> error -5 writing to inode 12 (offset 8388608 size 3149824 starting block
> 133632)
> [  302.324114] EXT4-fs error (device nvme1n1):
> ext4_wait_block_bitmap:503: comm kworker/u577:1: Cannot read block
> bitmap - block_group = 5, block_bitmap = 1077
> [  302.457958] Buffer I/O error on dev nvme1n1, logical block 0, lost
> sync page write
> [  302.524509] EXT4-fs (nvme1n1): Delayed block allocation failed for
> inode 12 at logical offset 32768 with max blocks 2048 with error 5
> [  302.659921] EXT4-fs (nvme1n1): This should not happen!! Data will be lost
> [  302.659921]
> [  302.793498] JBD2: Detected IO errors while flushing file data on
> nvme1n1-8
> [  302.797644] EXT4-fs error (device nvme1n1):
> ext4_wait_block_bitmap:503: comm kworker/u577:1: Cannot read block
> bitmap - block_group = 5, block_bitmap = 1077
> [  302.797699] EXT4-fs (nvme1n1): previous I/O error to superblock detected
> [  302.797709] ------------[ cut here ]------------
> [  302.797711] kernel BUG at fs/buffer.c:3103!
This is common bug which happens if device dies under our feet.
bh becomes invalidated and unmapped.
My proposed fix is here:
https://www.spinics.net/lists/kernel/msg2483231.html
Full patchset was not accepted, I'll update it and try again soon.

> [  302.797713] invalid opcode: 0000 [#1] SMP KASAN
> [  302.797714] Modules linked in: ext4 jbd2 mbcache vfat fat iTCO_wdt
> iTCO_vendor_support intel_rapl x86_pkg_temp_thermal intel_powerclamp
> coretemp kvm_intel kvm btrfs xor irqbypass crct10dif_pclmul crc32_pclmul
> ghash_clmulni_intel pcbc aesni_intel crypto_simd cryptd glue_helper
> raid6_pq pcspkr i2c_i801 i2c_core lpc_ich shpchp sg ioatdma dca wmi
> ipmi_si ipmi_devintf ipmi_msghandler nfit libnvdimm acpi_pad tpm_crb
> acpi_power_meter ip_tables xfs libcrc32c sd_mod crc32c_intel e1000e ahci
> nvme ptp libahci nvme_core pps_core libata
> [  302.797762] CPU: 41 PID: 513 Comm: kworker/u577:1 Not tainted 4.11.0 #62
> [  302.797764] Hardware name: Intel Corporation PURLEY/PURLEY, BIOS
> PLYDCRB1.86B.0121.R04.1702012027 02/01/2017
> [  302.797771] Workqueue: writeback wb_workfn (flush-259:2)
> [  302.797774] task: ffff88016d490000 task.stack: ffff88016d498000
> [  302.797778] RIP: 0010:submit_bh_wbc+0x277/0x2a0
> [  302.797780] RSP: 0018:ffff88016d49f248 EFLAGS: 00010246
> [  302.797783] RAX: 0000000000200005 RBX: ffff880155c2a498 RCX:
> ffffffff81384751
> [  302.797785] RDX: dffffc0000000000 RSI: 0000000000020000 RDI:
> ffff880155c2a498
> [  302.797787] RBP: ffff88016d49f290 R08: 0000000000000000 R09:
> ffffed00476881b7
> [  302.797788] R10: ffff88016d49f3e0 R11: ffffed00476881b6 R12:
> 0000000000020000
> [  302.797790] R13: 0000000000020000 R14: 0000000000000001 R15:
> 0000000000000000
> [  302.797792] FS:  0000000000000000(0000) GS:ffff88017a440000(0000)
> knlGS:0000000000000000
> [  302.797794] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [  302.797796] CR2: 00007faa8d9ae140 CR3: 000000000200d000 CR4:
> 00000000007406e0
> [  302.797798] DR0: 0000000000000000 DR1: 0000000000000000 DR2:
> 0000000000000000
> [  302.797799] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7:
> 0000000000000400
> [  302.797800] PKRU: 55555554
> [  302.797801] Call Trace:
> [  302.797806]  ? __wake_up_bit+0x45/0x90
> [  302.797810]  __sync_dirty_buffer+0x84/0x130
> [  302.797851]  ext4_commit_super+0x3e8/0x4f0 [ext4]
> [  302.797886]  __ext4_error+0xa3/0x140 [ext4]
> [  302.797889]  ? autoremove_wake_function+0xa0/0xa0
> [  302.797920]  ext4_wait_block_bitmap+0xbd/0xe0 [ext4]
> [  302.797956]  ext4_mb_init_cache+0x35e/0xb10 [ext4]
> [  302.797992]  ext4_mb_init_group+0x1fc/0x330 [ext4]
> [  302.798028]  ext4_mb_good_group+0x274/0x280 [ext4]
> [  302.798065]  ext4_mb_regular_allocator+0x4d0/0x750 [ext4]
> [  302.798101]  ext4_mb_new_blocks+0x93f/0x1640 [ext4]
> [  302.798105]  ? kasan_kmalloc+0x93/0xc0
> [  302.798108]  ? __kmalloc+0x12e/0x230
> [  302.798142]  ? ext4_find_extent+0x3cf/0x450 [ext4]
> [  302.798178]  ? ext4_ext_search_right+0x108/0x490 [ext4]
> [  302.798213]  ext4_ext_map_blocks+0x1128/0x15c0 [ext4]
> [  302.798245]  ext4_map_blocks+0x1b7/0xa20 [ext4]
> [  302.798277]  ext4_writepages+0xa71/0x13e0 [ext4]
> [  302.798282]  do_writepages+0x4b/0x70
> [  302.798284]  ? do_writepages+0x4b/0x70
> [  302.798288]  __writeback_single_inode+0x6a/0x4a0
> [  302.798292]  writeback_sb_inodes+0x271/0x650
> [  302.798296]  wb_writeback+0x1db/0x430
> [  302.798299]  wb_workfn+0x19a/0x590
> [  302.798302]  ? wb_workfn+0x19a/0x590
> [  302.798307]  ? finish_task_switch+0x9b/0x330
> [  302.798310]  process_one_work+0x2a2/0x680
> [  302.798313]  worker_thread+0x89/0x790
> [  302.798316]  kthread+0x18c/0x1e0
> [  302.798318]  ? rescuer_thread+0x600/0x600
> [  302.798321]  ? kthread_park+0xd0/0xd0
> [  302.798324]  ret_from_fork+0x2c/0x40
> [  302.798325] Code: 0f 45 e8 45 09 f5 e8 09 86 f7 ff 45 89 6c 24 14 4c
> 89 e7 e8 3c ca 13 00 48 83 c4 20 31 c0 5b 41 5c 41 5d 41 5e 41 5f 5d c3
> 0f 0b <0f> 0b 48 8d 43 20 48 89 45 d0 48 8d 43 10 48 89 45 b8 e9 a8 fe
> [  302.798363] RIP: submit_bh_wbc+0x277/0x2a0 RSP: ffff88016d49f248
> [  302.798531] ---[ end trace 273a42299ae29efd ]---
> [  302.802839]
> ==================================================================
>
>
>
> v4.6:
> [  401.567515] ------------[ cut here ]------------
> [  401.567526] WARNING: CPU: 16 PID: 730 at lib/list_debug.c:33
> __list_add+0xbf/0xf0
> [  401.567530] list_add corruption. prev->next should be next
> (ffffe8fffc600548), but was ffff88016e540000. (prev=ffff88016e540000).
> [  401.567579] Modules linked in: ext4 jbd2 mbcache vfat fat
> x86_pkg_temp_thermal coretemp kvm_intel kvm irqbypass crct10dif_pclmul
> crc32_pclmul ghash_clmulni_intel aesni_intel glue_helper lrw gf128mul
> iTCO_wdt ablk_helper cryptd iTCO_vendor_support btrfs xor pcspkr
> raid6_pq i2c_i801 sg i2c_core lpc_ich shpchp wmi ipmi_devintf ipmi_si
> ipmi_msghandler nfit fjes tpm_crb libnvdimm acpi_power_meter acpi_pad
> ip_tables xfs libcrc32c sd_mod crc32c_intel ahci e1000e nvme libahci ptp
> nvme_core pps_core libata
> [  401.567584] CPU: 16 PID: 730 Comm: kworker/u898:2 Not tainted 4.6.0 #64
> [  401.567586] Hardware name: Intel Corporation PURLEY/PURLEY, BIOS
> PLYDCRB1.86B.0121.R04.1702012027 02/01/2017
> [  401.567595] Workqueue: writeback wb_workfn (flush-259:2)
> [  401.567600]  ffffffff81e50fc1 00000000b7d5bb37 ffff88023207ee88
> ffffffff814b0578
> [  401.567604]  ffff88023207eee0 0000000000000000 ffff88023207eed0
> ffffffff810bf821
> [  401.567608]  ffff880230c9dd00 00000021fc6005c0 ffff88016e540000
> ffff88016e540000
> [  401.567609] Call Trace:
> [  401.567619]  [<ffffffff814b0578>] dump_stack+0x63/0x8b
> [  401.567626]  [<ffffffff810bf821>] __warn+0x111/0x130
> [  401.567630]  [<ffffffff810bf89f>] warn_slowpath_fmt+0x5f/0x80
> [  401.567633]  [<ffffffff814ddbff>] __list_add+0xbf/0xf0
> [  401.567640]  [<ffffffff8147e008>] blk_mq_insert_requests+0x168/0x2a0
> [  401.567645]  [<ffffffff8147f41a>] blk_mq_flush_plug_list+0x1ca/0x1f0
> [  401.567651]  [<ffffffff8146d203>] blk_flush_plug_list+0x133/0x330
> [  401.567659]  [<ffffffff81a0871f>] io_schedule_timeout+0x6f/0x1a0
> [  401.567663]  [<ffffffff81a0a139>] bit_wait_io+0x29/0x80
> [  401.567667]  [<ffffffff81a09b0f>] __wait_on_bit+0x7f/0xd0
> [  401.567671]  [<ffffffff81a0a110>] ? bit_wait_timeout+0xd0/0xd0
> [  401.567675]  [<ffffffff81a0a110>] ? bit_wait_timeout+0xd0/0xd0
> [  401.567679]  [<ffffffff81a09be1>] out_of_line_wait_on_bit+0x81/0xb0
> [  401.567686]  [<ffffffff8112a3b0>] ? autoremove_wake_function+0x50/0x50
> [  401.567692]  [<ffffffff81343683>] __sync_dirty_buffer+0x103/0x120
> [  401.567743]  [<ffffffffa0dd9609>] ext4_commit_super+0x3a9/0x4a0 [ext4]
> [  401.567794]  [<ffffffffa0dd9b1f>] __ext4_error+0x7f/0x120 [ext4]
> [  401.567827]  [<ffffffffa0d98c7d>] ext4_wait_block_bitmap+0xbd/0xe0 [ext4]
> [  401.567868]  [<ffffffffa0dfd2ce>] ext4_mb_init_cache+0x35e/0xb00 [ext4]
> [  401.567906]  [<ffffffffa0dfdc6c>] ext4_mb_init_group+0x1fc/0x330 [ext4]
> [  401.567944]  [<ffffffffa0dfe656>] ext4_mb_load_buddy_gfp+0x636/0x680
> [ext4]
> [  401.567982]  [<ffffffffa0e01dee>] ext4_mb_find_by_goal+0x15e/0x640 [ext4]
> [  401.568020]  [<ffffffffa0e02ff6>]
> ext4_mb_regular_allocator+0xd6/0x770 [ext4]
> [  401.568025]  [<ffffffff812c1b36>] ? ___slab_alloc+0x146/0x450
> [  401.568057]  [<ffffffffa0d98a59>] ?
> ext4_get_group_no_and_offset+0x99/0xb0 [ext4]
> [  401.568100]  [<ffffffffa0e05eb1>] ext4_mb_new_blocks+0x6b1/0x960 [ext4]
> [  401.568137]  [<ffffffffa0deacc8>] ? ext4_ext_search_right+0x108/0x490
> [ext4]
> [  401.568174]  [<ffffffffa0ded672>] ? ext4_find_extent+0x472/0x4c0 [ext4]
> [  401.568211]  [<ffffffffa0df457b>] ext4_ext_map_blocks+0x112b/0x15c0
> [ext4]
> [  401.568216]  [<ffffffff8123a3f4>] ? find_get_pages_tag+0x214/0x230
> [  401.568250]  [<ffffffffa0da0800>] ? __ext4_new_inode+0xbb0/0x1d20 [ext4]
> [  401.568283]  [<ffffffffa0da6257>] ext4_map_blocks+0x1b7/0x800 [ext4]
> [  401.568317]  [<ffffffffa0dac151>] ext4_writepages+0x951/0x1280 [ext4]
> [  401.568323]  [<ffffffff8124e9db>] do_writepages+0x4b/0x70
> [  401.568326]  [<ffffffff8133373a>] __writeback_single_inode+0x6a/0x480
> [  401.568330]  [<ffffffff813342ad>] writeback_sb_inodes+0x26d/0x660
> [  401.568334]  [<ffffffff8133474c>] __writeback_inodes_wb+0xac/0x100
> [  401.568338]  [<ffffffff81334c6c>] wb_writeback+0x3fc/0x420
> [  401.568341]  [<ffffffff813355cb>] wb_workfn+0x32b/0x590
> [  401.568347]  [<ffffffff810e3bd6>] process_one_work+0x256/0x620
> [  401.568351]  [<ffffffff810e4c55>] worker_thread+0x85/0x750
> [  401.568355]  [<ffffffff810e4bd0>] ? rescuer_thread+0x520/0x520
> [  401.568358]  [<ffffffff810ece22>] kthread+0x122/0x140
> [  401.568362]  [<ffffffff81a0e582>] ret_from_fork+0x22/0x40
> [  401.568365]  [<ffffffff810ecd00>] ? kthread_park+0x80/0x80
> [  401.568383] ---[ end trace 53be6edc49257ee0 ]---
> [  401.568384] ------------[ cut here ]------------
