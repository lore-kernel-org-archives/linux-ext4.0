From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 44731] ext4 deadlock under heavy io?
Date: Mon, 16 Jul 2012 20:54:14 +0000 (UTC)
Message-ID: <20120716205414.B3E7511FB37@bugzilla.kernel.org>
References: <bug-44731-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:34667 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753794Ab2GPUyS (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 16 Jul 2012 16:54:18 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 3FAF120253
	for <linux-ext4@vger.kernel.org>; Mon, 16 Jul 2012 20:54:17 +0000 (UTC)
Received: from bugzilla.kernel.org (unknown [198.145.19.217])
	by mail.kernel.org (Postfix) with ESMTP id 77FC52024E
	for <linux-ext4@vger.kernel.org>; Mon, 16 Jul 2012 20:54:15 +0000 (UTC)
In-Reply-To: <bug-44731-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=44731





--- Comment #2 from Anssi Hannula <anssi.hannula@iki.fi>  2012-07-16 20:54:14 ---
Created an attachment (id=75501)
 --> (https://bugzilla.kernel.org/attachment.cgi?id=75501)
sysrq-w output on 3.4.2 with frozen filesystem dm-4

I'm seeing a very similar issue on 3.4.2. I think this issue didn't exist
several major versions back.

When one or more applications do intensive I/O, the filesystem freezes and all
processes trying to access it freeze as well.

It doesn't always happen in the same way, though. Sometimes I get the "task
blocked for more than 120 seconds", but sometimes I don't (in the attached case
I didn't get those). Also, sometimes the system becomes usable again after
several minutes of being seemingly frozen, but often it doesn't recover (like
in the attached case). If wanted, I can provide more logs of these different
situations (the logs do look very similar than the ones on this report,
though).

In the attachment the frozen fs is dm-4. It is on the same LVM VG and RAID-6 as
dm-3, dm-5, dm-6, and those other filesystems continued to work while dm-4 was
frozen.

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
