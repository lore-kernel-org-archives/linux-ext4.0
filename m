From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 14602] JBD2 journal abort / checkpoint creation racy?
Date: Mon, 16 Nov 2009 16:04:35 GMT
Message-ID: <200911161604.nAGG4ZVH026084@demeter.kernel.org>
References: <bug-14602-13602@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:41320 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752613AbZKPQEb (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 16 Nov 2009 11:04:31 -0500
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.2/8.14.2) with ESMTP id nAGG4aGg026085
	for <linux-ext4@vger.kernel.org>; Mon, 16 Nov 2009 16:04:36 GMT
In-Reply-To: <bug-14602-13602@http.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

http://bugzilla.kernel.org/show_bug.cgi?id=14602





--- Comment #2 from Andi Kleen <andi-bz@firstfloor.org>  2009-11-16 16:04:33 ---
Hmm, it still seems strange because sometimes the error happens and more often
not, even when triggering the same underlying inode IO error. I think
something is at least inconsistent.

-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
