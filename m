Received: from mx0a-0064b401.pphosted.com (mx0a-0064b401.pphosted.com [205.220.166.238])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EBE2C2E612E;
	Tue, 16 Jun 2026 15:21:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.166.238
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781623296; cv=none; b=b1C5MnZ4MLUlveMJArVm7UOD/pn9eBXHz8s3FKg5I32Grw1TYXDoHyOOsqyy3pFobKkyzZeqe7HVoWcgiPOBOlYiyH1huNbLZ2/yowQDRFqSpl/e40KZhBgrBFF+Btl9wLstIjl6HDOHl7o2oluULZ8FHNcGOb0Am7V720vRc0w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781623296; c=relaxed/simple;
	bh=HZb7byMytaMRJ4rTpa8WAtt1FI/QGl3bpoqdNWq/hfc=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=A8IuY8trSaBOvy6qFz1ZmNuyvMvuvhM64ZJ4iO0ExIm5zBQ/Oh7OFT/EoMwr9xbn+dUu7WCvIXHQcXW15lr3r+r8z6jtdAnM9oehdQ4H/+Deppj24Z40lOTnEgia11mMyvHLCeA6olRcUkPNA8sGx2iGhjBPyl8DXsYTeLmlC/A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=windriver.com; spf=pass smtp.mailfrom=windriver.com; dkim=pass (2048-bit key) header.d=windriver.com header.i=@windriver.com header.b=p63/Xdhh; arc=none smtp.client-ip=205.220.166.238
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=windriver.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=windriver.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=windriver.com header.i=@windriver.com header.b="p63/Xdhh"
Received: from pps.filterd (m0250809.ppops.net [127.0.0.1])
	by mx0a-0064b401.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 65GDuMBe3880066;
	Tue, 16 Jun 2026 08:16:02 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=windriver.com;
	 h=cc:content-transfer-encoding:content-type:date:from
	:message-id:mime-version:subject:to; s=PPS06212021; bh=+CaCMxGw5
	WQEGKLPKOAnaMi+0oCmq51kuMokpqjRha4=; b=p63/XdhhPCzpC1sGGEVup/Uls
	XILikdbLabbA13rY+usoCFV4Y34hVRoCFnUKsKKn8soJMBc2/NTOD4WvSQdppM0Q
	v5acbN8z3qpTTmjtkOWnjzimADVdpRvKLUUnogahzu5Ov/sVPR9AWjFOmF2F/PjW
	BUXRkDQMyckgyR5dQDNWGpRE/qC3pJZmXWpOkuqMHUzWgykGCwpXjCo9QSiKAwIA
	mVlVx07ZQvnq5nL5RQwfNZGdNNzP1guO+sXUPOq+JpJNbRVpL63dH2OFa3lnIaN4
	qzvbQdQUbjBBWaIfC8njcOPeO0VqrYiWj2Qc7utkxGnt5wmLynNYO27C+LNfg==
Received: from ala-exchng02.corp.ad.wrs.com (ala-exchng02.wrs.com [128.224.246.37])
	by mx0a-0064b401.pphosted.com (PPS) with ESMTPS id 4es6qdvfpp-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
	Tue, 16 Jun 2026 08:16:01 -0700 (PDT)
Received: from ala-exchng01.corp.ad.wrs.com (10.11.224.121) by
 ALA-EXCHNG02.corp.ad.wrs.com (10.11.224.122) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.61; Tue, 16 Jun 2026 08:16:01 -0700
Received: from pek-yzhou-d3.wrs.com (10.11.232.110) by
 ala-exchng01.corp.ad.wrs.com (10.11.224.121) with Microsoft SMTP Server id
 15.1.2507.61 via Frontend Transport; Tue, 16 Jun 2026 08:15:58 -0700
From: Yun Zhou <yun.zhou@windriver.com>
To: <tytso@mit.edu>, <adilger.kernel@dilger.ca>, <libaokun@linux.alibaba.com>,
        <jack@suse.cz>, <ojaswin@linux.ibm.com>, <ritesh.list@gmail.com>,
        <yi.zhang@huawei.com>
