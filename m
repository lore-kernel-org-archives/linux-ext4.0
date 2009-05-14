From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 13292] ext4 without journal reproductible file corruption
Date: Thu, 14 May 2009 20:07:25 GMT
Message-ID: <200905142007.n4EK7PX5029724@demeter.kernel.org>
References: <bug-13292-13602@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:56985 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753180AbZENUHZ (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 14 May 2009 16:07:25 -0400
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.2/8.14.2) with ESMTP id n4EK7PYg029725
	for <linux-ext4@vger.kernel.org>; Thu, 14 May 2009 20:07:25 GMT
In-Reply-To: <bug-13292-13602@http.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

http://bugzilla.kernel.org/show_bug.cgi?id=13292





--- Comment #3 from Frank Mayhar <fmayhar@google.com>  2009-05-14 20:07:25 ---
Thank you for the very detailed information you provided.  Unfortunately I
can't reproduce this problem in my environment.  That environment is, however,
somewhat different from yours, in that it's a 2.6.26 kernel plus ext4 patches
up to March 16 (minus a few patches that depended on changes in other parts of
the kernel).

My suggestion is that you drop back to the March 16 (or so) kernel and see if
you can reproduce the problem.  If you can't reproduce it then you can do a
binary search to see where the problem started, i.e. try an April 15 kernel,
etc., until you home in on the offending commit.

If you _can_ reproduce the problem with the March 16 kernel then something more
complex is going on and I'll have to try again to reproduce it here.

-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
