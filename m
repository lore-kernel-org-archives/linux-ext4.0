From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 89131] Hangs when checking torrent through libtorrent; kernel
 BUG at mm/iov_iter.c:219!
Date: Wed, 17 Dec 2014 11:20:07 +0000
Message-ID: <bug-89131-13602-50przIpw1h@https.bugzilla.kernel.org/>
References: <bug-89131-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:56359 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751033AbaLQLUK (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 17 Dec 2014 06:20:10 -0500
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 917FA20A2E
	for <linux-ext4@vger.kernel.org>; Wed, 17 Dec 2014 11:20:09 +0000 (UTC)
Received: from bugzilla1.web.kernel.org (bugzilla1.web.kernel.org [172.20.200.51])
	by mail.kernel.org (Postfix) with ESMTP id 38BBF20A28
	for <linux-ext4@vger.kernel.org>; Wed, 17 Dec 2014 11:20:08 +0000 (UTC)
In-Reply-To: <bug-89131-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=89131

--- Comment #3 from Lubos Dolezel <lubosd@gmail.com> ---
Yep, this workaround helps.

As a little side note, using direct I/O with ext4 has resulted in many other
crashes on my system including softlockups and various other oopses. ext4's
direct involvement could be seen in ~50% of them.

So this "kernel BUG" is not the only possible outcome.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
