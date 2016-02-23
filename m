From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 112631] Cannot open encrypted Luks filesystem. Cruptsetup
 error.
Date: Tue, 23 Feb 2016 20:30:50 +0000
Message-ID: <bug-112631-13602-tB8p47FRkv@https.bugzilla.kernel.org/>
References: <bug-112631-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:43701 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754906AbcBWUay (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 23 Feb 2016 15:30:54 -0500
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 943C62037E
	for <linux-ext4@vger.kernel.org>; Tue, 23 Feb 2016 20:30:53 +0000 (UTC)
Received: from bugzilla1.web.kernel.org (bugzilla1.web.kernel.org [172.20.200.51])
	by mail.kernel.org (Postfix) with ESMTP id 131D4202FF
	for <linux-ext4@vger.kernel.org>; Tue, 23 Feb 2016 20:30:51 +0000 (UTC)
In-Reply-To: <bug-112631-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=112631

--- Comment #18 from da_audiophile@yahoo.com ---
Regarding Comment #17 - It is just 2 patches to apply to cryptsetup.  I would
think any distro would have no problem with them.[1]

1.
https://projects.archlinux.org/svntogit/packages.git/commit/trunk?h=packages/cryptsetup&id=ea2c8f73c45aa239ed5f356a8ecd01aeba51ef1d

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
