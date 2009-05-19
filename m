From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 12829] kernel complains on ENOSPC
Date: Tue, 19 May 2009 19:24:04 GMT
Message-ID: <200905191924.n4JJO4bl021138@demeter.kernel.org>
References: <bug-12829-13602@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:33892 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752811AbZESTYC (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 19 May 2009 15:24:02 -0400
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.2/8.14.2) with ESMTP id n4JJO4Pi021139
	for <linux-ext4@vger.kernel.org>; Tue, 19 May 2009 19:24:04 GMT
In-Reply-To: <bug-12829-13602@http.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

http://bugzilla.kernel.org/show_bug.cgi?id=12829


Theodore Tso <tytso@mit.edu> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |tytso@mit.edu
         Regression|---                         |No




--- Comment #5 from Theodore Tso <tytso@mit.edu>  2009-05-19 19:24:03 ---
Eric --- as a reminder, when you have a chance can you dig into this?   This
can cause data loss, so we really should return ENOSPC instead of syslogging
the error.

-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
