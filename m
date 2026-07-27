Received: from mx0b-0064b401.pphosted.com (mx0b-0064b401.pphosted.com [205.220.178.238])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F35E43F8ED1;
	Mon, 27 Jul 2026 10:55:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.178.238
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785149753; cv=none; b=jyIYnYePLjAZmkbkX6yHs/kPpQFDdasoehbGRD2vGd5CyqzoU4Owd0drXs9cCqFg9mTHwbqvFCbvrtYnAPDMyNBOA7DCHYi6xeXzsz730xIE3VhXjO+rjIrzuR/I1GIV0kgDOah4vIK9l594Eso0k1FeHH+HZI4oVRoobW62QWA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785149753; c=relaxed/simple;
	bh=Dwx97dyyF2c0e8vc+xngcgwqeE0JlwA537EbQg+fvGQ=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=HduGC8l3KN4s4pE7m6RAzcuTyBB1cGi0QoKBsjofhMM/pYLsMSXZnWpXKnC7f0G/0JN9D3d/QykaCbjOTk+pcNuaeRk+9CPZG329rB4i7HuCPolMylPoc+zcBls51fquqHBetKzOeerDpnB24NhXD4bZpNyJP9O/0rO/ZssLSfg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=windriver.com; spf=fail smtp.mailfrom=windriver.com; dkim=pass (2048-bit key) header.d=windriver.com header.i=@windriver.com header.b=L3hOX3k/; arc=none smtp.client-ip=205.220.178.238
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=windriver.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=windriver.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=windriver.com header.i=@windriver.com header.b="L3hOX3k/"
Received: from pps.filterd (m0250812.ppops.net [127.0.0.1])
	by mx0a-0064b401.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66RANwXH348215;
	Mon, 27 Jul 2026 10:55:00 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=windriver.com;
	 h=cc:content-transfer-encoding:content-type:date:from
	:in-reply-to:message-id:mime-version:references:subject:to; s=
	PPS06212021; bh=HkXcXHP5GEvUC1HDk0q9vPhPph5J/8SPhYzoGOyflNw=; b=
	L3hOX3k/luJZfQy0ZtmrRFihgodFhYYhNunz2JphqYsmzLXWiNwAFEJoyeE3YIWg
	ZyA+bBMiLk060KqWQU+E0gh86sCPLMdjeadrRa+8+xWGacc2uVx9iYBMexn0D1ch
	eqPPwMVwY15G17RWKH6ncofHDClHbgWydk6ZCOglhzjy1D7P5DmBcBGMGr9CmpK2
	RNdr7GBwW2wku4WWoBiutrU8dWGApr2AfIwLzvc3WtF3ZxzNi8kxrhc7VTIR1Raq
	7M+SVcDqhH5nkSPnvzaHguQl8+XTXfc9Y7j4WsH7S151uabgaknQEhAerv1tHxGp
	QCwb+UlsPMk7iVd8vcKhTw==
Received: from ala-exchng01.corp.ad.wrs.com (ala-exchng01.wrs.com [128.224.246.36])
	by mx0a-0064b401.pphosted.com (PPS) with ESMTPS id 4fmm43t18t-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
	Mon, 27 Jul 2026 10:55:00 +0000 (GMT)
Received: from ALA-EXCHNG02.corp.ad.wrs.com (10.11.224.122) by
 ala-exchng01.corp.ad.wrs.com (10.11.224.121) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.61; Mon, 27 Jul 2026 03:54:59 -0700
Received: from pek-yzhou-d3.wrs.com (10.11.232.110) by
 ALA-EXCHNG02.corp.ad.wrs.com (10.11.224.122) with Microsoft SMTP Server id
 15.1.2507.61 via Frontend Transport; Mon, 27 Jul 2026 03:54:56 -0700
From: Yun Zhou <yun.zhou@windriver.com>
To: <tytso@mit.edu>, <adilger.kernel@dilger.ca>, <libaokun@linux.alibaba.com>,
        <jack@suse.cz>, <ojaswin@linux.ibm.com>, <ritesh.list@gmail.com>,
        <yi.zhang@huawei.com>
