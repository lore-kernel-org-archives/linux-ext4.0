From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 76821] jbd2 write on disk each 2/3 seconds
Date: Sat, 24 May 2014 12:40:01 +0000
Message-ID: <bug-76821-13602-TDhTi0sRVG@https.bugzilla.kernel.org/>
References: <bug-76821-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:39816 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750845AbaEXMkD (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 24 May 2014 08:40:03 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 1CE3020295
	for <linux-ext4@vger.kernel.org>; Sat, 24 May 2014 12:40:02 +0000 (UTC)
Received: from bugzilla2.web.kernel.org (bugzilla2.web.kernel.org [172.20.200.52])
	by mail.kernel.org (Postfix) with ESMTP id 6E68920274
	for <linux-ext4@vger.kernel.org>; Sat, 24 May 2014 12:40:01 +0000 (UTC)
In-Reply-To: <bug-76821-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=76821

Abdelhak Bougouffa <abdelhak@cryptolab.net> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
            Summary|jbd2 write on disk each 5/6 |jbd2 write on disk each 2/3
                   |seconds                     |seconds

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
