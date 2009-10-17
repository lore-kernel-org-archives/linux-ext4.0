From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 14354] Bad corruption with 2.6.32-rc1 and upwards
Date: Sat, 17 Oct 2009 19:57:01 GMT
Message-ID: <200910171957.n9HJv1IB005589@demeter.kernel.org>
References: <bug-14354-13602@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:59117 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751726AbZJQT45 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 17 Oct 2009 15:56:57 -0400
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.2/8.14.2) with ESMTP id n9HJv1mt005591
	for <linux-ext4@vger.kernel.org>; Sat, 17 Oct 2009 19:57:01 GMT
In-Reply-To: <bug-14354-13602@http.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

http://bugzilla.kernel.org/show_bug.cgi?id=14354





--- Comment #84 from Theodore Tso <tytso@mit.edu>  2009-10-17 19:57:00 ---
Alexey, how did you check it?   What happens when you use build commit
91ac6f43?   Does the output of fsck show file system corruption after running
your script?   And what happens if you build commit fe188c0e (aka commit
91ac6f43^ aka the parent or immediate predecessor of commit 91ac6f43)?   Does
the problem reliably go away, which is to say fsck no longer reports file
system corruption after you use the immediate predecessor of commit 91ac6f32,
but which is there when you use commit 91ac6f32?

This commit is supposed to not change anything if you use it with a journal
(which is the ext4 default).   I've reviewed the patch again, and it looks like
it should be changing anything for a default ext4 filesystem with a journal
present --- which is why I'm asking you exactly how you confirmed that this
commit is the problem one.   Maybe I'm missing something, but I don't see how
the presence or absence of this patch could be changing anything.

Thanks for all of your work, even if it's causing me to be even more mystified
about what is going on.

-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
