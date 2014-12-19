From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 89131] Hangs when checking torrent through libtorrent; kernel
 BUG at mm/iov_iter.c:219!
Date: Fri, 19 Dec 2014 16:37:50 +0000
Message-ID: <bug-89131-13602-Wb92Jf6RpG@https.bugzilla.kernel.org/>
References: <bug-89131-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:35094 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751082AbaLSQhz (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 19 Dec 2014 11:37:55 -0500
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 1CB832013A
	for <linux-ext4@vger.kernel.org>; Fri, 19 Dec 2014 16:37:54 +0000 (UTC)
Received: from bugzilla2.web.kernel.org (bugzilla2.web.kernel.org [172.20.200.52])
	by mail.kernel.org (Postfix) with ESMTP id 660C120148
	for <linux-ext4@vger.kernel.org>; Fri, 19 Dec 2014 16:37:51 +0000 (UTC)
In-Reply-To: <bug-89131-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=89131

--- Comment #9 from Lubos Dolezel <lubosd@gmail.com> ---
Created attachment 161341
  --> https://bugzilla.kernel.org/attachment.cgi?id=161341&action=edit
dumpe2fs

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
