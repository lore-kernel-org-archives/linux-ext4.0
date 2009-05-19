From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 12787] possible circular locking dependency
Date: Tue, 19 May 2009 19:13:18 GMT
Message-ID: <200905191913.n4JJDId8020290@demeter.kernel.org>
References: <bug-12787-13602@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:54507 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752558AbZESTNQ (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 19 May 2009 15:13:16 -0400
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.2/8.14.2) with ESMTP id n4JJDIVw020291
	for <linux-ext4@vger.kernel.org>; Tue, 19 May 2009 19:13:18 GMT
In-Reply-To: <bug-12787-13602@http.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

http://bugzilla.kernel.org/show_bug.cgi?id=12787


Theodore Tso <tytso@mit.edu> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
             Status|NEW                         |RESOLVED
         Resolution|                            |PATCH_ALREADY_AVAILABLE




--- Comment #8 from Theodore Tso <tytso@mit.edu>  2009-05-19 19:13:17 ---
Unfortunately the 2.6.28 kernel series closed before I was able to find time to
get this into the stable kernel series.  The patch is in 2.6.29, so all I can
suggest folks to do is to upgrade to 2.6.29 or 2.6.30, which will be out very
shortly.

-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
