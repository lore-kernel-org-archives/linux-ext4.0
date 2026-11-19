Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=18.9.28.11
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795115858;
	b=guaIB3fyugr4gFASIUtmt+EiJA0RxukI/k9oQXyWQPCW55GJcbqDqN8eJJpZ5O1LFkSr
	 8Q5q0f8cFCtXvPr2LpiK4GERA6DjVmC1PnBJKIJEoyKoAy8uGyd1zTBXdCzsvpbl/TR0p
	 emv9vnGL6bPshL8YB3k/yD8y7hE3ttXepmq8uvs4b9eD18w8YYEYL9bR/c2qvUtKWcb18
	 Dh3RMsSwBxiUx58bh4yxyZP/HXcONC7RM6qHJXA3kRqdQYiJHqwWUlJIBwRKseYWu7OYL
	 sdBxC6QtODMTwLLpXS8nGMtUtbG0xI0F39Jlj7aIPPxKnvz6VxVQPlhCNMJSMPjwPAw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795115858;
	h=DMARC-Filter:Received:DKIM-Signature:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=ya3ptOiRMX6xQOyOzx6NJTWdcpX6/BnOV41bvCb/TrM=;
	b=mCuRSc++mGUgPbnYiyPJnLQOWnOXaM8A6xmlGmXiGLUkpc7KXhAdqlrmisEFE1MvKKfw
	 J7XzB4Q8MLl+uJZolAmo9tqfGM5sx5IguIvgN4NBT9DVIv78VkScFlhRCyTKcPODhZ/VB
	 FMSj8En9MU7ePF17Y6kElsSYe26oOKLJiVvtq8Fdv+pyvDhzwboKFVxtOt6KIquWzw6xm
	 USF+OBfLHeePtO46ZgGicO1qJy83whkfdnY6s7arOPKQN0qGx9nvfzxppKMV2yum6JCZg
	 7krlw4KcdAsEIPaYvYw6gGx0Px9Rer6UDDbW8Inz55mJxJl447DePugUsVaKydZBfyw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=mit.edu;
	spf=pass smtp.mailfrom=mit.edu;
	dkim=pass header.d=mit.edu header.i=@mit.edu header.a=rsa-sha256 header.s=outgoing header.b=NxbLwnwm;
	arc=none smtp.remote-ip=18.9.28.11
