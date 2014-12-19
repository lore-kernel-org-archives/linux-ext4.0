From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 89511] USB-storage mount error
Date: Fri, 19 Dec 2014 08:48:10 +0000
Message-ID: <bug-89511-13602-fWuXQb8CdR@https.bugzilla.kernel.org/>
References: <bug-89511-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:42914 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751243AbaLSIsO (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 19 Dec 2014 03:48:14 -0500
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 174372014A
	for <linux-ext4@vger.kernel.org>; Fri, 19 Dec 2014 08:48:13 +0000 (UTC)
Received: from bugzilla1.web.kernel.org (bugzilla1.web.kernel.org [172.20.200.51])
	by mail.kernel.org (Postfix) with ESMTP id 2C3CD20131
	for <linux-ext4@vger.kernel.org>; Fri, 19 Dec 2014 08:48:11 +0000 (UTC)
In-Reply-To: <bug-89511-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=89511

--- Comment #13 from Jun Itou <itou_jun@infoseek.jp> ---
root@sv-server:~# dmesg
[  645.276542] usb 1-1: new high-speed USB device number 2 using ehci_hcd
[  645.796524] usb 1-1: New USB device found, idVendor=04bb, idProduct=0109
[  645.796527] usb 1-1: New USB device strings: Mfr=1, Product=2,
SerialNumber=3
[  645.796529] usb 1-1: Product: I-O DATA HDZ-UES
[  645.796531] usb 1-1: Manufacturer: I-O DATA DEVICE INC.
[  645.796532] usb 1-1: SerialNumber: 0000000042A4
[  645.882473] Initializing USB Mass Storage driver...
[  645.883167] scsi3 : usb-storage 1-1:1.0
[  645.883322] usbcore: registered new interface driver usb-storage
[  645.883324] USB Mass Storage support registered.
[  646.884168] scsi 3:0:0:0: Direct-Access     I-O DATA HDZ-UE1.0TS      6706
PQ: 0 ANSI: 0 CCS
[  646.887386] sd 3:0:0:0: Attached scsi generic sg2 type 0
[  646.889095] sd 3:0:0:0: [sdb] 1953588672 512-byte logical blocks: (1.00
TB/931 GiB)
[  646.894571] sd 3:0:0:0: [sdb] Write Protect is off
[  646.894573] sd 3:0:0:0: [sdb] Mode Sense: 34 00 00 00
[  646.900113] sd 3:0:0:0: [sdb] Write cache: enabled, read cache: enabled,
doesn't support DPO or FUA
[  646.930078]  sdb: sdb1
[  646.955000] sd 3:0:0:0: [sdb] Attached SCSI disk
[  662.278480] EXT4-fs warning (device sdb1): ext4_clear_journal_err:4372:
Filesystem error recorded from previous mount: IO failure
[  662.278483] EXT4-fs warning (device sdb1): ext4_clear_journal_err:4373:
Marking fs in need of filesystem check.
[  662.282419] EXT4-fs (sdb1): warning: mounting fs with errors, running e2fsck
is recommended
[  662.338997] EXT4-fs (sdb1): recovery complete
[  662.340632] EXT4-fs (sdb1): mounted filesystem with ordered data mode. Opts:
(null)
[  663.594301] end_request: I/O error, dev sdb, sector 0
[  669.228566] end_request: I/O error, dev sdb, sector 973342744
[  669.228815] Aborting journal on device sdb1-8.
[  669.291432] EXT4-fs error (device sdb1): ext4_journal_start_sb:327: Detected
aborted journal
[  669.291752] EXT4-fs (sdb1): Remounting filesystem read-only
[  962.263034] EXT4-fs (sdb1): error count since last fsck: 5
[  962.263041] EXT4-fs (sdb1): initial error at time 1418959480:
ext4_journal_check_start:56
[  962.263044] EXT4-fs (sdb1): last error at time 1418971964:
ext4_journal_start_sb:327
[ 6265.348470] EXT4-fs error (device sdb1): ext4_put_super:819: Couldn't clean
up the journal
[ 6268.951780] EXT4-fs warning (device sdb1): ext4_clear_journal_err:4372:
Filesystem error recorded from previous mount: IO failure
[ 6268.951784] EXT4-fs warning (device sdb1): ext4_clear_journal_err:4373:
Marking fs in need of filesystem check.
[ 6268.957163] EXT4-fs (sdb1): warning: mounting fs with errors, running e2fsck
is recommended
[ 6269.014756] EXT4-fs (sdb1): recovery complete
[ 6269.016237] EXT4-fs (sdb1): mounted filesystem with ordered data mode. Opts:
(null)
[ 6293.840536] EXT4-fs (sdb1): warning: mounting fs with errors, running e2fsck
is recommended
[ 6293.896660] EXT4-fs (sdb1): mounted filesystem with ordered data mode. Opts:
(null)
[ 6297.609729] end_request: I/O error, dev sdb, sector 0
[ 6298.054636] end_request: I/O error, dev sdb, sector 973342744
[ 6298.054851] Aborting journal on device sdb1-8.
[ 6298.057033] journal commit I/O error
[ 6298.060325] EXT4-fs error (device sdb1): ext4_put_super:819: Couldn't clean
up the journal
[ 6298.060622] EXT4-fs (sdb1): Remounting filesystem read-only
[ 6384.756358] EXT4-fs warning (device sdb1): ext4_clear_journal_err:4372:
Filesystem error recorded from previous mount: IO failure
[ 6384.756592] EXT4-fs warning (device sdb1): ext4_clear_journal_err:4373:
Marking fs in need of filesystem check.
[ 6384.764453] EXT4-fs (sdb1): warning: mounting fs with errors, running e2fsck
is recommended
[ 6384.836288] EXT4-fs (sdb1): recovery complete
[ 6384.839274] EXT4-fs (sdb1): mounted filesystem with ordered data mode. Opts:
(null)
[ 6388.604514] end_request: I/O error, dev sdb, sector 0
[ 6390.380935] end_request: I/O error, dev sdb, sector 973342744
[ 6390.381126] Aborting journal on device sdb1-8.
[ 6390.384914] journal commit I/O error
[ 6390.388592] EXT4-fs error (device sdb1): ext4_put_super:819: Couldn't clean
up the journal
[ 6390.388595] EXT4-fs (sdb1): Remounting filesystem read-only

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
