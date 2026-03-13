Received: from fanzine2.igalia.com (fanzine2.igalia.com [213.97.179.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C54938F651;
	Fri, 13 Mar 2026 15:18:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.97.179.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773415141; cv=none; b=GA/IcX6dExjoWQUARz2UnIlrhr/A9iTp5ddKgPVCqFBiuwiv4oDVcEoxEOdSt0DzT/uFDrcGHCuZXqwhhK2NFikHES1c9shFA8irnsBGD1sZgd/6n+bOTR3PQ0S9py+FLhF6yhESJf+ANYimykQEOE8Mc4WdetDrVcvYdetxYZo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773415141; c=relaxed/simple;
	bh=wtMjCXHzkA1EUv5ltP+cLeay/dx12//WTzunS+F2pRc=;
	h=From:To:Subject:Date:Message-ID:MIME-Version:Content-Type; b=eI1xMJ/UJtMZaKoFdqzxUm72Q/rcEiv9Sk9mR0e1Rhl3Bd4QwoDnv3YxPR6onLGILJy0e6GUPbyNVtDWzBe93BhTIu5xfCfvQNpkaMrorxDEcLQBWKBQZGzpkdCWQPGloZE1l7LUTO0jlm+9/AM6ITJOWUQ6nahm9up3Elk0mqg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=igalia.com; spf=pass smtp.mailfrom=igalia.com; dkim=pass (2048-bit key) header.d=igalia.com header.i=@igalia.com header.b=k5aYx5yJ; arc=none smtp.client-ip=213.97.179.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=igalia.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=igalia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=igalia.com header.i=@igalia.com header.b="k5aYx5yJ"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=igalia.com;
	s=20170329; h=Content-Transfer-Encoding:Content-Type:MIME-Version:Message-ID:
	Date:Subject:To:From:Sender:Reply-To:Cc:Content-ID:Content-Description:
	Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
	In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=df4DHPcCsZ2Lc754B54t+5NS/j3zlIX54Mp+m3mcEqY=; b=k5aYx5yJ0SCnePuhvcayelD7F2
	01hhOEonmJpDivc+ruynEmITu8tSWwXmmHJkArfk5hc/2dAmYAZeZemKOwssXwZtjBNiFzrVv8llG
	iOxajQY/9D9SgNCpQtX0jRQ5NDyBiIoKiEI+2NtIA+mXrmUn6qrCNwTC2jZgSoK/q03ZOXYXfsyQ9
	Lzb/8Ov3po6Sks9pjqn7bKYALIkND+8FSY9iGNtoyzs4GB9RryEyR2D08wKzGZeH7TYqGNoaiYwD3
	y/5s+KykKly6muKXko8BuMA9vdHuJkbEqPhRbogtSK9BB23C2bIye/lM7Oc6NsmrkX6gW4j8tJZGG
	KITQN8wA==;
Received: from [187.106.45.161] (helo=toolbx)
	by fanzine2.igalia.com with esmtpsa 
	(Cipher TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256) (Exim)
	id 1w14Hn-00FIEy-8i; Fri, 13 Mar 2026 16:18:47 +0100
From: Helen Koike <koike@igalia.com>
To: tytso@mit.edu,
	adilger.kernel@dilger.ca,
	linux-ext4@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	kernel-dev@igalia.com,
	koike@igalia.com,
	syzbot+b73703b873a33d8eb8f6@syzkaller.appspotmail.com
Subject: [PATCH] ext4: fix bigalloc cluster arithmetic when s_first_data_block != 0
Date: Fri, 13 Mar 2026 12:18:30 -0300
Message-ID: <20260313151835.1248953-1-koike@igalia.com>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

On filesystems with bigalloc enabled and s_first_data_block != 0,
mballoc defines clusters starting from s_first_data_block, so cluster
N covers blocks [s_first_data_block + N*s_cluster_ratio, ...).

EXT4_B2C/EXT4_C2B perform a plain bit-shift on the absolute block
number, ignoring s_first_data_block.

For instance, with cluster_ratio = 4 and s_first_data_block = 1:

This is how EXT4_B2C/EXT4_C2B view it:

  block:    0   1   2   3   4   5   6   7   8   9  10  11  12 ...
            |___________|   |___________|   |___________|
  cluster:       0               1               2

This is how mballoc views it:

  block:    0   1   2   3   4   5   6   7   8   9  10  11  12 ...
                |___________|   |___________|   |___________|
  cluster:           0               1               2

This causes the following issues:

1) In extents.c, partial->pclu is stored and compared using EXT4_B2C,
   then passed to ext4_free_blocks() via EXT4_C2B. The resulting
   block address is misaligned with mballoc's cluster boundaries,
   causing the wrong cluster to be freed.

2) In ext4_free_blocks(), EXT4_PBLK_COFF uses the same plain
   bit-mask, so the intra-cluster offset of the start block is
   computed incorrectly, misaligning the freed range.

