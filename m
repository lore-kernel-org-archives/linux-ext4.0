From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 93031] New: root becomes read-only at boot due to
 journal_async_commit in /etc/fstab
Date: Tue, 10 Feb 2015 07:59:55 +0000
Message-ID: <bug-93031-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:43650 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752315AbbBJH76 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 10 Feb 2015 02:59:58 -0500
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 46B6620120
	for <linux-ext4@vger.kernel.org>; Tue, 10 Feb 2015 07:59:57 +0000 (UTC)
Received: from bugzilla2.web.kernel.org (bugzilla2.web.kernel.org [172.20.200.52])
	by mail.kernel.org (Postfix) with ESMTP id B956220125
	for <linux-ext4@vger.kernel.org>; Tue, 10 Feb 2015 07:59:55 +0000 (UTC)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=93031

            Bug ID: 93031
           Summary: root becomes read-only at boot due to
                    journal_async_commit in /etc/fstab
           Product: File System
           Version: 2.5
    Kernel Version: 3.18.5
          Hardware: x86-64
                OS: Linux
              Tree: Fedora
            Status: NEW
          Severity: high
          Priority: P1
         Component: ext4
          Assignee: fs_ext4@kernel-bugs.osdl.org
          Reporter: mtall.qld@gmail.com
        Regression: No

Booting kernel 3.18.5 with the journal_async_commit option for / in /etc/fstab
causes the root file system to be read-only. kernel 3.18.3 also has this
problem.

entry in /etc/fstab:
UUID=...  / ext4  defaults,nodiratime,noatime,journal_async_commit 1 1

Relevant log from dmesg:
EXT4-fs (sdb1): changing journal_checksum during remount not supported

Adding journal_checksum to /etc/fstab doesn't help.  Trying to manually remount
root to enable or disable journal_async_commit also doesn't work.

kernel 3.17.x works without problems.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
