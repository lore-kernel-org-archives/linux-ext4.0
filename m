From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 61601] rootflags=noatime causes kernel panic when booting
 without initrd.
Date: Fri, 11 Apr 2014 21:25:08 +0000
Message-ID: <bug-61601-13602-C2Tb8b4BjO@https.bugzilla.kernel.org/>
References: <bug-61601-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:49805 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754549AbaDKVZM (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 11 Apr 2014 17:25:12 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id E392C2035C
	for <linux-ext4@vger.kernel.org>; Fri, 11 Apr 2014 21:25:10 +0000 (UTC)
Received: from bugzilla2.web.kernel.org (bugzilla2.web.kernel.org [172.20.200.52])
	by mail.kernel.org (Postfix) with ESMTP id CA3912034C
	for <linux-ext4@vger.kernel.org>; Fri, 11 Apr 2014 21:25:08 +0000 (UTC)
In-Reply-To: <bug-61601-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=61601

--- Comment #5 from Mateusz <dragonn@op.pl> ---
Conrad Meyer but did you boot without initrd? With initrd it boots fine because
the root fs is mounted by a busybox script but without it the kernel mounts the
root fs with relatime with conflicts with noatime. Johannes Hirte so it looks
like all file system are affected, with category should I set now?

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
