From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 66881] [3.12.1][ext4]kernel BUG at
 fs/ext4/extents_status.c:709!
Date: Thu, 12 Dec 2013 06:55:36 +0000
Message-ID: <bug-66881-13602-Dob48fUbS0@https.bugzilla.kernel.org/>
References: <bug-66881-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:37163 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751364Ab3LLGzi (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 12 Dec 2013 01:55:38 -0500
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id D984920811
	for <linux-ext4@vger.kernel.org>; Thu, 12 Dec 2013 06:55:37 +0000 (UTC)
Received: from bugzilla2.web.kernel.org (bugzilla2.web.kernel.org [172.20.200.52])
	by mail.kernel.org (Postfix) with ESMTP id 7C64A20808
	for <linux-ext4@vger.kernel.org>; Thu, 12 Dec 2013 06:55:36 +0000 (UTC)
In-Reply-To: <bug-66881-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=66881

Zheng Liu <gnehzuil.liu@gmail.com> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |gnehzuil.liu@gmail.com

--- Comment #1 from Zheng Liu <gnehzuil.liu@gmail.com> ---
This commit (0826a7e1) has been applied to the latest ext4/dev branch, and will
be merged into upstream kernel.

Regards,
                                                - Zheng

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
