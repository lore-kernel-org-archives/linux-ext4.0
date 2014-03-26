From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 71641] Unreasonable performance degradation in ext4 with full
 data journaling
Date: Wed, 26 Mar 2014 13:40:42 +0000
Message-ID: <bug-71641-13602-LfCF31tFUe@https.bugzilla.kernel.org/>
References: <bug-71641-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:50489 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753526AbaCZNkp (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 26 Mar 2014 09:40:45 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 7F62120221
	for <linux-ext4@vger.kernel.org>; Wed, 26 Mar 2014 13:40:44 +0000 (UTC)
Received: from bugzilla2.web.kernel.org (bugzilla2.web.kernel.org [172.20.200.52])
	by mail.kernel.org (Postfix) with ESMTP id 4718E201BC
	for <linux-ext4@vger.kernel.org>; Wed, 26 Mar 2014 13:40:43 +0000 (UTC)
In-Reply-To: <bug-71641-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=71641

--- Comment #8 from Theodore Tso <tytso@mit.edu> ---
it's clear this isn't going to get performance up to 1.1 GB/s, but I'm curious
how much setting JBD2_NR_BATCH changes things at 512 and 1024 and possibly even
2048.   Once it no longer maters a difference, if you could do another
blktrace, and also gather lock_stat information, that would be useful.

To gather lock_stat information, enable CONFIG_LOCK_STAT, and then "echo 0  >
/proc/lock_stat" before you start the workload, and then capture the output of
/proc/lock_stat after you finish running your workload/benchmark.

If you also regather numbers with lock_stat enabled on a stock 3.11 kernel (and
also get a /proc/lock_stat report from a stock 3.11 kernel, with and without
data=journal), that would be useful.

If it turns out that there is some lock contention going on with some of the
jbd2 spinlocks, there are some patches queued for 3.15 that I may have to ask
you to try (which will mean going to something like 3.14-rc7 plus some
additional patches from the ext4 git tree).

Thanks for your benchmarking!

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
