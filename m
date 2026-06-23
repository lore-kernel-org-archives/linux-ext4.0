Received: from mx0a-0064b401.pphosted.com (mx0a-0064b401.pphosted.com [205.220.166.238])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8DC3C374197;
	Tue, 23 Jun 2026 08:37:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.166.238
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782203844; cv=none; b=UfSWUzyYro3blFSw0/WvOYj17rOuPrYKiOlxk/66hBTF1r7s33vK7y7R0/drsAs8mf/az0nTqevvhvkRayt72aTw72XT7PooUsuVRIBZyGcz6+4MQ2Hu06qS2VDGR++wc8guOYCE8sCf++d4oWAFaoO0vBuetOuAsQccnEwx/Dc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782203844; c=relaxed/simple;
	bh=lisJrLmBHBu9i8tWtDiOz4eagCgzLFTJXhjaSkxIqwM=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=lhWlVtcJJJBM/pXmAER8LszSIYZ7Ps7IK4SU40916l5P2TtxwoIkarvHa+eyPieTVmJZabH9RG9XXcAFcswTKy2KqZd2vTV9YisOTMQJtzU6A0a77Fcn5y7nxdC4MC+3DCsDWUyhHMKdBDUg1HmR+2HpoNmsT32cQ0wMu0RggRw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=windriver.com; spf=pass smtp.mailfrom=windriver.com; dkim=pass (2048-bit key) header.d=windriver.com header.i=@windriver.com header.b=slGHk5Kg; arc=none smtp.client-ip=205.220.166.238
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=windriver.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=windriver.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=windriver.com header.i=@windriver.com header.b="slGHk5Kg"
Received: from pps.filterd (m0250809.ppops.net [127.0.0.1])
	by mx0a-0064b401.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 65N6edfA3736759;
	Tue, 23 Jun 2026 01:35:44 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=windriver.com;
	 h=cc:content-transfer-encoding:content-type:date:from
	:message-id:mime-version:subject:to; s=PPS06212021; bh=397KKE1kt
	3957pneM+4QchHNNutq6btNuZrHM0t3DNk=; b=slGHk5KgzXGmlZOYmNUzDyhnu
	L4cE+sdm/RkC7L3gpHHEB8NvbUoqU3C2W6mf5HHIPjskdUf59FqwcEqI4rFJpnfv
	1FDn4yuoBTxrFX7CbeDjElxQ2sEX1cq4a8BwsVYM36IL7F98+Lke4qdC3dwe79gV
	kwwbLLqxJdpMnCYCpHhh/gEkDrcITvYfVVz6cy2ipJCUll9fyWFbSFExC4C7y6CM
	28MUzP2KwO4vAL2QaQ28jQrQfdroBCrga+0Da4gbebA28NdQa0wJq0KtUtp6Wp6R
	40nz5bThWHg4IE2ruq8uww7UK99etnVg28/Y9N0TY+Hlf58RxHEEr+Koj2ddQ==
Received: from ala-exchng02.corp.ad.wrs.com (ala-exchng02.wrs.com [128.224.246.37])
	by mx0a-0064b401.pphosted.com (PPS) with ESMTPS id 4ewtcctun7-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
	Tue, 23 Jun 2026 01:35:44 -0700 (PDT)
Received: from ALA-EXCHNG02.corp.ad.wrs.com (10.11.224.122) by
 ALA-EXCHNG02.corp.ad.wrs.com (10.11.224.122) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.61; Tue, 23 Jun 2026 01:35:43 -0700
Received: from pek-yzhou-d3.wrs.com (10.11.232.110) by
 ALA-EXCHNG02.corp.ad.wrs.com (10.11.224.122) with Microsoft SMTP Server id
 15.1.2507.61 via Frontend Transport; Tue, 23 Jun 2026 01:35:41 -0700
From: Yun Zhou <yun.zhou@windriver.com>
To: <tytso@mit.edu>, <adilger.kernel@dilger.ca>, <libaokun@linux.alibaba.com>,
        <jack@suse.cz>, <ojaswin@linux.ibm.com>, <ritesh.list@gmail.com>,
        <yi.zhang@huawei.com>
