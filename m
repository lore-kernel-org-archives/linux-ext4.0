From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 51431] ext4_mb_generate_buddy self ext4 errors
Date: Sat,  8 Dec 2012 16:38:40 +0000 (UTC)
Message-ID: <20121208163840.4D3FB11FC70@bugzilla.kernel.org>
References: <bug-51431-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:50306 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933030Ab2LHQio (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 8 Dec 2012 11:38:44 -0500
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id F16CC200C2
	for <linux-ext4@vger.kernel.org>; Sat,  8 Dec 2012 16:38:42 +0000 (UTC)
Received: from bugzilla.kernel.org (bugzilla.kernel.org [198.145.19.217])
	by mail.kernel.org (Postfix) with ESMTP id 576EF20104
	for <linux-ext4@vger.kernel.org>; Sat,  8 Dec 2012 16:38:40 +0000 (UTC)
In-Reply-To: <bug-51431-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=51431





--- Comment #3 from zakrzewskim@wp.pl  2012-12-08 16:38:39 ---
Thank you. That was what I was thinking. So there is nothing to worry about it.
I was using default CentOS 5.8 kernel which was 2.6.18.308-20 and it was kernel
panicing almost every day so I've switched to 3.0.54.

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
