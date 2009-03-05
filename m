From: bugme-daemon@bugzilla.kernel.org
Subject: [Bug 12821] filesystem corrupts on heavy I/O
Date: Thu,  5 Mar 2009 09:26:17 -0800 (PST)
Message-ID: <20090305172617.17244108040@picon.linux-foundation.org>
References: <bug-12821-13602@http.bugzilla.kernel.org/>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59191 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754231AbZCER0t (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 5 Mar 2009 12:26:49 -0500
Received: from picon.linux-foundation.org (picon.linux-foundation.org [140.211.169.79])
	by smtp1.linux-foundation.org (8.14.2/8.13.5/Debian-3ubuntu1.1) with ESMTP id n25HQHdg008290
	for <linux-ext4@vger.kernel.org>; Thu, 5 Mar 2009 09:26:18 -0800
In-Reply-To: <bug-12821-13602@http.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

http://bugzilla.kernel.org/show_bug.cgi?id=12821





------- Comment #1 from sandeen@redhat.com  2009-03-05 09:26 -------
Is this something you can reproduce?  I'm not remembering anything related
offhand other than an early bug in the extent code, which I think should be
fixed well before 2.6.27.

If you find inode #2621457, I expect that it is very fragmented, and I'd guess
that any access to it (reading it, that is, or perhaps extending it) will trip
this error.

If you can try a later kernel, maybe 2.6.27.x or 28.x or even .29 it'd let us
know if the problem still exists; if not maybe there is more debugging we can
do.

Providing an e2image -r of the filesystem would also let us see what kind of
layout that file has, though from your comments I'm guessing this may not be
possible due to security reasons.


-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug, or are watching the assignee.
