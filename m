Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.210.180
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795400600;
	b=ds6OKDwYKrpACWSioCBlq6bu4HAGZaP8hyT440BqTMK4HopRs26CO1yYx0s8exKjxcIM
	 xyIu9E4SQt33YGGVs6GtK9pUMgO9r3fbb3eMGTcgNLXaR9IA2VJjA+nGTxj/E5MKNvQJv
	 ckJXcg5SaT9lvyXqLtQBrSWXlgRe1PON2D4xQ2yjN/FACWj69p+Rm5z5cWcncnrsGzDWc
	 FVwuF2bYjqId5hq5IJDltzlNNUZ54sn5UnlyzD4aeBoTQBeRvbRaKM9y+vzw0om0HtuK4
	 2MZIDps6QLueVrbErEnVGSw1E3b5zLoLOYAU+SPuL5kDig40qY1HBnUTdAcmssGnKyQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795400600;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding;
	bh=7uAY5/w5Puv28N2neSgul396PP9IIniC66BhUtJLfCI=;
	b=RaWcTb/BlYgJsTkei1Jkp9FRVBtbp1S3aWEWrkbhhIIsqRxKFPBpYD6l9pOBLbuQQb9d
	 N/HfWlY2UE91X/8PMRiWL9qY7AEra+zqkCNOKH0dPa4NooC70cdT7V31/9/cFoLu6mi0k
	 wNPc3oJRunPcUuGcSOgP17n3Am2GFlcDNmOXlJ+BtCNO4OjbjYN1o4xTolzkTvx54JWiQ
	 lqTiau1vJQA8+LLyerLNPgr2r4pE0jncDbhhbX6GTZs5YPA7QvVU7nlICp8+R8BJfAilm
	 2mRv9SOQcU0ogh5BUY5Cd9v5fRfkuAPGksmd7crJnlPObkWb3nN9fSHNgdpE4W8peCw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=A9yCVn+f;
	arc=none smtp.remote-ip=209.85.210.180
Received: from mail-pf1-f180.google.com (mail-pf1-f180.google.com [209.85.210.180])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 558A1606A31A
	for <linux-ext4@vger.kernel.org>; Mon, 23 Nov 2026 02:23:20 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 558A1606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=A9yCVn+f
Received: by mail-pf1-f180.google.com with SMTP id d2e1a72fcca58-8a05b210703so1208272b3a.0
        for <linux-ext4@vger.kernel.org>; Sun, 22 Nov 2026 18:23:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795400600; x=1796005400; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=7uAY5/w5Puv28N2neSgul396PP9IIniC66BhUtJLfCI=;
        b=A9yCVn+fXInLTFUm76cI1GkeVtfvpWmSK9DX9wGE20dpsGNOtf1b6Nci87QJl+iV2h
         Hz0xVtkRxCH0KeaZus91CkSOx5fEFQ6Vc3sasd2qLPAZbUhirYHBTRxDnLasFf39bPyD
         TsjsldW61vs+88EnGrXkz/OIIqsWwLLH/uUlEvJuLKrLbgy7iwf2zkApYzaqLK0UKUXj
         k9ouyak+xtRVrNfxG8v+fHuk8ahpaed6i1z5+AWUT8Qmq8PM78KhuuYJMzOq/T93dIXn
         Xqr9FBDys8+6ljh4vIA+hLjDPtp5ZKKBoOhRMSRdFn7Z3hP56XA8f3EiRB44lawe7ffl
         paPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795400600; x=1796005400;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=7uAY5/w5Puv28N2neSgul396PP9IIniC66BhUtJLfCI=;
        b=CGTrjRoUpTLOCwbpqTsr5KYIptejv+lCOmqsGnnxOtfv18JnqNZtbeGQoP3Z6dnpUF
         BsNByLi4Owb6yylaTgWI4VMsBKeG0SUd0oEmoF/Ky56GYR1ax9sNPFsmfZY1ufynrBbO
         EL2UWzmTJYCXJhE5B3qaQTwqbn38k4Biy/AyOMAdFzm5M4MoV8Y0x98Ai2GGkGd4AGMO
         SsFIfJ1NNapA7o277dzpdOmDGw8GCYgLZUmUne4D0xaYiJRw0mINgkUo5yVV29P624dn
         IRLwlEKbxkv686TVOK2XitKA/LMS+MI7xV2ZZx+0xFxyOG9oDA7KX1QZEU2jSHMMsrXU
         tfOw==
X-Forwarded-Encrypted: i=1; AL+hErHh2d4cOjKC9HZHs7W12bWEhItwiqseQp4BKIOkOnTGlZr4eljOb14vAo5oUkJeTf+TOBVKsc4JOgIV@vger.kernel.org
X-Gm-Message-State: APuU4Z+wZPrYdlQkDr+qJEUPHil/Y9gbjGvFFUgTddu6vvj5fwuN6tRb
	r4PrEFAnpmcgyfhWc5d4LAyt0vpeWfErgdruCFgpY68R5ZNS+lRUp0jr
