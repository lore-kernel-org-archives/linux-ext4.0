From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH v3 0/2] ext4: increase mbcache scalability
Date: Thu, 12 Sep 2013 08:23:17 -0400
Message-ID: <20130912122317.GC12918@thunk.org>
References: <5229C939.8030108@hp.com>
 <62D71A85-C7EE-4F5F-B481-5329F0282044@dilger.ca>
 <20130910210250.GH29237@thunk.org>
 <522FDFCC.1070007@redhat.com>
 <20130911113001.GB13315@thunk.org>
 <52309F27.8060008@redhat.com>
 <alpine.DEB.2.02.1309111325270.5862@nftneq.ynat.uz>
 <5230D739.9010109@redhat.com>
 <20130911212523.GE13397@thunk.org>
 <5230D450.7000609@hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Eric Sandeen <sandeen@redhat.com>, David Lang <david@lang.hm>,
	Andreas Dilger <adilger@dilger.ca>,
	T Makphaibulchoke <tmac@hp.com>,
	"linux-ext4@vger.kernel.org List" <linux-ext4@vger.kernel.org>,
	aswin@hp.com, swin_proj@lists.hp.com
To: Thavatchai Makphaibulchoke <thavatchai.makpahibulchoke@hp.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:58948 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753238Ab3ILMYv (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 12 Sep 2013 08:24:51 -0400
Content-Disposition: inline
In-Reply-To: <5230D450.7000609@hp.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

(I've trimmed the cc list to stop spamming people who probably don't
care as much about this).

So I've tried the following patch, and I've confirmed that for short
xattrs (i.e., that fit inside the inode body, assuming an inode size >
128 bytes), the mbcache paths don't trigger at all.

Could you try this patch and see if we can figure out why mbcache code
paths are triggering for you?

						- Ted

diff --git a/fs/ext4/xattr.c b/fs/ext4/xattr.c
index c081e34..0942ae3 100644
--- a/fs/ext4/xattr.c
+++ b/fs/ext4/xattr.c
@@ -265,6 +265,8 @@ ext4_xattr_block_get(struct inode *inode, int name_index, const char *name,
 	struct ext4_xattr_entry *entry;
 	size_t size;
 	int error;
+	static DEFINE_RATELIMIT_STATE(_rs, DEFAULT_RATELIMIT_INTERVAL,
+				      DEFAULT_RATELIMIT_BURST);
 
 	ea_idebug(inode, "name=%d.%s, buffer=%p, buffer_size=%ld",
 		  name_index, name, buffer, (long)buffer_size);
@@ -286,6 +288,11 @@ bad_block:
 		error = -EIO;
 		goto cleanup;
 	}
+	if (__ratelimit(&_rs)) {
+		ext4_warning(inode->i_sb, "inode %lu",
+			     (unsigned long) inode->i_ino);
+		WARN_ON(1);
+	}
 	ext4_xattr_cache_insert(bh);
 	entry = BFIRST(bh);
 	error = ext4_xattr_find_entry(&entry, name_index, name, bh->b_size, 1);
@@ -409,6 +416,8 @@ ext4_xattr_block_list(struct dentry *dentry, char *buffer, size_t buffer_size)
 	struct inode *inode = dentry->d_inode;
 	struct buffer_head *bh = NULL;
 	int error;
+	static DEFINE_RATELIMIT_STATE(_rs, DEFAULT_RATELIMIT_INTERVAL,
+				      DEFAULT_RATELIMIT_BURST);
 
 	ea_idebug(inode, "buffer=%p, buffer_size=%ld",
 		  buffer, (long)buffer_size);
@@ -430,6 +439,11 @@ ext4_xattr_block_list(struct dentry *dentry, char *buffer, size_t buffer_size)
 		error = -EIO;
 		goto cleanup;
 	}
+	if (__ratelimit(&_rs)) {
+		ext4_warning(inode->i_sb, "inode %lu",
+			     (unsigned long) inode->i_ino);
+		WARN_ON(1);
+	}
 	ext4_xattr_cache_insert(bh);
 	error = ext4_xattr_list_entries(dentry, BFIRST(bh), buffer, buffer_size);
 
