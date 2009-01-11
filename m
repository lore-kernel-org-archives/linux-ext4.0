From: bugme-daemon@bugzilla.kernel.org
Subject: [Bug 11493] "proc_dir_entry 'hdb' already registered" on repeatedly mounting/umounting intentionally corrupted fs
Date: Sun, 11 Jan 2009 09:43:45 -0800 (PST)
Message-ID: <20090111174345.384C210800F@picon.linux-foundation.org>
References: <bug-11493-13602@http.bugzilla.kernel.org/>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53557 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751695AbZAKRoR (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Sun, 11 Jan 2009 12:44:17 -0500
Received: from picon.linux-foundation.org (picon.linux-foundation.org [140.211.169.79])
	by smtp1.linux-foundation.org (8.14.2/8.13.5/Debian-3ubuntu1.1) with ESMTP id n0BHhjQn008093
	for <linux-ext4@vger.kernel.org>; Sun, 11 Jan 2009 09:43:46 -0800
In-Reply-To: <bug-11493-13602@http.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

http://bugzilla.kernel.org/show_bug.cgi?id=11493


sliedes@cc.hut.fi changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
             Status|NEW                         |RESOLVED
         Resolution|                            |CODE_FIX




------- Comment #2 from sliedes@cc.hut.fi  2009-01-11 09:43 -------
Fixed in 2.6.28.


-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug, or are watching the assignee.
