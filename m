Return-Path: <SRS0=E3Xq=SZ=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=MAILING_LIST_MULTI,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0EB9DC10F14
	for <linux-ext4@archiver.kernel.org>; Tue, 23 Apr 2019 03:22:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DD8CF20B1F
	for <linux-ext4@archiver.kernel.org>; Tue, 23 Apr 2019 03:22:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730924AbfDWDWe convert rfc822-to-8bit (ORCPT
        <rfc822;linux-ext4@archiver.kernel.org>);
        Mon, 22 Apr 2019 23:22:34 -0400
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:58908 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727995AbfDWDWe (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>);
        Mon, 22 Apr 2019 23:22:34 -0400
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id C119228736
        for <linux-ext4@vger.kernel.org>; Tue, 23 Apr 2019 03:22:32 +0000 (UTC)
Received: by mail.wl.linuxfoundation.org (Postfix, from userid 486)
        id B39B02873B; Tue, 23 Apr 2019 03:22:32 +0000 (UTC)
From:   bugzilla-daemon@bugzilla.kernel.org
To:     linux-ext4@vger.kernel.org
Subject: [Bug 203391] New: Hit kernel panic when build linux-next with ubuntu
 18.04
Date:   Tue, 23 Apr 2019 03:22:31 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: new
X-Bugzilla-Watch-Reason: AssignedTo fs_ext4@kernel-bugs.osdl.org
X-Bugzilla-Product: File System
X-Bugzilla-Component: ext4
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: blocking
X-Bugzilla-Who: lilideng@outlook.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: fs_ext4@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: bug_id short_desc product version
 cf_kernel_version rep_platform op_sys cf_tree bug_status bug_severity
 priority component assigned_to reporter cf_regression attachments.created
Message-ID: <bug-203391-13602@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=203391

            Bug ID: 203391
           Summary: Hit kernel panic when build linux-next with ubuntu
                    18.04
           Product: File System
           Version: 2.5
    Kernel Version: 5.1.0-rc5-3f018f4a019a
          Hardware: All
                OS: Linux
              Tree: Mainline
            Status: NEW
          Severity: blocking
          Priority: P1
         Component: ext4
          Assignee: fs_ext4@kernel-bugs.osdl.org
          Reporter: lilideng@outlook.com
        Regression: No

Created attachment 282463
  --> https://bugzilla.kernel.org/attachment.cgi?id=282463&action=edit
Serial console log

1 Create a Ubuntu 18.04
2 Clone latest linux-next, build kernel successfully
3 Reboot
4 Hit kernel panic

Begin: Running /scripts/init-premount ... done.
Begin: Mounting root file system ... Begin: Running /scripts/local-top ...
done.
Begin: Running /scripts/local-premount ... [    9.150164] Btrfs loaded,
crc32c=crc32c-intel
Scanning for Btrfs filesystems
done.
Warning: fsck not present, so skipping root file system
[    9.286671] EXT4-fs (sdb1): mounted filesystem with ordered data mode. Opts:
(null)
done.
Begin: Running /scripts/local-bottom ... done.
Begin: Running /scripts/init-bottom ... done.
/sbin/init: error while loading shared libraries:
/usr/lib/x86_64-linux-gnu/libip4tc.so.0: invalid ELF header
[    9.424886] Kernel panic - not syncing: Attempted to kill init!
exitcode=0x00007f00
[    9.425715] CPU: 39 PID: 1 Comm: init Not tainted 5.1.0-rc5-3f018f4a019a #1
[    9.425715] Hardware name: Microsoft Corporation Virtual Machine/Virtual
Machine, BIOS 090007  06/02/2017
[    9.425715] Call Trace:
[    9.425715]  dump_stack+0x46/0x5b
[    9.425715]  panic+0xf8/0x2c2
[    9.425715]  do_exit+0xb8d/0xb90
[    9.425715]  do_group_exit+0x3a/0xa0
[    9.425715]  __x64_sys_exit_group+0x14/0x20
[    9.425715]  do_syscall_64+0x4f/0x110
[    9.425715]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
[    9.425715] RIP: 0033:0x7f5083940056
[    9.425715] Code: Bad RIP value.
[    9.425715] RSP: 002b:00007ffdb07cb888 EFLAGS: 00000206 ORIG_RAX:
00000000000000e7
[    9.425715] RAX: ffffffffffffffda RBX: 00007f5083946ce0 RCX:
00007f5083940056
[    9.425715] RDX: 000000000000007f RSI: 000000000000003c RDI:
000000000000007f
[    9.425715] RBP: 00007ffdb07cc380 R08: 00000000000000e7 R09:
00007ffdb07cb344
[    9.425715] R10: 0000000000000020 R11: 0000000000000206 R12:
0000000000000011
[    9.425715] R13: 00007f5083b3e010 R14: 00007f5083b3df80 R15:
00007f5083b4c170
[    9.425715] Kernel Offset: 0x1fc00000 from 0xffffffff81000000 (relocation
range: 0xffffffff80000000-0xffffffffbfffffff)
[    9.425715] ---[ end Kernel panic - not syncing: Attempted to kill init!
exitcode=0x00007f00 ]---

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
