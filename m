From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 16380] ext2/ext4 filesystem "hangs" for a few seconds when
 trying to write a lot of data to a freshly RW mounted FS
Date: Sat,  4 Aug 2012 20:00:28 +0000 (UTC)
Message-ID: <20120804200028.9235611FC62@bugzilla.kernel.org>
References: <bug-16380-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:47503 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752604Ab2HDUAb (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 4 Aug 2012 16:00:31 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id BCAF120213
	for <linux-ext4@vger.kernel.org>; Sat,  4 Aug 2012 20:00:30 +0000 (UTC)
Received: from bugzilla.kernel.org (unknown [198.145.19.217])
	by mail.kernel.org (Postfix) with ESMTP id E2DCB201FA
	for <linux-ext4@vger.kernel.org>; Sat,  4 Aug 2012 20:00:28 +0000 (UTC)
In-Reply-To: <bug-16380-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=16380


Artem S. Tashkinov <t.artem@mailcity.com> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
             Status|NEW                         |RESOLVED
         Resolution|                            |INVALID




--- Comment #16 from Artem S. Tashkinov <t.artem@mailcity.com>  2012-08-04 20:00:28 ---
(In reply to comment #15)
> The delay before the write starts is normal; that's encoded in how the
> writeback code handles dirty pages.  We don't start writes the instant that
> pages are dirtied in the buffer cache.
> 
> In any case, if you have arguments about how the writeback code makes its
> choices, it's kinda of pointless to be complaining on a bug targetted at the
> ext4 developers, since we start the writeback when the VM system asks us to
> start write pages belonging to a particular inode....
> 
> See /usr/src/linux/Documentation/sysctl/vm.txt for more information.

Thanks for letting us know, probably what I perceived as a regression in ext4fs
was in fact a change in the VM writeback code.

It's still weird and terribly counter intuitive as no other OS exhibit this
behavior, but now that I know why it happens I need to file a different bug
report.

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
