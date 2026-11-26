Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.53
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795676902;
	b=qJO6huA9s0WrrDjCRbV9mvEFTMMAlS9Qa2SBVni0iU6WPpMcGNZTJmJblIByD91kt1Nt
	 rANScZ0LNpvuQTZjY/q4DL5+H4I+3XY0Xdmy+N+YD7BoZkTNCG3zhPSOTNwZpKKbRLALg
	 KI9p8t6rp1bDAWqb7BPr2K64VEgQl9RPOeObfXN0HbY1F7pX1URP0EaOstoKaJFCHThEv
	 sG7PMwQJi0pxrf70yVS19zGP/sgaBi27ZKqo9JJlMLCj/sP0ugauG79fuoCcnmD0ArR2I
	 69h+p9MmllT2z19V3oDUQhm5hSy6uXoJwlNihDPuw5q/kjydfikMF+zGPdOC2Xtv4hg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795676902;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=97S8jXV0HnQEJfXyqtanW4x108PvFGwuKrpw7epybL8=;
	b=vvO0V8Cvqc+kiWUI4UBkSNYBy0lX1pQ9Fw8A+6gJ8OTvLahiljGyBoXQVpnPKWqClwVr
	 S6um3ll7EmFTz0p6S13UWymFsIxhv9/uK3FjIE2WPYASvZ0+wpDKDqqqUskzKxmvAsbSE
	 2JMqjPOH55+tQMJW9hixoXHpIbCXzRFrV88QQW8idNzp17sau6LPZaFU1VJW2jPzUIkzr
	 t5sjtp3h7wuKy67HSZPebnGQdWWJfVECgk5MyJAF/OmP7QgmM+F9CPubh3ktqT3NfIuF0
	 98m8mn29On7xLvUqCx4ogHuB7aLyWfYOdPiz0vtq4R5r+nKT36bH/eFfsE4AHyUqrCg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=Sk42BAhb;
	arc=none smtp.remote-ip=209.85.128.53
Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F26B606A327
	for <linux-ext4@vger.kernel.org>; Thu, 26 Nov 2026 07:08:22 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 4F26B606A327
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=Sk42BAhb
Received: by mail-wm1-f53.google.com with SMTP id 5b1f17b1804b1-4bb6ba3b244so67563395e9.3
        for <linux-ext4@vger.kernel.org>; Wed, 25 Nov 2026 23:08:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795676900; x=1796281700; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=97S8jXV0HnQEJfXyqtanW4x108PvFGwuKrpw7epybL8=;
        b=Sk42BAhbX5Ibcfu5TaWmwn9qZ32/fhdXhf/yj4d2AyJzyNKUgUHEXNTl8BVk4zRb9Q
         ugAKktFkIB+H938OccBMyhMeeKioyJzlRXiszTTo7wZs7x8a2ZSB5wpJie7imvaBWYKh
         qEbPK5hQV8RXBDRyO/seB+kEuy7b4xhYOU+Cg7Er4NBHDplNsCbzB/aoDMrQIRZYf9ep
         Q1vkDoimmOykCBs1/KhGsZeWCtM9yapDFH4nPgnYJMsvU8xFb5vWxd/CkyoSPgu77MS1
         LxLybqzZjV2I+94FIU04W6HKZdheT9SiLr29NvDBVaskefwFRtQD7L0S8sbyC5Aw0DV4
         jgTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795676900; x=1796281700;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=97S8jXV0HnQEJfXyqtanW4x108PvFGwuKrpw7epybL8=;
        b=YWFn5BFcslPkg61poKspKIg28U7NMySybDKq0/6yJVZfaW33s3zEOXXeUNo1hG1uP3
         BqZTBL6rp+NxY8tcj3z/uO9SdoH5gfocTXT5t300opyCeg+ynB3vQdtXEFJMQ5i7NJRJ
         1GIRvSMJZsiFWEADG3zqocFLB8sd2Tm/i7ehufg3RN3ZCTD/jq9scr0uAxmlxfBcRFEk
         d8qz6KVdpYeYVKgXJsnIwH4vWK6830yog0tjisn0jIxoHrYFGePx4VtsRaNcVXvboVsd
         pVY4k805iRjHHf83kqHheiyYXE67E5dQdf4EomzhtOiJZE/fZRCmA4lVheL70Zdom1Na
         Gfvw==
