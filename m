From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 14562] On umount warn in page_alloc.c:1751
 __alloc_pages_slowpath
Date: Mon, 9 Nov 2009 16:20:45 GMT
Message-ID: <200911091620.nA9GKjE0029286@demeter.kernel.org>
References: <bug-14562-13602@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:43492 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751459AbZKIQUk (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 9 Nov 2009 11:20:40 -0500
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.2/8.14.2) with ESMTP id nA9GKjPf029287
	for <linux-ext4@vger.kernel.org>; Mon, 9 Nov 2009 16:20:45 GMT
In-Reply-To: <bug-14562-13602@http.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

http://bugzilla.kernel.org/show_bug.cgi?id=14562





--- Comment #2 from Torsten Krah <tkrah@fachschaft.imn.htwk-leipzig.de>  2009-11-09 16:20:43 ---
Yes, you are right. I did mount it shortly afterwards again - like the trace
shows.
Hm the mount options aren't really "interesting", fstab read and reads like
this:

UUID=<UUID> /home ext4 defaults,relatime,errors=remount-ro 0 1

-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
