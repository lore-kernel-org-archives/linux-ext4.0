From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH v3 1/2] mbcache: decoupling the locking of local from
 global data
Date: Wed, 30 Oct 2013 09:27:10 -0400
Message-ID: <20131030132710.GA3305@thunk.org>
References: <1374108934-50550-1-git-send-email-tmac@hp.com>
 <1378312756-68597-1-git-send-email-tmac@hp.com>
 <1378312756-68597-2-git-send-email-tmac@hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: adilger.kernel@dilger.ca, viro@zeniv.linux.org.uk,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, aswin@hp.com,
	torvalds@linux-foundation.org, aswin_proj@groups.hp.com
To: T Makphaibulchoke <tmac@hp.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1378312756-68597-2-git-send-email-tmac@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Wed, Sep 04, 2013 at 10:39:15AM -0600, T Makphaibulchoke wrote:
> The patch increases the parallelism of mb_cache_entry utilization by
> replacing list_head with hlist_bl_node for the implementation of both the
> block and index hash tables.  Each hlist_bl_node contains a built-in lock
> used to protect mb_cache's local block and index hash chains. The global
> data mb_cache_lru_list and mb_cache_list continue to be protected by the
> global mb_cache_spinlock.

In the process of applying this patch to the ext4 tree, I had to
rework one of the patches to account for a change upstream to the
shrinker interface (which modified mb_cache_shrink_fn() to be
mb_cache_shrink_scan()).

Can you verify that the changes I made look sane?

Thanks,

					- Ted

diff --git a/fs/mbcache.c b/fs/mbcache.c
index 1f90cd0..44e7153 100644
--- a/fs/mbcache.c
+++ b/fs/mbcache.c
@@ -200,25 +200,38 @@ forget:
 static unsigned long
 mb_cache_shrink_scan(struct shrinker *shrink, struct shrink_control *sc)
 {
-	LIST_HEAD(free_list);
-	struct mb_cache_entry *entry, *tmp;
 	int nr_to_scan = sc->nr_to_scan;
 	gfp_t gfp_mask = sc->gfp_mask;
 	unsigned long freed = 0;
 
 	mb_debug("trying to free %d entries", nr_to_scan);
-	spin_lock(&mb_cache_spinlock);
-	while (nr_to_scan-- && !list_empty(&mb_cache_lru_list)) {
-		struct mb_cache_entry *ce =
-			list_entry(mb_cache_lru_list.next,
-				   struct mb_cache_entry, e_lru_list);
-		list_move_tail(&ce->e_lru_list, &free_list);
-		__mb_cache_entry_unhash(ce);
-		freed++;
-	}
-	spin_unlock(&mb_cache_spinlock);
-	list_for_each_entry_safe(entry, tmp, &free_list, e_lru_list) {
-		__mb_cache_entry_forget(entry, gfp_mask);
+	while (nr_to_scan > 0) {
+		struct mb_cache_entry *ce;
+
+		spin_lock(&mb_cache_spinlock);
+		if (list_empty(&mb_cache_lru_list)) {
+			spin_unlock(&mb_cache_spinlock);
+			break;
+		}
+		ce = list_entry(mb_cache_lru_list.next,
+			struct mb_cache_entry, e_lru_list);
+		list_del_init(&ce->e_lru_list);
+		spin_unlock(&mb_cache_spinlock);
+
+		hlist_bl_lock(ce->e_block_hash_p);
+		hlist_bl_lock(ce->e_index_hash_p);
+		if (!(ce->e_used || ce->e_queued)) {
+			__mb_cache_entry_unhash_index(ce);
+			hlist_bl_unlock(ce->e_index_hash_p);
+			__mb_cache_entry_unhash_block(ce);
+			hlist_bl_unlock(ce->e_block_hash_p);
+			__mb_cache_entry_forget(ce, gfp_mask);
+			--nr_to_scan;
+			freed++;
+		} else {
+			hlist_bl_unlock(ce->e_index_hash_p);
+			hlist_bl_unlock(ce->e_block_hash_p);
+		}
 	}
 	return freed;
 }
