Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=203.205.221.245
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793787046;
	b=VpRXMyGNf4asje1ILWE/NdP9Ig1CyN0H8xAEHdSbTLGwgsyrp0QyQZzSwMURdY+fg+Dn
	 wXc6FgKvXQHTOhdlbWwNREtnMdPheoOptvhP0UucF+udlyybfGb2894wqVYpSwmvI3YQx
	 FWD06O9aecU5qbB8FMzvY/q7fATiNbrjHBPyhS+Y3kFQYQMUqmgGnykHVdqZXTP6hX7cw
	 0EEPyBQGbtsfhijyN9AyB4h52P2JAM5G0CWe/I8ChcJEBuJBYI2/GvXqa+k3ZsePzl0MY
	 GQet7jlCGsp5pJYNlhGfPOStAShvBG1i1NWtudm5RTKPwZDq3VnJTW5EXt3oRpXbn/Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793787046;
	h=DMARC-Filter:DKIM-Signature:Received:X-QQ-mid:Message-ID:
	 X-QQ-XMAILINFO:X-QQ-XMRINFO:From:To:Cc:Subject:Date:X-OQ-MSGID:
	 X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=gOy7eQpzHFpztlKvyzaiFTVnnLLXz7dkAkgtCzD74wg=;
	b=KWOiNWy3D43o9PUhSoe8t3BUVupub6HOQJxU+AkKaU1kT2oDDRa0xFboTph5CA0PW5db
	 v/+V3vg7mCGYGmydCDbx04+elXnMAenE6zfyfsHKpLNhm/qZg544wlaqTi9f8O423UZ/P
	 GEMWXOeRcPQqPDvvfaB5+ZwqCzRMS+FUfMQNTT7AJojExlntU+M2HCi8vzfvAvnLU40rv
	 P1U48kLC8QBIjt3slUqIDa+jWo8xcOFaBAOZ0rcRaqgb3qCDUxL11yoQF5Sd78FzC62RE
	 rRKkv0uglc/vGVCWr753uAdE8M0OTqgcYwWDMc3A+2JsxwTLrapFi2JikKImOIfw8jg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=qq.com;
	spf=pass smtp.mailfrom=qq.com;
	dkim=pass header.d=qq.com header.i=@qq.com header.a=rsa-sha256 header.s=s201512 header.b=YOHwj3ZP;
	arc=none smtp.remote-ip=203.205.221.245
Received: from out203-205-221-245.mail.qq.com (out203-205-221-245.mail.qq.com [203.205.221.245])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1F7C606A329;
	Wed,  4 Nov 2026 10:10:44 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org D1F7C606A329
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=qq.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=qq.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=qq.com header.i=@qq.com header.a=rsa-sha256 header.s=s201512 header.b=YOHwj3ZP
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qq.com; s=s201512;
	t=1793787042; bh=gOy7eQpzHFpztlKvyzaiFTVnnLLXz7dkAkgtCzD74wg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YOHwj3ZPYIfVSGTuE7EpjJTzxRdacwiL7q6MD2hyqiXu7l7gMwpylsZzqTb/TXcOv
	 q1M0G9/XrNl3kjTvQzlRyaoyY1rujff7N7I2WuJ0t5AY59FNjder16zt9Gz2EsTvuf
	 gIigBDX2ncdl/q0pQPZcADbqF+myh76XEy18PRTU=
Received: from shuai-VMware-Virtual-Platform.. ([218.28.192.28])
	by newxmesmtplogicsvrsza63-0.qq.com (NewEsmtp) with SMTP
	id 2A6B48B0; Wed, 04 Nov 2026 18:10:38 +0800
