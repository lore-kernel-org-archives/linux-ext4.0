From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 48431] [PATCH]ext4_fill_super() reports success even if
 ext4_mb_init() fails
Date: Sat, 22 Dec 2012 09:29:55 +0000 (UTC)
Message-ID: <20121222092955.7FA8911FBAA@bugzilla.kernel.org>
References: <bug-48431-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:55926 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750832Ab2LVJaF (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 22 Dec 2012 04:30:05 -0500
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id CC6A72016B
	for <linux-ext4@vger.kernel.org>; Sat, 22 Dec 2012 09:30:03 +0000 (UTC)
Received: from bugzilla.kernel.org (bugzilla.kernel.org [198.145.19.217])
	by mail.kernel.org (Postfix) with ESMTP id 7514E20167
	for <linux-ext4@vger.kernel.org>; Sat, 22 Dec 2012 09:29:57 +0000 (UTC)
In-Reply-To: <bug-48431-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=48431


Florian Mickler <florian@mickler.org> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |florian@mickler.org




--- Comment #2 from Florian Mickler <florian@mickler.org>  2012-12-22 09:29:55 ---
A patch referencing this bug report has been merged in Linux v3.8-rc1:

commit 07aa2ea13814ea60d12f7330b6d5ccfdb0c3ba4d
Author: Lukas Czerner <lczerner@redhat.com>
Date:   Thu Nov 8 15:16:54 2012 -0500

    ext4: fix error handling in ext4_fill_super()

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
