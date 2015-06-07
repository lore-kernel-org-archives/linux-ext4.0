From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 99051] general protection fault in ext4_htree_store_dirent
Date: Sun, 07 Jun 2015 15:29:46 +0000
Message-ID: <bug-99051-13602-r4qNOw8tQJ@https.bugzilla.kernel.org/>
References: <bug-99051-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:59549 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750746AbbFGP3u convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 7 Jun 2015 11:29:50 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 009D6205C6
	for <linux-ext4@vger.kernel.org>; Sun,  7 Jun 2015 15:29:49 +0000 (UTC)
Received: from bugzilla1.web.kernel.org (bugzilla1.web.kernel.org [172.20.200.51])
	by mail.kernel.org (Postfix) with ESMTP id 949BB205C7
	for <linux-ext4@vger.kernel.org>; Sun,  7 Jun 2015 15:29:46 +0000 (UTC)
In-Reply-To: <bug-99051-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=3D99051

--- Comment #2 from Ernst Sj=C3=B6strand <ernstp@gmail.com> ---
My system which is brand new was panicing a lot so I was afraid it was =
broken.
But with 3.19.0-20-generic now it's very stable and passed 120 hours of
memtest.

--=20
You are receiving this mail because:
You are watching the assignee of the bug.--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
