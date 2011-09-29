From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH 1/2] libquota: use ext2fs byte swapping functions for portability
Date: Wed, 28 Sep 2011 20:30:14 -0400
Message-ID: <1317256215-12544-1-git-send-email-tytso@mit.edu>
Cc: Theodore Ts'o <tytso@mit.edu>, Aditya Kali <adityakali@google.com>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:56468 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754063Ab1I2AaR (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 28 Sep 2011 20:30:17 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
 lib/quota/quota.h        |    1 +
 lib/quota/quotaio.c      |    1 -
 lib/quota/quotaio_tree.c |   51 +++++++++++++++-------------
 lib/quota/quotaio_v2.c   |   81 +++++++++++++++++++++++----------------------
 4 files changed, 69 insertions(+), 65 deletions(-)

diff --git a/lib/quota/quota.h b/lib/quota/quota.h
index aab66d9..cc6c98e 100644
--- a/lib/quota/quota.h
+++ b/lib/quota/quota.h
@@ -35,6 +35,7 @@
 
 #include <errno.h>
 #include <sys/types.h>
+#include <ext2fs/ext2_types.h>
 
 #define __DQUOT_VERSION__	"dquot_6.5.2"
 
diff --git a/lib/quota/quotaio.c b/lib/quota/quotaio.c
index ac04f42..7e080c8 100644
--- a/lib/quota/quotaio.c
+++ b/lib/quota/quotaio.c
@@ -14,7 +14,6 @@
 #include <sys/types.h>
 #include <sys/stat.h>
 #include <sys/file.h>
-#include <asm/byteorder.h>
 
 #include "common.h"
 #include "quotaio.h"
diff --git a/lib/quota/quotaio_tree.c b/lib/quota/quotaio_tree.c
index 7aeac62..1daea75 100644
--- a/lib/quota/quotaio_tree.c
+++ b/lib/quota/quotaio_tree.c
@@ -11,7 +11,6 @@
 #include <stdlib.h>
 #include <string.h>
 #include <unistd.h>
-#include <asm/byteorder.h>
 
 #include "common.h"
 #include "quotaio_tree.h"
