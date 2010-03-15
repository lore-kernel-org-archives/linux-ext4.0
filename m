From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 15543] New: Oops in dentry_iput during ext3 remount readonly
Date: Mon, 15 Mar 2010 20:55:17 GMT
Message-ID: <bug-15543-13602@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:35150 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932183Ab0COUzT (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 15 Mar 2010 16:55:19 -0400
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.3/8.14.3) with ESMTP id o2FKtIX9031145
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Mon, 15 Mar 2010 20:55:18 GMT
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

http://bugzilla.kernel.org/show_bug.cgi?id=15543

               URL: http://i.imgur.com/27p2f.jpg
           Summary: Oops in dentry_iput during ext3 remount readonly
           Product: File System
           Version: 2.5
    Kernel Version: 2.6.32-gentoo-r5
          Platform: All
        OS/Version: Linux
              Tree: Mainline
            Status: NEW
          Severity: low
          Priority: P1
         Component: ext3
        AssignedTo: fs_ext3@kernel-bugs.osdl.org
        ReportedBy: ironiridis@gmail.com
        Regression: No


Was rebooting an office machine after a few package upgrades, and right at the
tail end of the reboot it appears that the kernel Oopsed right at the remount,
just before reboot.

I can attach my config and the kernel patchset provided with my distro, just
ask.

Below is my retyped Oops printout (photo of monitor is URL of bug):

EIP is at dentry_iput+0x25/0xb0
EAX: f057983c EBX: f05797f8 ECX: f05cad1c EDX: b05cad1c
ESI: f05cad04 EDI: f0579824 EBP: f05797f8 ESP: f69a8ef4
 DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
Process umount (pid: 6490, ti=f69a8000 task=f72cc6e0 task.ti=f69a8000)
Stack:
 00000282 f0579770 f05787f8 f05797f8 f69a8f2c c10940c2 f6897a00 f69a8f2c
<0> c10942fd f69a8f34 00000000 f6897a84 00000000 00000000 eafac2d4 f05798ac
<0> f69a8f34 f69a8f34 f6897a00 00000000 00000000 f69a8000 c1086775 00000001
Call Trace:
 [<c10940c2>] ? d_kill+0x32/0x60
 [<c10942fd>] ? __shrink_dcache_sb+0x20d/0x290
 [<c1086775>] ? do_remount_sb+0x35/0xe0
 [<c1099fa1>] ? sys_umount+0x321/0x350
 [<c106ef77>] ? remove_vma+0x37/0x50
 [<c1070502>] ? do_munmap+0x212/0x270
 [<c1099fe7>] ? sys_oldumount+0x17/0x20
 [<c1002e08>] ? sysenter_do_call+0x12/0x26
Code: 0f 0b eb fe 66 90 56 53 89 c3 83 ec 0c 8b 70 10 85 f6 0f 84 8e 00 00 00
c7
 40 10 00 00 00 00 8d 40 44 8b 4b 44 8b 53 48 89 51 04 <89> 0a 89 43 44 89 43
48
 fe 43 08 fe 05 c0 63 3f c1 8b 46 28 85
EIP: [<c1093f85>] dentry_iput+0x25/0xb0 SS:ESP 0068:f69a8ef4
CR2: 00000000b05cad1c
---[ end trace 29d86a99dda601c9 ]---

-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
