From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 14256] kernel BUG at fs/ext3/super.c:435
Date: Wed, 20 Jan 2010 20:09:09 GMT
Message-ID: <201001202009.o0KK99IH031140@demeter.kernel.org>
References: <bug-14256-13602@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:44522 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754286Ab0ATUJJ (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 20 Jan 2010 15:09:09 -0500
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.3/8.14.2) with ESMTP id o0KK99JY031141
	for <linux-ext4@vger.kernel.org>; Wed, 20 Jan 2010 20:09:09 GMT
In-Reply-To: <bug-14256-13602@http.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

http://bugzilla.kernel.org/show_bug.cgi?id=14256





--- Comment #35 from Darren Hart <dvhltc@us.ibm.com>  2010-01-20 20:09:08 ---
The fault path inode count problem appears to be fixed in 2.6.33-rc3 where the
fault logic is rewritten and and we properly account for both references taken
by queue_lock as well as get_futex_key(). Since Jan in comment #26 said he can
reproduce on 2.6.33-rc3, this isn't likely to be the path that caused the
problem. I'll continue to look.

-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
