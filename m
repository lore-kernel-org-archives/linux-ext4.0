From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 14830] When other IO is running sync times go to 10 to 20
 minutes
Date: Tue, 6 Apr 2010 23:01:18 GMT
Message-ID: <201004062301.o36N1IiK007214@demeter.kernel.org>
References: <bug-14830-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:41253 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757608Ab0DFXB2 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 6 Apr 2010 19:01:28 -0400
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.3/8.14.3) with ESMTP id o36N1Lw8007220
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Tue, 6 Apr 2010 23:01:21 GMT
In-Reply-To: <bug-14830-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=14830





--- Comment #29 from Eric Sandeen <sandeen@redhat.com>  2010-04-06 22:59:27 ---
A quick test on ext3 looks good; ext4 still seems to run away on sync :(

But I need to be a bit more methodical, and test a few more filesystems; will
let you know.

I'm not familiar enough with all the new writeback code; does this mean that a
sync will return as soon as any new IO is queued post-sync?  That seems odd if
so - but maybe I misunderstand.

Thanks,
-Eric

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
