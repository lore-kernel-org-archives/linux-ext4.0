From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 43292] jdb2 lockup with ext3 and nfs
Date: Wed,  6 Jun 2012 21:56:31 +0000 (UTC)
Message-ID: <20120606215631.BCB8811FC42@bugzilla.kernel.org>
References: <bug-43292-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:43433 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753998Ab2FFV4e (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 6 Jun 2012 17:56:34 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 9E01220385
	for <linux-ext4@vger.kernel.org>; Wed,  6 Jun 2012 21:56:33 +0000 (UTC)
Received: from bugzilla.kernel.org (bugzilla.kernel.org [198.145.19.204])
	by mail.kernel.org (Postfix) with ESMTP id C727420387
	for <linux-ext4@vger.kernel.org>; Wed,  6 Jun 2012 21:56:31 +0000 (UTC)
In-Reply-To: <bug-43292-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=43292





--- Comment #19 from Florian Pritz <flo@xssn.at>  2012-06-06 21:56:31 ---
(In reply to comment #18)
> OK, thanks for testing. So you say the problem resolves itself even when you
> don't run dd, just it takes longer? I'm more and more inclined to blame some
> hardware strangeness... Also originally you said the problem started happening
> around 3.3 or 3.4 but now you are testing with 3.0. So do you have any kernel
> where you don't see the problem?

So far I can *not* reproduce the problem with 3.0.17 (transfered 8gb of data).
However, with 3.0.32 I can reproduce every time by copying a 20mb+ file.

If you want, I can test a few kernels in between .17 and .32, but that's going
to take some time.

FYI: I do notice short hickups on the client, but those are most likely just
because the disks aren't fast enough to handle the write requests. I'm running
with Gbit ethernet and reading is obviously faster than writing and writing is
slower than the link limit, resulting in the network buffers filling up. I
don't consider this a bug.

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
