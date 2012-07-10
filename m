From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 43292] jdb2 lockup with ext3 and nfs
Date: Tue, 10 Jul 2012 13:12:46 +0000 (UTC)
Message-ID: <20120710131246.16DBC11FB04@bugzilla.kernel.org>
References: <bug-43292-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:47795 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751731Ab2GJNMw (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 10 Jul 2012 09:12:52 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 0D5D02022B
	for <linux-ext4@vger.kernel.org>; Tue, 10 Jul 2012 13:12:48 +0000 (UTC)
Received: from bugzilla.kernel.org (unknown [198.145.19.217])
	by mail.kernel.org (Postfix) with ESMTP id 1D7292023A
	for <linux-ext4@vger.kernel.org>; Tue, 10 Jul 2012 13:12:46 +0000 (UTC)
In-Reply-To: <bug-43292-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=43292





--- Comment #24 from Jan Kara <jack@suse.cz>  2012-07-10 13:12:45 ---
Thanks a lot for trying out the kernels. I don't see how using ext4 instead of
ext3 can make the difference we observed - i.e. a submitted read request is not
completed. I guess I'll try to use ext4 to mount ext3 filesystem and beat it up
a bit to see whether I'll reproduce the problem locally for further
investigation.

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
