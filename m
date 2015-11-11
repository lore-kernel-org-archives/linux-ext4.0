From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 107301] system hang during ext4 xattr operation
Date: Wed, 11 Nov 2015 02:37:59 +0000
Message-ID: <bug-107301-13602-p54vYtFXdo@https.bugzilla.kernel.org/>
References: <bug-107301-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:57223 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751519AbbKKCiG (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 10 Nov 2015 21:38:06 -0500
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id D2B76207AA
	for <linux-ext4@vger.kernel.org>; Wed, 11 Nov 2015 02:38:03 +0000 (UTC)
Received: from bugzilla1.web.kernel.org (bugzilla1.web.kernel.org [172.20.200.51])
	by mail.kernel.org (Postfix) with ESMTP id A8A5920793
	for <linux-ext4@vger.kernel.org>; Wed, 11 Nov 2015 02:37:59 +0000 (UTC)
In-Reply-To: <bug-107301-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=107301

--- Comment #14 from Theodore Tso <tytso@mit.edu> ---
In response to Jan's concerns in comment #11, I wonder if we can use some
hueristics to decide when to use mbcache and when to skip it.   So if there are
ways that we can identify certain xattr's by name or type as being almost
always unique, then if there are any of those xattrs in the external xattr
block, there's no point using the mbcache.   If we had such a function, we
could also use it to bias putting the unique xattrs in the extended inode
space, which might increase the chance that the external xattr block is more
likely to be shareable.

The final thing I'll note is that because of the mbcache locking, it can turn
into a real scalability bottlencheck for ext4, and it's not clear this is a
soluble problem.   So if you are running on a high-CPU count machine, and you
are using xattrs, and (for example) the SELinux xattr is so piggy that it won't
fit in your 256-byte inodes, things can get pretty painful.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
