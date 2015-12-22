From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 1/6] mbcache2: Reimplement mbcache
Date: Tue, 22 Dec 2015 14:29:50 +0100
Message-ID: <20151222132950.GC7266@quack.suse.cz>
References: <1449683858-28936-1-git-send-email-jack@suse.cz>
 <1449683858-28936-2-git-send-email-jack@suse.cz>
 <CAHpGcMJ_gWOTt89E9RnxSY4-yhdU_OQ14Jb5gJvETzQ_NXvXmA@mail.gmail.com>
 <20151215110809.GA1899@quack.suse.cz>
 <20151216155209.GD16918@quack.suse.cz>
 <CAHpGcMLWgiJ9-9onrYPowoMMgDHbsyLSyZ2wXp4RSRtmUeTgEw@mail.gmail.com>
 <20151222130752.GB7266@quack.suse.cz>
 <CAHpGcMLibLH5g7nJ4624Dd-bgLx_dp3FOVzmufOqPGihYDsGRQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="r5Pyd7+fXNt84Ff3"
Content-Transfer-Encoding: 8bit
Cc: Jan Kara <jack@suse.cz>, Ted Tso <tytso@mit.edu>,
	linux-ext4@vger.kernel.org, Laurent GUERBY <laurent@guerby.net>,
	Andreas Dilger <adilger@dilger.ca>
To: Andreas =?iso-8859-1?Q?Gr=FCnbacher?=
	<andreas.gruenbacher@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:34318 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751752AbbLVN3x (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 22 Dec 2015 08:29:53 -0500
Content-Disposition: inline
In-Reply-To: <CAHpGcMLibLH5g7nJ4624Dd-bgLx_dp3FOVzmufOqPGihYDsGRQ@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


--r5Pyd7+fXNt84Ff3
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit

On Tue 22-12-15 14:16:28, Andreas Grünbacher wrote:
> 2015-12-22 14:07 GMT+01:00 Jan Kara <jack@suse.cz>:
> > On Tue 22-12-15 13:20:58, Andreas Grünbacher wrote:
> >> That test scenario probably isn't very realistic: xattrs are mostly
> >> initialized at or immediately after file create time; they rarely
> >> removed. Hash chains should shrink significantly for that scenario.
> >
> > Well, the refcount gets dropped when the file itself is deleted. And that
> > isn't that rare. So I agree my benchmark isn't completely realistic in
> > changing the xattr but dropping xattr block refcount due to deleted file
> > will be relatively frequent so I don't thing refcount distribution obtained
> > by my benchmark is completely out.
> 
> Good point.
> 
> >> In addition, if the hash table is sized reasonably, long hash chains
> >> won't hurt that much because we can stop searching them as soon as we
> >> find the first reusable block. This won't help when there are hash
> >> conflicts, but those should be unlikely.
> >
> > Well, this is what happens currently as well...
> 
> Yes, except that many "unshareable" xattr blocks can remain in the
> hash table where they can only be skipped over. Since you have already
> written the code for fixing that and that fix won't make things worse,
> I would like to see that go in.

So for reference I'm attaching the patch which stops caching xattr block
when it reaches max refcount. Frankly, I'm not in favor of merging this
patch unless we can show it really improves noticeably some realistic
scenario. Removal and re-adding of xattr block from / to cache costs some
CPU cycles as well so overall I'm not convinced it is a clear win and
although the patch is simple it still adds some complexity.

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

--r5Pyd7+fXNt84Ff3
Content-Type: text/x-patch; charset=us-ascii
Content-Disposition: attachment; filename="0001-mbcache2-Do-not-cache-blocks-with-maximum-refcount.patch"

>From cf25c42595b5ff237ff4bc6c9968bb4e92181619 Mon Sep 17 00:00:00 2001
From: Jan Kara <jack@suse.cz>
Date: Wed, 16 Dec 2015 13:29:46 +0100
Subject: [PATCH] mbcache2: Do not cache blocks with maximum refcount

Maximum number of inodes sharing xattr block is limited to 1024 to limit
amount of damage one corrupted / bad block can cause. Thus xattr blocks
that have reached this limit cannot be used for further deduplicating
and are just occupying space in cache needlessly. The worst thing is
that all these blocks with the same content have the same hash and thus
they all end up in the same hash chain making chain unnecessarily long.
In the extreme case of a single xattr block value we degrade the hash
table to a linked list.

Improve the situation by removing entries for xattr blocks with maximum
refcount from the cache and adding them back once refcount drops. This
can cause some unnecessary cache removal & additions in cases when xattr
block frequently transations between max refcount and max refcount - 1,
but overall this is a win.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/ext4/xattr.c | 28 +++++++++++++++++++++++++---
 1 file changed, 25 insertions(+), 3 deletions(-)

diff --git a/fs/ext4/xattr.c b/fs/ext4/xattr.c
index a80e5e2acadd..a8401a650221 100644
--- a/fs/ext4/xattr.c
+++ b/fs/ext4/xattr.c
@@ -567,6 +567,10 @@ ext4_xattr_release_block(handle_t *handle, struct inode *inode,
 				 EXT4_FREE_BLOCKS_FORGET);
 	} else {
 		le32_add_cpu(&BHDR(bh)->h_refcount, -1);
+		/* Entry with max refcount was not cached. Add it now. */
+		if (le32_to_cpu(BHDR(bh)->h_refcount) ==
+		    EXT4_XATTR_REFCOUNT_MAX - 1)
+			ext4_xattr_cache_insert(EXT4_GET_MB_CACHE(inode), bh);
 		/*
 		 * Beware of this ugliness: Releasing of xattr block references
 		 * from different inodes can race and so we have to protect
@@ -865,6 +869,8 @@ inserted:
 	if (!IS_LAST_ENTRY(s->first)) {
 		new_bh = ext4_xattr_cache_find(inode, header(s->base), &ce);
 		if (new_bh) {
+			bool delete = false;
+
 			/* We found an identical block in the cache. */
 			if (new_bh == bs->bh)
 				ea_bdebug(new_bh, "keeping");
@@ -907,6 +913,9 @@ inserted:
 					goto inserted;
 				}
 				le32_add_cpu(&BHDR(new_bh)->h_refcount, 1);