@@ -526,7 +540,14 @@ ext4_xattr_release_block(handle_t *handle, struct inode *inode,
 {
 	struct mb_cache_entry *ce = NULL;
 	int error = 0;
+	static DEFINE_RATELIMIT_STATE(_rs, DEFAULT_RATELIMIT_INTERVAL,
+				      DEFAULT_RATELIMIT_BURST);
 
+	if (__ratelimit(&_rs)) {
+		ext4_warning(inode->i_sb, "inode %lu",
+			     (unsigned long) inode->i_ino);
+		WARN_ON(1);
+	}
 	ce = mb_cache_entry_get(ext4_xattr_cache, bh->b_bdev, bh->b_blocknr);
 	error = ext4_journal_get_write_access(handle, bh);
 	if (error)
@@ -745,12 +766,19 @@ ext4_xattr_block_set(handle_t *handle, struct inode *inode,
 	struct ext4_xattr_search *s = &bs->s;
 	struct mb_cache_entry *ce = NULL;
 	int error = 0;
+	static DEFINE_RATELIMIT_STATE(_rs, DEFAULT_RATELIMIT_INTERVAL,
+				      DEFAULT_RATELIMIT_BURST);
 
 #define header(x) ((struct ext4_xattr_header *)(x))
 
 	if (i->value && i->value_len > sb->s_blocksize)
 		return -ENOSPC;
 	if (s->base) {
+		if (__ratelimit(&_rs)) {
+			ext4_warning(inode->i_sb, "inode %lu",
+				     (unsigned long) inode->i_ino);
+			WARN_ON(1);
+		}
 		ce = mb_cache_entry_get(ext4_xattr_cache, bs->bh->b_bdev,
 					bs->bh->b_blocknr);
 		error = ext4_journal_get_write_access(handle, bs->bh);
@@ -769,6 +797,12 @@ ext4_xattr_block_set(handle_t *handle, struct inode *inode,
 				if (!IS_LAST_ENTRY(s->first))
 					ext4_xattr_rehash(header(s->base),
 							  s->here);
+				if (__ratelimit(&_rs)) {
+					ext4_warning(inode->i_sb,
+						     "inode %lu",
+						(unsigned long) inode->i_ino);
+					WARN_ON(1);
+				}
 				ext4_xattr_cache_insert(bs->bh);
 			}
 			unlock_buffer(bs->bh);
@@ -905,6 +939,11 @@ getblk_failed:
 			memcpy(new_bh->b_data, s->base, new_bh->b_size);
 			set_buffer_uptodate(new_bh);
 			unlock_buffer(new_bh);
+			if (__ratelimit(&_rs)) {
+				ext4_warning(inode->i_sb, "inode %lu",
+					     (unsigned long) inode->i_ino);
+				WARN_ON(1);
+			}
 			ext4_xattr_cache_insert(new_bh);
 			error = ext4_handle_dirty_xattr_block(handle,
 							      inode, new_bh);
@@ -1570,10 +1609,17 @@ ext4_xattr_cache_find(struct inode *inode, struct ext4_xattr_header *header,
 {
 	__u32 hash = le32_to_cpu(header->h_hash);
 	struct mb_cache_entry *ce;
+	static DEFINE_RATELIMIT_STATE(_rs, DEFAULT_RATELIMIT_INTERVAL,
+				      DEFAULT_RATELIMIT_BURST);
 
 	if (!header->h_hash)
 		return NULL;  /* never share */
 	ea_idebug(inode, "looking for cached blocks [%x]", (int)hash);
+	if (__ratelimit(&_rs)) {
+		ext4_warning(inode->i_sb, "inode %lu",
+			     (unsigned long) inode->i_ino);
+		WARN_ON(1);
+	}
 again:
 	ce = mb_cache_entry_find_first(ext4_xattr_cache, inode->i_sb->s_bdev,
 				       hash);
