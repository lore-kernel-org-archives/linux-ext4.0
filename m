From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 89131] Hangs when checking torrent through libtorrent; kernel
 BUG at mm/iov_iter.c:219!
Date: Mon, 19 Jan 2015 07:54:27 +0000
Message-ID: <bug-89131-13602-fi5yx8IVBL@https.bugzilla.kernel.org/>
References: <bug-89131-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:36548 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751226AbbASHya (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 19 Jan 2015 02:54:30 -0500
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 65B352037C
	for <linux-ext4@vger.kernel.org>; Mon, 19 Jan 2015 07:54:29 +0000 (UTC)
Received: from bugzilla2.web.kernel.org (bugzilla2.web.kernel.org [172.20.200.52])
	by mail.kernel.org (Postfix) with ESMTP id 25E6B20361
	for <linux-ext4@vger.kernel.org>; Mon, 19 Jan 2015 07:54:28 +0000 (UTC)
In-Reply-To: <bug-89131-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=89131

--- Comment #10 from kokoko3k@gmail.com <kokoko3k@gmail.com> ---
Unfortunately the crash still happens on 3.18.2

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
