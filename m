Received: from mx0b-0064b401.pphosted.com (mx0b-0064b401.pphosted.com [205.220.178.238])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23A6619D092;
	Sat, 20 Jun 2026 01:40:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.178.238
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781919623; cv=none; b=WujNjTyMAcw29rtayE6r/7duvs9t3Bv36YBLR/UZWxBamDxxWdA1I9tnFQemjJmpU9TYLSAvgwsh2nGzOFg6NyECdvOW6Vd+GENw0AsE2xRG+1hGAu2rvpSo+UhFgmFelv6tWVLs/83kC78b9igwpxgUpEgvkQC0WsFdlDMOrnE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781919623; c=relaxed/simple;
	bh=8eScCV6mKVEUviFK+VGEdLTaMce9eBM/xXU1b3AfMtc=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=Jy6FByLH98wQH7RUaA5ZH6HtGE5wq+36XbnNaDbDcHdoTfT4W8rfOJ4vrmJ6y3HeMJteWkxa/i8WJ8xkEiFJEYbMQYlh0DOXvQQyTxJDKSWhy9vzQbaYeAojaKRug66qrPi7b0wA5v3uV9bzwtWMCiJtQq25TEVxMbPXtJ1OG6g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=windriver.com; spf=pass smtp.mailfrom=windriver.com; dkim=pass (2048-bit key) header.d=windriver.com header.i=@windriver.com header.b=LG/DNnVR; arc=none smtp.client-ip=205.220.178.238
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=windriver.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=windriver.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=windriver.com header.i=@windriver.com header.b="LG/DNnVR"
Received: from pps.filterd (m0250811.ppops.net [127.0.0.1])
	by mx0a-0064b401.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 65K1U2bF3822841;
	Sat, 20 Jun 2026 01:39:42 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=windriver.com;
	 h=cc:content-transfer-encoding:content-type:date:from
	:message-id:mime-version:subject:to; s=PPS06212021; bh=sikg4BbqO
	4w0JCgJ83CtQR3V0Du35O5tTrPTmdyH3Eo=; b=LG/DNnVRaqExyhdkcknRbCGDV
	J2fbfPIehUOyQjB5tvf3rfwYKLVHD1u/1BFZC8nWHvjfx9W1p5Jmi4f5x+n5avm0
	C9Zu6JnTmL80rmyKq9YQasWUgT/J/sM6yBFJw5jYdhu6Iwh7BnQLrBKqZy0L49ne
	mkpFGRWgY2CDdDdIhEsQzWKiBg69jpkKEHy9ZU8TnYgqWrjEKfN1x/zmW7chX/c2
	w0+Apq9iNmPvfwWgKW0b6PJJ26Ho5p14MguQTSU27O8+7gs6nQYfeXtfqh0Q/1WW
	0zoz+/KKUT+JSFT4kKNQZcFCQrBuNBIpUnhpyx7pL4Xkz+qr7DcObl9D4CBqA==
Received: from ala-exchng01.corp.ad.wrs.com (ala-exchng01.wrs.com [128.224.246.36])
	by mx0a-0064b401.pphosted.com (PPS) with ESMTPS id 4ewg2wr1ss-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
	Sat, 20 Jun 2026 01:39:42 +0000 (GMT)
Received: from ala-exchng01.corp.ad.wrs.com (10.11.224.121) by
 ala-exchng01.corp.ad.wrs.com (10.11.224.121) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.61; Fri, 19 Jun 2026 18:39:40 -0700
Received: from pek-yzhou-d3.wrs.com (10.11.232.110) by
 ala-exchng01.corp.ad.wrs.com (10.11.224.121) with Microsoft SMTP Server id
 15.1.2507.61 via Frontend Transport; Fri, 19 Jun 2026 18:39:37 -0700
From: Yun Zhou <yun.zhou@windriver.com>
To: <tytso@mit.edu>, <adilger.kernel@dilger.ca>, <libaokun@linux.alibaba.com>,
        <jack@suse.cz>, <ojaswin@linux.ibm.com>, <ritesh.list@gmail.com>,
        <yi.zhang@huawei.com>
CC: <linux-ext4@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <yun.zhou@windriver.com>
Subject: [PATCH v8 0/4] ext4: fix xattr iput deadlock with s_writepages_rwsem
Date: Sat, 20 Jun 2026 09:39:33 +0800
Message-ID: <20260620013937.2564269-1-yun.zhou@windriver.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: zQbD4vKM03-evycS71jnB_5t_PPWzheU
X-Proofpoint-Spam-Info: AW1haW4tMjYwNjIwMDAxNCBTYWx0ZWRfX7WDNLH7g1F2P
 hXMbtgg9fE0eFghJdMdU1vcZ4SsE7kOWjicfZOO+gaVHHz/AM95qV/xahqKCANHH/QMuRi+zRwj
 0QzCo7dZxOvXM+irUJODWQqyDfFD8N6T+yxHghndMPin1wqnZPAf
