From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 14256] kernel BUG at fs/ext3/super.c:435
Date: Wed, 20 Jan 2010 18:11:17 GMT
Message-ID: <201001201811.o0KIBHBk013799@demeter.kernel.org>
References: <bug-14256-13602@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:40840 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753914Ab0ATSLT (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 20 Jan 2010 13:11:19 -0500
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.3/8.14.2) with ESMTP id o0KIBHmh013800
	for <linux-ext4@vger.kernel.org>; Wed, 20 Jan 2010 18:11:17 GMT
In-Reply-To: <bug-14256-13602@http.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

http://bugzilla.kernel.org/show_bug.cgi?id=14256





--- Comment #31 from Darren Hart <dvhltc@us.ibm.com>  2010-01-20 18:11:16 ---
Jan, I apologize, I missed the shared mapping. I wouldn't expect Kosaki's patch
to fix this. Have you experimented with the SHARED, RECURSIVE, and PRIO_INHERIT
flags of the mutexattr to see if this is the only configuration in which you
see the problem? Understanding which of these flags are required to reproduce
would help point at where to look in the code. Right now I suspect a futex key
reference imbalance in the futex_lock_pi() code path. 2.6.29 includes changes
from me on fault handling as well as key reference imbalance fixes in this
area.

Mikael, please let me know what your git bisection reveals.

I'm trying to make time to do some testing/analysis myself, but I'm being kept
very busy on other pressing issues right now, so I may not be able to respond
as quickly as I'd like.

-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
