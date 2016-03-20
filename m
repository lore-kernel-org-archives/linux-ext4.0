From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 108631] Stuck on mb_cache_spinlock
Date: Sun, 20 Mar 2016 21:54:18 +0000
Message-ID: <bug-108631-13602-knS55QyHz1@https.bugzilla.kernel.org/>
References: <bug-108631-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:55051 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750760AbcCTVyV (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 20 Mar 2016 17:54:21 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 17E78202B8
	for <linux-ext4@vger.kernel.org>; Sun, 20 Mar 2016 21:54:20 +0000 (UTC)
Received: from bugzilla1.web.kernel.org (bugzilla1.web.kernel.org [172.20.200.51])
	by mail.kernel.org (Postfix) with ESMTP id 93EF520225
	for <linux-ext4@vger.kernel.org>; Sun, 20 Mar 2016 21:54:18 +0000 (UTC)
In-Reply-To: <bug-108631-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=108631

Theodore Tso <tytso@mit.edu> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
             Status|ASSIGNED                    |RESOLVED
         Resolution|---                         |CODE_FIX

--- Comment #8 from Theodore Tso <tytso@mit.edu> ---
These patches have been pushed to Linus, and will be in Linux 4.6.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