X-Forwarded-Encrypted: i=1; AL+hErFVFVUFuc7L+PUIPHgNhLg3DyhfLae13hO9eAczZGh87G8uuvQY1pWUwUoCbDquvCmIME0S4cBraqn+@vger.kernel.org
X-Gm-Message-State: APuU4Z9F4B00HlVuDzt1opYwM3gFWNz6Di3Zlo37cM58KOisw/8qVFD5
	wEdBcR1ZB4kCV6JXmm7ioWEW56WZ7+Uk9FS5RiomCFwJ0D/EG2ySC8xc
X-Gm-Gg: AZFdTZdOmnUHZP9p4vL0hKRzF2ROxiaEekNiLE5GUipctYdeNlOaa/EOgYhQO+N1eXq
	dMQmHX+KJi39QYl31AV8y/7nDRL9CTfRt3CL3eKC5Q83zNCdHMSCk72SjzxEOfU4R3DKTxfpcI/
	bXG232BeSU+/c8HFS5PTbBe/3yTpgbJwuGqDCEfkrtmigMU1UuVuuNiV32jlJUTIn7d5BbLoNAL
	CMatk6Rq1O9T1zYiF6SpXaCBYjqyZzehwepyrZ1vI4R9f2M7JgpmzE4MpSWbiQif/bmD90KqKYT
	ZaDPRY3wL2KXQvK35LJEwjI87Agbt4xVGSEuwiZD33iQJScZxuNpDWN6k4ZfNl/3NAKF0+hDs0P
	ZjBLDIQkFltSWqsgaLOUatOACHtuiQf01+BR3UCdSTfDa6l5ZNs88SlsWwRr7OsWj/cdPUVIBTX
	Ow9JAU2yUUywTmNJxEsQ4vsGY7YMI+c6JQmXe5E4os42W3GGcZDbdU2D6IvqqgOQoSSWHc/Ag6n
	MOCVrVlwq8TDH8WQ+LhtKidBrHApwdXharS5NNnTGr7BTivjh3QP7LC6K9xMfqena8nLaHHLgNh
	geOOGAm8GphC1RwNYvTNVQup7MBxLNyCDN3toAKL/x9MV2NroQ==
X-Received: by 2002:a05:600c:154e:b0:4a3:59ee:86b with SMTP id 5b1f17b1804b1-4bb887c3b63mr430887455e9.4.1795676900395;
        Wed, 25 Nov 2026 23:08:20 -0800 (PST)
Received: from DESKTOP-V28CTA4.dbs.corp ([110.93.227.54])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4bb8538b09bsm1071077895e9.4.2026.11.25.23.08.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Nov 2026 23:08:19 -0800 (PST)
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
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Subject: [PATCH v4 2/5] ext4: fix delayed-allocation inline data conversion races
Date: Thu, 26 Nov 2026 12:07:46 +0500
Message-ID: <20261126070748.272109-4-arbabhaider649@gmail.com>
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

Commit ef09ed5d37b8 ("ext4: fix bug_on in ext4_writepages") attempted to
prevent ext4_convert_inline_data() from racing with delayed-allocation
inline data conversion by calling filemap_flush() when
EXT4_STATE_MAY_INLINE_DATA is already cleared.

However, several races remain in the delayed-allocation inline handoff:

1. filemap_flush() is asynchronous (WB_SYNC_NONE) and can return 0 while
   folio 0 is locked by a concurrent buffered write and
   ext4_has_inline_data(inode) is still true.  ext4_convert_inline_data()
   then proceeds to ext4_convert_inline_data_nolock() even though
   EXT4_STATE_MAY_INLINE_DATA is already cleared (meaning
   ext4_da_convert_inline_data_to_extent() has already moved the data into
   dirty folio 0), either copying stale on-disk inline data or rolling
   back via ext4_restore_inline_data() and re-setting
   EXT4_STATE_MAY_INLINE_DATA while writeback is pending, triggering:

     kernel BUG at fs/ext4/inode.c:3028!
     RIP: 0010:ext4_do_writepages+0x25c0/0x39a0
     Call Trace:
      ext4_writepages+0x285/0x500
      do_writepages+0x205/0x520
      filemap_writeback+0x1a6/0x250
      file_write_and_wait_range+0x8c/0x150
      ext4_sync_file+0x2cf/0x950
      ext4_buffered_write_iter+0x428/0x5d0
      ext4_file_write_iter+0x7cb/0x1450

