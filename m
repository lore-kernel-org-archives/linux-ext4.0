From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 101751] 0009103: INFO: task nginx:2334 blocked for more than
 120 seconds.
Date: Mon, 20 Jul 2015 11:47:04 +0000
Message-ID: <bug-101751-13602-eNPAO9gUGQ@https.bugzilla.kernel.org/>
References: <bug-101751-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:59339 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752644AbbGTLrH (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 20 Jul 2015 07:47:07 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id BA4BC20601
	for <linux-ext4@vger.kernel.org>; Mon, 20 Jul 2015 11:47:06 +0000 (UTC)
Received: from bugzilla2.web.kernel.org (bugzilla2.web.kernel.org [172.20.200.52])
	by mail.kernel.org (Postfix) with ESMTP id 7A3392060C
	for <linux-ext4@vger.kernel.org>; Mon, 20 Jul 2015 11:47:04 +0000 (UTC)
In-Reply-To: <bug-101751-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=101751

--- Comment #2 from zakrzewskim@wp.pl ---
The same happens on latest CentOS 6.6 kernel.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
