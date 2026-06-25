Received: from mx0b-0064b401.pphosted.com (mx0b-0064b401.pphosted.com [205.220.178.238])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8857233951;
	Thu, 25 Jun 2026 15:30:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.178.238
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782401426; cv=none; b=KR7Xhz8NDf3uxd/VhwdMHoa9lq8pVe/g9cfULvej5RlyM/cbuqlx/stknbC5mZs075nDuc36LlkFIis9pfMDmntSWRbjyRV6I8y7mOaqUPpS8NkJA/uEokMxSE5agU6AiVPAbp8bppxtDNXBEoaCjj4Rqy9XsQG1Kfu8eOH8l/4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782401426; c=relaxed/simple;
	bh=bi8NI/iVORJIgoDHe+rCY6P3IRjOJMhwE0E0Szdj4AI=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=I+o4duHWVfiTIUhrLUwS9bN0nARoRxTFEFLNd8PtU9YRvIA2Awcp6p6lROCACBtxtkhu6auddQ/fTM9qx237cUtqZKwK1ph0PI1fCfKJYlfVB2bcVXQZgxMeEdmlVNXJV7463WbXBtNrG8j58EUfU/lLDtG2ruK9g0LP4/FBt4Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=windriver.com; spf=fail smtp.mailfrom=windriver.com; dkim=pass (2048-bit key) header.d=windriver.com header.i=@windriver.com header.b=gQNTjKvM; arc=none smtp.client-ip=205.220.178.238
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=windriver.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=windriver.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=windriver.com header.i=@windriver.com header.b="gQNTjKvM"
Received: from pps.filterd (m0250812.ppops.net [127.0.0.1])
	by mx0a-0064b401.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 65P3s3C0354482;
	Thu, 25 Jun 2026 15:29:47 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=windriver.com;
	 h=cc:content-transfer-encoding:content-type:date:from
	:message-id:mime-version:subject:to; s=PPS06212021; bh=cyET8+jez
	DMPEdfgnjqjSkfg27pN2ATCIOjxVCYHDoU=; b=gQNTjKvMTI+uTliCMDxYOgyiO
	MR6Q/t3iw/dnqKtH2I+NQGHsrfw6RPefc4b7vz9ib3mujRlOL9NV97nHzEnQ2dvj
	6QptPgqEO0c4AS9aS8Lga1/HUAg2WgvXVwXOL1fnSAabtjsCNivd4ULK2Yqpn6kZ
	JC7Jz1ovGLbpyqYrykCI7hXj9smqSLnf6w1GnoQeoE55Ud1Y2os1zX0VPeVzvW3j
	m2hMD/sisocwj5HMcz8okOgveWBqx1W8R9lm5gFo4+J+esCTuwq7Maz3W68YSVuk
	RutQL6ijqSSY9rVlLysBDB25RxkOTAs8X6hFq5r39pEycVJ4tYsMDzB6tZkbQ==
Received: from ala-exchng01.corp.ad.wrs.com (ala-exchng01.wrs.com [128.224.246.36])
	by mx0a-0064b401.pphosted.com (PPS) with ESMTPS id 4f0t5dgv8d-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
	Thu, 25 Jun 2026 15:29:46 +0000 (GMT)
Received: from ala-exchng01.corp.ad.wrs.com (10.11.224.121) by
 ala-exchng01.corp.ad.wrs.com (10.11.224.121) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.61; Thu, 25 Jun 2026 08:29:45 -0700
Received: from pek-yzhou-d3.wrs.com (10.11.232.110) by
 ala-exchng01.corp.ad.wrs.com (10.11.224.121) with Microsoft SMTP Server id
 15.1.2507.61 via Frontend Transport; Thu, 25 Jun 2026 08:29:42 -0700
From: Yun Zhou <yun.zhou@windriver.com>
To: <tytso@mit.edu>, <adilger.kernel@dilger.ca>, <libaokun@linux.alibaba.com>,
        <jack@suse.cz>, <ojaswin@linux.ibm.com>, <ritesh.list@gmail.com>,
        <yi.zhang@huawei.com>, <viro@zeniv.linux.org.uk>, <brauner@kernel.org>
