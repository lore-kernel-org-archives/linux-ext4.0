Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.50
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795723996;
	b=mhGTmPaRl1VZSOUdKpIgFVjLkQaBdbo5SgGzM0HtY5L+SQ1AFxBD3pUbaJrxSkVytAkl
	 wA/Mkzd6r9rNmkxkGFKJoxCfUX5m9wXaX7ilsl8/k0r+apavhAopL9rnREa5BPLwZy4Lm
	 PYu5PgEKDNbJzMy+vh/CeV4VBTl8jypHYg4Ixbh2zKZ+BjflEjFVcOL1oJTa8LFutvIiR
	 aW159APjHOPtBUrm1YCY9YUfn6Ob3CQH6eyDwV45jZ3s/mpnc0P/qIBfyX5m5kGuTBvcx
	 SDEV3P8+p8J8Z0AGVyngN97hRchDp/8oivycQPwvoHglnaaNJ23nCw1+WslWwV9F2cg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795723996;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=N6P19Pl3VE7j1LHnu2Y4cCJ1WQ9+n0Lwd2qKUSRe9S8=;
	b=bgbdIvEMJNMC1nYNs2LjCLbJjWmz8EfhHqDuurq1l/Jq//I7BJqwkhsN09pixup7+u3j
	 Om/YrIJWA3EhQXVq4VmkFZcaUtPfONqK4Jq5mHBET+kDDPUxS1YxpwhN1HcflZ5UXhBVd
	 SN5rIFe7afc9AMEHM47HAg+sWXfetNZNdtpHlc8r7NJtnWm6WlTLI+5mzR2TrbHQJvKg/
	 sKzAadGQO7TI+UxwMftC/Tzls6kxl1dgqheqd5fwAqiuc6ZeNx3vOMboE5cIfGcYXbEgS
	 Kg/ZLLs4txzWwXNuLILjif4qVG6QbSjj+312ni7ZJxBZrka1rktY3yAMhGwl58CZdGw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=e2b.dev;
	spf=pass smtp.mailfrom=e2b.dev;
	dkim=pass header.d=e2b.dev header.i=@e2b.dev header.a=rsa-sha256 header.s=google header.b=hexG+I3C;
	arc=none smtp.remote-ip=209.85.128.50
Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com [209.85.128.50])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB945606A31C
	for <linux-ext4@vger.kernel.org>; Thu, 26 Nov 2026 20:13:15 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org AB945606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=e2b.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=e2b.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=e2b.dev header.i=@e2b.dev header.a=rsa-sha256 header.s=google header.b=hexG+I3C
Received: by mail-wm1-f50.google.com with SMTP id 5b1f17b1804b1-4bb85e07aadso91445465e9.1
        for <linux-ext4@vger.kernel.org>; Thu, 26 Nov 2026 12:13:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=e2b.dev; s=google; t=1795723994; x=1796328794; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=N6P19Pl3VE7j1LHnu2Y4cCJ1WQ9+n0Lwd2qKUSRe9S8=;
        b=hexG+I3C320/zpZe8lMGs6qSCwIuEFLbq5/wDdHro+hqKOAjk0oEOpothsU2wd6Nlr
         yxBWb92NB+JN66e1QE3JvPhXOfGn/aLWhSCObIg9s0ggecNNkDyjTuAjSRtAsupsnvQo
         p1lFVg27SJorofRWGWQr21mp2xDO3cHTRGe2gZgZTwUSXEKqrR+/inaeq0bWM18X8/iH
         TBbquskG+671IySzWsJNHAZ5hh+AsSKbo3tDppCxezd2plCfOPgj5Nbe4jEuqb36Yj7x
         ykJ8VtWVjGQqenH8mUhrzPKI4KpEyeiWjTB42tavx098uDIUSeaXXocM9gWsDs2TYIaE
         GKEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795723994; x=1796328794;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=N6P19Pl3VE7j1LHnu2Y4cCJ1WQ9+n0Lwd2qKUSRe9S8=;
        b=QMdAE5DqtoC7m4uYLPiYjbYaA5f5l2/ZlJBgrh4W0dGQHCjNClN9LThcsNWKjlObjD
         ljb8qJxtKCjEGZD+FlqsFeRlMtIgGYbcQlLSHi7z5dWu6CmFyrzMrNR7TXGCwIIgLMdM
         krKm4N97TQLAjiM/CPZ4947l26F3dveeTAU4nqqG5fOVFmwOAx1qWYmXhH8Zo6Q1My6L
         hZbvzLf47shsfj/W64LCxg1XSO4TjGbCr+MH1jMYwFtkkzwN5qTgZyO61oSzIIMOZk91
         wGK6pELY4jJotA+Ce9VbaOBZMcOOQ6ft6zli7Bu9AqZAga7wvX1md9LbhmILYuzxfLwB
         8BOQ==
