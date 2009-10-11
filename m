From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 14354] Bad corruption with 2.6.32-rc1 and upwards
Date: Sun, 11 Oct 2009 01:26:15 GMT
Message-ID: <200910110126.n9B1QF4s014297@demeter.kernel.org>
References: <bug-14354-13602@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:34596 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751869AbZJKB0w (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 10 Oct 2009 21:26:52 -0400
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.2/8.14.2) with ESMTP id n9B1QFUR014298
	for <linux-ext4@vger.kernel.org>; Sun, 11 Oct 2009 01:26:15 GMT
In-Reply-To: <bug-14354-13602@http.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

http://bugzilla.kernel.org/show_bug.cgi?id=14354





--- Comment #11 from Theodore Tso <tytso@mit.edu>  2009-10-11 01:26:15 ---
One more question; is this a completely stock 2.6.32-rcX kernel, or is this one
with special patches from Ubuntu?  If so, can you give me a pointer to the
Ubuntu git tree and the commit ID that was used?

-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
