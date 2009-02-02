From: bugme-daemon@bugzilla.kernel.org
Subject: [Bug 12603] firefox downloads hang on ext4; fine on ext3
Date: Sun,  1 Feb 2009 20:42:24 -0800 (PST)
Message-ID: <20090202044225.40B44108041@picon.linux-foundation.org>
References: <bug-12603-13602@http.bugzilla.kernel.org/>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56845 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752218AbZBBEm4 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 1 Feb 2009 23:42:56 -0500
Received: from picon.linux-foundation.org (picon.linux-foundation.org [140.211.169.79])
	by smtp1.linux-foundation.org (8.14.2/8.13.5/Debian-3ubuntu1.1) with ESMTP id n124gP9o017570
	for <linux-ext4@vger.kernel.org>; Sun, 1 Feb 2009 20:42:26 -0800
In-Reply-To: <bug-12603-13602@http.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

http://bugzilla.kernel.org/show_bug.cgi?id=12603





------- Comment #12 from avery@shadypixel.com  2009-02-01 20:42 -------
I ended up getting strace from cvs which fixes my bug. 2 strace's attached.

bad: starts right before i click the download link and ends at most a second or
2 after it's hung.
good: starts right before i click the download link and ends a few seconds
after download completes.


-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug, or are watching the assignee.
