From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 44731] ext4 deadlock under heavy io?
Date: Fri, 31 Aug 2012 13:03:54 +0000 (UTC)
Message-ID: <20120831130354.8412F11FBF5@bugzilla.kernel.org>
References: <bug-44731-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:56145 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751316Ab2HaNEC (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 31 Aug 2012 09:04:02 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id A33C920325
	for <linux-ext4@vger.kernel.org>; Fri, 31 Aug 2012 13:04:00 +0000 (UTC)
Received: from bugzilla.kernel.org (unknown [198.145.19.217])
	by mail.kernel.org (Postfix) with ESMTP id 8E546202E2
	for <linux-ext4@vger.kernel.org>; Fri, 31 Aug 2012 13:03:59 +0000 (UTC)
In-Reply-To: <bug-44731-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=44731





--- Comment #15 from Mirek Rusin <mirek@me.com>  2012-08-31 13:03:54 ---
Created an attachment (id=78931)
 --> (https://bugzilla.kernel.org/attachment.cgi?id=78931)
echo w > /proc/sysrq-trigger output on frozen filesystem (#2)

...just happened again, in case it's useful, another dump attached.

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
