From: bugme-daemon@bugzilla.kernel.org
Subject: [Bug 12478] Infinite loop printing "__find_get_block_slow() failed." on accessing intentionally corrupted ext4 fs
Date: Sun, 18 Jan 2009 09:10:25 -0800 (PST)
Message-ID: <20090118171026.10B8D10800F@picon.linux-foundation.org>
References: <bug-12478-13602@http.bugzilla.kernel.org/>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36310 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759705AbZARRKz (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Sun, 18 Jan 2009 12:10:55 -0500
Received: from picon.linux-foundation.org (picon.linux-foundation.org [140.211.169.79])
	by smtp1.linux-foundation.org (8.14.2/8.13.5/Debian-3ubuntu1.1) with ESMTP id n0IHAQ4F015571
	for <linux-ext4@vger.kernel.org>; Sun, 18 Jan 2009 09:10:27 -0800
In-Reply-To: <bug-12478-13602@http.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

http://bugzilla.kernel.org/show_bug.cgi?id=12478





------- Comment #1 from sliedes@cc.hut.fi  2009-01-18 09:10 -------
Created an attachment (id=19880)
 --> (http://bugzilla.kernel.org/attachment.cgi?id=19880&action=view)
Test case, corrupted ext4 filesystem hdb.153, bzip2 compressed.


-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug, or are watching the assignee.
