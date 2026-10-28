Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793148171;
	b=UDtPwU8NthbACTzjzHIXex1PtoVqJrTQwSPkebjzUrybM7VaIiuugTdY6p1N6YoFEmLS
	 C2n/LVMNlBX/QjQ5L6cl2SMMFA1xNPDyyjiE81rBl58qD1Q+obZOMqUwQ2Wk1wVw9zJ86
	 gl4bimD0dpeEZSAUgGnhuXRPTQIxbeVIIxZRL5JUdwqrJmvswXpJ86SUkTdF9sqOqnZFy
	 4QovnET6dKWwN0yT2RSdZEBNw7+nZHRbXD48RMgvnCok4PrEbbjx74dvwUhovggN82KNv
	 ra9s2wdnGGmRDE7WY5nnUmsX39U+f//SkM4ztiV++5Ah+z8KSVuq1aMF10jHxofo4/Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793148171;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 MIME-Version:Content-Transfer-Encoding;
	bh=7ra5EUja+O5y/IsXXX4ZxR+ZhvfGdXSGA1iSsADUCFI=;
	b=24Hk9AjhK6VQacwiHsWPN/wN4SOKLljoIdoKOHF2osBTn7IGdDwAv6y5AYD23TDpXvEM
	 4FzPDrw9jnUEsUtfoZamrVvKE421MEE8DrFPkmN6jI1Zgh+cKwN9o6D+vMBTu2T3xYEvz
	 BxjRInBgvrPKfg/CvVlRQfqOIYyvUAdGaoX6X/d+bglJUCvw7Ej6Q1VnumNohR2jfc4j2
	 nA9YWKnF27GqAyjOYz6u7DOfFdNvxFB4HQrN/KAGDBFQjFOaZn+BFAxgfIPbBCNiVIrPi
	 MbYJESZ/3vQFmBArZm9KItQpZfdBa1gqWKwpF5WnzNSwNFGOJxbnL6gP9mdZx5uyMiA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=d+AytK0O;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43EB9606A31A;
	Wed, 28 Oct 2026 00:42:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=d+AytK0O
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9FB5C1F01829;
	Wed, 28 Oct 2026 00:42:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793148170;
	bh=7ra5EUja+O5y/IsXXX4ZxR+ZhvfGdXSGA1iSsADUCFI=;
	h=From:To:Cc:Subject:Date;
	b=d+AytK0OzfY39sh5oGoKFE2gWnd8q2yfviI8Q3UNnvKepLrkqPEE8BfT6NYTbjv78
	 gZh4jFHuGM1dKP75jjISGW7HklFFAulg85HiximmTBxI1VzHS1hPHMq+CbwhIfOpw1
	 kGDv4IZK0iDSdvxw5/p4hqOSspDbzQHgmjz87aMxz8OHgLVHYbeKt6dRvzOdPt8/T/
	 PqyZQP0lKnYyGyR5J6ltsHYphoqgSD/rah9zptf07NmtaxBqNlGTSzekhsgrnNF8NB
	 2A2bOF9E996UzOWcJG2Vy/gqHDeCLGH9jjY2OnpUwqnjTkRfACbRW5gnHwkGy3aCz1
	 UI7BrZV46BUxg==
From: Eric Biggers <ebiggers@kernel.org>
To: stable@vger.kernel.org
Cc: linux-ext4@vger.kernel.org,
	Yao Kai <yaokai34@huawei.com>,
	syzbot+5322c5c260eb44d209ed@syzkaller.appspotmail.com,
	Zhihao Cheng <chengzhihao1@huawei.com>,
	Jan Kara <jack@suse.cz>,
	Zhang Yi <yi.zhang@huawei.com>,
	Theodore Ts'o <tytso@mit.edu>,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH 6.6] ext4: validate readdir offset before accessing dirent
Date: Tue, 27 Oct 2026 17:42:09 -0700
Message-ID: <20261028004209.58412-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.56.0
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

From: Yao Kai <yaokai34@huawei.com>

commit bc4b7b0414c33b2c8898eb04386df0d21a13dad8 upstream.

A corrupted directory can trigger the following KASAN report when
ext4_readdir() resumes from an invalid position:

  BUG: KASAN: use-after-free in __ext4_check_dir_entry+0x5ef/0x820
  Read of size 2 at addr ffff88810a646000 by task repro_linear/509

  Call Trace:
   <TASK>
   dump_stack_lvl+0x53/0x70
   print_report+0xd0/0x630
   kasan_report+0xce/0x100
   __ext4_check_dir_entry+0x5ef/0x820
   ext4_readdir+0xcde/0x2b70
   iterate_dir+0x1a1/0x520
   __x64_sys_getdents64+0x12b/0x220
   do_syscall_64+0xf9/0x540
   entry_SYSCALL_64_after_hwframe+0x77/0x7f
   </TASK>

KASAN reports use-after-free because the out-of-bounds access lands in an
adjacent freed page. The directory buffer itself is still referenced.

