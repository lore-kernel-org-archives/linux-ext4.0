From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 14562] On umount warn in page_alloc.c:1751
 __alloc_pages_slowpath
Date: Tue, 17 Nov 2009 22:25:16 GMT
Message-ID: <200911172225.nAHMPG2g025956@demeter.kernel.org>
References: <bug-14562-13602@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:45164 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753430AbZKQWZK (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 17 Nov 2009 17:25:10 -0500
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.2/8.14.2) with ESMTP id nAHMPGSI025957
	for <linux-ext4@vger.kernel.org>; Tue, 17 Nov 2009 22:25:16 GMT
In-Reply-To: <bug-14562-13602@http.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

http://bugzilla.kernel.org/show_bug.cgi?id=14562





--- Comment #5 from Francis Russell <francis+lkbt@unchartedbackwaters.co.uk>  2009-11-17 22:25:15 ---
Created an attachment (id=23817)
 --> (http://bugzilla.kernel.org/attachment.cgi?id=23817)
Warning from syslog

-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
