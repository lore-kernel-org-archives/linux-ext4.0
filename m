From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 112631] Cannot open encrypted Luks filesystem. Cruptsetup
 error.
Date: Mon, 07 Mar 2016 17:57:29 +0000
Message-ID: <bug-112631-13602-NmgcJsmzo9@https.bugzilla.kernel.org/>
References: <bug-112631-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:42769 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752840AbcCGR5f (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 7 Mar 2016 12:57:35 -0500
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 7CAEF202F2
	for <linux-ext4@vger.kernel.org>; Mon,  7 Mar 2016 17:57:31 +0000 (UTC)
Received: from bugzilla2.web.kernel.org (bugzilla2.web.kernel.org [172.20.200.52])
	by mail.kernel.org (Postfix) with ESMTP id ABD56202D1
	for <linux-ext4@vger.kernel.org>; Mon,  7 Mar 2016 17:57:30 +0000 (UTC)
In-Reply-To: <bug-112631-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=112631

--- Comment #21 from alex.theoto <alex.theoto@gmail.com> ---
I think this problem has solved.
There are both new linux-lts and cryptsetup packages available.

Can someone verify this?

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
