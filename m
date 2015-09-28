From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 105121] New: lseek() hangs for a long time on allocated files
Date: Mon, 28 Sep 2015 12:27:05 +0000
Message-ID: <bug-105121-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:52668 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933406AbbI1M1I (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 28 Sep 2015 08:27:08 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 98EAF20781
	for <linux-ext4@vger.kernel.org>; Mon, 28 Sep 2015 12:27:07 +0000 (UTC)
Received: from bugzilla1.web.kernel.org (bugzilla1.web.kernel.org [172.20.200.51])
	by mail.kernel.org (Postfix) with ESMTP id 46A532077A
	for <linux-ext4@vger.kernel.org>; Mon, 28 Sep 2015 12:27:06 +0000 (UTC)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=105121

            Bug ID: 105121
           Summary: lseek() hangs for a long time on allocated files
           Product: File System
           Version: 2.5
    Kernel Version: 4.2.1
          Hardware: All
                OS: Linux
              Tree: Mainline
            Status: NEW
          Severity: normal
          Priority: P1
         Component: ext4
          Assignee: fs_ext4@kernel-bugs.osdl.org
          Reporter: iam@valdikss.org.ru
        Regression: No

Created attachment 188751
  --> https://bugzilla.kernel.org/attachment.cgi?id=188751&action=edit
lseek test program

lseek() call hangs for a long time on fallocate allocated files on ext4.

Steps to reproduce:
1. gcc -o prog lseek-fallocate.c
2. fallocate -l 1G test
3. cat test > /dev/null
4. ./prog

Actual result:
prog hangs for 2 minutes on my system while doing lseek().

Expected result:
lseek() instantly return ENXIO.

Usually lseek works much faster if file wasn't cat'ed before lseek.
Works properly on btrfs.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
