From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 89131] Hangs when checking torrent through libtorrent; kernel
 BUG at mm/iov_iter.c:219!
Date: Fri, 19 Dec 2014 16:37:33 +0000
Message-ID: <bug-89131-13602-5QdOorcfTM@https.bugzilla.kernel.org/>
References: <bug-89131-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:35042 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751082AbaLSQhg (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 19 Dec 2014 11:37:36 -0500
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 3565720154
	for <linux-ext4@vger.kernel.org>; Fri, 19 Dec 2014 16:37:35 +0000 (UTC)
Received: from bugzilla1.web.kernel.org (bugzilla1.web.kernel.org [172.20.200.51])
	by mail.kernel.org (Postfix) with ESMTP id CA3602013A
	for <linux-ext4@vger.kernel.org>; Fri, 19 Dec 2014 16:37:33 +0000 (UTC)
In-Reply-To: <bug-89131-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=89131

--- Comment #8 from Lubos Dolezel <lubosd@gmail.com> ---
The kernel BUG typically happened pretty quickly when doing torrent checking
(reading).

Other symptoms (more fatal crashes) when downloading and uploading happened
within minutes/hours, but that's understandable, because the I/O is lower in
this case.

Note that I haven't had this issue for weeks until I started downloading a
particular torrent.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
