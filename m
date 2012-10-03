From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 48251] New: Sorting directory entries
Date: Wed,  3 Oct 2012 15:46:10 +0000 (UTC)
Message-ID: <bug-48251-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:44868 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932317Ab2JCPqR (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 3 Oct 2012 11:46:17 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 68BB820443
	for <linux-ext4@vger.kernel.org>; Wed,  3 Oct 2012 15:46:12 +0000 (UTC)
Received: from bugzilla.kernel.org (bugzilla.kernel.org [198.145.19.217])
	by mail.kernel.org (Postfix) with ESMTP id 924D42043C
	for <linux-ext4@vger.kernel.org>; Wed,  3 Oct 2012 15:46:10 +0000 (UTC)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=48251

           Summary: Sorting directory entries
           Product: File System
           Version: 2.5
          Platform: All
        OS/Version: Linux
              Tree: Mainline
            Status: NEW
          Severity: normal
          Priority: P1
         Component: ext3
        AssignedTo: fs_ext3@kernel-bugs.osdl.org
        ReportedBy: tux2002@front.ru
        Regression: No


Good day!
Why the directory entries in directory not listed (without sorting) in same
order that been created? I mean that directory like file with append writing
mode.
I have some tasks, when this is important.
Thanks!

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
