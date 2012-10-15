From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 45741] ext4 scans all disk when calling fallocate after mount
 on 99% full volume.
Date: Mon, 15 Oct 2012 21:24:57 +0000 (UTC)
Message-ID: <20121015212457.5A06411FC43@bugzilla.kernel.org>
References: <bug-45741-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:53063 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754171Ab2JOVZA (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 15 Oct 2012 17:25:00 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id C41F720181
	for <linux-ext4@vger.kernel.org>; Mon, 15 Oct 2012 21:24:59 +0000 (UTC)
Received: from bugzilla.kernel.org (bugzilla.kernel.org [198.145.19.217])
	by mail.kernel.org (Postfix) with ESMTP id 5B60E201A2
	for <linux-ext4@vger.kernel.org>; Mon, 15 Oct 2012 21:24:57 +0000 (UTC)
In-Reply-To: <bug-45741-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=45741


Florian Mickler <florian@mickler.org> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |florian@mickler.org




--- Comment #2 from Florian Mickler <florian@mickler.org>  2012-10-15 21:24:57 ---
A patch referencing this bug report has been merged in Linux v3.7-rc1:

commit 01fc48e8929e45e67527200017cff4e74e4ba054
Author: Theodore Ts'o <tytso@mit.edu>
Date:   Fri Aug 17 09:46:17 2012 -0400

    ext4: don't load the block bitmap for block groups which have no space

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
