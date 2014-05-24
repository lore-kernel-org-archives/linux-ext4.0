From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 76821] jbd2 write on disk each 5/6 seconds
Date: Sat, 24 May 2014 12:39:43 +0000
Message-ID: <bug-76821-13602-6ZMOdrFscJ@https.bugzilla.kernel.org/>
References: <bug-76821-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:39802 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750845AbaEXMjr (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 24 May 2014 08:39:47 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 3224720268
	for <linux-ext4@vger.kernel.org>; Sat, 24 May 2014 12:39:46 +0000 (UTC)
Received: from bugzilla2.web.kernel.org (bugzilla2.web.kernel.org [172.20.200.52])
	by mail.kernel.org (Postfix) with ESMTP id EF9A020274
	for <linux-ext4@vger.kernel.org>; Sat, 24 May 2014 12:39:43 +0000 (UTC)
In-Reply-To: <bug-76821-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=76821

Abdelhak Bougouffa <abdelhak@cryptolab.net> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
     Kernel Version|3.14.4-1-ARCH               |3.14.4-1-ARCH,
                   |                            |3.10.40-1-lts

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
