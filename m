From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 13676] unmount after fsstress on a ramdisk causes orphan inode
 list corruption
Date: Mon, 29 Jun 2009 18:47:50 GMT
Message-ID: <200906291847.n5TIloMR024208@demeter.kernel.org>
References: <bug-13676-13602@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:42982 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752746AbZF2Srr (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 29 Jun 2009 14:47:47 -0400
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.2/8.14.2) with ESMTP id n5TIlo9T024209
	for <linux-ext4@vger.kernel.org>; Mon, 29 Jun 2009 18:47:50 GMT
In-Reply-To: <bug-13676-13602@http.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

http://bugzilla.kernel.org/show_bug.cgi?id=13676


Andrew Morton <akpm@linux-foundation.org> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |akpm@linux-foundation.org
          Component|ext3                        |Block Layer
         AssignedTo|fs_ext3@kernel-bugs.osdl.or |axboe@kernel.dk
                   |g                           |
            Product|File System                 |IO/Storage
         Regression|No                          |Yes




--- Comment #1 from Andrew Morton <akpm@linux-foundation.org>  2009-06-29 18:47:49 ---
More likely to be a ramdisk bug.

<checks>

yup, according to Adrian's report, it happened after the introduction of brd.

<marks as regression, assigns to Nick>

hm, we don't have a category for ramdisk.  I'll make it IO/Storage, Block
layer.

-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
