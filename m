From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 121371] fsck created undeletable directory
Date: Sun, 03 Jul 2016 16:03:51 +0000
Message-ID: <bug-121371-13602-Gstl4knBWN@https.bugzilla.kernel.org/>
References: <bug-121371-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:58602 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752646AbcGCQDz (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 3 Jul 2016 12:03:55 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 136EB202D1
	for <linux-ext4@vger.kernel.org>; Sun,  3 Jul 2016 16:03:53 +0000 (UTC)
Received: from bugzilla1.web.kernel.org (bugzilla1.web.kernel.org [172.20.200.51])
	by mail.kernel.org (Postfix) with ESMTP id BCD022027D
	for <linux-ext4@vger.kernel.org>; Sun,  3 Jul 2016 16:03:51 +0000 (UTC)
In-Reply-To: <bug-121371-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=121371

Grief <iamgrief@gmail.com> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
             Status|NEW                         |RESOLVED
         Resolution|---                         |INVALID

--- Comment #2 from Grief <iamgrief@gmail.com> ---
Sorry. I've missed 'append only' attribute on a parent directory

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
