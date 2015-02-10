From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 93031] root becomes read-only at boot due to
 journal_async_commit in /etc/fstab
Date: Tue, 10 Feb 2015 08:00:28 +0000
Message-ID: <bug-93031-13602-2POdYZv5Df@https.bugzilla.kernel.org/>
References: <bug-93031-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:43674 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750726AbbBJIAa (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 10 Feb 2015 03:00:30 -0500
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 47D142012E
	for <linux-ext4@vger.kernel.org>; Tue, 10 Feb 2015 08:00:29 +0000 (UTC)
Received: from bugzilla2.web.kernel.org (bugzilla2.web.kernel.org [172.20.200.52])
	by mail.kernel.org (Postfix) with ESMTP id 90EFD20120
	for <linux-ext4@vger.kernel.org>; Tue, 10 Feb 2015 08:00:28 +0000 (UTC)
In-Reply-To: <bug-93031-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=93031

Stan <mtall.qld@gmail.com> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
         Regression|No                          |Yes

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
