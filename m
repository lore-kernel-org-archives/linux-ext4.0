From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 43292] jdb2 lockup with ext3 and nfs
Date: Fri,  1 Jun 2012 15:24:38 +0000 (UTC)
Message-ID: <20120601152438.133A311FD1B@bugzilla.kernel.org>
References: <bug-43292-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:47825 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964838Ab2FAPYm (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 1 Jun 2012 11:24:42 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id E52662029D
	for <linux-ext4@vger.kernel.org>; Fri,  1 Jun 2012 15:24:40 +0000 (UTC)
Received: from bugzilla.kernel.org (bugzilla.kernel.org [198.145.19.204])
	by mail.kernel.org (Postfix) with ESMTP id 1AC66202A4
	for <linux-ext4@vger.kernel.org>; Fri,  1 Jun 2012 15:24:38 +0000 (UTC)
In-Reply-To: <bug-43292-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=43292





--- Comment #14 from Jan Kara <jack@suse.cz>  2012-06-01 15:24:37 ---
OK, something strange is going on. The block trace ends like:
253,2    0     3716    19.264276270   751  Q   R 485490688 + 8 [nfsd]
  9,0    0     3699    19.264279134   751  A   R 527540608 + 8 <- (253,2)
485490688
  9,0    0     3700    19.264280391   751  Q   R 527540608 + 8 [nfsd]
  8,32   0    14793    19.264283254   751  A   R 527540672 + 8 <- (8,33)
527540608
  8,32   0    14794    19.264284162   751  Q   R 527540672 + 8 [nfsd]
  8,32   0    14795    19.264286537   751  G   R 527540672 + 8 [nfsd]
  8,32   0    14796    19.264288073   751  P   N [nfsd]
  8,32   0    14797    19.264290727   751  I   R 527540672 + 8 [nfsd]
  8,32   0    14798    19.264292264   751  U   N [nfsd] 1
  8,32   0    14799    19.264293940   751  D   R 527540672 + 8 [nfsd]

We see request to read 8 sectors starting at 485490688 has been issued to
/dev/dm-2. I've checked that against dumpe2fs output and indeed that is a block
bitmap for group 1852. That request has gone through md-0 to sdc where it has
been dispatched to the disk driver for processing. All is well but for some
reason the read never completed which is why nfsd hangs.

So this doesn't look like a problem in the filesystem or block layer but rather
somewhere in the driver or hardware. Can you check what happens if you just run

dd if=/dev/dm-2 of=/dev/null bs=512 count=8 skip=485490688

Does the command finish? And what if you run it after nfsd has hung? If it does
finish in both cases, can you gather the blktrace of hanging once more like
before so that I can check whether we hang waiting for the same block the
second time as well? Thanks!

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
