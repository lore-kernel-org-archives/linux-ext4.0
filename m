From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 95861] New: fs/inode.c:509 invalid opcode: 0000 [#1] SMP
Date: Mon, 30 Mar 2015 17:15:50 +0000
Message-ID: <bug-95861-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:44777 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753023AbbC3RPy (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 30 Mar 2015 13:15:54 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 9FC782035B
	for <linux-ext4@vger.kernel.org>; Mon, 30 Mar 2015 17:15:52 +0000 (UTC)
Received: from bugzilla1.web.kernel.org (bugzilla1.web.kernel.org [172.20.200.51])
	by mail.kernel.org (Postfix) with ESMTP id 208C720377
	for <linux-ext4@vger.kernel.org>; Mon, 30 Mar 2015 17:15:51 +0000 (UTC)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=95861

            Bug ID: 95861
           Summary: fs/inode.c:509 invalid opcode: 0000 [#1] SMP
           Product: File System
           Version: 2.5
    Kernel Version: 3.19.2
          Hardware: Intel
                OS: Linux
              Tree: Mainline
            Status: NEW
          Severity: normal
          Priority: P1
         Component: ext3
          Assignee: fs_ext3@kernel-bugs.osdl.org
          Reporter: ronis@ronispc.chem.mcgill.ca
        Regression: No

I was backing up some files onto an external hard drive which is unmounted when
finished (all this is in a script).  This time, trying to unmount /dev/sdb1
gave:

[251916.217504] ------------[ cut here ]------------
[251916.217853] kernel BUG at fs/inode.c:509!
[251916.218002] invalid opcode: 0000 [#1] SMP 
[251916.218002] Modules linked in: snd_hda_codec_idt snd_hda_codec_generic
snd_hda_intel snd_hda_controller snd_hda_codec snd_hwdep autofs4 nfsd lockd
grace nfs_acl auth_rpcgss sunrpc oid_registry ipv6 nf_conntrack_ipv4
nf_defrag_ipv4 xt_state nf_conntrack xt_multiport iptable_filter ip_tables fuse
floppy loop [last unloaded: snd_hwdep]
[251916.218002] CPU: 0 PID: 23470 Comm: umount Not tainted 3.19.2 #1
[251916.218002] task: de90a780 ti: c90b2000 task.ti: c90b2000
[251916.218002] EIP: 0060:[<c1112dd0>] EFLAGS: 00010006 CPU: 0
[251916.218002] EIP is at clear_inode+0x60/0x80
[251916.218002] EAX: 00001800 EBX: dab85068 ECX: c90b3e80 EDX: 00000000
[251916.218002] ESI: dab85104 EDI: c1661100 EBP: de90a780 ESP: c90b3f28
[251916.218002]  DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
[251916.218002] CR0: 8005003b CR2: b7396bd4 CR3: 15c74000 CR4: 000007d0
[251916.218002] Stack:
[251916.218002]  dab85068 c111387e dab852f4 c90b3f4c ca337460 c111396a ca3373c4
ca3373c4
[251916.218002]  c1114426 dab852f4 d46a7ccc ca337400 ca337460 c1661100 c10fe173
00000083
[251916.218002]  f544ea00 de90ab48 c10fe437 ca337400 c186c184 c10fe6ca f263b500
c19473ec
[251916.218002] Call Trace:
[251916.218002]  [<c111387e>] ? evict+0x8e/0x150
[251916.218002]  [<c111396a>] ? dispose_list+0x2a/0x40
[251916.218002]  [<c1114426>] ? evict_inodes+0x86/0xd0
[251916.218002]  [<c10fe173>] ? generic_shutdown_super+0x33/0xc0
[251916.218002]  [<c10fe437>] ? kill_block_super+0x17/0x60
[251916.218002]  [<c10fe6ca>] ? deactivate_locked_super+0x2a/0x40
[251916.218002]  [<c1116ca1>] ? cleanup_mnt+0x31/0x80
[251916.218002]  [<c1051cb9>] ? task_work_run+0x99/0xd0
[251916.218002]  [<c1002363>] ? do_notify_resume+0x53/0x70
[251916.218002]  [<c164ad77>] ? work_notifysig+0x24/0x29
[251916.218002] Code: 39 83 20 01 00 00 75 2b 8b 43 64 a8 20 74 2c a8 40 75 30
c7 43 64 60 00 00 00 5b c3 8d b4 26 00 00 00 00 0f 0b 8d b6 00 00 00 00 <0f> 0b
8d b6 00 00 00 00 0f 0b 8d b6 00 00 00 00 0f 0b 8d b6 00
[251916.218002] EIP: [<c1112dd0>] clear_inode+0x60/0x80 SS:ESP 0068:c90b3f28
[251916.218002] ---[ end trace d775e62345bf5ab2 ]---

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
