From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 47731] Null pointer dereference at strchr
Date: Fri, 21 Sep 2012 04:21:34 +0000 (UTC)
Message-ID: <20120921042134.CCF2911FA29@bugzilla.kernel.org>
References: <bug-47731-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:34568 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751309Ab2IUEVi (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 21 Sep 2012 00:21:38 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 9FF7820210
	for <linux-ext4@vger.kernel.org>; Fri, 21 Sep 2012 04:21:36 +0000 (UTC)
Received: from bugzilla.kernel.org (unknown [198.145.19.217])
	by mail.kernel.org (Postfix) with ESMTP id A2A6C20200
	for <linux-ext4@vger.kernel.org>; Fri, 21 Sep 2012 04:21:35 +0000 (UTC)
In-Reply-To: <bug-47731-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=47731





--- Comment #3 from Brad Figg <brad.figg@canonical.com>  2012-09-21 04:21:34 ---
After many, many runs of xfstests I have encountered this same oops.


Sep 20 23:46:19 rizzo jenkins: run xfstest 234
Sep 20 23:46:20 rizzo kernel: [46589.656011] EXT4-fs (sdb2): mounted filesystem
with ordered data mode. Opts: acl,user_xattr,usrquota,grpquota
Sep 20 23:46:20 rizzo kernel: [46589.674369] EXT4-fs (sdb2): re-mounted. Opts:
(null)
Sep 20 23:46:20 rizzo kernel: [46589.682388] EXT4-fs (sdb2): re-mounted. Opts:
(null)
Sep 20 23:46:20 rizzo kernel: [46590.133061] BUG: unable to handle kernel NULL
pointer dereference at 0000001a
Sep 20 23:46:20 rizzo kernel: [46590.133482] IP: [<c12d908f>] strchr+0xf/0x30
Sep 20 23:46:20 rizzo kernel: [46590.133728] *pdpt = 0000000026347001 *pde =
0000000000000000 
Sep 20 23:46:20 rizzo kernel: [46590.134069] Oops: 0000 [#1] SMP 
Sep 20 23:46:20 rizzo kernel: [46590.134262] Modules linked in: quota_v2
quota_tree dm_multipath scsi_dh vesafb coretemp kvm_intel kvm joydev gpio_ich
microcode i7core_edac hid_generic edac_core dcdbas lpc_ich lp mac_hid
acpi_power_meter parport usbhid hid mpt2sas scsi_transport_sas raid_class bnx2
Sep 20 23:46:20 rizzo kernel: [46590.135782] 
Sep 20 23:46:20 rizzo kernel: [46590.135861] Pid: 23450, comm: setquota Not
tainted 3.5.0-15-generic #22~precise1-Ubuntu Dell Inc. PowerEdge R310/05XKKK
Sep 20 23:46:20 rizzo kernel: [46590.136498] EIP: 0060:[<c12d908f>] EFLAGS:
00010246 CPU: 3
Sep 20 23:46:20 rizzo kernel: [46590.136805] EIP is at strchr+0xf/0x30
Sep 20 23:46:20 rizzo kernel: [46590.137007] EAX: 00003d3d EBX: c1603be4 ECX:
00180000 EDX: 0000003d
Sep 20 23:46:20 rizzo kernel: [46590.137362] ESI: 0000001a EDI: 00380800 EBP:
da22beac ESP: da22bea8
Sep 20 23:46:20 rizzo kernel: [46590.137718]  DS: 007b ES: 007b FS: 00d8 GS:
00e0 SS: 0068
Sep 20 23:46:20 rizzo kernel: [46590.138023] CR0: 8005003b CR2: 0000001a CR3:
130a0000 CR4: 000007f0
Sep 20 23:46:20 rizzo kernel: [46590.138376] DR0: 00000000 DR1: 00000000 DR2:
00000000 DR3: 00000000
Sep 20 23:46:20 rizzo kernel: [46590.138733] DR6: ffff0ff0 DR7: 00000400
Sep 20 23:46:20 rizzo kernel: [46590.138969] Process setquota (pid: 23450,
ti=da22a000 task=f6582610 task.ti=da22a000)
Sep 20 23:46:20 rizzo kernel: [46590.139473] Stack:
Sep 20 23:46:20 rizzo kernel: [46590.139592]  0000002c da22bef4 c11e8057
f779b480 c17b8975 0000002c c17b8597 00000034
Sep 20 23:46:20 rizzo kernel: [46590.140123]  0000002c ca024400 eeb29400
8c02c010 eeb2d000 00000000 2cd6d558 f779b480
Sep 20 23:46:20 rizzo kernel: [46590.149809]  eeb2d000 f779b480 00000000
da22befc c11e85e2 da22bf1c c1189e66 f6d6d550
Sep 20 23:46:20 rizzo kernel: [46590.169372] Call Trace:
Sep 20 23:46:20 rizzo kernel: [46590.178912]  [<c11e8057>]
_ext4_show_options+0xf7/0x670
Sep 20 23:46:20 rizzo kernel: [46590.188682]  [<c11e85e2>]
ext4_show_options+0x12/0x20
Sep 20 23:46:20 rizzo kernel: [46590.198181]  [<c1189e66>]
show_vfsmnt+0xc6/0x110
Sep 20 23:46:20 rizzo kernel: [46590.207743]  [<c116ca70>] m_show+0x10/0x20
Sep 20 23:46:20 rizzo kernel: [46590.216361]  [<c11709e3>] seq_read+0x203/0x380
Sep 20 23:46:20 rizzo kernel: [46590.225585]  [<c115343c>] vfs_read+0x8c/0x160
Sep 20 23:46:20 rizzo kernel: [46590.234509]  [<c11707e0>] ?
seq_lseek+0x170/0x170
Sep 20 23:46:20 rizzo kernel: [46590.243111]  [<c115354d>] sys_read+0x3d/0x70
Sep 20 23:46:20 rizzo kernel: [46590.251658]  [<c15e759f>]
sysenter_do_call+0x12/0x28
Sep 20 23:46:20 rizzo kernel: [46590.259959] Code: 19 c0 0c 01 8b 75 f8 8b 7d
fc 89 ec 5d c3 8d b4 26 00 00 00 00 8d bc 27 00 00 00 00 55 89 e5 56 66 66 66
66 90 89 c6 89 d0 88 c4 <ac> 38 e0 74 09 84 c0 75 f7 be 01 00 00 00 89 f0 48 5e
5d c3 8d 
Sep 20 23:46:20 rizzo kernel: [46590.286078] EIP: [<c12d908f>] strchr+0xf/0x30
SS:ESP 0068:da22bea8
Sep 20 23:46:20 rizzo kernel: [46590.294730] CR2: 000000000000001a
Sep 20 23:46:20 rizzo kernel: [46590.316231] ---[ end trace d04680d177f087ac
]---

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
