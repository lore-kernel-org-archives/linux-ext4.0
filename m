From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 151491] free space lossage on busy system with bigalloc enabled
 and 128KB cluster
Date: Thu, 16 Nov 2017 23:54:44 +0000
Message-ID: <bug-151491-13602-N5TCyglqbB@https.bugzilla.kernel.org/>
References: <bug-151491-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
To: linux-ext4@kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:56366 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752452AbdKPXyp (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>);
        Thu, 16 Nov 2017 18:54:45 -0500
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id C56812AA07
        for <linux-ext4@vger.kernel.org>; Thu, 16 Nov 2017 23:54:44 +0000 (UTC)
In-Reply-To: <bug-151491-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=151491

Eric Whitney (enwlinux@gmail.com) changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |enwlinux@gmail.com

--- Comment #10 from Eric Whitney (enwlinux@gmail.com) ---
I've been able to reproduce the reported problem on my test system running a
4.14 x86-64 kernel with the supplied test script.  Thanks for supplying it!

The block reporting errors from du and df are likely caused by delayed
allocation accounting bugs.  Experiments with an instrumented kernel show that
the number of delayed allocated blocks is occasionally overcounted as the test
files are physically allocated, leaving a residual value behind once allocation
is complete.  This residual value remains once a file has been fully written
out or deleted, and distorts the results reported by du or df.  Interestingly,
the overcounting isn't deterministic and varies from run to run.

Part of the overcounting appears due to code in ext4_ext_map_blocks() that
increases i_reserved_data_blocks when new clusters are allocated.  This code
has been previously implicated in other observed failures and in this case
appears to contribute some but not always all of the overcounted clusters seen
when running the test script.  Kernel traces indicate that there is usually
another as yet unknown contributor to the overcount.

Ted has suggested a temporary workaround which can be used to avoid the
reported problems, though it may have a significant workload-dependent
performance impact.  Delayed allocation can simply be disabled by using the
nodelalloc mount option.  I've tested this with repeated runs of the supplied
test script, and it avoids the reported problems as expected.

Reverting "ext4: don't release reserved space for previously allocated cluster"
(9d21c9fs2cc2) isn't an attractive option because doing so would expose users
to potential data loss.  The purpose of the patch was to fix cases where the
number of outstanding delayed allocation blocks were undercounted. 
Undercounting can lead to unexpected free space exhaustion at writeback time,
among other things.

I'll see what more I can learn from some additional experimentation.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
