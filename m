From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 16380] ext2/ext4 filesystem "hangs" for a few seconds when
 trying to write a lot of data to a freshly RW mounted FS
Date: Sat,  4 Aug 2012 19:51:51 +0000 (UTC)
Message-ID: <20120804195151.98BC111FC62@bugzilla.kernel.org>
References: <bug-16380-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:47329 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753390Ab2HDTv4 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 4 Aug 2012 15:51:56 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 803CC20211
	for <linux-ext4@vger.kernel.org>; Sat,  4 Aug 2012 19:51:55 +0000 (UTC)
Received: from bugzilla.kernel.org (unknown [198.145.19.217])
	by mail.kernel.org (Postfix) with ESMTP id 7A8C8201F6
	for <linux-ext4@vger.kernel.org>; Sat,  4 Aug 2012 19:51:53 +0000 (UTC)
In-Reply-To: <bug-16380-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=16380





--- Comment #15 from Theodore Tso <tytso@mit.edu>  2012-08-04 19:51:51 ---
The delay before the write starts is normal; that's encoded in how the
writeback code handles dirty pages.  We don't start writes the instant that
pages are dirtied in the buffer cache.

In any case, if you have arguments about how the writeback code makes its
choices, it's kinda of pointless to be complaining on a bug targetted at the
ext4 developers, since we start the writeback when the VM system asks us to
start write pages belonging to a particular inode....

See /usr/src/linux/Documentation/sysctl/vm.txt for more information.

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
