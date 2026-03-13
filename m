Received: from fanzine2.igalia.com (fanzine2.igalia.com [213.97.179.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CCEAB1B4223;
	Fri, 13 Mar 2026 17:09:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.97.179.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773421766; cv=none; b=NpjOlZB8e5Ld4n0egYqsgxD1coS/ljQkctz6+LRpivwU7wlwmyztZbHOzO6eSo0yVgLZpZbkBpSarnNX0NyGc7oY4+pakz4wmqJw3bUzm7WR8/XXXJuuplV1/wijdmNgkNSj2WxH4hWnKbPTXZYOoGbYaqGTszXaLBhGuvV3f6s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773421766; c=relaxed/simple;
	bh=XmqXies5kA3TuR4yz+ZUHZ3IsoK58tN8j7mthjh2E3Y=;
	h=From:To:Subject:Date:Message-ID:MIME-Version:Content-Type; b=KxotiHyYSIhYNB/SdsOo98NncjbrprzDr8IvJ5C/TM/1jloLztN0ykyQaSHzMP33iZbsULhu47/fibvRA4qLzhJuWHUcI+gsJO2QtYW2WE28SWMlHjt7gW85rXEKpCAv15Z1maVF604ArB+cR46iKs5HTR4RhyBOpYaIDSaMlGQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=igalia.com; spf=pass smtp.mailfrom=igalia.com; dkim=pass (2048-bit key) header.d=igalia.com header.i=@igalia.com header.b=Tc3Qoo5x; arc=none smtp.client-ip=213.97.179.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=igalia.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=igalia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=igalia.com header.i=@igalia.com header.b="Tc3Qoo5x"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=igalia.com;
	s=20170329; h=Content-Transfer-Encoding:Content-Type:MIME-Version:Message-ID:
	Date:Subject:To:From:Sender:Reply-To:Cc:Content-ID:Content-Description:
	Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
	In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=3Mh/uxOo2ywsRvlG4XYtcAukAXSyJxjJ5ed1cGRSWAk=; b=Tc3Qoo5xA3LvVZW/gKapahjrFS
	OqYLKpI9peH3IrY4Q/A1O4NjKHBVmEG6d9YN8IYUUzBPFf1Ga6EFb8G2+ag4Wa00kfcD49ls3W+fM
	/OqxKMafPOr86e9JP1PJlXSHr1fGywPuf5lCwt0+VzQ8KdToUGE0woJrlpNqXMZSBX5xLQv6RBhmz
	CwCikZUzqHugbWPN3JFasR2Czt3M0V8j6XDCA60nvq53C36N5QVyrkHAE5Bx7KkHqSCW5JyydnnvG
	hZ/x97QA/FV5dFOwoQmZQfhnQhY5gf8SzAn3x2N5DDEVURFVJazkZASo0z4ixIsM5/yn9hcM2GswX
	db1POdsw==;
Received: from [187.106.45.161] (helo=toolbx)
	by fanzine2.igalia.com with esmtpsa 
	(Cipher TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256) (Exim)
	id 1w160k-00FLLw-00; Fri, 13 Mar 2026 18:09:18 +0100
From: Helen Koike <koike@igalia.com>
To: tytso@mit.edu,
	adilger.kernel@dilger.ca,
	linux-ext4@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	kernel-dev@igalia.com,
	koike@igalia.com,
	syzbot+b73703b873a33d8eb8f6@syzkaller.appspotmail.com
Subject: [PATCH v2] ext4: fix partial cluster handling when s_first_data_block != 0
Date: Fri, 13 Mar 2026 14:07:17 -0300
Message-ID: <20260313170904.1278594-1-koike@igalia.com>
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

Introduce three macros that subtract s_first_data_block before
operating, matching the coordinate system used by mballoc:

  EXT4_MB_B2C(sbi, blk)        block -> cluster number
  EXT4_MB_C2B(sbi, cluster)    cluster -> first block of cluster
  EXT4_MB_PBLK_COFF(s, blk)    intra-cluster offset of a block

Use EXT4_MB_B2C/EXT4_MB_C2B for all partial->pclu operations in
extents.c, and EXT4_MB_PBLK_COFF in the alignment prologue of
ext4_free_blocks().

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
  by syzbot due to corrupted eh_entries read by inode 15.

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

v2:
- Update commit title to reflect the partial cluster issue
- Minor updates in commit message
- Removed unnecessary EXT4_MB_LBLK_COFF macro
- Rewrite the macros to reuse preexisting macros
- Update parameter names and indentation to match current coding style
- Update comments before the new macros

v1: https://lore.kernel.org/all/20260313151835.1248953-1-koike@igalia.com/

---

Hi all,

I'm not very familiar with this subsystem or prior discussions around
this issue. I did some digging, but I couldn't find much related to it.
With that in mind, please let me know if this approach does not make
sense and/or if you have any pointers.

I also checked the thread below [1] to see whether the EXT4_NUM_* macros
should be used instead, but that seems to be addressing a different
context.

I appreciate any feedback.

[1] https://lore.kernel.org/all/20130221121545.GA30821@gmail.com/

Thanks,
Helen
---
 fs/ext4/ext4.h    |  9 +++++++++
 fs/ext4/extents.c | 20 ++++++++++----------
 fs/ext4/mballoc.c |  2 +-
 3 files changed, 20 insertions(+), 11 deletions(-)

diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index 7e8f66ba17f4..eb0cfcd1d97a 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -315,6 +315,12 @@ struct ext4_io_submit {
 #define EXT4_B2C(sbi, blk)	((blk) >> (sbi)->s_cluster_bits)
 /* Translate a cluster number to a block number */
 #define EXT4_C2B(sbi, cluster)	((cluster) << (sbi)->s_cluster_bits)
+/* Translate a block to cluster using mballoc's cluster definition */
+#define EXT4_MB_B2C(sbi, blk) (EXT4_B2C((sbi), (blk) - \
+		le32_to_cpu((sbi)->s_es->s_first_data_block)))
+/* Translate a cluster to block using mballoc's cluster definition */
+#define EXT4_MB_C2B(sbi, cluster) (EXT4_C2B((sbi), (cluster)) + \
+		le32_to_cpu((sbi)->s_es->s_first_data_block))
 /* Translate # of blks to # of clusters */
 #define EXT4_NUM_B2C(sbi, blks)	(((blks) + (sbi)->s_cluster_ratio - 1) >> \
 				 (sbi)->s_cluster_bits)
@@ -331,6 +337,9 @@ struct ext4_io_submit {
 				 ((ext4_fsblk_t) (s)->s_cluster_ratio - 1))
 #define EXT4_LBLK_COFF(s, lblk) ((lblk) &				\
 				 ((ext4_lblk_t) (s)->s_cluster_ratio - 1))
+/* Get the cluster offset using mballoc's cluster definition */
+#define EXT4_MB_PBLK_COFF(s, pblk) (EXT4_PBLK_COFF((s), (pblk) - \
+		le32_to_cpu((s)->s_es->s_first_data_block)))
 
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
index 9c7881a4ea75..eb57265e3347 100644
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
-- 
2.53.0

