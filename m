From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH] ext4: use percpu counter for extent cache count
Date: Fri, 01 Mar 2013 10:42:25 -0600
Message-ID: <5130DA71.4040808@redhat.com>
References: <7BFB2135-A1F0-4B6D-9962-16E75E5560F8@gmail.com> <20130227174553.GA224@x4> <CA+55aFwWA1jPEEQNx_5oJ6Ze=3yFb6=E9nraBfX-Ve=WjRkQMw@mail.gmail.com> <20130227184912.GA19624@thunk.org> <20130227185625.GA224@x4> <20130227191923.GA1121@redhat.com> <20130227192907.GB14253@thunk.org> <20130227201217.GD14253@thunk.org> <20130301033005.GA7081@redhat.com> <20130301040039.GA4452@thunk.org> <20130301050029.GB4452@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Dave Jones <davej@redhat.com>,
	"gnehzuil.liu" <gnehzuil.liu@gmail.com>,
	Zheng Liu <wenqing.lz@taobao.com>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:8112 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751197Ab3CAQmb (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 1 Mar 2013 11:42:31 -0500
In-Reply-To: <20130301050029.GB4452@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Use a percpu counter rather than atomic types for shrinker accounting.
There's no need for ultimate accuracy in the shrinker, so this
should come a little more cheaply.  The percpu struct is somewhat
large, but there was a big gap before the cache-aligned
s_es_lru_lock anyway, and it fits nicely in there.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index 96c1093..4a01ba3 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -1268,7 +1268,6 @@ struct ext4_sb_info {
 	atomic_t s_mb_preallocated;
 	atomic_t s_mb_discarded;
 	atomic_t s_lock_busy;
-	atomic_t s_extent_cache_cnt;
 
 	/* locality groups */
 	struct ext4_locality_group __percpu *s_locality_groups;
@@ -1310,6 +1309,7 @@ struct ext4_sb_info {
 	/* Reclaim extents from extent status tree */
 	struct shrinker s_es_shrinker;
 	struct list_head s_es_lru;
+	struct percpu_counter s_extent_cache_cnt;
 	spinlock_t s_es_lru_lock ____cacheline_aligned_in_smp;
 };
 
diff --git a/fs/ext4/extents_status.c b/fs/ext4/extents_status.c
index 27fcdd2..95796a1 100644
--- a/fs/ext4/extents_status.c
+++ b/fs/ext4/extents_status.c
@@ -305,7 +305,7 @@ ext4_es_alloc_extent(struct inode *inode, ext4_lblk_t lblk, ext4_lblk_t len,
 	 */
 	if (!ext4_es_is_delayed(es)) {
 		EXT4_I(inode)->i_es_lru_nr++;
-		atomic_inc(&EXT4_SB(inode->i_sb)->s_extent_cache_cnt);
+		percpu_counter_inc(&EXT4_SB(inode->i_sb)->s_extent_cache_cnt);
 	}
 
 	return es;
@@ -317,7 +317,7 @@ static void ext4_es_free_extent(struct inode *inode, struct extent_status *es)
 	if (!ext4_es_is_delayed(es)) {
 		BUG_ON(EXT4_I(inode)->i_es_lru_nr == 0);
 		EXT4_I(inode)->i_es_lru_nr--;
-		atomic_dec(&EXT4_SB(inode->i_sb)->s_extent_cache_cnt);
+		percpu_counter_dec(&EXT4_SB(inode->i_sb)->s_extent_cache_cnt);
 	}
 
 	kmem_cache_free(ext4_es_cachep, es);
@@ -678,7 +678,7 @@ static int ext4_es_shrink(struct shrinker *shrink, struct shrink_control *sc)
 	int nr_to_scan = sc->nr_to_scan;
 	int ret, nr_shrunk = 0;
 
-	ret = atomic_read(&sbi->s_extent_cache_cnt);
+	ret = percpu_counter_read_positive(&sbi->s_extent_cache_cnt);
 	trace_ext4_es_shrink_enter(sbi->s_sb, nr_to_scan, ret);
 
 	if (!nr_to_scan)
@@ -711,7 +711,7 @@ static int ext4_es_shrink(struct shrinker *shrink, struct shrink_control *sc)
 	list_splice_tail(&scanned, &sbi->s_es_lru);
 	spin_unlock(&sbi->s_es_lru_lock);
 
-	ret = atomic_read(&sbi->s_extent_cache_cnt);
+	ret = percpu_counter_read_positive(&sbi->s_extent_cache_cnt);
 	trace_ext4_es_shrink_exit(sbi->s_sb, nr_shrunk, ret);
 	return ret;
 }

