From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 13964] ext4: panic causes lost data in git
Date: Fri, 28 Aug 2009 19:34:17 GMT
Message-ID: <200908281934.n7SJYH9k017752@demeter.kernel.org>
References: <bug-13964-13602@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:56116 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752389AbZH1TeP (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 28 Aug 2009 15:34:15 -0400
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.2/8.14.2) with ESMTP id n7SJYH7l017753
	for <linux-ext4@vger.kernel.org>; Fri, 28 Aug 2009 19:34:17 GMT
In-Reply-To: <bug-13964-13602@http.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

http://bugzilla.kernel.org/show_bug.cgi?id=13964


Roland Kletzing <devzero@web.de> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |devzero@web.de




--- Comment #2 from Roland Kletzing <devzero@web.de>  2009-08-28 19:34:16 ---
i also have seen this issue, but i can`t find alloc_on_commit option in latest
.git kernel.  hasn`t the appropriate patch been merged?

-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