CC: <linux-ext4@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <yun.zhou@windriver.com>, <linux-fsdevel@vger.kernel.org>
Subject: [PATCH v10 0/5] ext4: deferred iput framework for EA inodes
Date: Thu, 25 Jun 2026 23:29:36 +0800
Message-ID: <20260625152941.24788-1-yun.zhou@windriver.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-Spam-Info: AW1haW4tMjYwNjI1MDEzMiBTYWx0ZWRfX4vuOwbkB7PKZ
 aDbbsH1kFsMUKhvV8eqfZwCwo6NeVq1CMDx7JTa3ko+h/o/tzY1YyenMospVdV5nyRJYlFEHtiy
 HHGBTZzCZih+ojyu+od09o1n/hBOVzRMGyYkkSumC9Fq3ZorxrBr
X-Authority-Analysis: v=2.4 cv=HOvz0Itv c=1 sm=1 tr=0 ts=6a3d496b cx=c_pps
 a=AbJuCvi4Y3V6hpbCNWx0WA==:117 a=AbJuCvi4Y3V6hpbCNWx0WA==:17
 a=FelO9ux0wxsA:10 a=VkNPw1HP01LnGYTKEx00:22 a=bi6dqmuHe4P4UrxVR6um:22
 a=fTW__CHxibyLmBMfj2wP:22 a=edf1wS77AAAA:8 a=gLMtk1rzzRRLWMpW698A:9
 a=DcSpbTIhAlouE1Uv7lRv:22
X-Proofpoint-GUID: wcx9Rvq-6Qc9w_XQ_3IvwBcbvomlxtM9
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNjI1MDEzMiBTYWx0ZWRfX/sbvGbkLGWih
 bc4ie1pJkYl3HKUYLimgOln2foH0qpyJlLCa+duuD/gT7GacBS6pzfI0mSuuF2rzS6PrrYiAsN7
 mwFlF41uR4BQS7cKi/HCaha2dTwMS0ty9lL99rbznbWxCt8yF9+moeOWjrxsq1p7OUzara8n/s2
 Fx2c6mAWcZIiaFQAtOzbeb4fzgWxhAEOWrIpE4iCYsMV8ZDkThyyRQuuRVhon6VR+sYUGQrmdlw
 40CkyW9V1VeRHlqJ6GVQHkVWwgjXF9Xx3reEx5/RRZZFQgf2bcopAvQRz9ovrFoPxtLAV39qP/r
 WL6rF7U8YUyb/HhrNK1thWwCmmfWosylw8TAo9/woAtlE5l4uiBkaZZ/DZGkz9jduQwEK09VJn8
 75YMdxHR9ZFgyOty0tn2jZ6K/VcenGx7bjHqxNaN9kEw+Lgfm8lNo0wUIPGmVerjKVQQ9uHFnIk
 /UCCC2RGia7LzvmjvSQ==
X-Proofpoint-ORIG-GUID: wcx9Rvq-6Qc9w_XQ_3IvwBcbvomlxtM9
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-06-25_01,2026-06-24_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=0 spamscore=0 adultscore=0 phishscore=0 priorityscore=1501
 suspectscore=0 bulkscore=0 malwarescore=0 clxscore=1015 lowpriorityscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2606250132

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
conditionally defer final iput.

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

Patch 5 prevents a potential ABBA deadlock on corrupted filesystems
where multiple xattr entries reference the same EA inode.  It tracks
processed EA inodes on a per-call llist (reusing i_ea_iput_node) and
skips duplicates before iget, deferring the actual ext4_put_ea_inode()
until after the loop completes.  This covers both intra-block and
cross ibody/block duplicates in ext4_xattr_delete_inode().

Link: https://syzkaller.appspot.com/bug?extid=5d19358d7eb30ffb0cc5

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
 - Fix worker re-arm: ext4_drain_ea_inode_work() loops to handle
   nested EA inode evictions re-scheduling work.
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
 fs/ext4/super.c    |  19 +++-
 fs/ext4/xattr.c    | 214 +++++++++++++++++++++++++++------------------
 fs/ext4/xattr.h    |  21 +++--
 include/linux/fs.h |  13 +++
 6 files changed, 185 insertions(+), 101 deletions(-)

-- 
2.43.0

