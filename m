From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 92501] New: Root filesystem corruption
Date: Mon, 02 Feb 2015 13:45:31 +0000
Message-ID: <bug-92501-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:36398 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964928AbbBBNpf (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 2 Feb 2015 08:45:35 -0500
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id D498020450
	for <linux-ext4@vger.kernel.org>; Mon,  2 Feb 2015 13:45:33 +0000 (UTC)
Received: from bugzilla2.web.kernel.org (bugzilla2.web.kernel.org [172.20.200.52])
	by mail.kernel.org (Postfix) with ESMTP id 6BD1120445
	for <linux-ext4@vger.kernel.org>; Mon,  2 Feb 2015 13:45:32 +0000 (UTC)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=92501

            Bug ID: 92501
           Summary: Root filesystem corruption
           Product: File System
           Version: 2.5
    Kernel Version: 3.17.7 to 3.18.3
          Hardware: x86-64
                OS: Linux
              Tree: Mainline
            Status: NEW
          Severity: high
          Priority: P1
         Component: ext4
          Assignee: fs_ext4@kernel-bugs.osdl.org
          Reporter: ionut.radu@gmail.com
        Regression: No

Created attachment 165581
  --> https://bugzilla.kernel.org/attachment.cgi?id=165581&action=edit
log containing the filesystem corruptions and kernel version

Description of problem:
I have 3 laptops with Fedora 21, kernel 3.17.7 and all suffered from disk
corruption 
that prevent them to boot at some time.
I have root and home filesystem on the same disk partition. Corruption occurs
for temporary files of chrome and firefox.

Version-Release number of selected component (if applicable):
3.17.7

How reproducible:
All of my 3 laptops suffered from 
this at some time with Fedora 21
and kernel 3.17.7. Never happened before
and suddenly all 3 have filesystem corruption

Steps to Reproduce:
1. Don't know how to reproduce
2.
3.

Actual results:


Expected results:


Additional info:

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