X-QQ-mid: xmsmtpt1793787038t70e1lbkq
Message-ID: <tencent_4EAEF2024D7BB83D62E41306EED8D2112C08@qq.com>
X-QQ-XMAILINFO: OIJV+wUmQOUAh1TBMEZac7874ZkPXaV+VLM3riPE8vYa/5fS9TiJRZsW2ue5Z0
	 UFa5Ss97sjxBePqku8HLxBt3pziFL7SAiRoAodC8iOQHWhZ4Zqh5mVnQnJqLL80ooRsMf6/jwEG8
	 my4prOG2dvplDauq9Q4xVkf5nJuUbgi8ZBrDesCR+zq3QQp56ACEOkvFuWUmcZh7HPQLT6n2SXWL
	 VBikY4pNHDTggVpNW/R0oC2t2G7W1W5kHoUo62eGQzzBUEpZZ2br8PeQRtQ+zDw0h9jc8LVzxq8i
	 oawQCq8OnCUuVAEwSzqzAt/bIQuOQx6GfPhfm2ANve4vUlrqvzdo5wMXzBEUKrouIKEchgctuCui
	 HL5Ni/v5YJlAwYtouOm8bGVeq9dzx97YvU70V8gX3VoauTBLvotk7hJHwiuxn4zBsRpY6pz5Jij0
	 AUx2lEOBg7Gh5K1DNBUpo+WtY1kgp0eF/nteZ5irUmNL6og6eMaIEiiT/xenYcvkZ2r2vlP7ZSfW
	 oM2tPj86tXqbz27FHRaN+IBIpApGDnEpwtq7GCpWIsdgp0sEhTMVoiXKoA4orzPKUEX0s4Yat3V3
	 ZDR1Ud3Op7DHFZjnZ6wUnXVmCnk9EUK0gR6oAcyAu1sfp0TjjABbjLnAiPnIp8fr1c3H20j4ACSi
	 WEUyZsxjk/Z1WBlNgx68qZCWq7Gim76JOjO+3rAE3TaLJdRn2gHWcbl54JTiXceP6IKtGu/c9z1r
	 ECvyC8t8zXqOYOzwYAw9C+c75bmLt+IRft7lVj7FWN29DR78Cg07ixvK5S+TuI5HkE8c9Sz9jhho
	 j/2BYC2AFfxZSQNPvkY/rr/InPLEO9qQGpgNONq6zw3+iolF4w/mGLDFcmMHEvn/pY9Qj2cGDbjc
	 dzTM4NPWGyjopFyL1Nu7jSqMWKcQVKK22jrd3zz9lUu+J7jcyr57r1vACAmzSZD4TrF2w/WYDIrD
	 zS2CjwHvNMY7zAhzr2D1gjg9MVuH9qO08TB9TQNNlo9rIg1XXgQLyeBtyZeiFeDdM9pAuK+CUpgA
	 d/A+3AKf/feUs7xcp6bKUfsFlupeVeaJ4KH1iDMSj/d4zGkoPi5SykRBgq95g/0P9VhM8CUd6vMy
	 LlaFi2w6yhBbirNj72j+wp9EjLFPZrLS2euAx0
X-QQ-XMRINFO: M/715EihBoGS47X28/vv4NpnfpeBLnr4Qg==
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
Subject: [PATCH v5] ext4: fix slab-use-after-free in do_split()
Date: Wed,  4 Nov 2026 18:10:38 +0800
X-OQ-MSGID: <20261104101038.743378-1-847807867@qq.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <sashiko-outbox-197027@kernel.org>
References: <sashiko-outbox-197027@kernel.org>
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

The same aliasing applies to the htree index blocks: if the leaf block
or the new block aliases any index frame (the parent index block
frame->bh or one of its ancestors in the frames[] array),
dx_move_dirents() and dx_pack_dirents() overwrite the index header,
dx_insert_block() then memmove()s with a corrupted count and writes
out of bounds, and dx_release() can loop past the frames[] array (or
leak frames) with a corrupted indirect_levels.

Fix this by checking for all of these aliases in do_split() and
bailing out with -EFSCORRUPTED before any directory block contents are
modified, reporting the corruption via ext4_error_inode_block().

Reported-by: syzbot+09bec78ee77613a3efdd@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=09bec78ee77613a3efdd
Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Cc: stable@vger.kernel.org
Signed-off-by: Shuai Liu <847807867@qq.com>
Changes in v5:
  - The v4 posting mistakenly carried the v3 diff (the code changes
    were left unstaged when the commit was amended), so the code did
    not match the v4 changelog.  The code now actually implements
    those changes: do_split() takes the frames[] array and checks *bh
    and bh2 against all frames[0..level] (spotted by Sashiko)

---
 fs/ext4/namei.c | 39 +++++++++++++++++++++++++++++++++++----
 1 file changed, 35 insertions(+), 4 deletions(-)

diff --git a/fs/ext4/namei.c b/fs/ext4/namei.c
index 354fc2d22df1..5f2790a0b8b4 100644
--- a/fs/ext4/namei.c
+++ b/fs/ext4/namei.c
@@ -1903,13 +1903,14 @@ static struct ext4_dir_entry_2 *dx_pack_dirents(struct inode *dir, char *base,
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
@@ -1922,12 +1923,42 @@ static struct ext4_dir_entry_2 *do_split(handle_t *handle, struct inode *dir,
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
@@ -2325,7 +2356,7 @@ static int make_indexed_dir(handle_t *handle, struct ext4_filename *fname,
 	if (retval)
 		goto out_frames;
 
-	de = do_split(handle,dir, &bh2, frame, &fname->hinfo);
+	de = do_split(handle, dir, &bh2, frames, frame, &fname->hinfo);
 	if (IS_ERR(de)) {
 		retval = PTR_ERR(de);
 		goto out_frames;
@@ -2631,7 +2662,7 @@ static int ext4_dx_add_entry(handle_t *handle, struct ext4_filename *fname,
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

