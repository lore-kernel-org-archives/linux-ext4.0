From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 13201] kernel BUG at fs/ext4/extents.c:2737
Date: Mon, 8 Jun 2009 16:49:29 GMT
Message-ID: <200906081649.n58GnTsB008161@demeter.kernel.org>
References: <bug-13201-13602@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:44620 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752973AbZFHQt0 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 8 Jun 2009 12:49:26 -0400
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.2/8.14.2) with ESMTP id n58GnT6E008162
	for <linux-ext4@vger.kernel.org>; Mon, 8 Jun 2009 16:49:29 GMT
In-Reply-To: <bug-13201-13602@http.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

http://bugzilla.kernel.org/show_bug.cgi?id=13201





--- Comment #9 from Theodore Tso <tytso@mit.edu>  2009-06-08 16:49:28 ---
If this is the same problem as the one which we fixed with identical symptoms,
what matters is multiple processes/threads writing to the same file at the same
time.  People using NFS or SAMBA on a backup server seemed to be a most common
scenarios for triggering this (admittedly very hard to reproduce) bug.   We
finally got lucky in that someone had a setup which allows for reliable
reproduction of the bug, so we could finally sink our teeth into it.

So if what you saw was the same as the bug we fixed in 2.6.30-rc6, no it
shouldn't make a difference.   If it is a completely different bug, then of
course all bets are off.  In general though whether you are writing to one
filesystem or 4 filesystems shouldn't make a difference, except in that it
might change the timing necessary to hit a race condition (and in the case of
the bug that we found and fixed, it was highly timing dependent; in fact, even
after we found the problem, we weren't able to come up with a reliable
reproduction case, even though the problem was obvious on paper and the one
user who could reliably reproduce reported it went away once the patch was
applied; IIRC, Eric finally put in a delay into the code to widen the race
window to the point where he could replicate it.)

-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
