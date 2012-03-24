From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 42986] ext2_fs.h requires undefined type umode_t
Date: Sat, 24 Mar 2012 14:16:20 GMT
Message-ID: <201203241416.q2OEGKSq024192@bugzilla.kernel.org>
References: <bug-42986-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from bugzilla.kernel.org ([198.145.19.204]:33534 "EHLO
	bugzilla.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751801Ab2CXOQU (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 24 Mar 2012 10:16:20 -0400
Received: from bugzilla.kernel.org (localhost [127.0.0.1])
	by bugzilla.kernel.org (8.14.5/8.14.5) with ESMTP id q2OEGK9p024193
	for <linux-ext4@vger.kernel.org>; Sat, 24 Mar 2012 14:16:20 GMT
In-Reply-To: <bug-42986-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=42986





--- Comment #2 from Allan <allan@archlinux.org>  2012-03-24 14:16:19 ---
I noticed this issue while building the latest syslinux.

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
