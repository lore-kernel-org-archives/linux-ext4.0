From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 25832] kernel crashes upon resume if usb devices are removed
 when suspended
Date: Fri, 4 Feb 2011 06:28:24 GMT
Message-ID: <201102040628.p146SOBx001646@demeter1.kernel.org>
References: <bug-25832-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter1.kernel.org ([140.211.167.39]:52552 "EHLO
	demeter1.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751787Ab1BDG2Z (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 4 Feb 2011 01:28:25 -0500
Received: from demeter1.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter1.kernel.org (8.14.4/8.14.3) with ESMTP id p146SOt5001659
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Fri, 4 Feb 2011 06:28:24 GMT
In-Reply-To: <bug-25832-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=25832





--- Comment #7 from rocko <rockorequin@hotmail.com>  2011-02-04 06:27:51 ---
Thanks for the feedback. I didn't have CONFIG_DETECT_SOFTLOCKUP enabled, so I
recompiled the kernel with it on. I managed to reproduce the problem but
unfortunately still didn't get anything useful in the logs. The syslog shows
immediately after the wlan reconnected:

Feb  4 14:13:02 pegasus-maverick anacron[6272]: Anacron 2.3 started on
2011-02-04
Feb  4 14:13:02 pegasus-maverick anacron[6272]: Normal exit (0 jobs run)
<hard reset was required here>
Feb  4 14:14:30 pegasus-maverick kernel: imklog 4.2.0, log source = /proc/kmsg
started.


Might the number of USB devices be relevant? I used to have external 4 drives
connected and now only have 3: I managed three suspend/resume cycles without
getting the freeze, but after I attached a fourth drive (NTFS btw, whereas the
others are ext4), the next suspend/resume cycle froze the machine.


Am I right in thinking sysrq requires me to connect over the network? The
problem with that is that I can only reproduce this reliably after a
suspend/resume cycle, and of course the network connection is lost during
suspend and the machine typically locks up so quickly that I don't have time to
establish a new connection.

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
