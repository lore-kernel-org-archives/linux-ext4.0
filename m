From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 71791] Unlinking a file that was moved to another folder but
 still open by other process blocks either process (not always reproducible)
Date: Sun, 16 Mar 2014 07:20:29 +0000
Message-ID: <bug-71791-13602-XZi4G8PUn5@https.bugzilla.kernel.org/>
References: <bug-71791-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:48065 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751036AbaCPHUd (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 16 Mar 2014 03:20:33 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 6AA2B20279
	for <linux-ext4@vger.kernel.org>; Sun, 16 Mar 2014 07:20:32 +0000 (UTC)
Received: from bugzilla1.web.kernel.org (bugzilla1.web.kernel.org [172.20.200.51])
	by mail.kernel.org (Postfix) with ESMTP id 0EF7C202AE
	for <linux-ext4@vger.kernel.org>; Sun, 16 Mar 2014 07:20:30 +0000 (UTC)
In-Reply-To: <bug-71791-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=71791

Zheng Liu <gnehzuil.liu@gmail.com> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |gnehzuil.liu@gmail.com

--- Comment #2 from Zheng Liu <gnehzuil.liu@gmail.com> ---
I guess that the journal mode is 'data=ordered', right?  Could you please try
to switch the journal mode to 'data=writeback' and look at whether or not the
problem can be reproduced?

In our product system, we met a hang which is caused by 'data=ordered' under a
heavy IO workload.  When the user uses 'rm' command to delete a file,
ext4_begin_ordered_truncate() should be called with 'data=ordered' and it could
trigger write back kernel thread to write out the dirty data.  Then
truncate_inode_pages() will wait on write back.

Regards,
                                                - Zheng

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
