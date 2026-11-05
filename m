Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=162.62.58.211
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793844716;
	b=z7pnqXBoqU43G+DQaMJG50G1zn90hS9S6VsVGRHnKEzqAbXGleWWwpjD3xdnM6DzYkp8
	 7I9fXGBWjft2e2J+7TkyYjLD/x1mKMBmbdl6TOJjdmR/u+fTeRvQ8n54HLGZfK1ArivxE
	 mROOc1n/73rpM2pAoZ0swGZqrlQFVKcJo0csiv+tEQLEsOl6dUCBfSUr9vYB3op7dNFSr
	 EDolOvEvU8qU44BPZER1HaIK8iMRX2mBF785Ey1MFFWhooyd+GqeMEbkHZch7tRYW8t24
	 I87sgaiU8WoWNMKB0VkAqrC38rIe8rPrqSu07a5quY3325lJE8Bh97wX7WaEBiFVLOA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793844716;
	h=DMARC-Filter:DKIM-Signature:Received:X-QQ-mid:Message-ID:
	 X-QQ-XMAILINFO:X-QQ-XMRINFO:From:To:Cc:Subject:Date:X-OQ-MSGID:
	 X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=qyG1gsYQ3BoyLlEsOpf8qDvLw6xue201jPWCtX5Rs0g=;
	b=Rqejk41scYorjEjwcZIbcXYC7K/yjcrC/GoZNUuM2yMB8gNeU29QhiprQmGAYAnJfRVr
	 wEe5rJx+z00rLYYqCyKISru8HnrdWQTJrBjWQkpd2/fx2uJjSxuGRiIoupSedK2LaSj/I
	 byvBvDW+b/K7py3+iuY4zkR5WqqeM34LusVEwIDsEBwPVZYyKC3VmFfAObvOX3zBpyxuN
	 O9ojyxlr7WdtQ92mj5y9pAE968Umimhr9Fk8BjLg+kmE05H/PCM+t8AidWo7xtWH1y2Ko
	 DwrBoYD/2u0kS7YTg3wN0GvZdYcVRsjplWK3qoOfLIQnuDcQJ2vI4E1eMQj16/OIXMw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=qq.com;
	spf=pass smtp.mailfrom=qq.com;
	dkim=pass header.d=qq.com header.i=@qq.com header.a=rsa-sha256 header.s=s201512 header.b=FYgcBFeq;
	arc=none smtp.remote-ip=162.62.58.211
Received: from out162-62-58-211.mail.qq.com (out162-62-58-211.mail.qq.com [162.62.58.211])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED384606A326;
	Thu,  5 Nov 2026 02:11:53 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org ED384606A326
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=qq.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=qq.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=qq.com header.i=@qq.com header.a=rsa-sha256 header.s=s201512 header.b=FYgcBFeq
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qq.com; s=s201512;
	t=1793844709; bh=qyG1gsYQ3BoyLlEsOpf8qDvLw6xue201jPWCtX5Rs0g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FYgcBFeqc616ZCpk5YQ9sGcXrA6su83ZWG7JZrjCx7x6ldafH5PTBuqkAQlKrVi+M
	 v6+BJRWdygNZmYNOX7WopP8FtyVG/JRhRaWDFZtMRIVCkidjNLBViucm7Qo9t4l131
	 vy+p7A/9DdZ/rPDs3nt/tpHNJO5n0gr7iCJg1b6c=
Received: from shuai-VMware-Virtual-Platform.. ([218.28.192.28])
	by newxmesmtplogicsvrsza63-0.qq.com (NewEsmtp) with SMTP
	id 2EEAE2FE; Thu, 05 Nov 2026 10:11:46 +0800