CC: <linux-ext4@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <yun.zhou@windriver.com>
Subject: [PATCH v7 0/4] ext4: fix xattr iput deadlock with s_writepages_rwsem
Date: Tue, 16 Jun 2026 23:15:54 +0800
Message-ID: <20260616151558.1728881-1-yun.zhou@windriver.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Authority-Analysis: v=2.4 cv=DLq/JSNb c=1 sm=1 tr=0 ts=6a3168b1 cx=c_pps
 a=Lg6ja3A245NiLSnFpY5YKQ==:117 a=Lg6ja3A245NiLSnFpY5YKQ==:17
 a=FelO9ux0wxsA:10 a=VkNPw1HP01LnGYTKEx00:22 a=bi6dqmuHe4P4UrxVR6um:22
 a=iKiJcTA2PjBS6x5JeXcw:22 a=edf1wS77AAAA:8 a=SbkPr1n1RUiVGg3ktTkA:9
 a=DcSpbTIhAlouE1Uv7lRv:22
X-Proofpoint-GUID: 5Q6aS_P-PFIWSq6T1RdxjZhUKshhD4Co
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNjE2MDE1NiBTYWx0ZWRfXys/Lb+ViofSE
 HicXzMTMxxuHvOcYtFnaqsryyMKTxqmTgWe/E5Q1dM9AWSEnyu+bTzhhHsvGS76uF7INRKTdbyL
 4+2oDonX2k+DwWNcPoAMbqGbvE3ycnfBFBurTMAkiICswVzxlb/FvCYaWkRcshClXe2jpJvncWg
 Y+Q/oIgtyJm3YzKsUY1tOeGLzKSam7gxrtXyxoSevb+S/MCqbJKqlZHNRoqPGGpcSVIQ3MXPjnb
 072fSwZViVdqrRlCX/LEMeqg/05NS0YK+zLBjKW8nPjAmsv9kBBzcj3xEzi6I6I6oj5CkCy5RC/
 Nvh1Rilvh8cCyAfco32iXstTroTURSHZJx/4nIkHH4Oy3OZVrSHhJwV2FQ45u/JsXjuek7s6zSI
 lh9O7WT/+bsx2vbLInVN624m0RTggu0j6bGoXYAcfNyY/GrIyuho6VEZlq0LD9d3NvtRF7AGpHm
 7jzefasz6xcWVmlJPYg==
X-Proofpoint-Spam-Info: AW1haW4tMjYwNjE2MDE1NiBTYWx0ZWRfXyf8aydZkqi9y
 smGfOQEX9gxHnW49ZdByRK90kuX5+HvPmeUL0+2yOUvrlEQjLPjPESqDWGjsrJuYrbo1jrx+qbk
 /pW8w6jE38oK+pMp1zDMbKE17a9jpJdzo1nkfEYa9Ax7oJT8l/YL
X-Proofpoint-ORIG-GUID: 5Q6aS_P-PFIWSq6T1RdxjZhUKshhD4Co
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-06-16_04,2026-06-15_04,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 priorityscore=1501 suspectscore=0 phishscore=0 adultscore=0
 impostorscore=0 spamscore=0 bulkscore=0 malwarescore=0 lowpriorityscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606040000 definitions=main-2606160156

This series fixes a circular lock dependency reported by syzbot:

  s_writepages_rwsem --> jbd2_handle --> xattr_sem --> s_writepages_rwsem

The deadlock occurs when iput() on an EA inode triggers write_inode_now()
while xattr_sem and a jbd2 handle are held.  The triggering path is
during mount-time orphan cleanup (!SB_ACTIVE) where iput_final() calls
write_inode_now() synchronously.

Patch 1 blocks the deadlock by skipping extra isize expansion when
!SB_ACTIVE -- this prevents the xattr manipulation path from being
entered during mount.

Patch 2 is a belt-and-suspenders semantic improvement: an inode under
eviction never needs extra isize expansion.

Patches 3-4 are a structural improvement using a per-sb workqueue:

  Patch 3 introduces ext4_put_ea_inode(), which does direct iput() when
  SB_ACTIVE (zero overhead) and defers to a workqueue when !SB_ACTIVE.
  It also converts the first call site (ext4_xattr_block_set release
  path) which previously called iput under xattr_sem + jbd2 handle.

  Patch 4 converts the remaining EA inode iput() calls that execute
  under locks.  Sites where direct iput() is provably safe (i_nlink=0
  after dec_ref, or lookup-only paths) are left unchanged with comments.

