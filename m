From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 42362] [ext4] possible circular locking dependency detected
Date: Wed, 25 Jun 2014 16:13:04 +0000
Message-ID: <bug-42362-13602-4B7S1aBQNj@https.bugzilla.kernel.org/>
References: <bug-42362-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:35282 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757203AbaFYQNI (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 25 Jun 2014 12:13:08 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 5EE132038C
	for <linux-ext4@vger.kernel.org>; Wed, 25 Jun 2014 16:13:07 +0000 (UTC)
Received: from bugzilla1.web.kernel.org (bugzilla1.web.kernel.org [172.20.200.51])
	by mail.kernel.org (Postfix) with ESMTP id CC62D20394
	for <linux-ext4@vger.kernel.org>; Wed, 25 Jun 2014 16:13:04 +0000 (UTC)
In-Reply-To: <bug-42362-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=42362

xerofoify@gmail.com changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |xerofoify@gmail.com

--- Comment #1 from xerofoify@gmail.com ---
Please test this bug to if it's fixed on the latest kernels.
Cheers Nick

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
