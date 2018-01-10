From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH v2] fs/mbcache: make sure mb_cache_count() not return
 negative value.
Date: Tue, 9 Jan 2018 23:58:12 -0500
Message-ID: <20180110045812.GD5809@thunk.org>
References: <1515454691-69220-1-git-send-email-jiang.biao2@zte.com.cn>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
        ebiggers@google.com, akpm@linux-foundation.org, jack@suse.cz,
        zhong.weidong@zte.com.cn
To: Jiang Biao <jiang.biao2@zte.com.cn>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:57510 "EHLO imap.thunk.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932424AbeAJE6R (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Tue, 9 Jan 2018 23:58:17 -0500
Content-Disposition: inline
In-Reply-To: <1515454691-69220-1-git-send-email-jiang.biao2@zte.com.cn>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

I think I've found the cause of it, but having a sanity check is a
good idea.  I've simplified the patch and its description, though.
This is what I have in my tree.

     	    	 	    	      - Ted

commit 252194e48f00d146de303822bba8c3568ca127cd
Author: Jiang Biao <jiang.biao2@zte.com.cn>
Date:   Tue Jan 9 23:57:52 2018 -0500

    mbcache: make sure c_entry_count is not decremented past zero
    
    Signed-off-by: Jiang Biao <jiang.biao2@zte.com.cn>
    Signed-off-by: Theodore Ts'o <tytso@mit.edu>
    CC: Eric Biggers <ebiggers@google.com>
    CC: Andrew Morton <akpm@linux-foundation.org>
    CC: Jan Kara <jack@suse.cz>

diff --git a/fs/mbcache.c b/fs/mbcache.c
index 0851af5c1c3d..f2f15b747bed 100644
--- a/fs/mbcache.c
+++ b/fs/mbcache.c
@@ -239,7 +239,9 @@ void mb_cache_entry_delete(struct mb_cache *cache, u32 key, u64 value)
 			spin_lock(&cache->c_list_lock);
 			if (!list_empty(&entry->e_list)) {
 				list_del_init(&entry->e_list);
-				cache->c_entry_count--;
+				if (!WARN_ONCE(cache->c_entry_count == 0,
+		"mbcache: attempt to decrement c_entry_count past zero"))
+					cache->c_entry_count--;
 				atomic_dec(&entry->e_refcnt);
 			}
 			spin_unlock(&cache->c_list_lock);
