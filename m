From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 13549] New: Kernel oops while online resizing of an ext4
 filesystem
Date: Tue, 16 Jun 2009 09:13:54 GMT
Message-ID: <bug-13549-13602@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:53403 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752042AbZFPJNw (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 16 Jun 2009 05:13:52 -0400
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.2/8.14.2) with ESMTP id n5G9DsbY019936
	for <linux-ext4@vger.kernel.org>; Tue, 16 Jun 2009 09:13:54 GMT
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

http://bugzilla.kernel.org/show_bug.cgi?id=13549

           Summary: Kernel oops while online resizing of an ext4
                    filesystem
           Product: File System
           Version: 2.5
    Kernel Version: 2.6.29-2-amd64
          Platform: All
        OS/Version: Linux
              Tree: Mainline
            Status: NEW
          Severity: normal
          Priority: P1
         Component: ext4
        AssignedTo: fs_ext4@kernel-bugs.osdl.org
        ReportedBy: alex@nibbles.it
        Regression: No


I extended the device with lvm, then I tried to resize2f the filesystem and I
got these errors:

Jun 16 09:49:00 nb1a kernel: [677830.909054] PGD 5bf79067 PUD 59768067 PMD 0
Jun 16 09:49:00 nb1a kernel: [677830.909144] CPU 1
Jun 16 09:49:00 nb1a kernel: [677830.909163] Modules linked in: ext4 jbd2 crc16
tun ip6table_filter ip6_tables iptable_raw xt_comment xt_recent xt_po
licy ipt_ULOG ipt_TTL ipt_ttl ipt_REJECT ipt_REDIRECT ipt_NETMAP ipt_MASQUERADE
ipt_LOG ipt_ECN ipt_ecn ipt_CLUSTERIP ipt_ah ipt_addrtype nf_nat_tftp
 nf_nat_snmp_basic nf_nat_sip nf_nat_pptp nf_nat_proto_gre nf_nat_irc
nf_nat_h323 nf_nat_ftp nf_nat_amanda ts_kmp nf_conntrack_amanda nf_conntrack_tf
tp nf_conntrack_sip nf_conntrack_proto_sctp nf_conntrack_pptp
nf_conntrack_proto_gre nf_conntrack_netlink nf_conntrack_netbios_ns
nf_conntrack_irc nf
_conntrack_h323 nf_conntrack_ftp xt_tcpmss xt_pkttype xt_physdev xt_owner
xt_NFQUEUE xt_NFLOG nfnetlink_log xt_multiport xt_MARK xt_mark xt_mac xt_li
mit xt_length xt_iprange xt_helper xt_hashlimit xt_DSCP xt_dscp xt_dccp
xt_conntrack xt_CONNMARK xt_connmark xt_CLASSIFY xt_tcpudp xt_state iptable_n
at nf_nat nf_conntrack_ipv4 nf_defrag_ipv4 nf_conntrack iptable_mangle
iptable_filter ip_tables x_tables nfnetlink drbd cn autofs4
Jun 16 09:49:00 nb1a kernel: nfsd nfs lockd nfs_acl auth_rpcgss sunrpc ipv6
quota_v2 quota_tree xfs exportfs loop firewire_sbp2 firewire_core crc_itu
_t evdev snd_pcm snd_timer snd soundcore pcspkr snd_page_alloc psmouse
serio_raw k8temp shpchp pci_hotplug i2c_nforce2 i2c_core button ext3 jbd mbcac
he dm_mirror dm_region_hash dm_log dm_snapshot dm_mod ide_cd_mod cdrom
ide_pci_generic sd_mod crc_t10dif amd74xx ide_core sata_nv floppy 3w_9xxx r816
9 mii ata_generic forcedeth libata scsi_mod ehci_hcd ohci_hcd thermal processor
fan thermal_sys
Jun 16 09:49:00 nb1a kernel: [677830.909795] Pid: 4620, comm: resize2fs Not
tainted 2.6.29-2-amd64 #1 H8DM8-2
Jun 16 09:49:00 nb1a kernel: [677830.909822] RIP: 0010:[<ffffffffa069a97e>] 
[<ffffffffa069a97e>] ext4_group_add+0x135c/0x143e [ext4]
Jun 16 09:49:00 nb1a kernel: [677830.909875] RSP: 0000:ffff8800b6f29c48 
EFLAGS: 00010202
Jun 16 09:49:00 nb1a kernel: [677830.909900] RAX: 000000000000b8c8 RBX:
ffff880157a38000 RCX: 000000000000b8c8
Jun 16 09:49:00 nb1a kernel: [677830.909940] RDX: 0000000000007dfe RSI:
ffff8800b6f29e48 RDI: ffff880157a380e8
Jun 16 09:49:00 nb1a kernel: [677830.909981] RBP: 0000000000000000 R08:
0000000000000000 R09: 0000000000000000
Jun 16 09:49:00 nb1a kernel: [677830.910022] R10: 0000000000001719 R11:
0000000000000002 R12: 0000000000000000
Jun 16 09:49:00 nb1a kernel: [677830.910062] R13: ffff8802118e1800 R14:
ffff8800263e93f0 R15: 0000000000000200
Jun 16 09:49:00 nb1a kernel: [677830.910103] FS:  00007f2decdc6700(0000)
GS:ffff88021ea99e40(0000) knlGS:0000000000000000
Jun 16 09:49:00 nb1a kernel: [677830.910146] CS:  0010 DS: 0000 ES: 0000 CR0:
000000008005003b
Jun 16 09:49:00 nb1a kernel: [677830.910171] CR2: 000000000000b8cc CR3:
0000000083b24000 CR4: 00000000000006e0
Jun 16 09:49:00 nb1a kernel: [677830.910212] DR0: 0000000000000000 DR1:
0000000000000000 DR2: 0000000000000000
Jun 16 09:49:00 nb1a kernel: [677830.910253] DR3: 0000000000000000 DR6:
00000000ffff0ff0 DR7: 0000000000000400
Jun 16 09:49:00 nb1a kernel: [677830.910294] Process resize2fs (pid: 4620,
threadinfo ffff8800b6f28000, task ffff8801fe4e8000)
Jun 16 09:49:00 nb1a kernel: [677830.910355]  ffffffff80479d3c 0000000000000202
000000000000d2c7 ffffffff802846db
Jun 16 09:49:00 nb1a kernel: [677830.911053]  RSP <ffff8800b6f29c48>
Jun 16 09:49:00 nb1a kernel: [677830.911364] ---[ end trace 46ff5ad2da854d81
]---
Jun 16 09:49:00 nb1a kernel: [677830.911423] ------------[ cut here
]------------