CC: <linux-ext4@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <yun.zhou@windriver.com>
Subject: [PATCH v9 0/4] ext4: deferred iput framework for EA inodes
Date: Tue, 23 Jun 2026 16:35:36 +0800
Message-ID: <20260623083540.2744885-1-yun.zhou@windriver.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNjIzMDA2OCBTYWx0ZWRfX6bYu+zBjLovj
 7CrXliIqJp7O0J9pNrq8pHsdxcL5hgi/FFz1U3jAmh+VQKOKU88mSqhyqBOBALp7JlfAP0OKrdV
 Qym72FPDx7I91mN0+lUn5YoYtQzLOoX7GUO/aclEb0neu7JFIkSkrcEXskLehorVmcuu6mecwL0
 b+FpV3bfl6tIA6AeAru+34oKpsIKKNqPc3pzbZadINcDiI+pj4VuAnmgqZrzhJguOb1UhJtExZv
 cFitByIeu7FxxoiHfZx5Figuc2Bl/wD0TMM3noNVOYWqCYGz1sMmJHUBMFqec047omx9WFKbKb6
 aAwIWdoWSsB7FDvsa9ZSOPffVkQBBcgSJapMFZZDMXJe38XEUpEpXTKZzxkcDh/gs2ENLvmp9BM
 sDkb7DhlJ2V+cUQmXN73lMheWF0Ibz+QWq7caVkPAQKwYhBjdhwouwVZd55QUXYSBL3E8gfp38N
 DqpjhKdW+z+dXniXA6w==
X-Proofpoint-ORIG-GUID: T-diRvJgmp7_m0ISiAQEGci9UXLJLfuN
X-Authority-Analysis: v=2.4 cv=GuVyPE1C c=1 sm=1 tr=0 ts=6a3a4560 cx=c_pps
 a=Lg6ja3A245NiLSnFpY5YKQ==:117 a=Lg6ja3A245NiLSnFpY5YKQ==:17
 a=FelO9ux0wxsA:10 a=VkNPw1HP01LnGYTKEx00:22 a=bi6dqmuHe4P4UrxVR6um:22
 a=iKiJcTA2PjBS6x5JeXcw:22 a=edf1wS77AAAA:8 a=81yUN2V3KuxMimm0HBwA:9
 a=DcSpbTIhAlouE1Uv7lRv:22
X-Proofpoint-Spam-Info: AW1haW4tMjYwNjIzMDA2OCBTYWx0ZWRfXzc6Fl4Hu1iRk
 MJ3u96y9YsswDDTk7cuCm/+JQXvACKWB6nKJIHVHWZo5c4VSvUCDVUP0okieEG0Nq++1nB7vKdU
 tWoIP7gjsQjQVCuBQsjEH4WCLWD82IRmAOie8KPQQBa1fB4fedGh
X-Proofpoint-GUID: T-diRvJgmp7_m0ISiAQEGci9UXLJLfuN
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-06-23_02,2026-06-22_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 suspectscore=0 spamscore=0 clxscore=1015 phishscore=0
 adultscore=0 priorityscore=1501 impostorscore=0 bulkscore=0
 lowpriorityscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2606150000
 definitions=main-2606230068

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

Link: https://syzkaller.appspot.com/bug?extid=5d19358d7eb30ffb0cc5

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

Yun Zhou (4):
  fs: add iput_if_not_last() helper
  ext4: introduce ext4_put_ea_inode() for safe deferred iput
  ext4: convert all EA inode iput() calls to ext4_put_ea_inode()
  ext4: remove ea_inode_array mechanism in favor of ext4_put_ea_inode()

 fs/ext4/ext4.h     |  13 ++++-
 fs/ext4/inode.c    |   6 +-
 fs/ext4/super.c    |  18 +++++-
 fs/ext4/xattr.c    | 150 ++++++++++++++++++++-------------------------
 fs/ext4/xattr.h    |  21 ++++---
 include/linux/fs.h |  13 ++++
 6 files changed, 125 insertions(+), 96 deletions(-)

-- 
2.43.0

