From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 42859] kernel BUG at fs/ext4/extents.c:1953
Date: Wed, 13 Jun 2012 15:14:39 +0000 (UTC)
Message-ID: <20120613151439.AEA6F12060F@bugzilla.kernel.org>
References: <bug-42859-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:51807 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753229Ab2FMPOm (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 13 Jun 2012 11:14:42 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 7CCB020378
	for <linux-ext4@vger.kernel.org>; Wed, 13 Jun 2012 15:14:41 +0000 (UTC)
Received: from bugzilla.kernel.org (bugzilla.kernel.org [198.145.19.204])
	by mail.kernel.org (Postfix) with ESMTP id 6D83E203BB
	for <linux-ext4@vger.kernel.org>; Wed, 13 Jun 2012 15:14:40 +0000 (UTC)
In-Reply-To: <bug-42859-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=42859


Alan <alan@lxorguk.ukuu.org.uk> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
             Status|NEW                         |RESOLVED
                 CC|                            |alan@lxorguk.ukuu.org.uk
         Resolution|                            |CODE_FIX




-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