CC: <linux-ext4@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <yun.zhou@windriver.com>
Subject: [RFC PATCH 5/9] ext4: remove dead inline data write code
Date: Mon, 27 Jul 2026 18:54:37 +0800
Message-ID: <20260727105441.3213095-6-yun.zhou@windriver.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260727105441.3213095-1-yun.zhou@windriver.com>
References: <20260727105441.3213095-1-yun.zhou@windriver.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Authority-Analysis: v=2.4 cv=I/JVgtgg c=1 sm=1 tr=0 ts=6a673904 cx=c_pps
 a=AbJuCvi4Y3V6hpbCNWx0WA==:117 a=AbJuCvi4Y3V6hpbCNWx0WA==:17
 a=RAioF0-LDSMA:10 a=VkNPw1HP01LnGYTKEx00:22 a=bi6dqmuHe4P4UrxVR6um:22
 a=fTW__CHxibyLmBMfj2wP:22 a=t7CeM3EgAAAA:8 a=o9yudBK0RVXxuc10qUsA:9
 a=FdTzh2GWekK77mhwV6Dw:22
X-Proofpoint-GUID: kjNY2GzoScegDoWLTPyMYoEznb9kLmKi
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzI3MDEwNiBTYWx0ZWRfXxbDD1YSPt0rr
 jpzraW+fHTZy5nleQYd0hPZeJ81BngsqXdZLnTkYEN2nbXlLU2ZUYREmdqfs/1tPvBMQnuuhQBs
 DArm6nNLlol+mO95ihhgThyAc+CF9i3Yk5SstB/PNSsOES0WMpdTqlHdpQxjrt41Bw2bB0IU4pe
 trKVnxfjeV6hp2wWW0RtyAOjHXMEYGgKlsK+2/CQqhwyHYjN6ux4cIWrPHVuP/5LKfqwyjdb2pm
 7ASM4MR7g8IuCul1i1ZO/EfWF2oyXU6cUa2iiEbsC8q83SAknIs9rClsRcR5+osqYmiwRTHN5Qo
 9CWMfWgL35K+sP81XbdmPfgctxou4rytMyyFaq72/bzvoEgiIHNnONUPdDmNH3NGqKqBRL0ibQ6
 jRFawl7uLCcD3bqfDnHEiEgpp1gfBM1+m4xfuuDWjZnKhYxvl/TGASkpcdYkf/Ie4clIyclqA+N
 dtVQ+XNku3RW+tjwnyA==
X-Proofpoint-ORIG-GUID: kjNY2GzoScegDoWLTPyMYoEznb9kLmKi
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzI3MDEwNiBTYWx0ZWRfX8+WgzSjU5row
 7WIux9Mz45VdOyDXh+dErSVv7UN2Am7Df8kuMb6JWG+Fc/SvOIbYzwW6LkA5JNIXzpf1jFfIGqf
 gHCIqtI4MNdgu+iBsCbSUz0YQ7qs9R253zv8kv9AqKB/5ghlCumg
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-27_03,2026-07-24_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 suspectscore=0 bulkscore=0 impostorscore=0 malwarescore=0 clxscore=1015
 phishscore=0 adultscore=0 priorityscore=1501 lowpriorityscore=0 spamscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2607270106

Now that inline data write paths for regular files always convert to
block format, the following unreachable dead code is removed:

- ext4_write_inline_data_end(): was called from write_end when
  EXT4_WRITE_DATA_INLINE was set in fsdata, which no longer happens
- ext4_convert_inline_data_to_extent(): was the unsafe convert path
  (no restore on failure), replaced by ext4_convert_inline_data()
- EXT4_WRITE_DATA_INLINE flag and all associated checks in inode.c

