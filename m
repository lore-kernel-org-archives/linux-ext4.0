From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH v2] fs/mbcache: make sure mb_cache_count() not return
 negative value.
Date: Tue, 9 Jan 2018 23:26:01 -0500
Message-ID: <20180110042600.GC5809@thunk.org>
References: <1515454691-69220-1-git-send-email-jiang.biao2@zte.com.cn>
 <20180108161304.f4be912fb6e20cdf56ae78ef@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jiang Biao <jiang.biao2@zte.com.cn>, linux-fsdevel@vger.kernel.org,
        linux-ext4@vger.kernel.org, ebiggers@google.com, jack@suse.cz,
        zhong.weidong@zte.com.cn
To: Andrew Morton <akpm@linux-foundation.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:57464 "EHLO imap.thunk.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752243AbeAJE0H (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Tue, 9 Jan 2018 23:26:07 -0500
Content-Disposition: inline
In-Reply-To: <20180108161304.f4be912fb6e20cdf56ae78ef@linux-foundation.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Jan 08, 2018 at 04:13:04PM -0800, Andrew Morton wrote:
> I agree with Jan's comment.  We need to figure out how ->c_entry_count
> went negative.  mb_cache_count() says this state is "Unlikely, but not
> impossible", but from a quick read I can't see how this happens - it
> appears that coherency between ->c_list and ->c_entry_count is always
> maintained under ->c_list_lock?

I think I see the problem; and I think this should fix it.  Andrew,
Jan, can you review and double check my analysis?

Thanks,

     	     	    	       	     	- Ted

commit 18fb3649c7cd9e70f05045656c1888459d96dfe4
Author: Theodore Ts'o <tytso@mit.edu>
Date:   Tue Jan 9 23:24:53 2018 -0500

    mbcache: fix potential double counting when removing entry
    
    Entries are removed from the mb_cache entry in two places:
    mb_cache_shrink() and mb_cache_entry_delete().  The mb_cache_shrink()
    function finds the entry to delete via the cache->c_list pointer,
    while mb_cache_entry_delete() finds the entry via the hash lists.
    
    If the two functions race with each other, trying to delete an entry
    at the same time, it's possible for cache->c_entry_count to get
    decremented twice for that one entry.  Fix this by checking to see if
    entry is still on the cache list before removing it and dropping
    c_entry_count.
    
    Signed-off-by: Theodore Ts'o <tytso@mit.edu>

diff --git a/fs/mbcache.c b/fs/mbcache.c
index 49c5b25bfa8c..0851af5c1c3d 100644
--- a/fs/mbcache.c
+++ b/fs/mbcache.c
@@ -290,8 +290,10 @@ static unsigned long mb_cache_shrink(struct mb_cache *cache,
 			list_move_tail(&entry->e_list, &cache->c_list);
 			continue;
 		}
-		list_del_init(&entry->e_list);
-		cache->c_entry_count--;
+		if (!list_empty(&entry->e_list)) {
+			list_del_init(&entry->e_list);
+			cache->c_entry_count--;
+		}
 		/*
 		 * We keep LRU list reference so that entry doesn't go away
 		 * from under us.
