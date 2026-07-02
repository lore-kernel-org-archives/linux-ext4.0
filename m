Received: from mx0b-0064b401.pphosted.com (mx0b-0064b401.pphosted.com [205.220.178.238])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EFAB830D412;
	Thu,  2 Jul 2026 15:28:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.178.238
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783006084; cv=none; b=K1k5OSC7dCJFvUD7Yg3i1OX2eT41ykR6lik8CTzO6FbpyAMVlB3n6/Znwv5T0Ls7sADuc/0hb/EOGWLIsXgRP7bKSbzp0WAb5B1GY6ZDQMZWJ9iHhBjHw1rzmBCWXeftkK+Ml9393ryKmuuuGK+JvkmrGSFRpMR0h8RGDPY+jCM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783006084; c=relaxed/simple;
	bh=5eUXJ5FDvu3Ukqb7pD4PKCorbNamowsnQTxPJT9wabc=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=uj0HVuPwZN7o449S6uInUHZgEIpD04FHxlaIdgkVABieKQTJDumSTfijlAeCOM+excLx9zKcUplW7M7/7mZUjl9MUtXG03EK2J63Jh1+OvneG3ox9lKRHstfrGChCWTmxbGswUQjAyiyQNmgR/m0K9Qc3VosNKBaeLuJEB4yih4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=windriver.com; spf=pass smtp.mailfrom=windriver.com; dkim=pass (2048-bit key) header.d=windriver.com header.i=@windriver.com header.b=GvZ2tX1Z; arc=none smtp.client-ip=205.220.178.238
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=windriver.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=windriver.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=windriver.com header.i=@windriver.com header.b="GvZ2tX1Z"
Received: from pps.filterd (m0250812.ppops.net [127.0.0.1])
	by mx0a-0064b401.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 662E3xZA1908682;
	Thu, 2 Jul 2026 15:22:30 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=windriver.com;
	 h=cc:content-transfer-encoding:content-type:date:from
	:message-id:mime-version:subject:to; s=PPS06212021; bh=/w35vLLNv
	xBB1Tzw3g6sWcCRoQuPkM2OB3acch05eZI=; b=GvZ2tX1ZLrGO+YzLoPusVKlh2
	o488vZa2zo109O87KCSY6Obt0Uw8OlmocA32HY9tP2x5/L8mo6cufhFmlKIoS5wj
	JrXlPnwyeDa9CKJaqQ0vlRQTeD7AlT9Nx+669FtKzVnTmO9STWOo6vznL3uu4VWJ
	f4eNJAFK5WmiUXcBWi3qr74QKMmcdEra7AMkwTZwj4DSFDU+0MYt2p/XaG/YVGBB
	VwfYQ8QDVWiFDGZjSvTCeAYZzbmss8Vm1p7VYtovAHzcozIjk85Egk3ixeNK5E70
	2w38+jC9y3LN9PEneLh8uynHl73i5xcY6NFqtkqsSzgwRFuEY1YonIql4E9Ug==
Received: from ala-exchng01.corp.ad.wrs.com (ala-exchng01.wrs.com [128.224.246.36])
	by mx0a-0064b401.pphosted.com (PPS) with ESMTPS id 4f25g5qtd4-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
	Thu, 02 Jul 2026 15:22:30 +0000 (GMT)
Received: from ala-exchng01.corp.ad.wrs.com (10.11.224.121) by
 ala-exchng01.corp.ad.wrs.com (10.11.224.121) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.61; Thu, 2 Jul 2026 08:22:28 -0700
Received: from pek-yzhou-d3.wrs.com (10.11.232.110) by
 ala-exchng01.corp.ad.wrs.com (10.11.224.121) with Microsoft SMTP Server id
 15.1.2507.61 via Frontend Transport; Thu, 2 Jul 2026 08:22:25 -0700
From: Yun Zhou <yun.zhou@windriver.com>
To: <tytso@mit.edu>, <adilger.kernel@dilger.ca>, <libaokun@linux.alibaba.com>,
        <jack@suse.cz>, <ojaswin@linux.ibm.com>, <ritesh.list@gmail.com>,
        <yi.zhang@huawei.com>, <viro@zeniv.linux.org.uk>, <brauner@kernel.org>
