Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=18.194.254.142
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794988434;
	b=NoNYD9rXetogoZxtuvvwwuOW9lO6zDlZs0AODS9aF9X/ZCYjgTwyzWOhe5BsGP2AlzvI
	 b1FVO5rcFcoW1jNWuVOZ4VvclCAPCZ5AcDoxfv3Ww3EGaBeXOJFrESXcKMVMLBsdB+qir
	 Af2UamKc67E80Q0656e9OJwiTIYxr7ja3WVDw1fFVzuRq+pDa3apnHG29/sC3JUl1JZRZ
	 dZcS58VMU127XzWgslNrZq6awq5ELO9NcSshg6dvmve8ktqhGLYJeI29FAJwmdVjefDmM
	 zWj+6tr5siedqoyyQ/fkEvYEyi9Wv6P+MMPrtvgF5enZ/pVPSTyvq/GIf0g7VkQpbzg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794988434;
	h=DMARC-Filter:DKIM-Signature:X-QQ-mid:X-QQ-Originating-IP:Received:
	 X-QQ-SSF:X-QQ-GoodBg:X-BIZMAIL-ID:EX-QQ-RecipientCnt:From:To:Cc:
	 Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding:X-QQ-SENDSIZE:Feedback-ID:X-QQ-XMAILINFO:
	 X-QQ-XMRINFO:X-QQ-RECHKSPAM;
	bh=of79InBT8mNzHXN/uvDqlWjI49LM2uy1zpAggkhCfQk=;
	b=KowtFEjhtucc1PdZ6gTM1GIQBT28bs8P84+3V5FuJ8Xhw5te2hLQMlLimc8pqSVqtAfg
	 r6RRZbUPsYSH+B/89vksShMaN33w1IEHxtH176/A3FfMSoyrV3ZODzDAVMLaSFtQlJF2J
	 CiZibIcI7kApN1ASj/ybapmPeyysC5/iFUvdpk9D4oJSJX0GzgFellTUmp25tLltBB0Ab
	 SZPB4ipD3kcS3UeRbaj8H7RWlMTP7JoMxfXL1tdb8h1vVHHyQT374OwdgP9y4HECNBpN3
	 Knx0/d2frmnOo0/pt6WtOAsGcudO+9Klee+UUG509lzJ0ztvfxSETUfmbfa1XpkbbMg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=uniontech.com;
	spf=pass smtp.mailfrom=uniontech.com;
	dkim=pass header.d=uniontech.com header.i=@uniontech.com header.a=rsa-sha256 header.s=onoh2408 header.b=ofh0vEwX;
	arc=none smtp.remote-ip=18.194.254.142
Received: from smtpbgeu2.qq.com (smtpbgeu2.qq.com [18.194.254.142])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1FF3606A31C;
	Wed, 18 Nov 2026 07:53:49 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org F1FF3606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=uniontech.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=uniontech.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=uniontech.com header.i=@uniontech.com header.a=rsa-sha256 header.s=onoh2408 header.b=ofh0vEwX
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=uniontech.com;
	s=onoh2408; t=1794988284;
	bh=of79InBT8mNzHXN/uvDqlWjI49LM2uy1zpAggkhCfQk=;
	h=From:To:Subject:Date:Message-ID:MIME-Version;
	b=ofh0vEwX2TnHgebMdDCJFGREhMzfCWQToCZlYnduCWQhE3OZivn6egqQY5gvNudZ3
	 SRn34XICFc7uB4efo9xdwv+2KBy99UwREvQ4UL68jRO17BbQvY4Vs6abd75C57oTF4
	 U95ETboZC3wVFeWsqRgPdquIyIVvGugt4vVeD+SQ=
X-QQ-mid: zesmtpgz4t1794988248t06460a35
X-QQ-Originating-IP: 9zN4+xFYLMZXKnEV2ob/Lm33ZLoC513MCczzFOhJeks=
Received: from uniontech.com ( [113.57.152.160])
	by bizesmtp.qq.com (ESMTP) with 
	id ; Wed, 18 Nov 2026 15:50:46 +0800 (CST)
