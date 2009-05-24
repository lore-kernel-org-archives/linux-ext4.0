From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 13369] kernel BUG at fs/ext4/inode.c:3123
Date: Sun, 24 May 2009 16:32:19 GMT
Message-ID: <200905241632.n4OGWJ2R016446@demeter.kernel.org>
References: <bug-13369-13602@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:46754 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752485AbZEXQcT (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 24 May 2009 12:32:19 -0400
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.2/8.14.2) with ESMTP id n4OGWJ38016447
	for <linux-ext4@vger.kernel.org>; Sun, 24 May 2009 16:32:19 GMT
In-Reply-To: <bug-13369-13602@http.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

http://bugzilla.kernel.org/show_bug.cgi?id=13369





--- Comment #9 from Eric Sandeen <sandeen@redhat.com>  2009-05-24 16:32:18 ---
So the modification w/ the printk didn't print anything?  Must not have been
the first bh on the page that was wrong, then, I didn't anticipate 1k blocks,
I'll come up with another patch later that will print the state for all bh's on
the page.

-Eric

-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
