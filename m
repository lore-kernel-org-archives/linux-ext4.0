From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 92271] Provide a way to really delete files, please
Date: Thu, 29 Jan 2015 22:02:48 +0000
Message-ID: <bug-92271-13602-poXI1rs1vU@https.bugzilla.kernel.org/>
References: <bug-92271-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:36274 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753105AbbA2WCw (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 29 Jan 2015 17:02:52 -0500
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id B9B5620218
	for <linux-ext4@vger.kernel.org>; Thu, 29 Jan 2015 22:02:51 +0000 (UTC)
Received: from bugzilla2.web.kernel.org (bugzilla2.web.kernel.org [172.20.200.52])
	by mail.kernel.org (Postfix) with ESMTP id 093752024C
	for <linux-ext4@vger.kernel.org>; Thu, 29 Jan 2015 22:02:49 +0000 (UTC)
In-Reply-To: <bug-92271-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=92271

--- Comment #8 from Alexander Holler <holler@ahsoftware.de> ---
Or just make the promise that a file which has the 's' bit set, will be
overwritten with unlink(). That might avoid an additional syscall.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
