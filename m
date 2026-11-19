Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=18.9.28.11
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795115858;
	b=L/XAQnSk7muFpmBw8SA36cPq7TKuMo/bUjNSZmKFOaSi7xnk36Mp//uKiHzlTheJtENc
	 asDVN6A5cxIpDMduIdTHW6oRLa8lVbJlsFntylpX9Xq51EW7hrJ2GTwSYxin+sLd9Klt8
	 q9fFpCMcXry08Q8iruXD5oeA+7z33kWlSj6nAzKwEIuFC/jXCXMmeAwS7Beai8+iNkhGm
	 sMFFSxgNyH/hjHUs47AOSwXlgF40YYvbrejVFfBkt8jgaxkW1Gpz8wer6mJCAUwxhDz2Z
	 NBtFP+eYSyL9pWJ4I16e3RaSaCoTluM3No1pf72NSOj287H7E8al8d6JIvSsJlaOw1Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795115858;
	h=DMARC-Filter:Received:DKIM-Signature:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=awiFmy7cJ9b1AO/1sBiMVd7xl0eRLCeSgDpfoKIW7SM=;
	b=FnpKHxbow82l0shhWg378qnuRTuXCoFpsd8ku0LcgNxNnW+3yDZh+BnZDycp8nlfxEZj
	 mIsYFuohW29yTRAWYlOOBclWJ/0Kae6qvLWwGoh9MrBke7zFuqvnrqUX8LuS9DIQjM4pL
	 uVMW/amL1s/flAjV62EXP7rzpXerjH4UMRiuApAwbEB/LUZVb4N7TT+/V92BUK585aS5H
	 8HSU+ZPUqsIYaFui2yCo1RcXh96ssNtZjB7n/pr8Pb1mpi0emFXGb7D5C5aV33SUf3pTh
	 Pu2T83/3MHSFmpUAIwAAb6kgZVk5s7y2sEfwLkjXWHyHji89umTSI/HLnks9lI8+5hg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=mit.edu;
	spf=pass smtp.mailfrom=mit.edu;
	dkim=pass header.d=mit.edu header.i=@mit.edu header.a=rsa-sha256 header.s=outgoing header.b=baMq59wF;
	arc=none smtp.remote-ip=18.9.28.11
Received: from outgoing.mit.edu (outgoing-auth-1.mit.edu [18.9.28.11])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 529E860A262A
	for <linux-ext4@vger.kernel.org>; Thu, 19 Nov 2026 19:17:37 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 529E860A262A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mit.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=mit.edu header.i=@mit.edu header.a=rsa-sha256 header.s=outgoing header.b=baMq59wF
