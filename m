Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=162.62.57.64
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793839113;
	b=sgEFXrmrtL+3XQVqJhQ7a9bJl519sAB/tuMqFqXGH/E6ODw7fiRcM5nN7in1Vl0velqs
	 88Mp2KgiZjuFasoFmdPcdF7XRr7j3eruKsAeRojLRYzf2srvoy0l+KVgqfA2qjr3n5AaQ
	 7mgrHU3+TU9WbrmRdsr4EtIbvHtHizTHQDrpoK/4rfPdMjxQUgFlkbQ1uNvj9i0kyBlQq
	 nNnPT46QoFAzNefSxL+NP968dlm7d3Mb5jGsBrgMBXDvidL/MwhhN7cw6hZd6MvIywxYp
	 +imuvfYlZDGIQjDPSOiLgN//aBseS0m+gudo1UdcpDi6m5rWQWL7kJ9w0xz9uIRnsYQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793839113;
	h=DMARC-Filter:DKIM-Signature:Received:X-QQ-mid:Message-ID:
	 X-QQ-XMAILINFO:X-QQ-XMRINFO:From:To:Cc:Subject:Date:X-OQ-MSGID:
	 X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=mHu2Zp+OIHYsTxDxzUotJkKv0NMf1tqUvXZaUeyrli0=;
	b=OaiQWRzFkqBPUcTuMpPGFunoblIm57aJq96djyl1f4yuhn7/Umook93Bwmc8Zvg6MTou
	 bp2nOTI2u4UP3eXeC1QH3jWHmTZ+cEIev/03+RIiF0jcSSP+waSvAmZXTbnvDWw1kV9jC
	 Zth6If8HVjjWRiIAVo0JakIcoNp4clilW1T2sBPgMoDll4ePBIsH1KbNtULBAiMPFxV34
	 FgeIpvmP2rQlGSvyS7vOU79QQrvHQY2VHVT0y/b8xQfO+7EZZJM2JcADF5PD6pNWvdE3q
	 kYjyJcyxCU4vpGfIXn/19+R9v8YdxgZy1LMKoH5fczA+Al7QyB2NRHaDzvp6RH2d6Zw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=qq.com;
	spf=pass smtp.mailfrom=qq.com;
	dkim=pass header.d=qq.com header.i=@qq.com header.a=rsa-sha256 header.s=s201512 header.b=CIL4B5I0;
	arc=none smtp.remote-ip=162.62.57.64
Received: from out162-62-57-64.mail.qq.com (out162-62-57-64.mail.qq.com [162.62.57.64])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18BC3606A328;
	Thu,  5 Nov 2026 00:38:30 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 18BC3606A328
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=qq.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=qq.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=qq.com header.i=@qq.com header.a=rsa-sha256 header.s=s201512 header.b=CIL4B5I0
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qq.com; s=s201512;
	t=1793839101; bh=mHu2Zp+OIHYsTxDxzUotJkKv0NMf1tqUvXZaUeyrli0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CIL4B5I0zxkoEMrOyOvKCtJi+kpKpF86scdupcw/kulTi5BGFQdzVxQZT33Lytd07
	 /cDBh/Woaq9Smoitloo/IWO2IsDI8HVXTKSBzm4fqO/7NIMYG2FR29oHWBnOoLvEh3
	 goBNZT7TE1/5kar4o7dEGBJqKqHfncrLAE50vLwU=
Received: from shuai-VMware-Virtual-Platform.. ([218.28.192.28])
	by newxmesmtplogicsvrszc43-0.qq.com (NewEsmtp) with SMTP
	id 9912A272; Thu, 05 Nov 2026 08:38:17 +0800
