From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 42859] kernel BUG at fs/ext4/extents.c:1953
Date: Wed, 13 Jun 2012 15:14:44 +0000 (UTC)
Message-ID: <20120613151444.A8445120610@bugzilla.kernel.org>
References: <bug-42859-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:51875 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752659Ab2FMPOr (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 13 Jun 2012 11:14:47 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id F12CB203C4
	for <linux-ext4@vger.kernel.org>; Wed, 13 Jun 2012 15:14:45 +0000 (UTC)
Received: from bugzilla.kernel.org (bugzilla.kernel.org [198.145.19.204])
	by mail.kernel.org (Postfix) with ESMTP id ABED5203BE
	for <linux-ext4@vger.kernel.org>; Wed, 13 Jun 2012 15:14:44 +0000 (UTC)
In-Reply-To: <bug-42859-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=42859


Alan <alan@lxorguk.ukuu.org.uk> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
             Status|RESOLVED                    |CLOSED




-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
