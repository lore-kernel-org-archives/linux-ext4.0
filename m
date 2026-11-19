Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=18.9.28.11
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795115863;
	b=HH76+8+zxlHlCC3s1StNFs36ZSfm9oAkLEOxG2mcQ8vDl7d791RqBy25b1U43+dHqGZ4
	 db7u+qhGxvERvMDocrfUNjcGvUmJVdPK9trqaA5clJwInB3zEAUKqNZ6X4CBs4j/Fp92a
	 UHR/Uqtr6dKJaaewWwzKyqIPpwNORJr7yQG1XMQKZj1yHhrmtWk6UU81eyqXj8NMh8iYR
	 WzE4uZt9Rr6WuCdThSadgfnJs5a3Ss5cUfrFBmiIkQ3kuSogbdxbhUJdWLx+0Hgu3/wE1
	 cVcrVDAfpKkJCLbH16YXGIFqkGQNZr1REF3laFc6AtIdk7X1Yu4afZ+pM6QzIkySShA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795115863;
	h=DMARC-Filter:Received:DKIM-Signature:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Type:Content-Transfer-Encoding;
	bh=R88qBqdrpNRVJZW5mVO3jsLJ0GXmAl8K7yzOf7f/DE4=;
	b=HFiGtWbP3J4tA3SMHm0+bimAHBWRfImr2ixPNx91eR95/OXB9fd0tYO/d4YsU2Stl3la
	 b39yiQZ3Ug0q/0RzHfVwLZhGRDLzjjXw0B9RYyhzcBemyFaeFoYYt5m/HjyUb8XQzV8o+
	 y4ssmNrleoxqaCd2qvjETKibM/EVatcV1rfeWf864TB+9tyWF/t57xjcWrFJ8/jiXquQI
	 l1R1v1zs61LM1QxIOiSwGTclHm69FdwJY+/IayzKKe3oYTbYafJUu/YvYkp03C7LpRF3V
	 iaB2gymGnLt6mHnOF+w8d2c2MAy1PPoYMbmOcirthlHmzdOWqm2u1qwClQMiyRiBcDw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=mit.edu;
	spf=pass smtp.mailfrom=mit.edu;
	dkim=pass header.d=mit.edu header.i=@mit.edu header.a=rsa-sha256 header.s=outgoing header.b=fFhOF2Vm;
	arc=none smtp.remote-ip=18.9.28.11
