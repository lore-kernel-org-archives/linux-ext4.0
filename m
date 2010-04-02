From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 14830] When other IO is running sync times go to 10 to 20
 minutes
Date: Fri, 2 Apr 2010 05:41:35 GMT
Message-ID: <201004020541.o325fZKw007754@demeter.kernel.org>
References: <bug-14830-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:38827 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757928Ab0DBFlg (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 2 Apr 2010 01:41:36 -0400
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.3/8.14.3) with ESMTP id o325fZGd007763
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Fri, 2 Apr 2010 05:41:36 GMT
In-Reply-To: <bug-14830-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=14830





--- Comment #22 from Michael Godfrey <godfrey@isl.stanford.edu>  2010-04-02 05:41:26 ---
I tried another test with 2.6.32.10-90.fc12.x86_64.  I did
not expect an improvement.  But, the results were actually
a lot worse.  After starting an rsync  which transferred a
few 100GB through NFS, I started a sync using time sync.
This caused a number of the usual 2 minute timeout messages.  But, also
it did not close until about 20 minutes after the rsync had
completed.  All together  it ran for several hours. By the
way it was not possible to kill the sync using kill -9.

This is clearly hopeless.

Will anything be done about this in 2.6.33 for fc13?

Will the fact that Google is going with ext4 possibly help?

Michael

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
