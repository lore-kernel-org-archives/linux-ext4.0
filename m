From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 42859] kernel BUG at fs/ext4/extents.c:1953
Date: Wed, 4 Apr 2012 14:59:32 GMT
Message-ID: <201204041459.q34ExWEB007761@bugzilla.kernel.org>
References: <bug-42859-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from bugzilla.kernel.org ([198.145.19.204]:41469 "EHLO
	bugzilla.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756354Ab2DDO7d (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 4 Apr 2012 10:59:33 -0400
Received: from bugzilla.kernel.org (localhost [127.0.0.1])
	by bugzilla.kernel.org (8.14.5/8.14.5) with ESMTP id q34ExW1R007762
	for <linux-ext4@vger.kernel.org>; Wed, 4 Apr 2012 14:59:32 GMT
In-Reply-To: <bug-42859-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=42859


Florian Mickler <florian@mickler.org> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |florian@mickler.org




--- Comment #1 from Florian Mickler <florian@mickler.org>  2012-04-04 14:59:31 ---
A patch referencing this bug report has been merged in Linux v3.4-rc1:

commit 31d4f3a2f3c73f279ff96a7135d7202ef6833f12
Author: Theodore Ts'o <tytso@mit.edu>
Date:   Sun Mar 11 23:30:16 2012 -0400

    ext4: check for zero length extent

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