CC: <linux-ext4@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <yun.zhou@windriver.com>, <linux-fsdevel@vger.kernel.org>
Subject: [PATCH v13 0/4] ext4: deferred iput framework for EA inodes
Date: Thu, 2 Jul 2026 23:22:20 +0800
Message-ID: <20260702152225.4071746-1-yun.zhou@windriver.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzAyMDE2MSBTYWx0ZWRfX9TpisIS+C7KC
 iNZV2PG0uOru3Mf2JUtBNUXvJ++z/YwMgW1mUyfyLZO7iGbPh+mEJnfjc3R8LdcGZrt/HIoeHNk
 nVRaOeMtRLzLiMpmwLmvMiuvHUEdrtUVTU9V8P7++vQ8HIfVmBT7
X-Proofpoint-ORIG-GUID: 7k874Q40-MdYsgFtOXaXzrZEFMACYoxj
X-Proofpoint-GUID: 7k874Q40-MdYsgFtOXaXzrZEFMACYoxj
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzAyMDE2MSBTYWx0ZWRfXwVNPFBp+LkUj
 /jxp/MkOLxzV9JX2ToFpXrCEFLTRmUj2HFHprfxLQWR/n8gDxI70g6avoQkIGX6BiU/i9icjPht
 sJ4ZnjNKz4Q6LSua5RaMRoeMfvOYAmCiARqfI++5pxtYgA7uvBk8En1esmxY+yXj36sQd/6lXK+
 GqbetPqy3AzC77s5NEGEG5lzCM8MG7sKdSnEjUCOoTv6Ehx+bRfR1Sju0wmU3CIDJPoZqGtbe0i
 kGYzPjGWoNzTWOIuxRt6E7xiomQuNmreWiU0bliLXGZay17kgHkbNG0bVWAH5P4r+7n+aos0TR8
 cjbAvgUxE91VHfo3rFaFzYestauaozpT8l7Hm1w4e7/BL3Nkmjk9NKcejVhK0GBYWaeaM/0wc9X
 n49eaimvXlyqyZsYG6KrNrq+CfaTOtEDUihFzMnqzs5os4bZV9ASEqxITbpo/Kkp4fz35owG3xF
 CCnIOcz8pezuh8AxSyQ==
X-Authority-Analysis: v=2.4 cv=TvLWQjXh c=1 sm=1 tr=0 ts=6a468236 cx=c_pps
 a=AbJuCvi4Y3V6hpbCNWx0WA==:117 a=AbJuCvi4Y3V6hpbCNWx0WA==:17
 a=RAioF0-LDSMA:10 a=VkNPw1HP01LnGYTKEx00:22 a=bi6dqmuHe4P4UrxVR6um:22
 a=fTW__CHxibyLmBMfj2wP:22 a=edf1wS77AAAA:8 a=V-Be077b3uO8ztIljxAA:9
 a=DcSpbTIhAlouE1Uv7lRv:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-07-02_02,2026-06-26_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 lowpriorityscore=0 spamscore=0 phishscore=0 clxscore=1015
 priorityscore=1501 bulkscore=0 suspectscore=0 impostorscore=0 adultscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2607020161

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

The only change since v12 is a minor addition of two VFS_BUG_ON_INODE
assertions in iput_if_not_last() (patch 1), as suggested by Mateusz
Guzik.  All existing Reviewed-by tags are retained.  The series has
been fully reviewed and is ready to be merged.

Link: https://syzkaller.appspot.com/bug?extid=5d19358d7eb30ffb0cc5

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
 fs/ext4/super.c    |  18 +++++-
 fs/ext4/xattr.c    | 154 +++++++++++++++++++++------------------------
 fs/ext4/xattr.h    |   9 +--
 include/linux/fs.h |  15 +++++
 6 files changed, 119 insertions(+), 96 deletions(-)

-- 
2.43.0

