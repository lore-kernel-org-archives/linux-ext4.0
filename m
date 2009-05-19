From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 13201] kernel BUG at fs/ext4/extents.c:2737
Date: Tue, 19 May 2009 18:04:07 GMT
Message-ID: <200905191804.n4JI47eA015247@demeter.kernel.org>
References: <bug-13201-13602@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:38089 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750820AbZESSEG (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 19 May 2009 14:04:06 -0400
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.2/8.14.2) with ESMTP id n4JI47fg015248
	for <linux-ext4@vger.kernel.org>; Tue, 19 May 2009 18:04:07 GMT
In-Reply-To: <bug-13201-13602@http.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

http://bugzilla.kernel.org/show_bug.cgi?id=13201


Theodore Tso <tytso@mit.edu> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |tytso@mit.edu




--- Comment #6 from Theodore Tso <tytso@mit.edu>  2009-05-19 18:04:05 ---
Could you try replicating this problem in 2.6.30-rc6?   We fixed a race
condition in i_cached_extents could have very well caused your problem.   I'm
hoping it will close this a few other mystery bug reports we've had over the
past couple of months.  (The bug is an old one, but we had struggled with a
reliable reproduction case.)

-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
