From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 14256] kernel BUG at fs/ext3/super.c:435
Date: Wed, 20 Jan 2010 19:29:54 GMT
Message-ID: <201001201929.o0KJTs4S024990@demeter.kernel.org>
References: <bug-14256-13602@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:57834 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752989Ab0ATT3y (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 20 Jan 2010 14:29:54 -0500
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.3/8.14.2) with ESMTP id o0KJTs7r024991
	for <linux-ext4@vger.kernel.org>; Wed, 20 Jan 2010 19:29:54 GMT
In-Reply-To: <bug-14256-13602@http.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

http://bugzilla.kernel.org/show_bug.cgi?id=14256





--- Comment #33 from Darren Hart <dvhltc@us.ibm.com>  2010-01-20 19:29:53 ---
Took a look at the 2.6.29 code, I believe it is possible to have an inode
reference imbalance when a fault is taken. Unfortunately, both queue_lock() and
get_futex_key() acquire references to the inode (I'd like to do away with
queue_lock() as it masks reference usage and generally complicates the
corner-case-heavy futex code). In the fault path queue_unlock() will release
the first inode reference, but if on the first attempt (attempt == 0) the
get_user() fails, we'll simply return without dropping the second reference.
Some instrumentation could confirm this. I'll take a look at later sources
which should have a significantly different fault path.

-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