X-QQ-mid: xmsmtpt1793844706tdxlufj9z
Message-ID: <tencent_BA3A8C65555EB74908B7404C6562DC5D5705@qq.com>
X-QQ-XMAILINFO: OVFdYp27KdlJOTWDMjKzocYQeCxfvFDkjUJDdDoSrhs0rYcK2r0L+dloyQ1+Qc
	 w6Jo/T9NOOTqWCDwkRDohLWpkPVSYaQt6KrKJiJQQS8x+JbjFmL73EKAvKhypgndcvrEmDYhaaO9
	 DehNywBSsPV8F7RUGvMxy7RPQD+n3yOKvaxe0F1y+6VNXZWxgMzFjh5C6xM+ItiPElCjXkxopKTC
	 xi3+EO65+4n1dsEzXUyOcMHTybwpPL61FxhLIIah6HR5LzoV5uvdIV2JlkQqEtEx1Szp/eB4vJho
	 ky8jX9H/MUkVFfAGRDT6Co8bg4qbJ4YHHrTknchG/a6ndvDE6losHwceASOKLTyYdz1P76rAWr0v
	 8XhJHdVM+9rYmeFSW8U1XHSuVyFd6oIgES1ff896NE9pfrrKR6gi9hHv1xru8JYOoD9ce6iNVIHG
	 ffHuTdYpDKUi0PuMJcRaK6wdv8Fw4keUKp0no3l6q3SaeQOQaYMCFSaHKrV+kTIDb0ACtSb1sI/9
	 ujT+NZPIN3luY75vR8GH1esos5c8cJP5Dzfvsdr9acmxfZcll72o9lq7ryW94l2WVmeQe68NAHCV
	 fCY9R/UAVq1+xD3qyyMscvTPV0uQDmEwoXXDg9TxH8aLPK0+pE0c0SVvX5BMn0ll1yHcxVAhOQrX
	 mYEsQzUSfvkpbbuowOkZ5cy5VhCb+7FbEYDg2XQMSalWw07N5bMxreO1QgZz/ADdTNBZKwPasZKD
	 +f6XhCys+ghxuwGb4V28qAah7Npm3AvNJCtdvZ6GRljrs9+eFcMS4OHbUk5c1h+dxqfw4AMdS4/h
	 fZiuzAO0A8PUVg4ISORHGsu5L9yL1mSOoOGoKZsLHeb2YkAY0IHv4pcICi+fcFLGAFjuOWNFbaVD
	 PxdlxxRr5Zvgd/5kN6mQop/EEaImPaQXTUHcYUGAaB9X6nUSON8YoVs8cKvoq5cYUWT1EymthNtH
	 6BECUyUEnRGXYUOuixoaOh9+VKgIP8FRr6C+Wh7xQ2R3kefaXOTbzWDnEayhgUptpmZWl1M07tgm
	 TESjI1RvNma7iMahbrSsd1B24AE0Sr4Qt5bP6fHxzunXs1cqYa7hzlwKgo3eecnws5kWsC51B4Ea
	 k+NY1RvMKuTH743HuAhtNVXc2wYRuk4mQuCUUMqWQKMJ3JyHVjPKUP0nUp3w==
X-QQ-XMRINFO: MSVp+SPm3vtSI1QTLgDHQqIV1w2oNKDqfg==
From: Shuai Liu <847807867@qq.com>
To: linux-ext4@vger.kernel.org
Cc: tytso@mit.edu,
	adilger.kernel@dilger.ca,
	libaokun@linux.alibaba.com,
	jack@suse.cz,
	ojaswin@linux.ibm.com,
	ritesh.list@gmail.com,
	yi.zhang@huawei.com,
	linux-kernel@vger.kernel.org,
	syzbot+09bec78ee77613a3efdd@syzkaller.appspotmail.com,
	sashiko-bot@kernel.org,
	Shuai Liu <847807867@qq.com>,
	stable@vger.kernel.org
Subject: [PATCH v8] ext4: fix slab-use-after-free in do_split()
Date: Thu,  5 Nov 2026 10:11:46 +0800
X-OQ-MSGID: <20261105021146.1039041-1-847807867@qq.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <sashiko-outbox-198398@kernel.org>
References: <sashiko-outbox-198398@kernel.org>
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

do_split() allocates a new directory block with ext4_append() to hold
the second half of the entries of the leaf block being split, then
dx_move_dirents() copies entries from the old block (*bh) into the new
one (bh2).  Nothing verifies that the newly allocated block differs
from the block being split.

On a filesystem whose block bitmap is inconsistent with the directory
tree, a block already referenced as a directory leaf or as an htree
index block can still be marked free, so ext4_append() can return that
same block.  With concurrent operations on such a filesystem (as
exercised by the syzbot reproducer), the block can even be freed
between allocations, resulting in bh2 aliasing *bh.  dx_move_dirents()
then copies the block onto itself, corrupting directory entries
mid-copy: a rec_len field can be overwritten with name bytes, so the
subsequent wipe of the stale entry memset()s a bogus length, causing
the slab-use-after-free reported by syzbot.

