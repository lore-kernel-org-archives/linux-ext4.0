From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 111891] access to file does not change access time to folders
 above up to /(root)
Date: Fri, 05 Feb 2016 02:58:24 +0000
Message-ID: <bug-111891-13602-uaKOmeGgMf@https.bugzilla.kernel.org/>
References: <bug-111891-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:40925 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750729AbcBEC62 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 4 Feb 2016 21:58:28 -0500
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id B54A0202F2
	for <linux-ext4@vger.kernel.org>; Fri,  5 Feb 2016 02:58:27 +0000 (UTC)
Received: from bugzilla1.web.kernel.org (bugzilla1.web.kernel.org [172.20.200.51])
	by mail.kernel.org (Postfix) with ESMTP id 2B8F620357
	for <linux-ext4@vger.kernel.org>; Fri,  5 Feb 2016 02:58:25 +0000 (UTC)
In-Reply-To: <bug-111891-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=111891

Armin Mohring <armin_mohring@web.de> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
             Status|NEW                         |RESOLVED
         Resolution|---                         |WILL_NOT_FIX

--- Comment #2 from Armin Mohring <armin_mohring@web.de> ---
I thought it would be a good idea to change this behaviour.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
