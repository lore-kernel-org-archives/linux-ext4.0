From: "Hongzhi, Song" <hongzhi.song@windriver.com>
Subject: Panic with ext4,nbd,qemu-img,block
Date: Sat, 20 Jan 2018 16:41:00 +0800
Message-ID: <0555d0c0-1f42-e78f-28ab-6c7a00f0c020@windriver.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 8bit
Cc: <linux-kernel@vger.kernel.org>, <linux-block@vger.kernel.org>
To: <linux-ext4@vger.kernel.org>
Return-path: <linux-block-owner@vger.kernel.org>
Content-Language: en-US
Sender: linux-block-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Hello,

I create a virtual disk-image using qemu-img.

And then I use /dev/nbd to map the image.

I mount the /dev/nbd to a local dir with ext4-format

Finally, I have some trouble about ext4-filesystem and block device, 
with using demand of rsync or dd to write the image.

Reproduce :

     qemu-img create test.img 2G

     mkfs.ext4 -F test.img

      qemu-nbd -f raw -c /dev/nbd0 test.img

      mount -r ext4 /dev/nbd0 LOCAL_DIR/

     rsync -av META_DATA_DIR/  LOCAL_DIR/

Kernel Version:

     4.12+HEAD (I have test 4.15-rc7 and 4.12)

Machine:

     intel-x86-64

CPU:

     xeon

Architecture:

     I86

The problem is not always  appear step by step, but often using lava 
that is a auto-testing method.

And it just appears in some special board.

If someone has similar trouble or has resolution or wants more detail, 
please connect with me. Thanks.

Detail:


