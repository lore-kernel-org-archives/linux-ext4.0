From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 89621] EXT4-fs error (device dm-1):
 ext4_mb_release_inode_pa:3773: group 24089, free 34, pa_free 32
Date: Thu, 28 May 2015 01:22:48 +0000
Message-ID: <bug-89621-13602-Gk6HE9Q5Js@https.bugzilla.kernel.org/>
References: <bug-89621-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:55377 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751398AbbE1BWw (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 27 May 2015 21:22:52 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 4E7F32046F
	for <linux-ext4@vger.kernel.org>; Thu, 28 May 2015 01:22:51 +0000 (UTC)
Received: from bugzilla2.web.kernel.org (bugzilla2.web.kernel.org [172.20.200.52])
	by mail.kernel.org (Postfix) with ESMTP id A151D20738
	for <linux-ext4@vger.kernel.org>; Thu, 28 May 2015 01:22:49 +0000 (UTC)
In-Reply-To: <bug-89621-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=89621

--- Comment #12 from Theodore Tso <tytso@mit.edu> ---
Ah, never mind; the "debian 3.16.0" kernel is actually based on 3.16.7-ckt9 --
at least, the latest version of debian 3.16.0.   You'd have to specify exactly
what version of the "debian 3.16.0" kernel to know for sure.   (But this is why
many upstream kernel developers don't try to support distro kernels.  It's hard
to see what commits might or might not be in a particular kernel distro.)

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
