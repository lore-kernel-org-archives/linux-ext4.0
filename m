From: bugme-daemon@bugzilla.kernel.org
Subject: [Bug 12815] JBD: barrier-based sync failed on dm-1:8 - disabling barriers  -- and then hang
Date: Sat,  7 Mar 2009 09:08:17 -0800 (PST)
Message-ID: <20090307170817.47E8C108042@picon.linux-foundation.org>
References: <bug-12815-13602@http.bugzilla.kernel.org/>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35759 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751161AbZCGRIU (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 7 Mar 2009 12:08:20 -0500
Received: from picon.linux-foundation.org (picon.linux-foundation.org [140.211.169.79])
	by smtp1.linux-foundation.org (8.14.2/8.13.5/Debian-3ubuntu1.1) with ESMTP id n27H8HTq029592
	for <linux-ext4@vger.kernel.org>; Sat, 7 Mar 2009 09:08:18 -0800
In-Reply-To: <bug-12815-13602@http.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

http://bugzilla.kernel.org/show_bug.cgi?id=12815





------- Comment #6 from joey@kitenet.net  2009-03-07 09:08 -------
I added barrier=0 and did not see the problem again until today. W/o JBD
messages, so that was a red herring. This time there was nothing special in
dmesg.

sysrq shows the following. This is not all the hung processes, but should be
representative:

Mar  7 12:00:54 turtle kernel: [82352.940000] sh            D c0213428     0
21596  21594
Mar  7 12:00:54 turtle kernel: [82352.940000] [<c02130b4>] (schedule+0x0/0x3d0)
from [<c0213b94>] (__mutex_lock_slowpath+0x6c/0x98)
Mar  7 12:00:54 turtle kernel: [82352.940000] [<c0213b28>]
(__mutex_lock_slowpath+0x0/0x98) from [<c0213be0>] (mutex_lock+0x20/0x24)
Mar  7 12:00:54 turtle kernel: [82352.940000]  r8:c76d379c r7:c223de98
r6:c76d3728 r5:c7685d98 r4:00000000
Mar  7 12:00:54 turtle kernel: [82352.940000] [<c0213bc0>]
(mutex_lock+0x0/0x24) from [<c009e41c>] (do_lookup+0x78/0x194)
Mar  7 12:00:54 turtle kernel: [82352.940000] [<c009e3a4>]
(do_lookup+0x0/0x194) from [<c00a0198>] (__link_path_walk+0x3ac/0xe24)
Mar  7 12:00:54 turtle kernel: [82352.940000] [<c009fdec>]
(__link_path_walk+0x0/0xe24) from [<c00a0d98>] (path_walk+0x50/0xa0)
Mar  7 12:00:54 turtle kernel: [82352.940000] [<c00a0d48>] (path_walk+0x0/0xa0)
from [<c00a0edc>] (do_path_lookup+0xf4/0x11c)
Mar  7 12:00:54 turtle kernel: [82352.940000]  r6:ffffff9c r5:c223de98
r4:00000001
Mar  7 12:00:54 turtle kernel: [82352.940000] [<c00a0de8>]
(do_path_lookup+0x0/0x11c) from [<c00a198c>] (user_path_at+0x5c/0x9c)
Mar  7 12:00:54 turtle kernel: [82352.940000]  r7:c223df08 r6:ffffff9c
r5:00000001 r4:c68d9000
Mar  7 12:00:54 turtle kernel: [82352.940000] [<c00a1930>]
(user_path_at+0x0/0x9c) from [<c009a354>] (vfs_stat_fd+0x24/0x54)
Mar  7 12:00:54 turtle kernel: [82352.940000]  r7:000000c3 r6:c223df08
r5:c223df40 r4:bed3da18
Mar  7 12:00:54 turtle kernel: [82352.940000] [<c009a330>]
(vfs_stat_fd+0x0/0x54) from [<c009a438>] (vfs_stat+0x1c/0x20)
Mar  7 12:00:54 turtle kernel: [82352.940000]  r6:000c5668 r5:c223df40
r4:bed3da18
Mar  7 12:00:54 turtle kernel: [82352.940000] [<c009a41c>] (vfs_stat+0x0/0x20)
from [<c009a45c>] (sys_stat64+0x20/0x3c)
Mar  7 12:00:54 turtle kernel: [82352.940000] [<c009a43c>]
(sys_stat64+0x0/0x3c) from [<c0025e00>] (ret_fast_syscall+0x0/0x3c)
Mar  7 12:00:54 turtle kernel: [82352.940000]  r5:000bd6f8 r4:000c5668
Mar  7 12:00:54 turtle kernel: [82352.940000] sh            D c0213428     0
22291  22289
Mar  7 12:00:54 turtle kernel: [82352.940000] [<c02130b4>] (schedule+0x0/0x3d0)
from [<c0213b94>] (__mutex_lock_slowpath+0x6c/0x98)
Mar  7 12:00:54 turtle kernel: [82352.940000] [<c0213b28>]
(__mutex_lock_slowpath+0x0/0x98) from [<c0213be0>] (mutex_lock+0x20/0x24)
Mar  7 12:00:54 turtle kernel: [82352.940000]  r8:c76d379c r7:c4079e98
r6:c76d3728 r5:c7685d98 r4:00000000
Mar  7 12:00:54 turtle kernel: [82352.940000] [<c0213bc0>]
(mutex_lock+0x0/0x24) from [<c009e41c>] (do_lookup+0x78/0x194)
Mar  7 12:00:54 turtle kernel: [82352.940000] [<c009e3a4>]
(do_lookup+0x0/0x194) from [<c00a0198>] (__link_path_walk+0x3ac/0xe24)
Mar  7 12:00:54 turtle kernel: [82352.940000] [<c009fdec>]
(__link_path_walk+0x0/0xe24) from [<c00a0d98>] (path_walk+0x50/0xa0)
Mar  7 12:00:54 turtle kernel: [82352.940000] [<c00a0d48>] (path_walk+0x0/0xa0)
from [<c00a0edc>] (do_path_lookup+0xf4/0x11c)
Mar  7 12:00:54 turtle kernel: [82352.940000]  r6:ffffff9c r5:c4079e98
r4:00000001
Mar  7 12:00:54 turtle kernel: [82352.940000] [<c00a0de8>]
(do_path_lookup+0x0/0x11c) from [<c00a198c>] (user_path_at+0x5c/0x9c)
Mar  7 12:00:54 turtle kernel: [82352.940000]  r7:c4079f08 r6:ffffff9c
r5:00000001 r4:c6841000
Mar  7 12:00:54 turtle kernel: [82352.940000] [<c00a1930>]
(user_path_at+0x0/0x9c) from [<c009a354>] (vfs_stat_fd+0x24/0x54)
Mar  7 12:00:54 turtle kernel: [82352.940000]  r7:000000c3 r6:c4079f08
r5:c4079f40 r4:be967a18
Mar  7 12:00:54 turtle kernel: [82352.940000] [<c009a330>]
(vfs_stat_fd+0x0/0x54) from [<c009a438>] (vfs_stat+0x1c/0x20)
Mar  7 12:00:54 turtle kernel: [82352.940000]  r6:000c5668 r5:c4079f40
r4:be967a18
Mar  7 12:00:54 turtle kernel: [82352.940000] [<c009a41c>] (vfs_stat+0x0/0x20)
from [<c009a45c>] (sys_stat64+0x20/0x3c)
Mar  7 12:00:54 turtle kernel: [82352.940000] [<c009a43c>]
(sys_stat64+0x0/0x3c) from [<c0025e00>] (ret_fast_syscall+0x0/0x3c)
Mar  7 12:00:54 turtle kernel: [82352.940000]  r5:000bd6f8 r4:000c5668
Mar  7 12:00:54 turtle kernel: [82352.940000] sh            D c0213428     0
24027  24025


-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug, or are watching the assignee.
