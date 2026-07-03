Received: from mx0b-0064b401.pphosted.com (mx0b-0064b401.pphosted.com [205.220.178.238])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F3563D0924;
	Fri,  3 Jul 2026 13:25:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.178.238
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783085151; cv=none; b=VpD8Rldg9vuv0lrsGcZ0m4HmZVK4bFxO1zq1QdUDwFaH3OCeOd+A3t80+y4FT+SQE0oiaez4kqbYEIqtErqoblj//+tRdEnVWk9uh7VWXisWHYmRkEQpILJQgxHPPMD73sXkkkkxH5vC2EEp2q9w2yW6fKg9DkRwZmRY3CNeEs0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783085151; c=relaxed/simple;
	bh=oFdvsiLUWe74UuE2b8LKe3ZnwbztJXHus6GwA9ZPLts=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=kfEQMVS0RXtNDJfHTtM0cuLycSuq0BkwSmuzMXkk6K7Sr2Jkapk37dqiS0+VOk7J9lVDArnFogWgrwOvkM7KW8Qy8ncxngH20+xJIHpR2b8Wzp+YK49yFZSW4AMAKJ1XGxoCzhu1R9xwTme0/O7YBujIrKyINLy6Fy2HnybHcBo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=windriver.com; spf=pass smtp.mailfrom=windriver.com; dkim=pass (2048-bit key) header.d=windriver.com header.i=@windriver.com header.b=TAgeKYj4; arc=none smtp.client-ip=205.220.178.238
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=windriver.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=windriver.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=windriver.com header.i=@windriver.com header.b="TAgeKYj4"
Received: from pps.filterd (m0250811.ppops.net [127.0.0.1])
	by mx0a-0064b401.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 663BP53R009371;
	Fri, 3 Jul 2026 13:25:21 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=windriver.com;
	 h=cc:content-transfer-encoding:content-type:date:from
	:message-id:mime-version:subject:to; s=PPS06212021; bh=UPnOttJdF
	tQ/MkEv4+taxhyqI0TVParnhBgu7lpObAQ=; b=TAgeKYj4alB3SiiCK/DXnyCnU
	CjGYC1nchX33sN7ohG0MvvraYC+uKfaXoTVpPAuC2PhricVOp5ElL757B7sQBu6E
	FsR+qc0QK3Ot+GRVTA7MKv7QlBqlnC/EREthPT3EuhcRf0zzxsdqYPUKoVoGtvtA
	ShNEnW6vVSBfj5LyfcFY7fGZxRV81LE6nW8vRwIp44QE5Viz2BBVsYcg4ZwzfePx
	1H/p4YMBE69LmhVgS+jNMRPyYj+5swiuRmHwVArf7lxLBeyyLbsHqbDFoyCU+1n1
	OIbQjABe0jsyP0xY3c8CfZintvbWvJzjmYWV9Fz6YqAm2ApJQDymKsHzi5Bow==
Received: from ala-exchng02.corp.ad.wrs.com (ala-exchng02.wrs.com [128.224.246.37])
	by mx0a-0064b401.pphosted.com (PPS) with ESMTPS id 4f69av8b3a-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
	Fri, 03 Jul 2026 13:25:21 +0000 (GMT)
Received: from ala-exchng01.corp.ad.wrs.com (10.11.224.121) by
 ALA-EXCHNG02.corp.ad.wrs.com (10.11.224.122) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.61; Fri, 3 Jul 2026 06:25:20 -0700
Received: from pek-yzhou-d3.wrs.com (10.11.232.110) by
 ala-exchng01.corp.ad.wrs.com (10.11.224.121) with Microsoft SMTP Server id
 15.1.2507.61 via Frontend Transport; Fri, 3 Jul 2026 06:25:17 -0700
From: Yun Zhou <yun.zhou@windriver.com>
To: <tytso@mit.edu>, <adilger.kernel@dilger.ca>, <libaokun@linux.alibaba.com>,
        <jack@suse.cz>, <ojaswin@linux.ibm.com>, <ritesh.list@gmail.com>,
        <yi.zhang@huawei.com>
