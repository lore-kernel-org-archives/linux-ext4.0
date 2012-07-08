From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 43292] jdb2 lockup with ext3 and nfs
Date: Sun,  8 Jul 2012 14:44:49 +0000 (UTC)
Message-ID: <20120708144449.B398411FB24@bugzilla.kernel.org>
References: <bug-43292-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:57463 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751742Ab2GHOox (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 8 Jul 2012 10:44:53 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id D3C1A20200
	for <linux-ext4@vger.kernel.org>; Sun,  8 Jul 2012 14:44:52 +0000 (UTC)
Received: from bugzilla.kernel.org (unknown [198.145.19.217])
	by mail.kernel.org (Postfix) with ESMTP id CBB4F201F9
	for <linux-ext4@vger.kernel.org>; Sun,  8 Jul 2012 14:44:50 +0000 (UTC)
In-Reply-To: <bug-43292-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=43292





--- Comment #23 from Florian Pritz <bluewind@xinu.at>  2012-07-08 14:44:49 ---
Alright, after bisecting and trying lots of kernels, I believe it's not a code
change causing this, but rather a change [1] in Arch's config file.

3.0.22 with the ext3 module works fine, but if I apply that patch to use ext4
for ext3 file systems, it hangs. 
3.0.23 with the ext3 module works too.

Since I don't know if it ever worked with that option enabled, I don't think
bisecting will help. Any ideas?

[1]:
https://projects.archlinux.org/svntogit/packages.git/commit/trunk?h=packages/linux-lts&id=7c53d3c600983af5a021315b1ef27ed6d4807170

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
