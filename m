Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=18.9.28.11
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794458846;
	b=tqfk8aTDS2l6DnJ30MW76bKsFps81fkX9zbDVOO+NUUWu2p6DgM026f4OqJt12/FxFsF
	 yueZas2UcpglpnmKoL97wciZLGXbv4lGIVDqPQ+WWMh82VJ66hwxPzLn07AKwT1+pV3/v
	 BibsBqxwtEIPbofQR/z+Vw06N2BV+snWSHXMvHAWHf2ojfgsk6eLExM4hUKA1331Y+5w+
	 JMpxkXu4EGxsSSIPhB96efarjM+zdveELVCNFsfkAcgVCZJ/WGt5zXu2RvkTwGCdCW75Y
	 C0obHaXCD2cfQdASEPO31n2lrziaGfBlmK325y0UwFiuaZhMQcF2E/AH1Wi/bAXbE+Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794458846;
	h=DMARC-Filter:Received:DKIM-Signature:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=VZv9xDxTJFsmz63+9WNys6Ww/eG6VIqF/SBp0U9Bsu4=;
	b=Rvb/8iA04X58/wwah2xgRWzoY9tsBnN0+dZMHr8ZbdGCEJ7S3xiiWVrPHVmyHMTWantQ
	 /2wqAwmD9qI9z4Fta6ZNh8GmS4szoXEqkbKiXBx0a6efYCdLUkoarmUsZwz95WupSf/gQ
	 LzivJDoWx1d1Ax0YLt9GnmCIqweLQ4VCH7pAsWoa+J6uKsa8/WFO0Qu+nyPgad97EKVe8
	 X3IkBTaDlGOJh07GgnWAeQXw3NQ9nHTmfX2EMPZxlgbGukfQg9hDewNi7gyQUl6yU5ugn
	 HeKalOAIAnj0XBT2Z3OLwmwV+mClZF18+pC1A3UUbevgdKMvlDMt+9wGwStNkON//lA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=mit.edu;
	spf=pass smtp.mailfrom=mit.edu;
	dkim=pass header.d=mit.edu header.i=@mit.edu header.a=rsa-sha256 header.s=outgoing header.b=IXy7M4Bb;
	arc=none smtp.remote-ip=18.9.28.11
Received: from outgoing.mit.edu (outgoing-auth-1.mit.edu [18.9.28.11])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1AD7606A33F
	for <linux-ext4@vger.kernel.org>; Thu, 12 Nov 2026 04:47:25 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org E1AD7606A33F
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mit.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=mit.edu header.i=@mit.edu header.a=rsa-sha256 header.s=outgoing header.b=IXy7M4Bb
Received: from trampoline.thunk.org (pool-173-48-111-191.bstnma.fios.verizon.net [173.48.111.191])
	(authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
	by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 6AC4lMci031289
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 11 Nov 2026 23:47:23 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mit.edu; s=outgoing;
	t=1794458843; bh=VZv9xDxTJFsmz63+9WNys6Ww/eG6VIqF/SBp0U9Bsu4=;
	h=From:Subject:Date:Message-ID:MIME-Version;
	b=IXy7M4BbVTQoaR8L6oDyOzhicbwc9hswi7Faa5t0Aiy4uWCiYwoLjQmQEm7updofz
	 2e1nOa6kS1oACISyNIkDySyPt1XNaMUu1MjWNx8Nufkby8TpMPqGBaMqGht+IxAj7e
	 VXsSte484iMrrOBPjJynFWzzW2+bHOVMkrbNWUFEj/r+rK8hX1pXy1Py+X0DqGU+MT
	 l3T6S+GuL+n62u8SNkqMdCoxwUJLiXWTafvPwmfUcZQ4bu0hKjxc2NYHX6AJceWpUJ
	 WEaD+PZeThLwboaj9puOWwl0WNVlt4fTL4zoHwIoU6QZSwrFIQyuAbtG3nvDnpH0As
	 NFA8Mo0kbxvTw==
Received: by trampoline.thunk.org (Postfix, from userid 15806)
	id 697D22E015C; Wed, 11 Nov 2026 23:47:19 -0500 (EST)
From: "Theodore Ts'o" <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Cc: "Theodore Ts'o" <tytso@mit.edu>
Subject: [PATCH 23/23] ext4: don't stop EXT4_IOC_GET_ES_CACHE at uncached ranges
Date: Wed, 11 Nov 2026 23:47:12 -0500
Message-ID: <20261112044712.1577296-24-tytso@mit.edu>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261112044712.1577296-1-tytso@mit.edu>
References: <20261112044712.1577296-1-tytso@mit.edu>
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
index 4f1746be323f..1e6324a79cca 100644
--- a/fs/ext4/extents-test.c
+++ b/fs/ext4/extents-test.c
@@ -2946,6 +2946,36 @@ static void test_ext_fiemap_and_get_es_cache(struct kunit *test)
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
index 7872ddc21544..1925dd0d210e 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -2242,8 +2242,13 @@ static int ext4_fill_es_cache_info(struct inode *inode,
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
index 59eaac464bdc..a398dc97f30e 100644
--- a/fs/ext4/extents_status-test.c
+++ b/fs/ext4/extents_status-test.c
@@ -507,6 +507,7 @@ static void test_es_lookup_empty_tree_returns_miss(struct kunit *test)
 		&ctx->sbi->s_es_stats.es_stats_cache_misses);
 	ret = ext4_es_lookup_extent(inode, 10, &next_lblk, &es, NULL);
 	KUNIT_EXPECT_EQ(test, ret, 0);
+	KUNIT_EXPECT_EQ(test, next_lblk, 0U);
 	KUNIT_EXPECT_EQ(test, percpu_counter_sum_positive(
 		&ctx->sbi->s_es_stats.es_stats_cache_misses),
 		misses_before + 1);
@@ -579,9 +580,23 @@ test_es_lookup_hits_cache_and_rbtree_with_next_lblk(struct kunit *test)
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
index 075b9efb6dd4..ce66a4b026c2 100644
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
2.56.0.542.g3ef89b7020-goog

