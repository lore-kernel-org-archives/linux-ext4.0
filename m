From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 40822] EXT4-fs error (device dm-4): ext4_lookup:1044: inode
 #3308277: comm rm: deleted inode referenced: 3058008
Date: Mon, 23 Dec 2013 14:15:08 +0000
Message-ID: <bug-40822-13602-gHoeeo9zQ5@https.bugzilla.kernel.org/>
References: <bug-40822-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:40142 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757359Ab3LWOPR (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 23 Dec 2013 09:15:17 -0500
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id D9F13207B3
	for <linux-ext4@vger.kernel.org>; Mon, 23 Dec 2013 14:15:15 +0000 (UTC)
Received: from bugzilla1.web.kernel.org (bugzilla1.web.kernel.org [172.20.200.51])
	by mail.kernel.org (Postfix) with ESMTP id 41321207B5
	for <linux-ext4@vger.kernel.org>; Mon, 23 Dec 2013 14:15:09 +0000 (UTC)
In-Reply-To: <bug-40822-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=40822

Alan <alan@lxorguk.ukuu.org.uk> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |alan@lxorguk.ukuu.org.uk
     Kernel Version|2.6.39.3                    |3.7

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
