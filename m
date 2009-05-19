From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 12624] umount hangs after fsstress with data=journal
Date: Tue, 19 May 2009 19:16:32 GMT
Message-ID: <200905191916.n4JJGW4M020573@demeter.kernel.org>
References: <bug-12624-13602@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:53799 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751979AbZESTQa (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 19 May 2009 15:16:30 -0400
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.2/8.14.2) with ESMTP id n4JJGWmt020574
	for <linux-ext4@vger.kernel.org>; Tue, 19 May 2009 19:16:32 GMT
In-Reply-To: <bug-12624-13602@http.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

http://bugzilla.kernel.org/show_bug.cgi?id=12624


Theodore Tso <tytso@mit.edu> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |tytso@mit.edu
         Regression|---                         |No




--- Comment #1 from Theodore Tso <tytso@mit.edu>  2009-05-19 19:16:31 ---
Aneesh, can you reproduce this on a more modern kernel?

-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
