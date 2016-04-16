From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 116471] Core in ext4 filesystem on a Dell Server
Date: Sat, 16 Apr 2016 05:21:12 +0000
Message-ID: <bug-116471-13602-CA62twz4ep@https.bugzilla.kernel.org/>
References: <bug-116471-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:45996 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750798AbcDPFVS (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 16 Apr 2016 01:21:18 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 031A62026C
	for <linux-ext4@vger.kernel.org>; Sat, 16 Apr 2016 05:21:16 +0000 (UTC)
Received: from bugzilla2.web.kernel.org (bugzilla2.web.kernel.org [172.20.200.52])
	by mail.kernel.org (Postfix) with ESMTP id 0FC062027D
	for <linux-ext4@vger.kernel.org>; Sat, 16 Apr 2016 05:21:13 +0000 (UTC)
In-Reply-To: <bug-116471-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=116471

--- Comment #3 from kparamasivam@hpe.com ---
Thanks Christian and Eric.
This place https://bugs.centos.org/view.php?id=9080 has no resolution for the
issue. 

Consistently we have hit this same issue on 2 of our box.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
