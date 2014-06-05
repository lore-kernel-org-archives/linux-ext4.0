From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 40822] EXT4-fs error (device dm-4): ext4_lookup:1044: inode
 #3308277: comm rm: deleted inode referenced: 3058008
Date: Thu, 05 Jun 2014 14:59:35 +0000
Message-ID: <bug-40822-13602-gD9eJUuqDF@https.bugzilla.kernel.org/>
References: <bug-40822-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:35411 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752068AbaFEO7i (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 5 Jun 2014 10:59:38 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 2E0512035E
	for <linux-ext4@vger.kernel.org>; Thu,  5 Jun 2014 14:59:37 +0000 (UTC)
Received: from bugzilla2.web.kernel.org (bugzilla2.web.kernel.org [172.20.200.52])
	by mail.kernel.org (Postfix) with ESMTP id C470C20154
	for <linux-ext4@vger.kernel.org>; Thu,  5 Jun 2014 14:59:35 +0000 (UTC)
In-Reply-To: <bug-40822-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=40822

Sebastien Koechlin <seb.kernel@koocotte.org> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
             Status|NEW                         |RESOLVED
         Resolution|---                         |INVALID

--- Comment #7 from Sebastien Koechlin <seb.kernel@koocotte.org> ---
It's a Debian system, it's performing an array-check every month (by echoing
check into relevant /sys/block/$array/md/sync_action) and I have never seen any
error in dmesg.

But I found a strange drive, its SMART attributes were not updated for more
than 6 month (Power_On_Hours in particular).

I changed this drive and I can not reproduce any error. You've probably guessed
right; so I close this bug.

Thanks a lot.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
