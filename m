From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 93491] Kernel crashes every 10 minutes. Computer stalls
Date: Fri, 20 Feb 2015 16:09:48 +0000
Message-ID: <bug-93491-13602-UHKulAeN0S@https.bugzilla.kernel.org/>
References: <bug-93491-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:46120 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754478AbbBTQJu (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 20 Feb 2015 11:09:50 -0500
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 88A0520383
	for <linux-ext4@vger.kernel.org>; Fri, 20 Feb 2015 16:09:49 +0000 (UTC)
Received: from bugzilla1.web.kernel.org (bugzilla1.web.kernel.org [172.20.200.51])
	by mail.kernel.org (Postfix) with ESMTP id 4393220389
	for <linux-ext4@vger.kernel.org>; Fri, 20 Feb 2015 16:09:48 +0000 (UTC)
In-Reply-To: <bug-93491-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=93491

--- Comment #8 from Ionut Radu <ionut.radu@gmail.com> ---


Probably because the abrt is collecting data after reboot if computer stalls.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
