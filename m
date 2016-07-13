From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 124651] New: ext4 bugon panic when I mmap a file
Date: Wed, 13 Jul 2016 02:09:35 +0000
Message-ID: <bug-124651-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:45306 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750890AbcGMCJq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 12 Jul 2016 22:09:46 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 4DA312026D
	for <linux-ext4@vger.kernel.org>; Wed, 13 Jul 2016 02:09:39 +0000 (UTC)
Received: from bugzilla1.web.kernel.org (bugzilla1.web.kernel.org [172.20.200.51])
	by mail.kernel.org (Postfix) with ESMTP id E332B20270
	for <linux-ext4@vger.kernel.org>; Wed, 13 Jul 2016 02:09:35 +0000 (UTC)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=3D124651

            Bug ID: 124651
           Summary: ext4 bugon panic when I mmap a file
           Product: File System
           Version: 2.5
    Kernel Version: 3.10.0-229.el7.x86_64
          Hardware: All
                OS: Linux
              Tree: Mainline
            Status: NEW
          Severity: normal
          Priority: P1
         Component: ext4
          Assignee: fs_ext4@kernel-bugs.osdl.org
          Reporter: 35445233@qq.com
        Regression: No

[55324.661700] end_request: I/O error, dev dm-5, sector 467960
[55324.664220] EXT4-fs (dm-9): Delayed block allocation failed for inod=
e
5242883 at logical offset 1151 with max blocks 1 with error 5
[55324.670324] EXT4-fs (dm-9): This should not happen!! Data will be lo=
st

[55324.672523] end_request: I/O error, dev dm-5, sector 230686704
[55324.672526] Buffer I/O error on device dm-5, logical block 28835838
[55324.678318] end_request: I/O error, dev dm-5, sector 230686704
[55324.678319] Buffer I/O error on device dm-5, logical block 28835838
[55324.698575] end_request: I/O error, dev dm-5, sector 467936
[55324.702225] EXT4-fs warning (device dm-9): ext4_end_bio:332: I/O err=
or -5
writing to inode 5242883 (offset 4714496 size 0 starting block 54396)
[55324.712098] Buffer I/O error on device dm-9, logical block 54396
[55324.717510] Buffer I/O error on device dm-9, logical block 54397
[55324.720972] Buffer I/O error on device dm-9, logical block 54398
[55324.744231] ------------[ cut here ]------------
[55324.746148] WARNING: at fs/buffer.c:661 __set_page_dirty+0xaa/0xc0()
[55324.747614] Modules linked in: xt_CHECKSUM iptable_mangle ipt_REJECT
xt_conntrack ipt_MASQUERADE tun nf_nat_masquerade_ipv4 ebtable_filter e=
btables
ip6table_filter ip6_table
s iptable_nat nf_conntrack_ipv4 nf_nat_ipv4 xt_addrtype iptable_filter
ip_tables nf_nat dm_thin_pool dm_persistent_data dm_bio_prison dm_bufio=
 loop sg
target_core_mod scsi_tran
sport_iscsi 8021q garp mrp openvswitch(OF) nf_defrag_ipv6 nf_defrag_ipv=
4
nf_conntrack gre libcrc32c sysdig_probe(OF) dm_service_time iTCO_wdt
iTCO_vendor_support intel_powercla
mp coretemp intel_rapl kvm_intel kvm crct10dif_pclmul crc32_pclmul crc3=
2c_intel
ghash_clmulni_intel aesni_intel lrw gf128mul glue_helper ipmi_devintf i=
xgbe(OF)
ablk_helper ses=20
cryptd serio_raw ipmi_si ipmi_msghandler pcspkr hpwdt enclosure sb_edac=
 lpc_ich