Received: from outgoing.mit.edu (outgoing-auth-1.mit.edu [18.9.28.11])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5AC060A2615
	for <linux-ext4@vger.kernel.org>; Thu, 19 Nov 2026 19:17:42 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org A5AC060A2615
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mit.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=mit.edu header.i=@mit.edu header.a=rsa-sha256 header.s=outgoing header.b=fFhOF2Vm
Received: from trampoline.thunk.org (pool-173-48-114-214.bstnma.fios.verizon.net [173.48.114.214])
	(authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
	by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 6AJJHYEX029986
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 19 Nov 2026 14:17:34 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mit.edu; s=outgoing;
	t=1795115855; bh=R88qBqdrpNRVJZW5mVO3jsLJ0GXmAl8K7yzOf7f/DE4=;
	h=From:Subject:Date:Message-ID:MIME-Version:Content-Type;
	b=fFhOF2VmlmIs/h9KsBSqw8dz/TfBXkVM45FmcO4CA/xvYKTY1eM5GRTGT1PtEyZq4
	 90TOSf9ytwhPGjKhXGl84jC5wEe93DU4JnTBrZpVlKMUs5PWfw6QKDAg0NiqWIqio+
	 LgQyQTIvu7BR9mFZ3CKeFZomv+JIBwo1ZoghgruNI5WgpODLghC00xmXLmxZP03sf6
	 H2lHxow5gLVMN+nPnQ/fIDsDdBonI1MWt0sELbPWZblkYhlz+LD+OIEaCxd6jYQ97i
	 KilkeavIOQ47M5F1PjhNPQWIYrUUxZJgQyy7cR7LmLOwiSbHzXNJrq+F1/0LSYlw1c
	 k5+Gc3P3OPyDA==
Received: by trampoline.thunk.org (Postfix, from userid 15806)
	id 685202E0160; Thu, 19 Nov 2026 14:17:31 -0500 (EST)
From: "Theodore Ts'o" <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Cc: "Theodore Ts'o" <tytso@mit.edu>, stable@kernel.org
Subject: [PATCH -v2 27/32] ext4: zero dirty EOF folio tail before raising i_size in ext4_setattr()
Date: Thu, 19 Nov 2026 14:17:14 -0500
Message-ID: <20261119191719.1943298-28-tytso@mit.edu>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261119191719.1943298-1-tytso@mit.edu>
References: <20261119191719.1943298-1-tytso@mit.edu>
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

When extending a file with ext4_setattr() where blocksize < PAGE_SIZE
(or on a large folio whose size exceeds blocksize) and oldsize is
block-aligned (or falls short of the folio end), ext4_block_zero_eof()
only zeroes up to the next block boundary.  The remaining post-EOF
bytes in the dirty tail folio were not zeroed until
pagecache_isize_extended() ran after ext4_journal_stop() — leaving a
window after i_size_write() in which concurrent readers or writeback
could observe unzeroed post-EOF pagecache data from prior mmap writes.

Add ext4_zero_eof_folio_tail() and call it before ext4_journal_start()
and ext4_set_inode_size() in ext4_truncate_up() to zero dirty post-EOF
folio bytes before exposing the larger i_size, while keeping
pagecache_isize_extended() after ext4_journal_stop() so folio_mkclean()
runs after i_size is updated.

Extend inode_test_setattr() in ext4_inode_test to verify that with a
1 KiB block size and a dirty EOF folio, extending from 1024 to PAGE_SIZE
zeroes [1024, PAGE_SIZE) before __ext4_mark_inode_dirty() observes the
updated i_size.

Fixes: 52aecaee1c26 ("mm: zero range of eof folio exposed by inode size extension")
Cc: stable@kernel.org
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
---
 fs/ext4/inode-test.c | 75 ++++++++++++++++++++++++++++++++++++++++++++
 fs/ext4/inode.c      | 28 +++++++++++++++++
 2 files changed, 103 insertions(+)

diff --git a/fs/ext4/inode-test.c b/fs/ext4/inode-test.c
index 8a3d753b7079..5671e674cffa 100644
--- a/fs/ext4/inode-test.c
+++ b/fs/ext4/inode-test.c
@@ -3545,6 +3545,36 @@ static void inode_test_buffered_write_and_folio_ops(struct kunit *test)
  * -------------------------------------------------------------------------
  */
 
+struct setattr_dirty_snap {
+	bool seen;
+	loff_t isize;
+	u8 pre_eof_byte;
+	u8 post_eof_start_byte;
+	u8 post_eof_end_byte;
+};
+
+static struct setattr_dirty_snap setattr_snap;
+
+static int inode_test_setattr_dirty_stub(handle_t *handle, struct inode *inode,
+					 const char *func, unsigned int line)
+{
+	struct folio *folio;
+	u8 *kaddr;
+
+	setattr_snap.seen = true;
+	setattr_snap.isize = i_size_read(inode);
+	folio = filemap_get_folio(inode->i_mapping, 0);
+	if (!IS_ERR(folio)) {
+		kaddr = kmap_local_folio(folio, 0);
+		setattr_snap.pre_eof_byte = kaddr[1023];
+		setattr_snap.post_eof_start_byte = kaddr[1024];
+		setattr_snap.post_eof_end_byte = kaddr[PAGE_SIZE - 1];
+		kunmap_local(kaddr);
+		folio_put(folio);
+	}
+	return 0;
+}
+
 static void inode_test_setattr(struct kunit *test)
 {
 	struct inode_test_ctx *ctx = inode_test_setup(test);
@@ -3642,6 +3672,51 @@ static void inode_test_setattr(struct kunit *test)
 	KUNIT_EXPECT_EQ(test, inode->i_size, 4096LL);
 	KUNIT_EXPECT_EQ(test, ctx->ei.i_disksize, 4096LL);
 	KUNIT_EXPECT_EQ(test, ctx->total_freed_blocks, 1UL);
+
+	/*
+	 * 6. Sub-page blocksize (1024 < PAGE_SIZE) extending truncate from
+	 *    block-aligned oldsize = 1024 to PAGE_SIZE must zero dirty post-EOF
+	 *    bytes in the tail folio BEFORE i_size is raised and marked dirty.
+	 */
+	inode_test_reset_mock_inode(ctx, S_IFREG | 0644);
+	ctx->sb->s_blocksize = 1024;
+	ctx->sb->s_blocksize_bits = 10;
+	inode->i_blkbits = 10;
+	inode->i_size = 1024;
+	ctx->ei.i_disksize = 1024;
+
+	folio = filemap_grab_folio(inode->i_mapping, 0);
+	KUNIT_ASSERT_FALSE(test, IS_ERR(folio));
+	create_empty_buffers(folio, 1024, 0);
+	kaddr = kmap_local_folio(folio, 0);
+	memset(kaddr, 0x55, 1024);
+	memset(kaddr + 1024, 0xaa, PAGE_SIZE - 1024);
+	kunmap_local(kaddr);
+	folio_mark_uptodate(folio);
+	folio_mark_dirty(folio);
+	folio_unlock(folio);
+	folio_put(folio);
+
+	memset(&setattr_snap, 0, sizeof(setattr_snap));
+	kunit_activate_static_stub(test, __ext4_mark_inode_dirty,
+				   inode_test_setattr_dirty_stub);
+	attr = (struct iattr){ .ia_valid = ATTR_SIZE, .ia_size = PAGE_SIZE };
+	inode_lock(inode);
+	err = ext4_setattr(&nop_mnt_idmap, &dentry, &attr);
+	inode_unlock(inode);
+	kunit_deactivate_static_stub(test, __ext4_mark_inode_dirty);
+
+	KUNIT_ASSERT_EQ(test, err, 0);
+	KUNIT_ASSERT_TRUE(test, setattr_snap.seen);
+	KUNIT_EXPECT_EQ(test, setattr_snap.isize, (loff_t)PAGE_SIZE);
+	KUNIT_EXPECT_EQ(test, setattr_snap.pre_eof_byte, (u8)0x55);
+	KUNIT_EXPECT_EQ(test, setattr_snap.post_eof_start_byte, (u8)0x00);
+	KUNIT_EXPECT_EQ(test, setattr_snap.post_eof_end_byte, (u8)0x00);
+
+	truncate_inode_pages_final(inode->i_mapping);
+	ctx->sb->s_blocksize = INODE_TEST_BLK_SIZE;
+	ctx->sb->s_blocksize_bits = INODE_TEST_BLK_BITS;
+	inode->i_blkbits = INODE_TEST_BLK_BITS;
 }
 
 /* -------------------------------------------------------------------------
diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 9368a68db289..d4371e94503b 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -7036,6 +7036,28 @@ static inline void ext4_set_inode_size(struct inode *inode, loff_t newsize)
 	up_write(&EXT4_I(inode)->i_data_sem);
 }
 
+static void ext4_zero_eof_folio_tail(struct inode *inode, loff_t from,
+				     loff_t to)
+{
+	struct folio *folio;
+
+	if (IS_DAX(inode) || from >= to)
+		return;
+	folio = filemap_lock_folio(inode->i_mapping, from >> PAGE_SHIFT);
+	if (IS_ERR(folio))
+		return;
+	if (folio_test_dirty(folio) && from > folio_pos(folio)) {
+		size_t offset = from - folio_pos(folio);
+		size_t end = min_t(loff_t, to - folio_pos(folio),
+				   folio_size(folio));
+
+		if (offset < end)
+			folio_zero_segment(folio, offset, end);
+	}
+	folio_unlock(folio);
+	folio_put(folio);
+}
+
 static int ext4_truncate_up(struct inode *inode, loff_t oldsize, loff_t newsize)
 {
 	ext4_lblk_t old_lblk, new_lblk;
@@ -7054,6 +7076,12 @@ static int ext4_truncate_up(struct inode *inode, loff_t oldsize, loff_t newsize)
 		if (ret)
 			return ret;
 	}
+	/*
+	 * Zero any dirty post-EOF bytes in the tail folio before publishing
+	 * the larger i_size so concurrent readers cannot observe stale
+	 * pagecache data before pagecache_isize_extended().
+	 */
+	ext4_zero_eof_folio_tail(inode, oldsize, newsize);
 
 	handle = ext4_journal_start(inode, EXT4_HT_INODE, 3);
 	if (IS_ERR(handle))
-- 
2.56.1.708.g77570a6a1d-goog

