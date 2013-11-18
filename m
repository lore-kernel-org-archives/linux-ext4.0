From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 62751] INFO: rcu_sched detected stalls on CPUs/tasks: { 3}
 (detected by 2, t=15107 jiffies, g=270766, c=270765, q=0)
Date: Mon, 18 Nov 2013 07:51:29 +0000
Message-ID: <bug-62751-13602-ffQ6cczvwW@https.bugzilla.kernel.org/>
References: <bug-62751-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:50289 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750779Ab3KRHvc (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 18 Nov 2013 02:51:32 -0500
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 12F3D206E3
	for <linux-ext4@vger.kernel.org>; Mon, 18 Nov 2013 07:51:31 +0000 (UTC)
Received: from bugzilla1.web.kernel.org (bugzilla1.web.kernel.org [172.20.200.51])
	by mail.kernel.org (Postfix) with ESMTP id DFBC9205E2
	for <linux-ext4@vger.kernel.org>; Mon, 18 Nov 2013 07:51:29 +0000 (UTC)
In-Reply-To: <bug-62751-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=62751

--- Comment #8 from Loris Luise <loris.luise@gmail.com> ---
Hello,

what can I do on my side?

I've done the following modifications:

1) Installed latest mainline kernel 3.12

2) Replaced SCSI drivers from vmw_pvsci to LSI Logic SAS (mptsas)

3) reduced number of CPUs from 8 to 4

4) enabled on ESXi (4.1) setting for this machine "CPU Hot add" feature

The issue is still affecting ths machine... other 2 almost equals machine
running on this host (same kernel) but with XFS on root are not affected and
very
stable.

I reattached another info file (bug-20131118084007.txt) which contains a lot of
infos.

Thanks.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
