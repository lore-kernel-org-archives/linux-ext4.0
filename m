From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 26642] Automatically clean dirty bit on
 ext2/ext4-without-journal file systems
Date: Thu, 13 Jan 2011 18:42:21 GMT
Message-ID: <201101131842.p0DIgLDG014753@demeter2.kernel.org>
References: <bug-26642-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter2.kernel.org ([140.211.167.42]:60023 "EHLO
	demeter2.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751158Ab1AMSmW (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 13 Jan 2011 13:42:22 -0500
Received: from demeter2.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter2.kernel.org (8.14.4/8.14.3) with ESMTP id p0DIgLX1014754
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Thu, 13 Jan 2011 18:42:21 GMT
In-Reply-To: <bug-26642-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=26642


Theodore Tso <tytso@mit.edu> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
           Priority|P1                          |P3
                 CC|                            |tytso@mit.edu




--- Comment #1 from Theodore Tso <tytso@mit.edu>  2011-01-13 18:42:20 ---
This is an old proposal; the challenge which this is that if you do this, we
then have to block any attempts to write to the file system until the dirty bit
has been set in the superblock.   It can be done, but it's not been a high
priority to any of the ext3/ext4 developers.  Patches to do this will be
accepted.  If someone wants more details about how to best do this and is
willing to do the implementation and testing, please let me know.

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