Received: from trampoline.thunk.org (pool-173-48-114-214.bstnma.fios.verizon.net [173.48.114.214])
	(authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
	by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 6AJJHY0e030004
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 19 Nov 2026 14:17:35 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mit.edu; s=outgoing;
	t=1795115855; bh=awiFmy7cJ9b1AO/1sBiMVd7xl0eRLCeSgDpfoKIW7SM=;
	h=From:Subject:Date:Message-ID:MIME-Version;
	b=baMq59wFH/UFUnkCSZuVbP9li4sdqMVogQPOMbAMFl3k9AHEIGsOQA7D4Ugihf8we
	 lqAbzAwfwQK28aKGdQ4rju2cgeuDO22J/axuoQnfq7AvW5+Mk6dI9YZqOJx7/W6V+8
	 8q9DH5ePZPjXtn8HEdkCNBd/H3mXt3LxaGnRCWnTDkMJAFWJagqEJILUlUuL/jORPz
	 ziCNXa1Bhvy0ByGX4W55frFVhn4Yv+CUP81COP6xa9VtaPaymIqul6+O21G0DrSIXN
	 v7+sXP9IghcuSOQcEuLIV3rc/N3XzBDbwQ2dR5Xy9+x2lDgrr/3sU6oc++jyFcqX0T
	 OLo6ij2LigIWA==
Received: by trampoline.thunk.org (Postfix, from userid 15806)
	id 724252E016A; Thu, 19 Nov 2026 14:17:31 -0500 (EST)
From: "Theodore Ts'o" <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Cc: "Theodore Ts'o" <tytso@mit.edu>
Subject: [PATCH -v2 30/32] ext4: protect extent status shrinker stats with s_es_lock
Date: Thu, 19 Nov 2026 14:17:17 -0500
Message-ID: <20261119191719.1943298-31-tytso@mit.edu>
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

__es_shrink() updates the 64-bit statistics fields es_stats_scan_time,
es_stats_max_scan_time, and es_stats_shrunk at its out label after
dropping sbi->s_es_lock.  Concurrent shrinker invocations can race on
these read-modify-write updates and tear 64-bit values on 32-bit systems.

Similarly, ext4_seq_es_shrinker_info_show() releases sbi->s_es_lock
before reading those same statistics fields as well as the max inode's
i_ino, i_es_all_nr, and i_es_shk_nr fields.

Hold sbi->s_es_lock across the es_stats updates in __es_shrink(), and
snapshot the es_stats and max inode fields while holding sbi->s_es_lock
in ext4_seq_es_shrinker_info_show().  Extend
test_es_seq_shrinker_info_show_formats_stats() in
fs/ext4/extents_status-test.c to cover both EWMA branches and the
formatted shrinker statistics output.

Fixes: eb68d0e2fc5a ("ext4: track extent status tree shrinker delay statictics")
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
---
 fs/ext4/extents_status-test.c | 27 +++++++++++++++++++++++++++
 fs/ext4/extents_status.c      | 21 +++++++++++++++++----
 2 files changed, 44 insertions(+), 4 deletions(-)

diff --git a/fs/ext4/extents_status-test.c b/fs/ext4/extents_status-test.c
index fb04e8982cb0..3c3e76307bd7 100644
--- a/fs/ext4/extents_status-test.c
+++ b/fs/ext4/extents_status-test.c
@@ -1594,10 +1594,34 @@ static void test_es_seq_shrinker_info_show_formats_stats(struct kunit *test)
 {
 	struct es_test_ctx *ctx = test->priv;
 	struct inode *inode = &ctx->ei->vfs_inode;
+	struct shrink_control sc = {};
 	struct seq_file seq = {};
 	char *buf;
 
+	/*
+	 * Empty-list scan exercises the early goto-out stats lock path.
+	 * Nothing is examined, so the shrinker reports SHRINK_STOP.
+	 */
+	sc.nr_to_scan = 4;
+	KUNIT_EXPECT_EQ(test, es_shrinker_scan(ctx, &sc), SHRINK_STOP);
+	KUNIT_EXPECT_EQ(test, sc.nr_scanned, 0UL);
+
+	/* Populate extents and run two scans to exercise both EWMA branches */
 	es_insert_extent(inode, 10, 2, 100, EXTENT_STATUS_WRITTEN, false);
+	es_insert_extent(inode, 20, 2, 200, EXTENT_STATUS_WRITTEN, false);
+	es_insert_extent(inode, 30, 2, 300, EXTENT_STATUS_WRITTEN, false);
+	es_insert_extent(inode, 40, 2, 400, EXTENT_STATUS_WRITTEN, false);
+	es_insert_extent(inode, 50, 2, 500, EXTENT_STATUS_WRITTEN, false);
+
+	/* First scan hits nr_to_scan <= 0 goto-out path (shrunk = 2) */
+	sc.nr_to_scan = 2;
+	KUNIT_EXPECT_EQ(test, es_shrinker_scan(ctx, &sc), 2UL);
+	KUNIT_EXPECT_EQ(test, ctx->sbi->s_es_stats.es_stats_shrunk, 2UL);
+
+	/* Second scan exercises EWMA update: (1 + 2 * 3) / 4 == 1 */
+	sc.nr_to_scan = 1;
+	KUNIT_EXPECT_EQ(test, es_shrinker_scan(ctx, &sc), 1UL);
+	KUNIT_EXPECT_EQ(test, ctx->sbi->s_es_stats.es_stats_shrunk, 1UL);
 
 	buf = kunit_kzalloc(test, PAGE_SIZE, GFP_KERNEL);
 	KUNIT_ASSERT_NOT_NULL(test, buf);
@@ -1610,6 +1634,9 @@ static void test_es_seq_shrinker_info_show_formats_stats(struct kunit *test)
 			0);
 	KUNIT_EXPECT_GT(test, seq.count, 0UL);
 	KUNIT_EXPECT_NOT_NULL(test, strstr(buf, "reclaimable objects"));
+	KUNIT_EXPECT_NOT_NULL(test, strstr(buf, "1 inodes on list"));
+	KUNIT_EXPECT_NOT_NULL(test, strstr(buf, "1 shrunk objects"));
+	KUNIT_EXPECT_NOT_NULL(test, strstr(buf, "max scan time"));
 }
 
 static struct kunit_case extents_status_test_cases[] = {
diff --git a/fs/ext4/extents_status.c b/fs/ext4/extents_status.c
index a99b9d87d969..4b101801d5a4 100644
--- a/fs/ext4/extents_status.c
+++ b/fs/ext4/extents_status.c
@@ -1765,6 +1765,7 @@ static int __es_shrink(struct ext4_sb_info *sbi, int nr_to_scan,
 	*nr_scanned = orig_nr_to_scan - nr_to_scan;
 
 	scan_time = ktime_to_ns(ktime_sub(ktime_get(), start_time));
+	spin_lock(&sbi->s_es_lock);
 	if (likely(es_stats->es_stats_scan_time))
 		es_stats->es_stats_scan_time = (scan_time +
 				es_stats->es_stats_scan_time*3) / 4;
@@ -1777,6 +1778,7 @@ static int __es_shrink(struct ext4_sb_info *sbi, int nr_to_scan,
 				es_stats->es_stats_shrunk*3) / 4;
 	else
 		es_stats->es_stats_shrunk = nr_shrunk;
+	spin_unlock(&sbi->s_es_lock);
 
 	trace_ext4_es_shrink(sbi->s_sb, nr_shrunk, scan_time,
 			     nr_skipped, retried);
@@ -1839,6 +1841,9 @@ int ext4_seq_es_shrinker_info_show(struct seq_file *seq, void *v)
 	struct ext4_es_stats *es_stats = &sbi->s_es_stats;
 	struct ext4_inode_info *ei, *max = NULL;
 	unsigned int inode_cnt = 0;
+	unsigned int max_all_nr = 0, max_shk_nr = 0;
+	unsigned long shrunk;
+	u64 scan_time, max_scan_time, max_ino = 0;
 
 	if (v != SEQ_START_TOKEN)
 		return 0;
@@ -1852,6 +1857,14 @@ int ext4_seq_es_shrinker_info_show(struct seq_file *seq, void *v)
 		else if (!max)
 			max = ei;
 	}
+	if (max) {
+		max_ino = max->vfs_inode.i_ino;
+		max_all_nr = max->i_es_all_nr;
+		max_shk_nr = max->i_es_shk_nr;
+	}
+	scan_time = es_stats->es_stats_scan_time;
+	shrunk = es_stats->es_stats_shrunk;
+	max_scan_time = es_stats->es_stats_max_scan_time;
 	spin_unlock(&sbi->s_es_lock);
 
 	seq_printf(seq, "stats:\n  %lld objects\n  %lld reclaimable objects\n",
@@ -1864,14 +1877,14 @@ int ext4_seq_es_shrinker_info_show(struct seq_file *seq, void *v)
 		seq_printf(seq, "  %d inodes on list\n", inode_cnt);
 
 	seq_printf(seq, "average:\n  %llu us scan time\n",
-	    div_u64(es_stats->es_stats_scan_time, 1000));
-	seq_printf(seq, "  %lu shrunk objects\n", es_stats->es_stats_shrunk);
+	    div_u64(scan_time, 1000));
+	seq_printf(seq, "  %lu shrunk objects\n", shrunk);
 	if (inode_cnt)
 		seq_printf(seq,
 		    "maximum:\n  %llu inode (%u objects, %u reclaimable)\n"
 		    "  %llu us max scan time\n",
-		    max->vfs_inode.i_ino, max->i_es_all_nr, max->i_es_shk_nr,
-		    div_u64(es_stats->es_stats_max_scan_time, 1000));
+		    max_ino, max_all_nr, max_shk_nr,
+		    div_u64(max_scan_time, 1000));
 
 	return 0;
 }
-- 
2.56.1.708.g77570a6a1d-goog

