From: bugme-daemon@bugzilla.kernel.org
Subject: [Bug 12429] "BUG: spinlock cpu recursion on CPU#0, rm/699" on intentionally corrupted ext4 fs
Date: Sun, 18 Jan 2009 09:07:31 -0800 (PST)
Message-ID: <20090118170731.A832B10800F@picon.linux-foundation.org>
References: <bug-12429-13602@http.bugzilla.kernel.org/>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41006 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759455AbZARRIB (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Sun, 18 Jan 2009 12:08:01 -0500
Received: from picon.linux-foundation.org (picon.linux-foundation.org [140.211.169.79])
	by smtp1.linux-foundation.org (8.14.2/8.13.5/Debian-3ubuntu1.1) with ESMTP id n0IH7VBJ015331
	for <linux-ext4@vger.kernel.org>; Sun, 18 Jan 2009 09:07:32 -0800
In-Reply-To: <bug-12429-13602@http.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

http://bugzilla.kernel.org/show_bug.cgi?id=12429


sliedes@cc.hut.fi changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
             Status|NEW                         |RESOLVED
         Resolution|                            |PATCH_ALREADY_AVAILABLE




------- Comment #3 from sliedes@cc.hut.fi  2009-01-18 09:07 -------
Yup, cannot reproduce with 2.6.29-rc2 either.


-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug, or are watching the assignee.
