From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 42986] ext2_fs.h requires undefined type umode_t
Date: Sun, 25 Mar 2012 02:47:29 GMT
Message-ID: <201203250247.q2P2lTwn007835@bugzilla.kernel.org>
References: <bug-42986-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from bugzilla.kernel.org ([198.145.19.204]:35896 "EHLO
	bugzilla.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754027Ab2CYCra (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 24 Mar 2012 22:47:30 -0400
Received: from bugzilla.kernel.org (localhost [127.0.0.1])
	by bugzilla.kernel.org (8.14.5/8.14.5) with ESMTP id q2P2lTF1007836
	for <linux-ext4@vger.kernel.org>; Sun, 25 Mar 2012 02:47:29 GMT
In-Reply-To: <bug-42986-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=42986





--- Comment #4 from Allan <allan@archlinux.org>  2012-03-25 02:47:29 ---
Sure, that fixes syslinux...  But what about every other user of this header? 
The answer of "don't use it" is not very good if it is being installed.

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