2. In ext4_da_convert_inline_data_to_extent(), folio_mark_dirty(folio)
   was called before ext4_clear_inode_state(EXT4_STATE_MAY_INLINE_DATA),
   and ext4_do_writepages() tested EXT4_STATE_MAY_INLINE_DATA before
   acquiring xattr_sem.  On concurrent or weakly ordered CPUs, writeback
   can observe PAGECACHE_TAG_DIRTY with EXT4_STATE_MAY_INLINE_DATA still
   set and hit BUG_ON() in ext4_do_writepages().

3. When an inode already in delayed allocation
   (!EXT4_STATE_MAY_INLINE_DATA) is truncated to i_size == 0 in
   ext4_inline_data_truncate() or drops a failed write at i_size == 0 in
   ext4_da_truncate_failed_write(), dirty folio 0 and delayed extents are
   dropped while EXT4_INODE_INLINE_DATA remains set with
   !EXT4_STATE_MAY_INLINE_DATA and no dirty pages.  Also, when truncated
   to i_size == inline_size, ext4_inline_data_truncate() skipped removing
   delayed extents beyond i_size because ext4_es_remove_extent() was
   inside if (i_size < inline_size).

Fix the delayed-allocation handoff:

- In ext4_da_convert_inline_data_to_extent(), hold xattr_sem for write
  and clear EXT4_STATE_MAY_INLINE_DATA before marking folio 0 dirty, and
  in writeback validate the handoff and remove inline data under the
  same xattr_sem write lock. Return an error if the handoff is
  incomplete or removing inline data fails.
- In ext4_convert_inline_data(), serialize the initial and post-writeback
  state checks under down_read(&xattr_sem) (with a lockless fast path when
  neither EXT4_INODE_INLINE_DATA nor EXT4_STATE_MAY_INLINE_DATA is set),
  use synchronous filemap_write_and_wait() when
  !EXT4_STATE_MAY_INLINE_DATA, return ext4_emergency_state() or -EIO if
  ext4_has_inline_data(inode) still holds after writeback, and re-check
  EXT4_STATE_MAY_INLINE_DATA under ext4_write_lock_xattr() with a retry.
- In ext4_inline_data_truncate(), finish destroying inline data via
  ext4_destroy_inline_data_nolock() when !EXT4_STATE_MAY_INLINE_DATA and
  inode->i_size == 0, and remove delayed extents beyond i_size even when
  i_size == inline_size.  In ext4_da_truncate_failed_write(), call
  ext4_truncate() when inode->i_size == 0 with EXT4_INODE_INLINE_DATA set
  and !EXT4_STATE_MAY_INLINE_DATA (falling back to ext4_es_remove_extent()
  if ext4_truncate() fails).
- Update test_convert_inline_data_and_rollback() in fs/ext4/inline-test.c
  to match the new -EIO behavior when !EXT4_STATE_MAY_INLINE_DATA remains
  inline after writeback, and also cover normal conversion with
  EXT4_STATE_MAY_INLINE_DATA set.

Fixes: ef09ed5d37b8 ("ext4: fix bug_on in ext4_writepages")
Cc: stable@vger.kernel.org
Signed-off-by: Arbab Haider <arbabhaider649@gmail.com>
---
 fs/ext4/inline-test.c |  17 ++++++-
 fs/ext4/inline.c      | 104 ++++++++++++++++++++++++++++++++----------
 fs/ext4/inode.c       |  18 ++++++--
 3 files changed, 111 insertions(+), 28 deletions(-)

diff --git a/fs/ext4/inline-test.c b/fs/ext4/inline-test.c
index 0198ce831..006c5b3ea 100644
--- a/fs/ext4/inline-test.c
+++ b/fs/ext4/inline-test.c
@@ -717,6 +717,11 @@ static void test_write_and_destroy_inline_data(struct kunit *test)
 	KUNIT_ASSERT_FALSE(test, IS_ERR(handle));
 	ret = ext4_get_inode_loc(inode, &iloc);
 	KUNIT_ASSERT_EQ(test, ret, 0);
+	ext4_set_inode_state(inode, EXT4_STATE_MAY_INLINE_DATA);
+	ret = ext4_destroy_inline_data(handle, inode);
+	KUNIT_EXPECT_EQ(test, ret, -EIO);
+	KUNIT_EXPECT_TRUE(test, ext4_has_inline_data(inode));
+	ext4_clear_inode_state(inode, EXT4_STATE_MAY_INLINE_DATA);
 	ret = ext4_destroy_inline_data(handle, inode);
 	KUNIT_EXPECT_EQ(test, ret, 0);
 	KUNIT_EXPECT_FALSE(test, ext4_has_inline_data(inode));
