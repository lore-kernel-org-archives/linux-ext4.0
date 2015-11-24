From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 94791] syscall fanotify_mark overflow.
Date: Tue, 24 Nov 2015 16:14:57 +0000
Message-ID: <bug-94791-13602-NJqWhmtioV@https.bugzilla.kernel.org/>
References: <bug-94791-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:45869 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752805AbbKXQPC (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 24 Nov 2015 11:15:02 -0500
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id A3BFF207D2
	for <linux-ext4@vger.kernel.org>; Tue, 24 Nov 2015 16:15:00 +0000 (UTC)
Received: from bugzilla1.web.kernel.org (bugzilla1.web.kernel.org [172.20.200.51])
	by mail.kernel.org (Postfix) with ESMTP id 97120207C9
	for <linux-ext4@vger.kernel.org>; Tue, 24 Nov 2015 16:14:57 +0000 (UTC)
In-Reply-To: <bug-94791-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=94791

Tim Pickersgill <tim.pickersgill@sophos.com> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |tim.pickersgill@sophos.com

--- Comment #1 from Tim Pickersgill <tim.pickersgill@sophos.com> ---
A __u64 value is an unsigned long long, a 64-bit integer, regardless of system
bitness. Not sure how/why this would overflow on a 32-bit system. What symptoms
are you seeing?

We're using fanotify_mark() on 32-bit systems without seeing any issue here.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
