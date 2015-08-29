From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 103111] auto_da_alloc mount option not working
Date: Sat, 29 Aug 2015 03:28:27 +0000
Message-ID: <bug-103111-13602-AiErLofY37@https.bugzilla.kernel.org/>
References: <bug-103111-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:52420 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751691AbbH2D2b (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 28 Aug 2015 23:28:31 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 5094B20A2E
	for <linux-ext4@vger.kernel.org>; Sat, 29 Aug 2015 03:28:30 +0000 (UTC)
Received: from bugzilla2.web.kernel.org (bugzilla2.web.kernel.org [172.20.200.52])
	by mail.kernel.org (Postfix) with ESMTP id 841FE206D8
	for <linux-ext4@vger.kernel.org>; Sat, 29 Aug 2015 03:28:27 +0000 (UTC)
In-Reply-To: <bug-103111-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=103111

--- Comment #15 from Theodore Tso <tytso@mit.edu> ---
Just to be clear, no one should be *relying* on these hueristics.  They are not
mandated by Posix, and there is no guarantee that future file systems will
implement these hueristics.  They are workarounds for broken applications, in
the hopes that these broken applications will get **fixed**.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
