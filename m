From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 89511] USB-storage mount error
Date: Fri, 19 Dec 2014 18:51:29 +0000
Message-ID: <bug-89511-13602-BSYVwiCLJC@https.bugzilla.kernel.org/>
References: <bug-89511-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:39367 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751142AbaLSSve (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 19 Dec 2014 13:51:34 -0500
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id DE38320148
	for <linux-ext4@vger.kernel.org>; Fri, 19 Dec 2014 18:51:32 +0000 (UTC)
Received: from bugzilla2.web.kernel.org (bugzilla2.web.kernel.org [172.20.200.52])
	by mail.kernel.org (Postfix) with ESMTP id 3A12D2014A
	for <linux-ext4@vger.kernel.org>; Fri, 19 Dec 2014 18:51:30 +0000 (UTC)
In-Reply-To: <bug-89511-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=89511

--- Comment #15 from Alan Stern <stern@rowland.harvard.edu> ---
You did not attach anything -- instead you copied & pasted the logs directly
into the bug report!  This makes the report very long and hard to read.  You
should have used the "add an attachment" button near the top of the bug report.

Also, I can't tell what you did here.  You posted several logs and several
usbmon traces, but you didn't say how they are related.  Also, the usbmon
traces don't show any errors!

Here's what you should do:

   Plug in the drive and check the kernel log to see which bus it is attached
to.

   Unplug the drive.

   Run "dmesg -C" to clear the kernel's log buffer

   Run "cat /sys/kernel/debug/usb/usbmon/1u >mon.txt", if the drive was
attached to bus 1.  If it was attached to bus 2, use "2u" instead of "1u".

   Plug in the drive and wait for the error messages to appear.

   Unplug the drive.

   Use ^C to kill the "cat" program above.

   Run "dmesg >log.txt"

Finally, _attach_ (don't copy & paste!) the log.txt and mon.txt files to this
bug report.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
