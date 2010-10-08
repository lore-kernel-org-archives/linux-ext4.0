From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 19362] WARNING: at fs/fs-writeback.c:87
 __mark_inode_dirty+0x1f2/0x230()
Date: Fri, 8 Oct 2010 12:44:18 GMT
Message-ID: <201010081244.o98CiI4Q027497@demeter1.kernel.org>
References: <bug-19362-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:50354 "EHLO
	demeter1.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753149Ab0JHMoS (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 8 Oct 2010 08:44:18 -0400
Received: from demeter1.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter1.kernel.org (8.14.4/8.14.3) with ESMTP id o98CiIH2027528
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Fri, 8 Oct 2010 12:44:18 GMT
In-Reply-To: <bug-19362-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=19362


Thomas Renninger <trenn@suse.de> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
             Status|NEW                         |RESOLVED
         Resolution|                            |DUPLICATE




--- Comment #4 from Thomas Renninger <trenn@suse.de>  2010-10-08 12:44:12 ---
Same warning...

*** This bug has been marked as a duplicate of bug 19062 ***

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
