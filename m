From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 16223] ext4 in data=journal mode does not support delayed
 allocation
Date: Fri, 20 Jul 2012 13:56:22 +0000 (UTC)
Message-ID: <20120720135622.E327D11FACE@bugzilla.kernel.org>
References: <bug-16223-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:33746 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750944Ab2GTN41 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 20 Jul 2012 09:56:27 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id E62DB20212
	for <linux-ext4@vger.kernel.org>; Fri, 20 Jul 2012 13:56:25 +0000 (UTC)
Received: from bugzilla.kernel.org (unknown [198.145.19.217])
	by mail.kernel.org (Postfix) with ESMTP id 4475F201F3
	for <linux-ext4@vger.kernel.org>; Fri, 20 Jul 2012 13:56:24 +0000 (UTC)
In-Reply-To: <bug-16223-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=16223


Timothy Miller <theosib@gmail.com> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
             Status|RESOLVED                    |REOPENED
         Resolution|OBSOLETE                    |




--- Comment #1 from Timothy Miller <theosib@gmail.com>  2012-07-20 13:56:22 ---
Why was this marked obsolete?

According to this documentation on kernel.org, ext4 still does not support
delayed allocation in data=journal mode:

http://kernel.org/doc/Documentation/filesystems/ext4.txt

I've also spent some time googling this, and I haven't been able to find any
announcement that this has been fixed.

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
