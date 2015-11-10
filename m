From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 107301] system hang during ext4 xattr operation
Date: Tue, 10 Nov 2015 11:16:37 +0000
Message-ID: <bug-107301-13602-IJawEQAIdo@https.bugzilla.kernel.org/>
References: <bug-107301-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:52062 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752226AbbKJLQl (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 10 Nov 2015 06:16:41 -0500
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 6F0F6207B0
	for <linux-ext4@vger.kernel.org>; Tue, 10 Nov 2015 11:16:39 +0000 (UTC)
Received: from bugzilla1.web.kernel.org (bugzilla1.web.kernel.org [172.20.200.51])
	by mail.kernel.org (Postfix) with ESMTP id A715D2065E
	for <linux-ext4@vger.kernel.org>; Tue, 10 Nov 2015 11:16:37 +0000 (UTC)
In-Reply-To: <bug-107301-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=107301

--- Comment #13 from Laurent GUERBY <laurent@guerby.net> ---
We restarted all of our cluster machines with ubuntu 3.19 + my ext4 mbcache
removal patch: so far no data loss, no new freeze and no visible change in
performance (production too noisy to detect small changes).

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