edac_core hpilo i2c_i801 mfd_core
[55324.759813]  pcc_cpufreq ioatdma shpchp wmi acpi_power_meter dca bon=
ding
bridge stp llc nfsd auth_rpcgss nfs_acl lockd sunrpc dm_multipath ext4 =
mbcache
jbd2 usb_storage sd_m
od crc_t10dif crct10dif_common mgag200 syscopyarea sysfillrect sysimgbl=
t
i2c_algo_bit drm_kms_helper ttm drm qla2xxx(OF) scsi_transport_fc i2c_c=
ore hpsa
scsi_tgt dm_mirror dm_r
egion_hash dm_log dm_mod [last unloaded: openvswitch]
[55324.768918] CPU: 33 PID: 1612 Comm: mongod Tainted: GF        =20
O--------------   3.10.0-229.1.el7.x86_64 #1
[55324.771353] Hardware name: HP ProLiant BL460c Gen9, BIOS I36 12/28/2=
015
[55324.773397]  0000000000000000 000000001901e335 ffff881addf23bc0
ffffffff81620634
[55324.775625]  ffff881addf23bf8 ffffffff8106f92b ffffea00f2aaa5c0
ffff883cc1094fc8
[55324.777855]  ffff883cc1094fe0 0000000000000246 0000000000000001
ffff881addf23c08
[55324.779708] Call Trace:
[55324.781505]  [<ffffffff81620634>] dump_stack+0x19/0x1b
[55324.787209]  [<ffffffff8106f92b>] warn_slowpath_common+0x6b/0xb0
[55324.789667]  [<ffffffff8106fa7a>] warn_slowpath_null+0x1a/0x20
[55324.791357]  [<ffffffff812004aa>] __set_page_dirty+0xaa/0xc0
[55324.796320]  [<ffffffff81200550>] __set_page_dirty_buffers+0x90/0xc0
[55324.798319]  [<ffffffff81166967>] set_page_dirty+0x37/0x60
[55324.799972]  [<ffffffff8118579c>] unmap_page_range+0x6ec/0x860
[55324.802027]  [<ffffffff81185991>] unmap_single_vma+0x81/0xf0
[55324.805369]  [<ffffffff81186a59>] unmap_vmas+0x49/0x90
[55324.807215]  [<ffffffff8118f6ec>] exit_mmap+0xac/0x1a0
[55324.809443]  [<ffffffff8106ca97>] mmput+0x67/0xf0
[55324.811490]  [<ffffffff81075dcc>] do_exit+0x28c/0xa60
[55324.813329]  [<ffffffff810ab090>] ? wake_up_state+0x10/0x20
[55324.815318]  [<ffffffff8108421e>] ? signal_wake_up_state+0x1e/0x30
[55324.817695]  [<ffffffff810856b2>] ? zap_other_threads+0x92/0xc0
[55324.819676]  [<ffffffff8107661f>] do_group_exit+0x3f/0xa0
[55324.821262]  [<ffffffff81076694>] SyS_exit_group+0x14/0x20
[55324.823556]  [<ffffffff816306c9>] system_call_fastpath+0x16/0x1b
[55324.825843] ---[ end trace 3a488c6302e47a3e ]---
[55359.503567] ------------[ cut here ]------------
[55359.508185] kernel BUG at fs/ext4/inode.c:2263!
[55359.511451] invalid opcode: 0000 [#1] SMP=20
[55359.514849] Modules linked in: xt_CHECKSUM iptable_mangle ipt_REJECT
xt_conntrack ipt_MASQUERADE tun nf_nat_masquerade_ipv4 ebtable_filter e=
btables
ip6table_filter ip6_tables iptable_nat nf_conntrack_ipv4 nf_nat_ipv4
xt_addrtype iptable_filter ip_tables nf_nat dm_thin_pool dm_persistent_=
data
dm_bio_prison dm_bufio loop sg target_core_mod scsi_transport_iscsi 802=
1q garp
mrp openvswitch(OF) nf_defrag_ipv6 nf_defrag_ipv4 nf_conntrack gre libc=
rc32c
sysdig_probe(OF) dm_service_time iTCO_wdt iTCO_vendor_support intel_pow=
erclamp
coretemp intel_rapl kvm_intel kvm crct10dif_pclmul crc32_pclmul crc32c_=
intel
ghash_clmulni_intel aesni_intel lrw gf128mul glue_helper ipmi_devintf i=
xgbe(OF)
ablk_helper ses cryptd serio_raw ipmi_si ipmi_msghandler pcspkr hpwdt e=
nclosure
sb_edac lpc_ich edac_core hpilo i2c_i801 mfd_core
[55359.534793]  pcc_cpufreq ioatdma shpchp wmi acpi_power_meter dca bon=
ding
bridge stp llc nfsd auth_rpcgss nfs_acl lockd sunrpc dm_multipath ext4 =
mbcache
jbd2 usb_storage sd_mod crc_t10dif crct10dif_common mgag200 syscopyarea
sysfillrect sysimgblt i2c_algo_bit drm_kms_helper ttm drm qla2xxx(OF)
scsi_transport_fc i2c_core hpsa scsi_tgt dm_mirror dm_region_hash dm_lo=
g dm_mod
[last unloaded: openvswitch]
[55359.552743] CPU: 44 PID: 48206 Comm: kworker/u98:2 Tainted: GF      =
 W=20
O--------------   3.10.0-229.1.el7.x86_64 #1
[55359.557069] Hardware name: HP ProLiant BL460c Gen9, BIOS I36 12/28/2=
015
[55359.562221] Workqueue: writeback bdi_writeback_workfn (flush-253:9)
[55359.568154] task: ffff883fd23b6660 ti: ffff883be4fa8000 task.ti:
ffff883be4fa8000
[55359.572149] RIP: 0010:[<ffffffffa0146015>]  [<ffffffffa0146015>]
mpage_prepare_extent_to_map+0x2d5/0x2e0 [ext4]
[55359.577218] RSP: 0018:ffff883be4fab9a0  EFLAGS: 00010246
[55359.581304] RAX: 006fffff00000075 RBX: ffff883be4fab9e0 RCX:
000000000000047f
[55359.585514] RDX: 0000000000000000 RSI: 0000000000000000 RDI:
0000000000040000
[55359.590419] RBP: ffff883be4faba78 R08: 0000000000000000 R09:
0000000000000000
[55359.594536] R10: 0000000000000100 R11: 0000000000000220 R12:
0000000000003400
[55359.602253] R13: ffffffffffffffff R14: ffffea00f2aaa5c0 R15:
ffff883be4fabb20
[55359.605323] FS:  0000000000000000(0000) GS:ffff883fff400000(0000)
knlGS:0000000000000000
[55359.609512] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[55359.615395] CR2: 00007f38c4db96f8 CR3: 0000001f62a29000 CR4:
00000000001407e0
[55359.618623] DR0: 0000000000000000 DR1: 0000000000000000 DR2:
0000000000000000
[55359.622525] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7:
0000000000000400
[55359.625513] Stack:
[55359.628838]  ffff883be4fab9e0 0000000000000000 ffff883cc1094fc8
ffff883be4faba18
[55359.632829]  0000000000000504 0000000000000008 0000000000000000
ffffea00f2aaa5c0
[55359.636746]  ffffea00faa515c0 ffffea00f28d6800 ffffea00f28d6840
ffffea00faa3fc40
[55359.641008] Call Trace:
[55359.645065]  [<ffffffffa014a094>] ? ext4_writepages+0x434/0xd60 [ext=
4]
[55359.652033]  [<ffffffffa0177569>] ? __ext4_journal_start_sb+0x69/0xe=
0 [ext4]
[55359.655646]  [<ffffffffa014a0c3>] ext4_writepages+0x463/0xd60 [ext4]
[55359.663185]  [<ffffffff811681ee>] do_writepages+0x1e/0x40
[55359.672506]  [<ffffffff811f7c40>] __writeback_single_inode+0x40/0x22=
0
[55359.674714]  [<ffffffff811f86de>] writeback_sb_inodes+0x25e/0x420
[55359.677252]  [<ffffffff811f893f>] __writeback_inodes_wb+0x9f/0xd0
[55359.681207]  [<ffffffff811f9183>] wb_writeback+0x263/0x2f0
[55359.683438]  [<ffffffff811e7c2c>] ? get_nr_inodes+0x4c/0x70
[55359.685519]  [<ffffffff811faa5b>] bdi_writeback_workfn+0x2cb/0x460
[55359.687632]  [<ffffffff81090dab>] process_one_work+0x17b/0x470
[55359.691493]  [<ffffffff81091b8b>] worker_thread+0x11b/0x400
[55359.693588]  [<ffffffff81091a70>] ? rescuer_thread+0x400/0x400
[55359.695999]  [<ffffffff810990bf>] kthread+0xcf/0xe0
[55359.698401]  [<ffffffff81098ff0>] ? kthread_create_on_node+0x140/0x1=
40
[55359.700333]  [<ffffffff81630618>] ret_from_fork+0x58/0x90
:

i think because ext4_releasepage-=E3=80=8Btry_to_free_buffers-=E3=80=8B=
cancel_dirty_page dose
not clean the pte dirty=EF=BC=8Cso that the unmap_page_range set the pa=
ge diry
again=E3=80=82

maybe try_to_free_buffers can call  clear_page_dirty_for_io to slove th=
e
problem=EF=BC=9F=EF=BC=9F=EF=BC=9F

--=20
You are receiving this mail because:
You are watching the assignee of the bug.--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
