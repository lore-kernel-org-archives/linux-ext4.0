From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 20902] High IO wait when writing to ext4
Date: Thu, 25 Nov 2010 15:30:46 GMT
Message-ID: <201011251530.oAPFUkxi019525@demeter1.kernel.org>
References: <bug-20902-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter1.kernel.org ([140.211.167.39]:36810 "EHLO
	demeter1.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752187Ab0KYPar (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 25 Nov 2010 10:30:47 -0500
Received: from demeter1.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter1.kernel.org (8.14.4/8.14.3) with ESMTP id oAPFUkDN019526
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Thu, 25 Nov 2010 15:30:46 GMT
In-Reply-To: <bug-20902-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=20902





--- Comment #20 from Theodore Tso <tytso@mit.edu>  2010-11-25 15:30:45 ---
Curtw's patch (at commit id: 8a57d9d61) also fixes the problem in the steady
state, once all of the block bitmap's statistics are loaded into memory.   So
one thing we could do is to simply force the block bitmap scan at mount time. 
It doesn't so much solve the problem as it moves it to a time when it might be
less objectionable.  For 8TB file systems if it really does take 10 minutes
then we would have to mitigate this by (a) having mke2fs use a larger flex_bg
size automatically, and/or (b) loading up the block bitmap statistics in
parallel (which will help on RAID systems, but not when we have 8TB on a single
spindle; given that 3 and 4 TB disks are within the horizon in the next couple
of years, 8TB/spindle aren't that far out of reach).

Storing the largest contiguous free extent in a block group in the block group
might be another way of solving this problem.  The reason why I don't like this
approach, though, is that it forces the implementation details of the buddy
bitmap implementation into the file system format.  It's possible that we might
have N blocks free, where N might be say (for the sake of argument) 256 blocks.
 But if those N blocks aren't aligned on a buddy bitmap allocation boundary,
mballoc won't find that free extent.  It might see it as a free regions that
are 31 blocks, 32 blocks, 128 blocks, 64 blocks, and 1 block free.

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
