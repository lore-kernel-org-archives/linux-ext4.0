From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 43292] jdb2 lockup with ext3 and nfs
Date: Sun,  3 Jun 2012 20:16:11 +0000 (UTC)
Message-ID: <20120603201611.00DD311FC42@bugzilla.kernel.org>
References: <bug-43292-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:35467 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754054Ab2FCUQO (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 3 Jun 2012 16:16:14 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 1AF8C20212
	for <linux-ext4@vger.kernel.org>; Sun,  3 Jun 2012 20:16:13 +0000 (UTC)
Received: from bugzilla.kernel.org (bugzilla.kernel.org [198.145.19.204])
	by mail.kernel.org (Postfix) with ESMTP id 09BF620207
	for <linux-ext4@vger.kernel.org>; Sun,  3 Jun 2012 20:16:11 +0000 (UTC)
In-Reply-To: <bug-43292-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=43292





--- Comment #17 from Florian Pritz <flo@xssn.at>  2012-06-03 20:16:10 ---
It finishes in both cases.

I've run it directly after nfs hung and when the loop completed nfs was running
again. Normally it takes ~2minutes until nfs unfreezes, but in this case it was
faster.

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
