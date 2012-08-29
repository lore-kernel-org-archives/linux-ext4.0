From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 44731] ext4 deadlock under heavy io?
Date: Wed, 29 Aug 2012 14:23:41 +0000 (UTC)
Message-ID: <20120829142341.0715011FB49@bugzilla.kernel.org>
References: <bug-44731-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:51496 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751124Ab2H2OXq (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 29 Aug 2012 10:23:46 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 056C520257
	for <linux-ext4@vger.kernel.org>; Wed, 29 Aug 2012 14:23:42 +0000 (UTC)
Received: from bugzilla.kernel.org (unknown [198.145.19.217])
	by mail.kernel.org (Postfix) with ESMTP id 0976C201E1
	for <linux-ext4@vger.kernel.org>; Wed, 29 Aug 2012 14:23:41 +0000 (UTC)
In-Reply-To: <bug-44731-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=44731


Jan Kara <jack@suse.cz> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |jack@suse.cz, neilb@suse.de




--- Comment #3 from Jan Kara <jack@suse.cz>  2012-08-29 14:23:40 ---
I had a look into the traces from comment 2. At first sight things are waiting
for IO. But it needn't be that simple - a few processes are hanging in
get_active_stripe() waiting for a free stripe. So in theory it could be some
RAID5 issue. Neil, any idea?

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
