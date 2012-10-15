From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 47611] NULL pointer dereference in ext4_ext_remove_space on
 3.5.1
Date: Mon, 15 Oct 2012 08:59:13 +0000 (UTC)
Message-ID: <20121015085913.A9AFC11FC6C@bugzilla.kernel.org>
References: <bug-47611-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:59573 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751560Ab2JOI7R (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 15 Oct 2012 04:59:17 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 24DB1201F0
	for <linux-ext4@vger.kernel.org>; Mon, 15 Oct 2012 08:59:16 +0000 (UTC)
Received: from bugzilla.kernel.org (bugzilla.kernel.org [198.145.19.217])
	by mail.kernel.org (Postfix) with ESMTP id 582B2201E4
	for <linux-ext4@vger.kernel.org>; Mon, 15 Oct 2012 08:59:15 +0000 (UTC)
In-Reply-To: <bug-47611-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=47611


Mehmet Giritli <mehmet@giritli.eu> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |mehmet@giritli.eu




--- Comment #7 from Mehmet Giritli <mehmet@giritli.eu>  2012-10-15 08:59:13 ---
*** Bug 48711 has been marked as a duplicate of this bug. ***

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
