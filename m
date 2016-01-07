From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 108631] Stuck on mb_cache_spinlock
Date: Thu, 07 Jan 2016 09:02:42 +0000
Message-ID: <bug-108631-13602-GtFqrqjGZP@https.bugzilla.kernel.org/>
References: <bug-108631-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:36332 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751905AbcAGJCs (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 7 Jan 2016 04:02:48 -0500
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 79071200E6
	for <linux-ext4@vger.kernel.org>; Thu,  7 Jan 2016 09:02:46 +0000 (UTC)
Received: from bugzilla1.web.kernel.org (bugzilla1.web.kernel.org [172.20.200.51])
	by mail.kernel.org (Postfix) with ESMTP id C558820172
	for <linux-ext4@vger.kernel.org>; Thu,  7 Jan 2016 09:02:42 +0000 (UTC)
In-Reply-To: <bug-108631-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=108631

Norman Meilick <nm@sbe.de> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |nm@sbe.de

--- Comment #1 from Norman Meilick <nm@sbe.de> ---
Hi,

we have the same problem on several of our servers (mostly HP ProLiant ML350p
Gen8 but also other brands) and are able to reproduce it reliably on some of
them. Usually the soft lockups are triggered during our nightly rsync backups
(backing up lots of local files with POSIX ACLs to a local disk), but they also
happened during normal use. After a few hours of soft lockups and an unusable
server, the hardware watchdog finally kicks in and a kernel panic results.

All file systems involved are EXT3.
We've confirmed the problem with kernels 3.16, 3.18 and 4.3.
Kernel 3.14 seems not to be affected - no problems on any server after the
downgrade.

Soft lockup:
[26331.750524] BUG: soft lockup - CPU#2 stuck for 22s! [rsync:17146]
[26331.750552] Modules linked in: snd_mtpav netconsole snd_rawmidi
snd_seq_device snd soundcore mptctl mptbase xt_REDIRECT ip_set_bitmap_port
ip_set_hash_netport ip_set_hash_net ip_set_hash_ip ipmi_devintf configfs hpwdt
quota_v2 quota_tree autofs4 veth act_police cls_basic cls_flow cls_fw cls_u32
sch_fq_codel sch_tbf sch_prio sch_htb sch_hfsc sch_ingress sch_sfq stp llc
ppdev lp parport xt_CHECKSUM ipt_rpfilter xt_statistic xt_CT xt_LOG
xt_connlimit xt_realm xt_addrtype xt_comment xt_recent xt_nat ipt_ULOG
ipt_REJECT ipt_MASQUERADE ipt_ECN ipt_CLUSTERIP ipt_ah xt_set ip_set
nf_nat_tftp nf_nat_snmp_basic nf_conntrack_snmp nf_nat_sip nf_nat_pptp
nf_nat_proto_gre nf_nat_irc nf_nat_h323 nf_nat_ftp nf_nat_amanda ts_kmp
nf_conntrack_amanda nf_conntrack_sane nf_conntrack_tftp nf_conntrack_sip
nf_conntrack_proto_udplite nf_conntrack_proto_sctp nf_conntrack_pptp
nf_conntrack_proto_gre nf_conntrack_netlink nf_conntrack_netbios_ns
nf_conntrack_broadcast nf_conntrack_irc nf_conntrack_h323 nf_conntrack_ftp
xt_TPROXY nf_defrag_ipv6 xt_time xt_TCPMSS xt_tcpmss xt_sctp xt_policy
xt_pkttype xt_physdev xt_owner xt_NFQUEUE xt_NFLOG nfnetlink_log xt_multiport
xt_mark xt_mac xt_limit xt_length xt_iprange xt_helper xt_hashlimit xt_DSCP
xt_dscp xt_dccp xt_conntrack xt_connmark xt_CLASSIFY xt_AUDIT xt_tcpudp
xt_state iptable_raw iptable_nat nf_nat_ipv4 nf_nat nf_conntrack_ipv4
nf_defrag_ipv4 nf_conntrack iptable_mangle nfnetlink iptable_filter ip_tables
x_tables openvswitch gre vxlan libcrc32c intel_rapl x86_pkg_temp_thermal
intel_powerclamp coretemp kvm_intel kvm crct10dif_pclmul crc32_pclmul
aesni_intel hpilo sb_edac edac_core aes_x86_64 lrw shpchp gf128mul glue_helper
ipmi_si ablk_helper ipmi_msghandler serio_raw cryptd ioatdma pcspkr lpc_ich wmi
joydev acpi_power_meter mac_hid hid_generic psmouse igb usbhid tg3 i2c_algo_bit
pata_acpi hid dca hpsa ptp pps_core [last unloaded: snd_mtpav]
[26331.750591] CPU: 2 PID: 17146 Comm: rsync Tainted: G        W    
3.16.0-57-generic #77~14.04.1-Ubuntu
[26331.750592] Hardware name: HP ProLiant ML350p Gen8, BIOS P72 07/01/2015
[26331.750593] task: ffff8800857ea8c0 ti: ffff88015c01c000 task.ti:
ffff88015c01c000
[26331.750599] RIP: 0010:[<ffffffff81770b12>]  [<ffffffff81770b12>]
_raw_spin_lock+0x32/0x50
[26331.750600] RSP: 0018:ffff88015c01fb40  EFLAGS: 00000202
[26331.750600] RAX: 0000000000004ade RBX: ffffffff81120324 RCX:
00000000000054e8
[26331.750601] RDX: 00000000000054ea RSI: 00000000000054ea RDI:
ffffffff81f8d600
[26331.750602] RBP: ffff88015c01fb40 R08: 20043814dd400000 R09:
dffb4fec30c53750
[26331.750602] R10: 3998000000000000 R11: 000000609ccc0000 R12:
ffffffff81206960
[26331.750603] R13: ffff8800b9481310 R14: ffffffff81206fd8 R15:
ffff88015c01fb00
[26331.750604] FS:  00007fc052b8f740(0000) GS:ffff88043f440000(0000)
knlGS:0000000000000000
[26331.750605] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[26331.750606] CR2: 00000000edd93000 CR3: 000000015c2d0000 CR4:
00000000000407e0
[26331.750606] Stack:
[26331.750608]  ffff88015c01fb98 ffffffff8122d027 ffff8801b4364000
ffff8800b9481040
[26331.750609]  0000000008290bcc 0000000000001000 ffff88015c01fba8
ffff88020f0218f0
[26331.750611]  ffff88020f0218f0 ffff88015c01fc70 ffffff9f634c2733
ffff88015c01fbc0
[26331.750611] Call Trace:
[26331.750616]  [<ffffffff8122d027>] __mb_cache_entry_find+0x187/0x1e0
[26331.750617]  [<ffffffff8122d1a2>] mb_cache_entry_find_next+0x82/0xb0
[26331.750621]  [<ffffffff81296e7b>] ext4_xattr_block_set+0x26b/0xa30
[26331.750623]  [<ffffffff81298235>] ext4_xattr_set_handle+0x315/0x450
[26331.750625]  [<ffffffff8129c64b>] __ext4_set_acl+0x29b/0x350
[26331.750628]  [<ffffffff8129cb53>] ext4_init_acl+0x43/0xd0
[26331.750629]  [<ffffffff81253b19>] __ext4_new_inode+0xe59/0x12f0
[26331.750632]  [<ffffffff812641ac>] ext4_mkdir+0x1ac/0x400
[26331.750635]  [<ffffffff811e0747>] vfs_mkdir+0xb7/0x160
[26331.750637]  [<ffffffff811e686b>] SyS_mkdir+0xab/0xe0
[26331.750639]  [<ffffffff8177108d>] system_call_fastpath+0x1a/0x1f
[26331.750652] Code: 89 e5 b8 00 00 02 00 f0 0f c1 07 89 c2 c1 ea 10 66 39 c2
75 02 5d c3 83 e2 fe 0f b7 f2 b8 00 80 00 00 eb 0c 0f 1f 44 00 00 f3 90 <83> e8
01 74 0a 0f b7 0f 66 39 ca 75 f1 5d c3 66 66 66 90 66 66 
[26332.682647] Modules linked in: snd_mtpav netconsole snd_rawmidi
snd_seq_device snd soundcore mptctl mptbase xt_REDIRECT ip_set_bitmap_port
ip_set_hash_netport ip_set_hash_net ip_set_hash_ip ipmi_devintf configfs hpwdt
quota_v2 quota_tree autofs4 veth act_police cls_basic cls_flow cls_fw cls_u32
sch_fq_codel sch_tbf sch_prio sch_htb sch_hfsc sch_ingress sch_sfq stp llc
ppdev lp parport xt_CHECKSUM ipt_rpfilter xt_statistic xt_CT xt_LOG
xt_connlimit xt_realm xt_addrtype xt_comment xt_recent xt_nat ipt_ULOG
ipt_REJECT ipt_MASQUERADE ipt_ECN ipt_CLUSTERIP ipt_ah xt_set ip_set
nf_nat_tftp nf_nat_snmp_basic nf_conntrack_snmp nf_nat_sip nf_nat_pptp
nf_nat_proto_gre nf_nat_irc nf_nat_h323 nf_nat_ftp nf_nat_amanda ts_kmp
nf_conntrack_amanda nf_conntrack_sane nf_conntrack_tftp nf_conntrack_sip
nf_conntrack_proto_udplite nf_conntrack_proto_sctp nf_conntrack_pptp
nf_conntrack_proto_gre nf_conntrack_netlink nf_conntrack_netbios_ns
nf_conntrack_broadcast nf_conntrack_irc nf_conntrack_h323 nf_conntrack_ftp
xt_TPROXY nf_defrag_ipv6 xt_time xt_TCPMSS xt_tcpmss xt_sctp xt_policy
xt_pkttype xt_physdev xt_owner xt_NFQUEUE xt_NFLOG nfnetlink_log xt_multiport
xt_mark xt_mac xt_limit xt_length xt_iprange xt_helper xt_hashlimit xt_DSCP
xt_dscp xt_dccp xt_conntrack xt_connmark xt_CLASSIFY xt_AUDIT xt_tcpudp
xt_state iptable_raw iptable_nat nf_nat_ipv4 nf_nat nf_conntrack_ipv4
nf_defrag_ipv4 nf_conntrack iptable_mangle nfnetlink iptable_filter ip_tables
x_tables openvswitch gre vxlan libcrc32c intel_rapl x86_pkg_temp_thermal
intel_powerclamp coretemp kvm_intel kvm crct10dif_pclmul crc32_pclmul
aesni_intel hpilo sb_edac edac_core aes_x86_64 lrw shpchp gf128mul glue_helper
ipmi_si ablk_helper ipmi_msghandler serio_raw cryptd ioatdma pcspkr lpc_ich wmi
joydev acpi_power_meter mac_hid hid_generic psmouse igb usbhid tg3 i2c_algo_bit
pata_acpi hid dca hpsa ptp pps_core [last unloaded: snd_mtpav]
[26332.890168] CPU: 0 PID: 51806 Comm: rsync Tainted: G        W    
3.16.0-57-generic #77~14.04.1-Ubuntu
[26332.911627] Hardware name: HP ProLiant ML350p Gen8, BIOS P72 07/01/2015
[26332.933421] task: ffff88034d5a7010 ti: ffff88009089c000 task.ti:
ffff88009089c000
[26332.954043] RIP: 0010:[<ffffffff8122d869>]  [<ffffffff8122d869>]
mb_cache_entry_alloc+0x69/0x230
[26332.974573] RSP: 0018:ffff88009089fbd0  EFLAGS: 00000246
[26332.994921] RAX: ffff88010e053750 RBX: ffff88009089fbc0 RCX:
ffff88010e053750
[26333.015346] RDX: ffff88010e053750 RSI: 0000000000000050 RDI:
0000000000000001
[26333.035819] RBP: ffff88009089fbe8 R08: ffff880329aaa750 R09:
ffffffff81aaa85e
[26333.056281] R10: ffff880329aaa750 R11: 0000000000000246 R12:
ffff8801986e49a0
[26333.075995] R13: ffff8801986e49a0 R14: ffffffff810b5dc5 R15:
ffffffff8129edba
[26333.095567] FS:  00007fc052b8f740(0000) GS:ffff88043f400000(0000)
knlGS:0000000000000000
[26333.115318] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[26333.134546] CR2: 00000000f77b7000 CR3: 000000016c415000 CR4:
00000000000407f0
[26333.153632] Stack:
[26333.172429]  ffff880003603fc0 ffff880003603fc0 ffff880329aaa750
ffff88009089fc10
[26333.191585]  ffffffff81296073 ffff880003603fc0 ffffffff81aaa85e
ffff880003603f58
[26333.210546]  ffff88009089fc80 ffffffff81297cc0 ffff880003603fc0
ffff8800b9481040
[26333.229103] Call Trace:
[26333.247342]  [<ffffffff81296073>] ext4_xattr_cache_insert+0x23/0x70
[26333.265668]  [<ffffffff81297cc0>] ext4_xattr_get+0x200/0x290
[26333.283669]  [<ffffffff812960fb>] ? ext4_xattr_find_entry+0x3b/0x100
[26333.301506]  [<ffffffff8129ccaa>] ext4_xattr_security_get+0x2a/0x30
[26333.319294]  [<ffffffff811f9b2c>] generic_getxattr+0x4c/0x70
[26333.338108]  [<ffffffff812ec0ad>] cap_inode_need_killpriv+0x2d/0x40
[26333.357066]  [<ffffffff812edeb6>] security_inode_need_killpriv+0x16/0x20
[26333.375541]  [<ffffffff811efe63>] file_remove_suid+0x43/0xc0
[26333.393366]  [<ffffffff8129def0>] ? jbd2_journal_stop+0x1c0/0x3b0
[26333.411155]  [<ffffffff81164f86>] __generic_file_write_iter+0x126/0x350
[26333.428916]  [<ffffffff81250c00>] ext4_file_write_iter+0xf0/0x3a0
[26333.445980]  [<ffffffff811d51a1>] new_sync_write+0x81/0xb0
[26333.461304]  [<ffffffff811d5957>] vfs_write+0xb7/0x1f0
[26333.476357]  [<ffffffff811d64f6>] SyS_write+0x46/0xb0
[26333.490799]  [<ffffffff8177108d>] system_call_fastpath+0x1a/0x1f


Kernel panic:
[35127.073300] Kernel panic - not syncing: An NMI occurred. Depending on your
system the reason for the NMI is logged in any one of the following resources:
[35127.073300] 1. Integrated Management Log (IML)
[35127.073300] 2. OA Syslog
[35127.073300] 3. OA Forward Progress Log
[35127.073300] 4. iLO Event Log
[35127.148146] CPU: 0 PID: 51806 Comm: rsync Tainted: G        W    
3.16.0-57-generic #77~14.04.1-Ubuntu
[35127.163193] Hardware name: HP ProLiant ML350p Gen8, BIOS P72 07/01/2015
[35127.178164]  00001ff2a8b9cc34 ffff88043f405d88 ffffffff8176891e
ffffffffc05532d8
[35127.193308]  ffff88043f405e00 ffffffff81760d39 0000000000000008
ffff88043f405e10
[35127.208326]  ffff88043f405db0 0000000000000000 ffffc90012068072
0000000000000001
[35127.223370] Call Trace:
[35127.238143]  <NMI>  [<ffffffff8176891e>] dump_stack+0x45/0x56
[35127.252982]  [<ffffffff81760d39>] panic+0xc8/0x1fc
[35127.268159]  [<ffffffffc05528fd>] hpwdt_pretimeout+0xdd/0xdd [hpwdt]
[35127.283291]  [<ffffffff8101d2d9>] ? sched_clock+0x9/0x10
[35127.298505]  [<ffffffff81017f68>] nmi_handle+0x88/0x120
[35127.313634]  [<ffffffff81017f72>] ? nmi_handle+0x92/0x120
[35127.329260]  [<ffffffff8101840e>] io_check_error+0x1e/0xa0
[35127.345045]  [<ffffffff81018529>] default_do_nmi+0x99/0x140
[35127.360063]  [<ffffffff810186c0>] do_nmi+0xf0/0x160
[35127.374762]  [<ffffffff8177348f>] end_repeat_nmi+0x1a/0x1e
[35127.389518]  [<ffffffff8122d85b>] ? mb_cache_entry_alloc+0x5b/0x230
[35127.404386]  [<ffffffff8122d85b>] ? mb_cache_entry_alloc+0x5b/0x230
[35127.419001]  [<ffffffff8122d85b>] ? mb_cache_entry_alloc+0x5b/0x230
[35127.433400]  <<EOE>>  [<ffffffff81296073>] ext4_xattr_cache_insert+0x23/0x70
[35127.448042]  [<ffffffff81297cc0>] ext4_xattr_get+0x200/0x290
[35127.462789]  [<ffffffff812960fb>] ? ext4_xattr_find_entry+0x3b/0x100
[35127.478030]  [<ffffffff8129ccaa>] ext4_xattr_security_get+0x2a/0x30
[35127.491919]  [<ffffffff811f9b2c>] generic_getxattr+0x4c/0x70
[35127.505158]  [<ffffffff812ec0ad>] cap_inode_need_killpriv+0x2d/0x40
[35127.517814]  [<ffffffff812edeb6>] security_inode_need_killpriv+0x16/0x20
[35127.530709]  [<ffffffff811efe63>] file_remove_suid+0x43/0xc0
[35127.543130]  [<ffffffff8129def0>] ? jbd2_journal_stop+0x1c0/0x3b0
[35127.555322]  [<ffffffff81164f86>] __generic_file_write_iter+0x126/0x350
[35127.567068]  [<ffffffff81250c00>] ext4_file_write_iter+0xf0/0x3a0
[35127.578833]  [<ffffffff811d51a1>] new_sync_write+0x81/0xb0
[35127.589820]  [<ffffffff811d5957>] vfs_write+0xb7/0x1f0
[35127.600817]  [<ffffffff811d64f6>] SyS_write+0x46/0xb0
[35127.611291]  [<ffffffff8177108d>] system_call_fastpath+0x1a/0x1f

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
