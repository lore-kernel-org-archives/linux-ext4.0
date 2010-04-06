From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 14830] When other IO is running sync times go to 10 to 20
 minutes
Date: Tue, 6 Apr 2010 16:47:01 GMT
Message-ID: <201004061647.o36Gl1Vq019063@demeter.kernel.org>
References: <bug-14830-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:60530 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753018Ab0DFQrD (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 6 Apr 2010 12:47:03 -0400
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.3/8.14.3) with ESMTP id o36Gl1P1019064
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Tue, 6 Apr 2010 16:47:01 GMT
In-Reply-To: <bug-14830-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=14830





--- Comment #25 from Jan Kara <jack@suse.cz>  2010-04-06 16:46:52 ---
As I'm reading through wb_writeback, it could happen that the flushing thread
gets stuck in background flushing and thus we never gets to processing the work
for sync(1) and thus sync(1) never finishes. The attached patch should fix
that.
Eric, could you please test whether this patch together with the patch from
comment 18 fixes your testcase?

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
