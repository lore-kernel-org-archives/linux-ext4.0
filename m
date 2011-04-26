From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 25832] kernel crashes when a mounted ext3/4 file system is
 physically removed
Date: Tue, 26 Apr 2011 18:15:03 GMT
Message-ID: <201104261815.p3QIF3CF028959@demeter1.kernel.org>
References: <bug-25832-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter1.kernel.org ([140.211.167.39]:59775 "EHLO
	demeter1.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757921Ab1DZSPF (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 26 Apr 2011 14:15:05 -0400
Received: from demeter1.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter1.kernel.org (8.14.4/8.14.3) with ESMTP id p3QIF3Xf028960
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Tue, 26 Apr 2011 18:15:03 GMT
In-Reply-To: <bug-25832-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=25832





--- Comment #78 from Alan Stern <stern@rowland.harvard.edu>  2011-04-26 18:15:00 ---
I can report triggering a similar problem -- once.  I attached a USB drive with
an ext4 filesystem, mounted it, read a file from it, unbound usb-storage, and
then unmounted it.  No desktop was running at the time.  About a second later I
got a nasty crash -- an unending stream of log messages scrolling up the
console, with no way to stop it other than powering off the machine.

So then I rebuilt the test kernel to add netconsole support, and I have not
been able to trigger the problem since.

It wouldn't be at all suprising to find out that this bug lies not in the
filesystem code but somewhere lower, such as the block layer or even the SCSI
core.  It seems to have a large random component as well as a delayed impact. 
Rocko is able to trigger it a lot more reproducibly.

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
