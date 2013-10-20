From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 61631] kernel BUG at fs/ext4/super.c:818 umounting md raid6
 volume
Date: Sun, 20 Oct 2013 22:32:31 +0000
Message-ID: <bug-61631-13602-r49JckoQXb@https.bugzilla.kernel.org/>
References: <bug-61631-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:35826 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751868Ab3JTWch (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 20 Oct 2013 18:32:37 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 9A60120386
	for <linux-ext4@vger.kernel.org>; Sun, 20 Oct 2013 22:32:36 +0000 (UTC)
Received: from bugzilla2.web.kernel.org (bugzilla2.web.kernel.org [172.20.200.52])
	by mail.kernel.org (Postfix) with ESMTP id 332152031C
	for <linux-ext4@vger.kernel.org>; Sun, 20 Oct 2013 22:32:35 +0000 (UTC)
In-Reply-To: <bug-61631-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=61631

Jan Kara <jack@suse.cz> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
             Status|NEW                         |RESOLVED
         Resolution|---                         |CODE_FIX

--- Comment #16 from Jan Kara <jack@suse.cz> ---
Thanks for confirmation.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
