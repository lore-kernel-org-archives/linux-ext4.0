From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 15576] Data Loss (flex_bg and ext4_mb_generate_buddy errors)
Date: Mon, 28 Feb 2011 01:20:47 GMT
Message-ID: <201102280120.p1S1KlP5026594@demeter2.kernel.org>
References: <bug-15576-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter2.kernel.org ([140.211.167.42]:43366 "EHLO
	demeter2.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752085Ab1B1BUs (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 27 Feb 2011 20:20:48 -0500
Received: from demeter2.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter2.kernel.org (8.14.4/8.14.3) with ESMTP id p1S1Kl9i026595
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Mon, 28 Feb 2011 01:20:48 GMT
In-Reply-To: <bug-15576-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=15576


Theodore Tso <tytso@mit.edu> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |tytso@mit.edu
     Kernel Version|Linux elitemx-desktop       |2.6.31-20-generic
                   |2.6.31-20-generic           |#58-Ubuntu SMP
                   |#58-Ubuntu SMP Fri Mar 12   |
                   |05:23:09 UTC 2010 i686      |
                   |GNU/Linux                   |




-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
