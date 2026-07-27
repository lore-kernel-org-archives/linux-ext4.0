Received: from mx0b-0064b401.pphosted.com (mx0b-0064b401.pphosted.com [205.220.178.238])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4DE98175A60;
	Mon, 27 Jul 2026 10:55:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.178.238
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785149749; cv=none; b=ElR5+qheL9jVylWQpbp50SlY85ATITKMneOQeGt64zTMLuaFjp4NUecQuKXSyucj1KnM7+ZlrCljd3bbUeRSIO3/t6yMXttZjL8XWc2cSShXPTG/Fhzc3rdamGkAm1mLNb5i+qF3r2vQ/AtCZPgVfklXtmVDDSwk6He552TbS+E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785149749; c=relaxed/simple;
	bh=jZilYExCWH/vWAQK75upLSJiN6tIykRE0f79y8ecNig=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=UB9BetYPQGhPV0/N+NJSHT5jcQ/3PDcF+fczkw0tQafiWF8tLscBlmZ2i9D/A98QA5aYzunnOkCtEahGd4FQwZBFkxTSWJy7zu5Rd9zu/IS/9OKE+QBdF6RLo1pr0ylxn3eI8LwnjSYKCpT9zdu3prlqW8ZuBUcy16HZdmA8Ftg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=windriver.com; spf=fail smtp.mailfrom=windriver.com; dkim=pass (2048-bit key) header.d=windriver.com header.i=@windriver.com header.b=jm39Unev; arc=none smtp.client-ip=205.220.178.238
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=windriver.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=windriver.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=windriver.com header.i=@windriver.com header.b="jm39Unev"
Received: from pps.filterd (m0250811.ppops.net [127.0.0.1])
	by mx0a-0064b401.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66RANi6O690460;
	Mon, 27 Jul 2026 10:55:06 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=windriver.com;
	 h=cc:content-transfer-encoding:content-type:date:from
	:in-reply-to:message-id:mime-version:references:subject:to; s=
	PPS06212021; bh=+GNom81RVTG3rdxdmBHnAkmu1qJt7rBqpD36VOg67qc=; b=
	jm39Unev+meOP1w/Y1xV1I7bF/a6I8YOfBPB+KNTJjCS5itRqMf+c4f0tqNLZepv
	/exrU/2Z/FziNJk2gm3GehJq4/38Z6LvscLp1d+7BIyzih2ymVVncWpjINvTRYcd
	pVEpWBlKS1WwRBDMhu1q3b7671/ehcdXhlyX96dESsbUk3PmeAvUkSsXKDuYGy5N
	lwI6R8BQVAEFqoTvr7XeDz8iM4ljPwylQdkkzrBZWcx+RmGqKCFfKKo+nofP1ZzZ
	F7xYKqPtgg5e30MaUvM0CE8FVQUXCSy/4dDqm6pdMtJMS8k1bf3C81dNYqsTG4D+
	I/Z+xqoIUype+fkZ9FowkQ==
Received: from ala-exchng01.corp.ad.wrs.com (ala-exchng01.wrs.com [128.224.246.36])
	by mx0a-0064b401.pphosted.com (PPS) with ESMTPS id 4fmjnft3ec-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
	Mon, 27 Jul 2026 10:55:05 +0000 (GMT)
Received: from ALA-EXCHNG02.corp.ad.wrs.com (10.11.224.122) by
 ala-exchng01.corp.ad.wrs.com (10.11.224.121) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.61; Mon, 27 Jul 2026 03:55:04 -0700
Received: from pek-yzhou-d3.wrs.com (10.11.232.110) by
 ALA-EXCHNG02.corp.ad.wrs.com (10.11.224.122) with Microsoft SMTP Server id
 15.1.2507.61 via Frontend Transport; Mon, 27 Jul 2026 03:55:02 -0700
From: Yun Zhou <yun.zhou@windriver.com>
To: <tytso@mit.edu>, <adilger.kernel@dilger.ca>, <libaokun@linux.alibaba.com>,
        <jack@suse.cz>, <ojaswin@linux.ibm.com>, <ritesh.list@gmail.com>,
        <yi.zhang@huawei.com>
