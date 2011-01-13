From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 26642] Automatically clean dirty bit on
 ext2/ext4-without-journal file systems
Date: Thu, 13 Jan 2011 23:47:03 GMT
Message-ID: <201101132347.p0DNl3sW025661@demeter1.kernel.org>
References: <bug-26642-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter1.kernel.org ([140.211.167.39]:40515 "EHLO
	demeter1.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752187Ab1AMXrF (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 13 Jan 2011 18:47:05 -0500
Received: from demeter1.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter1.kernel.org (8.14.4/8.14.3) with ESMTP id p0DNl3JP025662
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Thu, 13 Jan 2011 23:47:03 GMT
In-Reply-To: <bug-26642-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=26642


Andreas Dilger <adilger.kernelbugzilla@dilger.ca> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |adilger.kernelbugzilla@dilg
                   |                            |er.ca




--- Comment #2 from Andreas Dilger <adilger.kernelbugzilla@dilger.ca>  2011-01-13 23:46:56 ---
I would also suggest looking at the per-group dirty bit that Val Henson
developed, maybe 1.5 years ago.  This allowed e2fsck to limit its boot-time
scanning to only the small subset of groups/inodes that were modified shortly
before the crash.

I don't know how close to production-ready that code was, but it was at least
at the working prototype stage.  Some changes and updates are probably needed
(e.g. changing the per-group flag value to avoid conflicting with other
assigned flags) before using it on a newer kernel with ext4.

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
