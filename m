From: bugme-daemon@bugzilla.kernel.org
Subject: [Bug 12224] journal activity on inactive partition causes inactive harddrive spinup
Date: Sun, 14 Dec 2008 21:07:16 -0800 (PST)
Message-ID: <20081215050716.E7756108042@picon.linux-foundation.org>
References: <bug-12224-13602@http.bugzilla.kernel.org/>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57522 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750706AbYLOFHT (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Mon, 15 Dec 2008 00:07:19 -0500
Received: from picon.linux-foundation.org (picon.linux-foundation.org [140.211.169.79])
	by smtp1.linux-foundation.org (8.14.2/8.13.5/Debian-3ubuntu1.1) with ESMTP id mBF57HbI003067
	for <linux-ext4@vger.kernel.org>; Sun, 14 Dec 2008 21:07:18 -0800
In-Reply-To: <bug-12224-13602@http.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

http://bugzilla.kernel.org/show_bug.cgi?id=12224





------- Comment #6 from sandeen@redhat.com  2008-12-14 21:07 -------
Dec 14 20:02:18 localhost kernel: kjournald(1109): WRITE block 12520 on sda1

is the first thing I see in the log above, with no indication of anything else
on sda1 before that.

If you let the system just sit idle, do you get sda1 hits from the sysctl
and/or blktrace?


-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug, or are watching the assignee.
