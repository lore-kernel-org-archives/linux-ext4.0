From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 43017] Freezing on poweroff (kworker, swapper)
Date: Tue,  4 Sep 2012 11:14:36 +0000 (UTC)
Message-ID: <20120904111436.6867A11FC3E@bugzilla.kernel.org>
References: <bug-43017-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:33047 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756778Ab2IDLOj (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 4 Sep 2012 07:14:39 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id E8B84201CF
	for <linux-ext4@vger.kernel.org>; Tue,  4 Sep 2012 11:14:38 +0000 (UTC)
Received: from bugzilla.kernel.org (unknown [198.145.19.217])
	by mail.kernel.org (Postfix) with ESMTP id 6E37320216
	for <linux-ext4@vger.kernel.org>; Tue,  4 Sep 2012 11:14:36 +0000 (UTC)
In-Reply-To: <bug-43017-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=43017


Alan <alan@lxorguk.ukuu.org.uk> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
             Status|NEW                         |RESOLVED
                 CC|                            |alan@lxorguk.ukuu.org.uk
         Resolution|                            |INVALID




--- Comment #1 from Alan <alan@lxorguk.ukuu.org.uk>  2012-09-04 11:14:36 ---
It should go to Fedora. If sysrq/kill works its almost certainly a user space
bug.

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
