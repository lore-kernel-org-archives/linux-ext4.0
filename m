From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 13909] md5sum on 3GB file is constantly hanging
Date: Mon, 17 Aug 2009 10:23:04 GMT
Message-ID: <200908171023.n7HAN45i023930@demeter.kernel.org>
References: <bug-13909-13602@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:34072 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757498AbZHQKXD (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 17 Aug 2009 06:23:03 -0400
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.2/8.14.2) with ESMTP id n7HAN4Vs023931
	for <linux-ext4@vger.kernel.org>; Mon, 17 Aug 2009 10:23:04 GMT
In-Reply-To: <bug-13909-13602@http.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

http://bugzilla.kernel.org/show_bug.cgi?id=13909





--- Comment #29 from Rus <harbour@sfinx.od.ua>  2009-08-17 10:23:00 ---
Yes, this fixed the problem for 3GB file. But I've tried to cat 11GB file -
full HDD activity for 3 hours - nothing happens. But dd exits with Ctrl-C at
least. May be unsigned long is too small for max file size limit that exists in
Linux filesystems ?

-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
