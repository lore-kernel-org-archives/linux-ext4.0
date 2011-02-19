From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 25832] kernel crashes upon resume if usb devices are removed
 when suspended
Date: Sat, 19 Feb 2011 15:55:20 GMT
Message-ID: <201102191555.p1JFtKVd009476@demeter2.kernel.org>
References: <bug-25832-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter2.kernel.org ([140.211.167.42]:55808 "EHLO
	demeter2.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751038Ab1BSPzV (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 19 Feb 2011 10:55:21 -0500
Received: from demeter2.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter2.kernel.org (8.14.4/8.14.3) with ESMTP id p1JFtKcf009477
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Sat, 19 Feb 2011 15:55:20 GMT
In-Reply-To: <bug-25832-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=25832





--- Comment #30 from Alan Stern <stern@rowland.harvard.edu>  2011-02-19 15:55:19 ---
I don't know about tracking this down, but for testing purposes you can
reproduce these conditions without actually unplugging and replugging the
device.  All you have to do is go into the /sys/bus/usb/drivers/usb_storage
directory.  In there, you'll see a file representing each usb-storage device in
your system, with names like "2-1.2:1.0".

To imitate an unplug, write the corresponding file name to the "unbind" file. 
To imitate a replug, write the file name to the "bind" file.  For example:

   echo -n 2-1.2:1.0 >unbind
   echo -n 2-1.2:1.0 >bind

This can easily be automated in a shell-script loop, which should speed up your
testing.

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