X-QQ-SSF: 0000000000000000000000000000000
X-QQ-GoodBg: 1
X-BIZMAIL-ID: 1648745034229925548
EX-QQ-RecipientCnt: 12
From: Yichong Chen <chenyichong@uniontech.com>
To: tytso@mit.edu,
	adilger.kernel@dilger.ca,
	libaokun@linux.alibaba.com,
	jack@suse.cz,
	ojaswin@linux.ibm.com,
	ritesh.list@gmail.com,
	yi.zhang@huawei.com,
	linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: guanwentao@uniontech.com,
	niecheng1@uniontech.com,
	Morduan Zang <zhangdandan@uniontech.com>
Subject: [PATCH] ext4: keep ordered data and i_disksize consistent on size changes
Date: Wed, 18 Nov 2026 15:50:42 +0800
Message-ID: <D7EEAE1F0CDD3029+20261118075044.3511841-1-chenyichong@uniontech.com>
X-Mailer: git-send-email 2.51.0
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
X-QQ-SENDSIZE: 520
Feedback-ID: zesmtpgz:uniontech.com:qybglogicsvrgz:qybglogicsvrgz3a-0
X-QQ-XMAILINFO: N3KO+CQyl90OsWqLPlYFYkKCX63cC5HHaB4upXryfQgI+Ybk+pjAPCXt
	Wju4gG5asynVOR9Zh4ud+Ui7F+qi9GnqDBpRq1xIZdym+pLPO9x57sJu8FZuInyg2+WiQbj
	8vXnWiFL7gGF21fuo1RvUehVsHxDvCLvh20QKvCgUuvovJMAHkcm+YFJDueXy3f8/+MPEHf
	PcUYdmcl9MV4UkL0nMs3GfCjblb927DsfaeiMk1hF0xKC1p0eg1c11xy+YCfP20dks4cdFF
	Utqpf1HDNyEoJXgRlM0Q+iLhbCR2Nc6p2HHRcXtbx/k5rtP3Q8r7KAphvOfCTv/pJt2RxKW
	iaan3ItWj3DHImQb3ALLuZnEPREAkmEf9ZX945Lq4jzGcdH45CJYwIkr6ubY9CI/7BJj17O
	c6rlljyVuYlkGkwg/69IIsgVvTxvO2VqRSvpaAUH2ICIexhlpgXp3hVWh/r5CRMItNh834h
	WbuI/nW08vdTSXQOiAO/JBihfmnpXZgN9w9VcmJX6Ck9moFOHfXr6vkEctaJK/mgWWq77ut
	V2ZLsGldp/r+fYqP7KwCg77CDaLlsHHS9LlRU0fOcvTzWH2wwlMVRN7KFZ9yEJ51nOEkHEM
	8Xg31ZnbdBhb4fnTcT8E04mm0Jbl3u7EHcDGs5R8UHWspU2Jrv+/AEfGD0ap2KGxBKhw7oK
	7Ne+4cR7UBQybgM/Qy/VjRryWUhQUVBjgZhHnnA8N8IDTeeVZgefHHDHSJ+hjotv+6qAaMz
	WiD0sB6tarH3Q1ANLv+WCO1zdwcIQd2JZM7J43J0mMsYjfJYL+L0QZ9Dw4KHJmDxSofT7w8
	3qrlOesgou52zAYMbe98pH9UMHYffO21KF9pIARWzoYp84ulBkbeJp9YJ+pMpF5z/fgMQ2u
	js7O7VDAPeKuVHsX7NxfkSX/U5lM0Xi36ZGD0gBEo3Q+HYt9F/eVnaxvCZ9dpE3cDhtEPrs
	SVuBCwvVFGXUoNBI+CEWxPp/gaudIODWPOQMuZ7nxX+I1XmVScpjQng2RBSIxQlYiC7xdBm
	NOd30tkq1sJB7KWOmHe0oa48VFONeQ/tn+f/1iN3+Ya23/hbGC
X-QQ-XMRINFO: NS+P29fieYNwqS3WCnRCOn9D1NpZuCnCRA==
X-QQ-RECHKSPAM: 0

From: Morduan Zang <zhangdandan@uniontech.com>

