Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.221.44
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795676916;
	b=2NY9bjqhuUSa4CkpSupCYmXH3WeAtbeB1tzTj9BnJW9nAWoGEA7mJNavgwHLabqyzMqN
	 JjcfQsFr7GhyvpNmTHdug8SiT5gDLRqIJPCg0czD2TNHcHJuxFgTedI+QLM7s321D3TLV
	 rqEcvLJMwCe6cGzDg2Rek4t5tQRBzEPyv92eu4k1sCjY8ks5Lpd6TA1WmqFLWtOx6dhAC
	 BnLIr8qOq/X+h8x1uXh9tkrdA4rbE9w1jhgzw+hCm8SKpo/NqDG3T3DjU1jqlHbszjB2H
	 22WbcrucRchheA5WnrsN39DIbhqf7mfbZOfBW0fSe48/Q0LQXpXVfhJ4qcntzWLp7sA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795676916;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=T/Z6qVaPDqOfhLuH0D0e+vpUE0BMkhpE5SefByryfic=;
	b=Mnh3QJsa9hXzqyyUTIezQdv9Hkh5cLWx21C0oVMQdtoT3tXtGLb3hv9LJeSL7cA8HFUi
	 nPYgl3qihPLYYef7LgMP0oirnUK8rdUCaCoHlzyNykCQqXpQpA2IunFmBFKP6xGuU/gWg
	 /9dssm+n37lGhB/Tt4d8kUlMnm6LWiOcMUAijbnNYcs3XEBtSEEmKVOinzqQYJxNdmjt9
	 1KqOjeBTJkvnhNSWPMElvz7VjER8I8zk4mBUajRlRbnhNbQgUgithhBT5/KA/Nu5OoxQq
	 Qfpsx3KVNeeXkgh3mXlXIuOlOYIYjRJF0gy7ZEAG22AU24+3hkYQ6cmvw1gYDRU80jg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=copmDR1B;
	arc=none smtp.remote-ip=209.85.221.44
Received: from mail-wr1-f44.google.com (mail-wr1-f44.google.com [209.85.221.44])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E792606A321
	for <linux-ext4@vger.kernel.org>; Thu, 26 Nov 2026 07:08:36 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 1E792606A321
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=copmDR1B
Received: by mail-wr1-f44.google.com with SMTP id ffacd0b85a97d-491846221ffso5723199f8f.3
        for <linux-ext4@vger.kernel.org>; Wed, 25 Nov 2026 23:08:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795676914; x=1796281714; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=T/Z6qVaPDqOfhLuH0D0e+vpUE0BMkhpE5SefByryfic=;
        b=copmDR1Bp4Vcakpzr6T5mHUQLGK9B8h2TNAgyg5U3KoXzS9RlXnyxaNecwXzxnfOCG
         QuRY7wBqBnsAnRmcoEy5FMAkUjMfBkVWzwwtbokM7lnZ1mecPweiFYzGBNfXf8xaLhXl
         KQj9S2XsKgOqqTd8p05ufnDLSuDi89JmeUjnzN8cNaSEoRz+W4+U+EbchJeYr//4tdg5
         WoG2cYctl4uCSLJLKZ0fhcwQMcRKLbEySiZttr3wTQhFcIXOiGFBvAMZYZydaXcCyv1S
         xQ0W2HYTTGQbmEWaxpQbOCbVJbMQRoaNpcnlAuUKpMCRwye3HYhglfNS0N8CwWVXBHmv
         OlXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795676914; x=1796281714;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=T/Z6qVaPDqOfhLuH0D0e+vpUE0BMkhpE5SefByryfic=;
        b=1E6CyIGWZjTiznOEWEO5xRfsWPeocb/wyBf03moYU/9kPDtLJTJVyOPynSKkWYWOCE
         kxjgydOnSP5yH6bdv8wkSSDeyDkzz70Q3LN8bJOfRs+AGkzLBbkDzsBe5hKl4jl5EeKx
         3VQTD2sUUk8Bs+uC02SrFApJptUNJIVmpWee1RTKiYllyMSOVXI3A4I43izKqWqlmKDo
         Eq8V+cFBeM1LfUSS8heRQ6mlysXFjkw73u0cCg6d3SIf77CYxBkIbQGSjUzTN4plaFJ8
         SUxRnDkvDlRdq6NFvUtw1T4FvskLtu2ytObUoR48be8yuz2BtayfGckMOy12Qwadtrpb
         r+mw==