Introduce four macros that subtract s_first_data_block before
operating, matching the coordinate system used by mballoc:

  EXT4_MB_B2C(sbi, blk)        block -> cluster number
  EXT4_MB_C2B(sbi, cluster)    cluster -> first block of cluster
  EXT4_MB_PBLK_COFF(sbi, blk)  intra-cluster offset of a block
  EXT4_MB_LBLK_COFF(sbi, n)    intra-cluster offset of a block count

Use EXT4_MB_B2C/EXT4_MB_C2B for all partial->pclu operations in
extents.c, and EXT4_MB_PBLK_COFF/EXT4_MB_LBLK_COFF in the alignment
prologue of ext4_free_blocks().

Regarding the issue reported by syzbot:

  Context: s_first_data_block=1, cluster size 16 and block 145 contains
  a extents leaf for inode 15.
  When an extent is removed (block 145 went from 7 to 6 valid extent
  entries), ext4_ext_rm_leaf() sees the cluster partial->pclu (which is
  10) to be freed.

  Note that EXT4_C2B(partial->pclu=10) is 160, and EXT4_B2C(145) is 9
  (so the extents leaf is in a different cluster). Finally
  ext4_free_blocks(..,block=160, count=16..) is called, which shouldn't
  be a problem (it should not free block 145).

  Except that in  ext4_free_blocks() (and later in ext4_mb_clear_bb()
  and mb_free_blocks()) , block 160 resolves to group 0 bit 9 count 1
  (which frees block 145 containing extents leaf!!!!), causing block
  145 to be reused by other inodes while inode 15 still thinks that
  block 145 contains extents metadata, resulting later in the UAF we see
  by syzbot.

  The issue doesn't reproduce with the current patch.

Test results:

> kvm-xfstests --kernel $BUILD_DIR/arch/x86/boot/bzImage smoke

ext4/4k: 7 tests, 1 skipped, 1113 seconds
  generic/475  Pass     185s
  generic/476  Pass     184s
  generic/521  Pass     182s
  generic/522  Pass     181s
  generic/642  Pass     185s
  generic/750  Pass     185s
  generic/751  Skipped  1s
Totals: 7 tests, 1 skipped, 0 failures, 0 errors, 1103s

> kvm-xfstests --kernel $BUILD_DIR/arch/x86/boot/bzImage -c 1k smoke

ext4/1k: 5 tests, 1 skipped, 755 seconds
  generic/521  Pass     183s
  generic/522  Pass     182s
  generic/642  Pass     186s
  generic/750  Pass     186s
  generic/751  Skipped  2s
Totals: 5 tests, 1 skipped, 0 failures, 0 errors, 739s

Signed-off-by: Helen Koike <koike@igalia.com>
Reported-by: syzbot+b73703b873a33d8eb8f6@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=b73703b873a33d8eb8f6

---

Hi all,

I'm sorry if the commit message is too verbose. I'm not a file system
developer, so I tried to be didactic for those like me.

I was also wondering if I should update the existing macros instead of
creating new ones, but since I'm not very familiar with this subsystem
and current discussions I decided to be safe and change only for the use
case I could test.

If you think this line of solution make sense I could update the
existing macros, please just let me know.

Thanks
Helen

---
 fs/ext4/ext4.h    | 21 +++++++++++++++++++++
 fs/ext4/extents.c | 20 ++++++++++----------
 fs/ext4/mballoc.c |  4 ++--
 3 files changed, 33 insertions(+), 12 deletions(-)

diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index 7e8f66ba17f4..83fd6e53c003 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -315,6 +315,17 @@ struct ext4_io_submit {
 #define EXT4_B2C(sbi, blk)	((blk) >> (sbi)->s_cluster_bits)
 /* Translate a cluster number to a block number */
 #define EXT4_C2B(sbi, cluster)	((cluster) << (sbi)->s_cluster_bits)
+/*
+ * Translate a physical block number to a cluster number using mballoc's
+ * cluster definition, which accounts for s_first_data_block.  Use these
+ * when tracking partial->pclu so that the cluster numbers are consistent
+ * with what ext4_get_group_no_and_offset() (and thus ext4_free_blocks())
+ * expects.
+ */
+#define EXT4_MB_B2C(sbi, nr) \
+	(((nr) - le32_to_cpu((sbi)->s_es->s_first_data_block)) >> (sbi)->s_cluster_bits)
+#define EXT4_MB_C2B(sbi, cluster) \
+	(((cluster) << (sbi)->s_cluster_bits) + le32_to_cpu((sbi)->s_es->s_first_data_block))
 /* Translate # of blks to # of clusters */
 #define EXT4_NUM_B2C(sbi, blks)	(((blks) + (sbi)->s_cluster_ratio - 1) >> \
 				 (sbi)->s_cluster_bits)
@@ -331,6 +342,16 @@ struct ext4_io_submit {
 				 ((ext4_fsblk_t) (s)->s_cluster_ratio - 1))
 #define EXT4_LBLK_COFF(s, lblk) ((lblk) &				\
 				 ((ext4_lblk_t) (s)->s_cluster_ratio - 1))
+/*
+ * Cluster-offset macros that account for s_first_data_block, consistent
+ * with mballoc's cluster numbering.  Use EXT4_MB_PBLK_COFF when aligning a
+ * physical block number and EXT4_MB_LBLK_COFF when aligning a block count.
+ */
+#define EXT4_MB_PBLK_COFF(sbi, pblk) \
+	(((pblk) - le32_to_cpu((sbi)->s_es->s_first_data_block)) & \
+	 ((ext4_fsblk_t)(sbi)->s_cluster_ratio - 1))
+#define EXT4_MB_LBLK_COFF(sbi, lblk) \
+	((lblk) & ((ext4_lblk_t)(sbi)->s_cluster_ratio - 1))
 
 /*
  * Structure of a blocks group descriptor
diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index 35703dce23a3..38d49f784c22 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -2493,13 +2493,13 @@ static int ext4_remove_blocks(handle_t *handle, struct inode *inode,
 	last_pblk = ext4_ext_pblock(ex) + ee_len - 1;
 
 	if (partial->state != initial &&
-	    partial->pclu != EXT4_B2C(sbi, last_pblk)) {
+	    partial->pclu != EXT4_MB_B2C(sbi, last_pblk)) {
 		if (partial->state == tofree) {
 			flags = get_default_free_blocks_flags(inode);
 			if (ext4_is_pending(inode, partial->lblk))
 				flags |= EXT4_FREE_BLOCKS_RERESERVE_CLUSTER;
 			ext4_free_blocks(handle, inode, NULL,
-					 EXT4_C2B(sbi, partial->pclu),
+					 EXT4_MB_C2B(sbi, partial->pclu),
 					 sbi->s_cluster_ratio, flags);
 			if (flags & EXT4_FREE_BLOCKS_RERESERVE_CLUSTER)
 				ext4_rereserve_cluster(inode, partial->lblk);
@@ -2545,7 +2545,7 @@ static int ext4_remove_blocks(handle_t *handle, struct inode *inode,
 	ext4_free_blocks(handle, inode, NULL, pblk, num, flags);
 
 	/* reset the partial cluster if we've freed past it */
