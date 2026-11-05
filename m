Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=203.205.221.210
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793840520;
	b=5HGyXv5Q3WU08nerXPSePxAfdmYFfFk2YumN5FlHWudC3ofY3OM3t32Ribo3t67cmmON
	 qWr4D1hi4IS6uUpiXnq9mreaxY5w56FeB4LsNQv8NGSkB+e2uZQKdIV2b4qtqhAeV+U3V
	 V5uGnR3oGoApil8sBnUeArnsrLNPFyrKa6qpM9jK2nNs4F0RyMS1RwiX7FLFcl6Av7FVm
	 uhJnevm9olb0mkGBRsM7n7BuOQ2e/99OKyvINkcbhMBIQn3SLKKebMRVPWnI7+0RA45DJ
	 BilzkoQQHojDWRNUZl84orgimqiWFb91eZJy6AxD17UKhR7FGtcArmuG6B2l/4BhDnw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793840520;
	h=DMARC-Filter:DKIM-Signature:Received:X-QQ-mid:Message-ID:
	 X-QQ-XMAILINFO:X-QQ-XMRINFO:From:To:Cc:Subject:Date:X-OQ-MSGID:
	 X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=bx/MT5maU3Gc+R/rF5SL72/9cGVJPJeAIUUkqfX7dac=;
	b=sifCV9LtLjrH9tOTargXzQ7CrG6yunLS3NcUPtKJvPsOgc+z6pExyDHTPFu+O2QQQAnC
	 A+AM99EKndWSP/84dT3rsWRvRVu6uOlbAa3TkdLbhjbxq7rd4m7iOQUyDFsjIkL0BySyX
	 ADHAJcgigjO1LP5pvHsHqGgt9EFJuxSxxBKtfg9Y/ZXrfx30fDUixtBRLStDES3hzgymY
	 E1PNmd2F/KKqdQ0G3fL7q6fzt84KP+vY/0+06kCHCOUZaRtiyM/I25MXJoBY92kVnK+nq
	 y/BFRB64nJCmzplhCb/VUnROTgdfkvVWIIOwfSp1gGbaDXlYbfIsqxpkTvkEn/keNKA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=qq.com;
	spf=pass smtp.mailfrom=qq.com;
	dkim=pass header.d=qq.com header.i=@qq.com header.a=rsa-sha256 header.s=s201512 header.b=kGeqFWKL;
	arc=none smtp.remote-ip=203.205.221.210
Received: from out203-205-221-210.mail.qq.com (out203-205-221-210.mail.qq.com [203.205.221.210])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52337606A328;
	Thu,  5 Nov 2026 01:01:58 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 52337606A328
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=qq.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=qq.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=qq.com header.i=@qq.com header.a=rsa-sha256 header.s=s201512 header.b=kGeqFWKL
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qq.com; s=s201512;
	t=1793840516; bh=bx/MT5maU3Gc+R/rF5SL72/9cGVJPJeAIUUkqfX7dac=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kGeqFWKLWIQ/9lvtMLFv1/xgdovTmiNR/qTl2QtriiGzgDTNpctlA4L8eiN69V/8s
	 +PHr4y2BttPhDHX/mRKzEJM/G1IZ8q9oCjoUzrc2juNYL+PIgh9MAMuoo27trs40iG
	 l9pWMDCndO2ojvO95mEmydAIzNs595Ehry6ubWsg=
Received: from shuai-VMware-Virtual-Platform.. ([218.28.192.28])
	by newxmesmtplogicsvrsza53-0.qq.com (NewEsmtp) with SMTP
	id 7484C94; Thu, 05 Nov 2026 09:01:52 +0800