X-Gm-Gg: AZFdTZfmVNFas3eKeW94eFUd9FgWTzeoPSN/bOSWO1BorOJi37t8U68sdsBJCW9LJ1u
	6Dn4Tr9fNDfsvz9C6xd04946aLReoVWOw87MEUEgtuqdU9F5btMamZbSW3+huFaeNAvQvbPhN3L
	wjTyzup+Ze8iTsPut/vBrHSR/APRxD3tS4+O423/q9ECLP4zI7dGvSwiQV6Gy/BT7WVmgbfVR0o
	yDAZMEDV3J8jUrWYxZsX6H0VZklVGNWnq3x5c0GGXrMzLTuSEvsXz/H3A292sr13SUOdQnYFmaT
	noHQErwZ/G0pMmaQtbTNrmKihryvkojNxz6nfK75AUYdzkEIWNUVEJCwMNxT83Cep/2ZUNNPpT9
	uI3yu+nkporZ1/wcev+6VhAMZPXogjeh3eQzvTuCvlCIZPSWHaf2APz/gRcJ78UEk9flgm/ifWi
	hjsRTU1vFvX8J/2OEN2CVHFIYJrLMa4HwcCuBjJ7EMvvvKHPyp9Ki6LscbV63SkKufz4mSNNqIa
	2q4gmaPQSRvlJ+uP9HCYcBgdnIsEgvbRhIRPG1kSPWZfK1941cZYK8B3K2tgNEfvTpnILFKllDH
	CMbFs+ePIlOfuObOQ9vAHFVdG7VtfzR4M78DmdarT31PtVtOvVVD8vSQKdKr/LSc
X-Received: by 2002:a05:6a00:1301:b0:881:be70:4490 with SMTP id d2e1a72fcca58-8c87c38b63emr9479674b3a.28.1795400599553;
        Sun, 22 Nov 2026 18:23:19 -0800 (PST)
Received: from jubuntu-dev.. (125-227-154-99.hinet-ip.hinet.net. [125.227.154.99])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-8c87344058bsm4564365b3a.41.2026.11.22.18.23.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 22 Nov 2026 18:23:19 -0800 (PST)
From: Hsiu-Hsien Lee <swinds24@gmail.com>
To: Theodore Ts'o <tytso@mit.edu>,
	Andreas Dilger <adilger.kernel@dilger.ca>
Cc: Jan Kara <jack@suse.cz>,
	Baokun Li <libaokun@linux.alibaba.com>,
	Ojaswin Mujoo <ojaswin@linux.ibm.com>,
	Ritesh Harjani <ritesh.list@gmail.com>,
	Zhang Yi <yi.zhang@huawei.com>,
	linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Hsiu-Hsien Lee <swinds24@gmail.com>
Subject: [PATCH] ext4: use unsigned int for inode numbers in fast commit
Date: Mon, 23 Nov 2026 10:23:09 +0800
Message-ID: <20261123022309.990044-1-swinds24@gmail.com>
X-Mailer: git-send-email 2.43.0
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

The fast commit code keeps inode numbers in signed int: fcd_parent and
fcd_ino in struct ext4_fc_dentry_update, the fc_modified_inodes array,
struct dentry_info_args, the inode number in ext4_fc_replay_inode() and
the argument of ext4_fc_record_modified_inode() and
ext4_mark_inode_used().  On a file system with more than 2^31 inodes,
inode numbers of 2^31 and above become negative.

In the commit path, fcd_ino is sign-extended when compared with i_ino,
so the WARN_ON() in ext4_fc_commit_dentry_updates() fires on every
fsync() of a newly created file with such an inode number.

In the replay path, the sign-extended value passed to ext4_iget() is
larger than s_inodes_count, so ext4_iget() reports "iget: illegal
inode #" and the dentry and inode tags of these inodes are not replayed
after a crash.

The on-disk fields are __le32 and converted with cpu_to_le32() and
le32_to_cpu(), so the journal format does not change.  Also print these
inode numbers with %u, and print the parent inode number instead of the
child's when the parent directory of a create is not found.

Reproducer:

  dd if=/dev/zero of=img bs=1M count=0 seek=9437184    # 9 TiB sparse
  mkfs.ext4 -O fast_commit -i 4096 -E lazy_itable_init=1 img
  mount -o loop,noinit_itable img /mnt
  mkdir /mnt/d1 ... /mnt/d64    # Orlov spreads them over all groups
  pick a directory with an inode number >= 2^31, then
  dd if=/dev/zero of=/mnt/dN/f bs=4k count=1 conv=fsync

