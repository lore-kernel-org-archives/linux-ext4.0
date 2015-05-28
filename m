From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 89621] EXT4-fs error (device dm-1):
 ext4_mb_release_inode_pa:3773: group 24089, free 34, pa_free 32
Date: Thu, 28 May 2015 10:35:19 +0000
Message-ID: <bug-89621-13602-urca3PJWl1@https.bugzilla.kernel.org/>
References: <bug-89621-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:48659 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751548AbbE1KfW (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 28 May 2015 06:35:22 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 905E22065E
	for <linux-ext4@vger.kernel.org>; Thu, 28 May 2015 10:35:21 +0000 (UTC)
Received: from bugzilla1.web.kernel.org (bugzilla1.web.kernel.org [172.20.200.51])
	by mail.kernel.org (Postfix) with ESMTP id E3F5D20644
	for <linux-ext4@vger.kernel.org>; Thu, 28 May 2015 10:35:19 +0000 (UTC)
In-Reply-To: <bug-89621-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=89621

--- Comment #14 from John Hughes <john@calva.com> ---
And for me its:

Linux olympic 3.16.0-0.bpo.4-amd64 #1 SMP Debian 3.16.7-ckt7-1~bpo70+1
(2015-04-07) x86_64 GNU/Linux

The last but one backported version for oldstable.  I can update to
3.16.7-ckt9...

(What a horrid name)

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
