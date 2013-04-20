From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 56821] an ext4 commit ee0906f causes weird disk hangs
Date: Sat, 20 Apr 2013 17:59:25 +0000 (UTC)
Message-ID: <20130420175925.DECF311FA4F@bugzilla.kernel.org>
References: <bug-56821-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:35360 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752500Ab3DTR7a (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 20 Apr 2013 13:59:30 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 530452064A
	for <linux-ext4@vger.kernel.org>; Sat, 20 Apr 2013 17:59:29 +0000 (UTC)
Received: from bugzilla.kernel.org (bugzilla.kernel.org [198.145.19.217])
	by mail.kernel.org (Postfix) with ESMTP id 1AA6320566
	for <linux-ext4@vger.kernel.org>; Sat, 20 Apr 2013 17:59:27 +0000 (UTC)
In-Reply-To: <bug-56821-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=56821





--- Comment #3 from Tommi Kyntola <kynde@ts.ray.fi>  2013-04-20 17:59:25 ---
Yes to software raid, I thought I mentioned it there already, but evidently I
skipped that bit, sorry.

I can strace the thunderbird launch, which is still the only way I've managed
to trigger it, but thankfully it triggers it every time, but we'll have to wait
until Monday as it's my office box.

You wouldn't happen to have ideas what I should/could try to cause that in a
cleaner way? (i.e. should I be generating load with large files or lots of
small ones, lots of concurrent action or will a single thread do, etc) 

And what else should I be trying? Stipping down kernel config? Would ext4
debugs help?

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
