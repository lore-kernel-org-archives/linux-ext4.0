From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 14972] [regression] msync() call on ext4 causes disk thrashing
Date: Mon, 4 Jan 2010 10:05:44 GMT
Message-ID: <201001041005.o04A5i30016547@demeter.kernel.org>
References: <bug-14972-13602@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:57800 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752471Ab0ADKFp (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 4 Jan 2010 05:05:45 -0500
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.3/8.14.2) with ESMTP id o04A5iSb016549
	for <linux-ext4@vger.kernel.org>; Mon, 4 Jan 2010 10:05:44 GMT
In-Reply-To: <bug-14972-13602@http.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

http://bugzilla.kernel.org/show_bug.cgi?id=14972





--- Comment #11 from Artem S. Tashkinov <t.artem@mailcity.com>  2010-01-04 10:05:42 ---
Created an attachment (id=24427)
 --> (http://bugzilla.kernel.org/attachment.cgi?id=24427)
blktrace for /dev/sda while running the test application

Thank you very much, Eric!

It seems like a lot of documentation needs to be updated.

-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
