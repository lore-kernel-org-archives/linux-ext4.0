From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 66881] [3.12.1][ext4]kernel BUG at
 fs/ext4/extents_status.c:709!
Date: Mon, 31 Mar 2014 20:33:50 +0000
Message-ID: <bug-66881-13602-gb4wFyFTwe@https.bugzilla.kernel.org/>
References: <bug-66881-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:50361 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751206AbaCaUdx (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 31 Mar 2014 16:33:53 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 53C1E203DA
	for <linux-ext4@vger.kernel.org>; Mon, 31 Mar 2014 20:33:52 +0000 (UTC)
Received: from bugzilla1.web.kernel.org (bugzilla1.web.kernel.org [172.20.200.51])
	by mail.kernel.org (Postfix) with ESMTP id E82B9203B1
	for <linux-ext4@vger.kernel.org>; Mon, 31 Mar 2014 20:33:50 +0000 (UTC)
In-Reply-To: <bug-66881-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=66881

Theodore Tso <tytso@mit.edu> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
             Status|NEW                         |RESOLVED
                 CC|                            |tytso@mit.edu
         Resolution|---                         |CODE_FIX

--- Comment #5 from Theodore Tso <tytso@mit.edu> ---
Thanks for the reminder that the bug could be closed!

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
