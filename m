From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 43292] jdb2 lockup with ext3 and nfs
Date: Mon,  4 Jun 2012 10:19:33 +0000 (UTC)
Message-ID: <20120604101933.6326111FC42@bugzilla.kernel.org>
References: <bug-43292-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:49088 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756799Ab2FDKTg (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 4 Jun 2012 06:19:36 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 8AFEC201B7
	for <linux-ext4@vger.kernel.org>; Mon,  4 Jun 2012 10:19:35 +0000 (UTC)
Received: from bugzilla.kernel.org (bugzilla.kernel.org [198.145.19.204])
	by mail.kernel.org (Postfix) with ESMTP id 6939F201BB
	for <linux-ext4@vger.kernel.org>; Mon,  4 Jun 2012 10:19:33 +0000 (UTC)
In-Reply-To: <bug-43292-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=43292





--- Comment #18 from Jan Kara <jack@suse.cz>  2012-06-04 10:19:33 ---
OK, thanks for testing. So you say the problem resolves itself even when you
don't run dd, just it takes longer? I'm more and more inclined to blame some
hardware strangeness... Also originally you said the problem started happening
around 3.3 or 3.4 but now you are testing with 3.0. So do you have any kernel
where you don't see the problem?

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
