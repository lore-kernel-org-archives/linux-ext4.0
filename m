From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 99051] general protection fault in ext4_htree_store_dirent
Date: Wed, 27 May 2015 23:08:32 +0000
Message-ID: <bug-99051-13602-AfeSvZgdES@https.bugzilla.kernel.org/>
References: <bug-99051-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:50235 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752310AbbE0XIf (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 27 May 2015 19:08:35 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 4F77C20701
	for <linux-ext4@vger.kernel.org>; Wed, 27 May 2015 23:08:34 +0000 (UTC)
Received: from bugzilla1.web.kernel.org (bugzilla1.web.kernel.org [172.20.200.51])
	by mail.kernel.org (Postfix) with ESMTP id DBCBF206F6
	for <linux-ext4@vger.kernel.org>; Wed, 27 May 2015 23:08:32 +0000 (UTC)
In-Reply-To: <bug-99051-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=99051

Theodore Tso <tytso@mit.edu> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |tytso@mit.edu

--- Comment #1 from Theodore Tso <tytso@mit.edu> ---
The failure is inside kmalloc(), which implies that the internal slab data
structures were corrupted (i.e., caused by a double free, buffer overrun,
etc.).  So the bug might not be in ext4 --- it's just that ext4 happened to
trip over the corrupted data structures.

Can you reproduce the crash at all?

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
