From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 71641] Unreasonable performance degradation in ext4 with full
 data journaling
Date: Wed, 26 Mar 2014 10:30:36 +0000
Message-ID: <bug-71641-13602-2fpbOVeeaY@https.bugzilla.kernel.org/>
References: <bug-71641-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:44966 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750792AbaCZKal (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 26 Mar 2014 06:30:41 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 6EE7E20219
	for <linux-ext4@vger.kernel.org>; Wed, 26 Mar 2014 10:30:40 +0000 (UTC)
Received: from bugzilla1.web.kernel.org (bugzilla1.web.kernel.org [172.20.200.51])
	by mail.kernel.org (Postfix) with ESMTP id E1BEA2022A
	for <linux-ext4@vger.kernel.org>; Wed, 26 Mar 2014 10:30:36 +0000 (UTC)
In-Reply-To: <bug-71641-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=71641

--- Comment #7 from Chia-Hung Chang <fredchang.tc@gmail.com> ---
(In reply to Theodore Tso from comment #6)
> Could you try changing JBD2_NR_BATCH (defined in include/linux/jbd2.h) from
> 64 to 256?  If that improves, you can try 512, but that might not make a
> further difference.

Thanks for your advice. The performance has the following improvement.

data=journal     JBD2_NR_BATCH=64          -> 398MB/s
data=journal     JBD2_NR_BATCH=256         -> 412MB/s
data=ordered               ->1.1GB/s

Do you have any other suggestions?

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
