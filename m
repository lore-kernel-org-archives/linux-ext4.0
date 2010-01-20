From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 14256] kernel BUG at fs/ext3/super.c:435
Date: Wed, 20 Jan 2010 19:54:38 GMT
Message-ID: <201001201954.o0KJscie028685@demeter.kernel.org>
References: <bug-14256-13602@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:57172 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751924Ab0ATTyj (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 20 Jan 2010 14:54:39 -0500
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.3/8.14.2) with ESMTP id o0KJscGx028686
	for <linux-ext4@vger.kernel.org>; Wed, 20 Jan 2010 19:54:38 GMT
In-Reply-To: <bug-14256-13602@http.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

http://bugzilla.kernel.org/show_bug.cgi?id=14256





--- Comment #34 from Mikael Pettersson <mikpe@it.uu.se>  2010-01-20 19:54:37 ---
My bisection has identified the following as the culprit:

commit 38d47c1b7075bd7ec3881141bb3629da58f88dab
Author: Peter Zijlstra <a.p.zijlstra@chello.nl>
Date:   Fri Sep 26 19:32:20 2008 +0200

    futex: rely on get_user_pages() for shared futexes

    On the way of getting rid of the mmap_sem requirement for shared futexes,
    start by relying on get_user_pages().

-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
