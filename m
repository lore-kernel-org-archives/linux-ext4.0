From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 94791] New: syscall fanotify_mark overflow.
Date: Thu, 12 Mar 2015 09:40:44 +0000
Message-ID: <bug-94791-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:50856 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752528AbbCLJkr (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 12 Mar 2015 05:40:47 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 3ABEE20483
	for <linux-ext4@vger.kernel.org>; Thu, 12 Mar 2015 09:40:46 +0000 (UTC)
Received: from bugzilla2.web.kernel.org (bugzilla2.web.kernel.org [172.20.200.52])
	by mail.kernel.org (Postfix) with ESMTP id 39E362047B
	for <linux-ext4@vger.kernel.org>; Thu, 12 Mar 2015 09:40:45 +0000 (UTC)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=94791

            Bug ID: 94791
           Summary: syscall fanotify_mark overflow.
           Product: File System
           Version: 2.5
    Kernel Version: 4.x
          Hardware: All
                OS: Linux
              Tree: Mainline
            Status: NEW
          Severity: normal
          Priority: P1
         Component: ext4
          Assignee: fs_ext4@kernel-bugs.osdl.org
          Reporter: du.guowei2@zte.com.cn
        Regression: No

file:
     fanotify_usr.c:
     syscall function fanotify_mark,below code will overflow on 32-bit system.

/* we only use the lower 32 bits as of right now. */
if ( mask & ((__u64)0xffffffff << 32))
        return -EINVAL;


include/linux/syscalls.h:
 asmlinkage long sys_fanotify_mark(int fanotify_fd, unsigned int flags, u64
mask, int fd, const char __usr *pathname);


u64 mask ,should convert to unsigned int mask???

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
