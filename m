From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 34302] Errors from kjournald
Date: Tue, 3 May 2011 18:48:29 GMT
Message-ID: <201105031848.p43ImT7Q001182@demeter1.kernel.org>
References: <bug-34302-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter1.kernel.org ([140.211.167.39]:37686 "EHLO
	demeter1.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754251Ab1ECSs3 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 3 May 2011 14:48:29 -0400
Received: from demeter1.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter1.kernel.org (8.14.4/8.14.3) with ESMTP id p43ImT8H001183
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Tue, 3 May 2011 18:48:29 GMT
In-Reply-To: <bug-34302-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=34302





--- Comment #4 from Tom Moore <tmoore@spatial.ca>  2011-05-03 18:48:28 ---
> This looks like a problem with your disk. 

So this is a disk hardware problem...

> One possibility is if the source disks share the SATA controller with the
> target they may both be blocked at the same time.  

... or is it a driver problem?  I am not sure what you mean by both being
blocked at the same time, and I don't know what I should do about it.

I have two sata controllers, and I put one of the source raid disks on each
controller.  I thought that this would improve reliability and perhaps
performance.  This means that the backup target disk shares a controller with
one of the source disks.  It appears that the drive that reset is on the second
controller with the backup target disk (how do I confirm what contoller the
devices ata8.00 and ata9.00 belong to?).

I would appreciate any suggestions on how to triage this problem as being
either 
1) hardware that should be replaced (easy) and close this bug report; or
2) driver related that needs to be watched for in case it happens again.

TIA

Tom

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