Without this patch every such fsync() triggers the WARN_ON().  With it
there is no warning, and after EXT4_IOC_SHUTDOWN with
EXT4_GOING_FLAGS_NOLOGFLUSH following creates, an unlink, a link and an
append in that directory, all of them are replayed on the next mount and
e2fsck -fn finds no errors.

Fixes: aa75f4d3daae ("ext4: main fast-commit commit path")
Fixes: 8016e29f4362 ("ext4: fast commit recovery path")
Assisted-by: Claude Opus 5.5
Signed-off-by: Hsiu-Hsien Lee <swinds24@gmail.com>
---
Testing: the reproducer and crash test above were run on a 6.6.y
kernel with this patch backported (the same change apart from context).
Without the patch, 10 of 10 fsync() calls in a directory with inode
number 2343567361 triggered the warning; with it, 0 of 10 did in a
directory with inode number 2313158657, while the fast commit stats
showed 26 commits and 0 ineligible.  On this tree the
patch is build-tested only (W=1, CONFIG_EXT4_DEBUG, ext4 KUnit tests).

The pending KUnit series for fast_commit.c [1] adds stubs and test
helpers with "int ino" arguments that will need the same type change
if it lands first.

[1] https://lore.kernel.org/linux-ext4/20261119155658.1940864-8-tytso@mit.edu/

 fs/ext4/ext4.h        |  2 +-
 fs/ext4/fast_commit.c | 28 ++++++++++++++++------------
 fs/ext4/fast_commit.h |  6 +++---
 fs/ext4/ialloc.c      |  2 +-
 4 files changed, 21 insertions(+), 17 deletions(-)

diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index aa0f23052..75039cf83 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -3067,7 +3067,7 @@ extern int ext4fs_dirhash(const struct inode *dir, const char *name, int len,
 			  struct dx_hash_info *hinfo);
 
 /* ialloc.c */
