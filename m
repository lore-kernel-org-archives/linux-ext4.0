From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 107301] system hang during ext4 xattr operation
Date: Sat, 07 Nov 2015 15:24:34 +0000
Message-ID: <bug-107301-13602-ABplKwzMFH@https.bugzilla.kernel.org/>
References: <bug-107301-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:53517 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753432AbbKGPYi (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 7 Nov 2015 10:24:38 -0500
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id E03B12063E
	for <linux-ext4@vger.kernel.org>; Sat,  7 Nov 2015 15:24:36 +0000 (UTC)
Received: from bugzilla2.web.kernel.org (bugzilla2.web.kernel.org [172.20.200.52])
	by mail.kernel.org (Postfix) with ESMTP id 19FF3205EE
	for <linux-ext4@vger.kernel.org>; Sat,  7 Nov 2015 15:24:35 +0000 (UTC)
In-Reply-To: <bug-107301-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=107301

--- Comment #5 from Laurent GUERBY <laurent@guerby.net> ---
My reading of the mbcache code is that

cache->c_max_entries = bucket_count << 4

is limiting to on average 16 entries per bucket. For ext4 bucket_bits is 10 so
1024 buckets.

Once the cache is full which is very likely situation given ceph use of xattr
with differing values all ceph threads will compete for the global mbcache
locks on *each* xattr operation.

Am I correct here?

ceph is designed to have one process managing one non shared device the mbcache
design is very likely limiting scalability here by having global locks. Plus
probably has a locking bug.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