329.11 EXT4-fs (nbd0): mounted filesystem with ordered data mode. Opts: 
(null)
329.12 block nbd0: Connection timed out
329.13 block nbd0: shutting down sockets
329.14 blk_update_request: I/O error, dev nbd0, sector 304384
329.15 blk_update_request: I/O error, dev nbd0, sector 304640
329.16 blk_update_request: I/O error, dev nbd0, sector 304896
329.17 blk_update_request: I/O error, dev nbd0, sector 305152
329.18 blk_update_request: I/O error, dev nbd0, sector 305408
329.19 blk_update_request: I/O error, dev nbd0, sector 305664
329.20 blk_update_request: I/O error, dev nbd0, sector 305920
329.21 blk_update_request: I/O error, dev nbd0, sector 306176
329.22 blk_update_request: I/O error, dev nbd0, sector 306432
329.23 blk_update_request: I/O error, dev nbd0, sector 306688
329.24 EXT4-fs warning (device nbd0): ext4_end_bio:322: I/O error -5 
writing to inode 160 (offset 8388608 size 8388608 starting block 38400)
329.25 Buffer I/O error on device nbd0, logical block 38144
329.26 Buffer I/O error on device nbd0, logical block 38145
329.27 Buffer I/O error on device nbd0, logical block 38146
329.28 Buffer I/O error on device nbd0, logical block 38147
329.29 Buffer I/O error on device nbd0, logical block 38148
329.30 Buffer I/O error on device nbd0, logical block 38149
329.31 Buffer I/O error on device nbd0, logical block 38150
329.32 Buffer I/O error on device nbd0, logical block 38151
329.33 Buffer I/O error on device nbd0, logical block 38152
329.34 Buffer I/O error on device nbd0, logical block 38153
329.35 EXT4-fs warning (device nbd0): ext4_end_bio:322: I/O error -5 
writing to inode 160 (offset 8388608 size 8388608 starting block 38656)
329.36 EXT4-fs warning (device nbd0): ext4_end_bio:322: I/O error -5 
writing to inode 160 (offset 8388608 size 8388608 starting block 38912)
329.37 EXT4-fs warning (device nbd0): ext4_end_bio:322: I/O error -5 
writing to inode 160 (offset 16777216 size 8388608 starting block 39168)
329.38 EXT4-fs warning (device nbd0): ext4_end_bio:322: I/O error -5 
writing to inode 160 (offset 16777216 size 8388608 starting block 39424)
329.39 EXT4-fs warning (device nbd0): ext4_end_bio:322: I/O error -5 
writing to inode 160 (offset 16777216 size 8388608 starting block 39680)
329.40 EXT4-fs warning (device nbd0): ext4_end_bio:322: I/O error -5 
writing to inode 160 (offset 16777216 size 8388608 starting block 39936)
329.41 EXT4-fs warning (device nbd0): ext4_end_bio:322: I/O error -5 
writing to inode 160 (offset 16777216 size 8388608 starting block 40192)
329.42 EXT4-fs warning (device nbd0): ext4_end_bio:322: I/O error -5 
writing to inode 160 (offset 16777216 size 8388608 starting block 40448)
329.43 EXT4-fs error (device nbd0): __ext4_get_inode_loc:4520: inode 
#222: block 174: comm kworker/u113:0: unable to read itable block
329.44 EXT4-fs warning (device nbd0): ext4_end_bio:322: I/O error -5 
writing to inode 160 (offset 16777216 size 8388608 starting block 40704)
329.45 ------------[ cut here ]------------
329.46 kernel BUG at /kernel-source//fs/buffer.c:3091!
329.47 invalid opcode: 0000 [#1] PREEMPT SMP
329.48 Modules linked in: nbd xt_CHECKSUM iptable_mangle ipt_REJECT 
nf_reject_ipv4 xt_tcpudp ebtable_filter ebtables ip6_tables 
ipt_MASQUERADE nf_nat_masquerade_ipv4 nf_conntrack_netlink nfnetlink 
xfrm_user iptable_nat xt_addrtype iptable_filter ip_tables xt_conntrack 
x_tables br_netfilter bridge stp llc intel_rapl sb_edac intel_powerclamp 
coretemp crct10dif_pclmul crct10dif_common aesni_intel aes_x86_64 
crypto_simd cryptd glue_helper iTCO_wdt iTCO_vendor_support lpc_ich 
i2c_i801 wmi acpi_pad acpi_power_meter nfsd openvswitch nf_defrag_ipv6 
nf_conntrack_ipv4 nf_defrag_ipv4 nf_nat_ipv4 nf_nat nf_conntrack 
kvm_intel kvm irqbypass fuse
329.49 CPU: 30 PID: 6 Comm: kworker/u113:0 Not tainted 
4.12.18-rt0-yocto-preempt-rt #1
329.50 Hardware name: Intel Corporation S2600WTT/S2600WTT, BIOS 
GRNDSDP1.86B.0036.R05.1407140519 07/14/2014
329.51 Workqueue: writeback wb_workfn (flush-43:0)
329.52 task: ffff977bec759e00 task.stack: ffffa2930524c000
329.53 RIP: 0010:submit_bh_wbc+0x155/0x160
329.54 RSP: 0018:ffffa2930524f7e0 EFLAGS: 00010246
329.55 RAX: 0000000000620005 RBX: ffff977f05cddc18 RCX: 0000000000000000
329.56 RDX: ffff977f05cddc18 RSI: 0000000000020800 RDI: 0000000000000001
329.57 RBP: ffffa2930524f808 R08: ff00000000000000 R09: 00ffffffffffffff
329.58 R10: ffffa2930524f920 R11: 000000000000058c R12: 000000000000a598
329.59 R13: ffffffffba15c500 R14: ffff977fe1bab400 R15: ffff977fea643000
329.60 FS: 0000000000000000(0000) GS:ffff977befa00000(0000) 
knlGS:0000000000000000
329.61 CS: 0010 DS: 0000 ES: 0000 CR0: 0000000080050033
329.62 CR2: 00007f7d70000010 CR3: 000000035ce0e000 CR4: 00000000001406e0
329.63 Call Trace:
329.64 __sync_dirty_buffer+0x41/0xa0
329.65 ext4_commit_super+0x1d6/0x2a0
329.66 __ext4_error_inode+0xb2/0x170
329.67 ? wake_up_bit+0x30/0x30
329.68 __ext4_get_inode_loc+0x365/0x460
329.69 ext4_reserve_inode_write+0x51/0xb0
329.70 ? ext4_writepages+0xd23/0x1090
329.71 ext4_mark_inode_dirty+0x48/0x200
329.72 ext4_writepages+0xd23/0x1090
329.73 ? __schedule+0x25b/0x6a0
329.74 do_writepages+0x39/0xc0
329.75 ? do_writepages+0x39/0xc0
329.76 ? unpin_current_cpu+0x5e/0x80
329.77 ? migrate_enable+0x2dd/0x3c0
329.78 __writeback_single_inode+0x4d/0x490
329.79 ? __writeback_single_inode+0x4d/0x490
329.80 ? rt_spin_unlock+0x27/0x40
329.81 writeback_sb_inodes+0x230/0x4d0
329.82 wb_writeback+0xde/0x3d0
329.83 wb_workfn+0xb8/0x420
329.84 ? wb_workfn+0xb8/0x420
329.85 ? unpin_current_cpu+0x5e/0x80
329.86 ? migrate_enable+0x2dd/0x3c0
329.87 ? _raw_spin_lock+0x17/0x40
329.88 process_one_work+0x1cf/0x470
329.89 ? migrate_disable+0x12f/0x200
329.90 worker_thread+0x4b/0x450
329.91 kthread+0x124/0x140
329.92 ? process_one_work+0x470/0x470
329.93 ? kthread_create_on_node+0x40/0x40
329.94 ret_from_fork+0x22/0x30
329.95 Code: 89 ef 44 09 f7 41 89 7c 24 14 4c 89 e7 e8 04 c4 22 00 5b 31 
c0 41 5c 41 5d 41 5e 41 5f 5d c3 f0 80 62 01 f7 e9 19 ff ff ff 0f 0b 
<0f> 0b 0f 0b 0f 0b 0f 0b 0f 0b 90 0f 1f 44 00 00 55 49 89 f9 48
329.96 RIP: submit_bh_wbc+0x155/0x160 RSP: ffffa2930524f7e0
329.97 ---[ end trace 0000000000000002 ]---
329.98 Buffer I/O error on dev nbd0, logical block 262144, lost sync 
page write
329.99 JBD2: Error -5 detected when updating journal superblock for nbd0-8.
329.100 Aborting journal on device nbd0-8.
329.101 ------------[ cut here ]------------
329.102 kernel BUG at /kernel-source//fs/buffer.c:3091!
329.103 invalid opcode: 0000 [#2] PREEMPT SMP
329.104 Modules linked in: nbd xt_CHECKSUM iptable_mangle ipt_REJECT 
nf_reject_ipv4 xt_tcpudp ebtable_filter ebtables ip6_tables 
ipt_MASQUERADE nf_nat_masquerade_ipv4 nf_conntrack_netlink nfnetlink 
xfrm_user iptable_nat xt_addrtype iptable_filter ip_tables xt_conntrack 
x_tables br_netfilter bridge stp llc intel_rapl sb_edac intel_powerclamp 
coretemp crct10dif_pclmul crct10dif_common aesni_intel aes_x86_64 
crypto_simd cryptd glue_helper iTCO_wdt iTCO_vendor_support lpc_ich 
i2c_i801 wmi acpi_pad acpi_power_meter nfsd openvswitch nf_defrag_ipv6 
nf_conntrack_ipv4 nf_defrag_ipv4 nf_nat_ipv4 nf_nat nf_conntrack 
kvm_intel kvm irqbypass fuse
329.105 CPU: 36 PID: 7760 Comm: jbd2/nbd0-8 Tainted: G D 
4.12.18-rt0-yocto-preempt-rt #1
329.106 Hardware name: Intel Corporation S2600WTT/S2600WTT, BIOS 
GRNDSDP1.86B.0036.R05.1407140519 07/14/2014
329.107 task: ffff977fdd853c00 task.stack: ffffa29308934000
329.108 RIP: 0010:submit_bh_wbc+0x155/0x160
329.109 RSP: 0018:ffffa29308937bd0 EFLAGS: 00010246
329.110 RAX: 0000000004000005 RBX: ffff977f05cf62e8 RCX: 0000000000000000
329.111 RDX: ffff977f05cf62e8 RSI: 0000000000020800 RDI: 0000000000000001
329.112 RBP: ffffa29308937bf8 R08: 0000000000000100 R09: 0000000000000000
329.113 R10: ffff977fdd853f30 R11: 0000000000000000 R12: ffff977fea6bc800
329.114 R13: 0000000000020800 R14: ffff977fc8a33000 R15: ffff977fea6bc800
329.115 FS: 0000000000000000(0000) GS:ffff977befb80000(0000) 
knlGS:0000000000000000
329.116 CS: 0010 DS: 0000 ES: 0000 CR0: 0000000080050033
329.117 CR2: 0000000000915d50 CR3: 000000035ce0e000 CR4: 00000000001406e0
329.118 Call Trace:
329.119 submit_bh+0x10/0x20
329.120 jbd2_write_superblock+0xaf/0x1e0
329.121 jbd2_journal_update_sb_errno+0x3f/0x50
329.122 __journal_abort_soft+0x3d/0x60
329.123 jbd2_write_superblock+0x1b4/0x1e0
329.124 jbd2_journal_update_sb_log_tail+0x3a/0x90
329.125 jbd2_journal_commit_transaction+0xb89/0x18d0
329.126 ? __this_cpu_preempt_check+0x13/0x20
329.127 ? __perf_event_task_sched_in+0x66/0x190
329.128 ? _raw_spin_lock_irqsave+0x1d/0x50
329.129 ? lock_timer_base+0x81/0xa0
329.130 ? _raw_spin_unlock_irqrestore+0x18/0x50
329.131 ? try_to_del_timer_sync+0x44/0x60
329.132 ? del_timer_sync+0x47/0xf0
329.133 kjournald2+0xc6/0x250
329.134 ? kjournald2+0xc6/0x250
329.135 ? wake_bit_function+0x60/0x60
329.136 kthread+0x124/0x140
329.137 ? commit_timeout+0x10/0x10
329.138 ? kthread_create_on_node+0x40/0x40
329.139 ret_from_fork+0x22/0x30
329.140 Code: 89 ef 44 09 f7 41 89 7c 24 14 4c 89 e7 e8 04 c4 22 00 5b 
31 c0 41 5c 41 5d 41 5e 41 5f 5d c3 f0 80 62 01 f7 e9 19 ff ff ff 0f 0b 
<0f> 0b 0f 0b 0f 0b 0f 0b 0f 0b 90 0f 1f 44 00 00 55 49 89 f9 48
329.141 RIP: submit_bh_wbc+0x155/0x160 RSP: ffffa29308937bd0
329.142 ---[ end trace 0000000000000003 ]---
329.143 block nbd0: Connection timed out
329.144 block nbd0: Connection timed out
329.145 block nbd0: Connection timed out
329.146 block nbd0: Connection timed out
329.147 block nbd0: Connection timed out
329.148 block nbd0: Connection timed out
329.149 block nbd0: Connection timed out
329.150 block nbd0: Connection timed out
329.151 block nbd0: Connection timed out
