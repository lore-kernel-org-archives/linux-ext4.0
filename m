From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 43305] Deleting a folder with 500 000 small files causes
 deadlock in start_this_handle.irsa.7
Date: Tue, 29 May 2012 20:34:50 +0000 (UTC)
Message-ID: <20120529203450.EF9DF11FD19@bugzilla.kernel.org>
References: <bug-43305-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:32797 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753719Ab2E2Uex (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 29 May 2012 16:34:53 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id AADE9203B1
	for <linux-ext4@vger.kernel.org>; Tue, 29 May 2012 20:34:52 +0000 (UTC)
Received: from bugzilla.kernel.org (bugzilla.kernel.org [198.145.19.204])
	by mail.kernel.org (Postfix) with ESMTP id 02BA520300
	for <linux-ext4@vger.kernel.org>; Tue, 29 May 2012 20:34:51 +0000 (UTC)
In-Reply-To: <bug-43305-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=43305





--- Comment #4 from Jan Kara <jack@suse.cz>  2012-05-29 20:34:50 ---
Actually, this does not seem like deadlock as such. Rather the storm of discard
requests we send to the drive probably causes a headache to its FTL. Can you
try mounting the filesystem with 'nodiscard' mount option?

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