-	if (partial->state != initial && partial->pclu != EXT4_B2C(sbi, pblk))
+	if (partial->state != initial && partial->pclu != EXT4_MB_B2C(sbi, pblk))
 		partial->state = initial;
 
 	/*
@@ -2560,7 +2560,7 @@ static int ext4_remove_blocks(handle_t *handle, struct inode *inode,
 	 */
 	if (EXT4_LBLK_COFF(sbi, from) && num == ee_len) {
 		if (partial->state == initial) {
-			partial->pclu = EXT4_B2C(sbi, pblk);
+			partial->pclu = EXT4_MB_B2C(sbi, pblk);
 			partial->lblk = from;
 			partial->state = tofree;
 		}
@@ -2651,7 +2651,7 @@ ext4_ext_rm_leaf(handle_t *handle, struct inode *inode,
 			 */
 			if (sbi->s_cluster_ratio > 1) {
 				pblk = ext4_ext_pblock(ex);
-				partial->pclu = EXT4_B2C(sbi, pblk);
+				partial->pclu = EXT4_MB_B2C(sbi, pblk);
 				partial->state = nofree;
 			}
 			ex--;
@@ -2766,13 +2766,13 @@ ext4_ext_rm_leaf(handle_t *handle, struct inode *inode,
 	 */
 	if (partial->state == tofree && ex >= EXT_FIRST_EXTENT(eh)) {
 		pblk = ext4_ext_pblock(ex) + ex_ee_len - 1;
-		if (partial->pclu != EXT4_B2C(sbi, pblk)) {
+		if (partial->pclu != EXT4_MB_B2C(sbi, pblk)) {
 			int flags = get_default_free_blocks_flags(inode);
 
 			if (ext4_is_pending(inode, partial->lblk))
 				flags |= EXT4_FREE_BLOCKS_RERESERVE_CLUSTER;
 			ext4_free_blocks(handle, inode, NULL,
-					 EXT4_C2B(sbi, partial->pclu),
+					 EXT4_MB_C2B(sbi, partial->pclu),
 					 sbi->s_cluster_ratio, flags);
 			if (flags & EXT4_FREE_BLOCKS_RERESERVE_CLUSTER)
 				ext4_rereserve_cluster(inode, partial->lblk);
@@ -2886,7 +2886,7 @@ int ext4_ext_remove_space(struct inode *inode, ext4_lblk_t start,
 			 */
 			if (sbi->s_cluster_ratio > 1) {
 				pblk = ext4_ext_pblock(ex) + end - ee_block + 1;
-				partial.pclu = EXT4_B2C(sbi, pblk);
+				partial.pclu = EXT4_MB_B2C(sbi, pblk);
 				partial.state = nofree;
 			}
 
@@ -2919,7 +2919,7 @@ int ext4_ext_remove_space(struct inode *inode, ext4_lblk_t start,
 			if (err < 0)
 				goto out;
 			if (pblk) {
-				partial.pclu = EXT4_B2C(sbi, pblk);
+				partial.pclu = EXT4_MB_B2C(sbi, pblk);
 				partial.state = nofree;
 			}
 		}
@@ -3041,7 +3041,7 @@ int ext4_ext_remove_space(struct inode *inode, ext4_lblk_t start,
 		if (ext4_is_pending(inode, partial.lblk))
 			flags |= EXT4_FREE_BLOCKS_RERESERVE_CLUSTER;
 		ext4_free_blocks(handle, inode, NULL,
-				 EXT4_C2B(sbi, partial.pclu),
+				 EXT4_MB_C2B(sbi, partial.pclu),
 				 sbi->s_cluster_ratio, flags);
 		if (flags & EXT4_FREE_BLOCKS_RERESERVE_CLUSTER)
 			ext4_rereserve_cluster(inode, partial.lblk);
diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
index 9c7881a4ea75..5c7ad20e4e7a 100644
--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -6360,7 +6360,7 @@ void ext4_free_blocks(handle_t *handle, struct inode *inode,
 	 * blocks at the beginning or the end unless we are explicitly
 	 * requested to avoid doing so.
 	 */
-	overflow = EXT4_PBLK_COFF(sbi, block);
+	overflow = EXT4_MB_PBLK_COFF(sbi, block);
 	if (overflow) {
 		if (flags & EXT4_FREE_BLOCKS_NOFREE_FIRST_CLUSTER) {
 			overflow = sbi->s_cluster_ratio - overflow;
@@ -6376,7 +6376,7 @@ void ext4_free_blocks(handle_t *handle, struct inode *inode,
 		/* The range changed so it's no longer validated */
 		flags &= ~EXT4_FREE_BLOCKS_VALIDATED;
 	}
-	overflow = EXT4_LBLK_COFF(sbi, count);
+	overflow = EXT4_MB_LBLK_COFF(sbi, count);
 	if (overflow) {
 		if (flags & EXT4_FREE_BLOCKS_NOFREE_LAST_CLUSTER) {
 			if (count > overflow)
-- 
2.53.0

