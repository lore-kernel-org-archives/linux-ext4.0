From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 116471] Core in ext4 filesystem on a Dell Server
Date: Sat, 16 Apr 2016 02:31:03 +0000
Message-ID: <bug-116471-13602-FgHGrdyf5u@https.bugzilla.kernel.org/>
References: <bug-116471-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:43730 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750802AbcDPCbI (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 15 Apr 2016 22:31:08 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id E359320218
	for <linux-ext4@vger.kernel.org>; Sat, 16 Apr 2016 02:31:05 +0000 (UTC)
Received: from bugzilla1.web.kernel.org (bugzilla1.web.kernel.org [172.20.200.51])
	by mail.kernel.org (Postfix) with ESMTP id 5D8512021F
	for <linux-ext4@vger.kernel.org>; Sat, 16 Apr 2016 02:31:03 +0000 (UTC)
In-Reply-To: <bug-116471-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=116471

Christian Kujau <lists@nerdbynature.de> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |lists@nerdbynature.de

--- Comment #2 from Christian Kujau <lists@nerdbynature.de> ---
A similar message has been reported in the CentOS bugtracker last year:
https://bugs.centos.org/view.php?id=9080, which also shows ext4 involved. Wow,
I even found a posting of my own: https://lkml.org/lkml/2004/5/21/242 - but
back then fs/buffer.c:1270 probably meant something completely different :-)

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
