From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 22212] Crash in ext4_init_io_end
Date: Sun, 7 Nov 2010 21:23:33 GMT
Message-ID: <201011072123.oA7LNXcX028130@demeter1.kernel.org>
References: <bug-22212-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:45573 "EHLO
	demeter1.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752625Ab0KGVXe (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 7 Nov 2010 16:23:34 -0500
Received: from demeter1.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter1.kernel.org (8.14.4/8.14.3) with ESMTP id oA7LNX4s028131
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Sun, 7 Nov 2010 21:23:33 GMT
In-Reply-To: <bug-22212-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=22212





--- Comment #3 from Theodore Tso <tytso@mit.edu>  2010-11-07 21:23:29 ---
Created an attachment (id=36582)
 --> (https://bugzilla.kernel.org/attachment.cgi?id=36582)
Proposed patch for problem

I think this should fix the problem.  Could folks who are seeing this please
test?

Many thanks!!

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
