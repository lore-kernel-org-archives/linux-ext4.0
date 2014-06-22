From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 78651] Write performance of ext4 degrades linearly as volume
 fills
Date: Sun, 22 Jun 2014 05:45:43 +0000
Message-ID: <bug-78651-13602-aq4xcrqv73@https.bugzilla.kernel.org/>
References: <bug-78651-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:59436 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750857AbaFVFpq (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 22 Jun 2014 01:45:46 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 1C00B20265
	for <linux-ext4@vger.kernel.org>; Sun, 22 Jun 2014 05:45:45 +0000 (UTC)
Received: from bugzilla2.web.kernel.org (bugzilla2.web.kernel.org [172.20.200.52])
	by mail.kernel.org (Postfix) with ESMTP id BED352022D
	for <linux-ext4@vger.kernel.org>; Sun, 22 Jun 2014 05:45:43 +0000 (UTC)
In-Reply-To: <bug-78651-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=78651

--- Comment #1 from Joseph D. Wagner <joe@josephdwagner.info> ---
Created attachment 140601
  --> https://bugzilla.kernel.org/attachment.cgi?id=140601&action=edit
debugfs extent info on the dump backup files

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
