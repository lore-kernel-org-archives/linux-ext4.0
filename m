From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 89621] EXT4-fs error (device dm-1):
 ext4_mb_release_inode_pa:3773: group 24089, free 34, pa_free 32
Date: Wed, 27 May 2015 09:53:06 +0000
Message-ID: <bug-89621-13602-lKvJt3cXgc@https.bugzilla.kernel.org/>
References: <bug-89621-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:57647 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750851AbbE0JxJ (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 27 May 2015 05:53:09 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 0EDA520652
	for <linux-ext4@vger.kernel.org>; Wed, 27 May 2015 09:53:08 +0000 (UTC)
Received: from bugzilla1.web.kernel.org (bugzilla1.web.kernel.org [172.20.200.51])
	by mail.kernel.org (Postfix) with ESMTP id 7610120645
	for <linux-ext4@vger.kernel.org>; Wed, 27 May 2015 09:53:06 +0000 (UTC)
In-Reply-To: <bug-89621-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=89621

--- Comment #9 from John Hughes <john@calva.com> ---
So the common factors between Michal's case and mine are:

Debian 3.16.0 kernel running in KVM
Host kernel doing MDADM (Raid 1 for me)

Michal is running LVM on the host, I'm running it on the guest.

Michal, my filesystems are ext3, (now being handled by ext4 subsystem).  Are
yours ext3 or ext4?

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