CC: <linux-ext4@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <yun.zhou@windriver.com>
Subject: [RFC PATCH 7/9] ext4: remove DA convert path for regular file inline data
Date: Mon, 27 Jul 2026 18:54:39 +0800
Message-ID: <20260727105441.3213095-8-yun.zhou@windriver.com>
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
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzI3MDEwNiBTYWx0ZWRfX5aI5hgwZvI29
 q6VwxbpmAd50tCQ8TPrr4o3y46nr0F5q83/Rjs+3eyx2+d+9FWt4E9nYtwisEBBnGXvXZZRGfK7
 faJ+RpVvA6I7SvP8CUbJTx3tgfAtlPLqAtB8C6wGz+uRkT/noj4E
X-Proofpoint-ORIG-GUID: R9PiFtNPjbbHiajfYoXipiCG5dE0RYdu
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzI3MDEwNiBTYWx0ZWRfX2VYk1Fxk/Pew
 p0jb8ieQTNd3cJnAOtIuX5I7X0Ila8O7MoGvyCIIiRni4z83eLpy7devW1HCfPNL0NKDgIyxLjq
 fLHpRyw3f/Uqu6QgimEaQIJPzOLY7JkSAQ4dji3OyO4F8Oni4TUhJEUa4TuYW95C5jb465E5mGg
 oZENEfu0e7htuStsktTuQ0yN4emTPFfnPLV6kZNU6QWMcGRYjY5gx3vYjmX/vlnPzISghYMo2xd
 xxXhq9xm+ofqb9IiePoX4kgZnegWm0TnmYsG4FbXlJFW0SjmIxw8CcsBTeig6KsoAU8qLReE3Mn
 xiJ34DwZX+gtcHWpO8h5FOiY220FHhcR3b1nvaFk8XcjDZcTxfiESWnmXwzdxHHQSKEqgK/zbUz
 YX257CWTvHplGWEMGLoVo94l7nvAk5Dt9JkYjiJWwotL0JjA+o5FA9Z50sl9OcZKmUriHeLgHts
 oAdeCYVYtR8EtpI219Q==
X-Authority-Analysis: v=2.4 cv=MuRiLWae c=1 sm=1 tr=0 ts=6a673909 cx=c_pps
 a=AbJuCvi4Y3V6hpbCNWx0WA==:117 a=AbJuCvi4Y3V6hpbCNWx0WA==:17
 a=RAioF0-LDSMA:10 a=VkNPw1HP01LnGYTKEx00:22 a=bi6dqmuHe4P4UrxVR6um:22
 a=klDOsUkWDRETUCZYPvoE:22 a=edf1wS77AAAA:8 a=hSkVLCK3AAAA:8 a=t7CeM3EgAAAA:8
 a=ei8J6-tlzKD3yoR0DoIA:9 a=DcSpbTIhAlouE1Uv7lRv:22 a=cQPPKAXgyycSBL8etih5:22
 a=FdTzh2GWekK77mhwV6Dw:22
X-Proofpoint-GUID: R9PiFtNPjbbHiajfYoXipiCG5dE0RYdu
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-27_03,2026-07-24_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 adultscore=0 priorityscore=1501 malwarescore=0 phishscore=0 suspectscore=0
 clxscore=1015 impostorscore=0 lowpriorityscore=0 spamscore=0 bulkscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2607270106

Replace ext4_da_convert_inline_data_to_extent() with
ext4_convert_inline_data() in the DA write path.

The DA convert function left a problematic intermediate state
(has_inline_data=true, MAY_INLINE_DATA=false) that caused races with
concurrent page_mkwrite: the racing thread would call filemap_flush()
which triggers writepages, but writepages rejects inodes with
has_inline_data set, leading to BUG_ON or WARN_ON.

Since the synchronous convert (ext4_convert_inline_data_nolock) only
allocates one block, the delayed allocation benefit (block contiguity)
is negligible for this single-block case.

With DA convert eliminated for regular files, the !MAY_INLINE_DATA
branch in ext4_convert_inline_data() is dead code and removed.

Remove ext4_da_convert_inline_data_to_extent().

Fixes: 7b4cc9787fe3 ("ext4: evict inline data when writing to memory map")
Reported-by: syzbot+d1da16f03614058fdc48@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=d1da16f03614058fdc48
Signed-off-by: Yun Zhou <yun.zhou@windriver.com>
---
 fs/ext4/inline.c | 86 +-----------------------------------------------
 1 file changed, 1 insertion(+), 85 deletions(-)

