From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 44731] ext4 deadlock under heavy io?
Date: Wed, 29 Aug 2012 16:12:41 +0000 (UTC)
Message-ID: <20120829161241.3628711FB38@bugzilla.kernel.org>
References: <bug-44731-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:54674 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753895Ab2H2QMr (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 29 Aug 2012 12:12:47 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 218AC20290
	for <linux-ext4@vger.kernel.org>; Wed, 29 Aug 2012 16:12:42 +0000 (UTC)
Received: from bugzilla.kernel.org (unknown [198.145.19.217])
	by mail.kernel.org (Postfix) with ESMTP id 3A1912027B
	for <linux-ext4@vger.kernel.org>; Wed, 29 Aug 2012 16:12:41 +0000 (UTC)
In-Reply-To: <bug-44731-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=44731


Nick Semenkovich <semenko@alum.mit.edu> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |semenko@alum.mit.edu




--- Comment #7 from Nick Semenkovich <semenko@alum.mit.edu>  2012-08-29 16:12:40 ---
@Mirek: Commit fab363b5ff502d1b39ddcfec04271f5858d9f26e seems to impact RAID6
(and RAID4) as well.

See:
http://comments.gmane.org/gmane.linux.raid/39236

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
