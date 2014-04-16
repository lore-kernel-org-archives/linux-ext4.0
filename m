From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 74171] New: Attempting to build recent version of e2fsprogs
 from git repo gives config.h missing
Date: Wed, 16 Apr 2014 10:27:44 +0000
Message-ID: <bug-74171-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:44105 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755360AbaDPK1s (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 16 Apr 2014 06:27:48 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 8BD7720200
	for <linux-ext4@vger.kernel.org>; Wed, 16 Apr 2014 10:27:47 +0000 (UTC)
Received: from bugzilla1.web.kernel.org (bugzilla1.web.kernel.org [172.20.200.51])
	by mail.kernel.org (Postfix) with ESMTP id A778D2026C
	for <linux-ext4@vger.kernel.org>; Wed, 16 Apr 2014 10:27:44 +0000 (UTC)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=74171

            Bug ID: 74171
           Summary: Attempting to build recent version of e2fsprogs from
                    git repo gives config.h missing
           Product: File System
           Version: 2.5
    Kernel Version: 3.13.9-100.fc19.x86_64
          Hardware: x86-64
                OS: Linux
              Tree: Mainline
            Status: NEW
          Severity: high
          Priority: P1
         Component: ext4
          Assignee: fs_ext4@kernel-bugs.osdl.org
          Reporter: grgoffe@yahoo.com
        Regression: No

This is my first time attempting to build e2fsprogs from the git repo. I'm
getting a failure with config.h missing. Here's a sample of the error message.
I have a complete build log available if needed.

../../../lib/uuid/unparse.c:35:20: fatal error: config.h: No such file or
directory

This is a fedora 19 x86_64 system.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
