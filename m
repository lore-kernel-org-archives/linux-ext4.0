From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 14936] kernel BUG at fs/ext4/inode.c:1063 if attempted to use
 non-ext4 partition with ext4
Date: Wed, 30 Dec 2009 21:49:46 GMT
Message-ID: <200912302149.nBULnkH3019762@demeter.kernel.org>
References: <bug-14936-13602@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:57825 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751734AbZL3Vtr (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 30 Dec 2009 16:49:47 -0500
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.3/8.14.2) with ESMTP id nBULnkU7019763
	for <linux-ext4@vger.kernel.org>; Wed, 30 Dec 2009 21:49:46 GMT
In-Reply-To: <bug-14936-13602@http.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

http://bugzilla.kernel.org/show_bug.cgi?id=14936


Rafael J. Wysocki <rjw@sisk.pl> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
             Status|NEW                         |RESOLVED
         Resolution|                            |PATCH_ALREADY_AVAILABLE




--- Comment #5 from Rafael J. Wysocki <rjw@sisk.pl>  2009-12-30 21:49:44 ---
Handled-By : Theodore Ts'o <tytso@mit.edu>
Patch : http://patchwork.kernel.org/patch/70282/

-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
