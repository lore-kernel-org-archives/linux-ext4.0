From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 112631] Cannot open encrypted Luks filesystem. Cruptsetup
 error.
Date: Tue, 23 Feb 2016 09:37:07 +0000
Message-ID: <bug-112631-13602-Zh5plYxgaQ@https.bugzilla.kernel.org/>
References: <bug-112631-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:50050 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750893AbcBWJhM (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 23 Feb 2016 04:37:12 -0500
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 3CE7D20437
	for <linux-ext4@vger.kernel.org>; Tue, 23 Feb 2016 09:37:10 +0000 (UTC)
Received: from bugzilla2.web.kernel.org (bugzilla2.web.kernel.org [172.20.200.52])
	by mail.kernel.org (Postfix) with ESMTP id A0ACE2035E
	for <linux-ext4@vger.kernel.org>; Tue, 23 Feb 2016 09:37:07 +0000 (UTC)
In-Reply-To: <bug-112631-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=112631

Philipp Dijkstal <philipp.dijkstal@web.de> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |philipp.dijkstal@web.de

--- Comment #16 from Philipp Dijkstal <philipp.dijkstal@web.de> ---
Yes. After today's upgrade to cryptsetup 1.7.0-2, it is resolved on my Arch
System with 4.1.18 lts kernel.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
