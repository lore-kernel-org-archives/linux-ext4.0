From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 84201] mount doesn't clear usrjquota / grpjqouta options
Date: Thu, 18 Sep 2014 10:04:05 +0000
Message-ID: <bug-84201-13602-lNThhbbNEm@https.bugzilla.kernel.org/>
References: <bug-84201-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:51987 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756143AbaIRKEM (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 18 Sep 2014 06:04:12 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 265FF201CE
	for <linux-ext4@vger.kernel.org>; Thu, 18 Sep 2014 10:04:07 +0000 (UTC)
Received: from bugzilla1.web.kernel.org (bugzilla1.web.kernel.org [172.20.200.51])
	by mail.kernel.org (Postfix) with ESMTP id ED038200E6
	for <linux-ext4@vger.kernel.org>; Thu, 18 Sep 2014 10:04:05 +0000 (UTC)
In-Reply-To: <bug-84201-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=84201

Jan Kara <jack@suse.cz> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
             Status|NEEDINFO                    |RESOLVED
         Resolution|---                         |CODE_FIX

--- Comment #10 from Jan Kara <jack@suse.cz> ---
Ted has merged the patch so I'm closing the bug.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