X-Forwarded-Encrypted: i=1; AL+hErEbUqNus4JpI7Z9TfgYkWz7MRcGqws38aHcnOlCk9U+BHAlsGsG88kAi5LKBVCQsNXzy0bP+YD1kLvv@vger.kernel.org
X-Gm-Message-State: APuU4Z8EKRogYIWPFMltlT9IfuM318FUehIsl4FxlDqKfKtBLyaRH+iS
	LTJzh8sMIRQRqh5qsuYYnnx9tSwhuTJTEWJZWSJcDcoTOrVIFcA1lPs44r0Af59wUGo=
X-Gm-Gg: AZFdTZdZ4OngV4rm5uPIMiPleT7ACJ2opZsr0RiJZeGoCQGixm052Lvffjc48sjIGHo
	5dg1MrlDuecdC65bsMR9Jzp7spMv1v9c18FCGn5pOXfb0o7nSRIq6fX0hsZ1Og7VTzJxlf08Jxk
	a8kXhlm/DO08/LkcdwbK7gDYFMNGg0g9xbYU1+vbctvxcdnIdxxavzngQn1JmFofRmjWSYRGluG
	IWCr2wbBvhTA7Lg7sCX0KLVcnwPJzr8b1dR6Q9XKoqQ0cFqi5uZhZ+HmMJiC3UP1LuM1KZPofOQ
	vCFe9xpTWgDI2T/1Bd64E8f8cdSZZ8Q6QoX8qPiXBjO3W7cQz+SChk4vhzZQ3qa+ktSAVGtxdQV
	2XkxgQxyMi+5ySwtSve8vs6BOXDQwJhr2l2WLRy9BvCWL+Sjyff6cNsoKkPVhtoftnanpZtgFuT
	Krp88vVK08pVXDwl8v3YhLbosCvs16wgv36UDOFrWtVans8iR+mxaNoze//2JrPMKKfhW3XUPoH
	mh1oz3eIjjnMuP5wsxvYbP/MvFcATzfCu4QCF2MGyvGe63IgcM8kYYnC0mZLQ7eEewojJG7dfVV
	v3BH0F3USH92uuak73EJr/zPmAZLdJQ0hUp97I8FJq8pVcOH4A==
X-Received: by 2002:a05:600c:a4b:b0:4a1:dade:f049 with SMTP id 5b1f17b1804b1-4bb88806292mr461102665e9.15.1795723994035;
        Thu, 26 Nov 2026 12:13:14 -0800 (PST)
Received: from fedora.sphynx-tuna.ts.net ([2a02:8308:397:e200:f9e9:8bad:f8cc:87a3])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4bb8538b09bsm1154281665e9.4.2026.11.26.12.13.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 Nov 2026 12:13:13 -0800 (PST)
From: =?UTF-8?q?Petr=20Van=C4=9Bk?= <petr.vanek@e2b.dev>
To: "Theodore Ts'o" <tytso@mit.edu>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	Baokun Li <libaokun@linux.alibaba.com>,
	Jan Kara <jack@suse.cz>,
	Ojaswin Mujoo <ojaswin@linux.ibm.com>,
	"Ritesh Harjani (IBM)" <ritesh.list@gmail.com>,
	Zhang Yi <yi.zhang@huawei.com>
