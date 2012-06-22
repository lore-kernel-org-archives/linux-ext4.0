From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 43292] jdb2 lockup with ext3 and nfs
Date: Fri, 22 Jun 2012 20:45:13 +0000 (UTC)
Message-ID: <20120622204513.9BEC911F7F1@bugzilla.kernel.org>
References: <bug-43292-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:45349 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754538Ab2FVUpS (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 22 Jun 2012 16:45:18 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 0B031202ED
	for <linux-ext4@vger.kernel.org>; Fri, 22 Jun 2012 20:45:17 +0000 (UTC)
Received: from bugzilla.kernel.org (unknown [198.145.19.217])
	by mail.kernel.org (Postfix) with ESMTP id 98EF9202DB
	for <linux-ext4@vger.kernel.org>; Fri, 22 Jun 2012 20:45:14 +0000 (UTC)
In-Reply-To: <bug-43292-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=43292





--- Comment #21 from Florian Pritz <bluewind@xinu.at>  2012-06-22 20:45:13 ---
Finally got around to testing. Looks like it break from 3.0.22 -> .23. 

I've used the Arch Linux packages for testing and noticed that there have been
a few config changes [1] at that time. Could those be related? I've already
tried booting .23 with transparent_hugepage=never, but that didn't help.

[1]:
https://projects.archlinux.org/svntogit/packages.git/log/trunk?h=packages/linux-lts

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