Link: https://syzkaller.appspot.com/bug?extid=5d19358d7eb30ffb0cc5

v7:
 - Replaced the deferred-iput array threading approach (v4-v6) with a
   simpler per-sb workqueue + lock-free llist design.  No function
   signature changes needed.  ext4_put_ea_inode() does direct iput when
   SB_ACTIVE (zero overhead in normal operation) and defers to the
   workqueue only during mount (!SB_ACTIVE).
 - Converted the iput in ext4_xattr_delete_inode()'s quota accounting
   loop to ext4_put_ea_inode() to eliminate a lockdep-reportable lock
   ordering violation (jbd2_handle -> iput -> s_writepages_rwsem).
 - Moved flush_work() before the if (sbi->s_journal) check in
   ext4_put_super() to cover nojournal mode.

v6:
 - ext4_inline_data_truncate(): use local ea_inode_array instead of
   passing NULL, freed after ext4_journal_stop().  Fixes a deadlock
   reachable via crafted filesystem where inline data xattr entry has
   e_value_inum set: orphan cleanup -> ext4_truncate ->
   ext4_inline_data_truncate -> iput under !SB_ACTIVE.

v5:
 - Split into 3 patches for easier review.
 - Add explicit !SB_ACTIVE early-return in ext4_try_to_expand_extra_isize()
   to block ALL mount-time paths (ext4_process_orphan -> ext4_truncate ->
   ext4_mark_inode_dirty), not just the eviction path. v4 only relied on
   EXT4_STATE_NO_EXPAND which doesn't cover orphan truncation.

v4:
 - Comprehensive rewrite of the deferred iput mechanism.
 - Thread ea_inode_array through ext4_expand_extra_isize_ea() and
   ext4_xattr_move_to_block() so ALL ea_inode iputs in the expand
   path are deferred, not just those in ext4_xattr_block_set().
 - Add NULL safety to ext4_expand_inode_array(): when ea_inode_array
   pointer is NULL, fall back to synchronous iput (for callers like
   ext4_initxattrs that only run with SB_ACTIVE).
 - Use __GFP_NOFAIL to guarantee deferred array growth, eliminating
   fallback to synchronous iput under locks.
 - Update ext4_xattr_ibody_set() and ext4_xattr_set_entry() signatures
   to accept ea_inode_array, converting ALL iput(ea_inode) calls.
 - Set EXT4_STATE_NO_EXPAND in ext4_evict_inode() before
   ext4_mark_inode_dirty().

v3:
 - Check ext4_expand_inode_array() return value; fallback to
   direct iput() on ENOMEM to prevent inode leak.
 - Make ext4_xattr_set_handle() take an optional ea_inode_array
   output parameter so callers can free after ext4_journal_stop(),
   avoiding the jbd2_handle vs s_writepages_rwsem AB-BA.
 - Pass ea_inode_array directly to ext4_xattr_release_block()
   instead of using a local array freed under xattr_sem.
 - Move ext4_xattr_inode_array_free() after ext4_journal_stop()

v2:
 - Defer iput() in ext4_xattr_block_set() via ea_inode_array,
   freed after xattr_sem is released. Fixes the root cause.

v1:
 - Set EXT4_STATE_NO_EXPAND in ext4_evict_inode() to skip expand
   on inodes being deleted. Only fixes the syzbot reproducer, not
   the underlying lock ordering violation.

Yun Zhou (4):
  ext4: skip extra isize expansion during mount to prevent deadlock
  ext4: set EXT4_STATE_NO_EXPAND in ext4_evict_inode
  ext4: introduce ext4_put_ea_inode() for safe deferred iput
  ext4: convert remaining EA inode iput() calls to ext4_put_ea_inode()

 fs/ext4/ext4.h  |   5 +++
 fs/ext4/inode.c |  11 +++++
 fs/ext4/super.c |   6 +++
 fs/ext4/xattr.c | 105 +++++++++++++++++++++++++++++++++++++++++++-----
 fs/ext4/xattr.h |   2 +
 5 files changed, 120 insertions(+), 9 deletions(-)

-- 
2.43.0

