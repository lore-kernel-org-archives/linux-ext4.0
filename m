From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 25832] kernel crashes when a mounted ext3/4 file system is
 physically removed
Date: Thu, 26 May 2011 06:44:15 GMT
Message-ID: <201105260644.p4Q6iFmN026251@demeter2.kernel.org>
References: <bug-25832-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter2.kernel.org ([140.211.167.42]:42497 "EHLO
	demeter2.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750753Ab1EZGoQ (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 26 May 2011 02:44:16 -0400
Received: from demeter2.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter2.kernel.org (8.14.4/8.14.3) with ESMTP id p4Q6iFuK026272
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Thu, 26 May 2011 06:44:15 GMT
In-Reply-To: <bug-25832-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=25832





--- Comment #82 from rocko <rockorequin@hotmail.com>  2011-05-26 06:44:12 ---
I just hit this again in 2.6.39. I was trying to delete a partition from an
external drive, something went wrong and for some reason the kernel dumped all
the other attached USB drives, whereupon the entire machine crashed with an
"unable to handle paging" then "scheduling while atomic" oops. It's a really
annoying bug.


This is what was recorded in the system log (it actually got written this
time):

May 26 14:28:02 hercules kernel: [128626.171297] xhci_hcd 0000:04:00.0: WARN:
Stalled endpoint
May 26 14:29:36 hercules kernel: [128720.267229] xhci_hcd 0000:04:00.0: WARN:
Stalled endpoint
May 26 14:29:36 hercules kernel: [128720.353640] xhci_hcd 0000:04:00.0: WARN:
Stalled endpoint
May 26 14:29:36 hercules kernel: [128720.380617] xhci_hcd 0000:04:00.0: WARN:
Stalled endpoint
May 26 14:29:41 hercules kernel: [128725.194501] xhci_hcd 0000:04:00.0: WARN:
Stalled endpoint
May 26 14:29:41 hercules kernel: [128725.222284] xhci_hcd 0000:04:00.0: WARN:
Stalled endpoint
May 26 14:29:46 hercules kernel: [128729.766858] xhci_hcd 0000:04:00.0: WARN:
Stalled endpoint
May 26 14:29:46 hercules kernel: [128729.801933] xhci_hcd 0000:04:00.0: WARN:
Stalled endpoint
May 26 14:29:53 hercules kernel: [128736.817629] xhci_hcd 0000:04:00.0: WARN:
Stalled endpoint
May 26 14:29:53 hercules kernel: [128736.817863] xhci_hcd 0000:04:00.0: ERROR
no room on ep ring
May 26 14:29:53 hercules kernel: [128736.817873] xhci_hcd 0000:04:00.0: ERR: No
room for command on command ring
May 26 14:29:53 hercules kernel: [128736.817882] xhci_hcd 0000:04:00.0: FIXME
allocate a new ring segment
May 26 14:30:00 hercules kernel: [128743.863985] xhci_hcd 0000:04:00.0: ERROR
no room on ep ring
May 26 14:30:00 hercules kernel: [128743.863998] xhci_hcd 0000:04:00.0: ERR: No
room for command on command ring
May 26 14:30:05 hercules kernel: [128748.872230] xhci_hcd 0000:04:00.0: xHCI
host not responding to stop endpoint command.
May 26 14:30:05 hercules kernel: [128748.872240] xhci_hcd 0000:04:00.0:
Assuming host is dying, halting host.
May 26 14:30:05 hercules kernel: [128748.878855] xhci_hcd 0000:04:00.0: HC
died; cleaning up
May 26 14:30:05 hercules kernel: [128748.878960] usb 3-1: USB disconnect,
device number 12
May 26 14:30:05 hercules kernel: [128748.878971] usb 3-1.1: USB disconnect,
device number 14
May 26 14:30:05 hercules kernel: [128748.879684] sd 18:0:0:0: Device offlined -
not ready after error recovery
May 26 14:30:05 hercules kernel: [128748.879717] sd 18:0:0:0: rejecting I/O to
offline device
May 26 14:30:05 hercules kernel: [128748.879786] sd 18:0:0:0: [sdf] Unhandled
error code
May 26 14:30:05 hercules kernel: [128748.879793] sd 18:0:0:0: [sdf]  Result:
hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK
May 26 14:30:05 hercules kernel: [128748.879804] sd 18:0:0:0: [sdf] CDB:
Read(10): 28 00 00 00 00 00 00 00 08 00
May 26 14:30:05 hercules kernel: [128748.879830] end_request: I/O error, dev
sdf, sector 0
May 26 14:30:05 hercules kernel: [128748.879840] Buffer I/O error on device
sdf, logical block 0
May 26 14:30:05 hercules kernel: [128748.879915] sd 18:0:0:0: rejecting I/O to
offline device
May 26 14:30:05 hercules kernel: [128748.879978] sd 18:0:0:0: rejecting I/O to
offline device
May 26 14:30:05 hercules kernel: [128748.963133] usb 3-1.5: USB disconnect,
device number 15
May 26 14:30:05 hercules kernel: [128749.116280] JBD2: I/O error detected when
updating journal superblock for sdd1-8.
May 26 14:30:05 hercules kernel: [128749.222460] usb 3-1.6: USB disconnect,
device number 13
May 26 14:30:05 hercules kernel: [128749.240211] JBD2: I/O error detected when
updating journal superblock for sdb1-8.
May 26 14:30:05 hercules kernel: [128749.262545] usb 3-1.7: USB disconnect,
device number 16
May 26 14:30:05 hercules kernel: [128749.269556] JBD2: I/O error detected when
updating journal superblock for sde1-8.
May 26 14:30:05 hercules kernel: [128749.363281] usb 3-2: USB disconnect,
device number 17
May 26 14:30:10 hercules kernel: [128754.270529] BUG: unable to handle kernel
paging request at 00000001638ca0f8


The "scheduling while atomic" message was shown on the screen, with a short
stack trace ("cpuidle_idle_call / cpu_idle / start_secondary").

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
