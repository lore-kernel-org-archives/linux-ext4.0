From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 47611] NULL pointer dereference in ext4_ext_remove_space on
 3.5.1
Date: Wed, 19 Sep 2012 18:02:40 +0000 (UTC)
Message-ID: <20120919180240.6882B11FA33@bugzilla.kernel.org>
References: <bug-47611-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:42945 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932791Ab2ISSCr (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 19 Sep 2012 14:02:47 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id A5B2720331
	for <linux-ext4@vger.kernel.org>; Wed, 19 Sep 2012 18:02:42 +0000 (UTC)
Received: from bugzilla.kernel.org (unknown [198.145.19.217])
	by mail.kernel.org (Postfix) with ESMTP id 6D25C2028C
	for <linux-ext4@vger.kernel.org>; Wed, 19 Sep 2012 18:02:40 +0000 (UTC)
In-Reply-To: <bug-47611-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=47611


costinel@gmail.com changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |costinel@gmail.com




--- Comment #5 from costinel@gmail.com  2012-09-19 18:02:40 ---
Does this bug affect 3.2.0?

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
