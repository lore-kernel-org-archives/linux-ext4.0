From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 109331] EXT4-fs (sda1): couldn't mount as ext3 due to feature
 incompatibilities
Date: Tue, 15 Dec 2015 00:51:53 +0000
Message-ID: <bug-109331-13602-8LFPW8zBrG@https.bugzilla.kernel.org/>
References: <bug-109331-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:47366 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752729AbbLOAv5 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 14 Dec 2015 19:51:57 -0500
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id D2D0F20304
	for <linux-ext4@vger.kernel.org>; Tue, 15 Dec 2015 00:51:55 +0000 (UTC)
Received: from bugzilla2.web.kernel.org (bugzilla2.web.kernel.org [172.20.200.52])
	by mail.kernel.org (Postfix) with ESMTP id 437B620374
	for <linux-ext4@vger.kernel.org>; Tue, 15 Dec 2015 00:51:54 +0000 (UTC)
In-Reply-To: <bug-109331-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=109331

Theodore Tso <tytso@mit.edu> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
           Priority|P1                          |P3
                 CC|                            |tytso@mit.edu

--- Comment #5 from Theodore Tso <tytso@mit.edu> ---
The kernel's low-level boot path tries each file system --- and the problem is
that ext4 doesn't know whether this is part of the boot process mounting the
root file system, or the user explicitly trying to mount a file system as ext3.

When we dropped support for ext3 in recent kernels, CONFIG_EXT4_USE_FOR_EXT23
was renamed CONFIG_EXT4_USE_FOR_EXT2 and the ext3 bug-for-bug backwards
compatibility support was unconditionally included.   It was just a side effect
of how ext3 code was removed from the Linux kernel, and given that most
distributions would never explicitly want to remove ext3 support entirely lest
it break users' configs (i.e., so very, VERY few people compile kernels with
!CONFIG_EXT2_FS, !CONFIG_EXT3_FS, and !CONFIG_EXT4_USE_FOR_EXT23) no one really
noticed or cared.

We can "fix" this by either changing CONFIG_EXT4_USE_FOR_EXT2 back to
CONFIG_EXT4_USE_FOR_EXT23, which would support !ext2, !ext3compat, ext4, but
not allow ext2, !ext3co,pat, or ext4.   Or by adding a new Kconfig for
EXT4_USE_FOR_EXT3 that would explicitly turn on/off just the ext3 compatibility
code.

Personally, I don't really care enough to implement this, but if someone wants
to try their hand at a relatively simple kernel patch, please give it a try.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
