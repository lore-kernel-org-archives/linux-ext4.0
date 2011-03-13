From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 25832] kernel crashes upon resume if usb devices are removed
 when suspended
Date: Sun, 13 Mar 2011 03:01:48 GMT
Message-ID: <201103130301.p2D31mmG021814@demeter1.kernel.org>
References: <bug-25832-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter1.kernel.org ([140.211.167.39]:42292 "EHLO
	demeter1.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756323Ab1CMDBt (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 12 Mar 2011 22:01:49 -0500
Received: from demeter1.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter1.kernel.org (8.14.4/8.14.3) with ESMTP id p2D31mj1021815
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Sun, 13 Mar 2011 03:01:48 GMT
In-Reply-To: <bug-25832-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=25832





--- Comment #46 from rocko <rockorequin@hotmail.com>  2011-03-13 03:01:46 ---
It's always a possibility, but I don't think this is a RAM problem. I have run
memory tests fairly recently to try and rule it out. One of the BIOS RAM tests
is very extensive: I didn't run it to completion because it would have taken
many hours to complete, but did let it go for 20 minutes or so. It tested quite
a few patterns and didn't find any failures. I also occasionally make it run
the 'quick' memory check upon boot (about 5 minutes worth) and it never finds
problems.

There are other indicators that this probably isn't a hardware problem:

* I have seen this bug occur on another PC that was running 2.6.37 at the time
- it crashed when I unplugged the external USB hub without unmounting the
drives first.

* I don't get crashes during normal operation - only after removing USB drives.
And only if they were mounted prior to removing them.

* Just now I have been testing Ubuntu's 2.6.35-28-generic kernel more
extensively and haven't been able to crash it (around 20 suspend/resume cycles
without incident).

* I did manage to crash a VM running Ubuntu 11.04 with kernel 2.6.38-rc8 by
using VirtualBox's USB menu in the status bar to repeatedly attach and remove
an external USB drive. It took about ten goes before it hung. In the past, the
host has usually crashed during this test, but this time I was running 2.6.35
on the host and only the VM crashed.

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
