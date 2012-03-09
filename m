From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 42895] jbd2 makes all system unresponsive
Date: Fri, 9 Mar 2012 10:49:21 GMT
Message-ID: <201203091049.q29AnL6v014859@bugzilla.kernel.org>
References: <bug-42895-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from bugzilla.kernel.org ([198.145.19.204]:40086 "EHLO
	bugzilla.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751009Ab2CIKtV (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 9 Mar 2012 05:49:21 -0500
Received: from bugzilla.kernel.org (localhost [127.0.0.1])
	by bugzilla.kernel.org (8.14.5/8.14.5) with ESMTP id q29AnLeJ014860
	for <linux-ext4@vger.kernel.org>; Fri, 9 Mar 2012 10:49:21 GMT
In-Reply-To: <bug-42895-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=42895





--- Comment #1 from Fabio Varesano <fabio.varesano@gmail.com>  2012-03-09 10:49:20 ---
It seems that even if the fil systems are ext3, the ext4 module is being used
due to CONFIG_EXT4_USE_FOR_EXT23 enabled in the kernel.

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