@@ -83,7 +82,7 @@ static int get_free_dqblk(struct quota_handle *h)
 	if (info->dqi_free_blk) {
 		blk = info->dqi_free_blk;
 		read_blk(h, blk, buf);
-		info->dqi_free_blk = __le32_to_cpu(dh->dqdh_next_free);
+		info->dqi_free_blk = ext2fs_le32_to_cpu(dh->dqdh_next_free);
 	} else {
 		memset(buf, 0, QT_BLKSIZE);
 		/* Assure block allocation... */
@@ -106,9 +105,9 @@ static void put_free_dqblk(struct quota_handle *h, dqbuf_t buf, uint blk)
 	struct qt_disk_dqdbheader *dh = (struct qt_disk_dqdbheader *)buf;
 	struct qtree_mem_dqinfo *info = &h->qh_info.u.v2_mdqi.dqi_qtree;
 
-	dh->dqdh_next_free = __cpu_to_le32(info->dqi_free_blk);
-	dh->dqdh_prev_free = __cpu_to_le32(0);
-	dh->dqdh_entries = __cpu_to_le16(0);
+	dh->dqdh_next_free = ext2fs_cpu_to_le32(info->dqi_free_blk);
+	dh->dqdh_prev_free = ext2fs_cpu_to_le32(0);
+	dh->dqdh_entries = ext2fs_cpu_to_le16(0);
 	info->dqi_free_blk = blk;
 	mark_quotafile_info_dirty(h);
 	write_blk(h, blk, buf);
@@ -119,9 +118,9 @@ static void remove_free_dqentry(struct quota_handle *h, dqbuf_t buf, uint blk)
 {
 	dqbuf_t tmpbuf = getdqbuf();
 	struct qt_disk_dqdbheader *dh = (struct qt_disk_dqdbheader *)buf;
-	uint nextblk = __le32_to_cpu(dh->dqdh_next_free), prevblk =
+	uint nextblk = ext2fs_le32_to_cpu(dh->dqdh_next_free), prevblk =
 
-		__le32_to_cpu(dh->dqdh_prev_free);
+		ext2fs_le32_to_cpu(dh->dqdh_prev_free);
 
 	if (nextblk) {
 		read_blk(h, nextblk, tmpbuf);
@@ -139,7 +138,7 @@ static void remove_free_dqentry(struct quota_handle *h, dqbuf_t buf, uint blk)
 		mark_quotafile_info_dirty(h);
 	}
 	freedqbuf(tmpbuf);
-	dh->dqdh_next_free = dh->dqdh_prev_free = __cpu_to_le32(0);
+	dh->dqdh_next_free = dh->dqdh_prev_free = ext2fs_cpu_to_le32(0);
 	write_blk(h, blk, buf);	/* No matter whether write succeeds
 				 * block is out of list */
 }
@@ -151,13 +150,13 @@ static void insert_free_dqentry(struct quota_handle *h, dqbuf_t buf, uint blk)
 	struct qt_disk_dqdbheader *dh = (struct qt_disk_dqdbheader *)buf;
 	struct qtree_mem_dqinfo *info = &h->qh_info.u.v2_mdqi.dqi_qtree;
 
-	dh->dqdh_next_free = __cpu_to_le32(info->dqi_free_entry);
-	dh->dqdh_prev_free = __cpu_to_le32(0);
+	dh->dqdh_next_free = ext2fs_cpu_to_le32(info->dqi_free_entry);
+	dh->dqdh_prev_free = ext2fs_cpu_to_le32(0);
 	write_blk(h, blk, buf);
 	if (info->dqi_free_entry) {
 		read_blk(h, info->dqi_free_entry, tmpbuf);
 		((struct qt_disk_dqdbheader *)tmpbuf)->dqdh_prev_free =
-				__cpu_to_le32(blk);
+				ext2fs_cpu_to_le32(blk);
 		write_blk(h, info->dqi_free_entry, tmpbuf);
 	}
 	freedqbuf(tmpbuf);
@@ -194,10 +193,12 @@ static uint find_free_dqentry(struct quota_handle *h, struct dquot *dquot,
 	}
 
 	/* Block will be full? */
-	if (__le16_to_cpu(dh->dqdh_entries) + 1 >= qtree_dqstr_in_blk(info))
+	if (ext2fs_le16_to_cpu(dh->dqdh_entries) + 1 >=
+	    qtree_dqstr_in_blk(info))
 		remove_free_dqentry(h, buf, blk);
 
-	dh->dqdh_entries = __cpu_to_le16(__le16_to_cpu(dh->dqdh_entries) + 1);
+	dh->dqdh_entries =
+		ext2fs_cpu_to_le16(ext2fs_le16_to_cpu(dh->dqdh_entries) + 1);
 	/* Find free structure in block */
 	ddquot = buf + sizeof(struct qt_disk_dqdbheader);
 	for (i = 0;
@@ -241,7 +242,7 @@ static int do_insert_tree(struct quota_handle *h, struct dquot *dquot,
 	}
 
 	ref = (u_int32_t *) buf;
-	newblk = __le32_to_cpu(ref[get_index(dquot->dq_id, depth)]);
+	newblk = ext2fs_le32_to_cpu(ref[get_index(dquot->dq_id, depth)]);
 	if (!newblk)
 		newson = 1;
 	if (depth == QT_TREEDEPTH - 1) {
@@ -255,7 +256,8 @@ static int do_insert_tree(struct quota_handle *h, struct dquot *dquot,
 	}
 
 	if (newson && ret >= 0) {
-		ref[get_index(dquot->dq_id, depth)] = __cpu_to_le32(newblk);
+		ref[get_index(dquot->dq_id, depth)] =
+			ext2fs_cpu_to_le32(newblk);
 		write_blk(h, *treeblk, buf);
 	} else if (newact && ret < 0) {
 		put_free_dqblk(h, buf, *treeblk);
@@ -320,9 +322,10 @@ static void free_dqentry(struct quota_handle *h, struct dquot *dquot, uint blk)
 
 	read_blk(h, blk, buf);
 	dh = (struct qt_disk_dqdbheader *)buf;
-	dh->dqdh_entries = __cpu_to_le16(__le16_to_cpu(dh->dqdh_entries) - 1);
+	dh->dqdh_entries =
+		ext2fs_cpu_to_le16(ext2fs_le16_to_cpu(dh->dqdh_entries) - 1);
 
-	if (!__le16_to_cpu(dh->dqdh_entries)) {	/* Block got free? */
+	if (!ext2fs_le16_to_cpu(dh->dqdh_entries)) {	/* Block got free? */
 		remove_free_dqentry(h, buf, blk);
 		put_free_dqblk(h, buf, blk);
 	} else {
@@ -331,7 +334,7 @@ static void free_dqentry(struct quota_handle *h, struct dquot *dquot, uint blk)
 		       0, info->dqi_entry_size);
 
 		/* First free entry? */
-		if (__le16_to_cpu(dh->dqdh_entries) ==
+		if (ext2fs_le16_to_cpu(dh->dqdh_entries) ==
 				qtree_dqstr_in_blk(info) - 1)
 			/* This will also write data block */
 			insert_free_dqentry(h, buf, blk);
@@ -351,7 +354,7 @@ static void remove_tree(struct quota_handle *h, struct dquot *dquot,
 	u_int32_t *ref = (u_int32_t *) buf;
 
 	read_blk(h, *blk, buf);
-	newblk = __le32_to_cpu(ref[get_index(dquot->dq_id, depth)]);
+	newblk = ext2fs_le32_to_cpu(ref[get_index(dquot->dq_id, depth)]);
 	if (depth == QT_TREEDEPTH - 1) {
 		free_dqentry(h, dquot, newblk);
 		newblk = 0;
@@ -362,7 +365,7 @@ static void remove_tree(struct quota_handle *h, struct dquot *dquot,
 	if (!newblk) {
 		int i;
 
-		ref[get_index(dquot->dq_id, depth)] = __cpu_to_le32(0);
+		ref[get_index(dquot->dq_id, depth)] = ext2fs_cpu_to_le32(0);
 
 		/* Block got empty? */
 		for (i = 0; i < QT_BLKSIZE && !buf[i]; i++);
@@ -421,7 +424,7 @@ static loff_t find_tree_dqentry(struct quota_handle *h, struct dquot *dquot,
 
 	read_blk(h, blk, buf);
 	ret = 0;
-	blk = __le32_to_cpu(ref[get_index(dquot->dq_id, depth)]);
+	blk = ext2fs_le32_to_cpu(ref[get_index(dquot->dq_id, depth)]);
 	if (!blk)	/* No reference? */
 		goto out_buf;
 	if (depth < QT_TREEDEPTH - 1)
@@ -493,7 +496,7 @@ static int report_block(struct dquot *dquot, uint blk, char *bitmap,
 	read_blk(dquot->dq_h, blk, buf);
 	dh = (struct qt_disk_dqdbheader *)buf;
 	ddata = buf + sizeof(struct qt_disk_dqdbheader);
-	entries = __le16_to_cpu(dh->dqdh_entries);
+	entries = ext2fs_le16_to_cpu(dh->dqdh_entries);
 	for (i = 0; i < qtree_dqstr_in_blk(info);
 			i++, ddata += info->dqi_entry_size)
 		if (!qtree_entry_unused(info, ddata)) {
@@ -526,7 +529,7 @@ static int report_tree(struct dquot *dquot, uint blk, int depth, char *bitmap,
 	read_blk(dquot->dq_h, blk, buf);
 	if (depth == QT_TREEDEPTH - 1) {
 		for (i = 0; i < QT_BLKSIZE >> 2; i++) {
-			blk = __le32_to_cpu(ref[i]);
+			blk = ext2fs_le32_to_cpu(ref[i]);
 			check_reference(dquot->dq_h, blk);
 			if (blk && !get_bit(bitmap, blk))
 				entries += report_block(dquot, blk, bitmap,
@@ -534,7 +537,7 @@ static int report_tree(struct dquot *dquot, uint blk, int depth, char *bitmap,
 		}
 	} else {
 		for (i = 0; i < QT_BLKSIZE >> 2; i++)
-			blk = __le32_to_cpu(ref[i]);
+			blk = ext2fs_le32_to_cpu(ref[i]);
 			if (blk) {
 				check_reference(dquot->dq_h, blk);
 				entries += report_tree(dquot, blk, depth + 1,
diff --git a/lib/quota/quotaio_v2.c b/lib/quota/quotaio_v2.c
index 3259816..660d463 100644
--- a/lib/quota/quotaio_v2.c
+++ b/lib/quota/quotaio_v2.c
@@ -11,7 +11,6 @@
 #include <stdlib.h>
 #include <string.h>
 #include <unistd.h>
-#include <asm/byteorder.h>
 
 #include "common.h"
 #include "quotaio_v2.h"
@@ -54,18 +53,18 @@ static void v2r1_disk2memdqblk(struct dquot *dquot, void *dp)
 	struct util_dqblk *m = &dquot->dq_dqb;
 	struct v2r1_disk_dqblk *d = dp, empty;
 
-	dquot->dq_id = __le32_to_cpu(d->dqb_id);
-	m->dqb_ihardlimit = __le64_to_cpu(d->dqb_ihardlimit);
-	m->dqb_isoftlimit = __le64_to_cpu(d->dqb_isoftlimit);
-	m->dqb_bhardlimit = __le64_to_cpu(d->dqb_bhardlimit);
-	m->dqb_bsoftlimit = __le64_to_cpu(d->dqb_bsoftlimit);
-	m->dqb_curinodes = __le64_to_cpu(d->dqb_curinodes);
-	m->dqb_curspace = __le64_to_cpu(d->dqb_curspace);
-	m->dqb_itime = __le64_to_cpu(d->dqb_itime);
-	m->dqb_btime = __le64_to_cpu(d->dqb_btime);
+	dquot->dq_id = ext2fs_le32_to_cpu(d->dqb_id);
+	m->dqb_ihardlimit = ext2fs_le64_to_cpu(d->dqb_ihardlimit);
+	m->dqb_isoftlimit = ext2fs_le64_to_cpu(d->dqb_isoftlimit);
+	m->dqb_bhardlimit = ext2fs_le64_to_cpu(d->dqb_bhardlimit);
+	m->dqb_bsoftlimit = ext2fs_le64_to_cpu(d->dqb_bsoftlimit);
+	m->dqb_curinodes = ext2fs_le64_to_cpu(d->dqb_curinodes);
+	m->dqb_curspace = ext2fs_le64_to_cpu(d->dqb_curspace);
+	m->dqb_itime = ext2fs_le64_to_cpu(d->dqb_itime);
+	m->dqb_btime = ext2fs_le64_to_cpu(d->dqb_btime);
 
 	memset(&empty, 0, sizeof(struct v2r1_disk_dqblk));
-	empty.dqb_itime = __cpu_to_le64(1);
+	empty.dqb_itime = ext2fs_cpu_to_le64(1);
 	if (!memcmp(&empty, dp, sizeof(struct v2r1_disk_dqblk)))
 		m->dqb_itime = 0;
 }
@@ -78,17 +77,17 @@ static void v2r1_mem2diskdqblk(void *dp, struct dquot *dquot)
 	struct util_dqblk *m = &dquot->dq_dqb;
 	struct v2r1_disk_dqblk *d = dp;
 
-	d->dqb_ihardlimit = __cpu_to_le64(m->dqb_ihardlimit);
-	d->dqb_isoftlimit = __cpu_to_le64(m->dqb_isoftlimit);
-	d->dqb_bhardlimit = __cpu_to_le64(m->dqb_bhardlimit);
-	d->dqb_bsoftlimit = __cpu_to_le64(m->dqb_bsoftlimit);
-	d->dqb_curinodes = __cpu_to_le64(m->dqb_curinodes);
-	d->dqb_curspace = __cpu_to_le64(m->dqb_curspace);
-	d->dqb_itime = __cpu_to_le64(m->dqb_itime);
-	d->dqb_btime = __cpu_to_le64(m->dqb_btime);
-	d->dqb_id = __cpu_to_le32(dquot->dq_id);
+	d->dqb_ihardlimit = ext2fs_cpu_to_le64(m->dqb_ihardlimit);
+	d->dqb_isoftlimit = ext2fs_cpu_to_le64(m->dqb_isoftlimit);
+	d->dqb_bhardlimit = ext2fs_cpu_to_le64(m->dqb_bhardlimit);
+	d->dqb_bsoftlimit = ext2fs_cpu_to_le64(m->dqb_bsoftlimit);
+	d->dqb_curinodes = ext2fs_cpu_to_le64(m->dqb_curinodes);
+	d->dqb_curspace = ext2fs_cpu_to_le64(m->dqb_curspace);
+	d->dqb_itime = ext2fs_cpu_to_le64(m->dqb_itime);
+	d->dqb_btime = ext2fs_cpu_to_le64(m->dqb_btime);
+	d->dqb_id = ext2fs_cpu_to_le32(dquot->dq_id);
 	if (qtree_entry_unused(&dquot->dq_h->qh_info.u.v2_mdqi.dqi_qtree, dp))
-		d->dqb_itime = __cpu_to_le64(1);
+		d->dqb_itime = ext2fs_cpu_to_le64(1);
 }
 
 static int v2r1_is_id(void *dp, struct dquot *dquot)
@@ -99,7 +98,7 @@ static int v2r1_is_id(void *dp, struct dquot *dquot)
 
 	if (qtree_entry_unused(info, dp))
 		return 0;
-	return __le32_to_cpu(d->dqb_id) == dquot->dq_id;
+	return ext2fs_le32_to_cpu(d->dqb_id) == dquot->dq_id;
 }
 
 static struct qtree_fmt_operations v2r1_fmt_ops = {
@@ -114,13 +113,14 @@ static struct qtree_fmt_operations v2r1_fmt_ops = {
 static inline void v2_disk2memdqinfo(struct util_dqinfo *m,
 				     struct v2_disk_dqinfo *d)
 {
-	m->dqi_bgrace = __le32_to_cpu(d->dqi_bgrace);
-	m->dqi_igrace = __le32_to_cpu(d->dqi_igrace);
-	m->u.v2_mdqi.dqi_flags = __le32_to_cpu(d->dqi_flags) & V2_DQF_MASK;
-	m->u.v2_mdqi.dqi_qtree.dqi_blocks = __le32_to_cpu(d->dqi_blocks);
-	m->u.v2_mdqi.dqi_qtree.dqi_free_blk = __le32_to_cpu(d->dqi_free_blk);
+	m->dqi_bgrace = ext2fs_le32_to_cpu(d->dqi_bgrace);
+	m->dqi_igrace = ext2fs_le32_to_cpu(d->dqi_igrace);
+	m->u.v2_mdqi.dqi_flags = ext2fs_le32_to_cpu(d->dqi_flags) & V2_DQF_MASK;
+	m->u.v2_mdqi.dqi_qtree.dqi_blocks = ext2fs_le32_to_cpu(d->dqi_blocks);
+	m->u.v2_mdqi.dqi_qtree.dqi_free_blk =
+		ext2fs_le32_to_cpu(d->dqi_free_blk);
 	m->u.v2_mdqi.dqi_qtree.dqi_free_entry =
-				__le32_to_cpu(d->dqi_free_entry);
+				ext2fs_le32_to_cpu(d->dqi_free_entry);
 }
 
 /*
@@ -129,13 +129,14 @@ static inline void v2_disk2memdqinfo(struct util_dqinfo *m,
 static inline void v2_mem2diskdqinfo(struct v2_disk_dqinfo *d,
 				     struct util_dqinfo *m)
 {
-	d->dqi_bgrace = __cpu_to_le32(m->dqi_bgrace);
-	d->dqi_igrace = __cpu_to_le32(m->dqi_igrace);
-	d->dqi_flags = __cpu_to_le32(m->u.v2_mdqi.dqi_flags & V2_DQF_MASK);
-	d->dqi_blocks = __cpu_to_le32(m->u.v2_mdqi.dqi_qtree.dqi_blocks);
-	d->dqi_free_blk = __cpu_to_le32(m->u.v2_mdqi.dqi_qtree.dqi_free_blk);
+	d->dqi_bgrace = ext2fs_cpu_to_le32(m->dqi_bgrace);
+	d->dqi_igrace = ext2fs_cpu_to_le32(m->dqi_igrace);
+	d->dqi_flags = ext2fs_cpu_to_le32(m->u.v2_mdqi.dqi_flags & V2_DQF_MASK);
+	d->dqi_blocks = ext2fs_cpu_to_le32(m->u.v2_mdqi.dqi_qtree.dqi_blocks);
+	d->dqi_free_blk =
+		ext2fs_cpu_to_le32(m->u.v2_mdqi.dqi_qtree.dqi_free_blk);
 	d->dqi_free_entry =
-			__cpu_to_le32(m->u.v2_mdqi.dqi_qtree.dqi_free_entry);
+		ext2fs_cpu_to_le32(m->u.v2_mdqi.dqi_qtree.dqi_free_entry);
 }
 
 /* Convert kernel quotablock format to utility one */
@@ -194,15 +195,15 @@ static int v2_check_file(struct quota_handle *h, int type, int fmt)
 	else
 		return 0;
 
-	if (__le32_to_cpu(dqh.dqh_magic) != file_magics[type]) {
-		if (__be32_to_cpu(dqh.dqh_magic) == file_magics[type])
+	if (ext2fs_le32_to_cpu(dqh.dqh_magic) != file_magics[type]) {
+		if (ext2fs_be32_to_cpu(dqh.dqh_magic) == file_magics[type])
 			log_fatal(3, "Your quota file is stored in wrong "
 				  "endianity.", "");
 		return 0;
 	}
-	if (__le32_to_cpu(dqh.dqh_version) > known_versions[type])
+	if (ext2fs_le32_to_cpu(dqh.dqh_version) > known_versions[type])
 		return 0;
-	if (version != __le32_to_cpu(dqh.dqh_version))
+	if (version != ext2fs_le32_to_cpu(dqh.dqh_version))
 		return 0;
 	return 1;
 }
@@ -230,8 +231,8 @@ static int v2_new_io(struct quota_handle *h)
 	BUG_ON(h->qh_fmt != QFMT_VFS_V1);
 
 	/* Write basic quota header */
-	ddqheader.dqh_magic = __cpu_to_le32(file_magics[h->qh_type]);
-	ddqheader.dqh_version = __cpu_to_le32(version);
+	ddqheader.dqh_magic = ext2fs_cpu_to_le32(file_magics[h->qh_type]);
+	ddqheader.dqh_version = ext2fs_cpu_to_le32(version);
 	if (h->e2fs_write(&h->qh_qf, 0, &ddqheader, sizeof(ddqheader)) !=
 			sizeof(ddqheader))
 		return -1;
-- 
1.7.4.1.22.gec8e1.dirty