ext4_dir_llseek() invalidates the directory cookie so that ext4_readdir()
rescans directory entries from the start of the block. The rescan checks
only the lower bound of rec_len before advancing. A corrupted rec_len can
therefore place the offset where the block has insufficient space for a
complete directory entry. The rescan itself may dereference that truncated
entry, or the main loop may pass it to __ext4_check_dir_entry(). The latter
reads de->rec_len before validating the range. For example:

  block offset  0                           4092  4096
                |---- de1.rec_len = 4092 -----|----|
                                               de2.inode
                                                    | de2.rec_len
                                                    ^ OOB, reported as UAF

de2 starts at offset 4092 in this 4 KiB block. Its four-byte inode fits in
the block, but its rec_len starts at offset 4096 and crosses the boundary.

The minimum safe length is inode-dependent. Encrypted and casefolded
directory entries need eight additional hash bytes, while a valid metadata
checksum tail is only 12 bytes.

Cache the metadata checksum feature state and derive the minimum directory
entry length from the on-disk format. Use it to bound both the rescan and
the offset passed to the main loop. Report an offset in a truncated block
tail and skip the remainder of the block, while continuing to accept an
offset exactly at the block boundary.

Reported-by: syzbot+5322c5c260eb44d209ed@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=5322c5c260eb44d209ed
Fixes: ac27a0ec112a ("[PATCH] ext4: initial copy of files from ext3")
Signed-off-by: Yao Kai <yaokai34@huawei.com>
Reviewed-by: Zhihao Cheng <chengzhihao1@huawei.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Reviewed-by: Zhang Yi <yi.zhang@huawei.com>
Link: https://patch.msgid.link/20260706041313.708346-1-yaokai34@huawei.com
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Eric Biggers <ebiggers@kernel.org>
---
 fs/ext4/dir.c | 20 ++++++++++++++++++--
 1 file changed, 18 insertions(+), 2 deletions(-)

diff --git a/fs/ext4/dir.c b/fs/ext4/dir.c
index 6682b8ab11f1c..bc53ea82161d3 100644
--- a/fs/ext4/dir.c
+++ b/fs/ext4/dir.c
@@ -136,6 +136,7 @@ static int ext4_readdir(struct file *file, struct dir_context *ctx)
 	struct super_block *sb = inode->i_sb;
 	struct buffer_head *bh = NULL;
 	struct fscrypt_str fstr = FSTR_INIT(NULL, 0);
+	bool has_csum = ext4_has_metadata_csum(sb);
 
 	err = fscrypt_prepare_readdir(inode);
 	if (err)
@@ -147,7 +148,7 @@ static int ext4_readdir(struct file *file, struct dir_context *ctx)
 			return err;
 
 		/* Can we just clear INDEX flag to ignore htree information? */
-		if (!ext4_has_metadata_csum(sb)) {
+		if (!has_csum) {
 			/*
 			 * We don't set the inode dirty flag since it's not
 			 * critical that it gets flushed back to the disk.
@@ -233,7 +234,10 @@ static int ext4_readdir(struct file *file, struct dir_context *ctx)
 		 * dirent right now.  Scan from the start of the block
 		 * to make sure. */
 		if (!inode_eq_iversion(inode, file->f_version)) {
-			for (i = 0; i < sb->s_blocksize && i < offset; ) {
+			for (i = 0;
+			     i <= sb->s_blocksize -
+				  ext4_dir_rec_len(1, has_csum ? NULL : inode) &&
+			     i < offset;) {
 				de = (struct ext4_dir_entry_2 *)
 					(bh->b_data + i);
 				/* It's too expensive to do a full
@@ -255,6 +259,17 @@ static int ext4_readdir(struct file *file, struct dir_context *ctx)
 			file->f_version = inode_query_iversion(inode);
 		}
 
+		if (unlikely(offset < sb->s_blocksize &&
+			     offset > sb->s_blocksize -
+			     ext4_dir_rec_len(1, has_csum ? NULL : inode))) {
+			EXT4_ERROR_FILE(file, bh->b_blocknr,
+					"bad entry in directory: %s - offset=%u, size=%lu",
+					"directory entry too close to block end",
+					offset, sb->s_blocksize);
+			ctx->pos = round_up(ctx->pos, sb->s_blocksize);
+			goto next_block;
+		}
+
 		while (ctx->pos < inode->i_size
 		       && offset < sb->s_blocksize) {
 			de = (struct ext4_dir_entry_2 *) (bh->b_data + offset);
@@ -310,6 +325,7 @@ static int ext4_readdir(struct file *file, struct dir_context *ctx)
 			ctx->pos += ext4_rec_len_from_disk(de->rec_len,
 						sb->s_blocksize);
 		}
+next_block:
 		if ((ctx->pos < inode->i_size) && !dir_relax_shared(inode))
 			goto done;
 		brelse(bh);

base-commit: 0aebf2870d53a8d97e02a99e2103ea0b38950c1b
-- 
2.56.0

