From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 43292] jdb2 lockup with ext3 and nfs
Date: Fri,  2 Nov 2012 15:46:21 +0000 (UTC)
Message-ID: <20121102154621.95F8B11FB5A@bugzilla.kernel.org>
References: <bug-43292-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:57864 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757849Ab2KBPq2 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 2 Nov 2012 11:46:28 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id EAA5A202E6
	for <linux-ext4@vger.kernel.org>; Fri,  2 Nov 2012 15:46:23 +0000 (UTC)
Received: from bugzilla.kernel.org (bugzilla.kernel.org [198.145.19.217])
	by mail.kernel.org (Postfix) with ESMTP id DAEA7202D1
	for <linux-ext4@vger.kernel.org>; Fri,  2 Nov 2012 15:46:21 +0000 (UTC)
In-Reply-To: <bug-43292-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=43292


Florian Pritz <bluewind@xinu.at> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
             Status|NEW                         |RESOLVED
         Resolution|                            |UNREPRODUCIBLE




--- Comment #25 from Florian Pritz <bluewind@xinu.at>  2012-11-02 15:46:21 ---
I've recently switched my file server to xfs and can no longer reproduce this.
Since I seem to have been the only one with this issue, I'm closing this bug.

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