ext4 propagates i_size into i_disksize on three size-changing paths:
ext4_truncate_up(), the shrink branch of ext4_truncate_down(), and
ext4_truncate() reached from a size-preserving ftruncate().  In ordered
data mode these paths can commit the new size while data below it is still
delalloc-only.  Delalloc data has no JBD2 ordered-data registration before
writeback; the registration done while allocating its blocks cannot
retroactively protect an earlier size update.

A crash between the metadata commit and writeback can therefore bring the
file back with a non-zero size, zero blocks and no extents - the classic
NULL file that generic/044..046 check for.

Measured on 7.4.0-rc3 (aebb7274, x86_64, ext4, default mount options) on
a copy of the xfstests scratch image, 20 files per run, pwrite then
truncate with no delay in between, sleep 10s, then simulated crash:

  write  truncate   result before the fix
  64k    64k        size=65536 blocks=0 no extent    (generic/044)
  64k    32k        size=32768 blocks=0 no extent    (generic/045)
  32k    64k        size=65536 blocks=0 no extent    (generic/046)

Fix both directions:

 - A truncate that does not change i_size only has to discard preallocated
   blocks past i_size.  It must not advance i_disksize, so route it to
   __ext4_truncate(inode, false).  Every other caller (evict, orphan
   cleanup, verity, real shrink) keeps advancing it, where the orphan list
   makes the update safe.

 - When the size really changes, write out the still-delalloc range before
   i_size/i_disksize are updated, via ext4_ordered_flush_to().  This runs
   outside any journal handle so writeback can start its own transaction,
   and before i_size is lowered so writeback still sees the old, larger
   size.

Start the writeback at i_disksize, but also search the extent status tree
for the first delayed extent in the surviving range and use the lower of
the two.  DIO and fallocate can advance i_disksize over older buffered
delalloc data, so i_disksize alone is not sufficient to prove that all
blocks below it exist.  For example, a buffered write followed by an
extending fallocate and a shrink can otherwise still leave a NULL file.

The inode and invalidate locks held by ext4_setattr() prevent new delalloc
extents from appearing.  Concurrent writeback can only remove delayed
extents or advance i_disksize, making the selected range more conservative.
Take the i_disksize snapshot under i_data_sem to serialize with writeback
and avoid a torn 64-bit read on 32-bit systems.  Drop the lock before
waiting.

This avoids turning every size change into a whole-file sync point when
there is no earlier delalloc data.  Inline data needs no separate flush
because it is committed with the inode itself.

The new writeback is limited to data=ordered: data=journal already keeps
data in the journal, and data=writeback never made this guarantee.  The
size-preserving change applies to all modes and simply avoids advancing
i_disksize past delalloc data.

Signed-off-by: Morduan Zang <zhangdandan@uniontech.com>
---
 fs/ext4/ext4.h     |  6 ++--
 fs/ext4/extents.c  | 18 +++++++----
 fs/ext4/indirect.c |  8 +++--
 fs/ext4/inode.c    | 75 +++++++++++++++++++++++++++++++++++++++++-----
 4 files changed, 89 insertions(+), 18 deletions(-)

diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index bf0325ecbec7..b948a5953760 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -3263,7 +3263,8 @@ static inline bool is_special_ino(struct super_block *sb, unsigned long ino)
 extern int ext4_ind_map_blocks(handle_t *handle, struct inode *inode,
 				struct ext4_map_blocks *map, int flags);
 extern int ext4_ind_trans_blocks(struct inode *inode, int nrblocks);
-extern void ext4_ind_truncate(handle_t *, struct inode *inode);
+extern void ext4_ind_truncate(handle_t *handle, struct inode *inode,
+			      bool update_disksize);
 extern int ext4_ind_remove_space(handle_t *handle, struct inode *inode,
 				 ext4_lblk_t start, ext4_lblk_t end);
 
