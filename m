From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 14300] BUG_ON crash w/ ext4
Date: Sat, 3 Oct 2009 22:17:41 GMT
Message-ID: <200910032217.n93MHfim028579@demeter.kernel.org>
References: <bug-14300-13602@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:44423 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751724AbZJCWSR (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 3 Oct 2009 18:18:17 -0400
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.2/8.14.2) with ESMTP id n93MHfY7028580
	for <linux-ext4@vger.kernel.org>; Sat, 3 Oct 2009 22:17:41 GMT
In-Reply-To: <bug-14300-13602@http.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

http://bugzilla.kernel.org/show_bug.cgi?id=14300


Theodore Tso <tytso@mit.edu> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
             Status|RESOLVED                    |CLOSED
                 CC|                            |tytso@mit.edu




--- Comment #3 from Theodore Tso <tytso@mit.edu>  2009-10-03 22:17:40 ---
The bugfix has now been merged into mainline.

-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
