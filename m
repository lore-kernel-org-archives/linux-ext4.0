From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 13232] ext3/4 with synchronous writes gets wedged by Postfix
Date: Wed, 13 May 2009 16:18:58 GMT
Message-ID: <200905131618.n4DGIw3O023762@demeter.kernel.org>
References: <bug-13232-13602@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:57961 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760721AbZEMQS7 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 13 May 2009 12:18:59 -0400
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.2/8.14.2) with ESMTP id n4DGIwe8023763
	for <linux-ext4@vger.kernel.org>; Wed, 13 May 2009 16:18:58 GMT
In-Reply-To: <bug-13232-13602@http.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

http://bugzilla.kernel.org/show_bug.cgi?id=13232


Vincent Li <mchun.li@gmail.com> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |mchun.li@gmail.com




--- Comment #5 from Vincent Li <mchun.li@gmail.com>  2009-05-13 16:18:57 ---
I tried to run Postfix on ubuntu 9.04 server version and followed the reporduce
command, had the same problem.

kernel version: 2.6.30-rc4
Distribution: Ubuntu 9.04 
Software Environment: Postfix 2.5.1-2ubuntu1.2

also have following message poping up on control terminal:

[844,700070] INFO: task kjournald: 628 blocked for more than 120 seconds,
[844,700148] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this
meassage.

-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