X-QQ-mid: xmsmtpt1793839097tkdlsus0m
Message-ID: <tencent_75A7137EEE37D2E72C50F2284D95B85A6208@qq.com>
X-QQ-XMAILINFO: Mg/13mbJq/Ru72bRH8u6I/LlE3zpGN+46yeQkAQ9GaBhoYhPdOzk/a6PsVlX4P
	 o97ZqDAOB4trRBzl+V3jSr0J62lHnaFvlZO2Nk85nksRqRxgkQXgDflczXY+IUXpW1nqUnfecMan
	 inTo5xX7QcJ05kD7tI74thQF8JxhOJe/jd/IJhEw8h5mobHve+/tECjPhIXMTt1+PA1lB8269yBT
	 0jb6uU0x3iymrXre5kURvglrNLNOjnlNF8I9YaPIX8aMg6AdeEK/s3T3CIiaaNWifr242O4jEu8A
	 mEBE2mwHOfxPj5UTx/vBpYZfhIDVh7AouEelQ0TL0pyyeMiMf1Ur2pe0GHeJJmw/G92rBYUJb2it
	 QG6I/IdbMJvCakFWVLuqF2+Lq88AcUDIt2K/J4jV2ea9t7JHkqi9hOLuMKa/9jMrkDJsoYaMpA0B
	 ajr4W+ndZEeeZbGVv7KMaehcMBjk+NtliZqG9HB99P/o2VfB9pBqWSf0mPu0XKaJ0RfGuiLQHJDU
	 0qIy/liIXr6ClnR7CTIjYwyYv9kEmcQZEfQAQxBaAvZEdpaQOiW/wBqmpa4Ea3Wk9kSzcegp4C/Y
	 xTyjHJdtaMaV1PYP/uHIgeBT3MiKeStWnWV7qIsMFVA/Eu85pK3K3u3V32andFaBALm+rwBFPA4U
	 BjkyztcQaVDpS6k0rf7emvexLx6fm7rmBWzuBHDaH0xenztjZFblLPNlWazW8Gcy054Nn1ZZotrt
	 n4SgxOQpx2x1Xa4Z1DUKenVvrbV40EYggm7RliWL/58Ta5MvyceTvbf1huyIocF7ReTnIdwSn1sr
	 NRWU2uip/C48VveKyVkbrUtwTP8udj5OIuy+nnRixzyKNUg06sO1YrpL/zSQIR5kaajgnlg29ZJG
	 61JrDDeRRlkRYsOrnzlgQtN0FsJAvtkGsJ6aqinBGN3YD2j/jjAMEoLhsNVG+S1ujnKukQ3tr/H5
	 pxEWtj6rvIf1swhIcAmoBxExS8+RAI9HiyaF5HZCrG7ywalbd3ZgW1D5p0LDbTVRWsSeOOTJw12V
	 Csqw9jH8qVC0akU3yZJFWM8jPhvptON83CYlmCRui2Z2W/TubUC3P5s8xl6R+dtMsE4n2FM7CInT
	 sqe4o+
X-QQ-XMRINFO: NS+P29fieYNwqS3WCnRCOn9D1NpZuCnCRA==
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
Subject: [PATCH v6] ext4: fix slab-use-after-free in do_split()
Date: Thu,  5 Nov 2026 08:38:17 +0800
X-OQ-MSGID: <20261105003817.904103-1-847807867@qq.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <sashiko-outbox-197106@kernel.org>
References: <sashiko-outbox-197106@kernel.org>
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
Changes in v6:
  - Move the aliasing checks to every point where a directory buffer
    is obtained for an htree operation, before its contents are
    modified, as the checks inside do_split() were too late for three
    paths (Sashiko):
    * make_indexed_dir(): an aliased ext4_append() result would be
      memcpy()ed and memset()ed before do_split() could check it
    * ext4_dx_add_entry(): add_dirent_to_buf() would insert into a
      leaf block aliasing an already-verified index block right after
      the read, and the index split would copy entries into an
      aliased ext4_append() buffer before do_split() is reached
  - Extend the commit message accordingly (Sashiko)

---
 fs/ext4/namei.c | 68 ++++++++++++++++++++++++++++++++++++++++++++++---
 1 file changed, 64 insertions(+), 4 deletions(-)

diff --git a/fs/ext4/namei.c b/fs/ext4/namei.c
index 354fc2d22df1..d9ae5c5a5562 100644
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
+		for (f = frames; f <= frame; f++) {
+			if (bh2 == f->bh)
+				break;
+		}
+		if (f <= frame || bh2 == bh) {
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

