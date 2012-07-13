From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 44731] ext4 deadlock under heavy io?
Date: Fri, 13 Jul 2012 14:01:24 +0000 (UTC)
Message-ID: <20120713140124.D0AB611FAD0@bugzilla.kernel.org>
References: <bug-44731-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:50621 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757555Ab2GMOBc (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 13 Jul 2012 10:01:32 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 988A8201C3
	for <linux-ext4@vger.kernel.org>; Fri, 13 Jul 2012 14:01:31 +0000 (UTC)
Received: from bugzilla.kernel.org (unknown [198.145.19.217])
	by mail.kernel.org (Postfix) with ESMTP id ED84F201CD
	for <linux-ext4@vger.kernel.org>; Fri, 13 Jul 2012 14:01:25 +0000 (UTC)
In-Reply-To: <bug-44731-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=44731


Alan <alan@lxorguk.ukuu.org.uk> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |alan@lxorguk.ukuu.org.uk
     Kernel Version|Linux 3.2.0-23-generic      |3.2.0-23 x86_64
                   |#36-Ubuntu SMP Tue Apr 10   |
                   |20:39:51 UTC 2012 x86_64    |
                   |x86_64 x86_64 GNU/Linux     |




-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
