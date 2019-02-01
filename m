Return-Path: <SRS0=gd00=QI=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=MAILING_LIST_MULTI,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DAEA4C282D8
	for <linux-ext4@archiver.kernel.org>; Fri,  1 Feb 2019 20:10:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B152D218AF
	for <linux-ext4@archiver.kernel.org>; Fri,  1 Feb 2019 20:10:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730116AbfBAUKV convert rfc822-to-8bit (ORCPT
        <rfc822;linux-ext4@archiver.kernel.org>);
        Fri, 1 Feb 2019 15:10:21 -0500
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:37808 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725890AbfBAUKV (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Fri, 1 Feb 2019 15:10:21 -0500
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id AB19C32D37
        for <linux-ext4@vger.kernel.org>; Fri,  1 Feb 2019 20:10:19 +0000 (UTC)
Received: by mail.wl.linuxfoundation.org (Postfix, from userid 486)
        id 9D9CE32D24; Fri,  1 Feb 2019 20:10:19 +0000 (UTC)
From:   bugzilla-daemon@bugzilla.kernel.org
To:     linux-ext4@vger.kernel.org
Subject: [Bug 202485] New: chmod'ed permission not persisted upon fsync
Date:   Fri, 01 Feb 2019 20:10:18 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: new
X-Bugzilla-Watch-Reason: AssignedTo fs_ext4@kernel-bugs.osdl.org
X-Bugzilla-Product: File System
X-Bugzilla-Component: ext4
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: seulbae@gatech.edu
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: fs_ext4@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: bug_id short_desc product version
 cf_kernel_version rep_platform op_sys cf_tree bug_status bug_severity
 priority component assigned_to reporter cf_regression attachments.created
Message-ID: <bug-202485-13602@https.bugzilla.kernel.org/>
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

https://bugzilla.kernel.org/show_bug.cgi?id=202485

            Bug ID: 202485
           Summary: chmod'ed permission not persisted upon fsync
           Product: File System
           Version: 2.5
    Kernel Version: 4.18~Latest
          Hardware: All
                OS: Linux
              Tree: Mainline
            Status: NEW
          Severity: normal
          Priority: P1
         Component: ext4
          Assignee: fs_ext4@kernel-bugs.osdl.org
          Reporter: seulbae@gatech.edu
        Regression: No

Created attachment 280919
  --> https://bugzilla.kernel.org/attachment.cgi?id=280919&action=edit
Proof of Concept

[Kernel version]
This bug can be reproduced on
kernel 4.18 ~ 4.20.0+(kernel 645ff1e8e704c4f33ab1fcd3c87f95cb9b6d7144)

[Reproduce] * Use a VM, since our PoC simulates a crash by triggering a SysRq!
1. Download base image
$ wget https://gts3.org/~seulbae/fsimg/ext4-00.image

2. Mount image
$ mkdir /tmp/ext4
$ sudo mount -o loop ext4-00.image /tmp/ext4

3. Compile and run PoC
$ gcc poc.c -o poc
$ sudo ./poc /tmp/ext4
(System reboots)

[Check]
1. Re-mount the crashed image
$ mkdir /tmp/ext4
$ sudo mount -o loop ext4-00.image /tmp/ext4

2. Check inconsistency
$ stat /tmp/ext4/foo/bar/fifo
-> Access: (0644/prw-r--r--)

[Description]
In the base image, 2 directories and 7 files exist.

0: 0755 (mount_point)
+--257: 0755 foo
   +--258: 0755 bar
      +--259: 0644 baz (12 bytes, offset: {})
      +--259: 0644 hln (12 bytes, offset: {})
      +--260: 0644 xattr (0 bytes, offset: {})
      +--261: 0644 acl (0 bytes, offset: {})
      +--262: 0644 æøå (4 bytes, offset: {})
      +--263: 0644 fifo
      +--264: 0777 sln -> mnt/foo/bar/baz

foo/bar/fifo is a FIFO file.
The PoC basically
1. changes its permission,
(line 26) syscall(SYS_chmod, "foo/bar/fifo", 0400);
2. opens it,
(line 27) syscall(SYS_chmod, "foo/bar/fifo", 0400);
3. flushes its metadata, and then
(line 28) syscall(SYS_fsync, fd);
4. simulates a crash by rebooting right away without unmounting.
(line 30) system("echo b > /proc/sysrq-trigger");

We expect that the metadata regarding
the new permission is successfully flushed to disk,
and when we remount the crashed image,
we will see that foo/bar/fifo's mode is changed to 0400.

However, the file still has its old mode, 0644.

Reported by Seulbae Kim (seulbae@gatech.edu) from SSLab, Gatech

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
