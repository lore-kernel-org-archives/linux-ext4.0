From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 84201] mount doesn't clear usrjquota / grpjqouta options
Date: Tue, 16 Sep 2014 20:25:12 +0000
Message-ID: <bug-84201-13602-cFAA3Yh28Z@https.bugzilla.kernel.org/>
References: <bug-84201-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:57173 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753853AbaIPUZO (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 16 Sep 2014 16:25:14 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 90C4E201ED
	for <linux-ext4@vger.kernel.org>; Tue, 16 Sep 2014 20:25:13 +0000 (UTC)
Received: from bugzilla2.web.kernel.org (bugzilla2.web.kernel.org [172.20.200.52])
	by mail.kernel.org (Postfix) with ESMTP id DA36D201B4
	for <linux-ext4@vger.kernel.org>; Tue, 16 Sep 2014 20:25:12 +0000 (UTC)
In-Reply-To: <bug-84201-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=84201

--- Comment #9 from Jan Kara <jack@suse.cz> ---
Created attachment 150581
  --> https://bugzilla.kernel.org/attachment.cgi?id=150581&action=edit
[PATCH] ext4: Don't check quota format when there are no quota files

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
