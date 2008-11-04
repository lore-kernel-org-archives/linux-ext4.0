From: bugme-daemon@bugzilla.kernel.org
Subject: [Bug 11950] Early boot failure for 2.6.28-rc[123]: NULL pointer deref stemming from scheduler_tick
Date: Tue,  4 Nov 2008 15:38:18 -0800 (PST)
Message-ID: <20081104233818.716A7108057@picon.linux-foundation.org>
References: <bug-11950-13602@http.bugzilla.kernel.org/>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48170 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757258AbYKDXiU (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 4 Nov 2008 18:38:20 -0500
Received: from picon.linux-foundation.org (picon.linux-foundation.org [140.211.169.79])
	by smtp1.linux-foundation.org (8.14.2/8.13.5/Debian-3ubuntu1.1) with ESMTP id mA4NcIv4030622
	for <linux-ext4@vger.kernel.org>; Tue, 4 Nov 2008 15:38:19 -0800
In-Reply-To: <bug-11950-13602@http.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

http://bugzilla.kernel.org/show_bug.cgi?id=11950


rjw@sisk.pl changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
             Status|REJECTED                    |CLOSED




-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You reported the bug, or are watching the reporter.
