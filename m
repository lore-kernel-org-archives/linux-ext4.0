From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 27912] Set 'err' in ext4_init_fs() if kset_create_and_add()
 fails
Date: Mon, 15 Oct 2012 21:24:05 +0000 (UTC)
Message-ID: <20121015212405.8EE7311FC39@bugzilla.kernel.org>
References: <bug-27912-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:52915 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753617Ab2JOVYI (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 15 Oct 2012 17:24:08 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 2EBE02025F
	for <linux-ext4@vger.kernel.org>; Mon, 15 Oct 2012 21:24:07 +0000 (UTC)
Received: from bugzilla.kernel.org (bugzilla.kernel.org [198.145.19.217])
	by mail.kernel.org (Postfix) with ESMTP id 92C5120181
	for <linux-ext4@vger.kernel.org>; Mon, 15 Oct 2012 21:24:05 +0000 (UTC)
In-Reply-To: <bug-27912-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=27912


Florian Mickler <florian@mickler.org> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |florian@mickler.org




--- Comment #5 from Florian Mickler <florian@mickler.org>  2012-10-15 21:24:05 ---
A patch referencing this bug report has been merged in Linux v3.7-rc1:

commit 0e376b1e3ccedee49cb8cc6b652fbc1e7c15eeef
Author: Theodore Ts'o <tytso@mit.edu>
Date:   Fri Aug 17 10:04:17 2012 -0400

    ext4: return an error if kset_create_and_add fails in ext4_init_fs()

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
