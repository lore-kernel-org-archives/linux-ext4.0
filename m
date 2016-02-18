From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 100321] General protection fault (stalls the machine) with jbd2
 and raid456
Date: Thu, 18 Feb 2016 15:37:40 +0000
Message-ID: <bug-100321-13602-HjMFADntri@https.bugzilla.kernel.org/>
References: <bug-100321-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:60498 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1424586AbcBRPho (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 18 Feb 2016 10:37:44 -0500
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id D8DE820395
	for <linux-ext4@vger.kernel.org>; Thu, 18 Feb 2016 15:37:42 +0000 (UTC)
Received: from bugzilla2.web.kernel.org (bugzilla2.web.kernel.org [172.20.200.52])
	by mail.kernel.org (Postfix) with ESMTP id 20E8420375
	for <linux-ext4@vger.kernel.org>; Thu, 18 Feb 2016 15:37:41 +0000 (UTC)
In-Reply-To: <bug-100321-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=100321

--- Comment #4 from Jouni Karvo <jouni.karvo@iki.fi> ---
4.2 is not affected.  the bug was in raid456 and Neil Brown fixed it last
summer; probably some 4.1 version is already ok.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
