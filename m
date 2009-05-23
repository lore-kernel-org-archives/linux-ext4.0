From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 13201] kernel BUG at fs/ext4/extents.c:2737
Date: Sat, 23 May 2009 10:10:52 GMT
Message-ID: <200905231010.n4NAAq04014995@demeter.kernel.org>
References: <bug-13201-13602@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:39854 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751729AbZEWKKw (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 23 May 2009 06:10:52 -0400
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.2/8.14.2) with ESMTP id n4NAAq80014996
	for <linux-ext4@vger.kernel.org>; Sat, 23 May 2009 10:10:52 GMT
In-Reply-To: <bug-13201-13602@http.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

http://bugzilla.kernel.org/show_bug.cgi?id=13201





--- Comment #7 from Franco Broi <franco@fugro-fsi.com.au>  2009-05-23 10:10:50 ---
I wont be able to recreate the original test conditions but I'll run a test
with a single large filesystem within a couple of weeks.

-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
