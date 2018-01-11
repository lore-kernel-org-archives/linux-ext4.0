From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH v2] fs/mbcache: make sure mb_cache_count() not return
 negative value.
Date: Thu, 11 Jan 2018 10:04:47 +0100
Message-ID: <20180111090447.gymhnet7sxx4yqkl@quack2.suse.cz>
References: <1515454691-69220-1-git-send-email-jiang.biao2@zte.com.cn>
 <20180108161304.f4be912fb6e20cdf56ae78ef@linux-foundation.org>
 <20180110042600.GC5809@thunk.org>
 <20180110150223.axkqucrhzef2n64u@quack2.suse.cz>
 <20180110201137.GB6499@thunk.org>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="m7nu5i3zqohnk3fi"
Cc: Jan Kara <jack@suse.cz>, Andrew Morton <akpm@linux-foundation.org>,
        Jiang Biao <jiang.biao2@zte.com.cn>,
        linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
        ebiggers@google.com, zhong.weidong@zte.com.cn
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:58282 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754129AbeAKJEu (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Thu, 11 Jan 2018 04:04:50 -0500
Content-Disposition: inline
In-Reply-To: <20180110201137.GB6499@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


--m7nu5i3zqohnk3fi
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed 10-01-18 15:11:37, Theodore Ts'o wrote:
> On Wed, Jan 10, 2018 at 04:02:23PM +0100, Jan Kara wrote:
> > So I don't think this can be a problem. Look, mb_cache_shrink() holds
> > c_list_lock. It will take first entry from cache->c_list - this list is
> > using list_head entry->e_list and so we are guaranteed entry->e_list is
> > non-empty.
> > 
> > The other place deleting entry - mb_cache_entry_delete() - which is using
> > different list to grab the entry is properly checking for
> > !list_empty(entry->e_list) after acquiring c_list_lock.
> 
> Hmm... you're right.  How we handle the hlist_bl_lock and c_list_lock
> still creeps me out a bit, but it's not going to cause the potential
> problem.  I think there is a problem if mb_cache_entry_create() races
> with mb_cache_delete(), but that will result in an entry being on the
> c_list while not being on the hash list, and it doesn't cause the
> c_entry_count to get out of sync with reality.

So that is actually an interesting scenario. If mb_cache_entry_delete() for
(key, value) could happen at the same moment as mb_cache_entry_create() for
the same (key, value) pair, the whole thing could race like:

mb_cache_entry_create()			mb_cache_entry_delete()
  alloc and init 'entry'
  hlist_bl_lock(head);
  search hash, found nothing
  hlist_bl_add_head(&entry->e_hash_list, head);
  hlist_bl_unlock(head);
					hlist_bl_lock(head);
					  search hash, found 'entry'
					  hlist_bl_del_init(&entry->e_hash_list);
					  hlist_bl_unlock(head);
					  spin_lock(&cache->c_list_lock);
					  if (!list_empty(&entry->e_list))
					    false
					  spin_unlock(&cache->c_list_lock);
					  mb_cache_entry_put(cache, entry);
					    - drops last reference, entry
					      gets freed
  spin_lock(&cache->c_list_lock);
  list_add_tail(&entry->e_list, &cache->c_list);
  atomic_inc(&entry->e_refcnt);
  ...
  - and we have added freed entry to LRU, from this point on anything could
    happen.

Now I don't see how this could really happen with the way how ext4 uses
mbache as we call mb_cache_entry_delete() only when xattr block refcount
would drop to 0 (i.e., the last inode referencing the block deletes its
xattr) and then there's nobody to try to insert the same block into the
cache at the same time (xattr_sem protects this) but then ext4 locking in
this area is hairy enough that I could be missing something.

This is relatively easy for mbcache to tolerate but first I'd like to know
whether ext4 indeed can trigger the behavior as that might indicate ext4
bug which would be just hidden by the mbcache fix.

Jiang, can you please run with the attached patch and see whether the
WARN_ON triggers before the entry count goes wrong? Thanks!

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

--m7nu5i3zqohnk3fi
Content-Type: text/x-patch; charset=us-ascii
Content-Disposition: attachment; filename="0001-mbcache-WARN-if-entry-was-already-freed-when-adding-.patch"

>From 920a6679143d0a00673c7452a4352fbf74859474 Mon Sep 17 00:00:00 2001
From: Jan Kara <jack@suse.cz>
Date: Thu, 11 Jan 2018 09:59:34 +0100
Subject: [PATCH] mbcache: WARN if entry was already freed when adding to LRU
 list

DO NOT MERGE THIS! This is just a debug patch.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/mbcache.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/mbcache.c b/fs/mbcache.c
index b8b8b9ced9f8..63b039c99ec8 100644
--- a/fs/mbcache.c
+++ b/fs/mbcache.c
@@ -109,7 +109,7 @@ int mb_cache_entry_create(struct mb_cache *cache, gfp_t mask, u32 key,
 	spin_lock(&cache->c_list_lock);
 	list_add_tail(&entry->e_list, &cache->c_list);
 	/* Grab ref for LRU list */
-	atomic_inc(&entry->e_refcnt);
+	WARN_ON(!atomic_inc_not_zero(&entry->e_refcnt));
 	cache->c_entry_count++;
 	spin_unlock(&cache->c_list_lock);
 
-- 
2.13.6


--m7nu5i3zqohnk3fi--
