From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 48751] ext3: ctime changes with no reason in 30 seconds after a
 file change
Date: Sat, 13 Oct 2012 18:11:20 +0000 (UTC)
Message-ID: <20121013181120.BDABB11FB05@bugzilla.kernel.org>
References: <bug-48751-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:58143 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753972Ab2JMSLW (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 13 Oct 2012 14:11:22 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id C2C102024A
	for <linux-ext4@vger.kernel.org>; Sat, 13 Oct 2012 18:11:21 +0000 (UTC)
Received: from bugzilla.kernel.org (bugzilla.kernel.org [198.145.19.217])
	by mail.kernel.org (Postfix) with ESMTP id C28BA20248
	for <linux-ext4@vger.kernel.org>; Sat, 13 Oct 2012 18:11:20 +0000 (UTC)
In-Reply-To: <bug-48751-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=48751


Vladimir A. Pavlov <pv4@bk.ru> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |pv4@bk.ru
           Platform|All                         |i386




--- Comment #1 from Vladimir A. Pavlov <pv4@bk.ru>  2012-10-13 18:11:20 ---
> 3.2 or above (3.6.1 is still as well)

I mean 3.6.1 is affected as well

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