@@ -3965,7 +3966,8 @@ extern int ext4_ext_map_blocks(handle_t *handle, struct inode *inode,
 ext4_lblk_t ext4_determine_insert_hole(struct inode *inode, ext4_lblk_t lblk,
 				       ext4_lblk_t hole_start,
 				       ext4_lblk_t hole_len);
-extern int ext4_ext_truncate(handle_t *, struct inode *);
+extern int ext4_ext_truncate(handle_t *handle, struct inode *inode,
+			     bool update_disksize);
 extern int ext4_ext_remove_space(struct inode *inode, ext4_lblk_t start,
 				 ext4_lblk_t end);
 extern void ext4_ext_init(struct super_block *);
diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index cd35e88bc372..fb5a16e5b176 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -4548,7 +4548,8 @@ int ext4_ext_map_blocks(handle_t *handle, struct inode *inode,
 	return err ? err : allocated;
 }
 
-int ext4_ext_truncate(handle_t *handle, struct inode *inode)
+int ext4_ext_truncate(handle_t *handle, struct inode *inode,
+		      bool update_disksize)
 {
 	struct super_block *sb = inode->i_sb;
 	ext4_lblk_t last_block;
@@ -4560,11 +4561,16 @@ int ext4_ext_truncate(handle_t *handle, struct inode *inode)
 	 * because page truncation is enough.
 	 */
 
-	/* we have to know where to truncate from in crash case */
-	__ext4_set_i_disksize(inode, inode->i_size);
-	err = ext4_mark_inode_dirty(handle, inode);
-	if (err)
-		return err;
+	/*
+	 * A size-preserving truncate must not expose delalloc-only data by
+	 * advancing the on-disk size before writeback.
+	 */
+	if (update_disksize) {
+		__ext4_set_i_disksize(inode, inode->i_size);
+		err = ext4_mark_inode_dirty(handle, inode);
+		if (err)
+			return err;
+	}
 
 	last_block = (inode->i_size + sb->s_blocksize - 1)
 			>> EXT4_BLOCK_SIZE_BITS(sb);
diff --git a/fs/ext4/indirect.c b/fs/ext4/indirect.c
index a495080df710..d4de88c802b8 100644
--- a/fs/ext4/indirect.c
+++ b/fs/ext4/indirect.c
@@ -1126,7 +1126,8 @@ static void ext4_free_branches(handle_t *handle, struct inode *inode,
 	}
 }
 
-void ext4_ind_truncate(handle_t *handle, struct inode *inode)
+void ext4_ind_truncate(handle_t *handle, struct inode *inode,
+		       bool update_disksize)
 {
 	struct ext4_inode_info *ei = EXT4_I(inode);
 	__le32 *i_data = ei->i_data;
@@ -1158,8 +1159,11 @@ void ext4_ind_truncate(handle_t *handle, struct inode *inode)
 	 * the new, shorter inode size (held for now in i_size) into the
 	 * on-disk inode. We do this via i_disksize, which is the value which
 	 * ext4 *really* writes onto the disk inode.
+	 *
+	 * A size-preserving truncate must not advance it past delalloc data.
 	 */
-	ei->i_disksize = inode->i_size;
+	if (update_disksize)
+		ei->i_disksize = inode->i_size;
 
 	if (last_block == max_block) {
 		/*
diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index e3129353d4ed..48de9716305f 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -5410,7 +5410,7 @@ int ext4_inode_attach_jinode(struct inode *inode)
  * that's fine - as long as they are linked from the inode, the post-crash
  * ext4_truncate() run will find them and release them.
  */
-int ext4_truncate(struct inode *inode)
+static int __ext4_truncate(struct inode *inode, bool update_disksize)
 {
 	struct ext4_inode_info *ei = EXT4_I(inode);
 	unsigned int credits;
@@ -5483,9 +5483,9 @@ int ext4_truncate(struct inode *inode)
 	ext4_discard_preallocations(inode);
 
 	if (ext4_test_inode_flag(inode, EXT4_INODE_EXTENTS))
-		err = ext4_ext_truncate(handle, inode);
+		err = ext4_ext_truncate(handle, inode, update_disksize);
 	else
-		ext4_ind_truncate(handle, inode);
+		ext4_ind_truncate(handle, inode, update_disksize);
 
 	up_write(&ei->i_data_sem);
 	if (err)
@@ -5516,6 +5516,11 @@ int ext4_truncate(struct inode *inode)
 	return err;
 }
 
+int ext4_truncate(struct inode *inode)
+{
+	return __ext4_truncate(inode, true);
+}
+
 static inline u64 ext4_inode_peek_iversion(const struct inode *inode)
 {
 	if (unlikely(EXT4_I(inode)->i_flags & EXT4_EA_INODE_FL))
@@ -6881,6 +6886,48 @@ static inline void ext4_set_inode_size(struct inode *inode, loff_t newsize)
 	up_write(&EXT4_I(inode)->i_data_sem);
 }
 
+/*
+ * Write back delalloc data before covering it with a new on-disk size.
+ *
+ * DIO and fallocate can advance i_disksize over older delalloc extents, so
+ * include the first delayed extent in the surviving range when choosing the
+ * start.  The inode and invalidate locks held by ext4_setattr() prevent new
+ * delalloc extents; concurrent writeback can only remove them and make the
+ * flush more conservative.
+ *
+ * Read i_disksize under i_data_sem to serialize with writeback and avoid a
+ * torn read on 32-bit systems.  Drop the lock before waiting because
+ * writeback needs it to advance i_disksize.
+ *
+ * Inline data is committed with the inode and needs no separate flush.
+ * Must be called without a journal handle and before i_size is lowered.
+ */
+static int ext4_ordered_flush_to(struct inode *inode, loff_t newsize)
+{
+	struct extent_status es;
+	ext4_lblk_t end_lblk;
+	loff_t start;
+
+	if (!ext4_should_order_data(inode) || ext4_has_inline_data(inode) ||
+	    newsize <= 0)
+		return 0;
+
+	end_lblk = (newsize - 1) >> inode->i_blkbits;
+	ext4_es_find_extent_range(inode, ext4_es_is_delayed, 0, end_lblk, &es);
+
+	down_read(&EXT4_I(inode)->i_data_sem);
+	start = EXT4_I(inode)->i_disksize;
+	up_read(&EXT4_I(inode)->i_data_sem);
+
+	if (es.es_len && es.es_lblk <= end_lblk)
+		start = min(start, EXT4_LBLK_TO_B(inode, es.es_lblk));
+	if (newsize <= start)
+		return 0;
+
+	return filemap_write_and_wait_range(inode->i_mapping, start,
+					    newsize - 1);
+}
+
 static int ext4_truncate_up(struct inode *inode, loff_t oldsize, loff_t newsize)
 {
 	ext4_lblk_t old_lblk, new_lblk;
@@ -6900,6 +6947,10 @@ static int ext4_truncate_up(struct inode *inode, loff_t oldsize, loff_t newsize)
 			return ret;
 	}
 
+	ret = ext4_ordered_flush_to(inode, newsize);
+	if (ret)
+		return ret;
+
 	handle = ext4_journal_start(inode, EXT4_HT_INODE, 3);
 	if (IS_ERR(handle))
 		return PTR_ERR(handle);
@@ -6931,10 +6982,20 @@ static int ext4_truncate_down(struct inode *inode, loff_t oldsize,
 	int ret;
 
 	/* Do not change i_size. */
-	if (newsize == oldsize)
-		goto truncate;
+	if (newsize == oldsize) {
+		/*
+		 * Only blocks past i_size need to be discarded.  Do not advance
+		 * i_disksize past data that may still be delalloc-only.
+		 */
+		truncate_pagecache(inode, newsize);
+		return __ext4_truncate(inode, false);
+	}
 
 	/* Shrink. */
+	ret = ext4_ordered_flush_to(inode, newsize);
+	if (ret)
+		return ret;
+
 	handle = ext4_journal_start(inode, EXT4_HT_INODE, 3);
 	if (IS_ERR(handle))
 		return PTR_ERR(handle);
@@ -6971,11 +7032,9 @@ static int ext4_truncate_down(struct inode *inode, loff_t oldsize,
 
 	if (ext4_should_journal_data(inode))
 		ext4_wait_for_tail_page_commit(inode);
-truncate:
 	/*
 	 * Truncate pagecache after we've waited for commit in data=journal
-	 * mode to make pages freeable.  Call ext4_truncate() even if
-	 * i_size didn't change to truncate possible preallocated blocks.
+	 * mode to make pages freeable.
 	 */
 	truncate_pagecache(inode, newsize);
 	return ext4_truncate(inode);
-- 
2.51.0

