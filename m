From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 13964] ext4: panic causes lost data in git
Date: Sat, 29 Aug 2009 13:06:47 GMT
Message-ID: <200908291306.n7TD6lDn024299@demeter.kernel.org>
References: <bug-13964-13602@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:41837 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751183AbZH2NGp (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 29 Aug 2009 09:06:45 -0400
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.2/8.14.2) with ESMTP id n7TD6lw5024300
	for <linux-ext4@vger.kernel.org>; Sat, 29 Aug 2009 13:06:47 GMT
In-Reply-To: <bug-13964-13602@http.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

http://bugzilla.kernel.org/show_bug.cgi?id=13964





--- Comment #4 from Roland Kletzing <devzero@web.de>  2009-08-29 13:06:46 ---
ok, but what is the solution for all the apps which don`t have issues with ext3
but start having issues with ext4? fix all the apps? that would take a long
time...   alloc_on_commit really sounds like a good compatibility switch....

-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
