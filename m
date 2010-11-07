From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 22212] Crash in ext4_init_io_end
Date: Sun, 7 Nov 2010 21:27:11 GMT
Message-ID: <201011072127.oA7LRBqw028514@demeter1.kernel.org>
References: <bug-22212-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:40254 "EHLO
	demeter1.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753194Ab0KGV1L (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 7 Nov 2010 16:27:11 -0500
Received: from demeter1.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter1.kernel.org (8.14.4/8.14.3) with ESMTP id oA7LRBUX028515
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Sun, 7 Nov 2010 21:27:11 GMT
In-Reply-To: <bug-22212-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=22212


Theodore Tso <tytso@mit.edu> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |tytso@mit.edu
     Kernel Version|                            |2.6.37-rc1
         Regression|No                          |Yes




-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
