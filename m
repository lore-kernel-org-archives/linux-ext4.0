From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 14315] kernel BUG at fs/ext4/inode.c
Date: Sat, 3 Oct 2009 17:41:38 GMT
Message-ID: <200910031741.n93HfcvZ029468@demeter.kernel.org>
References: <bug-14315-13602@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:58553 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750896AbZJCRmO (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 3 Oct 2009 13:42:14 -0400
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.2/8.14.2) with ESMTP id n93HfcSp029469
	for <linux-ext4@vger.kernel.org>; Sat, 3 Oct 2009 17:41:38 GMT
In-Reply-To: <bug-14315-13602@http.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

http://bugzilla.kernel.org/show_bug.cgi?id=14315


Theodore Tso <tytso@mit.edu> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
             Status|NEW                         |RESOLVED
                 CC|                            |tytso@mit.edu
         Resolution|                            |DUPLICATE




--- Comment #1 from Theodore Tso <tytso@mit.edu>  2009-10-03 17:41:37 ---


*** This bug has been marked as a duplicate of bug 14300 ***

-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
