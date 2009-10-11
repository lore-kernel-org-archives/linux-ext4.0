From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 14354] Bad corruption with 2.6.32-rc1 and upwards
Date: Sun, 11 Oct 2009 21:45:34 GMT
Message-ID: <200910112145.n9BLjYWV015325@demeter.kernel.org>
References: <bug-14354-13602@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:49762 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752038AbZJKVqK (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 11 Oct 2009 17:46:10 -0400
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.2/8.14.2) with ESMTP id n9BLjYSw015326
	for <linux-ext4@vger.kernel.org>; Sun, 11 Oct 2009 21:45:34 GMT
In-Reply-To: <bug-14354-13602@http.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

http://bugzilla.kernel.org/show_bug.cgi?id=14354





--- Comment #15 from Alexey Fisher <bug-track@fisher-privat.net>  2009-10-11 21:45:34 ---
Yes, i had read-only problem too, but i can't reproduce it now. I had some
trouble to mount system and fsck it, some important files was corrupt. Suddenly
all i wanted is to make it work again.. so there is not dmesg after it.
On my major PC i used debsums to find broken files and reinstall this. On my
laptop i didn't had so mach luck, the packagebase was corrupted so i
reformatted and reinstall the system. I can try to go back to 2.6.32-rcX and
use it until next crush, but i need to know what to do, to extrakt all
information will need for this bug. Thirst good idea will be probably remote
syslog server.

-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
