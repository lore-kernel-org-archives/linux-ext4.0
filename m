From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 89621] EXT4-fs error (device dm-1):
 ext4_mb_release_inode_pa:3773: group 24089, free 34, pa_free 32
Date: Sat, 13 Dec 2014 03:36:07 +0000
Message-ID: <bug-89621-13602-R1xQUFGmsf@https.bugzilla.kernel.org/>
References: <bug-89621-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:33209 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964843AbaLMDgL (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 12 Dec 2014 22:36:11 -0500
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 165CE20204
	for <linux-ext4@vger.kernel.org>; Sat, 13 Dec 2014 03:36:10 +0000 (UTC)
Received: from bugzilla2.web.kernel.org (bugzilla2.web.kernel.org [172.20.200.52])
	by mail.kernel.org (Postfix) with ESMTP id B6C7720211
	for <linux-ext4@vger.kernel.org>; Sat, 13 Dec 2014 03:36:07 +0000 (UTC)
In-Reply-To: <bug-89621-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=89621

Theodore Tso <tytso@mit.edu> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |tytso@mit.edu

--- Comment #1 from Theodore Tso <tytso@mit.edu> ---
This error just means there is an inconsistency between the number of free
blocks in the bitmap and the number of blocks reported in the block group
descriptors.  So the errors reported by fsck could be consistent with what you
are seeing.

This might be fixed by d89b2f764e9f9eb6c1ac90d25e6fc5b43b676a48.   It's a bit
painful because I'm not sure what is included in 3.16-0.bpo.2-amd64.   You need
to ask the Debian kernel distro folks that question.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
