From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 14354] Bad corruption with 2.6.32-rc1 and upwards
Date: Sat, 24 Oct 2009 17:04:38 GMT
Message-ID: <200910241704.n9OH4cxh017290@demeter.kernel.org>
References: <bug-14354-13602@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:42008 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750961AbZJXREd (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 24 Oct 2009 13:04:33 -0400
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.2/8.14.2) with ESMTP id n9OH4cGm017291
	for <linux-ext4@vger.kernel.org>; Sat, 24 Oct 2009 17:04:38 GMT
In-Reply-To: <bug-14354-13602@http.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

http://bugzilla.kernel.org/show_bug.cgi?id=14354





--- Comment #110 from Maxim Levitsky <maximlevitsky@gmail.com>  2009-10-24 17:04:29 ---
I got some bad news for you.

I have just finished recovering from another semi-severe corruption, this time
again on my laptop.

This time:

1 - there were no crashes, for last week, and no s2ram/disk was ever attempted.
2 - tune2fs -c 1 was used, and I know for sure that fsck did run every boot
(tested without usplash, and with (had very slow boot as expected))

Yet, today, I did usual 'apt-get' update, I updated -git version of
NetworkManager I use, and noticed that it won't connect via pptp. So to be sure
I rebooted the system, fsck failed, and large corruption is there...


So it looks like bitmaps are corrupted during runtime, and crashes aren't the
cause.

The rest in attached log

-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
