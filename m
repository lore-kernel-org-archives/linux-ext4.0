From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 94791] syscall fanotify_mark overflow.
Date: Tue, 01 Dec 2015 14:08:55 +0000
Message-ID: <bug-94791-13602-2AKYxb575T@https.bugzilla.kernel.org/>
References: <bug-94791-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:39613 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755443AbbLAOJH (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 1 Dec 2015 09:09:07 -0500
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 04331204D8
	for <linux-ext4@vger.kernel.org>; Tue,  1 Dec 2015 14:09:02 +0000 (UTC)
Received: from bugzilla2.web.kernel.org (bugzilla2.web.kernel.org [172.20.200.52])
	by mail.kernel.org (Postfix) with ESMTP id 7D1D020503
	for <linux-ext4@vger.kernel.org>; Tue,  1 Dec 2015 14:08:56 +0000 (UTC)
In-Reply-To: <bug-94791-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=94791

--- Comment #3 from Tim Pickersgill <tim.pickersgill@sophos.com> ---
Tinkering with Eric Paris's fanotify-example
(http://git.infradead.org/users/eparis/fanotify-example.git), to forcibly set
higher bits in the mask passed to fanotify_mark(), the call correctly returns
-EINVAL on both 32- and 64-bit kernels.

Suggest this bug should be rejected unless a failing example can be provided.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
