From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 72181] ext4_mb_generate_buddy:free block calculation seems to
 overflow
Date: Sun, 16 Mar 2014 04:22:35 +0000
Message-ID: <bug-72181-13602-hivNsYP2SR@https.bugzilla.kernel.org/>
References: <bug-72181-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:46703 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751000AbaCPEWh (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 16 Mar 2014 00:22:37 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id BE18520373
	for <linux-ext4@vger.kernel.org>; Sun, 16 Mar 2014 04:22:36 +0000 (UTC)
Received: from bugzilla1.web.kernel.org (bugzilla1.web.kernel.org [172.20.200.51])
	by mail.kernel.org (Postfix) with ESMTP id 5048A2034E
	for <linux-ext4@vger.kernel.org>; Sun, 16 Mar 2014 04:22:35 +0000 (UTC)
In-Reply-To: <bug-72181-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=72181

--- Comment #1 from WeiZhang <zweiustc@gmail.com> ---
usually, we just get a wrong number of "free" from bitmap while bitmap is
corrupted. but it should not larger than "max = EXT4_CLUSTERS_PER_GROUP(sb)"
right?

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
