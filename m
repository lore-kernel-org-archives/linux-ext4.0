From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 70091] mutex_unlock is missed in function
 (swap_inode_boot_loader) in file (linux-3.13/fs/ext4/ioctl.c)
Date: Mon, 31 Mar 2014 20:39:39 +0000
Message-ID: <bug-70091-13602-MbHVc4Xpw8@https.bugzilla.kernel.org/>
References: <bug-70091-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:50604 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750946AbaCaUjm (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 31 Mar 2014 16:39:42 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 2979D203C4
	for <linux-ext4@vger.kernel.org>; Mon, 31 Mar 2014 20:39:41 +0000 (UTC)
Received: from bugzilla1.web.kernel.org (bugzilla1.web.kernel.org [172.20.200.51])
	by mail.kernel.org (Postfix) with ESMTP id 85830203AF
	for <linux-ext4@vger.kernel.org>; Mon, 31 Mar 2014 20:39:39 +0000 (UTC)
In-Reply-To: <bug-70091-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=70091

Theodore Tso <tytso@mit.edu> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
             Status|NEW                         |RESOLVED
                 CC|                            |tytso@mit.edu
         Resolution|---                         |CODE_FIX

--- Comment #2 from Theodore Tso <tytso@mit.edu> ---
Thanks for the note!

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
