From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 14601] Wrong handling of META_BG when getting number of blocks
 for group descriptors
Date: Tue, 17 Nov 2009 22:57:24 GMT
Message-ID: <200911172257.nAHMvOmo019348@demeter.kernel.org>
References: <bug-14601-13602@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:43295 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756799AbZKQW5S (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 17 Nov 2009 17:57:18 -0500
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.2/8.14.2) with ESMTP id nAHMvO2f019349
	for <linux-ext4@vger.kernel.org>; Tue, 17 Nov 2009 22:57:24 GMT
In-Reply-To: <bug-14601-13602@http.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

http://bugzilla.kernel.org/show_bug.cgi?id=14601


Theodore Tso <tytso@mit.edu> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |tytso@mit.edu




--- Comment #2 from Theodore Tso <tytso@mit.edu>  2009-11-17 22:57:23 ---
Jan, I have a IMHO better set of patches which I plan to merge for ext4; it
ends up simplifying the code, and makes it easier to read.   I'll backport my
ext4 fixes to ext3 and send them to you.  It's on my todo list.

-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
