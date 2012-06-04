From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 43305] Deleting a folder with 500 000 small files causes
 deadlock in start_this_handle.irsa.7
Date: Mon,  4 Jun 2012 10:22:48 +0000 (UTC)
Message-ID: <20120604102248.6DFF111FBD1@bugzilla.kernel.org>
References: <bug-43305-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:49201 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756837Ab2FDKWu (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 4 Jun 2012 06:22:50 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id E594220290
	for <linux-ext4@vger.kernel.org>; Mon,  4 Jun 2012 10:22:49 +0000 (UTC)
Received: from bugzilla.kernel.org (bugzilla.kernel.org [198.145.19.204])
	by mail.kernel.org (Postfix) with ESMTP id 7623A20275
	for <linux-ext4@vger.kernel.org>; Mon,  4 Jun 2012 10:22:48 +0000 (UTC)
In-Reply-To: <bug-43305-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=43305





--- Comment #5 from Jan Kara <jack@suse.cz>  2012-06-04 10:22:48 ---
Any result with nodiscard mount option? I'll just close this bug if there's no
reply...

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
