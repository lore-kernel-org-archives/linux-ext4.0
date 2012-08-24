From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 36172] "kernel BUG at fs/ext4/super.c" triggered after
 tune2fs/remount
Date: Fri, 24 Aug 2012 15:36:22 +0000 (UTC)
Message-ID: <20120824153622.EAD9B11FA35@bugzilla.kernel.org>
References: <bug-36172-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:36985 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759036Ab2HXPge (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 24 Aug 2012 11:36:34 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id DC69820493
	for <linux-ext4@vger.kernel.org>; Fri, 24 Aug 2012 15:36:28 +0000 (UTC)
Received: from bugzilla.kernel.org (unknown [198.145.19.217])
	by mail.kernel.org (Postfix) with ESMTP id ECB55204C7
	for <linux-ext4@vger.kernel.org>; Fri, 24 Aug 2012 15:36:22 +0000 (UTC)
In-Reply-To: <bug-36172-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=36172





--- Comment #6 from Christoph Biedl <bugzilla.kernel.bpeb@manchmal.in-ulm.de>  2012-08-24 15:36:22 ---
> So I'm going to close this as a kernel bug, and treat it as an e2fsprogs bug.

I'm totally fine with this.

Regards, Christoph

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
