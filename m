From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 42763] directory access hangs without error
Date: Mon, 13 Feb 2012 16:02:52 GMT
Message-ID: <201202131602.q1DG2qZ8021821@bugzilla.kernel.org>
References: <bug-42763-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from bugzilla.kernel.org ([198.145.19.204]:54663 "EHLO
	bugzilla.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757012Ab2BMQCw (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 13 Feb 2012 11:02:52 -0500
Received: from bugzilla.kernel.org (localhost [127.0.0.1])
	by bugzilla.kernel.org (8.14.5/8.14.5) with ESMTP id q1DG2q2g021822
	for <linux-ext4@vger.kernel.org>; Mon, 13 Feb 2012 16:02:52 GMT
In-Reply-To: <bug-42763-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=42763





--- Comment #2 from Eric Buddington <ebuddington@wesleyan.edu>  2012-02-13 16:02:51 ---
Created an attachment (id=72366)
 --> (https://bugzilla.kernel.org/attachment.cgi?id=72366)
C program to trigger the bug

compile with --std=gnu99 -lpthread -lrt

invocation is ./edu <directory> <number of threads>

triggers the bug after about a dozen iteratons. Program will stall showing
"1a", indicating one still-active thread, and fail to exit.

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
