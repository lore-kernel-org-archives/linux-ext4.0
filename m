From: bugme-daemon@bugzilla.kernel.org
Subject: [Bug 11960] Oops in ext4_mb_poll_new_transaction
Date: Wed,  5 Nov 2008 14:24:05 -0800 (PST)
Message-ID: <20081105222405.D8B1311D107@picon.linux-foundation.org>
References: <bug-11960-13602@http.bugzilla.kernel.org/>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57912 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753395AbYKEWYI (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 5 Nov 2008 17:24:08 -0500
Received: from picon.linux-foundation.org (picon.linux-foundation.org [140.211.169.79])
	by smtp1.linux-foundation.org (8.14.2/8.13.5/Debian-3ubuntu1.1) with ESMTP id mA5MO52T016434
	for <linux-ext4@vger.kernel.org>; Wed, 5 Nov 2008 14:24:06 -0800
In-Reply-To: <bug-11960-13602@http.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

http://bugzilla.kernel.org/show_bug.cgi?id=11960





------- Comment #2 from kelly@newdream.net  2008-11-05 14:24 -------
backup:~# dumpe2fs -h /dev/sdb1 | grep Journal
dumpe2fs 1.41.3 (12-Oct-2008)
Journal inode:            8
Journal backup:           inode blocks
Journal size:             128M

I'll work on building a new kernel with the actual stable stuff soon. Hopefully
we won't see it there!


-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug, or are watching the assignee.
