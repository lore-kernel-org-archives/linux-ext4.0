From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 65701] oops: fs/ext4/ext4_jbd2.c
Date: Mon, 25 Nov 2013 22:15:26 +0000
Message-ID: <bug-65701-13602-3bhzkVKnWa@https.bugzilla.kernel.org/>
References: <bug-65701-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:48306 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752391Ab3KYWP3 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 25 Nov 2013 17:15:29 -0500
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 377AA20347
	for <linux-ext4@vger.kernel.org>; Mon, 25 Nov 2013 22:15:28 +0000 (UTC)
Received: from bugzilla1.web.kernel.org (bugzilla1.web.kernel.org [172.20.200.51])
	by mail.kernel.org (Postfix) with ESMTP id DE87620328
	for <linux-ext4@vger.kernel.org>; Mon, 25 Nov 2013 22:15:26 +0000 (UTC)
In-Reply-To: <bug-65701-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=65701

Jan Kara <jack@suse.cz> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |jack@suse.cz

--- Comment #3 from Jan Kara <jack@suse.cz> ---
The patch looks good to me. Feel free to add
Reviewed-by: Jan Kara <jack@suse.cz>
Can you send it to Al Viro for inclusion? Thanks!

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
