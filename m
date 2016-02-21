From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 112631] Cannot open encrypted Luks filesystem. Cruptsetup
 error.
Date: Sun, 21 Feb 2016 20:14:58 +0000
Message-ID: <bug-112631-13602-8E62d7aPxz@https.bugzilla.kernel.org/>
References: <bug-112631-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:32786 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751106AbcBUUPC (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 21 Feb 2016 15:15:02 -0500
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 54CDD20390
	for <linux-ext4@vger.kernel.org>; Sun, 21 Feb 2016 20:15:01 +0000 (UTC)
Received: from bugzilla2.web.kernel.org (bugzilla2.web.kernel.org [172.20.200.52])
	by mail.kernel.org (Postfix) with ESMTP id B2D7C2041D
	for <linux-ext4@vger.kernel.org>; Sun, 21 Feb 2016 20:14:59 +0000 (UTC)
In-Reply-To: <bug-112631-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=112631

--- Comment #13 from Henrique de Moraes Holschuh <hmh@hmh.eng.br> ---
Cross-bts link to issue report in cryptsetup upstream:
https://gitlab.com/cryptsetup/cryptsetup/issues/284

Apparently, some changes had to be backported to cryptsetup 1.7.x branch, so I
expect it will be fixed in the cryptsetup 1.7.1 release, hopefully very soon.

The cryptsetup issue report mentions that the kernel change also breaks old
versions of libkcapi.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
