From: bugme-daemon@bugzilla.kernel.org
Subject: [Bug 12424] ext4_da_writepages error while downloading a file w/firefox
Date: Sat, 10 Jan 2009 20:08:24 -0800 (PST)
Message-ID: <20090111040824.1DD3B10800F@picon.linux-foundation.org>
References: <bug-12424-13602@http.bugzilla.kernel.org/>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36698 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751311AbZAKEI0 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Sat, 10 Jan 2009 23:08:26 -0500
Received: from picon.linux-foundation.org (picon.linux-foundation.org [140.211.169.79])
	by smtp1.linux-foundation.org (8.14.2/8.13.5/Debian-3ubuntu1.1) with ESMTP id n0B48OAi000502
	for <linux-ext4@vger.kernel.org>; Sat, 10 Jan 2009 20:08:25 -0800
In-Reply-To: <bug-12424-13602@http.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

http://bugzilla.kernel.org/show_bug.cgi?id=12424





------- Comment #3 from avery@shadypixel.com  2009-01-10 20:08 -------
Yes, the filesystem went read only. Unfortunately, I wasn't in the room when it
happened and by the time I came in, dmesg was just filled with this backtrace.
If it helps, I snapped pictures of the fsck on reboot too. I'll attach those.


-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug, or are watching the assignee.
