From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 12686] kernel oops __ticket_spin_lock
Date: Tue, 19 May 2009 19:08:39 GMT
Message-ID: <200905191908.n4JJ8d46019871@demeter.kernel.org>
References: <bug-12686-13602@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:33106 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753693AbZESTIi (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 19 May 2009 15:08:38 -0400
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.2/8.14.2) with ESMTP id n4JJ8dRk019872
	for <linux-ext4@vger.kernel.org>; Tue, 19 May 2009 19:08:39 GMT
In-Reply-To: <bug-12686-13602@http.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

http://bugzilla.kernel.org/show_bug.cgi?id=12686


Theodore Tso <tytso@mit.edu> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
             Status|NEW                         |RESOLVED
                 CC|                            |tytso@mit.edu
         Resolution|                            |UNREPRODUCIBLE
         Regression|---                         |No




--- Comment #3 from Theodore Tso <tytso@mit.edu>  2009-05-19 19:08:39 ---
I can't reproduce this on a recent kernel.  Even after removing the bogus
indirect and triple indirect block which causes modern kernels to refuse to
mount the filesystem, it still doesn't crash, even after giving all of the
ext4_claim_inode() errors caused by the very large s_first_ino value.   So it
looks like this problem is no longer an issue on 2.6.30-rc6 kernels.

-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
