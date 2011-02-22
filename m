From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 29662] System freeze while rsyncing whole system from ext4 to
 ext4 via USB 2.0
Date: Tue, 22 Feb 2011 13:50:49 GMT
Message-ID: <201102221350.p1MDonSt005463@demeter2.kernel.org>
References: <bug-29662-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter2.kernel.org ([140.211.167.42]:49092 "EHLO
	demeter2.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752826Ab1BVNuu (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 22 Feb 2011 08:50:50 -0500
Received: from demeter2.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter2.kernel.org (8.14.4/8.14.3) with ESMTP id p1MDonRo005494
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Tue, 22 Feb 2011 13:50:49 GMT
In-Reply-To: <bug-29662-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=29662





--- Comment #1 from Marc <marc@osknowledge.org>  2011-02-22 13:50:47 ---
Please advise how to test again/what info is required. Logs are 'empty' besides
this:

=== 2.6.38-rc6
Feb 22 08:32:36 marc kernel: [   41.527852] ADDRCONF(NETDEV_CHANGE): wlan0:
link becomes ready
Feb 22 08:32:46 marc kernel: [   52.104662] wlan0: no IPv6 routers present
Feb 22 08:33:33 marc kernel: [   99.008401] fuse init (API version 7.16)
Feb 22 08:42:34 marc kernel: [  638.643602] usb 2-1.1: new high speed USB
device using ehci_hcd and address 5
Feb 22 08:42:35 marc kernel: [  638.732119] usb 2-1.1: New USB device found,
idVendor=04cf, idProduct=8818
Feb 22 08:42:35 marc kernel: [  638.732125] usb 2-1.1: New USB device strings:
Mfr=1, Product=2, SerialNumber=3
Feb 22 08:42:35 marc kernel: [  638.732130] usb 2-1.1: Product: USB Mass
Storage Device
Feb 22 08:42:35 marc kernel: [  638.732133] usb 2-1.1: Manufacturer: Myson
Century, Inc.
Feb 22 08:42:35 marc kernel: [  638.732137] usb 2-1.1: SerialNumber: 100
Feb 22 08:42:35 marc kernel: [  638.733036] scsi6 : usb-storage 2-1.1:1.0
Feb 22 08:42:36 marc kernel: [  639.733360] scsi 6:0:0:0: Direct-Access    
SAMSUNG  HM160HC          LQ10 PQ: 0 ANSI: 0 CCS
Feb 22 08:42:36 marc kernel: [  639.734122] sd 6:0:0:0: [sdb] 312581808
512-byte logical blocks: (160 GB/149 GiB)
Feb 22 08:42:36 marc kernel: [  639.734586] sd 6:0:0:0: [sdb] Write Protect is
off
Feb 22 08:42:36 marc kernel: [  639.734592] sd 6:0:0:0: [sdb] Mode Sense: 00 14
00 00
Feb 22 08:42:36 marc kernel: [  639.735484] sd 6:0:0:0: [sdb] Write cache:
enabled, read cache: enabled, doesn't support DPO or FUA
Feb 22 08:42:36 marc kernel: [  639.793900]  sdb: sdb1
Feb 22 08:42:36 marc kernel: [  639.796339] sd 6:0:0:0: [sdb] Attached SCSI
disk
Feb 22 08:42:40 marc kernel: [  644.366257] EXT4-fs (sdb1): mounted filesystem
with ordered data mode. Opts: (null)

... rsync no ran for ~ 10 minutes ...

=== hang + acpid shutdown

=== reboot into stable again immediately

Feb 22 09:06:06 marc kernel: [    0.000000] Linux version 2.6.37-ck2-dezzy
(marc@marc) (gcc version 4.5.2 (Gentoo 4.5.2 p1.0) ) #1 SMP PREEMPT Mon Feb 14
06:05:25 CET 2011
Feb 22 09:06:06 marc kernel: [    0.000000] BIOS-provided physical RAM map:

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
