From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 92271] Provide a way to really delete files, please
Date: Sun, 01 Feb 2015 17:18:46 +0000
Message-ID: <bug-92271-13602-cjVAYPo1yK@https.bugzilla.kernel.org/>
References: <bug-92271-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:56597 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753204AbbBARSt (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 1 Feb 2015 12:18:49 -0500
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 28C24202AE
	for <linux-ext4@vger.kernel.org>; Sun,  1 Feb 2015 17:18:48 +0000 (UTC)
Received: from bugzilla1.web.kernel.org (bugzilla1.web.kernel.org [172.20.200.51])
	by mail.kernel.org (Postfix) with ESMTP id 760E920218
	for <linux-ext4@vger.kernel.org>; Sun,  1 Feb 2015 17:18:46 +0000 (UTC)
In-Reply-To: <bug-92271-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=92271

--- Comment #18 from Alexander Holler <holler@ahsoftware.de> ---
And if the encrypted content isn't really deleted, what happens if the key has
gone away before it was "flushed" (whatever that means)? Which doesn't sound
that unlikely after we've learned about the resources governments are using to
get their hands on such stuff. So one could say one problem was exchanged
against another, if the storage isn't really erased (which leads to original
problem).

Anyway, maybe the easy way I've used to fix fat in a few hours works for extN
too. No idea if and when I will try or even post patches, as I personally don't
have any problem with all that and are happily able to secure my own stuff
according to most of my needs (hopefully). So I'll now stop arguing (likely to
your pleasure) ;)

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
