From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 38852] New: Oops in page_waitqueue during large copy to ext4
 filesystem
Date: Wed, 6 Jul 2011 13:47:40 GMT
Message-ID: <bug-38852-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter1.kernel.org ([140.211.167.39]:50264 "EHLO
	demeter1.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751981Ab1GFNrl (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 6 Jul 2011 09:47:41 -0400
Received: from demeter1.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter1.kernel.org (8.14.4/8.14.4) with ESMTP id p66DleRZ025997
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Wed, 6 Jul 2011 13:47:40 GMT
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=38852

           Summary: Oops in page_waitqueue during large copy to ext4
                    filesystem
           Product: File System
           Version: 2.5
    Kernel Version: 2.6.39.2 (Debian)
          Platform: All
        OS/Version: Linux
              Tree: Mainline
            Status: NEW
          Severity: normal
          Priority: P1
         Component: ext4
        AssignedTo: fs_ext4@kernel-bugs.osdl.org
        ReportedBy: jim@jtan.com
        Regression: No


This is with Debian's linux-image-2.6.39-2 package (version 2.6.39-3).

While copying data from a 7T ext3 filesystem to a 15T ext4 filesystem using
  rsync -av /old/ /new
and simultaneously running two copies of
  watch -n 0.25 df -m /old /new

I got the oops below.

Interestingly: the bad address (0001b90) and function (page_waitqueue) is the
same as in these oopses I found online:
  http://lists.suse.com/opensuse-bugs/2011-06/msg00108.html
  http://pastebin.com/pedzNbkb


Jul  6 00:18:33 bucket kernel: [35046.620471] BUG: unable to handle kernel
paging request at 0000000000001b90
Jul  6 00:18:33 bucket kernel: [35046.622410] IP: [<ffffffff810b5175>]
page_waitqueue+0x55/0x6d
Jul  6 00:18:33 bucket kernel: [35046.624016] PGD 143151067 PUD 1afb09067 PMD 0 
Jul  6 00:18:33 bucket kernel: [35046.624016] Oops: 0000 [#1] SMP 
Jul  6 00:18:33 bucket kernel: [35046.624016] last sysfs file:
/sys/devices/virtual/block/dm-3/dm/name
Jul  6 00:18:33 bucket kernel: [35046.624016] CPU 0 
Jul  6 00:18:33 bucket kernel: [35046.624016] Modules linked in: ext4 jbd2
crc16 dm_mirror dm_region_hash dm_log ppdev lp tun act_police cls_flow cls_fw
cls_u32 sch_tbf sch_prio sch_htb sch_hfsc sch_ingress sch_sfq bridge stp
xt_time xt_connlimit xt_realm xt_addrtype iptable_raw xt_comment xt_recent
xt_policy ipt_ULOG ipt_REJECT ipt_REDIRECT ipt_NETMAP ipt_MASQUERADE ipt_ECN
ipt_ecn ipt_CLUSTERIP ipt_ah nf_nat_tftp nf_nat_snmp_basic nf_conntrack_snmp
nf_nat_sip nf_nat_pptp nf_nat_proto_gre nf_nat_irc nf_nat_h323 nf_nat_ftp
nf_nat_amanda ts_kmp nf_conntrack_amanda nf_conntrack_sane nf_conntrack_tftp
nf_conntrack_sip nf_conntrack_proto_sctp nf_conntrack_pptp
nf_conntrack_proto_gre nf_conntrack_netlink nf_conntrack_netbios_ns
nf_conntrack_broadcast nf_conntrack_irc nf_conntrack_h323 nf_conntrack_ftp
xt_TPROXY nf_tproxy_core ip6_tables nf_defrag_ipv6 xt_tcpmss xt_pkttype
xt_physdev xt_owner xt_NFQUEUE xt_NFLOG nfnetlink_log xt_multiport xt_mark
xt_mac xt_limit xt_length xt_iprange xt_helper xt_hashlimit xt_DSCP xt_
Jul  6 00:18:33 bucket kernel: scp xt_dccp xt_conntrack xt_connmark xt_CLASSIFY
xt_AUDIT ipt_LOG xt_tcpudp xt_state iptable_nat nf_nat nf_conntrack_ipv4
nf_defrag_ipv4 nf_conntrack iptable_mangle nfnetlink iptable_filter ip_tables
x_tables fuse nfsd nfs lockd fscache auth_rpcgss nfs_acl sunrpc sit tunnel4
firewire_sbp2 loop raid456 async_raid6_recov async_pq raid6_pq async_xor xor
async_memcpy async_tx kvm_amd kvm snd_hda_codec_hdmi snd_hda_codec_analog
snd_hda_intel snd_hda_codec snd_hwdep snd_pcm_oss snd_mixer_oss radeon snd_pcm
ttm drm_kms_helper drm snd_timer pl2303 i2c_algo_bit snd i2c_nforce2
amd64_edac_mod usbserial soundcore i2c_core psmouse shpchp serio_raw edac_core
snd_page_alloc evdev pcspkr edac_mce_amd pci_hotplug power_supply parport_pc
asus_atk0110 parport k8temp processor button ext3 jbd mbcache dm_mod raid1
md_mod ata_generic sd_mod crc_t10dif ohci_hcd firewire_ohci sata_sil24 sata_nv
firewire_core pata_amd crc_itu_t libata ehci_hcd usbcore scsi_mod fan thermal
thermal_sys forcedeth [last unlo
Jul  6 00:18:33 bucket kernel: : scsi_wait_scan]
Jul  6 00:18:33 bucket kernel: [35046.635406] 
Jul  6 00:18:33 bucket kernel: [35046.635406] Pid: 19788, comm: flush-253:3 Not
tainted 2.6.39-2-amd64 #1 System manufacturer System Product Name/M2N32 WS
Professional
Jul  6 00:18:33 bucket kernel: [35046.635406] RIP: 0010:[<ffffffff810b5175>] 
[<ffffffff810b5175>] page_waitqueue+0x55/0x6d
Jul  6 00:18:33 bucket kernel: [35046.635406] RSP: 0018:ffff8800b138ba48 
EFLAGS: 00010207
Jul  6 00:18:33 bucket kernel: [35046.635406] RAX: 5f3fdff0e323c7d8 RBX:
ffffea000283c7d8 RCX: 0000000000000040
Jul  6 00:18:33 bucket kernel: [35046.635406] RDX: 0000000000001500 RSI:
0000000000000000 RDI: 0000000000000000
Jul  6 00:18:33 bucket kernel: [35046.635406] RBP: 00000000000003a7 R08:
f600000000000000 R09: ffff8800b138baa0
Jul  6 00:18:33 bucket kernel: [35046.635406] R10: ffff8800b138ba80 R11:
00000000000003aa R12: ffff8800b138ba90
Jul  6 00:18:33 bucket kernel: [35046.635406] R13: ffff880026df4690 R14:
ffff8800b138bb18 R15: ffff8800b138baa0
Jul  6 00:18:33 bucket kernel: [35046.635406] FS:  00007fcd7e9db700(0000)
GS:ffff8801bfc00000(0000) knlGS:0000000000000000
Jul  6 00:18:33 bucket kernel: [35046.635406] CS:  0010 DS: 0000 ES: 0000 CR0:
000000008005003b
Jul  6 00:18:33 bucket kernel: [35046.635406] CR2: 0000000000001b90 CR3:
000000018da84000 CR4: 00000000000006f0
Jul  6 00:18:33 bucket kernel: [35046.635406] DR0: 0000000000000000 DR1:
0000000000000000 DR2: 0000000000000000
Jul  6 00:18:33 bucket kernel: [35046.635406] DR3: 0000000000000000 DR6:
00000000ffff0ff0 DR7: 0000000000000400
Jul  6 00:18:33 bucket kernel: [35046.635406] Process flush-253:3 (pid: 19788,
threadinfo ffff8800b138a000, task ffff8801b5b0c8e0)
Jul  6 00:18:33 bucket kernel: [35046.635406] Stack:
Jul  6 00:18:33 bucket kernel: [35046.635406]  ffffffff810b5ecd
00000000000003a7 ffffffffa082092f ffff8800b138baa0
Jul  6 00:18:33 bucket kernel: [35046.635406]  000000000000000e
ffffea000283c7d8 00000000000003a7 ffff8800b138baf8
Jul  6 00:18:33 bucket kernel: [35046.635406]  0000000000008000
000000000000000e 0000000000000000 ffffea00004963c8
Jul  6 00:18:33 bucket kernel: [35046.635406] Call Trace:
Jul  6 00:18:33 bucket kernel: [35046.635406]  [<ffffffff810b5ecd>] ?
unlock_page+0x10/0x1e
Jul  6 00:18:33 bucket kernel: [35046.635406]  [<ffffffffa082092f>] ?
ext4_num_dirty_pages+0xf1/0x204 [ext4]
Jul  6 00:18:33 bucket kernel: [35046.635406]  [<ffffffffa0820ebd>] ?
ext4_da_writepages+0x16d/0x424 [ext4]
Jul  6 00:18:33 bucket kernel: [35046.635406]  [<ffffffff8111783f>] ?
writeback_single_inode+0xb8/0x1b8
Jul  6 00:18:33 bucket kernel: [35046.635406]  [<ffffffff81117cdc>] ?
writeback_sb_inodes+0xc2/0x13b
Jul  6 00:18:33 bucket kernel: [35046.635406]  [<ffffffff8111857b>] ?
writeback_inodes_wb+0xfd/0x10f
Jul  6 00:18:33 bucket kernel: [35046.635406]  [<ffffffff8111879f>] ?
wb_writeback+0x212/0x32d
Jul  6 00:18:33 bucket kernel: [35046.635406]  [<ffffffff81051e71>] ?
lock_timer_base+0x25/0x49
Jul  6 00:18:33 bucket kernel: [35046.635406]  [<ffffffff81118a26>] ?
wb_do_writeback+0x16c/0x1fb
Jul  6 00:18:33 bucket kernel: [35046.635406]  [<ffffffff81051f43>] ?
del_timer_sync+0x34/0x3e
Jul  6 00:18:33 bucket kernel: [35046.635406]  [<ffffffff81118b77>] ?
bdi_writeback_thread+0xc2/0x1fb
Jul  6 00:18:33 bucket kernel: [35046.635406]  [<ffffffff81118ab5>] ?
wb_do_writeback+0x1fb/0x1fb
Jul  6 00:18:33 bucket kernel: [35046.635406]  [<ffffffff8105ef15>] ?
kthread+0x7a/0x82
Jul  6 00:18:33 bucket kernel: [35046.635406]  [<ffffffff81339f64>] ?
kernel_thread_helper+0x4/0x10
Jul  6 00:18:33 bucket kernel: [35046.635406]  [<ffffffff8105ee9b>] ?
kthread_worker_fn+0x147/0x147
Jul  6 00:18:33 bucket kernel: [35046.635406]  [<ffffffff81339f60>] ?
gs_change+0x13/0x13
Jul  6 00:18:33 bucket kernel: [35046.635406] Code: 07 00 00 48 03 14 c5 90 30
68 81 48 b8 01 00 fc ff ff ff f7 ff 48 0f af c7 48 c1 e7 3f 4c 01 c0 48 01 f0
48 29 c8 b9 40 00 00 00 <2b> 8a 90 06 00 00 48 01 f8 48 d3 e8 48 6b c0 18 48 03
82 80 06 
Jul  6 00:18:33 bucket kernel: [35046.635406] RIP  [<ffffffff810b5175>]
page_waitqueue+0x55/0x6d
Jul  6 00:18:33 bucket kernel: [35046.635406]  RSP <ffff8800b138ba48>
Jul  6 00:18:33 bucket kernel: [35046.635406] CR2: 0000000000001b90
Jul  6 00:18:34 bucket kernel: [35047.179525] ---[ end trace a9a928c8a40241df
]---

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