Signed-off-by: Yun Zhou <yun.zhou@windriver.com>
---
 fs/ext4/ext4.h   |   3 -
 fs/ext4/inline.c | 210 -----------------------------------------------
 fs/ext4/inode.c  |  22 -----
 3 files changed, 235 deletions(-)

diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index 5f0448b960fe..832bc1f3b600 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -3148,7 +3148,6 @@ int do_journal_get_write_access(handle_t *handle, struct inode *inode,
 				struct buffer_head *bh);
 void ext4_set_inode_mapping_order(struct inode *inode);
 #define FALL_BACK_TO_NONDELALLOC 1
-#define EXT4_WRITE_DATA_INLINE	 2
 
 typedef enum {
 	EXT4_IGET_NORMAL =	0,
@@ -3759,8 +3758,6 @@ extern int ext4_destroy_inline_data(handle_t *handle, struct inode *inode);
 extern void ext4_update_final_de(void *de_buf, int old_size, int new_size);
 
 int ext4_readpage_inline(struct inode *inode, struct folio *folio);
-int ext4_write_inline_data_end(struct inode *inode, loff_t pos, unsigned len,
-			       unsigned copied, struct folio *folio);
 extern int ext4_generic_write_inline_data(struct address_space *mapping,
 					  struct inode *inode,
 					  loff_t pos, unsigned len,
diff --git a/fs/ext4/inline.c b/fs/ext4/inline.c
index 0803fa8eade7..5c6202add3d8 100644
--- a/fs/ext4/inline.c
+++ b/fs/ext4/inline.c
@@ -568,122 +568,6 @@ int ext4_readpage_inline(struct inode *inode, struct folio *folio)
 	return ret >= 0 ? 0 : ret;
 }
 
-static int ext4_convert_inline_data_to_extent(struct address_space *mapping,
-					      struct inode *inode)
-{
-	int ret, needed_blocks, no_expand;
-	handle_t *handle = NULL;
-	int retries = 0, sem_held = 0;
-	struct folio *folio = NULL;
-	unsigned from, to;
-	struct ext4_iloc iloc;
-
-	if (!ext4_has_inline_data(inode)) {
-		/*
-		 * clear the flag so that no new write
-		 * will trap here again.
-		 */
-		ext4_clear_inode_state(inode, EXT4_STATE_MAY_INLINE_DATA);
-		return 0;
-	}
-
-	needed_blocks = ext4_chunk_trans_extent(inode, 1);
-
-	ret = ext4_get_inode_loc(inode, &iloc);
-	if (ret)
-		return ret;
-
-retry:
-	handle = ext4_journal_start(inode, EXT4_HT_WRITE_PAGE, needed_blocks);
-	if (IS_ERR(handle)) {
-		ret = PTR_ERR(handle);
-		handle = NULL;
-		goto out;
-	}
-
-	/* We cannot recurse into the filesystem as the transaction is already
-	 * started */
-	folio = __filemap_get_folio(mapping, 0, FGP_WRITEBEGIN | FGP_NOFS,
-			mapping_gfp_mask(mapping));
-	if (IS_ERR(folio)) {
-		ret = PTR_ERR(folio);
-		goto out_nofolio;
-	}
-
-	ext4_write_lock_xattr(inode, &no_expand);
-	sem_held = 1;
-	/* If some one has already done this for us, just exit. */
-	if (!ext4_has_inline_data(inode)) {
-		ret = 0;
-		goto out;
-	}
-
-	from = 0;
-	to = ext4_get_inline_size(inode);
-	if (!folio_test_uptodate(folio)) {
-		ret = ext4_read_inline_folio(inode, folio);
-		if (ret < 0)
-			goto out;
-	}
-
-	ext4_fc_track_inode(handle, inode);
-	ret = ext4_destroy_inline_data_nolock(handle, inode);
-	if (ret)
-		goto out;
-
-	if (ext4_should_dioread_nolock(inode)) {
-		ret = ext4_block_write_begin(handle, folio, from, to,
-					     ext4_get_block_unwritten);
-	} else
-		ret = ext4_block_write_begin(handle, folio, from, to,
-					     ext4_get_block);
-	clear_buffer_new(folio_buffers(folio));
-
-	if (!ret && ext4_should_journal_data(inode)) {
-		ret = ext4_walk_page_buffers(handle, inode,
-					     folio_buffers(folio), from, to,
-					     NULL, do_journal_get_write_access);
-	}
-
-	if (ret) {
-		folio_unlock(folio);
-		folio_put(folio);
-		folio = NULL;
-		ext4_orphan_add(handle, inode);
-		ext4_write_unlock_xattr(inode, &no_expand);
-		sem_held = 0;
-		ext4_journal_stop(handle);
-		handle = NULL;
-		ext4_truncate_failed_write(inode);
-		/*
-		 * If truncate failed early the inode might
-		 * still be on the orphan list; we need to
-		 * make sure the inode is removed from the
-		 * orphan list in that case.
-		 */
-		if (inode->i_nlink)
-			ext4_orphan_del(NULL, inode);
-	}
-
-	if (ret == -ENOSPC && ext4_should_retry_alloc(inode->i_sb, &retries))
-		goto retry;
-
-	if (folio)
-		block_commit_write(folio, from, to);
-out:
-	if (folio) {
-		folio_unlock(folio);
-		folio_put(folio);
-	}
-out_nofolio:
-	if (sem_held)
-		ext4_write_unlock_xattr(inode, &no_expand);
-	if (handle)
-		ext4_journal_stop(handle);
-	brelse(iloc.bh);
-	return ret;
-}
-
 /*
  * Prepare the write for the inline data.
  * If the data can be written into the inode, we just read
@@ -712,100 +596,6 @@ int ext4_generic_write_inline_data(struct address_space *mapping,
 	return ret;
 }
 
-int ext4_write_inline_data_end(struct inode *inode, loff_t pos, unsigned len,
-			       unsigned copied, struct folio *folio)
-{
-	handle_t *handle = ext4_journal_current_handle();
-	int no_expand;
-	void *kaddr;
-	struct ext4_iloc iloc;
-	int ret = 0, ret2;
-
-	if (unlikely(copied < len) && !folio_test_uptodate(folio))
-		copied = 0;
-
-	if (likely(copied)) {
-		ret = ext4_get_inode_loc(inode, &iloc);
-		if (ret) {
-			folio_unlock(folio);
-			folio_put(folio);
-			ext4_std_error(inode->i_sb, ret);
-			goto out;
-		}
-		ext4_write_lock_xattr(inode, &no_expand);
-		/*
-		 * We could have raced with ext4_page_mkwrite() converting
-		 * the inode and clearing the inline data flag, so we just
-		 * release resources and retry the whole write.
-		 */
-		if (unlikely(!ext4_has_inline_data(inode))) {
-			ext4_write_unlock_xattr(inode, &no_expand);
-			brelse(iloc.bh);
-			folio_unlock(folio);
-			folio_put(folio);
-			ext4_journal_stop(handle);
-			return 0;
-		}
-
-		/*
-		 * ei->i_inline_off may have changed since
-		 * ext4_write_begin() called
-		 * ext4_convert_inline_data()
-		 */
-		(void) ext4_find_inline_data_nolock(inode);
-
-		kaddr = kmap_local_folio(folio, 0);
-		ext4_write_inline_data(inode, &iloc, kaddr, pos, copied);
-		kunmap_local(kaddr);
-		folio_mark_uptodate(folio);
-		/* clear dirty flag so that writepages wouldn't work for us. */
-		folio_clear_dirty(folio);
-
-		ext4_write_unlock_xattr(inode, &no_expand);
-		brelse(iloc.bh);
-
-		/*
-		 * It's important to update i_size while still holding folio
-		 * lock: page writeout could otherwise come in and zero
-		 * beyond i_size.
-		 */
-		ext4_update_inode_size(inode, pos + copied);
-	}
-	folio_unlock(folio);
-	folio_put(folio);
-
-	/*
-	 * Don't mark the inode dirty under folio lock. First, it unnecessarily
-	 * makes the holding time of folio lock longer. Second, it forces lock
-	 * ordering of folio lock and transaction start for journaling
-	 * filesystems.
-	 */
-	if (likely(copied))
-		mark_inode_dirty(inode);
-out:
-	/*
-	 * If we didn't copy as much data as expected, we need to trim back
-	 * size of xattr containing inline data.
-	 */
-	if (pos + len > inode->i_size && ext4_can_truncate(inode))
-		ext4_orphan_add(handle, inode);
-
-	ret2 = ext4_journal_stop(handle);
-	if (!ret)
-		ret = ret2;
-	if (pos + len > inode->i_size) {
-		ext4_truncate_failed_write(inode);
-		/*
-		 * If truncate failed early the inode might still be
-		 * on the orphan list; we need to make sure the inode
-		 * is removed from the orphan list in that case.
-		 */
-		if (inode->i_nlink)
-			ext4_orphan_del(NULL, inode);
-	}
-	return ret ? ret : copied;
-}
-
 /*
  * Try to make the page cache and handle ready for the inline data case.
  * We can call this function in 2 cases:
diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index f9e1f0a6024d..2256fb3826a9 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -1300,8 +1300,6 @@ static int ext4_write_begin(const struct kiocb *iocb,
 	if (unlikely(ret))
 		return ret;
 
-	*fsdata = (void *)((unsigned long)*fsdata & ~EXT4_WRITE_DATA_INLINE);
-
 	trace_ext4_write_begin(inode, pos, len);
 	/*
 	 * Reserve one block more for addition to orphan list in case
@@ -1315,10 +1313,6 @@ static int ext4_write_begin(const struct kiocb *iocb,
 		ret = ext4_convert_inline_data(inode);
 		if (ret < 0)
 			return ret;
-		if (ret == 1) {
-			*fsdata = (void *)((unsigned long)*fsdata | EXT4_WRITE_DATA_INLINE);
-			return 0;
-		}
 	}
 
 	/*
@@ -1451,10 +1445,6 @@ static int ext4_write_end(const struct kiocb *iocb,
 
 	trace_ext4_write_end(inode, pos, len, copied);
 
-	if ((unsigned long)fsdata & EXT4_WRITE_DATA_INLINE)
-		return ext4_write_inline_data_end(inode, pos, len, copied,
-						  folio);
-
 	copied = block_write_end(pos, len, copied, folio);
 	/*
 	 * it's important to update i_size while still holding folio lock:
@@ -1560,10 +1550,6 @@ static int ext4_journalled_write_end(const struct kiocb *iocb,
 
 	BUG_ON(!ext4_handle_valid(handle));
 
-	if ((unsigned long)fsdata & EXT4_WRITE_DATA_INLINE)
-		return ext4_write_inline_data_end(inode, pos, len, copied,
-						  folio);
-
 	if (unlikely(copied < len) && !folio_test_uptodate(folio)) {
 		copied = 0;
 		ext4_journalled_zero_new_buffers(handle, inode, folio,
@@ -3172,10 +3158,6 @@ static int ext4_da_write_begin(const struct kiocb *iocb,
 						     foliop, true);
 		if (ret < 0)
 			return ret;
-		if (ret == 1) {
-			*fsdata = (void *)((unsigned long)*fsdata | EXT4_WRITE_DATA_INLINE);
-			return 0;
-		}
 	}
 
 retry:
@@ -3312,10 +3294,6 @@ static int ext4_da_write_end(const struct kiocb *iocb,
 
 	trace_ext4_da_write_end(inode, pos, len, copied);
 
-	if (write_mode & EXT4_WRITE_DATA_INLINE)
-		return ext4_write_inline_data_end(inode, pos, len, copied,
-						  folio);
-
 	if (unlikely(copied < len) && !folio_test_uptodate(folio))
 		copied = 0;
 
-- 
2.43.0