+				if (le32_to_cpu(BHDR(new_bh)->h_refcount) ==
+				    EXT4_XATTR_REFCOUNT_MAX)
+					delete = true;
 				ea_bdebug(new_bh, "reusing; refcount now=%d",
 					le32_to_cpu(BHDR(new_bh)->h_refcount));
 				unlock_buffer(new_bh);
@@ -916,8 +925,16 @@ inserted:
 				if (error)
 					goto cleanup_dquot;
 			}
-			mb2_cache_entry_touch(ext4_mb_cache, ce);
-			mb2_cache_entry_put(ext4_mb_cache, ce);
+			/*
+			 * Delete entry from cache in case it reached max
+			 * refcount and thus cannot be used anymore
+			 */
+			if (unlikely(delete)) {
+				mb2_cache_entry_delete(ext4_mb_cache, ce);
+			} else {
+				mb2_cache_entry_touch(ext4_mb_cache, ce);
+				mb2_cache_entry_put(ext4_mb_cache, ce);
+			}
 			ce = NULL;
 		} else if (bs->bh && s->base == bs->bh->b_data) {
 			/* We were modifying this block in-place. */
@@ -1538,7 +1555,8 @@ cleanup:
  * ext4_xattr_cache_insert()
  *
  * Create a new entry in the extended attribute cache, and insert
- * it unless such an entry is already in the cache.
+ * it unless such an entry is already in the cache or it has too many
+ * references.
  *
  * Returns 0, or a negative error number on failure.
  */
@@ -1549,6 +1567,10 @@ ext4_xattr_cache_insert(struct mb2_cache *ext4_mb_cache, struct buffer_head *bh)
 	struct mb2_cache_entry *ce;
 	int error;
 
+	/* Don't cache entry with too many references as it cannot be used */
+	if (le32_to_cpu(BHDR(bh)->h_refcount) >= EXT4_XATTR_REFCOUNT_MAX)
+		return;
+
 	ce = mb2_cache_entry_create(ext4_mb_cache, GFP_NOFS, hash,
 				    bh->b_blocknr);
 	if (IS_ERR(ce)) {
-- 
1.7.12.4


--r5Pyd7+fXNt84Ff3--
