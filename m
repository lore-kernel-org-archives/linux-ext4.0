From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 14354] Bad corruption with 2.6.32-rc1 and upwards
Date: Tue, 3 Nov 2009 13:58:29 GMT
Message-ID: <200911031358.nA3DwTHw008484@demeter.kernel.org>
References: <bug-14354-13602@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:38157 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750816AbZKCN60 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 3 Nov 2009 08:58:26 -0500
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.2/8.14.2) with ESMTP id nA3DwUj1008485
	for <linux-ext4@vger.kernel.org>; Tue, 3 Nov 2009 13:58:30 GMT
In-Reply-To: <bug-14354-13602@http.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

http://bugzilla.kernel.org/show_bug.cgi?id=14354





--- Comment #172 from Theodore Tso <tytso@mit.edu>  2009-11-03 13:58:25 ---
There's a lot more we need to understand --- including why we weren't seeing a
printk message indicating a journal checksum, and which commit was showing the
checksum failure, and why we ended up seeing a checksum failure in the first
place.   If it was the last commit that was being written right before the
system crash, the commit block simply should have been missing due to the
barrier.   But we can do this without having to worry about 2.6.32 being a QA
disaster for ext4.  :-)

-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
