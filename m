From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 41682] INFO: possible circular locking dependency detected ..
 at ext4_evict_inode
Date: Tue, 7 Feb 2012 12:41:45 GMT
Message-ID: <201202071241.q17CfjXM004951@bugzilla.kernel.org>
References: <bug-41682-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from bugzilla.kernel.org ([198.145.19.204]:41571 "EHLO
	bugzilla.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756113Ab2BGMlp (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 7 Feb 2012 07:41:45 -0500
Received: from bugzilla.kernel.org (localhost [127.0.0.1])
	by bugzilla.kernel.org (8.14.5/8.14.5) with ESMTP id q17Cfjmf004952
	for <linux-ext4@vger.kernel.org>; Tue, 7 Feb 2012 12:41:45 GMT
In-Reply-To: <bug-41682-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=41682





--- Comment #13 from Witold Baryluk <baryluk@smp.if.uj.edu.pl>  2012-02-07 12:41:44 ---
Cannot reproduce anymore at 3.2.4 or 3.3-rc2+. I think this can be closed.

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
