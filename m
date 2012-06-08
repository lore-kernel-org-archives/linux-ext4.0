From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 43354] Corruption on a small loopback ext4 file system with
 Linux 3.4
Date: Fri,  8 Jun 2012 17:46:39 +0000 (UTC)
Message-ID: <20120608174639.7F0BB1205DA@bugzilla.kernel.org>
References: <bug-43354-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:56256 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752127Ab2FHRqm (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 8 Jun 2012 13:46:42 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 36F34203FA
	for <linux-ext4@vger.kernel.org>; Fri,  8 Jun 2012 17:46:41 +0000 (UTC)
Received: from bugzilla.kernel.org (bugzilla.kernel.org [198.145.19.204])
	by mail.kernel.org (Postfix) with ESMTP id 84C1B203F3
	for <linux-ext4@vger.kernel.org>; Fri,  8 Jun 2012 17:46:39 +0000 (UTC)
In-Reply-To: <bug-43354-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=43354





--- Comment #4 from Eric Sandeen <sandeen@redhat.com>  2012-06-08 17:46:39 ---
Hm, wait - drop caches _after_ unmount is required?  Ok that's even weirder
(and scarier - especially since it's after a sync)

And - on further testing, ext2 & ext3 fail too.  Yikes.

It also seems to happen only on loopback; a real device is fine.

And, loopback fails whether it's hosted on ext4 or xfs.  So something generic
broke here...

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