Cc: Deepanshu Kartikey <kartikey406@gmail.com>,
	=?UTF-8?q?Petr=20Van=C4=9Bk?= <petr.vanek@e2b.dev>,
	linux-ext4@vger.kernel.org
Subject: [PATCH 3/3] ext4: test inline data conversion through the page cache
Date: Thu, 26 Nov 2026 21:12:55 +0100
Message-ID: <20261126201258.1553196-4-petr.vanek@e2b.dev>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261126201258.1553196-1-petr.vanek@e2b.dev>
References: <20261126201258.1553196-1-petr.vanek@e2b.dev>
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

ext4_convert_inline_data() now moves a regular file's inline data into
folio 0 and leaves it to writeback.  Check that: after the conversion,
folio 0 must be uptodate and dirty, hold the old inline data, and have
its buffer mapped to the new block, without any metadata buffer being
dirtied.  Drop the page cache before converting, so that folio 0 has to
be read from the inline data.

Add cases for an ext4_map_blocks() failure with -EIO restoring the
inline data, for data=journal mode, where the folio's buffer is
journalled through ext4_handle_dirty_metadata(), and for an empty
inline file, which must be converted without mapping a block.

Signed-off-by: Petr Vaněk <petr.vanek@e2b.dev>
---
 fs/ext4/inline-test.c | 84 +++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 82 insertions(+), 2 deletions(-)

diff --git a/fs/ext4/inline-test.c b/fs/ext4/inline-test.c
index 3b697d4c425c..399c8cfcf659 100644
--- a/fs/ext4/inline-test.c
+++ b/fs/ext4/inline-test.c
@@ -1122,6 +1122,35 @@ static void test_inline_data_truncate(struct kunit *test)
  * =========================================================================
  */
 