Jun 16 09:49:00 nb1a kernel: [677830.911479] WARNING: at
/build/buildd/linux-2.6-2.6.29/debian/build/source_amd64_none/kernel/exit.c:983
do_exit+0x41/0x7b1()
Jun 16 09:49:00 nb1a kernel: [677830.911560] Hardware name: H8DM8-2
Jun 16 09:49:00 nb1a kernel: [677830.911614] Modules linked in: ext4 jbd2 crc16
tun ip6table_filter ip6_tables iptable_raw xt_comment xt_recent xt_policy
ipt_ULOG ipt_TTL ipt_ttl ipt_REJECT ipt_REDIRECT ipt_NETMAP ipt_MASQUERADE
ipt_LOG ipt_ECN ipt_ecn ipt_CLUSTERIP ipt_ah ipt_addrtype nf_nat_tftp
nf_nat_snmp_basic nf_nat_sip nf_nat_pptp nf_nat_proto_gre nf_nat_irc
nf_nat_h323 nf_nat_ftp nf_nat_amanda ts_kmp nf_conntrack_amanda
nf_conntrack_tftp nf_conntrack_sip nf_conntrack_proto_sctp nf_conntrack_pptp
nf_conntrack_proto_gre nf_conntrack_netlink nf_conntrack_netbios_ns
nf_conntrack_irc nf_conntrack_h323 nf_conntrack_ftp xt_tcpmss xt_pkttype
xt_physdev xt_owner xt_NFQUEUE xt_NFLOG nfnetlink_log xt_multiport xt_MARK
xt_mark xt_mac xt_limit xt_length xt_iprange xt_helper xt_hashlimit xt_DSCP
xt_dscp xt_dccp xt_conntrack xt_CONNMARK xt_connmark xt_CLASSIFY xt_tcpudp
xt_state iptable_nat nf_nat nf_conntrack_ipv4 nf_defrag_ipv4 nf_conntrack
iptable_mangle iptable_filter ip_tables x_tables nfnetlink drbd cn autofs4
Jun 16 09:49:00 nb1a kernel: nfsd nfs lockd nfs_acl auth_rpcgss sunrpc ipv6
quota_v2 quota_tree xfs exportfs loop firewire_sbp2 firewire_core crc_itu_t
evdev snd_pcm snd_timer snd soundcore pcspkr snd_page_alloc psmouse serio_raw
k8temp shpchp pci_hotplug i2c_nforce2 i2c_core button ext3 jbd mbcache
dm_mirror dm_region_hash dm_log dm_snapshot dm_mod ide_cd_mod cdrom
ide_pci_generic sd_mod crc_t10dif amd74xx ide_core sata_nv floppy 3w_9xxx r8169
mii ata_generic forcedeth libata scsi_mod ehci_hcd ohci_hcd thermal processor
fan thermal_sys
Jun 16 09:49:00 nb1a kernel: [677830.921994] Pid: 4620, comm: resize2fs
Tainted: G      D    2.6.29-2-amd64 #1
Jun 16 09:49:00 nb1a kernel: [677830.922067] Call Trace:
Jun 16 09:49:00 nb1a kernel: [677830.922121]  [<ffffffff80243a29>]
warn_slowpath+0xd8/0x112
Jun 16 09:49:00 nb1a kernel: [677830.922181]  [<ffffffff80227dbc>]
default_spin_lock_flags+0x5/0x9
Jun 16 09:49:00 nb1a kernel: [677830.922240]  [<ffffffff80479d3c>]
_spin_lock_irqsave+0x24/0x2c
Jun 16 09:49:00 nb1a kernel: [677830.922299]  [<ffffffff80479d3c>]
_spin_lock_irqsave+0x24/0x2c
Jun 16 09:49:00 nb1a kernel: [677830.922358]  [<ffffffff8024412a>]
release_console_sem+0x197/0x1cc
Jun 16 09:49:00 nb1a kernel: [677830.922419]  [<ffffffff80477eac>]
printk+0x4e/0x5a
Jun 16 09:49:00 nb1a kernel: [677830.922476]  [<ffffffff80227dbc>]
default_spin_lock_flags+0x5/0x9
Jun 16 09:49:00 nb1a kernel: [677830.922536]  [<ffffffff80246bb4>]
do_exit+0x41/0x7b1
Jun 16 09:49:00 nb1a kernel: [677830.922594]  [<ffffffff802592cc>] up+0xe/0x36
Jun 16 09:49:00 nb1a kernel: [677830.922650]  [<ffffffff80479d3c>]
_spin_lock_irqsave+0x24/0x2c
Jun 16 09:49:00 nb1a kernel: [677830.922709]  [<ffffffff8024412a>]
release_console_sem+0x197/0x1cc
Jun 16 09:49:00 nb1a kernel: [677830.922769]  [<ffffffff80214d99>]
oops_end+0xb6/0xbb
Jun 16 09:49:00 nb1a kernel: [677830.922827]  [<ffffffff8022e86a>]
do_page_fault+0x8c4/0x966
Jun 16 09:49:00 nb1a kernel: [677830.922887]  [<ffffffff80292096>]
__rmqueue_smallest+0xa6/0x126
Jun 16 09:49:00 nb1a kernel: [677830.922947]  [<ffffffff80292133>]
__rmqueue+0x1d/0x1fd
Jun 16 09:49:00 nb1a kernel: [677830.923005]  [<ffffffff80211b8e>]
common_interrupt+0xe/0x13
Jun 16 09:49:00 nb1a kernel: [677830.923066]  [<ffffffff80344070>]
cfq_set_request+0x0/0x30e
Jun 16 09:49:00 nb1a kernel: [677830.923124]  [<ffffffff8029238f>]
rmqueue_bulk+0x7c/0x8c
Jun 16 09:49:00 nb1a kernel: [677830.923184]  [<ffffffff8029e2a1>]
zone_statistics+0x3c/0x5f
Jun 16 09:49:00 nb1a kernel: [677830.923243]  [<ffffffff80292096>]
__rmqueue_smallest+0xa6/0x126
Jun 16 09:49:00 nb1a kernel: [677830.923303]  [<ffffffff8029e2a1>]
zone_statistics+0x3c/0x5f
Jun 16 09:49:00 nb1a kernel: [677830.923362]  [<ffffffff802943cc>]
__alloc_pages_internal+0xd2/0x422
Jun 16 09:49:00 nb1a kernel: [677830.923421]  [<ffffffff80479de2>]
_spin_lock+0x5/0x7
Jun 16 09:49:00 nb1a kernel: [677830.923483]  [<ffffffffa06761cd>]
__jbd2_journal_temp_unlink_buffer+0x35/0xf5 [jbd2]
Jun 16 09:49:00 nb1a kernel: [677830.923562]  [<ffffffffa067633b>]
__jbd2_journal_file_buffer+0xae/0x144 [jbd2]
Jun 16 09:49:00 nb1a kernel: [677830.923640]  [<ffffffffa06773a5>]
do_get_write_access+0x3cf/0x414 [jbd2]
Jun 16 09:49:00 nb1a kernel: [677830.923700]  [<ffffffff80479de2>]
_spin_lock+0x5/0x7
Jun 16 09:49:00 nb1a kernel: [677830.923758]  [<ffffffff8047a0c5>]
page_fault+0x25/0x30
Jun 16 09:49:00 nb1a kernel: [677830.923824]  [<ffffffffa069a97e>]
ext4_group_add+0x135c/0x143e [ext4]
Jun 16 09:49:00 nb1a kernel: [677830.923891]  [<ffffffffa069a946>]
ext4_group_add+0x1324/0x143e [ext4]
Jun 16 09:49:00 nb1a kernel: [677830.923951]  [<ffffffff80479d3c>]
_spin_lock_irqsave+0x24/0x2c
Jun 16 09:49:00 nb1a kernel: [677830.924011]  [<ffffffff802846db>]
delayacct_end+0x7d/0x88
Jun 16 09:49:00 nb1a kernel: [677830.924070]  [<ffffffff802db3d0>]
sync_dirty_buffer+0x5f/0x98
Jun 16 09:49:00 nb1a kernel: [677830.924128]  [<ffffffff80479de2>]
_spin_lock+0x5/0x7
Jun 16 09:49:00 nb1a kernel: [677830.924189]  [<ffffffffa067b5bb>]
jbd2_journal_update_superblock+0x133/0x13f [jbd2]
Jun 16 09:49:00 nb1a kernel: [677830.924279]  [<ffffffff80479de2>]
_spin_lock+0x5/0x7
Jun 16 09:49:00 nb1a kernel: [677830.924344]  [<ffffffffa06905df>]
ext4_ioctl+0x4dd/0x5d8 [ext4]
Jun 16 09:49:00 nb1a kernel: [677830.924403]  [<ffffffff8023f8a3>]
finish_task_switch+0x2a/0xc7
Jun 16 09:49:00 nb1a kernel: [677830.924463]  [<ffffffff802c869e>]
vfs_ioctl+0x21/0x6c
Jun 16 09:49:00 nb1a kernel: [677830.924521]  [<ffffffff802c8b22>]
do_vfs_ioctl+0x439/0x472
Jun 16 09:49:00 nb1a kernel: [677830.924580]  [<ffffffff802bdaaf>]
vfs_write+0xcd/0x102
Jun 16 09:49:00 nb1a kernel: [677830.924638]  [<ffffffff802c8bac>]
sys_ioctl+0x51/0x70
Jun 16 09:49:00 nb1a kernel: [677830.924696]  [<ffffffff802110aa>]
system_call_fastpath+0x16/0x1b
Jun 16 09:49:00 nb1a kernel: [677830.924756] ---[ end trace 46ff5ad2da854d82
]---
Jun 16 09:49:00 nb1a kernel: [677830.924189]  [<ffffffffa067b5bb>]
jbd2_journal_update_superblock+0x133/0x13f [jbd2]
Jun 16 09:49:00 nb1a kernel: [677830.924279]  [<ffffffff80479de2>]
_spin_lock+0x5/0x7
Jun 16 09:49:00 nb1a kernel: [677830.924344]  [<ffffffffa06905df>]
ext4_ioctl+0x4dd/0x5d8 [ext4]
Jun 16 09:49:00 nb1a kernel: [677830.924403]  [<ffffffff8023f8a3>]
finish_task_switch+0x2a/0xc7
Jun 16 09:49:00 nb1a kernel: [677830.924463]  [<ffffffff802c869e>]
vfs_ioctl+0x21/0x6c
Jun 16 09:49:00 nb1a kernel: [677830.924521]  [<ffffffff802c8b22>]
do_vfs_ioctl+0x439/0x472
Jun 16 09:49:00 nb1a kernel: [677830.924580]  [<ffffffff802bdaaf>]
vfs_write+0xcd/0x102
Jun 16 09:49:00 nb1a kernel: [677830.924638]  [<ffffffff802c8bac>]
sys_ioctl+0x51/0x70
Jun 16 09:49:00 nb1a kernel: [677830.924696]  [<ffffffff802110aa>]
system_call_fastpath+0x16/0x1b
Jun 16 09:49:00 nb1a kernel: [677830.924756] ---[ end trace 46ff5ad2da854d82
]---

P.S.: Please add "debian" on the tree dropdown, exact debian package is:
linux-image-2.6.29-2-amd64 version 2.6.29-5

-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
