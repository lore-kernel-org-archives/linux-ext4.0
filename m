From: bugme-daemon@bugzilla.kernel.org
Subject: [Bug 12224] journal activity on inactive partition causes inactive harddrive spinup
Date: Tue, 16 Dec 2008 14:01:28 -0800 (PST)
Message-ID: <20081216220129.0ACE811D107@picon.linux-foundation.org>
References: <bug-12224-13602@http.bugzilla.kernel.org/>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51510 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750967AbYLPWBb (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Tue, 16 Dec 2008 17:01:31 -0500
Received: from picon.linux-foundation.org (picon.linux-foundation.org [140.211.169.79])
	by smtp1.linux-foundation.org (8.14.2/8.13.5/Debian-3ubuntu1.1) with ESMTP id mBGM1TGN028817
	for <linux-ext4@vger.kernel.org>; Tue, 16 Dec 2008 14:01:30 -0800
In-Reply-To: <bug-12224-13602@http.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

http://bugzilla.kernel.org/show_bug.cgi?id=12224





------- Comment #9 from sandeen@redhat.com  2008-12-16 14:01 -------
Are the laptop-mode tools doing remounts behind your back?

The only way I see this is if I do "mount -o remount /"; then I see kjournald
activity on other ext3 filesystems.  I'll dig into that.


-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug, or are watching the assignee.