The same aliasing applies to the htree index blocks.  If the leaf
block or a newly allocated block aliases an index frame, the index
header can be overwritten before do_split() runs (add_dirent_to_buf()
inserting into an aliased leaf, make_indexed_dir() moving the dirents
into an aliased new block, the index split in ext4_dx_add_entry()
copying entries into an aliased buffer), letting dx_insert_block()
memmove() out of bounds with a corrupted count and dx_release() loop
past the frames[] array (or leak frames) with a corrupted
indirect_levels.

Fix this by checking for these aliases before any directory block
contents are modified, and bailing out with -EFSCORRUPTED, reporting
the corruption via ext4_error_inode_block():

  - make_indexed_dir(): after ext4_append(), before moving the
    dirents out of the root block
  - ext4_dx_add_entry(): after reading the leaf block and after
    ext4_append() in the index split, before the entries are copied
  - do_split(): for *bh and bh2 against all frames[0..level]

Reported-by: syzbot+09bec78ee77613a3efdd@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=09bec78ee77613a3efdd
Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Cc: stable@vger.kernel.org
Signed-off-by: Shuai Liu <847807867@qq.com>
Changes in v8:
  - Add an index-to-index alias check in dx_probe(). The existing tree cycle
    check compares only logical block numbers, so on a corrupted filesystem
    where two distinct logical index blocks map to the same physical block,
    frames[] can be populated with identical buffer_heads (the same physical
    block can pass the limit, count and checksum checks at both levels since
    dx_root and dx_node entries live at different offsets). Writing a child
    frame's dx_node entries in place then overwrites the root dx_root_info
    (including indirect_levels) and the root dx_countlimit, and dx_release()
    reading the corrupted indirect_levels can walk past the end of the
    frames[] array and brelse() stack garbage. Check each newly read index
    block against all ancestor frames' buffer_heads, which also removes a
    double brelse() of an aliased buffer_head on the dx_probe() failure
    path. (Sashiko)

---
 fs/ext4/namei.c | 79 ++++++++++++++++++++++++++++++++++++++++++++++---
 1 file changed, 75 insertions(+), 4 deletions(-)

diff --git a/fs/ext4/namei.c b/fs/ext4/namei.c
index 354fc2d22df1..fb1ea835cd20 100644
--- a/fs/ext4/namei.c
+++ b/fs/ext4/namei.c
@@ -914,6 +914,17 @@ dx_probe(struct ext4_filename *fname, struct inode *dir,
 			goto fail;
 		}
 