CC: <linux-ext4@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <yun.zhou@windriver.com>
Subject: [PATCH v4] ext4: fix race in ext4_convert_inline_data() leading to BUG_ON in writepages
Date: Fri, 3 Jul 2026 21:25:16 +0800
Message-ID: <20260703132517.3527261-1-yun.zhou@windriver.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzAzMDEzMiBTYWx0ZWRfX4cuHLAoESU5R
 2PP7qAxZYFArFoIOEYpjxlR91ioUqFJGmCAkNFH78oJEJzZyO1krHAJ2qrRyoZoxHcetyxUK+9M
 IVNvsGLcTQqUwK1RPYYkrWAF4gpVcRKlfvrfB3FbuVaYhiftAzIyexkpw6Q0yCA/+/uZbgbKOfA
 KIowgIQC9lYvFFeHMvm81fAIIQsgv1jGx3pL8V1P0LXWVpbly15RsSgRl5/IdOVLu/d6uaDeTb3
 ix1AkBNrK+xofCebhIf9KdH1zrVl6SN+Z3vm7z49Dby0H007NPJ+CaeQz5MJ97Bb+9yjgDLe4td
 kIpu/z1BqZB7wE6KGbCnTe8heE2SufdxT/XtQFmnVQ3/6wmFo/R61wJlqbMt9kUWdrVvW920rcm
 eS44Jsjx/LFFNIfPjPaEoNymAJOvVzNSy0cN+IryHaV1YjaB3kMBHMv1buNlqlsAsL/iMN+A9hf
 CYuYUbaLSVr089aVipQ==
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzAzMDEzMiBTYWx0ZWRfX2cAgOOnpW2hs
 z8vEwHhWZ+hVj6mmtJW4wg0lqDLJT0AD3uYg1bJicMhWARtIrhr3TPB+zO/W63iLlANRAcXO0vo
 JBB2QNRFifABpZBdVKPHAQLd5JoNg4YT0a2Sc4Lu7e7gFb8uOG+8
X-Proofpoint-GUID: Ob4fdFGNlKZe8UOZsaKVwJTPIHLjrbxZ
X-Proofpoint-ORIG-GUID: Ob4fdFGNlKZe8UOZsaKVwJTPIHLjrbxZ
X-Authority-Analysis: v=2.4 cv=MsliLWae c=1 sm=1 tr=0 ts=6a47b841 cx=c_pps
 a=Lg6ja3A245NiLSnFpY5YKQ==:117 a=Lg6ja3A245NiLSnFpY5YKQ==:17
 a=RAioF0-LDSMA:10 a=VkNPw1HP01LnGYTKEx00:22 a=bi6dqmuHe4P4UrxVR6um:22
 a=klDOsUkWDRETUCZYPvoE:22 a=edf1wS77AAAA:8 a=hSkVLCK3AAAA:8 a=t7CeM3EgAAAA:8
 a=Ec7YC5YzSVSLeTcfCwIA:9 a=DcSpbTIhAlouE1Uv7lRv:22 a=cQPPKAXgyycSBL8etih5:22
 a=FdTzh2GWekK77mhwV6Dw:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-07-03_02,2026-06-26_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 lowpriorityscore=0 priorityscore=1501 suspectscore=0 adultscore=0
 impostorscore=0 spamscore=0 bulkscore=0 malwarescore=0 clxscore=1015
 phishscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2606150000
 definitions=main-2607030132

ext4_convert_inline_data() has two unsafe lockless fast paths that can
observe a transient state from a concurrent convert_inline_data_nolock()
that has destroyed inline data but then fails and restores it.  A racing
thread sees the transient state, concludes no conversion is needed, and
creates dirty pages via block_page_mkwrite().  The restoring thread then
re-sets inline data + MAY_INLINE_DATA, leaving dirty pages coexisting
with inline data, triggering BUG_ON in ext4_do_writepages().

