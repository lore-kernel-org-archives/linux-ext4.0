From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 89621] EXT4-fs error (device dm-1):
 ext4_mb_release_inode_pa:3773: group 24089, free 34, pa_free 32
Date: Wed, 12 Aug 2015 09:12:21 +0000
Message-ID: <bug-89621-13602-19oTjr1Hkw@https.bugzilla.kernel.org/>
References: <bug-89621-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:59195 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932885AbbHLJMY (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 12 Aug 2015 05:12:24 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 68CC02071A
	for <linux-ext4@vger.kernel.org>; Wed, 12 Aug 2015 09:12:23 +0000 (UTC)
Received: from bugzilla2.web.kernel.org (bugzilla2.web.kernel.org [172.20.200.52])
	by mail.kernel.org (Postfix) with ESMTP id 358C320715
	for <linux-ext4@vger.kernel.org>; Wed, 12 Aug 2015 09:12:22 +0000 (UTC)
In-Reply-To: <bug-89621-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=89621

John Hughes <john@calva.com> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
         Regression|No                          |Yes

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
