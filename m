From: bugme-daemon@bugzilla.kernel.org
Subject: [Bug 12603] firefox downloads hang on ext4; fine on ext3
Date: Sun,  1 Feb 2009 18:52:25 -0800 (PST)
Message-ID: <20090202025225.C2CEF108041@picon.linux-foundation.org>
References: <bug-12603-13602@http.bugzilla.kernel.org/>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48151 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752264AbZBBCw5 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 1 Feb 2009 21:52:57 -0500
Received: from picon.linux-foundation.org (picon.linux-foundation.org [140.211.169.79])
	by smtp1.linux-foundation.org (8.14.2/8.13.5/Debian-3ubuntu1.1) with ESMTP id n122qQdf013448
	for <linux-ext4@vger.kernel.org>; Sun, 1 Feb 2009 18:52:27 -0800
In-Reply-To: <bug-12603-13602@http.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

http://bugzilla.kernel.org/show_bug.cgi?id=12603





------- Comment #5 from avery@shadypixel.com  2009-02-01 18:52 -------
So, I don't think it actually needs to be a very large file, just large enough
so that I can close the main firefox window before it completely downloads.
I've actually been downloading firefox itself as a testcase because it take a
few seconds to finish.

ps output attached

sysrq-l didn't have anything just:

"[1893205.442069] SysRq : Show backtrace of all active CPUs"

I should point out that firefox isn't "hung" in the traditional sense. It's not
using 100% cpu. I can cancel the download and exit just fine. But the download
itself it hung and will never finish. The only reason I'm reporting this to
ext4 instead of firefox is that it's 100% reproducible w/ext4 and works 100% of
the time w/ext3.


-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug, or are watching the assignee.
