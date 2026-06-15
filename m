Received: from mx0b-0064b401.pphosted.com (mx0b-0064b401.pphosted.com [205.220.178.238])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D938D366045;
	Mon, 15 Jun 2026 06:10:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.178.238
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781503854; cv=none; b=or/+0vcRvy0ISxa+Z3OLRwrE4X26tVoFRh5TKImznFVWYrI3Gl1QqL1nqeVt1uiGYcAU8EWHjw0y9QjXn/ICFi3w6ALxe82o5PlLJedtRJbwSTSSyw1PsyXTrmFn/s8WWE2zNg/vqn6G9Mq2gRjpspt9/yDrRek/hhD2dDJUUhw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781503854; c=relaxed/simple;
	bh=fD7S+j4dBXGvPVPnKXk5HbR3FaikKlQ1GQ3woaiex5E=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=rKW3E1E8480CbRnLb7XqvGa0AUivD2BqFtgUOlwMLO3kChoI89ao9SYh+1QfZQg+BhwHCENswCDLqua5ioyvM9nJS8m3tHguqyCIyqRaJe/rPqvH5AYR48DDa5kQz6D8vQ3G5VolWhieeUAScWrw2OiSC0b/g3xyrTi7VNJ+2Fs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=windriver.com; spf=pass smtp.mailfrom=windriver.com; dkim=pass (2048-bit key) header.d=windriver.com header.i=@windriver.com header.b=cfmUbnos; arc=none smtp.client-ip=205.220.178.238
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=windriver.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=windriver.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=windriver.com header.i=@windriver.com header.b="cfmUbnos"
Received: from pps.filterd (m0250811.ppops.net [127.0.0.1])
	by mx0a-0064b401.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 65F5pUfE161003;
	Mon, 15 Jun 2026 06:10:20 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=windriver.com;
	 h=cc:content-transfer-encoding:content-type:date:from
	:message-id:mime-version:subject:to; s=PPS06212021; bh=2COof7nKz
	xniXU0wu3qy33JexswggqQ8KVLk7O6LtVQ=; b=cfmUbnosZl4J9xHpMcQiPLlBO
	hwVv0V7YT1g3u+SQV3W1psvGH9pf5/4K4+/eBCTlRESkaz8lV5SZ1LZ0LabZYo22
	+L+cCAEIuystjjC3RNnyxmoxrGMNxNWphmzj9J7I3zLgXC5IEboMRjc05+hNC/O3
	f7s2UzdLN43r7TnfqNLQqm5PlinNR/ckbltF5quw6Qwc54GlNSBdpNuVv7ayeGS0
	ilJzPBEvCGhrIDDkH183iQHwUrA3GsnXDROqyCu7z+SkYiHhhrQnQAT/1T8GuP3I
	211vGbxELnReXz3+YVgnOdgXIJ0noLD/Q74VGN9kaP7VLTHeY388PnKnRJWcg==
Received: from ala-exchng01.corp.ad.wrs.com (ala-exchng01.wrs.com [128.224.246.36])
	by mx0a-0064b401.pphosted.com (PPS) with ESMTPS id 4ervkp2bbg-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
	Mon, 15 Jun 2026 06:10:20 +0000 (GMT)
Received: from ALA-EXCHNG02.corp.ad.wrs.com (10.11.224.122) by
 ala-exchng01.corp.ad.wrs.com (10.11.224.121) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.61; Sun, 14 Jun 2026 23:10:19 -0700
Received: from pek-yzhou-d3.wrs.com (10.11.232.110) by
 ALA-EXCHNG02.corp.ad.wrs.com (10.11.224.122) with Microsoft SMTP Server id
 15.1.2507.61 via Frontend Transport; Sun, 14 Jun 2026 23:10:16 -0700
From: Yun Zhou <yun.zhou@windriver.com>
To: <tytso@mit.edu>, <adilger.kernel@dilger.ca>, <libaokun@linux.alibaba.com>,
        <jack@suse.cz>, <ojaswin@linux.ibm.com>, <ritesh.list@gmail.com>,
        <yi.zhang@huawei.com>, <ebiggers@google.com>, <yun.zhou@windriver.com>
