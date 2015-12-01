From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 94791] syscall fanotify_mark overflow.
Date: Tue, 01 Dec 2015 11:07:30 +0000
Message-ID: <bug-94791-13602-zNiqbWYeGU@https.bugzilla.kernel.org/>
References: <bug-94791-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:52159 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756193AbbLALHe (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 1 Dec 2015 06:07:34 -0500
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id F0DB5206AC
	for <linux-ext4@vger.kernel.org>; Tue,  1 Dec 2015 11:07:32 +0000 (UTC)
Received: from bugzilla2.web.kernel.org (bugzilla2.web.kernel.org [172.20.200.52])
	by mail.kernel.org (Postfix) with ESMTP id 4729A206B6
	for <linux-ext4@vger.kernel.org>; Tue,  1 Dec 2015 11:07:31 +0000 (UTC)
In-Reply-To: <bug-94791-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=94791

--- Comment #2 from Tim Pickersgill <tim.pickersgill@sophos.com> ---
Not an ext4 issue, I'd suggest that this be reclassified as "Other" and
assigned to "fs_other@kernel-bugs.osdl.org" or Eric Paris (eparis@redhat.com)

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
