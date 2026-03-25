Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9954B36E487;
	Wed, 25 Mar 2026 07:33:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774424030; cv=none; b=JwOo1SLi+YyzaqvgQ3dSgtMnCEXnbKWpo+IHYgkfed/+5euWtrsC7ZgKnGd6bFGlJ3lf7PBk2J9afdMCwAe2l8vmaoDz280nu8CnU346xADtugjiSszB4Qlhoveett8w4mUIt94kADh/ViP/Q4p4uCnW1iiZ1X9thksCvinxSow=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774424030; c=relaxed/simple;
	bh=SaZsXlqQlKMJtJslUW02LI7hk29DIv9bgzjrJByHt2w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VUMF8hYWwdt3IjJpkYaygwLAOws+8WMb6XdTAOyBiITrBNcKuXleXo+lfxh++oWV4rsqicEOu7tYx5CniHz1QDcbHqq9Vxy/tR0YmKtGWVpkFLiqXqI4BVQAaAdA5lLeOtIFQ0OjGP1+3PbvGSipmw2ThSd5Nl7FdgXqAflsaIQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.177])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTPS id 4fgdt51DmbzKHMZJ;
	Wed, 25 Mar 2026 15:33:01 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.112])
	by mail.maildlp.com (Postfix) with ESMTP id 82C014058C;
	Wed, 25 Mar 2026 15:33:39 +0800 (CST)
Received: from huaweicloud.com (unknown [10.50.85.155])
	by APP1 (Coremail) with SMTP id cCh0CgAHC9vFj8NpuR6cCA--.49898S8;
	Wed, 25 Mar 2026 15:33:39 +0800 (CST)
From: Zhang Yi <yi.zhang@huaweicloud.com>
To: linux-ext4@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	tytso@mit.edu,
	adilger.kernel@dilger.ca,
	jack@suse.cz,
	ojaswin@linux.ibm.com,
	ritesh.list@gmail.com,
	libaokun@linux.alibaba.com,
	yi.zhang@huawei.com,
	yi.zhang@huaweicloud.com,
	yizhang089@gmail.com,
	yangerkun@huawei.com,
	yukuai@fnnas.com
Subject: [PATCH v2 04/10] ext4: factor out journalled block zeroing range
Date: Wed, 25 Mar 2026 15:28:43 +0800
Message-ID: <20260325072850.3997161-5-yi.zhang@huaweicloud.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260325072850.3997161-1-yi.zhang@huaweicloud.com>
References: <20260325072850.3997161-1-yi.zhang@huaweicloud.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:cCh0CgAHC9vFj8NpuR6cCA--.49898S8
X-Coremail-Antispam: 1UD129KBjvJXoWxur18Jr4kCryrtryUJw4Utwb_yoW7JF13pr
	y3K39rZrW7WF9FgF4Sq3W7Xr1a9a4rGrW8WFWxG3savayYqFn3KF1UK3WSvF45tr43G3W0
	qF4Yy34j93WDtrDanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUmI14x267AKxVWrJVCq3wAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2048vs2IY020E87I2jVAFwI0_JF0E3s1l82xGYI
	kIc2x26xkF7I0E14v26ryj6s0DM28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48ve4kI8wA2
	z4x0Y4vE2Ix0cI8IcVAFwI0_tr0E3s1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI0_Gr1j6F
	4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x0267AKxVW0oVCq
	3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0I7
	IYx2IY67AKxVWUGVWUXwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFVCjc4AY6r1j6r4U
	M4x0Y48IcxkI7VAKI48JM4x0x7Aq67IIx4CEVc8vx2IErcIFxwACI402YVCY1x02628vn2
	kIc2xKxwCY1x0262kKe7AKxVWUtVW8ZwCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7xkE
	bVWUJVW8JwC20s026c02F40E14v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67
	AF67kF1VAFwI0_Jw0_GFylIxkGc2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUJVWUCwCI
	42IY6xIIjxv20xvEc7CjxVAFwI0_Cr0_Gr1UMIIF0xvE42xK8VAvwI8IcIk0rVWUJVWUCw
	CI42IY6I8E87Iv67AKxVWUJVW8JwCI42IY6I8E87Iv6xkF7I0E14v26r4j6r4UJbIYCTnI
	WIevJa73UjIFyTuYvjfUriihUUUUU
X-CM-SenderInfo: d1lo6xhdqjqx5xdzvxpfor3voofrz/

From: Zhang Yi <yi.zhang@huawei.com>

Refactor __ext4_block_zero_page_range() by separating the block zeroing
operations for ordered data mode and journal data mode into two distinct
functions:

  - ext4_block_do_zero_range(): handles non-journal data mode with
    ordered data support
  - ext4_block_journalled_zero_range(): handles journal data mode

Also extract a common helper, ext4_load_tail_bh(), to handle buffer head
and folio retrieval, along with the associated error handling. This
prepares for converting the partial block zero range to the iomap
infrastructure.

