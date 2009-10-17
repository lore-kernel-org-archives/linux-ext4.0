From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 14354] Bad corruption with 2.6.32-rc1 and upwards
Date: Sat, 17 Oct 2009 20:59:08 GMT
Message-ID: <200910172059.n9HKx8bI015264@demeter.kernel.org>
References: <bug-14354-13602@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:39994 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753831AbZJQU7E (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 17 Oct 2009 16:59:04 -0400
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.2/8.14.2) with ESMTP id n9HKx86K015265
	for <linux-ext4@vger.kernel.org>; Sat, 17 Oct 2009 20:59:08 GMT
In-Reply-To: <bug-14354-13602@http.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

http://bugzilla.kernel.org/show_bug.cgi?id=14354





--- Comment #86 from Alexey Fisher <bug-track@fisher-privat.net>  2009-10-17 20:59:07 ---
With commit fe188c0e i get "clean" fsck log with 91ac6f43 i get error like:

Free blocks count wrong for group #0 (8935, counted=8922).

Entry 'libnss_wins.so.2' in /var/spool/postfix/lib (155666) has deleted/unused
inode 136151.  Clear? yes

Running additional passes to resolve blocks claimed by more than one inode...
Pass 1B: Rescanning for multiply-claimed blocks
Multiply-claimed block(s) in inode 131134: 557394
Multiply-claimed block(s) in inode 131201: 557394

... you'll see it. To be sue i double checked two this kernels.

-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
