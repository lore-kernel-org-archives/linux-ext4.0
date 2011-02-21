From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 25832] kernel crashes upon resume if usb devices are removed
 when suspended
Date: Mon, 21 Feb 2011 16:48:36 GMT
Message-ID: <201102211648.p1LGmaLd005849@demeter2.kernel.org>
References: <bug-25832-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter2.kernel.org ([140.211.167.42]:40096 "EHLO
	demeter2.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751551Ab1BUQsj (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 21 Feb 2011 11:48:39 -0500
Received: from demeter2.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter2.kernel.org (8.14.4/8.14.3) with ESMTP id p1LGmauC005850
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Mon, 21 Feb 2011 16:48:36 GMT
In-Reply-To: <bug-25832-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=25832





--- Comment #35 from Alan Stern <stern@rowland.harvard.edu>  2011-02-21 16:48:34 ---
If you generate plug and unplug events too rapidly, you will overrun the USB
hub driver.  If you run the test while using a VT console instead of X11, and
if you enable CONFIG_USB_DEBUG and do "echo 8 >/proc/sys/kernel/printk" before
starting, you'll be able to see what's going on.

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