+		for (i = 0; i < level; i++) {
+			if (frame_in[i].bh == frame->bh) {
+				ext4_warning_inode(dir,
+					"dx entry: index block %u aliases ancestor index block",
+					block);
+				brelse(frame->bh);
+				frame->bh = NULL;
+				goto fail;
+			}
+		}
+
 		entries = ((struct dx_node *) frame->bh->b_data)->entries;
 
 		if (dx_get_limit(entries) != dx_node_limit(dir)) {
@@ -1903,13 +1914,14 @@ static struct ext4_dir_entry_2 *dx_pack_dirents(struct inode *dir, char *base,
  * Returns pointer to de in block into which the new entry will be inserted.
  */
 static struct ext4_dir_entry_2 *do_split(handle_t *handle, struct inode *dir,
-			struct buffer_head **bh,struct dx_frame *frame,
-			struct dx_hash_info *hinfo)
+			struct buffer_head **bh, struct dx_frame *frames,
+			struct dx_frame *frame, struct dx_hash_info *hinfo)
 {
 	unsigned blocksize = dir->i_sb->s_blocksize;
 	unsigned continued;
 	int count;
 	struct buffer_head *bh2;
+	struct dx_frame *f;
 	ext4_lblk_t newblock;
 	u32 hash2;
 	struct dx_map_entry *map;
@@ -1922,12 +1934,42 @@ static struct ext4_dir_entry_2 *do_split(handle_t *handle, struct inode *dir,
 	if (ext4_has_feature_metadata_csum(dir->i_sb))
 		csum_size = sizeof(struct ext4_dir_entry_tail);
 
+	for (f = frames; f <= frame; f++) {
+		if (*bh == f->bh) {
+			ext4_error_inode_block(dir, (*bh)->b_blocknr,
+					       EFSCORRUPTED,
+					       "leaf block aliased with index block");
+			brelse(*bh);
+			*bh = NULL;
+			return ERR_PTR(-EFSCORRUPTED);
+		}
+	}
+
 	bh2 = ext4_append(handle, dir, &newblock);
 	if (IS_ERR(bh2)) {
 		brelse(*bh);
 		*bh = NULL;
 		return ERR_CAST(bh2);
 	}
+	if (bh2 == *bh) {
+		ext4_error_inode_block(dir, (*bh)->b_blocknr, EFSCORRUPTED,
+				       "cannot split aliased directory block");
+		brelse(bh2);
+		brelse(*bh);
+		*bh = NULL;
+		return ERR_PTR(-EFSCORRUPTED);
+	}
+	for (f = frames; f <= frame; f++) {
+		if (bh2 == f->bh) {
+			ext4_error_inode_block(dir, bh2->b_blocknr,
+					       EFSCORRUPTED,
+					       "leaf block aliased with index block");
+			brelse(bh2);
+			brelse(*bh);
+			*bh = NULL;
+			return ERR_PTR(-EFSCORRUPTED);
+		}
+	}
 
 	BUFFER_TRACE(*bh, "get_write_access");
 	err = ext4_journal_get_write_access(handle, dir->i_sb, *bh,
@@ -2257,6 +2299,13 @@ static int make_indexed_dir(handle_t *handle, struct ext4_filename *fname,
 		brelse(bh);
 		return PTR_ERR(bh2);
 	}
+	if (bh2 == bh) {
+		ext4_error_inode_block(dir, bh->b_blocknr, EFSCORRUPTED,
+				       "cannot index aliased directory block");
+		brelse(bh2);
+		brelse(bh);
+		return -EFSCORRUPTED;
+	}
 	ext4_set_inode_flag(dir, EXT4_INODE_INDEX);
 	data2 = bh2->b_data;
 
@@ -2325,7 +2374,7 @@ static int make_indexed_dir(handle_t *handle, struct ext4_filename *fname,
 	if (retval)
 		goto out_frames;
 
-	de = do_split(handle,dir, &bh2, frame, &fname->hinfo);
+	de = do_split(handle, dir, &bh2, frames, frame, &fname->hinfo);
 	if (IS_ERR(de)) {
 		retval = PTR_ERR(de);
 		goto out_frames;
@@ -2476,6 +2525,7 @@ static int ext4_dx_add_entry(handle_t *handle, struct ext4_filename *fname,
 			     struct inode *dir, struct inode *inode)
 {
 	struct dx_frame frames[EXT4_HTREE_LEVEL], *frame;
+	struct dx_frame *f;
 	struct dx_entry *entries, *at;
 	struct buffer_head *bh;
 	struct super_block *sb = dir->i_sb;
@@ -2496,6 +2546,15 @@ static int ext4_dx_add_entry(handle_t *handle, struct ext4_filename *fname,
 		bh = NULL;
 		goto cleanup;
 	}
+	for (f = frames; f <= frame; f++) {
+		if (bh == f->bh) {
+			ext4_error_inode_block(dir, bh->b_blocknr,
+					       EFSCORRUPTED,
+					       "leaf block aliased with index block");
+			err = -EFSCORRUPTED;
+			goto cleanup;
+		}
+	}
 
 	BUFFER_TRACE(bh, "get_write_access");
 	err = ext4_journal_get_write_access(handle, sb, bh, EXT4_JTR_NONE);
@@ -2549,6 +2608,18 @@ static int ext4_dx_add_entry(handle_t *handle, struct ext4_filename *fname,
 			err = PTR_ERR(bh2);
 			goto cleanup;
 		}
+		for (f = frames; f < frames + levels; f++) {
+			if (bh2 == f->bh)
+				break;
+		}
+		if (f < frames + levels || bh2 == bh) {
+			ext4_error_inode_block(dir, bh2->b_blocknr,
+					       EFSCORRUPTED,
+					       "cannot split aliased index block");
+			brelse(bh2);
+			err = -EFSCORRUPTED;
+			goto cleanup;
+		}
 		node2 = (struct dx_node *)(bh2->b_data);
 		entries2 = node2->entries;
 		memset(&node2->fake, 0, sizeof(struct fake_dirent));
@@ -2631,7 +2702,7 @@ static int ext4_dx_add_entry(handle_t *handle, struct ext4_filename *fname,
 			goto journal_error;
 		}
 	}
-	de = do_split(handle, dir, &bh, frame, &fname->hinfo);
+	de = do_split(handle, dir, &bh, frames, frame, &fname->hinfo);
 	if (IS_ERR(de)) {
 		err = PTR_ERR(de);
 		goto cleanup;
-- 
2.43.0

