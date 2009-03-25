From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 12787] possible circular locking dependency
Date: Wed, 25 Mar 2009 16:49:33 GMT
Message-ID: <200903251649.n2PGnXPn011770@demeter.kernel.org>
References: <bug-12787-13602@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:35313 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752261AbZCYQtf (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 25 Mar 2009 12:49:35 -0400
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.2/8.14.2) with ESMTP id n2PGnXwC011771
	for <linux-ext4@vger.kernel.org>; Wed, 25 Mar 2009 16:49:33 GMT
In-Reply-To: <bug-12787-13602@http.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

http://bugzilla.kernel.org/show_bug.cgi?id=12787


Theodore Tso <tytso@mit.edu> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |tytso@mit.edu




--- Comment #7 from Theodore Tso <tytso@mit.edu>  2009-03-25 16:49:33 ---
Thanks for reminding me about this one.  I've added it to the commits to submit
to stable@kernel.org for the next stable release.

-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
