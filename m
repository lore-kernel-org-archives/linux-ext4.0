From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 41682] INFO: possible circular locking dependency detected ..
 at ext4_evict_inode
Date: Wed, 24 Aug 2011 21:22:04 GMT
Message-ID: <201108242122.p7OLM4iU004035@demeter1.kernel.org>
References: <bug-41682-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter1.kernel.org ([140.211.167.39]:41113 "EHLO
	demeter1.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752622Ab1HXVWG (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 24 Aug 2011 17:22:06 -0400
Received: from demeter1.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter1.kernel.org (8.14.4/8.14.4) with ESMTP id p7OLM5mI004036
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Wed, 24 Aug 2011 21:22:05 GMT
In-Reply-To: <bug-41682-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=41682





--- Comment #2 from Witold Baryluk <baryluk@smp.if.uj.edu.pl>  2011-08-24 21:22:03 ---
This build is of mainline kernel, and already have this commit

commit c063d8a60fc912ae198f054608ad461a69dc9a19
Merge: 79058c4 dccaf33
Author: Linus Torvalds <torvalds@linux-foundation.org>
Date:   Sun Aug 21 06:59:41 2011 -0700

    Merge branch 'for_linus' of
git://git.kernel.org/pub/scm/linux/kernel/git/tytso/ext4

    * 'for_linus' of git://git.kernel.org/pub/scm/linux/kernel/git/tytso/ext4:
      ext4: flush any pending end_io requests before DIO reads w/dioread_nolock
      ext4: fix nomblk_io_submit option so it correctly converts uninit blocks
      ext4: Resolve the hang of direct i/o read in handling
EXT4_IO_END_UNWRITTEN.
      ext4: call ext4_ioend_wait and ext4_flush_completed_IO in
ext4_evict_inode
      ext4: Fix ext4_should_writeback_data() for no-journal mode


So, it includes

commit 2581fdc810889fdea97689cb62481201d579c796
Author: Jiaying Zhang <jiayingz@google.com>
Date:   Sat Aug 13 12:17:13 2011 -0400

    ext4: call ext4_ioend_wait and ext4_flush_completed_IO in ext4_evict_inode


which should actually remove deadlock.

So probably some other nasty bug was introduced, or my configuration is very
strange (and it is).

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
