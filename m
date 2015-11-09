From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 107301] system hang during ext4 xattr operation
Date: Mon, 09 Nov 2015 15:22:23 +0000
Message-ID: <bug-107301-13602-niulSHtxBU@https.bugzilla.kernel.org/>
References: <bug-107301-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:40170 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751339AbbKIPW2 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 9 Nov 2015 10:22:28 -0500
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id F4075205B8
	for <linux-ext4@vger.kernel.org>; Mon,  9 Nov 2015 15:22:26 +0000 (UTC)
Received: from bugzilla2.web.kernel.org (bugzilla2.web.kernel.org [172.20.200.52])
	by mail.kernel.org (Postfix) with ESMTP id 0D1DE20621
	for <linux-ext4@vger.kernel.org>; Mon,  9 Nov 2015 15:22:24 +0000 (UTC)
In-Reply-To: <bug-107301-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=107301

--- Comment #11 from Jan Kara <jack@suse.cz> ---
Actually if most of inodes have xattrs like this, then the biggest win would
probably be to create filesystem with 512-byte inodes where the ~270-byte xattr
will fit into the inode as well. Then you save on extra block lookup etc.

WRT disabling mbcache, it seems disabling it would really help your usecase.
However I'm not a big fan of mount options for disabling/enabling various
functionality in the filesystem as it blows up a test matrix and tends to be a
usability issue as well (people don't know the option or don't know when to
enable / disable it). So I'd prefer if we just fixed mbcache...

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