@@ -741,6 +746,7 @@ static void test_write_and_destroy_inline_data(struct kunit *test)
 
 	handle = ext4_journal_start(inode, EXT4_HT_INODE, 1);
 	KUNIT_ASSERT_FALSE(test, IS_ERR(handle));
+	ext4_clear_inode_state(inode, EXT4_STATE_MAY_INLINE_DATA);
 	ret = ext4_destroy_inline_data(handle, inode);
 	KUNIT_EXPECT_EQ(test, ret, 0);
 	KUNIT_EXPECT_FALSE(test, ext4_test_inode_flag(inode, EXT4_INODE_EXTENTS));
@@ -1139,14 +1145,23 @@ static void test_convert_inline_data_and_rollback(struct kunit *test)
 
 	/*
 	 * 2. Inline inode without EXT4_STATE_MAY_INLINE_DATA -> calls
-	 * filemap_flush() and finishes converting inline data if still inline.
+	 * filemap_write_and_wait() and returns -EIO if still inline instead of
+	 * falling through to ext4_convert_inline_data_nolock(). With
+	 * EXT4_STATE_MAY_INLINE_DATA set, converts inline data to an extent.
 	 */
 	ret = create_inline_file(inode, buf, sizeof(buf));
 	KUNIT_ASSERT_EQ(test, ret, 0);
 	ext4_clear_inode_state(inode, EXT4_STATE_MAY_INLINE_DATA);
 	ret = ext4_convert_inline_data(inode);
+	KUNIT_EXPECT_EQ(test, ret, -EIO);
+	KUNIT_EXPECT_TRUE(test, ext4_has_inline_data(inode));
+
+	ext4_set_inode_state(inode, EXT4_STATE_MAY_INLINE_DATA);
+	ret = ext4_convert_inline_data(inode);
 	KUNIT_EXPECT_EQ(test, ret, 0);
 	KUNIT_EXPECT_FALSE(test, ext4_has_inline_data(inode));
+	KUNIT_EXPECT_FALSE(test,
+			   ext4_test_inode_state(inode, EXT4_STATE_MAY_INLINE_DATA));
 	KUNIT_EXPECT_MEMEQ(test, ctx->data_block_buf, buf, sizeof(buf));
 
 	/*
diff --git a/fs/ext4/inline.c b/fs/ext4/inline.c
index acdc65ce4..df50b0483 100644
--- a/fs/ext4/inline.c
+++ b/fs/ext4/inline.c
@@ -921,7 +921,7 @@ static int ext4_da_convert_inline_data_to_extent(struct address_space *mapping,
 	if (IS_ERR(folio))
 		return PTR_ERR(folio);
 
-	down_read(&EXT4_I(inode)->xattr_sem);
+	down_write(&EXT4_I(inode)->xattr_sem);
 	if (!ext4_has_inline_data(inode)) {
 		ext4_clear_inode_state(inode, EXT4_STATE_MAY_INLINE_DATA);
 		goto out;
@@ -938,7 +938,7 @@ static int ext4_da_convert_inline_data_to_extent(struct address_space *mapping,
 	ret = ext4_block_write_begin(NULL, folio, 0, inline_size,
 				     ext4_da_get_block_prep);
 	if (ret) {
-		up_read(&EXT4_I(inode)->xattr_sem);
+		up_write(&EXT4_I(inode)->xattr_sem);
 		folio_unlock(folio);
 		folio_put(folio);
 		ext4_truncate_failed_write(inode);
@@ -946,12 +946,19 @@ static int ext4_da_convert_inline_data_to_extent(struct address_space *mapping,
 	}
 
 	clear_buffer_new(folio_buffers(folio));
+	/*
+	 * Clear EXT4_STATE_MAY_INLINE_DATA before marking folio 0 dirty so
+	 * concurrent writeback cannot see PAGECACHE_TAG_DIRTY while
+	 * EXT4_STATE_MAY_INLINE_DATA is still set. Holding xattr_sem for
+	 * write prevents ext4_convert_inline_data() from observing the
+	 * cleared state before folio 0 is dirtied.
+	 */
+	ext4_clear_inode_state(inode, EXT4_STATE_MAY_INLINE_DATA);
 	folio_mark_dirty(folio);
 	folio_mark_uptodate(folio);
