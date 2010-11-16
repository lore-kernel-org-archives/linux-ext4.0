From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 22302] 2.6.36 BUG: scheduling while atomic:
 rc.sysinit/1376/0x00000002
Date: Tue, 16 Nov 2010 18:26:43 GMT
Message-ID: <201011161826.oAGIQhoL016907@demeter1.kernel.org>
References: <bug-22302-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter1.kernel.org ([140.211.167.39]:55784 "EHLO
	demeter1.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756567Ab0KPS0o (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 16 Nov 2010 13:26:44 -0500
Received: from demeter1.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter1.kernel.org (8.14.4/8.14.3) with ESMTP id oAGIQhes016908
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Tue, 16 Nov 2010 18:26:44 GMT
In-Reply-To: <bug-22302-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=22302


Florian Mickler <florian@mickler.org> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
             Status|NEW                         |RESOLVED
                 CC|                            |florian@mickler.org
         Resolution|                            |CODE_FIX




--- Comment #2 from Florian Mickler <florian@mickler.org>  2010-11-16 18:26:42 ---
Fixed by:
commit b56ff9d397cecdaad6c98c9d57cc6fea475e1f50
Author: Theodore Ts'o <tytso@mit.edu>
Date:   Mon Nov 8 13:49:33 2010 -0500

    ext4: Don't call sb_issue_discard() in ext4_free_blocks()

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
