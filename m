From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 42872] fstat()/ext3_iget() sometime takes over 2 minutes...
Date: Thu, 22 Mar 2012 14:37:49 GMT
Message-ID: <201203221437.q2MEbnRU019169@bugzilla.kernel.org>
References: <bug-42872-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from bugzilla.kernel.org ([198.145.19.204]:54890 "EHLO
	bugzilla.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752719Ab2CVOhu (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 22 Mar 2012 10:37:50 -0400
Received: from bugzilla.kernel.org (localhost [127.0.0.1])
	by bugzilla.kernel.org (8.14.5/8.14.5) with ESMTP id q2MEbn4D019170
	for <linux-ext4@vger.kernel.org>; Thu, 22 Mar 2012 14:37:49 GMT
In-Reply-To: <bug-42872-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=42872





--- Comment #3 from Jan Kara <jack@suse.cz>  2012-03-22 14:37:48 ---
I did some testing of read latencies under heavy write load. Switching to
data=writeback helped a lot (not that data=ordered shouldn't be fixed but it's
not so simple). So can you try whether it helps also your case?

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
