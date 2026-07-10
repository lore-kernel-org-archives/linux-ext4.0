Received: from mx0b-0064b401.pphosted.com (mx0b-0064b401.pphosted.com [205.220.178.238])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B9DD36213D;
	Fri, 10 Jul 2026 03:09:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.178.238
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783652990; cv=none; b=qw5qWuwRE2LktLL5W4nPqoagHpuSqTAqV21hFQ7bW2jO0dOFN93/7CjgreHDiB+U7tBn0zFnJcnfReZqXPoAZ0SnmCvkY+JE6qn+whKKv4DoEHsAqGqHXvtZP+ROlE5qK95fDXQxLpmqS+PRNRcS5zMeTNMQkU5VxkVpZHGUxqU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783652990; c=relaxed/simple;
	bh=TfLbsC+Wmd+zeLMfBTAud3/cZxg7Mnin49jyexeGab4=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=BD8YdaF+5acaR/uzOBW22iexPzSeaMq6Jo4HwFCuaA+uuyEz04AwDvqSsMRnzgHdV1El8yLr4bn853lxv50Lcg/kIEnACd65CD4akmRgvzfiBmVzGA9hD1H9y+Ikd+8kuetLnXYzoDj3YtZ0lRVHIeh2U4gYlYWE3GBqsKjLPl4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=windriver.com; spf=pass smtp.mailfrom=windriver.com; dkim=pass (2048-bit key) header.d=windriver.com header.i=@windriver.com header.b=sz4AiY8a; arc=none smtp.client-ip=205.220.178.238
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=windriver.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=windriver.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=windriver.com header.i=@windriver.com header.b="sz4AiY8a"
Received: from pps.filterd (m0250812.ppops.net [127.0.0.1])
	by mx0a-0064b401.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66A351Gr3727693;
	Fri, 10 Jul 2026 03:08:56 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=windriver.com;
	 h=cc:content-transfer-encoding:content-type:date:from
	:message-id:mime-version:subject:to; s=PPS06212021; bh=6L0i4zeRt
	paJNIJIZIwMF7gCYWgCKKOPfoeqePOQCXs=; b=sz4AiY8ayHp5TvjPpUYRIp9hB
	FvF9OVR5Pjviy+3qjqK87hZvF7XGLYniECixmXdCNtw2KAH21rXTb68tPLHW5YTR
	5p0db0LgqKDli/MhegAy6iOWGh3y3uk4kl8cG3Y4eT5o+wD2vk0pp5lc+Yaa9K/H
	SrsptGDmHZPw/B5l2PuXD7ZLO75/JtVxhMXhy5PfFEWIVDrZMmPZQ5g+ZH2sp6lk
	juOVWfMl8blkBYE37M4Iv3PD8wEBAhv5jvRKJdoUEj4SPMuIqVoqcDPi8BWalGID
	JC9wAT3g9H9QV/7CovRwjIv9ukerablDhmftVoP0hf53aYVtOd2zdzTopAA6w==
Received: from ala-exchng01.corp.ad.wrs.com (ala-exchng01.wrs.com [128.224.246.36])
	by mx0a-0064b401.pphosted.com (PPS) with ESMTPS id 4fa1h2217q-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
	Fri, 10 Jul 2026 03:08:56 +0000 (GMT)
Received: from ala-exchng01.corp.ad.wrs.com (10.11.224.121) by
 ala-exchng01.corp.ad.wrs.com (10.11.224.121) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.61; Thu, 9 Jul 2026 20:08:55 -0700
Received: from pek-yzhou-d3.wrs.com (10.11.232.110) by
 ala-exchng01.corp.ad.wrs.com (10.11.224.121) with Microsoft SMTP Server id
 15.1.2507.61 via Frontend Transport; Thu, 9 Jul 2026 20:08:52 -0700
From: Yun Zhou <yun.zhou@windriver.com>
To: <tytso@mit.edu>, <adilger.kernel@dilger.ca>, <libaokun@linux.alibaba.com>,
        <jack@suse.cz>, <ojaswin@linux.ibm.com>, <ritesh.list@gmail.com>,
        <yi.zhang@huawei.com>, <viro@zeniv.linux.org.uk>, <brauner@kernel.org>
