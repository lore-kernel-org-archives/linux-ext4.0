From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 17361] Watchdog detected hard LOCKUP in
 jbd2_journal_get_write_access
Date: Wed, 22 Sep 2010 17:58:51 GMT
Message-ID: <201009221758.o8MHwpHo020440@demeter2.kernel.org>
References: <bug-17361-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from [140.211.167.42] ([140.211.167.42]:33469 "EHLO
	demeter2.kernel.org" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1752912Ab0IVR6w (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 22 Sep 2010 13:58:52 -0400
Received: from demeter2.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter2.kernel.org (8.14.4/8.14.3) with ESMTP id o8MHwpQc020441
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Wed, 22 Sep 2010 17:58:52 GMT
In-Reply-To: <bug-17361-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=17361





--- Comment #9 from Christian Casteyde <casteyde.christian@free.fr>  2010-09-22 17:58:50 ---
Created an attachment (id=31012)
 --> (https://bugzilla.kernel.org/attachment.cgi?id=31012)
finally, the NULL dereference

I'm not sure the second and next warnings are not due to the first one, and a
bug in kmemcheck itself.
I'm totally unable to tell what cause it, and I gave up bisecting because it
crashes here and there, and I cannot say what crash is due to which bug, if
ever there is only one bug.

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
