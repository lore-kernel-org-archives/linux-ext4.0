From: bugme-daemon@bugzilla.kernel.org
Subject: [Bug 11688] Oops while writing on a newly ext4 formated 1TB partition on a external USB drive
Date: Sun, 18 Jan 2009 16:56:49 -0800 (PST)
Message-ID: <20090119005649.F333310800F@picon.linux-foundation.org>
References: <bug-11688-13602@http.bugzilla.kernel.org/>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:32959 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755439AbZASA5U (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Sun, 18 Jan 2009 19:57:20 -0500
Received: from picon.linux-foundation.org (picon.linux-foundation.org [140.211.169.79])
	by smtp1.linux-foundation.org (8.14.2/8.13.5/Debian-3ubuntu1.1) with ESMTP id n0J0uoDN015947
	for <linux-ext4@vger.kernel.org>; Sun, 18 Jan 2009 16:56:51 -0800
In-Reply-To: <bug-11688-13602@http.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

http://bugzilla.kernel.org/show_bug.cgi?id=11688





------- Comment #5 from tytso@mit.edu  2009-01-18 16:56 -------
Ext4's delayed allocation will cause more memory pressure, because blocks
aren't as aggressively pushed out to disk.   How much memory do you have in
your system, how many ext3/ext4 filesystems do you have mounted, how many of
them are active (and how active) versus totally quiescent, and how big is the
journal for those filesystems?


-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug, or are watching the assignee.