CC: <linux-ext4@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <yun.zhou@windriver.com>, <linux-fsdevel@vger.kernel.org>
Subject: [PATCH v14 0/4] ext4: deferred iput framework for EA inodes
Date: Fri, 10 Jul 2026 11:08:47 +0800
Message-ID: <20260710030851.2791589-1-yun.zhou@windriver.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Authority-Analysis: v=2.4 cv=LbIMLDfi c=1 sm=1 tr=0 ts=6a506248 cx=c_pps
 a=AbJuCvi4Y3V6hpbCNWx0WA==:117 a=AbJuCvi4Y3V6hpbCNWx0WA==:17
 a=RAioF0-LDSMA:10 a=VkNPw1HP01LnGYTKEx00:22 a=bi6dqmuHe4P4UrxVR6um:22
 a=fTW__CHxibyLmBMfj2wP:22 a=edf1wS77AAAA:8 a=V-Be077b3uO8ztIljxAA:9
 a=DcSpbTIhAlouE1Uv7lRv:22
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzEwMDAyNiBTYWx0ZWRfX9XtgE+mTgUM9
 ohfG+CyH4OebI6FhObsdyykpLwjKGtkZGcBn5P3O5AIBzKR1CIs/3ZZfefqoBIKyzvqmQ6y1olc
 yLsfIyWL2FtvxErQlQS8v0fZwpvjKKkGxs+QTckCFQMPTSnWoeQy
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzEwMDAyNiBTYWx0ZWRfX+CikfzjaEAv4
 q7HkJrfeyTTZn/iaozfqJVZAYG1e9i3lZBZXv2McOpEnsI3koinp8A/SHl5C+K8dSr0yEiZrUWe
 vHgoZtx+nkB3uOnPGAve9cWa/rDOZcwHl9E53i4Thn+HXsg0Y4Bjl+MBNQQWv5Zr7At0kxPIoKb
 aa/Ih9cxP+jjU+zOIat5Lz6WeEIsjtDGo142gFyNjXQUEj7nofKd/IGKkqDfuVVXSeaX4CTuc9+
 E3gk4eu4roxS3dLyOPsmZfEDvcHp5jCrNHFu6AoVIdL7HWSttff56gfetFIfFRKI4QLjcEdvSZT
 RGF2aX1xEd8vT4wOxYUC8K5Cjfg1DQLfNd12MJT01r13HNJdEkJ1D2Y/zAnhPqLo+loPI5VQrsC
 f5g3Vl5QXwKSBArqOqEer56ETusHpp4tbmaRVXMYXAjlyKv0e+w2SfDI5QePLtxe71WZCYmYFed
 47hw3MpPjlgCCVc/K3Q==
X-Proofpoint-ORIG-GUID: bsV7pxDZQzBPXor0abJngAg8Oxa49lxl
X-Proofpoint-GUID: bsV7pxDZQzBPXor0abJngAg8Oxa49lxl
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-09_04,2026-07-09_04,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 adultscore=0 phishscore=0 priorityscore=1501 malwarescore=0 clxscore=1015
 lowpriorityscore=0 bulkscore=0 suspectscore=0 spamscore=0 impostorscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2607100026

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
Annotated with __must_check to ensure callers handle the failure case.

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

Link: https://syzkaller.appspot.com/bug?extid=5d19358d7eb30ffb0cc5

v14:
 - Patch 2: add flush_delayed_work in ext4_sync_fs() to cover
   remount-ro, freeze, and sync(2) paths uniformly (suggested by
   Jan Kara).

v13:
 - Patch 1: add VFS_BUG_ON_INODE assertions in iput_if_not_last() to
   catch misuse on inodes in I_FREEING/I_CLEAR state or with zero
   refcount (suggested by Mateusz Guzik).

v12:
 - Drop patch 5 (dedup array for corrupted fs duplicate entries).
 - Simplify ext4_put_ea_inode() to take only an inode argument (sb is
   derived from inode->i_sb).

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

Yun Zhou (4):
  fs: add iput_if_not_last() helper
  ext4: introduce ext4_put_ea_inode() for safe deferred iput
  ext4: convert all EA inode iput() calls to ext4_put_ea_inode()
  ext4: remove ea_inode_array mechanism in favor of ext4_put_ea_inode()

 fs/ext4/ext4.h     |  13 +++-
 fs/ext4/inode.c    |   6 +-
 fs/ext4/super.c    |  19 +++++-
 fs/ext4/xattr.c    | 154 +++++++++++++++++++++------------------------
 fs/ext4/xattr.h    |   9 +--
 include/linux/fs.h |  15 +++++
 6 files changed, 120 insertions(+), 96 deletions(-)

-- 
2.43.0