X-QQ-mid: xmsmtpt1793840512tzr0fmsg1
Message-ID: <tencent_7C8B9CBC52133FEE9798F6C494FB91B43106@qq.com>
X-QQ-XMAILINFO: M1rD3f8svNzn8Bm7Sxg6CqNVJiJMCuSjDHt8Gx5LIERbXr02HHva400avORAjM
	 mrGESlGdUjWwaZxrErOzia7gOG/L4LX2kdQ/6jpwLDNNtndwp2RL996LCUebE6t18wugLUVQlw0P
	 Ky69Kt42dUg+j45XpYlrDaLV0okcDAgyA069ZhKWNoruJndM/VCqBPndlnTrektCMsO37+LQXM2N
	 YnlyymF0eep6cD7v7rgET1P3zj5IgywrelFDuXhhczWooTW0tUljpeIIjcwWcEfgoSJCXm1zE+yC
	 47PKuV+/8qby01zkJ0qppYqCpiar61kFwWAP3a3aXV/scmDjyci3dJuCKXR5os3LPlftUqqIzwIY
	 EdL5Fj+QOXMR2Wk7F6RLHQN40goRwbOXrsIc7DDHhw19E2EwaOWDZIzauNykg1Rc0XWVsmT3nPAm
	 WkH3fb/Rke6Cf00L+bzsEDx6lfljpa3jmvWegyaYAram1pvD4+rc0u8QQ0wN/Q48EZjw8G0ff4Rq
	 DvI0HVeCERMjEppyLIK2DQUv17poFdES1838PzJANuNDNSWSn0LVIR5Z7+15lZzL3yacz1sRpjK/
	 shdRxXSlgtOFmAqxTZgPd7+sJZYF7qmq317zjc/c2/Mz74R/hFUfpq38MJbwrAN1D5jid1W3TihH
	 2ua6Zmjdp8IpxWW+jqlT188QauV6gM0tAih9j2YgEkB6QUbuI/0I7C4WR1RFp/hRHxwvoboU+wtb
	 oN8kZkTI/bRL3xpH/Anf8SVvp6vg22BooetkCIkqVkz76WySbool/FB7itCD+99Wt46XUusp3uVo
	 JX9YEJGtm8EhpGSgi2l0kUni+vSO2q2ihOlXcT3IF7lkBB7DrPlTmFw+qS52a7FI04lev6Xx/QFh
	 jqyWAjWV4TdUPQ/QNF6tvEg20dQgff4W+VKl3xSVcNdAwkZ1SDXCYU/F3cZ4tfvavg2/t+SZNv8h
	 W/0U6MTqSXyXlXFr4tUrjNa8VKrdTGNGEehkjvr9kJpBUPJVMEw0c+BaQwMsxakcMXkfYsu/V02h
	 7fBjmTBNNrom/5+DhJ4E9HNN0j5MWwNs+UYC8k3vbT6H2+FBnT5ALkPIHpt8KxcEaMR5hRUmCDzm
	 1hehHtvSIhIIQ7mJ4IGy2bk26bspsXPuj+AZ8iEoEI6I4wZ+Y=
X-QQ-XMRINFO: OWPUhxQsoeAVwkVaQIEGSKwwgKCxK/fD5g==
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
Subject: [PATCH v7] ext4: fix slab-use-after-free in do_split()
Date: Thu,  5 Nov 2026 09:01:52 +0800
X-OQ-MSGID: <20261105010152.923236-1-847807867@qq.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <sashiko-outbox-198371@kernel.org>
References: <sashiko-outbox-198371@kernel.org>
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
Changes in v7:
  - Extend the index split alias check to all active htree frames
    (frames[0..levels-1]), not just the current frame and its
    ancestors: after the parent index walkback loop decrements frame,
    the skipped lower-level frames stay active and are still released
    by dx_release(), so an aliased bh2 could overwrite them in place
    (Sashiko)

---
 fs/ext4/namei.c | 68 ++++++++++++++++++++++++++++++++++++++++++++++---
 1 file changed, 64 insertions(+), 4 deletions(-)

diff --git a/fs/ext4/namei.c b/fs/ext4/namei.c
index 354fc2d22df1..55892206dbd8 100644
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
@@ -2257,6 +2288,13 @@ static int make_indexed_dir(handle_t *handle, struct ext4_filename *fname,
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
 
@@ -2325,7 +2363,7 @@ static int make_indexed_dir(handle_t *handle, struct ext4_filename *fname,
 	if (retval)
 		goto out_frames;
 
-	de = do_split(handle,dir, &bh2, frame, &fname->hinfo);
+	de = do_split(handle, dir, &bh2, frames, frame, &fname->hinfo);
 	if (IS_ERR(de)) {
 		retval = PTR_ERR(de);
 		goto out_frames;
@@ -2476,6 +2514,7 @@ static int ext4_dx_add_entry(handle_t *handle, struct ext4_filename *fname,
 			     struct inode *dir, struct inode *inode)
 {
 	struct dx_frame frames[EXT4_HTREE_LEVEL], *frame;
+	struct dx_frame *f;
 	struct dx_entry *entries, *at;
 	struct buffer_head *bh;
 	struct super_block *sb = dir->i_sb;
@@ -2496,6 +2535,15 @@ static int ext4_dx_add_entry(handle_t *handle, struct ext4_filename *fname,
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
@@ -2549,6 +2597,18 @@ static int ext4_dx_add_entry(handle_t *handle, struct ext4_filename *fname,
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
@@ -2631,7 +2691,7 @@ static int ext4_dx_add_entry(handle_t *handle, struct ext4_filename *fname,
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