+/*
+ * Check that a regular file's inline data was moved into folio 0, dirty and
+ * mapped to the new block, so that writeback writes it out.
+ */
+static void expect_converted_folio(struct kunit *test, struct inode *inode,
+				   const void *buf, size_t len)
+{
+	struct buffer_head *bh;
+	struct folio *folio;
+	void *kaddr;
+
+	folio = filemap_lock_folio(inode->i_mapping, 0);
+	KUNIT_ASSERT_FALSE(test, IS_ERR(folio));
+	KUNIT_EXPECT_TRUE(test, folio_test_uptodate(folio));
+	KUNIT_EXPECT_TRUE(test, folio_test_dirty(folio));
+	bh = folio_buffers(folio);
+	KUNIT_EXPECT_NOT_NULL(test, bh);
+	if (bh) {
+		KUNIT_EXPECT_TRUE(test, buffer_mapped(bh));
+		KUNIT_EXPECT_TRUE(test, buffer_dirty(bh));
+		KUNIT_EXPECT_EQ(test, bh->b_blocknr, (sector_t)TEST_PBLK);
+	}
+	kaddr = kmap_local_folio(folio, 0);
+	KUNIT_EXPECT_MEMEQ(test, kaddr, buf, len);
+	kunmap_local(kaddr);
+	folio_unlock(folio);
+	folio_put(folio);
+}
+
 static void test_convert_inline_data_and_rollback(struct kunit *test)
 {
 	struct inline_test_ctx *ctx = test->priv;
@@ -1142,13 +1171,20 @@ static void test_convert_inline_data_and_rollback(struct kunit *test)
 	/*
 	 * 2. Inline inode without EXT4_STATE_MAY_INLINE_DATA -> calls
 	 * filemap_flush() and finishes converting inline data if still inline.
+	 * Drop the page cache first so that folio 0 must be read from the
+	 * inline data.
 	 */
 	ret = create_inline_file(inode, buf, sizeof(buf));
 	KUNIT_ASSERT_EQ(test, ret, 0);
+	truncate_inode_pages(&inode->i_data, 0);
 	ext4_clear_inode_state(inode, EXT4_STATE_MAY_INLINE_DATA);
+	ctx->dirty_metadata_calls = 0;
 	ret = ext4_convert_inline_data(inode);
 	KUNIT_EXPECT_EQ(test, ret, 0);
 	KUNIT_EXPECT_FALSE(test, ext4_has_inline_data(inode));
+	expect_converted_folio(test, inode, buf, sizeof(buf));
+	/* The data goes through the page cache, not a metadata buffer. */
+	KUNIT_EXPECT_EQ(test, ctx->dirty_metadata_calls, 0);
 
 	/*
 	 * 3. Error rollback when ext4_map_blocks fails (-ENOSPC):
@@ -1169,14 +1205,58 @@ static void test_convert_inline_data_and_rollback(struct kunit *test)
 			   sizeof(buf) - EXT4_MIN_INLINE_DATA_SIZE);
 	ctx->map_blocks_ret = 1;
 
+	/* 4. Error rollback when ext4_map_blocks fails with -EIO */
+	ctx->map_blocks_ret = -EIO;
+	ret = ext4_convert_inline_data(inode);
+	KUNIT_EXPECT_EQ(test, ret, -EIO);
+	KUNIT_EXPECT_TRUE(test, ext4_has_inline_data(inode));
+	KUNIT_EXPECT_MEMEQ(test, raw_inline_i_block(ctx), buf,
+			   EXT4_MIN_INLINE_DATA_SIZE);
+	ctx->map_blocks_ret = 1;
+
+	/*
+	 * 5. Successful conversion via ext4_convert_inline_data():
+	 * copies 80 bytes into folio 0, destroys inline data, initializes
+	 * extent tree.
+	 */
+	ret = ext4_convert_inline_data(inode);
+	KUNIT_EXPECT_EQ(test, ret, 0);
+	KUNIT_EXPECT_FALSE(test, ext4_has_inline_data(inode));
+	KUNIT_EXPECT_TRUE(test, ext4_test_inode_flag(inode, EXT4_INODE_EXTENTS));
+	expect_converted_folio(test, inode, buf, sizeof(buf));
+
 	/*
-	 * 4. Successful conversion via ext4_convert_inline_data():
-	 * destroys inline data, initializes extent tree.
+	 * 6. data=journal: the folio's buffer is journalled as data and
+	 * dirtied through ext4_handle_dirty_metadata().
 	 */
+	reset_inode_state(ctx, S_IFREG | 0644);
+	ret = create_inline_file(inode, buf, sizeof(buf));
+	KUNIT_ASSERT_EQ(test, ret, 0);
+	truncate_inode_pages(&inode->i_data, 0);
+	ctx->journal_mode = EXT4_INODE_JOURNAL_DATA_MODE;
+	ctx->dirty_metadata_calls = 0;
+	ret = ext4_convert_inline_data(inode);
+	KUNIT_EXPECT_EQ(test, ret, 0);
+	KUNIT_EXPECT_FALSE(test, ext4_has_inline_data(inode));
+	KUNIT_EXPECT_GT(test, ctx->dirty_metadata_calls, 0);
+	expect_converted_folio(test, inode, buf, sizeof(buf));
+	ctx->journal_mode = EXT4_INODE_WRITEBACK_DATA_MODE;
+
+	/*
+	 * 7. Empty inline file: the inline data is dropped and no block is
+	 * mapped, so a failing ext4_map_blocks() must not be reached.
+	 */
+	reset_inode_state(ctx, S_IFREG | 0644);
+	ret = create_inline_file(inode, buf, sizeof(buf));
+	KUNIT_ASSERT_EQ(test, ret, 0);
+	i_size_write(inode, 0);
+	ctx->ei.i_disksize = 0;
+	ctx->map_blocks_ret = -EIO;
 	ret = ext4_convert_inline_data(inode);
 	KUNIT_EXPECT_EQ(test, ret, 0);
 	KUNIT_EXPECT_FALSE(test, ext4_has_inline_data(inode));
 	KUNIT_EXPECT_TRUE(test, ext4_test_inode_flag(inode, EXT4_INODE_EXTENTS));
+	ctx->map_blocks_ret = 1;
 }
 
 static void test_write_triggers_inline_to_extent_conversion(struct kunit *test)
-- 
2.56.1

