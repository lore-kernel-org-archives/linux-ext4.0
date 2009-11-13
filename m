From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 9502] ext4 bitmap allocator must limit blocks to < 2^32
Date: Fri, 13 Nov 2009 22:16:25 GMT
Message-ID: <200911132216.nADMGPca016350@demeter.kernel.org>
References: <bug-9502-13602@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:33493 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755973AbZKMWQT (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 13 Nov 2009 17:16:19 -0500
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.2/8.14.2) with ESMTP id nADMGPtr016351
	for <linux-ext4@vger.kernel.org>; Fri, 13 Nov 2009 22:16:25 GMT
In-Reply-To: <bug-9502-13602@http.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

http://bugzilla.kernel.org/show_bug.cgi?id=9502


Eric Sandeen <sandeen@redhat.com> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
             Status|NEW                         |RESOLVED
         Resolution|                            |CODE_FIX
         AssignedTo|fs_ext4@kernel-bugs.osdl.or |sandeen@redhat.com
                   |g                           |
         Regression|---                         |No




--- Comment #5 from Eric Sandeen <sandeen@redhat.com>  2009-11-13 22:16:21 ---
Should be fixed in 2.6.32 by:

commit fb0a387dcdcd21aab1b09ee7fd80b7c979bdbbfd
Author: Eric Sandeen <sandeen@redhat.com>
Date:   Wed Sep 16 14:45:10 2009 -0400

    ext4: limit block allocations for indirect-block files to < 2^32

    Today, the ext4 allocator will happily allocate blocks past
    2^32 for indirect-block files, which results in the block
    numbers getting truncated, and corruption ensues.

    This patch limits such allocations to < 2^32, and adds
    BUG_ONs if we do get blocks larger than that.

    This should address RH Bug 519471, ext4 bitmap allocator
    must limit blocks to < 2^32

    * ext4_find_goal() is modified to choose a goal < UINT_MAX,
      so that our starting point is in an acceptable range.

    * ext4_xattr_block_set() is modified such that the goal block
      is < UINT_MAX, as above.

    * ext4_mb_regular_allocator() is modified so that the group
      search does not continue into groups which are too high

    * ext4_mb_use_preallocated() has a check that we don't use
      preallocated space which is too far out

    * ext4_alloc_blocks() and ext4_xattr_block_set() add some BUG_ONs

    No attempt has been made to limit inode locations to < 2^32,
    so we may wind up with blocks far from their inodes.  Doing
    this much already will lead to some odd ENOSPC issues when the
    "lower 32" gets full, and further restricting inodes could
    make that even weirder.

    For high inodes, choosing a goal of the original, % UINT_MAX,
    may be a bit odd, but then we're in an odd situation anyway,
    and I don't know of a better heuristic.

    Signed-off-by: Eric Sandeen <sandeen@redhat.com>
    Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>

-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
