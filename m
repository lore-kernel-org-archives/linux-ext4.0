From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 151491] free space lossage on busy system with bigalloc enabled
 and 128KB cluster
Date: Thu, 30 Nov 2017 16:08:41 +0000
Message-ID: <bug-151491-13602-6X9NJMdKhv@https.bugzilla.kernel.org/>
References: <bug-151491-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
To: linux-ext4@kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:59314 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752303AbdK3QIm (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>);
        Thu, 30 Nov 2017 11:08:42 -0500
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id C89322A0DD
        for <linux-ext4@vger.kernel.org>; Thu, 30 Nov 2017 16:08:41 +0000 (UTC)
In-Reply-To: <bug-151491-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=151491

--- Comment #14 from Eric Whitney (enwlinux@gmail.com) ---
I've been able to identify the unknown contributor to the delalloc accounting
error as discussed previously (in comment 10).

When ext4 is writing back a previously delalloc'ed extent that contains just a
portion of a cluster, and then delallocs an extent that contains another
disjoint portion of that same cluster, the count of delalloc'ed clusters
(i_reserved_data_blocks) is incorrectly incremented.  The cluster has been
physically allocated during writeback, but the subsequent delalloc write does
not discover that allocation.  This is because the code in ext4_da_map_blocks()
checks for a previously physically allocated block at the point of allocation
rather than a previously physically allocated cluster spanning the point of
allocation.

The effect is to bump the delalloc'ed cluster count for clusters that will
never be allocated (since they've already been allocated), and the overcount
will therefore never be reduced.

It's more likely this problem would occur when writing files sequentially if
the test system was under memory pressure, resulting in writeback activity in
parallel with delalloc writes.  The magnitude of the overcount is also likely
to be larger in this situation.  This correlates well with the observation that
the reproducer for the accounting errors is more likely to reproduce the
problem on a test system with little free memory.

I've been testing a prototype patch that appears to fix this problem.  However,
I've also identified at least two other unrelated delalloc accounting problems
for bigalloc file systems whose effects are masked by the other contributor to
overcounting in ext4_ext_map_blocks().  Fixing it results in failures caused by
these other problems when running xfstests-bld on bigalloc.  So, there's a lot
of work yet to be done before it's time to post patches.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