-	ext4_clear_inode_state(inode, EXT4_STATE_MAY_INLINE_DATA);
 
 out:
-	up_read(&EXT4_I(inode)->xattr_sem);
+	up_write(&EXT4_I(inode)->xattr_sem);
 	if (folio) {
 		folio_unlock(folio);
 		folio_put(folio);
@@ -1842,10 +1849,18 @@ bool empty_inline_dir(struct inode *dir, int *has_inline_data)
 
 int ext4_destroy_inline_data(handle_t *handle, struct inode *inode)
 {
-	int ret, no_expand;
+	int ret = 0, no_expand;
 
 	ext4_write_lock_xattr(inode, &no_expand);
+	if (!ext4_has_inline_data(inode))
+		goto out;
+	/* Only writeback of a completed delayed-allocation handoff may proceed. */
+	if (ext4_test_inode_state(inode, EXT4_STATE_MAY_INLINE_DATA)) {
+		ret = -EIO;
+		goto out;
+	}
 	ret = ext4_destroy_inline_data_nolock(handle, inode);
+out:
 	ext4_write_unlock_xattr(inode, &no_expand);
 
 	return ret;
@@ -1914,6 +1929,25 @@ int ext4_inline_data_truncate(struct inode *inode, int *has_inline)
 	if ((err = ext4_orphan_add(handle, inode)) != 0)
 		goto out;
 
+	/*
+	 * If the file was already moved to delayed allocation
+	 * (!EXT4_STATE_MAY_INLINE_DATA) and is now truncated to zero,
+	 * truncate_pagecache() has already dropped dirty folio 0. Finish
+	 * converting the empty inode out of inline data here instead of
+	 * leaving EXT4_INODE_INLINE_DATA set with !EXT4_STATE_MAY_INLINE_DATA
+	 * and no dirty pages.
+	 */
+	if (!ext4_test_inode_state(inode, EXT4_STATE_MAY_INLINE_DATA) &&
+	    inode->i_size == 0) {
+		down_write(&EXT4_I(inode)->i_data_sem);
+		EXT4_I(inode)->i_disksize = 0;
+		ext4_es_remove_extent(inode, 0, EXT_MAX_BLOCKS);
+		up_write(&EXT4_I(inode)->i_data_sem);
+
+		err = ext4_destroy_inline_data_nolock(handle, inode);
+		goto out;
+	}
+
 	if ((err = ext4_get_inode_loc(inode, &is.iloc)) != 0)
 		goto out;
 
@@ -1922,20 +1956,19 @@ int ext4_inline_data_truncate(struct inode *inode, int *has_inline)
 	inline_size = ext4_get_inline_size(inode);
 	EXT4_I(inode)->i_disksize = i_size;
 
-	if (i_size < inline_size) {
-		/*
-		 * if there's inline data to truncate and this file was
-		 * converted to extents after that inline data was written,
-		 * the extent status cache must be cleared to avoid leaving
-		 * behind stale delayed allocated extent entries
-		 */
-		if (!ext4_test_inode_state(inode, EXT4_STATE_MAY_INLINE_DATA)) {
-			ext4_lblk_t lblk = EXT4_B_TO_LBLK(inode, i_size);
+	/*
+	 * If this file was moved to delayed allocation
+	 * (!EXT4_STATE_MAY_INLINE_DATA), remove delayed extents beyond the
+	 * new i_size while keeping block 0 if i_size > 0 (folio 0 is still
+	 * dirty in the page cache).
+	 */
+	if (!ext4_test_inode_state(inode, EXT4_STATE_MAY_INLINE_DATA)) {
+		ext4_lblk_t lblk = EXT4_B_TO_LBLK(inode, inode->i_size);
 
-			ext4_es_remove_extent(inode, lblk,
-					      EXT_MAX_BLOCKS - lblk);
-		}
+		ext4_es_remove_extent(inode, lblk, EXT_MAX_BLOCKS - lblk);
+	}
 
+	if (i_size < inline_size) {
 		/* Clear the content in the xattr space. */
 		if (inline_size > EXT4_MIN_INLINE_DATA_SIZE) {
 			if ((err = ext4_xattr_ibody_find(inode, &i, &is)) != 0)
@@ -2005,22 +2038,40 @@ int ext4_convert_inline_data(struct inode *inode)
 	handle_t *handle;
 	struct ext4_iloc iloc;
 
+retry:
+	if (!ext4_has_inline_data(inode) &&
+	    !ext4_test_inode_state(inode, EXT4_STATE_MAY_INLINE_DATA))
+		return 0;
+
+	down_read(&EXT4_I(inode)->xattr_sem);
 	if (!ext4_has_inline_data(inode)) {
 		ext4_clear_inode_state(inode, EXT4_STATE_MAY_INLINE_DATA);
+		up_read(&EXT4_I(inode)->xattr_sem);
 		return 0;
-	} else if (!ext4_test_inode_state(inode, EXT4_STATE_MAY_INLINE_DATA)) {
+	}
+	if (!ext4_test_inode_state(inode, EXT4_STATE_MAY_INLINE_DATA)) {
+		up_read(&EXT4_I(inode)->xattr_sem);
 		/*
 		 * Inode has inline data but EXT4_STATE_MAY_INLINE_DATA is
 		 * cleared. This means we are in the middle of moving of
-		 * inline data to delay allocated block. Just force writeout
-		 * here to finish conversion.
+		 * inline data to delay allocated block. Force synchronous
+		 * writeout here to finish conversion.
 		 */
-		error = filemap_flush(inode->i_mapping);
+		error = filemap_write_and_wait(inode->i_mapping);
 		if (error)
 			return error;
-		if (!ext4_has_inline_data(inode))
+		down_read(&EXT4_I(inode)->xattr_sem);
+		if (!ext4_has_inline_data(inode)) {
+			up_read(&EXT4_I(inode)->xattr_sem);
 			return 0;
+		}
+		up_read(&EXT4_I(inode)->xattr_sem);
+		error = ext4_emergency_state(inode->i_sb);
+		if (error)
+			return error;
+		return -EIO;
 	}
+	up_read(&EXT4_I(inode)->xattr_sem);
 
 	needed_blocks = ext4_chunk_trans_extent(inode, 1);
 
@@ -2036,8 +2087,15 @@ int ext4_convert_inline_data(struct inode *inode)
 	}
 
 	ext4_write_lock_xattr(inode, &no_expand);
-	if (ext4_has_inline_data(inode))
+	if (ext4_has_inline_data(inode)) {
+		if (!ext4_test_inode_state(inode, EXT4_STATE_MAY_INLINE_DATA)) {
+			ext4_write_unlock_xattr(inode, &no_expand);
+			ext4_journal_stop(handle);
+			brelse(iloc.bh);
+			goto retry;
+		}
 		error = ext4_convert_inline_data_nolock(handle, inode, &iloc);
+	}
 	ext4_write_unlock_xattr(inode, &no_expand);
 	ext4_journal_stop(handle);
 out_free:
diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 07a62d856..f27aeae02 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -3019,16 +3019,20 @@ static int ext4_do_writepages(struct mpage_da_data *mpd)
 	 * we'd better clear the inline data here.
 	 */
 	if (ext4_has_inline_data(inode)) {
+		int stop_err;
+
 		/* Just inode will be modified... */
 		handle = ext4_journal_start(inode, EXT4_HT_INODE, 1);
 		if (IS_ERR(handle)) {
 			ret = PTR_ERR(handle);
 			goto out_writepages;
 		}
-		BUG_ON(ext4_test_inode_state(inode,
-				EXT4_STATE_MAY_INLINE_DATA));
-		ext4_destroy_inline_data(handle, inode);
-		ext4_journal_stop(handle);
+		ret = ext4_destroy_inline_data(handle, inode);
+		stop_err = ext4_journal_stop(handle);
+		if (!ret)
+			ret = stop_err;
+		if (ret)
+			goto out_writepages;
 	}
 
 	/*
@@ -3437,9 +3441,15 @@ static void ext4_da_truncate_failed_write(struct inode *inode)
 
 	filemap_invalidate_lock(mapping);
 	truncate_inode_pages(mapping, inode->i_size);
+	if (inode->i_size == 0 && ext4_has_inline_data(inode) &&
+	    !ext4_test_inode_state(inode, EXT4_STATE_MAY_INLINE_DATA)) {
+		if (!ext4_truncate(inode))
+			goto out_unlock;
+	}
 	down_write(&EXT4_I(inode)->i_data_sem);
 	ext4_es_remove_extent(inode, lblk, EXT_MAX_BLOCKS - lblk);
 	up_write(&EXT4_I(inode)->i_data_sem);
+out_unlock:
 	filemap_invalidate_unlock(mapping);
 }
 
-- 
2.53.0