CC: <linux-ext4@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH v3] ext4: drop s_writepages_rwsem around inline data handling in writepages
Date: Mon, 15 Jun 2026 14:10:15 +0800
Message-ID: <20260615061015.1523668-1-yun.zhou@windriver.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNjE1MDA2MyBTYWx0ZWRfX2MS0LACXlw0Q
 o+aEJ6WQjfOiEkV9fUNPiapkiwBHnJ018TwdE1xMhVdJ7UVM+HKfrtIx5CFYtS4PHd/Psttif7C
 cBOX71QrlpBJnswGAtlfGZHz+kV7D9CNF4HU184SqWB3QGEOCpzNl2MQlS34YAxrRUWLVHt7F+X
 sZCkK46vQWrh8yIv7ATIR0ryJjfvZPAxDk9cds9KU/Yi+87qyXveq/yD6p+4K2SafVXYKnDgYBr
 WLHAeSaiiBgVD3n6b1hYX7GDjYmnXtCKlgepTupH2l5gKGbi1E2Fel0hq929Cgl3RaFg19dHHVX
 Ea2ah4yvzLHHJFillcp/LqXH7Nd1IaqHrQj421vR+Rdq5wF6Peqoh2+DF0mPLN6lKsF1QTMDekQ
 H+OV8TTWUHdkVS7cbVlKvcqoYndr1GPQ0h7IxoMGPL7sG6+gW8C/NphrQo8qWHwtAorbuy95vMi
 eHuP/ylX/+gBYJQHsJw==
X-Authority-Analysis: v=2.4 cv=BK+DalQG c=1 sm=1 tr=0 ts=6a2f974c cx=c_pps
 a=AbJuCvi4Y3V6hpbCNWx0WA==:117 a=AbJuCvi4Y3V6hpbCNWx0WA==:17
 a=FelO9ux0wxsA:10 a=VkNPw1HP01LnGYTKEx00:22 a=bi6dqmuHe4P4UrxVR6um:22
 a=klDOsUkWDRETUCZYPvoE:22 a=edf1wS77AAAA:8 a=hSkVLCK3AAAA:8 a=t7CeM3EgAAAA:8
 a=bJwlv0obxc_OLVI2mnQA:9 a=DcSpbTIhAlouE1Uv7lRv:22 a=cQPPKAXgyycSBL8etih5:22
 a=FdTzh2GWekK77mhwV6Dw:22
X-Proofpoint-Spam-Info: AW1haW4tMjYwNjE1MDA2MyBTYWx0ZWRfX/F14Xnh325ay
 COB4g4o31OZL6fZSf5lxZgeHm1itmg2CGs//aNdCMmOIgEGUC7C0PVkpbzMLasPonKMTqXV8LVf
 RrJe35IDb2yKFarFFsQmX6CkFpo2bf40u3awzQ5p4GYegui9owiw
X-Proofpoint-GUID: 5FlshfWZND0tJSOXu4OX3Ze-8lefEZ4K
X-Proofpoint-ORIG-GUID: 5FlshfWZND0tJSOXu4OX3Ze-8lefEZ4K
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-06-15_01,2026-06-12_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 adultscore=0 lowpriorityscore=0 priorityscore=1501 malwarescore=0
 clxscore=1015 bulkscore=0 suspectscore=0 impostorscore=0 spamscore=0
 phishscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2606040000
 definitions=main-2606150063

ext4_do_writepages() calls ext4_destroy_inline_data() which acquires
xattr_sem while s_writepages_rwsem is held (read).  This creates a
circular lock dependency:

  CPU0                               CPU1
  ----                               ----
  ext4_writepages()
    ext4_writepages_down_read()
      [holds s_writepages_rwsem]
                                     ext4_evict_inode()
                                       __ext4_mark_inode_dirty()
                                         ext4_expand_extra_isize_ea()
                                           ext4_xattr_block_set()
                                             [holds xattr_sem]
                                             iput(old_bh inode)
                                               write_inode_now()
                                                 ext4_writepages()
                                                   ext4_writepages_down_read()
                                                   [BLOCKED on s_writepages_rwsem]
    ext4_do_writepages()
      ext4_destroy_inline_data()
        down_write(xattr_sem)
        [BLOCKED on xattr_sem]

Fix by temporarily dropping s_writepages_rwsem for the entire inline
data handling block, including the journal handle start/stop.  The
rwsem must be dropped before ext4_journal_start() -- not between
journal_start and journal_stop -- to avoid a secondary deadlock with
ext4_change_inode_journal_flag() which takes rwsem (write) and then
calls jbd2_journal_lock_updates() waiting for active handles to stop.

This is safe because:

 - This code runs before any block mapping or IO submission, so no
   writepages state depends on the rwsem being held at this point.

 - Inline data destruction is a one-way format transition (once cleared,
   EXT4_INODE_INLINE_DATA is never set again).  The rwsem is
   re-acquired after journal_stop, ensuring format stability for the
   remainder of writepages.

 - The can_map flag identifies the ext4_writepages() path (holds rwsem)
   vs ext4_normal_submit_inode_data_buffers() (does not), so the
   drop/reacquire is skipped when the rwsem is not held.

Also check the return value of ext4_destroy_inline_data() to avoid
proceeding with an inconsistent inode format on failure.

