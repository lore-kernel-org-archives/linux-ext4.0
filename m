From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 102731] I have a cough.
Date: Wed, 12 Aug 2015 08:56:30 +0000
Message-ID: <bug-102731-13602-Zx09QZYrzv@https.bugzilla.kernel.org/>
References: <bug-102731-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:57065 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753902AbbHLI4d (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 12 Aug 2015 04:56:33 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 883DF20713
	for <linux-ext4@vger.kernel.org>; Wed, 12 Aug 2015 08:56:32 +0000 (UTC)
Received: from bugzilla1.web.kernel.org (bugzilla1.web.kernel.org [172.20.200.51])
	by mail.kernel.org (Postfix) with ESMTP id DC4DF2070D
	for <linux-ext4@vger.kernel.org>; Wed, 12 Aug 2015 08:56:30 +0000 (UTC)
In-Reply-To: <bug-102731-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=102731

--- Comment #1 from John Hughes <john@calva.com> ---
The hardware:

A couple of Dell PowerEdge 840's (Xeon 3050, 4G).

disks SATA internal and SCSI in external cabinets

Host OS Debian 7.7 kernel 3.16, version  3.16.5-1~bpo70+1

Disks assembled into RAID1 arrays then passed to kvm guest as virtio.

Guest OS Debian 7.7, kernel either as host, or now 3.18.19

Guest uses LVM2

All filesystems on guest are ext3, now handled by ext4 subsystem.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
