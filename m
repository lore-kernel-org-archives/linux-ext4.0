Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793147937;
	b=I8zegipR8sFsKnd0ri2ZRQVkQZiGjQBHfBZBYyTN+uzPPNIa/iNhVHdWCvsOiIZjGRdm
	 DPw0Lj2DW+/VA9nRjoqteWqHtYLzJafd8/GOi+R7lW1ofFiD62VadYuyqptXvKOzAAPAR
	 9C0Juck9odsV6skLI7YKY+yTISwfhr1oCQQdK8to+8/ux3C5uoNrsFUPhOJhRBtzWkojZ
	 T9fEkIls0XC0iZmkDLm87L1mzPKHGIfKJy5RKTPacOCZpIoCRXUYVaBlraKjIpVuBfW95
	 wG7GEzVwba31Qt17d5L+7SPKK6C5DamdzIJ8aVa+PSTciA3u9xjL8Xr0XysBiYhvfCA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793147937;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ve+vCzEn2RessCc6Gkbpr2RSC04/z/xF8lspYJwg+fA=;
	b=JJqhTX6bizihQzyPOhUUffiNlxdWIFIAb/QVm0UgmVTehG13e492mpxXOSzXuYiz+4xJ
	 LLWAyvDDZi/tByIETsmtsb00lCslwDjAu2b4Pb0y4ohfKxI6a1xQlsWAX6fPtISSfuq0M
	 A/p4Qz1QKzO1bql+P8kvb78t3iS83xo6FjXBMOlcz5qyca8AaWobPtxh3Wy8o03SloqJZ
	 uMiq0VqFWN1ojZNy1Tk9/u1j80++M82vyKuqwplgHvZFLCX4ZJurzdut79A10QupZbW31
	 AaKbK4oNJpaZOArgWXR8SixiFMTpY97QA5/PR81P7D3F985lWia6qENT1TD/doxOraQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=bcjQ4Y+g;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2CD8D606A31A;
	Wed, 28 Oct 2026 00:38:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=bcjQ4Y+g
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 76CF01F01825;
	Wed, 28 Oct 2026 00:38:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793147936;
	bh=ve+vCzEn2RessCc6Gkbpr2RSC04/z/xF8lspYJwg+fA=;
	h=From:To:Cc:Subject:Date;
	b=bcjQ4Y+gTEDgZOZGGq8C4AVGj2PpGDH5htg6xguugzDuEb9jG0hNgkYCC/mTglGUN
	 hSt2a4WNjSdYWLjJ3bUbIGgirpyMWw9nYRhJvO+vH9UII0bhD62DO41jaq1stkY6BH
	 rHiUoSvViXf24qWHhBcl1EN9tcMISMZoPonICZQdH29F00LJ+UcVoK2jhwdtdGGfcU
	 aJ/zfvjJUJdZh7otnDv58vL0g2EsBG/0quihqh/1vksWPSB7lBVFOtp0ISW5CcEN9w
	 jVmOcMxMIRbDhgS7/+lSlvAiEjcc7LOnzQWzVzEMwCmOop/2vhpPqrH1UpQvMcgSou
	 qvPdqYcwxVMaw==
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
Subject: [PATCH 6.12] ext4: validate readdir offset before accessing dirent
Date: Tue, 27 Oct 2026 17:37:46 -0700
Message-ID: <20261028003746.31943-1-ebiggers@kernel.org>
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
index b278b5703c197..265e544cc3482 100644
--- a/fs/ext4/dir.c
+++ b/fs/ext4/dir.c
@@ -137,6 +137,7 @@ static int ext4_readdir(struct file *file, struct dir_context *ctx)
 	struct buffer_head *bh = NULL;
 	struct fscrypt_str fstr = FSTR_INIT(NULL, 0);
 	struct dir_private_info *info = file->private_data;
+	bool has_csum = ext4_has_metadata_csum(sb);
 
 	err = fscrypt_prepare_readdir(inode);
 	if (err)
@@ -148,7 +149,7 @@ static int ext4_readdir(struct file *file, struct dir_context *ctx)
 			return err;
 
 		/* Can we just clear INDEX flag to ignore htree information? */
-		if (!ext4_has_metadata_csum(sb)) {
+		if (!has_csum) {
 			/*
 			 * We don't set the inode dirty flag since it's not
 			 * critical that it gets flushed back to the disk.
@@ -234,7 +235,10 @@ static int ext4_readdir(struct file *file, struct dir_context *ctx)
 		 * dirent right now.  Scan from the start of the block
 		 * to make sure. */
 		if (!inode_eq_iversion(inode, info->cookie)) {
-			for (i = 0; i < sb->s_blocksize && i < offset; ) {
+			for (i = 0;
+			     i <= sb->s_blocksize -
+				  ext4_dir_rec_len(1, has_csum ? NULL : inode) &&
+			     i < offset;) {
 				de = (struct ext4_dir_entry_2 *)
 					(bh->b_data + i);
 				/* It's too expensive to do a full
@@ -256,6 +260,17 @@ static int ext4_readdir(struct file *file, struct dir_context *ctx)
 			info->cookie = inode_query_iversion(inode);
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
@@ -311,6 +326,7 @@ static int ext4_readdir(struct file *file, struct dir_context *ctx)
 			ctx->pos += ext4_rec_len_from_disk(de->rec_len,
 						sb->s_blocksize);
 		}
+next_block:
 		if ((ctx->pos < inode->i_size) && !dir_relax_shared(inode))
 			goto done;
 		brelse(bh);

base-commit: 85d82e0d7c2dfd3e75d34f35b7ebbf41f45c9c4e
-- 
2.56.0

