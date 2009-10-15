From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 14354] Bad corruption with 2.6.32-rc1 and upwards
Date: Thu, 15 Oct 2009 04:24:51 GMT
Message-ID: <200910150424.n9F4Opmi003256@demeter.kernel.org>
References: <bug-14354-13602@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:37431 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750948AbZJOEZ1 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 15 Oct 2009 00:25:27 -0400
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.2/8.14.2) with ESMTP id n9F4OpA7003257
	for <linux-ext4@vger.kernel.org>; Thu, 15 Oct 2009 04:24:51 GMT
In-Reply-To: <bug-14354-13602@http.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

http://bugzilla.kernel.org/show_bug.cgi?id=14354





--- Comment #52 from Theodore Tso <tytso@mit.edu>  2009-10-15 04:24:49 ---
BTW, I've been doing additional tests where I'm doing a kernel or e2fsprogs 
build on my laptop, and then force a power down/crash while the build is
running, and I still haven't been able to reproduce the bug on my end.   Can
someone give me a hint about what else might be happening on the system when
the crash happens?

Thanks!!

-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