Received: from outgoing.mit.edu (outgoing-auth-1.mit.edu [18.9.28.11])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48521606A338
	for <linux-ext4@vger.kernel.org>; Thu, 19 Nov 2026 19:17:37 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 48521606A338
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mit.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=mit.edu header.i=@mit.edu header.a=rsa-sha256 header.s=outgoing header.b=NxbLwnwm
Received: from trampoline.thunk.org (pool-173-48-114-214.bstnma.fios.verizon.net [173.48.114.214])
	(authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
	by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 6AJJHYTp029951
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 19 Nov 2026 14:17:34 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mit.edu; s=outgoing;
	t=1795115855; bh=ya3ptOiRMX6xQOyOzx6NJTWdcpX6/BnOV41bvCb/TrM=;
	h=From:Subject:Date:Message-ID:MIME-Version;
	b=NxbLwnwm9d18+LNOjS11QGJfkgCxbdSiNm5+DSnCMx8n0t2P8MgxLjke/BgOwJgk2
	 VLEvQvnjpBvr9MrRZjZJaLMknenDxjxWLZFy+wSKt2+bzx+yr5oq3LzQbiXVrHCu7V
	 MpbT426B2hFv43VBh9qCnMUgliTcv0DbvcLD9ONwgRPart7z4kyEUv0ibcb2Q3dWGQ
	 5zs8V0gJtVsCORk8e0AEnuuyyX2K1WgXCdcJWiePIOk52UrvHMGuCpbKmWFL94TQNc
	 OLyYpKA+ZvKVp8Wp8zsT57fMU0LVqGZKKURaXHwYGZFaPr/MSv8ivxFQzrqVHmz5M9
	 6CT8pnDeuHpEQ==
Received: by trampoline.thunk.org (Postfix, from userid 15806)
	id 504622E0159; Thu, 19 Nov 2026 14:17:31 -0500 (EST)
From: "Theodore Ts'o" <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Cc: "Theodore Ts'o" <tytso@mit.edu>
Subject: [PATCH -v2 20/32] ext4: don't stop EXT4_IOC_GET_ES_CACHE at uncached ranges
Date: Thu, 19 Nov 2026 14:17:07 -0500
Message-ID: <20261119191719.1943298-21-tytso@mit.edu>
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
Content-Transfer-Encoding: 8bit

ext4_fill_es_cache_info() walks the extent status tree by calling
ext4_es_lookup_extent() with a next_lblk pointer and stops as soon as
the lookup misses.  ext4_es_lookup_extent() only fills in *next_lblk on
a hit, so any block in the requested range that is not covered by an
extent status entry terminates the walk.

The extent status tree commonly has such gaps, since entries are only
added for ranges that have been mapped and can be reclaimed by the
shrinker.  As a result EXT4_IOC_GET_ES_CACHE reports no extents at all
when the query starts in an uncached range, even if cached extents
follow, and a paginated query that resumes after an extent preceding
an uncached gap returns zero extents without FIEMAP_EXTENT_LAST, which
ends the iteration early and hides the rest of the cache.

Make ext4_es_lookup_extent() also report the start of the next cached
extent on a miss, derived from the last node visited during the tree
walk in the same way as __es_tree_search(), and have
ext4_fill_es_cache_info() skip ahead to it instead of giving up.  The
returned block is always greater than the looked up one, so the walk
still terminates, and 0 still means there are no further extents.

Extend the KUnit tests to check next_lblk on lookup misses and
ext4_get_es_cache() on a tree with leading and interior gaps.

Fixes: bb5835edcdf8 ("ext4: add new ioctl EXT4_IOC_GET_ES_CACHE")
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
---
 fs/ext4/extents-test.c        | 30 ++++++++++++++++++++++++++++++
 fs/ext4/extents.c             |  9 +++++++--
 fs/ext4/extents_status-test.c | 17 ++++++++++++++++-
 fs/ext4/extents_status.c      | 23 +++++++++++++++++++++++
 4 files changed, 76 insertions(+), 3 deletions(-)

diff --git a/fs/ext4/extents-test.c b/fs/ext4/extents-test.c
index 6458345ea958..543247c74cb1 100644
--- a/fs/ext4/extents-test.c
+++ b/fs/ext4/extents-test.c
@@ -2974,6 +2974,36 @@ static void test_ext_fiemap_and_get_es_cache(struct kunit *test)
 	KUNIT_ASSERT_EQ(test, err, 0);
 	KUNIT_EXPECT_EQ(test, fieinfo.fi_flags & FIEMAP_FLAG_CACHE, 0U);
 	KUNIT_EXPECT_GE(test, fieinfo.fi_extents_mapped, 5U);
+
+	/*
+	 * ES tree with uncached ranges [0, 10), [20, 50) and beyond 60:
+	 * ext4_get_es_cache() must skip over them instead of stopping, both
+	 * when the query starts in a leading uncached range and when a
+	 * paginated query resumes inside an uncached gap.
+	 */
+	down_write(&EXT4_I(inode)->i_data_sem);
+	ext4_es_remove_extent(inode, 0, EXT_MAX_BLOCKS);
+	ext4_es_insert_extent(inode, 10, 10, 400, EXTENT_STATUS_WRITTEN, 0);
+	ext4_es_insert_extent(inode, 50, 10, 500, EXTENT_STATUS_WRITTEN, 0);
+	up_write(&EXT4_I(inode)->i_data_sem);
+	inode->i_size = 100LL * 4096;
+	EXT4_I(inode)->i_disksize = 100LL * 4096;
+
+	memset(&fieinfo, 0, sizeof(fieinfo));
+	err = ext4_get_es_cache(inode, &fieinfo, 0, 100 * 4096);
+	KUNIT_EXPECT_EQ(test, err, 0);
+	KUNIT_EXPECT_EQ(test, fieinfo.fi_extents_mapped, 2U);
+
+	memset(&fieinfo, 0, sizeof(fieinfo));
+	err = ext4_get_es_cache(inode, &fieinfo, 20 * 4096, 80 * 4096);
+	KUNIT_EXPECT_EQ(test, err, 0);
+	KUNIT_EXPECT_EQ(test, fieinfo.fi_extents_mapped, 1U);
+
+	/* A query range entirely inside an uncached gap reports nothing */
+	memset(&fieinfo, 0, sizeof(fieinfo));
+	err = ext4_get_es_cache(inode, &fieinfo, 20 * 4096, 30 * 4096);
+	KUNIT_EXPECT_EQ(test, err, 0);
+	KUNIT_EXPECT_EQ(test, fieinfo.fi_extents_mapped, 0U);
 }
 
 static const struct kunit_ext_test_param test_split_convert_params[] = {
diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index 10d36012ade4..71e7d1e89417 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -2251,8 +2251,13 @@ static int ext4_fill_es_cache_info(struct inode *inode,
 	while (block <= end) {
 		next = 0;
 		flags = 0;
-		if (!ext4_es_lookup_extent(inode, block, &next, &es, NULL))
-			break;
+		if (!ext4_es_lookup_extent(inode, block, &next, &es, NULL)) {
+			/* Skip over an uncached range to the next extent */
+			if (next == 0)
+				break;
+			block = next;
+			continue;
+		}
 		if (ext4_es_is_unwritten(&es))
 			flags |= FIEMAP_EXTENT_UNWRITTEN;
 		if (ext4_es_is_delayed(&es))
diff --git a/fs/ext4/extents_status-test.c b/fs/ext4/extents_status-test.c
index 825d12513e4a..fb04e8982cb0 100644
--- a/fs/ext4/extents_status-test.c
+++ b/fs/ext4/extents_status-test.c
@@ -513,6 +513,7 @@ static void test_es_lookup_empty_tree_returns_miss(struct kunit *test)
 		&ctx->sbi->s_es_stats.es_stats_cache_misses);
 	ret = ext4_es_lookup_extent(inode, 10, &next_lblk, &es, NULL);
 	KUNIT_EXPECT_EQ(test, ret, 0);
+	KUNIT_EXPECT_EQ(test, next_lblk, 0U);
 	KUNIT_EXPECT_EQ(test, percpu_counter_sum_positive(
 		&ctx->sbi->s_es_stats.es_stats_cache_misses),
 		misses_before + 1);
@@ -585,9 +586,23 @@ test_es_lookup_hits_cache_and_rbtree_with_next_lblk(struct kunit *test)
 		&ctx->sbi->s_es_stats.es_stats_cache_hits),
 		hits_before + 4);
 