X-Proofpoint-GUID: zQbD4vKM03-evycS71jnB_5t_PPWzheU
X-Authority-Analysis: v=2.4 cv=Xdm5Co55 c=1 sm=1 tr=0 ts=6a35ef5e cx=c_pps
 a=AbJuCvi4Y3V6hpbCNWx0WA==:117 a=AbJuCvi4Y3V6hpbCNWx0WA==:17
 a=FelO9ux0wxsA:10 a=VkNPw1HP01LnGYTKEx00:22 a=bi6dqmuHe4P4UrxVR6um:22
 a=klDOsUkWDRETUCZYPvoE:22 a=edf1wS77AAAA:8 a=Z-JQ_2aD3jRCEdb7ED0A:9
 a=DcSpbTIhAlouE1Uv7lRv:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNjIwMDAxNCBTYWx0ZWRfX4ANi9Sab+v0d
 JEsa1P21i74rjvq9ZXLnkWxqgmVRXFtQR4pV1M+xHE5fquD6W493Ju7ibWO3P/d9uswpaQL2RxQ
 KAVeQiYkW7DE856vuWe/OStwKPKJt6aNYjn718V7v04hHE2zxeRNTfcyCU3xsxtttyoEsvwiJKF
 NMvwcCHYq/h8zPkevHCzrV/WqOCy3ByMLQKpLevKKfurWOA95ttw67XAU0sZEsYezN11JvdCUy4
 YTCSKZVS5vQ+V8b+6CxbpkuwCDRyPHGmjIX8YE4/MnZWZjL9C4uAq6NMFUALk9KpEAWAxrwHmHC
 AEigb5EvjgtQjll/bDx2iiIrV0olkLxAg+PfKbT1i4Nkm4dR7CKY+9meZ1R8E2rCtoy2z93Lcdq
 AjUHZERJXAHdU8/Paicgvjfm6lyy5WzIOUZXHRkb9UUVbSwsCDnDSBEpt80RieEI9sl0HOtwmyc
 HpTy3j9aGz/T+j8Sk2Q==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-06-19_05,2026-06-18_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 lowpriorityscore=0 spamscore=0 priorityscore=1501 adultscore=0
 impostorscore=0 malwarescore=0 clxscore=1015 bulkscore=0 suspectscore=0
 phishscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2606150000
 definitions=main-2606200014

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

Patches 3-4 are a structural improvement using a per-sb delayed workqueue:

  Patch 3 introduces ext4_put_ea_inode(), which does direct iput() when
  SB_ACTIVE (zero overhead) and defers to a delayed worker (1 jiffie)
  when !SB_ACTIVE.  The delay allows multiple EA inodes to accumulate
  before the worker runs, reducing context switches.  It also converts
  the first call site (ext4_xattr_block_set release path).

  Patch 4 converts all remaining EA inode iput() calls that execute
  under xattr_sem or a jbd2 handle.  Direct iput() in pure lookup paths
  (ext4_xattr_inode_get, ext4_xattr_inode_cache_find, tmp_inode) is
  left unchanged since these do not hold locks.

Link: https://syzkaller.appspot.com/bug?extid=5d19358d7eb30ffb0cc5

v8:
 - Use delayed_work with 1 jiffie delay instead of immediate work,
   allowing EA inodes to batch before processing (per reviewer suggestion).
 - Move flush_delayed_work() in ext4_put_super() before ext4_quotas_off()
   to ensure deferred iputs complete while quota is still active.
 - Convert ext4_xattr_inode_inc_ref_all() main loop iput calls and
   ext4_xattr_inode_create() error path to ext4_put_ea_inode() for
   completeness -- eliminates all direct iput of EA inodes under locks.
 - Convert ext4_xattr_inode_dec_ref_all() ENOMEM fallback iput which
   is reachable during !SB_ACTIVE via ext4_evict_inode ->
   ext4_xattr_delete_inode -> ext4_xattr_release_block.
 - Add flush_delayed_work() in __ext4_fill_super() failed_mount_wq
   error path to prevent use-after-free if mount fails.

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
 - Split patch 3 into two for easier review: infrastructure + first
   conversion, then remaining mechanical conversions.

v6:
 - ext4_inline_data_truncate(): use local ea_inode_array instead of
   passing NULL, freed after ext4_journal_stop().

v5:
 - Split into 3 patches for easier review.
 - Add explicit !SB_ACTIVE early-return in ext4_try_to_expand_extra_isize()
   to block ALL mount-time paths.

v4:
 - Comprehensive rewrite: thread ea_inode_array through all xattr
   functions, use __GFP_NOFAIL, set EXT4_STATE_NO_EXPAND in evict.

v3:
 - Make ext4_xattr_set_handle() take ea_inode_array output parameter.

v2:
 - Defer iput() in ext4_xattr_block_set() via ea_inode_array.

v1:
 - Set EXT4_STATE_NO_EXPAND in ext4_evict_inode().

Yun Zhou (4):
  ext4: skip extra isize expansion during mount to prevent deadlock
  ext4: set EXT4_STATE_NO_EXPAND in ext4_evict_inode
  ext4: introduce ext4_put_ea_inode() for safe deferred iput
  ext4: convert remaining EA inode iput() calls to ext4_put_ea_inode()

 fs/ext4/ext4.h  |   5 +++
 fs/ext4/inode.c |  11 +++++
 fs/ext4/super.c |   6 +++
 fs/ext4/xattr.c | 114 ++++++++++++++++++++++++++++++++++++++++++------
 fs/ext4/xattr.h |   2 +
 5 files changed, 125 insertions(+), 13 deletions(-)

-- 
2.43.0

