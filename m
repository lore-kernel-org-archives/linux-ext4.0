From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 14354] Bad corruption with 2.6.32-rc1 and upwards
Date: Mon, 2 Nov 2009 04:07:03 GMT
Message-ID: <200911020407.nA2473iN026023@demeter.kernel.org>
References: <bug-14354-13602@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:51952 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753768AbZKBEG6 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 1 Nov 2009 23:06:58 -0500
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.2/8.14.2) with ESMTP id nA2473Um026024
	for <linux-ext4@vger.kernel.org>; Mon, 2 Nov 2009 04:07:03 GMT
In-Reply-To: <bug-14354-13602@http.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

http://bugzilla.kernel.org/show_bug.cgi?id=14354





--- Comment #166 from Eric Sandeen <sandeen@redhat.com>  2009-11-02 04:06:56 ---
well, this time I went for many many more runs on each bisect point and came up
with:

# good: [ab86e5765d41a5eb4239a1c04d613db87bea5ed8] Merge
git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/driver-core-2.6
git bisect good ab86e5765d41a5eb4239a1c04d613db87bea5ed8

# bad: [0a80e9867db154966b2a771042e10452ac110e1e] ext4: replace MAX_DEFRAG_SIZE
with EXT_MAX_BLOCK
git bisect bad 0a80e9867db154966b2a771042e10452ac110e1e

# good: [98a56ab382079f777e261e14512cbd4fb2107af4] ext4: Fix spelling typo in
the trace format for trace_ext4_da_writepages()
# Survived 46 runs
git bisect good 98a56ab382079f777e261e14512cbd4fb2107af4

# bad: [b6a758ec3af3ec236dbfdcf6a06b84ac8f94957e] ext4: move
ext4_mb_init_group() function earlier in the mballoc.c
# Failed in 20 runs
git bisect bad b6a758ec3af3ec236dbfdcf6a06b84ac8f94957e

# bad: [daea696dbac0e33af3cfe304efbfb8d74e0effe6] ext4: Remove unneeded
BUG_ON() in ext4_move_extents()
# Failed in 40 runs
git bisect bad daea696dbac0e33af3cfe304efbfb8d74e0effe6

# good: [a3710fd1ee8cd542c5de63cf2c39f8912031f867] ext4: fix tracepoint format
string warnings
# Survived 59 runs
git bisect good a3710fd1ee8cd542c5de63cf2c39f8912031f867

# bad: [5f3481e9a80c240f169b36ea886e2325b9aeb745] ext4: fix cache flush in
ext4_sync_file
# Failed in 40 runs
git bisect bad 5f3481e9a80c240f169b36ea886e2325b9aeb745

# bad: [d0646f7b636d067d715fab52a2ba9c6f0f46b0d7] ext4: Remove journal_checksum
mount option and enable it by default
# Failed in 9 runs
git bisect bad d0646f7b636d067d715fab52a2ba9c6f0f46b0d7

So it's looking like a problem with journal checksums.  I backed that patch out
and am running the testcase overnight to convince myself that it survives
without it.  The patch itself seems fine - it just changes the default; I'm
looking at the journal checksum code to see if I can see any problem.

-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
