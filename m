From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 47731] New: Null pointer dereference at strchr
Date: Wed, 19 Sep 2012 21:50:27 +0000 (UTC)
Message-ID: <bug-47731-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:49539 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752113Ab2ISVua (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 19 Sep 2012 17:50:30 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 71E5320377
	for <linux-ext4@vger.kernel.org>; Wed, 19 Sep 2012 21:50:29 +0000 (UTC)
Received: from bugzilla.kernel.org (unknown [198.145.19.217])
	by mail.kernel.org (Postfix) with ESMTP id 6070520376
	for <linux-ext4@vger.kernel.org>; Wed, 19 Sep 2012 21:50:28 +0000 (UTC)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=47731

           Summary: Null pointer dereference at strchr
           Product: File System
           Version: 2.5
    Kernel Version: 3.5.4
          Platform: All
        OS/Version: Linux
              Tree: Mainline
            Status: NEW
          Severity: normal
          Priority: P1
         Component: ext4
        AssignedTo: fs_ext4@kernel-bugs.osdl.org
        ReportedBy: brad.figg@canonical.com
        Regression: No


This is a 3.5.0-15.20 Ubuntu kernel. 

I was running xfstests and got this oops. I am not sure which test caused it
but the last test being run was 234.


Nov  1 02:52:47 rizzo kernel: [11454.238205] BUG: unable to handle kernel NULL
pointer dereference at 000000e5
Nov  1 02:52:47 rizzo kernel: [11454.249565] IP: [<c12d367f>] strchr+0xf/0x30
Nov  1 02:52:47 rizzo kernel: [11454.260460] *pdpt = 0000000036dd7001 *pde =
0000000000000000
Nov  1 02:52:47 rizzo kernel: [11454.271359] Oops: 0000 [#1] SMP
Nov  1 02:52:47 rizzo kernel: [11454.282094] Modules linked in: quota_v2
quota_tree nf_conntrack_ipv6 nf_defrag_ipv6 ip6table_filter ip6_tables
xt_recent nf_conntrack_ipv4 nf_defrag_ipv4 xt_state nf_conntrack iptable_filter
ip_tables x_tables bluetooth pppoe pppox irda crc_ccitt atm p8022 psnap llc
p8023 ax25 btrfs zlib_deflate libcrc32c xfs ext2 dm_multipath scsi_dh vesafb
coretemp kvm_intel kvm joydev i7core_edac edac_core gpio_ich microcode lpc_ich
dcdbas mac_hid acpi_power_meter lp parport hid_generic usbhid hid mpt2sas bnx2
scsi_transport_sas raid_class [last unloaded: tipc]
Nov  1 02:52:47 rizzo kernel: [11454.314893]
Nov  1 02:52:47 rizzo kernel: [11454.314895] Pid: 32681, comm: setquota
Tainted: G           O 3.5.0-15-generic #20-Ubuntu Dell Inc. PowerEdge
R310/05XKKK
Nov  1 02:52:47 rizzo kernel: [11454.314898] EIP: 0060:[<c12d367f>] EFLAGS:
00210246 CPU: 3
Nov  1 02:52:47 rizzo kernel: [11454.314900] EIP is at strchr+0xf/0x30
Nov  1 02:52:47 rizzo kernel: [11454.314901] EAX: 00003d3d EBX: c15ebbf0 ECX:
00280000 EDX: 0000003d
Nov  1 02:52:47 rizzo kernel: [11454.314902] ESI: 000000e5 EDI: d250fc00 EBP:
ef2e3eac ESP: ef2e3ea8
Nov  1 02:52:47 rizzo kernel: [11454.314903]  DS: 007b ES: 007b FS: 00d8 GS:
00e0 SS: 0068
Nov  1 02:52:47 rizzo kernel: [11454.314904] CR0: 8005003b CR2: 000000e5 CR3:
291c4000 CR4: 000007f0
Nov  1 02:52:47 rizzo kernel: [11454.314905] DR0: 00000000 DR1: 00000000 DR2:
00000000 DR3: 00000000
Nov  1 02:52:47 rizzo kernel: [11454.314906] DR6: ffff0ff0 DR7: 00000400
Nov  1 02:52:47 rizzo kernel: [11454.314907] Process setquota (pid: 32681,
ti=ef2e2000 task=c2943f70 task.ti=ef2e2000)
Nov  1 02:52:47 rizzo kernel: [11454.314908] Stack:
Nov  1 02:52:47 rizzo kernel: [11454.314908]  0000002d ef2e3ef8 c11e35df
d2a67de0 c17925fd 0000002c c1791a80 c1161fc4
Nov  1 02:52:47 rizzo kernel: [11454.314913]  8c3ac810 0000002c e9e77400
8c02c010 ef2e3eec d250d800 00000000 2ca67de0
Nov  1 02:52:47 rizzo kernel: [11454.314917]  d2a67de0 d2a67de0 c11e3930
f6c62a90 ef2e3f00 c11e3942 ef2e3f20 c1184e39
Nov  1 02:52:47 rizzo kernel: [11454.314921] Call Trace:
Nov  1 02:52:47 rizzo kernel: [11454.314923]  [<c11e35df>]
_ext4_show_options+0x37f/0x6d0
Nov  1 02:52:47 rizzo kernel: [11454.314927]  [<c1161fc4>] ? d_path+0xb4/0xd0
Nov  1 02:52:47 rizzo kernel: [11454.314930]  [<c11e3930>] ?
_ext4_show_options+0x6d0/0x6d0
Nov  1 02:52:47 rizzo kernel: [11454.314932]  [<c11e3942>]
ext4_show_options+0x12/0x20
Nov  1 02:52:47 rizzo kernel: [11454.314934]  [<c1184e39>]
show_vfsmnt+0xc9/0x110
Nov  1 02:52:47 rizzo kernel: [11454.314936]  [<c11684f0>] m_show+0x10/0x20
Nov  1 02:52:47 rizzo kernel: [11454.314939]  [<c116c1c4>] seq_read+0x244/0x3c0
Nov  1 02:52:47 rizzo kernel: [11454.314941]  [<c116bf80>] ?
seq_lseek+0x150/0x150
Nov  1 02:52:47 rizzo kernel: [11454.314943]  [<c114f159>] vfs_read+0x89/0x160
Nov  1 02:52:47 rizzo kernel: [11454.314946]  [<c116bf80>] ?
seq_lseek+0x150/0x150
Nov  1 02:52:47 rizzo kernel: [11454.314948]  [<c114f26d>] sys_read+0x3d/0x70
Nov  1 02:52:47 rizzo kernel: [11454.314950]  [<c15cf65f>]
sysenter_do_call+0x12/0x28
Nov  1 02:52:47 rizzo kernel: [11454.314954] Code: 19 c0 0c 01 8b 75 f8 8b 7d
fc 89 ec 5d c3 8d b4 26 00 00 00 00 8d bc 27 00 00 00 00 55 89 e5 56 66 66 66
66 90 89 c6 89 d0 88 c4 <ac> 38 e0 74 09 84 c0 75 f7 be 01 00 00 00 89 f0 48 5e
5d c3 8d
Nov  1 02:52:47 rizzo kernel: [11454.314979] EIP: [<c12d367f>] strchr+0xf/0x30
SS:ESP 0068:ef2e3ea8
Nov  1 02:52:47 rizzo kernel: [11454.314981] CR2: 00000000000000e5

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
