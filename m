From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 42872] fstat()/ext3_iget() sometime takes over 2 minutes...
Date: Thu, 15 Mar 2012 17:56:34 GMT
Message-ID: <201203151756.q2FHuYA4023348@bugzilla.kernel.org>
References: <bug-42872-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from bugzilla.kernel.org ([198.145.19.204]:59252 "EHLO
	bugzilla.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031966Ab2COR4e (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 15 Mar 2012 13:56:34 -0400
Received: from bugzilla.kernel.org (localhost [127.0.0.1])
	by bugzilla.kernel.org (8.14.5/8.14.5) with ESMTP id q2FHuYMS023349
	for <linux-ext4@vger.kernel.org>; Thu, 15 Mar 2012 17:56:34 GMT
In-Reply-To: <bug-42872-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=42872





--- Comment #2 from Petr Vandrovec <petr@vandrovec.name>  2012-03-15 17:56:32 ---
Created an attachment (id=72596)
 --> (https://bugzilla.kernel.org/attachment.cgi?id=72596)
dmesg from boot + hang

I've uploaded kernel log from today's occurrence.  Apparently building code
together with find stresses system too much.  'free' says:

             total       used       free     shared    buffers     cached
Mem:       8149468    7922940     226528          0     415524    5283992
-/+ buffers/cache:    2223424    5926044
Swap:      2040248      59792    1980456

which does not look that bad...

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