Signed-off-by: Zhang Yi <yi.zhang@huawei.com>
Reviewed-by: Jan Kara <jack@suse.cz>
---
 fs/ext4/inode.c | 98 ++++++++++++++++++++++++++++++++++---------------
 1 file changed, 69 insertions(+), 29 deletions(-)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index a7635bbac1a0..3ccba708895d 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -4002,13 +4002,11 @@ void ext4_set_aops(struct inode *inode)
  * ext4_punch_hole, etc) which needs to be properly zeroed out. Otherwise a
  * racing writeback can come later and flush the stale pagecache to disk.
  */
-static int __ext4_block_zero_page_range(handle_t *handle,
-		struct address_space *mapping, loff_t from, loff_t length,
-		bool *did_zero)
+static struct buffer_head *ext4_load_tail_bh(struct inode *inode, loff_t from)
 {
 	unsigned int offset, blocksize, pos;
 	ext4_lblk_t iblock;
-	struct inode *inode = mapping->host;
+	struct address_space *mapping = inode->i_mapping;
 	struct buffer_head *bh;
 	struct folio *folio;
 	int err = 0;
@@ -4017,7 +4015,7 @@ static int __ext4_block_zero_page_range(handle_t *handle,
 				    FGP_LOCK | FGP_ACCESSED | FGP_CREAT,
 				    mapping_gfp_constraint(mapping, ~__GFP_FS));
 	if (IS_ERR(folio))
-		return PTR_ERR(folio);
+		return ERR_CAST(folio);
 
 	blocksize = inode->i_sb->s_blocksize;
 
@@ -4069,33 +4067,73 @@ static int __ext4_block_zero_page_range(handle_t *handle,
 			}
 		}
 	}
-	if (ext4_should_journal_data(inode)) {
-		BUFFER_TRACE(bh, "get write access");
-		err = ext4_journal_get_write_access(handle, inode->i_sb, bh,
-						    EXT4_JTR_NONE);
-		if (err)
-			goto unlock;
-	}
-	folio_zero_range(folio, offset, length);
+	return bh;
+
+unlock:
+	folio_unlock(folio);
+	folio_put(folio);
+	return err ? ERR_PTR(err) : NULL;
+}
+
+static int ext4_block_do_zero_range(handle_t *handle, struct inode *inode,
+				    loff_t from, loff_t length, bool *did_zero)
+{
+	struct buffer_head *bh;
+	struct folio *folio;
+	int err = 0;
+
+	bh = ext4_load_tail_bh(inode, from);
+	if (IS_ERR_OR_NULL(bh))
+		return PTR_ERR_OR_ZERO(bh);
+
+	folio = bh->b_folio;
+	folio_zero_range(folio, offset_in_folio(folio, from), length);
 	BUFFER_TRACE(bh, "zeroed end of block");
 
-	if (ext4_should_journal_data(inode)) {
-		err = ext4_dirty_journalled_data(handle, bh);
-	} else {
-		mark_buffer_dirty(bh);
-		/*
-		 * Only the written block requires ordered data to prevent
-		 * exposing stale data.
-		 */
-		if (!buffer_unwritten(bh) && !buffer_delay(bh) &&
-		    ext4_should_order_data(inode))
-			err = ext4_jbd2_inode_add_write(handle, inode, from,
-					length);
-	}
+	mark_buffer_dirty(bh);
+	/*
+	 * Only the written block requires ordered data to prevent exposing
+	 * stale data.
+	 */
+	if (ext4_should_order_data(inode) &&
+	    !buffer_unwritten(bh) && !buffer_delay(bh))
+		err = ext4_jbd2_inode_add_write(handle, inode, from, length);
 	if (!err && did_zero)
 		*did_zero = true;
 
-unlock:
+	folio_unlock(folio);
+	folio_put(folio);
+	return err;
+}
+
+static int ext4_block_journalled_zero_range(handle_t *handle,
+		struct inode *inode, loff_t from, loff_t length, bool *did_zero)
+{
+	struct buffer_head *bh;
+	struct folio *folio;
+	int err;
+
+	bh = ext4_load_tail_bh(inode, from);
+	if (IS_ERR_OR_NULL(bh))
+		return PTR_ERR_OR_ZERO(bh);
+	folio = bh->b_folio;
+
+	BUFFER_TRACE(bh, "get write access");
+	err = ext4_journal_get_write_access(handle, inode->i_sb, bh,
+					    EXT4_JTR_NONE);
+	if (err)
+		goto out;
+
+	folio_zero_range(folio, offset_in_folio(folio, from), length);
+	BUFFER_TRACE(bh, "zeroed end of block");
+
+	err = ext4_dirty_journalled_data(handle, bh);
+	if (err)
+		goto out;
+
+	if (did_zero)
+		*did_zero = true;
+out:
 	folio_unlock(folio);
 	folio_put(folio);
 	return err;
@@ -4126,9 +4164,11 @@ static int ext4_block_zero_page_range(handle_t *handle,
 	if (IS_DAX(inode)) {
 		return dax_zero_range(inode, from, length, did_zero,
 				      &ext4_iomap_ops);
+	} else if (ext4_should_journal_data(inode)) {
+		return ext4_block_journalled_zero_range(handle, inode, from,
+							length, did_zero);
 	}
-	return __ext4_block_zero_page_range(handle, mapping, from, length,
-					    did_zero);
+	return ext4_block_do_zero_range(handle, inode, from, length, did_zero);
 }
 
 /*
-- 
2.52.0

