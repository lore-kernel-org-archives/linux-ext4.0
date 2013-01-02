From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 48431] [PATCH]ext4_fill_super() reports success even if
 ext4_mb_init() fails
Date: Wed,  2 Jan 2013 17:00:19 +0000 (UTC)
Message-ID: <20130102170019.3BE5A11FF02@bugzilla.kernel.org>
References: <bug-48431-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:38670 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752591Ab3ABRA1 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 2 Jan 2013 12:00:27 -0500
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id C73BE20308
	for <linux-ext4@vger.kernel.org>; Wed,  2 Jan 2013 17:00:26 +0000 (UTC)
Received: from bugzilla.kernel.org (bugzilla.kernel.org [198.145.19.217])
	by mail.kernel.org (Postfix) with ESMTP id 9CC3E20310
	for <linux-ext4@vger.kernel.org>; Wed,  2 Jan 2013 17:00:23 +0000 (UTC)
In-Reply-To: <bug-48431-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=48431


Alan <alan@lxorguk.ukuu.org.uk> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
             Status|NEW                         |RESOLVED
         Resolution|                            |CODE_FIX




-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
