From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 15906] serious performance regression in "umount" on ext4 over
 LVM
Date: Wed, 5 May 2010 07:28:17 GMT
Message-ID: <201005050728.o457SHRn012045@demeter.kernel.org>
References: <bug-15906-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:49605 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756983Ab0EEH2S (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 5 May 2010 03:28:18 -0400
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.3/8.14.3) with ESMTP id o457SHlZ012046
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Wed, 5 May 2010 07:28:17 GMT
In-Reply-To: <bug-15906-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=15906


Dmitry Monakhov <dmonakhov@openvz.org> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |dmonakhov@openvz.org




--- Comment #13 from Dmitry Monakhov <dmonakhov@openvz.org>  2010-05-05 07:28:10 ---
Yep. i've already know that issue. In fact it was broken by followng commit

>From 03ba3782e8dcc5b0e1efe440d33084f066e38cae Mon Sep 17 00:00:00 2001          
From: Jens Axboe <jens.axboe@oracle.com>                                        
Date: Wed, 9 Sep 2009 09:08:54 +0200                                            
Subject: [PATCH] writeback: switch to per-bdi threads for flushing data

The problem with __sync_filesystem(0) is no longer works on umount
because sb can not be pined s_mount sem is downed for write and s_root is NULL.

And in fact ext3 is also broken in case of "-obarrier=1"
The patch attached fix the original regression, but there is one more issue
left

A delalloc option. In fact dirty inode is still dirty even after first
call of writeback_single_inode which is called from __sync_filesystem(0)
due to delalloc allocation happen during inode write. So it takes second
__sync_filesystem call to clear dirty flags. Currently i'm working on that
issue. I hope i'll post a solution today.

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
