From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 89511] USB-storage mount error
Date: Thu, 11 Dec 2014 10:00:17 +0000
Message-ID: <bug-89511-13602-TdFf4fDTCD@https.bugzilla.kernel.org/>
References: <bug-89511-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:40069 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932698AbaLKKAW (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 11 Dec 2014 05:00:22 -0500
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 84897201D3
	for <linux-ext4@vger.kernel.org>; Thu, 11 Dec 2014 10:00:21 +0000 (UTC)
Received: from bugzilla2.web.kernel.org (bugzilla2.web.kernel.org [172.20.200.52])
	by mail.kernel.org (Postfix) with ESMTP id 96C3D2018E
	for <linux-ext4@vger.kernel.org>; Thu, 11 Dec 2014 10:00:18 +0000 (UTC)
In-Reply-To: <bug-89511-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=89511

Jan Kara <jack@suse.cz> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |jack@suse.cz

--- Comment #4 from Jan Kara <jack@suse.cz> ---
This doesn't seem to be ext3/4 related. Rather it seems we cannot read the
device for some reason - 3.2.63 complains like:
[   57.418428] end_request: I/O error, dev sdb, sector 0

3.17.4 complains like:
[11378.644515] end_request: critical target error, dev sdb, sector 0

Since the device worked in 3.2.62, it may be USB-storage or SCSI related. Alan
Stern, can you have a look?

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
