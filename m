From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 101011] Kernel Oops when disconnecting a mounted ext4 usb stick
Date: Fri, 14 Aug 2015 11:02:14 +0000
Message-ID: <bug-101011-13602-98MZYFz3Q1@https.bugzilla.kernel.org/>
References: <bug-101011-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:40035 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754268AbbHNLCS (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 14 Aug 2015 07:02:18 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id EC62C207D8
	for <linux-ext4@vger.kernel.org>; Fri, 14 Aug 2015 11:02:16 +0000 (UTC)
Received: from bugzilla1.web.kernel.org (bugzilla1.web.kernel.org [172.20.200.51])
	by mail.kernel.org (Postfix) with ESMTP id 62845207D0
	for <linux-ext4@vger.kernel.org>; Fri, 14 Aug 2015 11:02:14 +0000 (UTC)
In-Reply-To: <bug-101011-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=101011

Maciej Szmigiero <mail@maciej.szmigiero.name> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |mail@maciej.szmigiero.name

--- Comment #7 from Maciej Szmigiero <mail@maciej.szmigiero.name> ---
I can also confirm that this bug is present in latest stable kernel (4.1.5) and
reverting commit from comment 6 seems to fix it.

-- 
You are receiving this mail because:
You are on the CC list for the bug.
