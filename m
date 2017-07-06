From: Miao Xie <miaoxie@huawei.com>
Subject: Re: [PATCH v2 1/2] ext4, project: expand inode extra size if possible
Date: Thu, 6 Jul 2017 11:51:41 +0800
Message-ID: <768966ae-93fc-e648-5604-505a6a7c8e25@huawei.com>
References: <20170704074210.77918-1-wshilong@ddn.com>
 <987151C3-9E9D-4ACD-84BB-B9DC33C08822@dilger.ca>
Reply-To: <miaoxie@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
Cc: linux-ext4 <linux-ext4@vger.kernel.org>,
        "Theodore Ts'o" <tytso@mit.edu>, "Li Xi" <lixi@ddn.com>,
        "zhangyi (F)" <yi.zhang@huawei.com>, <wshilong@ddn.com>,
        Shuichi Ihara <sihara@ddn.com>
To: Andreas Dilger <adilger@dilger.ca>,
        Wang Shilong <wangshilong1991@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from szxga03-in.huawei.com ([45.249.212.189]:8871 "EHLO
        szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752521AbdGFDwd (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Wed, 5 Jul 2017 23:52:33 -0400
In-Reply-To: <987151C3-9E9D-4ACD-84BB-B9DC33C08822@dilger.ca>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Sorry, I reply late.

on 2017/7/6 at 0:31, Andreas Dilger wrote:
>>
>> +	if (need_expand) {
>> +		err = ext4_expand_extra_isize(inode,
>> +				      EXT4_SB(sb)->s_want_extra_isize,
>> +				      iloc, handle);
>> +		if (err)
>> +			goto out_stop;
>> +	}
>> +

I found ext4_expand_extra_isize just tried to expand extra isize, 
it would give up and return 0 if someone was holding attr lock.
so though it return 0, extra isize may not be expanded successfully.
So ...

How about the following patches?

>From 6e3362e9e9ee81f7184036ff0df7d010c368bac8 Mon Sep 17 00:00:00 2001
From: Miao Xie <miaoxie@huawei.com>
Date: Wed, 5 Jul 2017 18:29:53 +0800
Subject: [PATCH 1/4] ext4: fix forgetten xattr lock protection in
 ext4_expand_extra_isize

We should avoid the contention between the i_extra_isize update and
the inline data insertion, so move the xattr trylock in front of
i_extra_isize update.

Signed-off-by: Miao Xie <miaoxie@huawei.com>
---
 fs/ext4/inode.c | 18 ++++++++++++++++--
 fs/ext4/xattr.c | 10 ----------
 2 files changed, 16 insertions(+), 12 deletions(-)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 5cf82d0..4af3edc 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -5639,10 +5639,15 @@ static int ext4_expand_extra_isize(struct inode *inode,
 {
 	struct ext4_inode *raw_inode;
 	struct ext4_xattr_ibody_header *header;
+	int no_expand;
+	int error;
 
 	if (EXT4_I(inode)->i_extra_isize >= new_extra_isize)
 		return 0;
 
+	if (ext4_write_trylock_xattr(inode, &no_expand) == 0)
+		return 0;
+
 	raw_inode = ext4_raw_inode(&iloc);
 
 	header = IHDR(inode, raw_inode);
@@ -5654,12 +5659,21 @@ static int ext4_expand_extra_isize(struct inode *inode,
 		       EXT4_I(inode)->i_extra_isize, 0,
 		       new_extra_isize - EXT4_I(inode)->i_extra_isize);
 		EXT4_I(inode)->i_extra_isize = new_extra_isize;
+		ext4_write_unlock_xattr(inode, &no_expand);
 		return 0;
 	}
 
 	/* try to expand with EAs present */
-	return ext4_expand_extra_isize_ea(inode, new_extra_isize,
-					  raw_inode, handle);
+	error = ext4_expand_extra_isize_ea(inode, new_extra_isize,
+					   raw_inode, handle);
+	if (error) {
+		/*
+		 * Inode size expansion failed; don't try again
+		 */
+		no_expand = 1;
+	}
+	ext4_write_unlock_xattr(inode, &no_expand);
+	return error;
 }
 
 /*
diff --git a/fs/ext4/xattr.c b/fs/ext4/xattr.c
index 5d3c253..12ee5fb 100644
--- a/fs/ext4/xattr.c
+++ b/fs/ext4/xattr.c
@@ -1472,10 +1472,6 @@ int ext4_expand_extra_isize_ea(struct inode *inode, int new_extra_isize,
 	int error = 0, tried_min_extra_isize = 0;
 	int s_min_extra_isize = le16_to_cpu(EXT4_SB(inode->i_sb)->s_es->s_min_extra_isize);
 	int isize_diff;	/* How much do we need to grow i_extra_isize */
-	int no_expand;
-
-	if (ext4_write_trylock_xattr(inode, &no_expand) == 0)
-		return 0;
 
 retry:
 	isize_diff = new_extra_isize - EXT4_I(inode)->i_extra_isize;
@@ -1558,16 +1554,10 @@ int ext4_expand_extra_isize_ea(struct inode *inode, int new_extra_isize,
 	EXT4_I(inode)->i_extra_isize = new_extra_isize;
 	brelse(bh);
 out:
-	ext4_write_unlock_xattr(inode, &no_expand);
 	return 0;
 
 cleanup:
 	brelse(bh);
-	/*
-	 * Inode size expansion failed; don't try again
-	 */
-	no_expand = 1;
-	ext4_write_unlock_xattr(inode, &no_expand);
 	return error;
 }
 
-- 
2.5.0


>From 6ea3ddf433a28032764d0b200a61805ccf85c07a Mon Sep 17 00:00:00 2001
From: Miao Xie <miaoxie@huawei.com>
Date: Wed, 5 Jul 2017 19:30:14 +0800
Subject: [PATCH 2/4] ext4: restructure ext4_expand_extra_isize

Current ext4_expand_extra_isize just tries to expand extra isize, if
someone is holding xattr lock or some check fails, it will give up.
So rename its name to ext4_try_to_expand_extra_isize.

Besides that, we clean up unnecessary check and move some relative checks
into it.

Signed-off-by: Miao Xie <miaoxie@huawei.com>
---
 fs/ext4/inode.c | 67 ++++++++++++++++++++++++---------------------------------
 fs/ext4/xattr.c | 11 +++++++++-
 2 files changed, 38 insertions(+), 40 deletions(-)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 4af3edc..01a9340 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -5632,21 +5632,35 @@ ext4_reserve_inode_write(handle_t *handle, struct inode *inode,
  * Expand an inode by new_extra_isize bytes.
  * Returns 0 on success or negative error number on failure.
  */
-static int ext4_expand_extra_isize(struct inode *inode,
-				   unsigned int new_extra_isize,
-				   struct ext4_iloc iloc,
-				   handle_t *handle)
+static int ext4_try_to_expand_extra_isize(struct inode *inode,
+					  unsigned int new_extra_isize,
+					  struct ext4_iloc iloc,
+					  handle_t *handle)
 {
 	struct ext4_inode *raw_inode;
 	struct ext4_xattr_ibody_header *header;
 	int no_expand;
 	int error;
 
-	if (EXT4_I(inode)->i_extra_isize >= new_extra_isize)
-		return 0;
+	if (ext4_test_inode_state(inode, EXT4_STATE_NO_EXPAND))
+		return -EOVERFLOW;
+
+	/*
+	 * In nojournal mode, we can immediately attempt to expand
+	 * the inode.  When journaled, we first need to obtain extra
+	 * buffer credits since we may write into the EA block
+	 * with this same handle. If journal_extend fails, then it will
+	 * only result in a minor loss of functionality for that inode.
+	 * If this is felt to be critical, then e2fsck should be run to
+	 * force a large enough s_min_extra_isize.
+	 */
+	if (ext4_handle_valid(handle) &&
+	    jbd2_journal_extend(handle,
+				EXT4_DATA_TRANS_BLOCKS(inode->i_sb)) != 0)
+		return -ENOSPC;
 
 	if (ext4_write_trylock_xattr(inode, &no_expand) == 0)
-		return 0;
+		return -EBUSY;
 
 	raw_inode = ext4_raw_inode(&iloc);
 
@@ -5673,6 +5687,7 @@ static int ext4_expand_extra_isize(struct inode *inode,
 		no_expand = 1;
 	}
 	ext4_write_unlock_xattr(inode, &no_expand);
+
 	return error;
 }
 
@@ -5693,44 +5708,18 @@ int ext4_mark_inode_dirty(handle_t *handle, struct inode *inode)
 {
 	struct ext4_iloc iloc;
 	struct ext4_sb_info *sbi = EXT4_SB(inode->i_sb);
-	static unsigned int mnt_count;
-	int err, ret;
+	int err;
 
 	might_sleep();
 	trace_ext4_mark_inode_dirty(inode, _RET_IP_);
 	err = ext4_reserve_inode_write(handle, inode, &iloc);
 	if (err)
 		return err;
-	if (EXT4_I(inode)->i_extra_isize < sbi->s_want_extra_isize &&
-	    !ext4_test_inode_state(inode, EXT4_STATE_NO_EXPAND)) {
-		/*
-		 * In nojournal mode, we can immediately attempt to expand
-		 * the inode.  When journaled, we first need to obtain extra
-		 * buffer credits since we may write into the EA block
-		 * with this same handle. If journal_extend fails, then it will
-		 * only result in a minor loss of functionality for that inode.
-		 * If this is felt to be critical, then e2fsck should be run to
-		 * force a large enough s_min_extra_isize.
-		 */
-		if (!ext4_handle_valid(handle) ||
-		    jbd2_journal_extend(handle,
-			     EXT4_DATA_TRANS_BLOCKS(inode->i_sb)) == 0) {
-			ret = ext4_expand_extra_isize(inode,
-						      sbi->s_want_extra_isize,
-						      iloc, handle);
-			if (ret) {
-				if (mnt_count !=
-					le16_to_cpu(sbi->s_es->s_mnt_count)) {
-					ext4_warning(inode->i_sb,
-					"Unable to expand inode %lu. Delete"
-					" some EAs or run e2fsck.",
-					inode->i_ino);
-					mnt_count =
-					  le16_to_cpu(sbi->s_es->s_mnt_count);
-				}
-			}
-		}
-	}
+
+	if (EXT4_I(inode)->i_extra_isize < sbi->s_want_extra_isize)
+		ext4_try_to_expand_extra_isize(inode, sbi->s_want_extra_isize,
+					       iloc, handle);
+
 	return ext4_mark_iloc_dirty(handle, inode, &iloc);
 }
 
diff --git a/fs/ext4/xattr.c b/fs/ext4/xattr.c
index 12ee5fb..3c6c225 100644
--- a/fs/ext4/xattr.c
+++ b/fs/ext4/xattr.c
@@ -1465,12 +1465,14 @@ int ext4_expand_extra_isize_ea(struct inode *inode, int new_extra_isize,
 {
 	struct ext4_xattr_ibody_header *header;
 	struct buffer_head *bh = NULL;
+	struct ext4_sb_info *sbi = EXT4_SB(inode->i_sb);
+	static unsigned int mnt_count;
 	size_t min_offs;
 	size_t ifree, bfree;
 	int total_ino;
 	void *base, *end;
 	int error = 0, tried_min_extra_isize = 0;
-	int s_min_extra_isize = le16_to_cpu(EXT4_SB(inode->i_sb)->s_es->s_min_extra_isize);
+	int s_min_extra_isize = le16_to_cpu(sbi->s_es->s_min_extra_isize);
 	int isize_diff;	/* How much do we need to grow i_extra_isize */
 
 retry:
@@ -1558,6 +1560,13 @@ int ext4_expand_extra_isize_ea(struct inode *inode, int new_extra_isize,
 
 cleanup:
 	brelse(bh);
+
+	if (mnt_count != le16_to_cpu(sbi->s_es->s_mnt_count)) {
+		ext4_warning(inode->i_sb, "Unable to expand inode %lu. Delete some EAs or run e2fsck.",
+			     inode->i_ino);
+		mnt_count = le16_to_cpu(sbi->s_es->s_mnt_count);
+	}
+
 	return error;
 }
 
-- 
2.5.0

>From c6cb954d91be4af11271480004c8873971123502 Mon Sep 17 00:00:00 2001
From: Miao Xie <miaoxie@huawei.com>
Date: Wed, 5 Jul 2017 19:43:55 +0800
Subject: [PATCH 3/4] ext4: cleanup ext4_expand_extra_isize_ea()

Clean up some goto statement, make ext4_expand_extra_isize_ea() clearer.

Signed-off-by: Miao Xie <miaoxie@huawei.com>
---
 fs/ext4/xattr.c | 15 +++++----------
 1 file changed, 5 insertions(+), 10 deletions(-)

diff --git a/fs/ext4/xattr.c b/fs/ext4/xattr.c
index 3c6c225..73fbe4a 100644
--- a/fs/ext4/xattr.c
+++ b/fs/ext4/xattr.c
@@ -1464,7 +1464,7 @@ int ext4_expand_extra_isize_ea(struct inode *inode, int new_extra_isize,
 			       struct ext4_inode *raw_inode, handle_t *handle)
 {
 	struct ext4_xattr_ibody_header *header;
-	struct buffer_head *bh = NULL;
+	struct buffer_head *bh;
 	struct ext4_sb_info *sbi = EXT4_SB(inode->i_sb);
 	static unsigned int mnt_count;
 	size_t min_offs;
@@ -1478,7 +1478,7 @@ int ext4_expand_extra_isize_ea(struct inode *inode, int new_extra_isize,
 retry:
 	isize_diff = new_extra_isize - EXT4_I(inode)->i_extra_isize;
 	if (EXT4_I(inode)->i_extra_isize >= new_extra_isize)
-		goto out;
+		return 0;
 
 	header = IHDR(inode, raw_inode);
 
@@ -1513,6 +1513,7 @@ int ext4_expand_extra_isize_ea(struct inode *inode, int new_extra_isize,
 			EXT4_ERROR_INODE(inode, "bad block %llu",
 					 EXT4_I(inode)->i_file_acl);
 			error = -EFSCORRUPTED;
+			brelse(bh);
 			goto cleanup;
 		}
 		base = BHDR(bh);
@@ -1520,11 +1521,11 @@ int ext4_expand_extra_isize_ea(struct inode *inode, int new_extra_isize,
 		min_offs = end - base;
 		bfree = ext4_xattr_free_space(BFIRST(bh), &min_offs, base,
 					      NULL);
+		brelse(bh);
 		if (bfree + ifree < isize_diff) {
 			if (!tried_min_extra_isize && s_min_extra_isize) {
 				tried_min_extra_isize++;
 				new_extra_isize = s_min_extra_isize;
-				brelse(bh);
 				goto retry;
 			}
 			error = -ENOSPC;
@@ -1542,7 +1543,6 @@ int ext4_expand_extra_isize_ea(struct inode *inode, int new_extra_isize,
 		    s_min_extra_isize) {
 			tried_min_extra_isize++;
 			new_extra_isize = s_min_extra_isize;
-			brelse(bh);
 			goto retry;
 		}
 		goto cleanup;
@@ -1554,14 +1554,9 @@ int ext4_expand_extra_isize_ea(struct inode *inode, int new_extra_isize,
 			EXT4_GOOD_OLD_INODE_SIZE + new_extra_isize,
 			(void *)header, total_ino);
 	EXT4_I(inode)->i_extra_isize = new_extra_isize;
-	brelse(bh);
-out:
-	return 0;
 
 cleanup:
-	brelse(bh);
-
-	if (mnt_count != le16_to_cpu(sbi->s_es->s_mnt_count)) {
+	if (error && mnt_count != le16_to_cpu(sbi->s_es->s_mnt_count)) {
 		ext4_warning(inode->i_sb, "Unable to expand inode %lu. Delete some EAs or run e2fsck.",
 			     inode->i_ino);
 		mnt_count = le16_to_cpu(sbi->s_es->s_mnt_count);
-- 
2.5.0

>From e2ff4a302588e9d564734219b38c7dddb13f3c1e Mon Sep 17 00:00:00 2001
From: Miao Xie <miaoxie@huawei.com>
Date: Wed, 5 Jul 2017 21:01:26 +0800
Subject: [PATCH 4/4] ext4, project: expand inode extra size if possible

when upgrading from old format, try to set project id
to old file first time, it will return EOVERFLOW, but if
that file is dirtied(touch etc), changing project id will
be allowed, this might be confusing for users, we could
try to expand @i_extra_iszie here too.

Reported-by: Zhang Yi <yi.zhang@huawei.com>
Signed-off-by: Miao Xie <miaoxie@huawei.com>
Signed-off-by: Wang Shilong <wshilong@ddn.com>
---
 fs/ext4/ext4_jbd2.h |  3 ++
 fs/ext4/inode.c     | 97 +++++++++++++++++++++++++++++++++++++++++------------
 fs/ext4/ioctl.c     |  9 +++--
 3 files changed, 85 insertions(+), 24 deletions(-)

diff --git a/fs/ext4/ext4_jbd2.h b/fs/ext4/ext4_jbd2.h
index f976111..3149fdd 100644
--- a/fs/ext4/ext4_jbd2.h
+++ b/fs/ext4/ext4_jbd2.h
@@ -234,6 +234,9 @@ int ext4_reserve_inode_write(handle_t *handle, struct inode *inode,
 
 int ext4_mark_inode_dirty(handle_t *handle, struct inode *inode);
 
+int ext4_expand_extra_isize(struct inode *inode,
+			    unsigned int new_extra_isize,
+			    struct ext4_iloc *iloc);
 /*
  * Wrapper functions with which ext4 calls into JBD.
  */
diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 01a9340..41a353f 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -5628,6 +5628,42 @@ ext4_reserve_inode_write(handle_t *handle, struct inode *inode,
 	return err;
 }
 
+static int __ext4_expand_extra_isize(struct inode *inode,
+				     unsigned int new_extra_isize,
+				     struct ext4_iloc *iloc,
+				     handle_t *handle, int *no_expand)
+{
+	struct ext4_inode *raw_inode;
+	struct ext4_xattr_ibody_header *header;
+	int error;
+
+	raw_inode = ext4_raw_inode(iloc);
+
+	header = IHDR(inode, raw_inode);
+
+	/* No extended attributes present */
+	if (!ext4_test_inode_state(inode, EXT4_STATE_XATTR) ||
+	    header->h_magic != cpu_to_le32(EXT4_XATTR_MAGIC)) {
+		memset((void *)raw_inode + EXT4_GOOD_OLD_INODE_SIZE +
+		       EXT4_I(inode)->i_extra_isize, 0,
+		       new_extra_isize - EXT4_I(inode)->i_extra_isize);
+		EXT4_I(inode)->i_extra_isize = new_extra_isize;
+		return 0;
+	}
+
+	/* try to expand with EAs present */
+	error = ext4_expand_extra_isize_ea(inode, new_extra_isize,
+					   raw_inode, handle);
+	if (error) {
+		/*
+		 * Inode size expansion failed; don't try again
+		 */
+		*no_expand = 1;
+	}
+
+	return error;
+}
+
 /*
  * Expand an inode by new_extra_isize bytes.
  * Returns 0 on success or negative error number on failure.
@@ -5637,8 +5673,6 @@ static int ext4_try_to_expand_extra_isize(struct inode *inode,
 					  struct ext4_iloc iloc,
 					  handle_t *handle)
 {
-	struct ext4_inode *raw_inode;
-	struct ext4_xattr_ibody_header *header;
 	int no_expand;
 	int error;
 
@@ -5662,32 +5696,53 @@ static int ext4_try_to_expand_extra_isize(struct inode *inode,
 	if (ext4_write_trylock_xattr(inode, &no_expand) == 0)
 		return -EBUSY;
 
-	raw_inode = ext4_raw_inode(&iloc);
+	error = __ext4_expand_extra_isize(inode, new_extra_isize, &iloc,
+					  handle, &no_expand);
+	ext4_write_unlock_xattr(inode, &no_expand);
 
-	header = IHDR(inode, raw_inode);
+	return error;
+}
 
-	/* No extended attributes present */
-	if (!ext4_test_inode_state(inode, EXT4_STATE_XATTR) ||
-	    header->h_magic != cpu_to_le32(EXT4_XATTR_MAGIC)) {
-		memset((void *)raw_inode + EXT4_GOOD_OLD_INODE_SIZE +
-		       EXT4_I(inode)->i_extra_isize, 0,
-		       new_extra_isize - EXT4_I(inode)->i_extra_isize);
-		EXT4_I(inode)->i_extra_isize = new_extra_isize;
-		ext4_write_unlock_xattr(inode, &no_expand);
-		return 0;
+int ext4_expand_extra_isize(struct inode *inode,
+			    unsigned int new_extra_isize,
+			    struct ext4_iloc *iloc)
+{
+	handle_t *handle;
+	int no_expand;
+	int error, rc;
+
+	if (ext4_test_inode_state(inode, EXT4_STATE_NO_EXPAND)) {
+		brelse(iloc->bh);
+		return -EOVERFLOW;
 	}
 
-	/* try to expand with EAs present */
-	error = ext4_expand_extra_isize_ea(inode, new_extra_isize,
-					   raw_inode, handle);
+	handle = ext4_journal_start(inode, EXT4_HT_INODE,
+				    EXT4_DATA_TRANS_BLOCKS(inode->i_sb));
+	if (IS_ERR(handle)) {
+		error = PTR_ERR(handle);
+		brelse(iloc->bh);
+		return error;
+	}
+
+	ext4_write_lock_xattr(inode, &no_expand);
+
+	BUFFER_TRACE(iloc.bh, "get_write_access");
+	error = ext4_journal_get_write_access(handle, iloc->bh);
 	if (error) {
-		/*
-		 * Inode size expansion failed; don't try again
-		 */
-		no_expand = 1;
+		brelse(iloc->bh);
+		goto out_stop;
 	}
-	ext4_write_unlock_xattr(inode, &no_expand);
 
+	error = __ext4_expand_extra_isize(inode, new_extra_isize, iloc,
+					  handle, &no_expand);
+
+	rc = ext4_mark_iloc_dirty(handle, inode, iloc);
+	if (!error)
+		error = rc;
+
+	ext4_write_unlock_xattr(inode, &no_expand);
+out_stop:
+	ext4_journal_stop(handle);
 	return error;
 }
 
diff --git a/fs/ext4/ioctl.c b/fs/ext4/ioctl.c
index 0c21e22..0120207 100644
--- a/fs/ext4/ioctl.c
+++ b/fs/ext4/ioctl.c
@@ -351,11 +351,14 @@ static int ext4_ioctl_setproject(struct file *filp, __u32 projid)
 
 	raw_inode = ext4_raw_inode(&iloc);
 	if (!EXT4_FITS_IN_INODE(raw_inode, ei, i_projid)) {
-		err = -EOVERFLOW;
+		err = ext4_expand_extra_isize(inode,
+					      EXT4_SB(sb)->s_want_extra_isize,
+					      &iloc);
+		if (err)
+			goto out_unlock;
+	} else {
 		brelse(iloc.bh);
-		goto out_unlock;
 	}
-	brelse(iloc.bh);
 
 	dquot_initialize(inode);
 
-- 
2.5.0
