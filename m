From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 50261] Invalid d_type on readdir(), but e2fsck sees correct
 type
Date: Mon, 22 Jul 2013 16:28:07 +0000
Message-ID: <bug-50261-13602-tlyJH2eW9b@https.bugzilla.kernel.org/>
References: <bug-50261-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:42007 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755648Ab3GVQ2X (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 22 Jul 2013 12:28:23 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 22D202030E
	for <linux-ext4@vger.kernel.org>; Mon, 22 Jul 2013 16:28:18 +0000 (UTC)
Received: from bugzilla1.web.kernel.org (bugzilla1.web.kernel.org [172.20.200.51])
	by mail.kernel.org (Postfix) with ESMTP id 276E720306
	for <linux-ext4@vger.kernel.org>; Mon, 22 Jul 2013 16:28:08 +0000 (UTC)
In-Reply-To: <bug-50261-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=50261

Bernd Schubert <bernd.schubert@fastmail.fm> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
             Status|NEW                         |RESOLVED
     Kernel Version|                            |3.11
         Resolution|---                         |OBSOLETE

--- Comment #1 from Bernd Schubert <bernd.schubert@fastmail.fm> ---
Hmm, no idea why, but I cannot reproduce it anymore. When it occured it was
very reproducible, but I didn't have time to investigate that time.
So I'm closing it for now.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
