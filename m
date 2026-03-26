Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE74F37C91E;
	Thu, 26 Mar 2026 11:15:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774523754; cv=none; b=GT4zBaZAJZw0Qf/EKOFVIhxiFDD9ec1sner9VtqKMTBob7pyh5IbinqEOc4PnsoXXCImcmGiU92aDCWKNFs33RW9PiXcWt6flpyDFIu4p7h233LA7MhCk3RP+c/RIqrRDnT0ceQN4bBBREz9f1W8Lh4pIyPfn8EBV0KWRnAVkdQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774523754; c=relaxed/simple;
	bh=YXS8lHEC3Jdo2j5cSBN7EJ0ZzFqzocgiimSao+12Ztg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KCdl04ikEeaDev1Zo73du6fvi60XHsUeyl9liuDk5OAdXszE905RNS6yeBodQmybz7DOtpz7HawclKq3gQhSO6VnEtb+Gck/Gw/wVOWi12r7HhTiQBlFEf7zeRMagepRsRkCL+H/8ULpDQlPPa65aIb1nefO87nJntyvYf/4Aqg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=none smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.170])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTPS id 4fhLmT6MCjzYQv3Z;
	Thu, 26 Mar 2026 19:15:37 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.112])
	by mail.maildlp.com (Postfix) with ESMTP id CFF904056F;
	Thu, 26 Mar 2026 19:15:49 +0800 (CST)
Received: from huaweicloud.com (unknown [10.50.85.155])
	by APP1 (Coremail) with SMTP id cCh0CgD3+NhWFcVprDInCQ--.2580S7;
	Thu, 26 Mar 2026 19:15:49 +0800 (CST)
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
Subject: [PATCH v3 03/11] ext4: factor out journalled block zeroing range
Date: Thu, 26 Mar 2026 19:10:46 +0800
Message-ID: <20260326111054.907252-4-yi.zhang@huaweicloud.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260326111054.907252-1-yi.zhang@huaweicloud.com>
References: <20260326111054.907252-1-yi.zhang@huaweicloud.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:cCh0CgD3+NhWFcVprDInCQ--.2580S7
X-Coremail-Antispam: 1UD129KBjvJXoWxur18Jr4kCryrtryUJw4Utwb_yoW7JF13pr
	y3K3srZrW7WF9FgF4Sq3W7Xr1aka4rGrW8WFyxG3savayYqFn3KF1UK3WSvF45tr43G3W0
	qF4Yy34j93WDtrDanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUmY14x267AKxVWrJVCq3wAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2048vs2IY020E87I2jVAFwI0_JrWl82xGYIkIc2
	x26xkF7I0E14v26ryj6s0DM28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48ve4kI8wA2z4x0
	Y4vE2Ix0cI8IcVAFwI0_tr0E3s1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI0_Gr1j6F4UJw
	A2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x0267AKxVW0oVCq3wAS
	0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0I7IYx2
	IY67AKxVWUJVWUGwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFVCjc4AY6r1j6r4UM4x0
	Y48IcxkI7VAKI48JM4x0x7Aq67IIx4CEVc8vx2IErcIFxwACI402YVCY1x02628vn2kIc2
	xKxwCY1x0262kKe7AKxVWUtVW8ZwCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7xkEbVWU
	JVW8JwC20s026c02F40E14v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67AF67
	kF1VAFwI0_Jw0_GFylIxkGc2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUJVWUCwCI42IY
	6xIIjxv20xvEc7CjxVAFwI0_Cr0_Gr1UMIIF0xvE42xK8VAvwI8IcIk0rVWUJVWUCwCI42
	IY6I8E87Iv67AKxVWUJVW8JwCI42IY6I8E87Iv6xkF7I0E14v26r4j6r4UJbIYCTnIWIev
	Ja73UjIFyTuYvjfUO_MaUUUUU
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
index 5b601b8a4453..1d6eb3ff437e 100644
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

