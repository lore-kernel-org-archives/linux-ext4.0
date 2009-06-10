From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 13230] unexplained fsck error with ext4 on software raid 10
Date: Wed, 10 Jun 2009 13:53:12 GMT
Message-ID: <200906101353.n5ADrCU5002233@demeter.kernel.org>
References: <bug-13230-13602@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:33380 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753832AbZFJNxM (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 10 Jun 2009 09:53:12 -0400
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.2/8.14.2) with ESMTP id n5ADrC8U002234
	for <linux-ext4@vger.kernel.org>; Wed, 10 Jun 2009 13:53:12 GMT
In-Reply-To: <bug-13230-13602@http.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

http://bugzilla.kernel.org/show_bug.cgi?id=13230


Theodore Tso <tytso@mit.edu> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
             Status|RESOLVED                    |CLOSED




--- Comment #6 from Theodore Tso <tytso@mit.edu>  2009-06-10 13:53:11 ---
Yes, this patch is in 2.6.30, and it's in the 2.6.27.y and 2.6.29.y patches
which Greg sent out for review yesterday.  So 2.6.27.25 and 2.6.29.5 should
have this patch when they get released next week.

-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