X-Forwarded-Encrypted: i=1; AL+hErHOzLcMviXiifZrfTZ/hD+ev/paVVeBN6WE7Ag8XFhmj5L6pvswkTJ2kb1GbBSUBMKCgyQh7xOAaSvF@vger.kernel.org
X-Gm-Message-State: APuU4Z8WthP7LSanoRA2+fgT1gEQ3fFYEpUmfhyotRE3Ff2vF1LvblXt
	S782M2akjxYJhAUjp7LIxyTV/h0IY500/uUwMGqQpN6Ulg0PNjY3wmZp
X-Gm-Gg: AZFdTZd/GBhVnCfEUm5W7zItUn9s4ibuoHwTkXs0flCO3jKPcsU1bNJ6/1QbK/BaGOL
	31sXwu/QQHQPD8It3RMLUAIOgT/iAkPgFV7gNPPpTvCSt4wQuTvB4bg2ixXu7fi3HSavgzccsD2
	b+v3uzlHfYx3iXRVf5fslQ82PTrrLw98VHhCR82imtdgoqrjtgyoxQori3Bg6cjG+1/EErPe1P5
	Z+Tl2FvSMTWsvTNTdbXfdBlPaH6n1KJTbRpRJPn+ecROKwZDShCsu2jz1iduEfTFoslW0YWNzqZ
	s3VkCoXdYQogaMDTadjQ8otg+NS8C2HnDyk+zPYGtwxKJpnA55wBMiLUBu/qeX8pCO78iuQX2ou
	ah9Ga7xv7kc+HVYGxuCoUcsQyf16fVqYqu1zaeUb74VDTGgoTV8LuItAmY2Hew/5lLA3lhLCM1K
	Hmh34C6oVmMgECM36itEvhmDMlXinoeK2G9vzlQkbZTUm9gbJDAs5CphDSrmy02d1ZyLIjavzNT
	I1hjQX5Y/EvFUAdnDy2IYphH3hA9+mwqIe1rfFq8ttPAwoH/FgGGQ/BKcCz1+2/giFwYTz2glFj
	tf8ZJhxXD67LRpL/dI2qOO1H32zqkun/IKb/PtKw4Ap3xqnDfA==
X-Received: by 2002:a05:600c:a085:b0:49f:e8bf:8f9b with SMTP id 5b1f17b1804b1-4bb887ca0dfmr426149955e9.4.1795676914479;
        Wed, 25 Nov 2026 23:08:34 -0800 (PST)
Received: from DESKTOP-V28CTA4.dbs.corp ([110.93.227.54])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4bb8538b09bsm1071077895e9.4.2026.11.25.23.08.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Nov 2026 23:08:34 -0800 (PST)
From: Arbab Haider <arbabhaider649@gmail.com>
To: tytso@mit.edu
Cc: adilger.kernel@dilger.ca,
	libaokun@linux.alibaba.com,
	jack@suse.cz,
	ojaswin@linux.ibm.com,
	ritesh.list@gmail.com,
	yi.zhang@huawei.com,
	yebin10@huawei.com,
	linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v4 5/5] ext4: serialize inode migration against concurrent inline data conversion
Date: Thu, 26 Nov 2026 12:07:49 +0500
Message-ID: <20261126070748.272109-7-arbabhaider649@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261126070748.272109-2-arbabhaider649@gmail.com>
References: <20261126070748.272109-2-arbabhaider649@gmail.com>
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

ext4_ext_migrate() and ext4_ind_migrate() are invoked under i_rwsem alone
(neither filemap_invalidate_lock nor xattr_sem is held), and
ext4_ext_migrate() checks EXT4_INODE_EXTENTS and ext4_has_inline_data()
before acquiring ext4_writepages_down_write(inode->i_sb).

This allows two races against concurrent inline-data conversion:

1. Against ext4_page_mkwrite() -> ext4_convert_inline_data_nolock()
   rollback: ext4_create_inline_data() clears EXT4_INODE_EXTENTS before
   setting EXT4_INODE_INLINE_DATA while leaving the extent header from
   ext4_ext_tree_init() in ei->i_data[0].  ext4_ext_migrate() can observe
   both flags clear, interpret ei->i_data[0] as a direct block pointer,
   and persist both EXT4_INODE_EXTENTS and EXT4_INODE_INLINE_DATA on disk.
   Similarly, ext4_ind_migrate() can observe transiently set
   EXT4_INODE_EXTENTS during conversion and clear it concurrently.
