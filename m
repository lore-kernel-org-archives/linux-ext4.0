From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 56091] kernel oops when copying data to ext4 fs
Date: Sat, 01 Feb 2014 01:01:56 +0000
Message-ID: <bug-56091-13602-wfgksN0hzz@https.bugzilla.kernel.org/>
References: <bug-56091-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:33247 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932767AbaBABB6 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 31 Jan 2014 20:01:58 -0500
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id D124C2026C
	for <linux-ext4@vger.kernel.org>; Sat,  1 Feb 2014 01:01:57 +0000 (UTC)
Received: from bugzilla2.web.kernel.org (bugzilla2.web.kernel.org [172.20.200.52])
	by mail.kernel.org (Postfix) with ESMTP id 7913E20263
	for <linux-ext4@vger.kernel.org>; Sat,  1 Feb 2014 01:01:56 +0000 (UTC)
In-Reply-To: <bug-56091-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=56091

--- Comment #3 from shakilk1729@gmail.com <shakilk1729@gmail.com> ---
Not able to reproduce this in kernel 3.13. Does this mean we have to still fix
this in 3.8.5

Regards
Shakil

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
