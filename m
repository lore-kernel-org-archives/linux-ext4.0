From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 25352] resizing ext4 will corrupt filesystem
Date: Thu, 31 Mar 2011 16:26:29 GMT
Message-ID: <201103311626.p2VGQTda031501@demeter1.kernel.org>
References: <bug-25352-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter1.kernel.org ([140.211.167.39]:39187 "EHLO
	demeter1.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756772Ab1CaQ0a (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 31 Mar 2011 12:26:30 -0400
Received: from demeter1.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter1.kernel.org (8.14.4/8.14.3) with ESMTP id p2VGQTsk031502
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Thu, 31 Mar 2011 16:26:29 GMT
In-Reply-To: <bug-25352-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=25352


Theodore Tso <tytso@mit.edu> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
             Status|NEEDINFO                    |RESOLVED
         Resolution|                            |CODE_FIX




--- Comment #15 from Theodore Tso <tytso@mit.edu>  2011-03-31 16:26:28 ---
Martin Steigerwald's problem should be filed as a separate bug if he can
reproduce it.  It would also be nice if he gave us e2fsck transcripts in
*english*, and was very clear which e2fsck output came from which machine, and
exactly what was done on each machine that might have been related to problems
showing up.

If someone wants to translate this to english, and separate out his different
complaints into separate bug reports, that would be great.  But I don't think
the ext4 developers have time to try to decrypt his bug reports....

I'm going to close the original problem as fixed since the original problem was
fixed.

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