diff --git a/fs/ext4/inline.c b/fs/ext4/inline.c
index ebbb9b29e3e1..009a4e058793 100644
--- a/fs/ext4/inline.c
+++ b/fs/ext4/inline.c
@@ -21,10 +21,6 @@
 #define EXT4_INLINE_DOTDOT_OFFSET	2
 #define EXT4_INLINE_DOTDOT_SIZE		4
 
-
-static int ext4_da_convert_inline_data_to_extent(struct address_space *mapping,
-						 struct inode *inode);
-
 static int ext4_get_inline_size(struct inode *inode)
 {
 	if (EXT4_I(inode)->i_inline_off)
@@ -538,76 +534,8 @@ int ext4_generic_write_inline_data(struct address_space *mapping,
 					  struct folio **foliop,
 					  bool da)
 {
-	int ret;
-	int retries = 0;
-
 	/* Inline data is deprecated: always convert to block format */
-	if (!da)
-		return ext4_convert_inline_data(inode);
-
-retry:
-	ret = ext4_da_convert_inline_data_to_extent(mapping, inode);
-	if (ret == -ENOSPC && ext4_should_retry_alloc(inode->i_sb, &retries))
-		goto retry;
-	return ret;
-}
-
-/*
- * Try to make the page cache and handle ready for the inline data case.
- * We can call this function in 2 cases:
- * 1. The inode is created and the first write exceeds inline size. We can
- *    clear the inode state safely.
- * 2. The inode has inline data, then we need to read the data, make it
- *    update and dirty so that ext4_da_writepages can handle it. We don't
- *    need to start the journal since the file's metadata isn't changed now.
- */
-static int ext4_da_convert_inline_data_to_extent(struct address_space *mapping,
-						 struct inode *inode)
-{
-	int ret = 0, inline_size;
-	struct folio *folio;
-
-	folio = __filemap_get_folio(mapping, 0, FGP_WRITEBEGIN,
-					mapping_gfp_mask(mapping));
-	if (IS_ERR(folio))
-		return PTR_ERR(folio);
-
-	down_read(&EXT4_I(inode)->xattr_sem);
-	if (!ext4_has_inline_data(inode)) {
-		ext4_clear_inode_state(inode, EXT4_STATE_MAY_INLINE_DATA);
-		goto out;
-	}
-
-	inline_size = ext4_get_inline_size(inode);
-
-	if (!folio_test_uptodate(folio)) {
-		ret = ext4_read_inline_folio(inode, folio);
-		if (ret < 0)
-			goto out;
-	}
-
-	ret = ext4_block_write_begin(NULL, folio, 0, inline_size,
-				     ext4_da_get_block_prep);
-	if (ret) {
-		up_read(&EXT4_I(inode)->xattr_sem);
-		folio_unlock(folio);
-		folio_put(folio);
-		ext4_truncate_failed_write(inode);
-		return ret;
-	}
-
-	clear_buffer_new(folio_buffers(folio));
-	folio_mark_dirty(folio);
-	folio_mark_uptodate(folio);
-	ext4_clear_inode_state(inode, EXT4_STATE_MAY_INLINE_DATA);
-
-out:
-	up_read(&EXT4_I(inode)->xattr_sem);
-	if (folio) {
-		folio_unlock(folio);
-		folio_put(folio);
-	}
-	return ret;
+	return ext4_convert_inline_data(inode);
 }
 
 #ifdef INLINE_DIR_DEBUG
@@ -1650,18 +1578,6 @@ int ext4_convert_inline_data(struct inode *inode)
 	if (!ext4_has_inline_data(inode)) {
 		ext4_clear_inode_state(inode, EXT4_STATE_MAY_INLINE_DATA);
 		return 0;
-	} else if (!ext4_test_inode_state(inode, EXT4_STATE_MAY_INLINE_DATA)) {
-		/*
-		 * Inode has inline data but EXT4_STATE_MAY_INLINE_DATA is
-		 * cleared. This means we are in the middle of moving of
-		 * inline data to delay allocated block. Just force writeout
-		 * here to finish conversion.
-		 */
-		error = filemap_flush(inode->i_mapping);
-		if (error)
-			return error;
-		if (!ext4_has_inline_data(inode))
-			return 0;
 	}
 
 	needed_blocks = ext4_chunk_trans_extent(inode, 1);
-- 
2.43.0

