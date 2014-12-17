From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 89131] Hangs when checking torrent through libtorrent; kernel
 BUG at mm/iov_iter.c:219!
Date: Wed, 17 Dec 2014 09:49:38 +0000
Message-ID: <bug-89131-13602-qm049RRWlt@https.bugzilla.kernel.org/>
References: <bug-89131-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:52018 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750790AbaLQJtm (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 17 Dec 2014 04:49:42 -0500
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 0B59220A30
	for <linux-ext4@vger.kernel.org>; Wed, 17 Dec 2014 09:49:41 +0000 (UTC)
Received: from bugzilla1.web.kernel.org (bugzilla1.web.kernel.org [172.20.200.51])
	by mail.kernel.org (Postfix) with ESMTP id 78D4620A28
	for <linux-ext4@vger.kernel.org>; Wed, 17 Dec 2014 09:49:39 +0000 (UTC)
In-Reply-To: <bug-89131-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=89131

Lubos Dolezel <lubosd@gmail.com> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |lubosd@gmail.com

--- Comment #1 from Lubos Dolezel <lubosd@gmail.com> ---
Created attachment 160921
  --> https://bugzilla.kernel.org/attachment.cgi?id=160921&action=edit
Kernel BUG dump

I'm seeing the same kind of crash, 5 times just yesterday!

I'm using libtorrent to download a huge torrent (almost 50GB) with many files
inside (BluRay dump). I haven't seen it with other torrents.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
