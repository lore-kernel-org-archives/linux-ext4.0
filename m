From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 13549] Kernel oops while online resizing of an ext4 filesystem
Date: Sat, 20 Mar 2010 21:53:49 GMT
Message-ID: <201003202153.o2KLrn0R027543@demeter.kernel.org>
References: <bug-13549-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:57392 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750808Ab0CTVxv (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 20 Mar 2010 17:53:51 -0400
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.3/8.14.3) with ESMTP id o2KLrnJE027545
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Sat, 20 Mar 2010 21:53:50 GMT
In-Reply-To: <bug-13549-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=13549





--- Comment #4 from Alessandro Polverini <alex@nibbles.it>  2010-03-20 21:53:31 ---
I updated to debian kernel 2.6.32-3-amd64 and I can reproduce the problem.
When trying to resize the fs I got this on the console:

nb1a kernel: [ 2518.347172] Oops: 0002 [#1] SMP
Message from syslogd@nb1a at Sat Mar 20 22:44:02 2010 ...
nb1a kernel: [ 2518.347195] last sysfs file:
/sys/devices/pci0000:00/0000:00:01.1/i2c-1/1-002c/fan8_input
nb1a kernel: [ 2518.348350] Stack:
nb1a kernel: [ 2518.348699] Call Trace:
nb1a kernel: [ 2518.348699] Code: 48 8b 74 24 50 48 8b 7c 24 50 8b 8b 40 03 00
00 8b 06 8b 57 28 d3 e8 89 c0 48 6b c0 0c 48 89 c1 48 03 8b 48 03 00 00 48 8d
71 04 <f0> 01 51 04 49 8b 95 80 02 00 00 48 03 83 48 03 00 00 8b 52 18
nb1a kernel: [ 2518.348699] CR2: 00000000000153d0

While this is what I can see in /var/log/messages:

Mar 20 22:44:02 nb1a kernel: [ 2518.347146] PGD 41d326067 PUD 41d5c5067 PMD 0 
Mar 20 22:44:02 nb1a kernel: [ 2518.347239] CPU 0 
Mar 20 22:44:02 nb1a kernel: [ 2518.347259] Modules linked in: tun
ip6table_filter ip6_tables iptable_raw xt_comment xt_recent xt_policy ipt_ULOG
ipt_REJECT ipt_REDIRECT ipt_NETMAP ipt_MASQUERADE ipt_LOG ipt_ECN ipt_ecn
ipt_CLUSTERIP ipt_ah ipt_addrtype nf_nat_tftp nf_nat_snmp_basic nf_nat_sip
nf_nat_pptp nf_nat_proto_gre nf_nat_irc nf_nat_h323 nf_nat_ftp nf_nat_amanda
ts_kmp nf_conntrack_amanda nf_conntrack_tftp nf_conntrack_sip
nf_conntrack_proto_sctp nf_conntrack_pptp nf_conntrack_proto_gre
nf_conntrack_netlink nf_conntrack_netbios_ns nf_conntrack_irc nf_conntrack_h323
nf_conntrack_ftp xt_tcpmss xt_pkttype xt_physdev xt_owner xt_NFQUEUE xt_NFLOG
nfnetlink_log xt_multiport xt_MARK xt_mark xt_mac xt_limit xt_length xt_iprange
xt_helper xt_hashlimit xt_DSCP xt_dscp xt_dccp xt_conntrack xt_CONNMARK
xt_connmark xt_CLASSIFY xt_tcpudp xt_state iptable_nat nf_nat nf_conntrack_ipv4
nf_defrag_ipv4 nf_conntrack iptable_mangle iptable_filter ip_tables x_tables
nfnetlink drbd cn autofs4 nfsd nfs lockd fscache nfs_acl a
Mar 20 22:44:02 nb1a kernel: th_rpcgss sunrpc xfs exportfs ext4 jbd2 crc16
w83793 w83627hf hwmon_vid ipmi_msghandler psmouse amd64_edac_mod evdev
serio_raw snd_pcm snd_timer edac_core edac_mce_amd k8temp shpchp snd soundcore
snd_page_alloc pci_hotplug button processor pcspkr i2c_nforce2 i2c_core ext3
jbd mbcache dm_mirror dm_region_hash dm_log dm_snapshot dm_mod ide_cd_mod cdrom
ide_pci_generic amd74xx ide_core sata_nv sd_mod crc_t10dif ata_generic floppy
r8169 mii 3w_9xxx ehci_hcd ohci_hcd libata forcedeth scsi_mod usbcore nls_base
thermal fan thermal_sys [last unloaded: scsi_wait_scan]
Mar 20 22:44:02 nb1a kernel: [ 2518.347914] Pid: 13590, comm: resize2fs Not
tainted 2.6.32-3-amd64 #1 H8DM8-2
Mar 20 22:44:02 nb1a kernel: [ 2518.347942] RIP: 0010:[<ffffffffa0310863>] 
[<ffffffffa0310863>] ext4_group_add+0x136c/0x1451 [ext4]
Mar 20 22:44:02 nb1a kernel: [ 2518.347992] RSP: 0018:ffff88021e7c1c38  EFLAGS:
00010206
Mar 20 22:44:02 nb1a kernel: [ 2518.348017] RAX: 00000000000153cc RBX:
ffff88041d8e7800 RCX: 00000000000153cc
Mar 20 22:44:02 nb1a kernel: [ 2518.348045] RDX: 0000000000007dfe RSI:
00000000000153d0 RDI: ffff88021e7c1e48
Mar 20 22:44:02 nb1a kernel: [ 2518.348072] RBP: ffff8801e1ed1d20 R08:
ffff88041ee03380 R09: 0000000000000000
Mar 20 22:44:02 nb1a kernel: [ 2518.348100] R10: 000000501d59c868 R11:
0000000000000200 R12: 0000000000000000
Mar 20 22:44:02 nb1a kernel: [ 2518.348128] R13: ffff88041d8e1c00 R14:
ffff88021ed67600 R15: 0000000000000200
Mar 20 22:44:02 nb1a kernel: [ 2518.348156] FS:  00007f33572bc700(0000)
GS:ffff880008c00000(0000) knlGS:0000000000000000
Mar 20 22:44:02 nb1a kernel: [ 2518.348198] CS:  0010 DS: 0000 ES: 0000 CR0:
000000008005003b
Mar 20 22:44:02 nb1a kernel: [ 2518.348224] CR2: 00000000000153d0 CR3:
000000041db72000 CR4: 00000000000006f0
Mar 20 22:44:02 nb1a kernel: [ 2518.348251] DR0: 0000000000000000 DR1:
0000000000000000 DR2: 0000000000000000
Mar 20 22:44:02 nb1a kernel: [ 2518.348279] DR3: 0000000000000000 DR6:
00000000ffff0ff0 DR7: 0000000000000400
Mar 20 22:44:02 nb1a kernel: [ 2518.348307] Process resize2fs (pid: 13590,
threadinfo ffff88021e7c0000, task ffff8801ea533170)
Mar 20 22:44:02 nb1a kernel: [ 2518.348369]  00000000fcdf07e0 ffffffff8106beb9
ffff8802098927f8 ffff880209892808
Mar 20 22:44:02 nb1a kernel: [ 2518.348399] <0> ffff8802098927e8
0000000000000292 0000000000000292 ffffffff81098f06
Mar 20 22:44:02 nb1a kernel: [ 2518.348444] <0> 0000000000000000
000080000000fed6 ffff88021e7c1e48 0000000000001c51
Mar 20 22:44:02 nb1a kernel: [ 2518.348699]  [<ffffffff8106beb9>] ?
ktime_get_ts+0x68/0xb2
Mar 20 22:44:02 nb1a kernel: [ 2518.348699]  [<ffffffff81098f06>] ?
delayacct_end+0x74/0x7f
Mar 20 22:44:02 nb1a kernel: [ 2518.348699]  [<ffffffff81064a84>] ?
wake_bit_function+0x0/0x23
Mar 20 22:44:02 nb1a kernel: [ 2518.348699]  [<ffffffff8110ca96>] ?
sync_dirty_buffer+0x5b/0x93
Mar 20 22:44:02 nb1a kernel: [ 2518.348699]  [<ffffffffa02fb804>] ?
ext4_ioctl+0x5ee/0x753 [ext4]
Mar 20 22:44:02 nb1a kernel: [ 2518.348699]  [<ffffffff810f8fa2>] ?
vfs_ioctl+0x21/0x6c
Mar 20 22:44:02 nb1a kernel: [ 2518.348699]  [<ffffffff810f94f0>] ?
do_vfs_ioctl+0x48d/0x4cb
Mar 20 22:44:02 nb1a kernel: [ 2518.348699]  [<ffffffff810edc16>] ?
vfs_write+0xcd/0x102
Mar 20 22:44:02 nb1a kernel: [ 2518.348699]  [<ffffffff810f957f>] ?
sys_ioctl+0x51/0x70
Mar 20 22:44:02 nb1a kernel: [ 2518.348699]  [<ffffffff81010b42>] ?
system_call_fastpath+0x16/0x1b
Mar 20 22:44:02 nb1a kernel: [ 2518.348699]  RSP <ffff88021e7c1c38>
Mar 20 22:44:02 nb1a kernel: [ 2518.354183] ---[ end trace 9ee7dc16cc7e9d74
]---

The size of the partition:
# df /mnt/disk2/
Filesystem           1K-blocks      Used Available Use% Mounted on
/dev/mapper/vg1-backup
                     935361592 878396176  56965416  94% /mnt/disk2

I'll now try to reboot the machine and collect to e2image -h data you
requested.

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
