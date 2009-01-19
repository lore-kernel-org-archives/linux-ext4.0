From: bugme-daemon@bugzilla.kernel.org
Subject: [Bug 11688] Oops while writing on a newly ext4 formated 1TB partition on a external USB drive
Date: Mon, 19 Jan 2009 00:50:56 -0800 (PST)
Message-ID: <20090119085056.78F1F10800C@picon.linux-foundation.org>
References: <bug-11688-13602@http.bugzilla.kernel.org/>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45486 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752630AbZASIu6 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Mon, 19 Jan 2009 03:50:58 -0500
Received: from picon.linux-foundation.org (picon.linux-foundation.org [140.211.169.79])
	by smtp1.linux-foundation.org (8.14.2/8.13.5/Debian-3ubuntu1.1) with ESMTP id n0J8ou3f013816
	for <linux-ext4@vger.kernel.org>; Mon, 19 Jan 2009 00:50:57 -0800
In-Reply-To: <bug-11688-13602@http.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

http://bugzilla.kernel.org/show_bug.cgi?id=11688





------- Comment #8 from vedranf@vedranf.mine.nu  2009-01-19 00:50 -------
Errr, that was output of $ free -m, so it's ~1.7GB of memory.
Regarding noatime... I didn't change debian defaults. 
Disabling quotas (/etc/init.d/quota stop) seems to fix the problem. I copied
some 70GB and oops didn't happen.

I need to test it more,  but I'm 90% sure it's quota related bug. You can
assign this bug to someone who is in charge of ext3 and quota.


-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug, or are watching the assignee.
