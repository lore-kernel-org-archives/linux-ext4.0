From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 25832] kernel crashes upon resume if usb devices are removed
 when suspended
Date: Sat, 5 Feb 2011 19:56:57 GMT
Message-ID: <201102051956.p15Juvmt026929@demeter1.kernel.org>
References: <bug-25832-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter1.kernel.org ([140.211.167.39]:58266 "EHLO
	demeter1.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752526Ab1BET47 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 5 Feb 2011 14:56:59 -0500
Received: from demeter1.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter1.kernel.org (8.14.4/8.14.3) with ESMTP id p15Juv6f026941
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Sat, 5 Feb 2011 19:56:57 GMT
In-Reply-To: <bug-25832-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=25832





--- Comment #13 from rocko <rockorequin@hotmail.com>  2011-02-05 19:56:52 ---
I can reproduce the freezing problem fairly reliably - it doesn't always occur,
but seems likely to occur over 3-5 suspend/resume cycles. 

I also have seen it occur on another PC (an older Dell 32 bit laptop, fwiw)
using the same external drive setup, ie with four USB drives attached via a
7-in-1 D-Link USB hub. Two are 1TB ext4 drives, one is a 500GB ext4 drive, and
the other drive was either a 1TB ext4 drive or a 500GB ntfs drive. I did try
reproducing the freeze with just a single drive attached but wasn't successful,
so perhaps the number of drives is relevant.

Both PCs that I have seen the freeze on were running Ubuntu 10.10. 

To see the (truncated) debug log I suspended from a console using
"/etc/init.d/sleep.sh force".


The fact that FUSE was involved in comment #10 puzzles me, given that that bug
dump starts off saying it's an EXT4-fs error on sdb1 - isn't ext4 purely a
kernel driver? I assume FUSE would have been loaded because of the ntfs-3g
driver loaded for sdf1? It's quite possible that comment #10 was a different
bug entirely, because the system didn't freeze. If it is related, it might be
relevant that the freezing problem also occurs with only external ext4 drives
attached. FUSE might still have been loaded though at that time the PC used to
have an internal ntfs partition. Does the reference to gnome-panel reading
directory lblock 0 suggest gnome-panel was trying to read a configuration file?
Those would all be on my ext4 home partition, which is on the internal drive.

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
