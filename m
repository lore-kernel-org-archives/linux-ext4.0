From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 89621] EXT4-fs error (device dm-1):
 ext4_mb_release_inode_pa:3773: group 24089, free 34, pa_free 32
Date: Mon, 15 Dec 2014 22:27:11 +0000
Message-ID: <bug-89621-13602-6bAKC50yCt@https.bugzilla.kernel.org/>
References: <bug-89621-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:55333 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750892AbaLOW1N (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 15 Dec 2014 17:27:13 -0500
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id D5D3F209EB
	for <linux-ext4@vger.kernel.org>; Mon, 15 Dec 2014 22:27:12 +0000 (UTC)
Received: from bugzilla1.web.kernel.org (bugzilla1.web.kernel.org [172.20.200.51])
	by mail.kernel.org (Postfix) with ESMTP id 777AD20A01
	for <linux-ext4@vger.kernel.org>; Mon, 15 Dec 2014 22:27:11 +0000 (UTC)
In-Reply-To: <bug-89621-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=89621

--- Comment #5 from Theodore Tso <tytso@mit.edu> ---
Yes, barriers are enabled by default, and with cache=none, the flush commands
*should* be sent down to the host device.   It might be worth doing a quick
blktrace to make sure the host device is getting the cache flushes and they
aren't getting dropped by qemu or by mdraid, but the configuration at least
looks sane.

In the cases where you've seen the problem, have there been any sense where
either (a) the host has suffered a crash or shutdown or power drop, or (b) the
guest VM has been abruptly shutdown or killed without triggering a normal guest
OS shutdown?

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
