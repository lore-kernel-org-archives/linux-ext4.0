From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 48751] ext3: ctime changes with no reason in 30 seconds after a
 file change
Date: Sun, 14 Oct 2012 12:28:12 +0000 (UTC)
Message-ID: <20121014122812.54CA811FB3D@bugzilla.kernel.org>
References: <bug-48751-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:41200 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752882Ab2JNM2P (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 14 Oct 2012 08:28:15 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 768EE20212
	for <linux-ext4@vger.kernel.org>; Sun, 14 Oct 2012 12:28:13 +0000 (UTC)
Received: from bugzilla.kernel.org (bugzilla.kernel.org [198.145.19.217])
	by mail.kernel.org (Postfix) with ESMTP id 7FA2620206
	for <linux-ext4@vger.kernel.org>; Sun, 14 Oct 2012 12:28:12 +0000 (UTC)
In-Reply-To: <bug-48751-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=48751


Alan <alan@lxorguk.ukuu.org.uk> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |alan@lxorguk.ukuu.org.uk




--- Comment #2 from Alan <alan@lxorguk.ukuu.org.uk>  2012-10-14 12:28:12 ---
Does this go away if you mount without "relatime" ?

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
