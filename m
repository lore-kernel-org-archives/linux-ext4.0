From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 14972] [regression] msync() call on ext4 causes disk thrashing
Date: Sun, 3 Jan 2010 12:38:55 GMT
Message-ID: <201001031238.o03CctfZ011282@demeter.kernel.org>
References: <bug-14972-13602@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:46970 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752830Ab0ACMi4 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 3 Jan 2010 07:38:56 -0500
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.3/8.14.2) with ESMTP id o03CctWo011283
	for <linux-ext4@vger.kernel.org>; Sun, 3 Jan 2010 12:38:55 GMT
In-Reply-To: <bug-14972-13602@http.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

http://bugzilla.kernel.org/show_bug.cgi?id=14972





--- Comment #9 from Artem S. Tashkinov <t.artem@mailcity.com>  2010-01-03 12:38:54 ---
grep BLK.*TRACE /usr/src/linux/.config

CONFIG_BLK_DEV_IO_TRACE=y

Yes, I'm running under root. SeLinux is disabled in the kernel. I've no idea
what to do :(

-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
