From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 114621] /etc/fstab: impossible to disable relatime
Date: Tue, 15 Mar 2016 17:32:21 +0000
Message-ID: <bug-114621-13602-I7RwfWbLhz@https.bugzilla.kernel.org/>
References: <bug-114621-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:43630 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934230AbcCORcZ (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 15 Mar 2016 13:32:25 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 9B8BB20304
	for <linux-ext4@vger.kernel.org>; Tue, 15 Mar 2016 17:32:23 +0000 (UTC)
Received: from bugzilla2.web.kernel.org (bugzilla2.web.kernel.org [172.20.200.52])
	by mail.kernel.org (Postfix) with ESMTP id 2880A2021B
	for <linux-ext4@vger.kernel.org>; Tue, 15 Mar 2016 17:32:22 +0000 (UTC)
In-Reply-To: <bug-114621-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=114621

Armin Mohring <armin_mohring@web.de> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
             Status|RESOLVED                    |REOPENED
         Resolution|INVALID                     |---

--- Comment #2 from Armin Mohring <armin_mohring@web.de> ---
I have disabled relatime in fstab.
And this error did not occur.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
