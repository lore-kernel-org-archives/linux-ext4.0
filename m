Received: from mx0a-0064b401.pphosted.com (mx0a-0064b401.pphosted.com [205.220.166.238])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA3E3370AF9;
	Mon, 29 Jun 2026 11:09:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.166.238
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782731377; cv=none; b=EfTYutzktwy9PZfjpT7UVDm2qeQu1jhwEHUWDGB8EcZhLoxSY81Jol4QzGljQvpadzS4pmFEaFgTrz2LWpB8Zh2KnhWPo9lkHxgmPyLfV8KlXBBQkxrWrmbet+gOrBsFcTpJXbnAoZGkeav8PsPO7ngXa3ZVZ0RbaqwlJPZTwNA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782731377; c=relaxed/simple;
	bh=LxyZaXCneYwp3HgHiWayRByZZeziz+uPNFtlxo4krvA=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=tS3ONEVgURe8DUAKzyqfOihRUp3rkCwNs8kL0fk9/TqQ6LKEI5aglndr2eOxpCZe0C0AoRpnTcKzmhBKQU1BvAYP+/XbnMAZJWy4NDhB07W7V19F7BCyXrjdUe+Gzcb3xzS5YZgqI63NWqHTX0pa4pbex5eVlC+ZnRmWr+pBsmc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=windriver.com; spf=pass smtp.mailfrom=windriver.com; dkim=pass (2048-bit key) header.d=windriver.com header.i=@windriver.com header.b=sarmwxrD; arc=none smtp.client-ip=205.220.166.238
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=windriver.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=windriver.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=windriver.com header.i=@windriver.com header.b="sarmwxrD"
Received: from pps.filterd (m0250810.ppops.net [127.0.0.1])
	by mx0a-0064b401.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 65TAVTML2496113;
	Mon, 29 Jun 2026 04:08:53 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=windriver.com;
	 h=cc:content-transfer-encoding:content-type:date:from
	:message-id:mime-version:subject:to; s=PPS06212021; bh=rQ21WFO7B
	sLpjonQ9rw8LxwZgheM8uxKvPRLQSpUNpI=; b=sarmwxrDevLnekZNI57izYlIu
	paK4ERlkBzIHgdyc60aBKYRQEjDFQodKC+oeVkS5MMLKe8z3axm/+dKYPV/c7euf
	Bo0kPlhfYzKya/iUSrbdPgkggwzX03G4UXJizZ+a2LAsbw2awe2DmqbUlsPsE70W
	5xbUv/KV4qrvpoCUrTrNvan7X+hqsQ8ZNxQgyXf3IhvAbIdjRTCTghceQaPL6pMM
	ivhT3/RzX0Cm942pNGLToNY8Y1KNB4t8geE3cfKl9IlfAmvQfknei683xTGjG2or
	P525m6oOCCtnD8zc3SlwEStIbhFa0EEfX31U4xJRdwNGrwgzxGk4u1SBG3UQg==
Received: from ala-exchng01.corp.ad.wrs.com (ala-exchng01.wrs.com [128.224.246.36])
	by mx0a-0064b401.pphosted.com (PPS) with ESMTPS id 4f29syhvqq-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
	Mon, 29 Jun 2026 04:08:52 -0700 (PDT)
Received: from ala-exchng01.corp.ad.wrs.com (10.11.224.121) by
 ala-exchng01.corp.ad.wrs.com (10.11.224.121) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.61; Mon, 29 Jun 2026 04:08:51 -0700
Received: from pek-yzhou-d3.wrs.com (10.11.232.110) by
 ala-exchng01.corp.ad.wrs.com (10.11.224.121) with Microsoft SMTP Server id
 15.1.2507.61 via Frontend Transport; Mon, 29 Jun 2026 04:08:48 -0700
From: Yun Zhou <yun.zhou@windriver.com>
To: <tytso@mit.edu>, <adilger.kernel@dilger.ca>, <libaokun@linux.alibaba.com>,
        <jack@suse.cz>, <ojaswin@linux.ibm.com>, <ritesh.list@gmail.com>,
        <yi.zhang@huawei.com>, <viro@zeniv.linux.org.uk>, <brauner@kernel.org>
CC: <linux-ext4@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <yun.zhou@windriver.com>, <linux-fsdevel@vger.kernel.org>,
        <xiaowu.417@qq.com>
