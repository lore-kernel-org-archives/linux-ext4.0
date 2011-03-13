From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 25832] kernel crashes upon resume if usb devices are removed
 when suspended
Date: Sun, 13 Mar 2011 21:17:03 GMT
Message-ID: <201103132117.p2DLH3PY029708@demeter1.kernel.org>
References: <bug-25832-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter1.kernel.org ([140.211.167.39]:35301 "EHLO
	demeter1.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755434Ab1CMVRE (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 13 Mar 2011 17:17:04 -0400
Received: from demeter1.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter1.kernel.org (8.14.4/8.14.3) with ESMTP id p2DLH3Dp029709
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Sun, 13 Mar 2011 21:17:03 GMT
In-Reply-To: <bug-25832-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=25832





--- Comment #47 from Alan Stern <stern@rowland.harvard.edu>  2011-03-13 21:17:00 ---
Okay, if you believe this, and if you can reliably detect the bug (which is
often a difficult thing to be sure of), then you can try bisecting the kernel
changes between 2.6.35 and 2.6.36-rc1.

The thing is, the test really does have to be reliable.  If you make a mistake
(tell git that a kernel doesn't have the bug when it actually does) then you're
very unlikely to track down the true cause.  Still, it's worth a try --
especially since nothing else seems to help!

The test you used in comment #31 would be a good approach.

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
