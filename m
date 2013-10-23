From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 63511] EXT4-fs warning (device sdc):
 ext4_da_update_reserve_space:362: ino 75159523, allocated 1 with only 0
 reserved metadata blocks (releasing 162 blocks with reserved 162 data blocks)
Date: Wed, 23 Oct 2013 10:40:00 +0000
Message-ID: <bug-63511-13602-YenPqD3Rub@https.bugzilla.kernel.org/>
References: <bug-63511-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:54024 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752408Ab3JWKkP (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 23 Oct 2013 06:40:15 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 042812030D
	for <linux-ext4@vger.kernel.org>; Wed, 23 Oct 2013 10:40:10 +0000 (UTC)
Received: from bugzilla2.web.kernel.org (bugzilla2.web.kernel.org [172.20.200.52])
	by mail.kernel.org (Postfix) with ESMTP id CFA9A202F9
	for <linux-ext4@vger.kernel.org>; Wed, 23 Oct 2013 10:40:09 +0000 (UTC)
In-Reply-To: <bug-63511-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=63511

Jan Kara <jack@suse.cz> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
             Status|NEW                         |RESOLVED
                 CC|                            |jack@suse.cz
         Resolution|---                         |CODE_FIX

--- Comment #1 from Jan Kara <jack@suse.cz> ---
Thanks for report. This bug should be fixed by commit
7d7345322d60edb0fa49a64a89b31360f01d09cb (merged in 3.12-rc something). The
warning is mostly harmless though (the bug could lead to real problems only if
we hit ENOSPC condition).

I've asked stable kernel guys to take the commit into 3.10 and 3.11 -stable
series.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
