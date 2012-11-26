From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 50981] ext4 : DATA CORRUPTION read and write on same 4096 page
 range
Date: Mon, 26 Nov 2012 08:34:18 +0000 (UTC)
Message-ID: <20121126083418.8E43A11FB7E@bugzilla.kernel.org>
References: <bug-50981-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:32822 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753671Ab2KZIeV (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 26 Nov 2012 03:34:21 -0500
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 98A24201BA
	for <linux-ext4@vger.kernel.org>; Mon, 26 Nov 2012 08:34:20 +0000 (UTC)
Received: from bugzilla.kernel.org (bugzilla.kernel.org [198.145.19.217])
	by mail.kernel.org (Postfix) with ESMTP id 27B332018F
	for <linux-ext4@vger.kernel.org>; Mon, 26 Nov 2012 08:34:19 +0000 (UTC)
In-Reply-To: <bug-50981-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=50981


Lukas Czerner <lczerner@redhat.com> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |lczerner@redhat.com




--- Comment #2 from Lukas Czerner <lczerner@redhat.com>  2012-11-26 08:34:18 ---
This is present upstream as well (3.7.0-rc7). In fact it is not even ext4
specific. I can easily reproduce this on btrfs, ext3, vfat. I suspect that this
would be reproducible on every file system which does not implement its own
read/write exclusion as xfs does.

MM people should really take a look at this as well since we are expecting the
read/write to/from the single page to be atomic, but this looks like that it
might not be true.

Thanks!
-Lukas

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
