From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 112631] Cannot open encrypted Luks root filesystem
Date: Fri, 19 Feb 2016 18:52:19 +0000
Message-ID: <bug-112631-13602-i0ZGddtzGy@https.bugzilla.kernel.org/>
References: <bug-112631-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:45134 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2992921AbcBSSwW (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 19 Feb 2016 13:52:22 -0500
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id A37B820522
	for <linux-ext4@vger.kernel.org>; Fri, 19 Feb 2016 18:52:21 +0000 (UTC)
Received: from bugzilla1.web.kernel.org (bugzilla1.web.kernel.org [172.20.200.51])
	by mail.kernel.org (Postfix) with ESMTP id 5CA002053F
	for <linux-ext4@vger.kernel.org>; Fri, 19 Feb 2016 18:52:19 +0000 (UTC)
In-Reply-To: <bug-112631-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=112631

Karl Sponser <karl.sponser@web.de> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |karl.sponser@web.de

--- Comment #2 from Karl Sponser <karl.sponser@web.de> ---
I can confirm the problem on Fedora ARM with the RPI Kernel 4.1.18 (previous
kernels worked). It's not possible to open a luks container nor format a new
device:



# cryptsetup luksOpen /dev/vg1/test1 luks-test1
Enter passphrase for /dev/vg1/test1:
Failed to setup dm-crypt key mapping for device /dev/vg1/test1.
Check that kernel supports aes-xts-plain64 cipher (check syslog for more info).



# cryptsetup luksFormat /dev/vg1/test2
WARNING!
========
This will overwrite data on /dev/vg1/test2 irrevocably.
Are you sure? (Type uppercase yes): YES
Enter passphrase:
Verify passphrase:
Failed to setup dm-crypt key mapping for device /dev/vg1/test2.
Check that kernel supports aes-xts-plain64 cipher (check syslog for more info). 



Even if the message tells to check syslog for more information, there's no
entry in /var/log/messages nor in dmesg output.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