Subject: [PATCH v11 0/5] ext4: deferred iput framework for EA inodes
Date: Mon, 29 Jun 2026 19:08:43 +0800
Message-ID: <20260629110848.3085662-1-yun.zhou@windriver.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-GUID: OC5OGALtt3GExeMLzQzSeoTRm_CbkgJC
X-Authority-Analysis: v=2.4 cv=HsJG3UTS c=1 sm=1 tr=0 ts=6a425244 cx=c_pps
 a=AbJuCvi4Y3V6hpbCNWx0WA==:117 a=AbJuCvi4Y3V6hpbCNWx0WA==:17
 a=FelO9ux0wxsA:10 a=VkNPw1HP01LnGYTKEx00:22 a=bi6dqmuHe4P4UrxVR6um:22
 a=HK-ge7EqtdluswH-FwHe:22 a=edf1wS77AAAA:8 a=V-Be077b3uO8ztIljxAA:9
 a=DcSpbTIhAlouE1Uv7lRv:22
X-Proofpoint-ORIG-GUID: OC5OGALtt3GExeMLzQzSeoTRm_CbkgJC
X-Proofpoint-Spam-Info: AW1haW4tMjYwNjI5MDA5MCBTYWx0ZWRfXywXpoRoaxTso
 RQ2/vwTNfjqPhPUoYcJJpiURSwbicwosYbOSDaRz0oeykvihyi7VUNKVDNMnQZ+PxoGz/HOUbDU
 6qgfrxxjCVFEmPhkBAigVVzNuvzfcg0tMFMqmLhxSNQMITGGCz52
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNjI5MDA5MCBTYWx0ZWRfXzfFojjAgkb4b
 /QmX8+ijQnSVoKYkktjW8/CQPKlOYVnPJCi0Q1Qx8CKxExATvwKgMwglUisOau377eaxUOnuCrP
 8mjM8/8fsNBX02RvTJOCURe1bY6WSty7vK6ToRhI+DYRqibfpW72d3uUTcRq/e2ykdvV+E0l4+/
 kTFhkpX2rCYYJEC4W7Xzf1yElXDaNIMrNkNgmzC8EugyfeIFAdrs36wgrR+82zlmJ+SJxICzSg7
 VP6ahIByIYVKEYExtpESiidZ54H+IskLrVx+NHq/B2Y9MUMPVK3yobdzsSakWOP5o6oTew5wEtC
 iQVp9TKOs9hlGMIFAc6PrYCgxccAOGkEJyRa6bryrtI3pZrQzSqxc/EOVVzwTxBKxJVeGbzRLkv
 8H/XRQGiR73OyEhtF3gn6Xh6AGBvSmmhAE0JG8xpeIdh3H/140ax3YFtk07Cw2pequAvuy4aP9/
 gfLGtbTdM0Sdk13cFFQ==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-06-29_03,2026-06-26_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 suspectscore=0 clxscore=1015 impostorscore=0 adultscore=0
 phishscore=0 lowpriorityscore=0 bulkscore=0 malwarescore=0 spamscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2606290090

This series introduces a deferred-iput framework for EA inodes to
eliminate a class of lock ordering issues in ext4 xattr code.

The problem: iput() on EA inodes while holding xattr_sem or a jbd2
handle can trigger eviction, which may acquire those same locks or
s_writepages_rwsem, creating circular dependencies.  The immediate
deadlock (during mount-time orphan cleanup) is fixed by two separate
patches already reviewed and posted:

  ext4: skip extra isize expansion during mount to prevent deadlock
  ext4: set EXT4_STATE_NO_EXPAND in ext4_evict_inode

This series provides the structural fix that makes the code safe
regardless of calling context:

Patch 1 adds a VFS helper iput_if_not_last() which drops an inode
reference only if it is not the last one, using atomic_add_unless().
This provides a proper VFS abstraction for filesystems that need to
conditionally defer final iput.  Annotated with __must_check.

Patch 2 introduces ext4_put_ea_inode() using iput_if_not_last() as
a fast path (single atomic, zero overhead for the common case).  If
this is the last reference, the inode is linked onto a per-sb llist
(via i_ea_iput_node embedded in ext4_inode_info, union with xattr_sem
which is unused for EA inodes) and a delayed worker (1 jiffie) performs
the final iput() in a clean context.  No per-iput allocation needed.
Also moves init_rwsem(xattr_sem) from init_once to ext4_alloc_inode
to handle slab reuse after the union field has been overwritten.

Patch 3 converts all EA inode iput() calls in xattr code to use
ext4_put_ea_inode() uniformly -- no exceptions to reason about.

