From: bugme-daemon@bugzilla.kernel.org
Subject: [Bug 12603] firefox downloads hang on ext4; fine on ext3
Date: Sun,  1 Feb 2009 18:57:14 -0800 (PST)
Message-ID: <20090202025714.63440108041@picon.linux-foundation.org>
References: <bug-12603-13602@http.bugzilla.kernel.org/>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45033 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753446AbZBBC5p (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 1 Feb 2009 21:57:45 -0500
Received: from picon.linux-foundation.org (picon.linux-foundation.org [140.211.169.79])
	by smtp1.linux-foundation.org (8.14.2/8.13.5/Debian-3ubuntu1.1) with ESMTP id n122vEV4013650
	for <linux-ext4@vger.kernel.org>; Sun, 1 Feb 2009 18:57:15 -0800
In-Reply-To: <bug-12603-13602@http.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

http://bugzilla.kernel.org/show_bug.cgi?id=12603





------- Comment #7 from avery@shadypixel.com  2009-02-01 18:57 -------
One more thing:

After I have a download in the "hung" state, if I close the download window,
start firefox again, and then open the download window, I get the following
message from firefox:

---
/home/avery/downloads/firefox-3.0.5.tar.bz2.part could not be saved, because
the source file could not be read.

Try again later, or contact the server administrator.
---

avery@polar:~/downloads$ ls -l firefox-3.0.5.tar.bz2*
-rw------- 1 avery avery       0 2009-02-01 21:39 firefox-3.0.5.tar.bz2
-rw------- 1 avery avery 9112341 2009-02-01 21:54 firefox-3.0.5.tar.bz2.part


-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug, or are watching the assignee.
