From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 45621] Kernel ooops: BUG: unable to handle kernel paging
 request at 000000080000001c
Date: Wed,  7 Nov 2012 09:58:40 +0000 (UTC)
Message-ID: <20121107095840.2D82111FB59@bugzilla.kernel.org>
References: <bug-45621-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:59096 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751927Ab2KGJ6o (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 7 Nov 2012 04:58:44 -0500
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 4AA29201E4
	for <linux-ext4@vger.kernel.org>; Wed,  7 Nov 2012 09:58:43 +0000 (UTC)
Received: from bugzilla.kernel.org (bugzilla.kernel.org [198.145.19.217])
	by mail.kernel.org (Postfix) with ESMTP id BA425201F3
	for <linux-ext4@vger.kernel.org>; Wed,  7 Nov 2012 09:58:40 +0000 (UTC)
In-Reply-To: <bug-45621-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=45621


Ivan Shapovalov <intelfx100@gmail.com> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |intelfx100@gmail.com




--- Comment #7 from Ivan Shapovalov <intelfx100@gmail.com>  2012-11-07 09:58:39 ---
This (or similar) seems to be reproducible with reiser4 (another out-of-tree
filesystem) on a custom kernel.

Symptoms:
1) on newly allocated pages, sometimes page_private(pg) != 0ul
2) sometimes BUGs happen on 0000_0000_0000_000e in a following scenario:
pg = find_or_create_page(...);
// check for pg != NULL
// pg->mapping is accessed

Happens 2-3 times a day. Also different BUGs happened (addresses 0016, 00b0,
0f91) but the backtraces seem to be invalid and I can't describe the actual
in-code scenario.

Directly observed on kernels 3.2 to latest stable (but current reiser4
maintainer, Edward Shishkin, seen this on 2.6.39 - though just 1-2 times at
all).

In my case, the kernel is vanilla + -ck patchset + various config changes (KSM,
big pagetables, cleancache+frontswap+zcache, sparse memory model, transparent
hugepages).
The config is here: ftp://intelfx.homeip.net/kernel_config
Hardware is Acer 3830TG (HM65 chipset, SNB cpu, 4 GB of RAM). Running in x86_64
mode.

I know that this is too small level of detail - but can anything be done to
track down/collect more info?

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
