From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 61631] kernel BUG at fs/ext4/super.c:818 umounting md raid6
 volume
Date: Tue, 15 Oct 2013 08:04:15 +0000
Message-ID: <bug-61631-13602-qXKd4LTO0G@https.bugzilla.kernel.org/>
References: <bug-61631-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:57288 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750904Ab3JOIEW (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 15 Oct 2013 04:04:22 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 85904202E5
	for <linux-ext4@vger.kernel.org>; Tue, 15 Oct 2013 08:04:21 +0000 (UTC)
Received: from bugzilla2.web.kernel.org (bugzilla2.web.kernel.org [172.20.200.52])
	by mail.kernel.org (Postfix) with ESMTP id C37B3202C1
	for <linux-ext4@vger.kernel.org>; Tue, 15 Oct 2013 08:04:15 +0000 (UTC)
In-Reply-To: <bug-61631-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=61631

--- Comment #14 from Jan Kara <jack@suse.cz> ---
Umm, no, it really looks like a ton of inodes remains in the orphan list and I
really things this is the NFS bug. So just try a kernel with that fix
(bf7bd3e98be5c74813bee6ad496139fb0a011b3b) applied. Thanks!

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