2. Against ext4_do_writepages() on a delalloc inline-data inode: writeback
   can convert the inode (setting EXT4_INODE_EXTENTS, clearing
   EXT4_INODE_INLINE_DATA, and allocating block 0 into ei->i_data[])
   between ext4_ext_migrate()'s EXT4_INODE_EXTENTS and
   ext4_has_inline_data() checks, causing ext4_ext_migrate() to interpret
   the extent header and extent entry in ei->i_data[] as indirect blocks.

Hold filemap_invalidate_lock(inode->i_mapping) across ext4_ext_migrate()
and ext4_ind_migrate() to exclude ext4_page_mkwrite(), and acquire
ext4_writepages_down_write(inode->i_sb) before checking EXT4_INODE_EXTENTS
and ext4_has_inline_data() in ext4_ext_migrate() to exclude concurrent
writeback.

Signed-off-by: Arbab Haider <arbabhaider649@gmail.com>
---
 fs/ext4/migrate.c | 33 ++++++++++++++++++++++-----------
 1 file changed, 22 insertions(+), 11 deletions(-)

diff --git a/fs/ext4/migrate.c b/fs/ext4/migrate.c
index 807bd3034..528623310 100644
--- a/fs/ext4/migrate.c
+++ b/fs/ext4/migrate.c
@@ -433,22 +433,25 @@ int ext4_ext_migrate(struct inode *inode)
 	uid_t owner[2];
 	int alloc_ctx;
 
+	filemap_invalidate_lock(inode->i_mapping);
+	alloc_ctx = ext4_writepages_down_write(inode->i_sb);
+
 	/*
 	 * If the filesystem does not support extents, or the inode
 	 * already is extent-based, error out.
 	 */
 	if (!ext4_has_feature_extents(inode->i_sb) ||
 	    ext4_test_inode_flag(inode, EXT4_INODE_EXTENTS) ||
-	    ext4_has_inline_data(inode))
-		return -EINVAL;
+	    ext4_has_inline_data(inode)) {
+		retval = -EINVAL;
+		goto out_unlock;
+	}
 
 	if (S_ISLNK(inode->i_mode) && inode->i_blocks == 0)
 		/*
 		 * don't migrate fast symlink
 		 */
-		return retval;
-
-	alloc_ctx = ext4_writepages_down_write(inode->i_sb);
+		goto out_unlock;
 
 	/*
 	 * Worst case we can touch the allocation bitmaps and a block
@@ -613,6 +616,7 @@ int ext4_ext_migrate(struct inode *inode)
 out_unlock:
 	ext4_writepages_up_write(inode->i_sb, alloc_ctx);
 	iput(tmp_inode);
+	filemap_invalidate_unlock(inode->i_mapping);
 	return retval;
 }
 EXPORT_SYMBOL_FOR_EXT4_TEST(ext4_ext_migrate);
@@ -634,14 +638,19 @@ int ext4_ind_migrate(struct inode *inode)
 	int				ret, ret2 = 0;
 	int				alloc_ctx;
 
+	filemap_invalidate_lock(inode->i_mapping);
+
 	if (!ext4_has_feature_extents(inode->i_sb) ||
-	    (!ext4_test_inode_flag(inode, EXT4_INODE_EXTENTS)))
-		return -EINVAL;
+	    (!ext4_test_inode_flag(inode, EXT4_INODE_EXTENTS))) {
+		ret = -EINVAL;
+		goto out_invalidate;
+	}
 
-	if (ext4_has_feature_bigalloc(inode->i_sb))
-		return -EOPNOTSUPP;
-	if (ext4_inode_buffered_iomap(inode))
-		return -EOPNOTSUPP;
+	if (ext4_has_feature_bigalloc(inode->i_sb) ||
+	    ext4_inode_buffered_iomap(inode)) {
+		ret = -EOPNOTSUPP;
+		goto out_invalidate;
+	}
 
 	/*
 	 * In order to get correct extent info, force all delayed allocation
@@ -702,6 +711,8 @@ int ext4_ind_migrate(struct inode *inode)
 	ext4_journal_stop(handle);
 out_unlock:
 	ext4_writepages_up_write(inode->i_sb, alloc_ctx);
+out_invalidate:
+	filemap_invalidate_unlock(inode->i_mapping);
 	return ret;
 }
 EXPORT_SYMBOL_FOR_EXT4_TEST(ext4_ind_migrate);
-- 
2.53.0

