From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 89621] EXT4-fs error (device dm-1):
 ext4_mb_release_inode_pa:3773: group 24089, free 34, pa_free 32
Date: Wed, 27 May 2015 10:01:37 +0000
Message-ID: <bug-89621-13602-kPcFxS81W7@https.bugzilla.kernel.org/>
References: <bug-89621-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:58395 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752262AbbE0KBm (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 27 May 2015 06:01:42 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 1224C20647
	for <linux-ext4@vger.kernel.org>; Wed, 27 May 2015 10:01:40 +0000 (UTC)
Received: from bugzilla1.web.kernel.org (bugzilla1.web.kernel.org [172.20.200.51])
	by mail.kernel.org (Postfix) with ESMTP id 6B92B20652
	for <linux-ext4@vger.kernel.org>; Wed, 27 May 2015 10:01:37 +0000 (UTC)
In-Reply-To: <bug-89621-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=89621

--- Comment #10 from Michal Cihar <michal@cihar.com> ---
In my case it is ext4. And I have LVM + RAID 1 on host.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
