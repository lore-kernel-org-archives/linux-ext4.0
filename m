From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 71791] Unlinking a file that was moved to another folder but
 still open by other process blocks either process (not always reproducible)
Date: Tue, 11 Mar 2014 20:14:17 +0000
Message-ID: <bug-71791-13602-4LFzENGHK3@https.bugzilla.kernel.org/>
References: <bug-71791-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:36617 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754341AbaCKUOT (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 11 Mar 2014 16:14:19 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 0BB552034E
	for <linux-ext4@vger.kernel.org>; Tue, 11 Mar 2014 20:14:19 +0000 (UTC)
Received: from bugzilla1.web.kernel.org (bugzilla1.web.kernel.org [172.20.200.51])
	by mail.kernel.org (Postfix) with ESMTP id 756BF20260
	for <linux-ext4@vger.kernel.org>; Tue, 11 Mar 2014 20:14:17 +0000 (UTC)
In-Reply-To: <bug-71791-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=71791

Jan Kara <jack@suse.cz> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
             Status|NEW                         |NEEDINFO
                 CC|                            |jack@suse.cz

--- Comment #1 from Jan Kara <jack@suse.cz> ---
So one note is that we are likely waiting for writeback on some page in that
file to finish. Another note is that I don't think another process has the file
open - the stacktrace clearly shows that we are completely deleting the file
which means noone can have the file open (if you can really show otherwise, it
would be a major bug).

I guess the file has been written quite recently and the filesystem is quite
loaded with the IO, isn't it?

Can you try mounting the filesystem with 'noauto_da_alloc' mount option?

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