A similar race exists with ext4_da_convert_inline_data_to_extent():
after it copies data to page cache and clears MAY_INLINE_DATA, a
concurrent convert_inline_data_nolock() can restore MAY_INLINE_DATA.

Simply moving the MAY_INLINE_DATA check inside xattr_sem would require
taking the write lock, starting a journal handle, and reading the inode
location on every call -- even for inodes that have long since been
converted.  This causes measurable performance regression on filesystems
with the inline_data feature enabled.

Fix this by introducing EXT4_STATE_INLINE_CONVERTED, a monotonic
(set once, never cleared) per-inode state bit indicating that inline
data has been successfully copied out to page cache or a data block.
This provides:

1. A safe lockless fast path in ext4_convert_inline_data(): once the
   bit is set, return 0 after ensuring any pending writeback completes
   (via filemap_flush if has_inline_data is still set).

2. A WARN_ON_ONCE guard in convert_inline_data_nolock(): if the bit
   is unexpectedly set at restore time, warn.  This should not happen
   given the MAY_INLINE_DATA check prevents entering nolock when DA
   conversion is in progress.

3. Inside xattr_sem, only call convert_inline_data_nolock() when both
   has_inline_data AND MAY_INLINE_DATA are set.  When has_inline_data
   is set but MAY_INLINE_DATA is clear, DA conversion is in progress;
   skip convert_nolock to avoid destroy+restore re-setting MAY.

The bit is set in all successful conversion paths:
- ext4_convert_inline_data_nolock() on success
- ext4_convert_inline_data() when inline data is gone after nolock
- ext4_da_convert_inline_data_to_extent() after page cache copy
- ext4_convert_inline_data_to_extent() after block_commit_write

Fixes: 7b4cc9787fe3 ("ext4: evict inline data when writing to memory map")
Reported-by: syzbot+d1da16f03614058fdc48@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=d1da16f03614058fdc48
Signed-off-by: Yun Zhou <yun.zhou@windriver.com>
---
v4:
- Preserve filemap_flush error return in INLINE_CONVERTED fast path.
- Reword comment to match original style.

v3:
- Introduce EXT4_STATE_INLINE_CONVERTED monotonic bit for safe lockless
  fast path, avoiding performance regression from always taking xattr_sem.
- Add WARN_ON_ONCE at restore point as sanity check.
- Skip convert_nolock when MAY_INLINE_DATA is clear (DA convert in
  progress) to prevent destroy+restore re-setting MAY.

v2:
- Reworked fix: root cause confirmed via ftrace.
- Removed both unsafe lockless fast paths, serialize under xattr_sem.
- Skip convert_nolock when MAY_INLINE_DATA is clear (DA convert in
  progress) to prevent destroy+restore from re-setting MAY.

 fs/ext4/ext4.h   |  1 +
 fs/ext4/inline.c | 46 +++++++++++++++++++++++++++++++++-------------
 2 files changed, 34 insertions(+), 13 deletions(-)

diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index b9b0ada7774b..310aeb14f9f0 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -2049,6 +2049,7 @@ enum {
 	EXT4_STATE_FC_FLUSHING_DATA,	/* Fast commit flushing data */
 	EXT4_STATE_ORPHAN_FILE,		/* Inode orphaned in orphan file */
 	EXT4_STATE_FC_REQUEUE,		/* Inode modified during fast commit */
+	EXT4_STATE_INLINE_CONVERTED,	/* inline data copied out, do not restore */
 };
 
 #define EXT4_INODE_BIT_FNS(name, field, offset)				\