-	/* Lookup in gap [15..19] returns 0 */
+	/* Lookup in gap [15..19] returns 0 and points next_lblk at [20, 5) */
+	next_lblk = 0xdead;
 	ret = ext4_es_lookup_extent(inode, 15, &next_lblk, &es, NULL);
 	KUNIT_EXPECT_EQ(test, ret, 0);
+	KUNIT_EXPECT_EQ(test, next_lblk, 20U);
+
+	/* Miss before the first extent points next_lblk at [10, 5) */
+	next_lblk = 0xdead;
+	ret = ext4_es_lookup_extent(inode, 5, &next_lblk, &es, NULL);
+	KUNIT_EXPECT_EQ(test, ret, 0);
+	KUNIT_EXPECT_EQ(test, next_lblk, 10U);
+
+	/* Miss after the last extent sets next_lblk to 0 */
+	next_lblk = 0xdead;
+	ret = ext4_es_lookup_extent(inode, 30, &next_lblk, &es, NULL);
+	KUNIT_EXPECT_EQ(test, ret, 0);
+	KUNIT_EXPECT_EQ(test, next_lblk, 0U);
 }
 
 static void test_es_fc_replay_bypasses_tree_operations(struct kunit *test)
diff --git a/fs/ext4/extents_status.c b/fs/ext4/extents_status.c
index b7fb8502f9d4..a99b9d87d969 100644
--- a/fs/ext4/extents_status.c
+++ b/fs/ext4/extents_status.c
@@ -1087,6 +1087,10 @@ void ext4_es_cache_extent(struct inode *inode, ext4_lblk_t lblk,
  *
  * ext4_es_lookup_extent is called by ext4_map_blocks/ext4_da_map_blocks.
  *
+ * If @next_lblk is not NULL, it is set to the starting block of the first
+ * extent after @lblk in the tree, or 0 if there is none, regardless of
+ * whether @lblk itself was found.
+ *
  * Return: 1 on found, 0 on not
  */
 int ext4_es_lookup_extent(struct inode *inode, ext4_lblk_t lblk,
@@ -1157,6 +1161,25 @@ int ext4_es_lookup_extent(struct inode *inode, ext4_lblk_t lblk,
 			*pseq = EXT4_I(inode)->i_es_seq;
 	} else {
 		percpu_counter_inc(&stats->es_stats_cache_misses);
+		if (next_lblk) {
+			/*
+			 * es1 is the last node visited by the tree walk, so
+			 * it is either the successor or the predecessor of
+			 * @lblk (see __es_tree_search()).
+			 */
+			*next_lblk = 0;
+			if (es1 && lblk < es1->es_lblk) {
+				*next_lblk = es1->es_lblk;
+			} else if (es1) {
+				node = rb_next(&es1->rb_node);
+				if (node) {
+					es1 = rb_entry(node,
+						       struct extent_status,
+						       rb_node);
+					*next_lblk = es1->es_lblk;
+				}
+			}
+		}
 	}
 
 	read_unlock(&EXT4_I(inode)->i_es_lock);
-- 
2.56.1.708.g77570a6a1d-goog

