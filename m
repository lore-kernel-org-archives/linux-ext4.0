From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 42362] [ext4] possible circular locking dependency detected
Date: Fri, 29 Apr 2016 17:39:21 +0000
Message-ID: <bug-42362-13602-NzjR3XEKWx@https.bugzilla.kernel.org/>
References: <bug-42362-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:41770 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751331AbcD2Rj0 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 29 Apr 2016 13:39:26 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id CF4172011D
	for <linux-ext4@vger.kernel.org>; Fri, 29 Apr 2016 17:39:24 +0000 (UTC)
Received: from bugzilla2.web.kernel.org (bugzilla2.web.kernel.org [172.20.200.52])
	by mail.kernel.org (Postfix) with ESMTP id 0EA922015E
	for <linux-ext4@vger.kernel.org>; Fri, 29 Apr 2016 17:39:22 +0000 (UTC)
In-Reply-To: <bug-42362-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=42362

Ivan Bulatovic <combuster@archlinux.us> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
             Status|NEW                         |RESOLVED
         Resolution|---                         |OBSOLETE

--- Comment #2 from Ivan Bulatovic <combuster@archlinux.us> ---
No problems with 4.6.0-rc5. Too late to bisect now, so marking this as
resolved.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