diff --git a/fs/ext4/inline.c b/fs/ext4/inline.c
index 8045e4ff270c..7a5898bfa3ee 100644
--- a/fs/ext4/inline.c
+++ b/fs/ext4/inline.c
@@ -671,6 +671,8 @@ static int ext4_convert_inline_data_to_extent(struct address_space *mapping,
 
 	if (folio)
 		block_commit_write(folio, from, to);
+	if (folio && !ret)
+		ext4_set_inode_state(inode, EXT4_STATE_INLINE_CONVERTED);
 out:
 	if (folio) {
 		folio_unlock(folio);
@@ -921,6 +923,7 @@ static int ext4_da_convert_inline_data_to_extent(struct address_space *mapping,
 	clear_buffer_new(folio_buffers(folio));
 	folio_mark_dirty(folio);
 	folio_mark_uptodate(folio);
+	ext4_set_inode_state(inode, EXT4_STATE_INLINE_CONVERTED);
 	ext4_clear_inode_state(inode, EXT4_STATE_MAY_INLINE_DATA);
 	*fsdata = (void *)CONVERT_INLINE_DATA;
 
@@ -1172,8 +1175,14 @@ static int ext4_convert_inline_data_nolock(handle_t *handle,
 	}
 
 out_restore:
-	if (error)
-		ext4_restore_inline_data(handle, inode, iloc, buf, inline_size);
+	if (error) {
+		WARN_ON_ONCE(ext4_test_inode_state(inode,
+					EXT4_STATE_INLINE_CONVERTED));
+		ext4_restore_inline_data(handle, inode, iloc, buf,
+					 inline_size);
+	} else {
+		ext4_set_inode_state(inode, EXT4_STATE_INLINE_CONVERTED);
+	}
 
 out:
 	brelse(data_bh);
@@ -1959,21 +1968,27 @@ int ext4_convert_inline_data(struct inode *inode)
 	handle_t *handle;
 	struct ext4_iloc iloc;
 
-	if (!ext4_has_inline_data(inode)) {
-		ext4_clear_inode_state(inode, EXT4_STATE_MAY_INLINE_DATA);
+	if (!ext4_has_feature_inline_data(inode->i_sb))
 		return 0;
-	} else if (!ext4_test_inode_state(inode, EXT4_STATE_MAY_INLINE_DATA)) {
+
+	/*
+	 * Once inline data has been successfully copied out (to page
+	 * cache or a data block), this bit is set and never cleared.
+	 * It is safe to check without locks -- the bit is monotonic.
+	 */
+	if (ext4_test_inode_state(inode, EXT4_STATE_INLINE_CONVERTED)) {
 		/*
-		 * Inode has inline data but EXT4_STATE_MAY_INLINE_DATA is
-		 * cleared. This means we are in the middle of moving of
+		 * Inode is in STATE_INLINE_CONVERTED state but still has
+		 * inline data. This means we are in the middle of moving of
 		 * inline data to delay allocated block. Just force writeout
 		 * here to finish conversion.
 		 */
-		error = filemap_flush(inode->i_mapping);
-		if (error)
-			return error;
-		if (!ext4_has_inline_data(inode))
-			return 0;
+		if (ext4_has_inline_data(inode)) {
+			error = filemap_flush(inode->i_mapping);
+			if (error)
+				return error;
+		}
+		return 0;
 	}
 
 	needed_blocks = ext4_chunk_trans_extent(inode, 1);
@@ -1990,8 +2005,13 @@ int ext4_convert_inline_data(struct inode *inode)
 	}
 
 	ext4_write_lock_xattr(inode, &no_expand);
-	if (ext4_has_inline_data(inode))
+	if (ext4_has_inline_data(inode) &&
+	    ext4_test_inode_state(inode, EXT4_STATE_MAY_INLINE_DATA))
 		error = ext4_convert_inline_data_nolock(handle, inode, &iloc);
+	if (!ext4_has_inline_data(inode)) {
+		ext4_set_inode_state(inode, EXT4_STATE_INLINE_CONVERTED);
+		ext4_clear_inode_state(inode, EXT4_STATE_MAY_INLINE_DATA);
+	}
 	ext4_write_unlock_xattr(inode, &no_expand);
 	ext4_journal_stop(handle);
 out_free:
-- 
2.43.0

