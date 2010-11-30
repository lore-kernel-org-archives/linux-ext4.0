From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 23772] oops after mounting ext4 fs in 2.6.36.1 (failed to parse
 options in superblock)
Date: Tue, 30 Nov 2010 21:16:36 GMT
Message-ID: <201011302116.oAULGaip017279@demeter1.kernel.org>
References: <bug-23772-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter1.kernel.org ([140.211.167.39]:46453 "EHLO
	demeter1.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751475Ab0K3VQh (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 30 Nov 2010 16:16:37 -0500
Received: from demeter1.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter1.kernel.org (8.14.4/8.14.3) with ESMTP id oAULGafO017280
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Tue, 30 Nov 2010 21:16:36 GMT
In-Reply-To: <bug-23772-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=23772





--- Comment #19 from Fryderyk Dziarmagowski <fdziarmagowski@gmail.com>  2010-11-30 21:16:34 ---
(In reply to comment #17)
> Something is scribbling on / has scribbled on the front of your filesystem, it
> seems.

"is scribbling" is the right one. After doing a dd once more, just after error
msg, the file system was altered (compared visually in text editor). 

> What kind of storage is this?

external usb disk by western digital:
# skdump /dev/disk/by-label/MyBook
Device: sat12:/dev/disk/by-label/MyBook
Type: 12 Byte SCSI ATA SAT Passthru
Size: 305242 MiB
Model: [WDC WD3200AAKS-00SBA0]
Serial: [WD-WCAPZ2842083]
Firmware: [12.01B01]
SMART Available: yes

Unfortunately, the oops is back. Tried to run fsck -f on the unlucky partition
causes a hard lockup (only reset helps). For this time, it was something with
ext4_msg, I will do a screenshot tomorrow.

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
