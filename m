From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 14972] [regression] msync() call on ext4 causes disk thrashing
Date: Wed, 11 Jan 2012 00:08:00 GMT
Message-ID: <201201110008.q0B080aJ015397@bugzilla.kernel.org>
References: <bug-14972-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from bugzilla.kernel.org ([198.145.19.204]:41307 "EHLO
	bugzilla.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756145Ab2AMXNv (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 13 Jan 2012 18:13:51 -0500
Received: from bugzilla.kernel.org (localhost [127.0.0.1])
	by bugzilla.kernel.org (8.14.5/8.14.5) with ESMTP id q0B080Ou015398
	for <linux-ext4@vger.kernel.org>; Wed, 11 Jan 2012 00:08:00 GMT
In-Reply-To: <bug-14972-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=14972


Artem S. Tashkinov <t.artem@mailcity.com> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
             Status|NEW                         |RESOLVED
         Resolution|                            |CODE_FIX




--- Comment #13 from Artem S. Tashkinov <t.artem@mailcity.com>  2012-01-11 00:07:59 ---
In one of recent kernels (somewhere around 2.6.38) this issue was fixed.

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
