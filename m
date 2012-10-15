From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 47731] Null pointer dereference at strchr
Date: Mon, 15 Oct 2012 21:18:33 +0000 (UTC)
Message-ID: <20121015211833.9BFC111FC43@bugzilla.kernel.org>
References: <bug-47731-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:52202 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753491Ab2JOVSg (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 15 Oct 2012 17:18:36 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 3C13D2024C
	for <linux-ext4@vger.kernel.org>; Mon, 15 Oct 2012 21:18:35 +0000 (UTC)
Received: from bugzilla.kernel.org (bugzilla.kernel.org [198.145.19.217])
	by mail.kernel.org (Postfix) with ESMTP id A62C020272
	for <linux-ext4@vger.kernel.org>; Mon, 15 Oct 2012 21:18:33 +0000 (UTC)
In-Reply-To: <bug-47731-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=47731


Florian Mickler <florian@mickler.org> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |florian@mickler.org




--- Comment #6 from Florian Mickler <florian@mickler.org>  2012-10-15 21:18:33 ---
A patch referencing this bug report has been merged in Linux v3.7-rc1:

commit 50df9fd55e4271e89a7adf3b1172083dd0ca199d
Author: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Date:   Sun Sep 23 22:49:12 2012 -0400

    ext4: fix crash when accessing /proc/mounts concurrently

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