Reported-by: syzbot+bb2455d02bda0b5701e3@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=bb2455d02bda0b5701e3
Fixes: c8585c6fcaf2 ("ext4: fix races between changing inode journal mode and ext4_writepages")
Signed-off-by: Yun Zhou <yun.zhou@windriver.com>
---
v3: Drop s_writepages_rwsem before ext4_journal_start() and reacquire
    after ext4_journal_stop(), instead of dropping between journal_start
    and journal_stop as in v2.  This avoids two issues identified in v2
    review:
    - memalloc_nofs_restore() in ext4_writepages_up_read() would clear
      PF_MEMALLOC_NOFS while the jbd2 handle is active.
    - Reacquiring s_writepages_rwsem while holding a handle creates an
      ABBA deadlock with ext4_change_inode_journal_flag() which takes
      the rwsem (write) then calls jbd2_journal_lock_updates().

v2: Instead of moving inline data handling to ext4_writepages(),
    temporarily drop s_writepages_rwsem around ext4_destroy_inline_data()
    in ext4_do_writepages(). The move approach had a race where concurrent
    writes could create dirty pages with inline data after the early check,
    and unconditional destruction without dirty pages would lose data.

v1: Moved inline data cleanup from ext4_do_writepages() to
      ext4_writepages() before acquiring s_writepages_rwsem.

 fs/ext4/inode.c | 31 ++++++++++++++++++++++++++-----
 1 file changed, 26 insertions(+), 5 deletions(-)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index c2c2d6ac7f3d..cd7588a3fa45 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -1694,6 +1694,9 @@ struct mpage_da_data {
 	struct writeback_control *wbc;
 	unsigned int can_map:1;	/* Can writepages call map blocks? */
 
+	/* Saved memalloc context from ext4_writepages_down_read() */
+	int alloc_ctx;
+
 	/* These are internal state of ext4_do_writepages() */
 	loff_t start_pos;	/* The start pos to write */
 	loff_t next_pos;	/* Current pos to examine */
@@ -2816,16 +2819,35 @@ static int ext4_do_writepages(struct mpage_da_data *mpd)
 	 * we'd better clear the inline data here.
 	 */
 	if (ext4_has_inline_data(inode)) {
-		/* Just inode will be modified... */
+		/*
+		 * Temporarily drop s_writepages_rwsem because
+		 * ext4_destroy_inline_data() acquires xattr_sem, which has
+		 * a higher lock ordering rank.  Holding both would create a
+		 * circular dependency with ext4_xattr_block_set() -> iput()
+		 * -> ext4_writepages() -> s_writepages_rwsem.
+		 *
+		 * Drop the rwsem before starting the journal handle to also
+		 * avoid a deadlock with ext4_change_inode_journal_flag(),
+		 * which takes rwsem (write) then jbd2_journal_lock_updates().
+		 */
+		if (mpd->can_map)
+			ext4_writepages_up_read(inode->i_sb, mpd->alloc_ctx);
 		handle = ext4_journal_start(inode, EXT4_HT_INODE, 1);
 		if (IS_ERR(handle)) {
+			if (mpd->can_map)
+				mpd->alloc_ctx =
+					ext4_writepages_down_read(inode->i_sb);
 			ret = PTR_ERR(handle);
 			goto out_writepages;
 		}
 		BUG_ON(ext4_test_inode_state(inode,
 				EXT4_STATE_MAY_INLINE_DATA));
-		ext4_destroy_inline_data(handle, inode);
+		ret = ext4_destroy_inline_data(handle, inode);
 		ext4_journal_stop(handle);
+		if (mpd->can_map)
+			mpd->alloc_ctx = ext4_writepages_down_read(inode->i_sb);
+		if (ret)
+			goto out_writepages;
 	}
 
 	/*
@@ -3032,13 +3054,12 @@ static int ext4_writepages(struct address_space *mapping,
 		.can_map = 1,
 	};
 	int ret;
-	int alloc_ctx;
 
 	ret = ext4_emergency_state(sb);
 	if (unlikely(ret))
 		return ret;
 
-	alloc_ctx = ext4_writepages_down_read(sb);
+	mpd.alloc_ctx = ext4_writepages_down_read(sb);
 	ret = ext4_do_writepages(&mpd);
 	/*
 	 * For data=journal writeback we could have come across pages marked
@@ -3047,7 +3068,7 @@ static int ext4_writepages(struct address_space *mapping,
 	 */
 	if (!ret && mpd.journalled_more_data)
 		ret = ext4_do_writepages(&mpd);
-	ext4_writepages_up_read(sb, alloc_ctx);
+	ext4_writepages_up_read(sb, mpd.alloc_ctx);
 
 	return ret;
 }
-- 
2.43.0

