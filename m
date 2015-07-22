From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 89511] USB-storage mount error
Date: Wed, 22 Jul 2015 17:39:01 +0000
Message-ID: <bug-89511-13602-QcCOzWBXE4@https.bugzilla.kernel.org/>
References: <bug-89511-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:33001 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754481AbbGVRjG (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 22 Jul 2015 13:39:06 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 6C9BA2051A
	for <linux-ext4@vger.kernel.org>; Wed, 22 Jul 2015 17:39:04 +0000 (UTC)
Received: from bugzilla2.web.kernel.org (bugzilla2.web.kernel.org [172.20.200.52])
	by mail.kernel.org (Postfix) with ESMTP id A0C3020667
	for <linux-ext4@vger.kernel.org>; Wed, 22 Jul 2015 17:39:01 +0000 (UTC)
In-Reply-To: <bug-89511-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=89511

Dan Williams <dcbw@redhat.com> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |dcbw@redhat.com

--- Comment #68 from Dan Williams <dcbw@redhat.com> ---
I have a drive with this problem and I tested 4.0.8 with this hunk added to the
patch above.

UNUSUAL_DEV(  0x0bc2, 0x0888, 0x0000, 0x0000,
              "Seagate",
              "USB 2.0 Pocket Hard Drive",
              USB_SC_DEVICE, USB_PR_DEVICE, NULL,
              US_FL_NO_SYNCHRONIZE_CACHE),

I don't have the linux-usb thread around so I can reply to
http://www.spinics.net/lists/linux-usb/msg126364.html, but here's the result
of:

[dcbw@localhost ~]$ sudo hdparm -W 0 --prefer-ata12 /dev/sdb

/dev/sdb:
 setting drive write-caching to 0 (off)
SG_IO: bad/missing sense data, sb[]:  70 00 05 00 00 00 00 0a 00 00 00 00 20 00
00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
SG_IO: bad/missing sense data, sb[]:  70 00 05 00 00 00 00 0a 00 00 00 00 20 00
00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
SG_IO: bad/missing sense data, sb[]:  70 00 05 00 00 00 00 0a 00 00 00 00 20 00
00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
SG_IO: bad/missing sense data, sb[]:  70 00 05 00 00 00 00 0a 00 00 00 00 20 00
00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
SG_IO: bad/missing sense data, sb[]:  70 00 05 00 00 00 00 0a 00 00 00 00 20 00
00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
 write-caching = not supported

What was the upstream resolution on this one?

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
