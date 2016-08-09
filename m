From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 151491] free space lossage on busy system with bigalloc enabled
 and 128KB cluster
Date: Tue, 09 Aug 2016 18:28:31 +0000
Message-ID: <bug-151491-13602-cKK42gTe9s@https.bugzilla.kernel.org/>
References: <bug-151491-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:47666 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932257AbcHIS2e (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 9 Aug 2016 14:28:34 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 41CAE2024D
	for <linux-ext4@vger.kernel.org>; Tue,  9 Aug 2016 18:28:33 +0000 (UTC)
Received: from bugzilla2.web.kernel.org (bugzilla2.web.kernel.org [172.20.200.52])
	by mail.kernel.org (Postfix) with ESMTP id B635D20263
	for <linux-ext4@vger.kernel.org>; Tue,  9 Aug 2016 18:28:31 +0000 (UTC)
In-Reply-To: <bug-151491-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=151491

--- Comment #3 from Matthew L. Martin <mlmartin@clearsky-data.com> ---
Unfortunately, after an extended run of the test scripts the fault presented
itself in the 4.7 kernel:

[root@d-ceph01 ~]# df -h /mnt/hdd_sd[gh]; du -hs  /mnt/hdd_sd[gh]
Filesystem      Size  Used Avail Use% Mounted on
/dev/sdg        5.5T  669G  4.8T  13% /mnt/hdd_sdg
/dev/sdh        5.5T   20G  5.4T   1% /mnt/hdd_sdh
20G    /mnt/hdd_sdg
20G    /mnt/hdd_sdh

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
