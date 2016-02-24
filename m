From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 112631] Cannot open encrypted Luks filesystem. Cruptsetup
 error.
Date: Wed, 24 Feb 2016 21:01:42 +0000
Message-ID: <bug-112631-13602-ZDiLacGj5i@https.bugzilla.kernel.org/>
References: <bug-112631-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:50827 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753149AbcBXVBp (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 24 Feb 2016 16:01:45 -0500
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 576CD2038A
	for <linux-ext4@vger.kernel.org>; Wed, 24 Feb 2016 21:01:44 +0000 (UTC)
Received: from bugzilla2.web.kernel.org (bugzilla2.web.kernel.org [172.20.200.52])
	by mail.kernel.org (Postfix) with ESMTP id 10DDA202F0
	for <linux-ext4@vger.kernel.org>; Wed, 24 Feb 2016 21:01:43 +0000 (UTC)
In-Reply-To: <bug-112631-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=112631

--- Comment #20 from Karl Sponser <karl.sponser@web.de> ---
Fedora won't patch to cryptsetup, because it's a kernel bug:
https://bugzilla.redhat.com/show_bug.cgi?id=1311286#c2

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