Patch 4 removes the now-redundant ea_inode_array mechanism (parameter
threading, struct, expand/free functions), replaced entirely by direct
ext4_put_ea_inode() calls.  This is a net code reduction.

Patch 5 prevents a potential deadlock on corrupted filesystems where
multiple xattr entries reference the same EA inode whose nlink has
dropped to zero.  It tracks such EA inode numbers in a small on-stack
array (with dynamic growth for the pathological case) and skips
duplicates before iget, eliminating the deadlock window entirely.
Legitimate EA inode dedup (ref_count > 1) is unaffected since nlink
remains > 0 after dec_ref and such entries are not added to the skip
array.

Link: https://syzkaller.appspot.com/bug?extid=5d19358d7eb30ffb0cc5

v11:
 - Patch 1: add __must_check annotation to iput_if_not_last().
 - Patch 2: remove ext4_drain_ea_inode_work() wrapper, use direct
   flush_delayed_work() at drain points.  Re-arm is not possible
   because check_igot_inode() in __ext4_iget() already rejects EA
   inodes with extended attributes, so evicting an EA inode never
   enters ext4_xattr_delete_inode().  Drop the ext4_evict_inode()
   guard (was patch 5 in v10) -- it is unnecessary given the above.
   Remove ext4_xattr_inode_array_free_deferred() intermediate function
   -- mechanism is introduced without converting any call site.
 - Patch 2: add comment on ext4_put_ea_inode() documenting why the
   inode cannot be double-queued to s_ea_inode_to_free (reviewer
   request).
 - Patch 2: simplify ext4_ea_inode_work() by removing 'next' variable.
 - Patch 5: replace per-call llist (i_ea_iput_node reuse) with a simple
   on-stack ino array + __GFP_NOFAIL dynamic growth.  This eliminates
   all concurrent access concerns on i_ea_iput_node and avoids the
   need for EXT4_STATE_EA_DEC_REF or ihold tricks.  Only EA inodes
   whose nlink drops to 0 are tracked, so legitimate dedup with
   ref_count > 1 is correctly processed multiple times.

v10:
 - New patch 5: prevent deadlock from duplicate EA inode references
   on corrupted filesystems.  Track processed EA inodes on a per-call
   llist to skip duplicates before iget, and defer ext4_put_ea_inode()
   until after the loop to avoid queuing an inode for eviction while
   the same loop may still iget it.
 - Patch 2: move ext4_init_ea_inode_work() before ext4_multi_mount_protect()
   so that failed_mount3a drain does not hit an uninitialized delayed_work
   when MMP check fails.

v9:
 - Add iput_if_not_last() as proper VFS helper (per reviewer: don't
   let filesystems manipulate inode refcount without VFS abstraction).
 - Use iput_if_not_last() + llist_node embedded in ext4_inode_info
   (union with xattr_sem) to avoid per-iput allocation entirely.
 - Convert ALL EA inode iput() calls uniformly -- no exceptions.
 - Remove entire ea_inode_array mechanism.
 - Add WARN_ON_ONCE in ext4_put_ea_inode() to catch misuse on non-EA
   inodes (protects the xattr_sem union safety).
 - Move INIT_DELAYED_WORK before journal loading (fast commit replay
   may trigger evictions).
 - Drain before ext4_quotas_off() for correct quota accounting.
 - Add flush in failed_mount_wq and failed_mount3a error paths for
   journal replay case.
 - Move init_rwsem(xattr_sem) from init_once to ext4_alloc_inode to
   handle slab object reuse after union overwrite.
 - Encapsulate worker init into ext4_init_ea_inode_work(), making
   ext4_ea_inode_work() static to xattr.c.

Yun Zhou (5):
  fs: add iput_if_not_last() helper
  ext4: introduce ext4_put_ea_inode() for safe deferred iput
  ext4: convert all EA inode iput() calls to ext4_put_ea_inode()
  ext4: remove ea_inode_array mechanism in favor of ext4_put_ea_inode()
  ext4: prevent deadlock from duplicate EA inode references on corrupted
    fs

 fs/ext4/ext4.h     |  13 ++-
 fs/ext4/inode.c    |   6 +-
 fs/ext4/super.c    |  18 +++-
 fs/ext4/xattr.c    | 209 +++++++++++++++++++++++++++------------------
 fs/ext4/xattr.h    |   9 +-
 include/linux/fs.h |  13 +++
 6 files changed, 172 insertions(+), 96 deletions(-)

-- 
2.43.0

