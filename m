From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 89511] USB-storage mount error
Date: Sun, 11 Jan 2015 01:29:05 +0000
Message-ID: <bug-89511-13602-CsJPK2BPDE@https.bugzilla.kernel.org/>
References: <bug-89511-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:52207 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751123AbbAKB3L (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 10 Jan 2015 20:29:11 -0500
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 2F986205CB
	for <linux-ext4@vger.kernel.org>; Sun, 11 Jan 2015 01:29:10 +0000 (UTC)
Received: from bugzilla2.web.kernel.org (bugzilla2.web.kernel.org [172.20.200.52])
	by mail.kernel.org (Postfix) with ESMTP id 56D5620585
	for <linux-ext4@vger.kernel.org>; Sun, 11 Jan 2015 01:29:06 +0000 (UTC)
In-Reply-To: <bug-89511-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=89511

--- Comment #48 from Jun Itou <itou_jun@infoseek.jp> ---
Created attachment 163171
  --> https://bugzilla.kernel.org/attachment.cgi?id=163171&action=edit
3.2.62 is bug?

It is as follows in kernel 3.2.62.
Is this bug?

=== uname =====================================================================
root@sv-server:~# uname -a
Linux sv-server 3.2.62 #1 SMP Sun Jan 11 07:43:15 JST 2015 x86_64 GNU/Linux

=== dmesg =====================================================================
[    9.633130] scsi 3:0:0:0: Direct-Access     I-O DATA HDW-UE           0100
PQ: 0 ANSI: 2
[    9.634993] sd 3:0:0:0: Attached scsi generic sg2 type 0
[    9.639479] sd 3:0:0:0: [sdb] 1953546336 512-byte logical blocks: (1.00
TB/931 GiB)
[    9.644845] sd 3:0:0:0: [sdb] Write Protect is off
[    9.644848] sd 3:0:0:0: [sdb] Mode Sense: 53 00 00 08
[    9.650373] sd 3:0:0:0: [sdb] Write cache: enabled, read cache: enabled,
doesn't support DPO or FUA
[    9.681459]  sdb: sdb1
[    9.699713] sd 3:0:0:0: [sdb] Attached SCSI disk

=== cache_type ================================================================
root@sv-server:~# cat /sys/block/sdb/device/scsi_disk/*/cache_type
write back

=== fdisk =====================================================================
root@sv-server:~# fdisk /dev/sdb
  -- omission --
Calling ioctl() to re-read partition table.
Syncing disks.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
