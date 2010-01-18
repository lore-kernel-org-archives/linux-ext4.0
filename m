From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 14256] kernel BUG at fs/ext3/super.c:435
Date: Mon, 18 Jan 2010 22:41:50 GMT
Message-ID: <201001182241.o0IMfoal002031@demeter.kernel.org>
References: <bug-14256-13602@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:33835 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753008Ab0ARWlv (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 18 Jan 2010 17:41:51 -0500
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.3/8.14.2) with ESMTP id o0IMfoYQ002032
	for <linux-ext4@vger.kernel.org>; Mon, 18 Jan 2010 22:41:50 GMT
In-Reply-To: <bug-14256-13602@http.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

http://bugzilla.kernel.org/show_bug.cgi?id=14256





--- Comment #25 from Jan Kara <jack@suse.cz>  2010-01-18 22:41:46 ---
Whohoo, reproduced! The trick was that this test is creating files in /tmp and
I was doing all the compilation (and unmounting) in a different partition than
/tmp is. Thanks for identifying the test case.

For others interested: What the test does is: It creates a temporary file,
mmaps it, deletes it, creates pthread mutex in the mmap, forks, does some mutex
locking, exits. During this process we apparently leak an inode reference, yay.
What is interesting is that when the mutex is created without priority
inheritance logic, everything works fine so there's something racy about our
pthread mutex handling in the kernel.

I'll now go and debug it more, I just wanted to share the news.

-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