-extern int ext4_mark_inode_used(struct super_block *sb, int ino);
+extern int ext4_mark_inode_used(struct super_block *sb, unsigned int ino);
 extern struct inode *__ext4_new_inode(const struct mnt_idmap *, handle_t *,
 				      struct inode *, umode_t,
 				      const struct qstr *qstr, __u32 goal,
diff --git a/fs/ext4/fast_commit.c b/fs/ext4/fast_commit.c
index 5f12449b9..4a066e43e 100644
--- a/fs/ext4/fast_commit.c
+++ b/fs/ext4/fast_commit.c
@@ -1763,7 +1763,8 @@ static void ext4_fc_cleanup(journal_t *journal, int full, tid_t tid)
 
 /* Helper struct for dentry replay routines */
 struct dentry_info_args {
-	int parent_ino, dname_len, ino, inode_len;
+	unsigned int parent_ino, ino;
+	int dname_len, inode_len;
 	char *dname;
 };
 
@@ -1814,14 +1815,14 @@ static int ext4_fc_replay_unlink(struct super_block *sb,
 	inode = ext4_iget(sb, darg.ino, EXT4_IGET_NORMAL);
 
 	if (IS_ERR(inode)) {
-		ext4_debug("Inode %d not found", darg.ino);
+		ext4_debug("Inode %u not found", darg.ino);
 		return 0;
 	}
 
 	old_parent = ext4_iget(sb, darg.parent_ino,
 				EXT4_IGET_NORMAL);
 	if (IS_ERR(old_parent)) {
-		ext4_debug("Dir with inode %d not found", darg.parent_ino);
+		ext4_debug("Dir with inode %u not found", darg.parent_ino);
 		iput(inode);
 		return 0;
 	}
@@ -1845,7 +1846,7 @@ static int ext4_fc_replay_link_internal(struct super_block *sb,
 
 	dir = ext4_iget(sb, darg->parent_ino, EXT4_IGET_NORMAL);
 	if (IS_ERR(dir)) {
-		ext4_debug("Dir with inode %d not found.", darg->parent_ino);
+		ext4_debug("Dir with inode %u not found.", darg->parent_ino);
 		dir = NULL;
 		goto out;
 	}
@@ -1897,7 +1898,8 @@ static int ext4_fc_replay_link(struct super_block *sb,
  * Record all the modified inodes during replay. We use this later to setup
  * block bitmaps correctly.
  */
-static int ext4_fc_record_modified_inode(struct super_block *sb, int ino)
+static int ext4_fc_record_modified_inode(struct super_block *sb,
+					 unsigned int ino)
 {
 	struct ext4_fc_replay_state *state;
 	int i;
@@ -1907,10 +1909,11 @@ static int ext4_fc_record_modified_inode(struct super_block *sb, int ino)
 		if (state->fc_modified_inodes[i] == ino)
 			return 0;
 	if (state->fc_modified_inodes_used == state->fc_modified_inodes_size) {
-		int *fc_modified_inodes;
+		unsigned int *fc_modified_inodes;
 
 		fc_modified_inodes = krealloc(state->fc_modified_inodes,
-				sizeof(int) * (state->fc_modified_inodes_size +
+				sizeof(*fc_modified_inodes) *
+				(state->fc_modified_inodes_size +
 				EXT4_FC_REPLAY_REALLOC_INCREMENT),
 				GFP_KERNEL);
 		if (!fc_modified_inodes)
@@ -1934,7 +1937,8 @@ static int ext4_fc_replay_inode(struct super_block *sb,
 	struct ext4_inode *raw_fc_inode;
 	struct inode *inode = NULL;
 	struct ext4_iloc iloc;
-	int inode_len, ino, ret, tag = tl->fc_tag;
+	int inode_len, ret, tag = tl->fc_tag;
+	unsigned int ino;
 	struct ext4_extent_header *eh;
 	size_t off_gen = offsetof(struct ext4_inode, i_generation);
 
@@ -2058,7 +2062,7 @@ static int ext4_fc_replay_create(struct super_block *sb,
 
 	inode = ext4_iget(sb, darg.ino, EXT4_IGET_NORMAL);
 	if (IS_ERR(inode)) {
-		ext4_debug("inode %d not found.", darg.ino);
+		ext4_debug("inode %u not found.", darg.ino);
 		inode = NULL;
 		ret = -EINVAL;
 		goto out;
@@ -2071,7 +2075,7 @@ static int ext4_fc_replay_create(struct super_block *sb,
 		 */
 		dir = ext4_iget(sb, darg.parent_ino, EXT4_IGET_NORMAL);
 		if (IS_ERR(dir)) {
-			ext4_debug("Dir %d not found.", darg.ino);
+			ext4_debug("Dir %u not found.", darg.parent_ino);
 			ret = PTR_ERR(dir);
 			goto out;
 		}
@@ -2280,7 +2284,7 @@ ext4_fc_replay_del_range(struct super_block *sb, u8 *val)
 
 	inode = ext4_iget(sb, le32_to_cpu(lrange.fc_ino), EXT4_IGET_NORMAL);
 	if (IS_ERR(inode)) {
-		ext4_debug("Inode %d not found", le32_to_cpu(lrange.fc_ino));
+		ext4_debug("Inode %u not found", le32_to_cpu(lrange.fc_ino));
 		return 0;
 	}
 
@@ -2338,7 +2342,7 @@ static int ext4_fc_set_bitmaps_and_counters(struct super_block *sb)
 		inode = ext4_iget(sb, state->fc_modified_inodes[i],
 			EXT4_IGET_NORMAL);
 		if (IS_ERR(inode)) {
-			ext4_debug("Inode %d not found.",
+			ext4_debug("Inode %u not found.",
 				state->fc_modified_inodes[i]);
 			continue;
 		}
diff --git a/fs/ext4/fast_commit.h b/fs/ext4/fast_commit.h
index 2f77a37fb..446841c4b 100644
--- a/fs/ext4/fast_commit.h
+++ b/fs/ext4/fast_commit.h
@@ -110,8 +110,8 @@ enum {
  */
 struct ext4_fc_dentry_update {
 	int fcd_op;		/* Type of update create / unlink / link */
-	int fcd_parent;		/* Parent inode number */
-	int fcd_ino;		/* Inode number */
+	unsigned int fcd_parent;	/* Parent inode number */
+	unsigned int fcd_ino;		/* Inode number */
 	struct name_snapshot fcd_name;	/* Dirent name */
 	struct list_head fcd_list;
 	struct list_head fcd_dilist;
@@ -153,7 +153,7 @@ struct ext4_fc_replay_state {
 	int fc_crc;
 	struct ext4_fc_alloc_region *fc_regions;
 	int fc_regions_size, fc_regions_used, fc_regions_valid;
-	int *fc_modified_inodes;
+	unsigned int *fc_modified_inodes;
 	int fc_modified_inodes_used, fc_modified_inodes_size;
 };
 
diff --git a/fs/ext4/ialloc.c b/fs/ext4/ialloc.c
index 92e2243b9..4ad7a1809 100644
--- a/fs/ext4/ialloc.c
+++ b/fs/ext4/ialloc.c
@@ -817,7 +817,7 @@ static int find_inode_bit(struct super_block *sb, ext4_group_t group,
 	return 1;
 }
 
-int ext4_mark_inode_used(struct super_block *sb, int ino)
+int ext4_mark_inode_used(struct super_block *sb, unsigned int ino)
 {
 	unsigned long max_ino = le32_to_cpu(EXT4_SB(sb)->s_es->s_inodes_count);
 	struct buffer_head *inode_bitmap_bh = NULL, *group_desc_bh = NULL;

base-commit: 008aad6508e30cd1bb6d2c2cf65221ba1f16a065
-- 
2.43.0

