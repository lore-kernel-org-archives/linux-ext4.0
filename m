From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 78651] Write performance of ext4 degrades linearly as volume
 fills
Date: Sun, 06 Jul 2014 17:57:24 +0000
Message-ID: <bug-78651-13602-SRv4NhDCsM@https.bugzilla.kernel.org/>
References: <bug-78651-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:56625 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751749AbaGFR51 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 6 Jul 2014 13:57:27 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id AE7CE2035D
	for <linux-ext4@vger.kernel.org>; Sun,  6 Jul 2014 17:57:26 +0000 (UTC)
Received: from bugzilla2.web.kernel.org (bugzilla2.web.kernel.org [172.20.200.52])
	by mail.kernel.org (Postfix) with ESMTP id 21D19202A1
	for <linux-ext4@vger.kernel.org>; Sun,  6 Jul 2014 17:57:25 +0000 (UTC)
In-Reply-To: <bug-78651-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=78651

Theodore Tso <tytso@mit.edu> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |tytso@mit.edu

--- Comment #5 from Theodore Tso <tytso@mit.edu> ---
Delayed allocation certainly works with or without the journal.  But disabling
delayed allocation will _significantly_ impact performance.   There's certainly
no surprise there.   Delalloc is one of the reasons why ext4 is significantly
more performant than ext3, and the mode that we use in Google is ext4 with
delalloc in no journal mode.

In answer to your other questions, no the es_shrink_enter and es_shrink_exit
calls are not balanced.  In particular, the ext4_es_shrink_enter tracepoint
gets called from two different functions (which is a bad thing; recent shrinker
infrastructure changes added a s_es_shrinker_.count_objects() callback, and the
person converted the ext4 shirnker over to the new setup duplicated the
tracepoint instead of creating a new one.   Also, in ext4_es_scan(), if
nr_to_scan is zero, we don't end up calling the ext4_es_shrinker_exit
tracepoint.

Some other things to try.  (1)  Try collecting copies of /proc/meminfo and
/proc/slabinfo every 10% of the dump process or so.  That might be useful.  (2)
Try reformatting with a much larger journal, and see if that makes a
difference.  I doubt it will, but it's worth a try.   (3)   Either using
/sys/kernel/debug, or the ftrace command (don't use perf; since we need the
data associated with the tracepoints, not just the count), enable the
jbd2_checkpoint and jbd2_run_stats and collect the tracepoint data during the
run.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
