From: bugme-daemon@bugzilla.kernel.org
Subject: [Bug 12272] at random rmmod/insmod corrupts filesystem
Date: Sun, 28 Dec 2008 06:47:35 -0800 (PST)
Message-ID: <20081228144735.DEC8D10800E@picon.linux-foundation.org>
References: <bug-12272-13602@http.bugzilla.kernel.org/>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42730 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750811AbYL1Ori (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Sun, 28 Dec 2008 09:47:38 -0500
Received: from picon.linux-foundation.org (picon.linux-foundation.org [140.211.169.79])
	by smtp1.linux-foundation.org (8.14.2/8.13.5/Debian-3ubuntu1.1) with ESMTP id mBSElaFx019904
	for <linux-ext4@vger.kernel.org>; Sun, 28 Dec 2008 06:47:37 -0800
In-Reply-To: <bug-12272-13602@http.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

http://bugzilla.kernel.org/show_bug.cgi?id=12272





------- Comment #3 from folkert@vanheusden.com  2008-12-28 06:47 -------
(In reply to comment #1)
> please provide the output of the script and/or post a list of your modules. 
> do you see any warnings/oopses in dmesg while running it ?

No oopses, no warnings.
Only odd messages I see are:
[  487.377387] bio too big device hda5 (8 > 0)
[  487.377860] bio too big device hda5 (8 > 0)

will reboot tomorrow to see what filesystem errors there are


-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug, or are watching the assignee.
