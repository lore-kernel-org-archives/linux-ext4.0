From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 14972] [regression] msync() call on ext4 causes disk thrashing
Date: Fri, 1 Jan 2010 23:14:39 GMT
Message-ID: <201001012314.o01NEdo3018411@demeter.kernel.org>
References: <bug-14972-13602@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:40914 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751949Ab0AAXOj (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 1 Jan 2010 18:14:39 -0500
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.3/8.14.2) with ESMTP id o01NEdUg018412
	for <linux-ext4@vger.kernel.org>; Fri, 1 Jan 2010 23:14:39 GMT
In-Reply-To: <bug-14972-13602@http.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

http://bugzilla.kernel.org/show_bug.cgi?id=14972





--- Comment #1 from Artem S. Tashkinov <t.artem@mailcity.com>  2010-01-01 23:14:38 ---
Created an attachment (id=24399)
 --> (http://bugzilla.kernel.org/attachment.cgi?id=24399)
.config; dmesg; lspci; hdparm -I

-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
