Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.44
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795676907;
	b=oksT+Nf9Y5s14HRl13Iwub1gaUdcA//64lbE5ov3NOcScLddID2pMdYFcx85rJcyiD/0
	 WZX/NkFWjy4ld4G6Oc0qr0Ezay8fMAcilD9xqQb389EZjhywh0QYhwDqFrOVSw6ZQnD6U
	 UO/Q6+QjXyuoGdNiEw2Wr7gknEfzLktpCAmzh1cRRp8QCnOY1EyxOzg41M5Viyj9zUavQ
	 gIzGlsPpJSFRa8/U5CisHEPwKdL1ySKzr3dMA4XacnBPv1DO4Er9M76ABbDDZijODKhRC
	 B8NJSIhbEqoZ1iCDBLWELEWi1KNSss2wWKil2wisWS0Njk3ZTy8IA855rOOuv4KSfjA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795676907;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Yj6ckuRDXDtFJUpKIi45gNhkfWqvhByp1dDJI5/R+1Y=;
	b=cDV7axbKX4yKPUczmmiOoxOYbU5onBVEOUUYAVN70+Fv7Au9FB6imWLDAR+DrT2W9fBD
	 TlbTFG+u/kK1bvqsCNWXIdH+/1gMkKj0FviOO+K3jEEljsefN1lEP61c2sal5h3tjhZ7l
	 +dkL7f3XwXo24akVnCSJZyqEvjJ1GGAoKirs/tpcPluEMFJMLj6Psb8sNxgIWJuksORM+
	 21+QEmiY8k1MfrTrxk19zra9dc6sYSi9zZukaGnX6LLUeLp7fEtedG0OErNkb3SkaRKSt
	 xiHDqzX76OqjSxOo/V5AF1YDhACWSlGY+kq3WrTcLWIeInEeqppXnMp0HS4lcZ58B5w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b="dI3NCul/";
	arc=none smtp.remote-ip=209.85.128.44
Received: from mail-wm1-f44.google.com (mail-wm1-f44.google.com [209.85.128.44])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA4C8606A31E
	for <linux-ext4@vger.kernel.org>; Thu, 26 Nov 2026 07:08:26 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org AA4C8606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=dI3NCul/
Received: by mail-wm1-f44.google.com with SMTP id 5b1f17b1804b1-4bba5e17728so13430245e9.2
        for <linux-ext4@vger.kernel.org>; Wed, 25 Nov 2026 23:08:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795676905; x=1796281705; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Yj6ckuRDXDtFJUpKIi45gNhkfWqvhByp1dDJI5/R+1Y=;
        b=dI3NCul/M5tSJZMUjPLZpG5jet7fsuTXmr25IM6IymEOdlKgfQzBPLqBHs6YSVyIK6
         IkltqGBwEVKurTPCSqNn0J/wff8ThjoV6FnsVsVE/wYPQ2DiYcIvM0/8zS0NzGopQnVk
         jYBtJpKhT1XJggU/BUTaNh5rVrbHwbHShz4Xil9DVZe7geulZPJXB+jHtmus2BTdEM1Y
         7eTnAEUFIwc2UPn8lRC2Pp6OhFtpDD4cUZ3BDgeg6wrnHmae3jNT5+h+mreswHlajbrc
         ZbHt1tKEIH9+BY7vfxutCyE3UKsCrde/1exrTETzNnd634GX2qI/lTi/adS9oSvXb4nV
         xWOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795676905; x=1796281705;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=Yj6ckuRDXDtFJUpKIi45gNhkfWqvhByp1dDJI5/R+1Y=;
        b=nWwMc4vDqcJXpcT+O+rcIy4B8QnBBhQ8SNCkg5MQg8c7mqtaxx6BR1/ZZoOYnOYogt
         wp3IdT9logU/VPr/tvnz6mbIrD4yKV2Y0Z5n31MiPReG286jsEw7YOYLDJJSfts3gNzz
         NIZOMt/VtpLzNbQw/URFQAyobazb0x3yTDLduboiddW/HM5w3UJxQ0KXgOYcIxrgXp8N
         j3SFgGzjEHpOi6VjFVWBlYoI9AZvJmLz0ASIJJlTdh/tv/TwR9F8gdd90T+YMHg/XNng
         IwC6NC46kEnmw5oYehrEaYndbLPcWoN37sMwVe6DZWQBAhcNA4tPZgLCG+c7cwiCDJFv
         Wjkg==
X-Forwarded-Encrypted: i=1; AL+hErFV47/wTBGcvcJPH2CamuzZHr88luLpeZM2V701G/x3iF08LITCARDf89EsIpUEnVzP7D9OADizbJiK@vger.kernel.org
X-Gm-Message-State: APuU4Z80PwhE3Ha8aYAqRF1SqZ2sgZugCNn9Y5DgHEhF0P1lm4XgOPAC
	l8WZINHEkFmREAZvyPi4oLAWPpQagsslP8/4QahXrckgnx7O47FjJklp
X-Gm-Gg: AZFdTZeVvMHDwrRHgGppZRTU/6fqBj9+Ot71t/6KlaMo9y/iW8fzXnXq1QjAebpOawu
	5OF+kEi4r37RZ0lOMp8jHsqwkmz2up22EongMbDTmJYj2fx855Dgps9xq0a9SeUuVIDYrRpGPqp
	2Nne7h1IMZTO4+jxMF5IqOIJuT6BNbnR47ZkFnUtfIBAikDBVIv0xIEv5XczPaTjPRxL4RJt3rs
	YORJU+XAtcDsOo0W+A2NzwpTG3dOYxY4KPLvlfd0aTANQbwv24KK47i2xlr7ump8lLibB3UhCKk
	v+eN8mqBWBxZOyLoFQQtbDRXptQXGeTedCrT73aBxW6B2T8qfgdF+bNpbE1lY2MmcgZ3YE7RKGo
	73qyhZQaet+oPPImvhKBKxMvzKXqNWtJPFyEzVq59xk6JSm/6KFRJk67Pl6GN9WLnQYpDAl5Rw6
	GlhbKapraCtcbDr9styA5QctITjDvOceGrQwK7kUSeoQLOdsTuHR9VajS4lPF1Tz9cQN6eK5+T3
	4OGr6sI0ROzCLO/tfDcxYqGEvHBDX10C0olDk/dbRi+RIlAdyc4/6faZ2tNu2X2dC261O7VxFw+
	dH4tzEdripwjC5d+A8DSFcdWLfmbvgsN+8be1Z3a+OIPEsiXxw==
X-Received: by 2002:a05:600c:4f4e:b0:4bb:6c71:b268 with SMTP id 5b1f17b1804b1-4bb8882672fmr421403295e9.6.1795676905035;
        Wed, 25 Nov 2026 23:08:25 -0800 (PST)
Received: from DESKTOP-V28CTA4.dbs.corp ([110.93.227.54])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4bb8538b09bsm1071077895e9.4.2026.11.25.23.08.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Nov 2026 23:08:24 -0800 (PST)
From: Arbab Haider <arbabhaider649@gmail.com>
To: tytso@mit.edu
Cc: adilger.kernel@dilger.ca,
	libaokun@linux.alibaba.com,
	jack@suse.cz,
	ojaswin@linux.ibm.com,
	ritesh.list@gmail.com,
	yi.zhang@huawei.com,
	yebin10@huawei.com,
	linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v4 3/5] ext4: keep EXT4_STATE_MAY_INLINE_DATA set during inline conversion
Date: Thu, 26 Nov 2026 12:07:47 +0500
Message-ID: <20261126070748.272109-5-arbabhaider649@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261126070748.272109-2-arbabhaider649@gmail.com>
References: <20261126070748.272109-2-arbabhaider649@gmail.com>
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

In ext4_convert_inline_data_nolock(), ext4_destroy_inline_data_nolock()
cleared both EXT4_INODE_INLINE_DATA and EXT4_STATE_MAY_INLINE_DATA and
dropped i_data_sem before ext4_map_blocks() allocated and initialized
block 0.  When ext4_page_mkwrite() invokes ext4_convert_inline_data()
without holding i_rwsem, two classes of races occur during that window:

1. A concurrent ext4_da_write_begin() sees !EXT4_STATE_MAY_INLINE_DATA,
   bypasses xattr_sem, and dirties folio 0 before ext4_map_blocks() fails
   (e.g. -ENOSPC) and ext4_restore_inline_data() restores
   EXT4_INODE_INLINE_DATA and EXT4_STATE_MAY_INLINE_DATA, triggering
   BUG_ON(ext4_test_inode_state(inode, EXT4_STATE_MAY_INLINE_DATA)) in
   ext4_do_writepages().
2. Callers that check ext4_has_inline_data() without xattr_sem while
   holding only i_rwsem or folio_lock can observe the transiently cleared
   EXT4_INODE_INLINE_DATA flag before block 0 is initialized or rollback
   completes:
   - ext4_convert_inline_data_to_extent() and ext4_prepare_inline_data()
     can misroute writes or recreate inline data after conversion.
   - ext4_dio_read_iter() and ext4_dio_write_iter() can bypass the
     buffered I/O fallback, clear EXT4_STATE_MAY_INLINE_DATA after a
     rollback, or hit WARN_ON_ONCE(ext4_has_inline_data()) in
     ext4_iomap_begin().
   - ext4_setattr() can skip ext4_convert_inline_data() and persist
     i_size > i_inline_size after rollback.
   - ext4_block_zero_eof() can enter ext4_block_zero_range(), failing
     with -ERANGE, aliasing JBD2 buffers in data=journal mode, or
     dirtying folio 0 across rollback.
   - ext4_bmap() can hit WARN_ON_ONCE(ext4_has_inline_data()) in
     ext4_iomap_begin().
   - ext4_iomap_begin_report() (FIEMAP / SEEK_DATA / SEEK_HOLE) can read
     ei->i_data[] as indirect block pointers after rollback, triggering
     EXT4_ERROR_INODE().
   - ext4_read_folio() and ext4_readahead() can cache a zeroed folio 0 or
     read stale on-disk block contents.

Keep EXT4_STATE_MAY_INLINE_DATA set during
ext4_convert_inline_data_nolock() until ext4_map_blocks() and block
initialization succeed (clearing it on unrecoverable failure in
ext4_destroy_inline_data_nolock() / ext4_restore_inline_data(), and
clearing it on success in ext4_convert_inline_data_to_extent()).
Serialize the inline-data checks with xattr_sem in
ext4_convert_inline_data_to_extent(), ext4_prepare_inline_data(),
ext4_dio_read_iter(), ext4_dio_write_iter() (respecting IOCB_NOWAIT),
ext4_setattr(), ext4_block_zero_eof(), ext4_bmap(), and ext4_readahead()
(preserving lockless fast paths on converted inodes and preserving
readahead for sparse files extended from empty inodes), and check
EXT4_STATE_MAY_INLINE_DATA alongside ext4_has_inline_data() in
ext4_iomap_begin_report() and ext4_read_folio().

Signed-off-by: Arbab Haider <arbabhaider649@gmail.com>
---
 fs/ext4/file.c     | 73 ++++++++++++++++++++++++++++++++++++----------
 fs/ext4/inline.c   | 14 ++++++++-
 fs/ext4/inode.c    | 53 ++++++++++++++++++++++++---------
 fs/ext4/readpage.c | 15 ++++++++--
 4 files changed, 121 insertions(+), 34 deletions(-)

diff --git a/fs/ext4/file.c b/fs/ext4/file.c
index cfb22d0d5..81412b38e 100644
--- a/fs/ext4/file.c
+++ b/fs/ext4/file.c
@@ -70,6 +70,7 @@ static ssize_t ext4_dio_read_iter(struct kiocb *iocb, struct iov_iter *to)
 {
 	ssize_t ret;
 	struct inode *inode = file_inode(iocb->ki_filp);
+	bool use_dio, check_inline;
 
 	if (iocb->ki_flags & IOCB_NOWAIT) {
 		if (!inode_trylock_shared(inode))
@@ -78,7 +79,23 @@ static ssize_t ext4_dio_read_iter(struct kiocb *iocb, struct iov_iter *to)
 		inode_lock_shared(inode);
 	}
 
-	if (!ext4_should_use_dio(iocb, to)) {
+	check_inline = ext4_has_inline_data(inode) ||
+		ext4_test_inode_state(inode, EXT4_STATE_MAY_INLINE_DATA);
+	if (check_inline) {
+		if (iocb->ki_flags & IOCB_NOWAIT) {
+			if (!down_read_trylock(&EXT4_I(inode)->xattr_sem)) {
+				inode_unlock_shared(inode);
+				return -EAGAIN;
+			}
+		} else {
+			down_read(&EXT4_I(inode)->xattr_sem);
+		}
+	}
+	use_dio = ext4_should_use_dio(iocb, to);
+	if (check_inline)
+		up_read(&EXT4_I(inode)->xattr_sem);
+
+	if (!use_dio) {
 		inode_unlock_shared(inode);
 		/*
 		 * Fallback to buffered I/O if the operation being performed on
@@ -633,22 +650,46 @@ static ssize_t ext4_dio_write_iter(struct kiocb *iocb, struct iov_iter *from)
 	}
 
 	/* Fallback to buffered I/O if the inode does not support direct I/O. */
-	if (!ext4_should_use_dio(iocb, from)) {
-		if (ilock_shared)
-			inode_unlock_shared(inode);
-		else
-			inode_unlock(inode);
-		return ext4_buffered_write_iter(iocb, from);
-	}
+	{
+		bool check_inline = ext4_has_inline_data(inode) ||
+			ext4_test_inode_state(inode, EXT4_STATE_MAY_INLINE_DATA);
+
+		if (check_inline) {
+			if (iocb->ki_flags & IOCB_NOWAIT) {
+				if (!down_read_trylock(&EXT4_I(inode)->xattr_sem)) {
+					if (ilock_shared)
+						inode_unlock_shared(inode);
+					else
+						inode_unlock(inode);
+					return -EAGAIN;
+				}
+			} else {
+				down_read(&EXT4_I(inode)->xattr_sem);
+			}
+		}
+		if (!ext4_should_use_dio(iocb, from)) {
+			if (check_inline)
+				up_read(&EXT4_I(inode)->xattr_sem);
+			if (ilock_shared)
+				inode_unlock_shared(inode);
+			else
+				inode_unlock(inode);
+			return ext4_buffered_write_iter(iocb, from);
+		}
 
-	/*
-	 * Prevent inline data from being created since we are going to allocate
-	 * blocks for DIO. We know the inode does not currently have inline data
-	 * because ext4_should_use_dio() checked for it, but we have to clear
-	 * the state flag before the write checks because a lock cycle could
-	 * introduce races with other writers.
-	 */
-	ext4_clear_inode_state(inode, EXT4_STATE_MAY_INLINE_DATA);
+		/*
+		 * Prevent inline data from being created since we are going to
+		 * allocate blocks for DIO. We know the inode does not currently
+		 * have inline data because ext4_should_use_dio() checked for it
+		 * under xattr_sem, but we have to clear the state flag before
+		 * releasing xattr_sem and running the write checks because a
+		 * lock cycle could introduce races with other writers or inline
+		 * data rollback.
+		 */
+		ext4_clear_inode_state(inode, EXT4_STATE_MAY_INLINE_DATA);
+		if (check_inline)
+			up_read(&EXT4_I(inode)->xattr_sem);
+	}
 
 	ret = ext4_dio_write_checks(iocb, from, &ilock_shared, &extend,
 				    &dio_flags);
diff --git a/fs/ext4/inline.c b/fs/ext4/inline.c
index df50b0483..9270a2f4c 100644
--- a/fs/ext4/inline.c
+++ b/fs/ext4/inline.c
@@ -428,6 +428,10 @@ static int ext4_prepare_inline_data(handle_t *handle, struct inode *inode,
 		return -ENOSPC;
 
 	ext4_write_lock_xattr(inode, &no_expand);
+	if (!ext4_test_inode_state(inode, EXT4_STATE_MAY_INLINE_DATA)) {
+		ext4_write_unlock_xattr(inode, &no_expand);
+		return -ENOSPC;
+	}
 	/*
 	 * ei->i_inline_size may have changed since the initial check
 	 * if other xattrs were added. Recalculate to ensure
@@ -507,7 +511,8 @@ static int ext4_destroy_inline_data_nolock(handle_t *handle,
 
 	EXT4_I(inode)->i_inline_off = 0;
 	EXT4_I(inode)->i_inline_size = 0;
-	ext4_clear_inode_state(inode, EXT4_STATE_MAY_INLINE_DATA);
+	if (error)
+		ext4_clear_inode_state(inode, EXT4_STATE_MAY_INLINE_DATA);
 out:
 	brelse(is.iloc.bh);
 	if (error == -ENODATA)
@@ -595,14 +600,17 @@ static int ext4_convert_inline_data_to_extent(struct address_space *mapping,
 	unsigned from, to;
 	struct ext4_iloc iloc;
 
+	down_read(&EXT4_I(inode)->xattr_sem);
 	if (!ext4_has_inline_data(inode)) {
 		/*
 		 * clear the flag so that no new write
 		 * will trap here again.
 		 */
 		ext4_clear_inode_state(inode, EXT4_STATE_MAY_INLINE_DATA);
+		up_read(&EXT4_I(inode)->xattr_sem);
 		return 0;
 	}
+	up_read(&EXT4_I(inode)->xattr_sem);
 
 	needed_blocks = ext4_chunk_trans_extent(inode, 1);
 
@@ -647,6 +655,7 @@ static int ext4_convert_inline_data_to_extent(struct address_space *mapping,
 	ret = ext4_destroy_inline_data_nolock(handle, inode);
 	if (ret)
 		goto out;
+	ext4_clear_inode_state(inode, EXT4_STATE_MAY_INLINE_DATA);
 
 	if (ext4_should_dioread_nolock(inode)) {
 		ret = ext4_block_write_begin(handle, folio, from, to,
@@ -1114,6 +1123,7 @@ static void ext4_restore_inline_data(handle_t *handle, struct inode *inode,
 		ext4_msg(inode->i_sb, KERN_EMERG,
 			"error restoring inline_data for inode -- potential data loss! (inode %llu, error %d)",
 			inode->i_ino, ret);
+		ext4_clear_inode_state(inode, EXT4_STATE_MAY_INLINE_DATA);
 		return;
 	}
 	ext4_write_inline_data(inode, iloc, buf, 0, inline_size);
@@ -1214,6 +1224,8 @@ static int ext4_convert_inline_data_nolock(handle_t *handle,
 out_restore:
 	if (error)
 		ext4_restore_inline_data(handle, inode, iloc, buf, inline_size);
+	else
+		ext4_clear_inode_state(inode, EXT4_STATE_MAY_INLINE_DATA);
 
 out:
 	brelse(data_bh);
diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index f27aeae02..f5d0d7939 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -3613,8 +3613,16 @@ static sector_t ext4_bmap(struct address_space *mapping, sector_t block)
 	/*
 	 * We can get here for an inline file via the FIBMAP ioctl
 	 */
-	if (ext4_has_inline_data(inode))
-		goto out;
+	if (ext4_has_inline_data(inode) ||
+	    ext4_test_inode_state(inode, EXT4_STATE_MAY_INLINE_DATA)) {
+		bool has_inline;
+
+		down_read(&EXT4_I(inode)->xattr_sem);
+		has_inline = ext4_has_inline_data(inode);
+		up_read(&EXT4_I(inode)->xattr_sem);
+		if (has_inline)
+			goto out;
+	}
 
 	if (mapping_tagged(mapping, PAGECACHE_TAG_DIRTY) &&
 	    (test_opt(inode->i_sb, DELALLOC) ||
@@ -4117,7 +4125,8 @@ static int ext4_iomap_begin_report(struct inode *inode, loff_t offset,
 	if ((offset >> blkbits) > EXT4_MAX_LOGICAL_BLOCK)
 		return -EINVAL;
 
-	if (ext4_has_inline_data(inode)) {
+	if (ext4_has_inline_data(inode) ||
+	    ext4_test_inode_state(inode, EXT4_STATE_MAY_INLINE_DATA)) {
 		ret = ext4_inline_data_iomap(inode, iomap);
 		if (ret != -EAGAIN) {
 			if (ret == 0 && offset >= iomap->length)
@@ -5104,13 +5113,21 @@ int ext4_block_zero_eof(struct inode *inode, loff_t from, loff_t end)
 	if (!offset || from >= end)
 		return 0;
 	/*
-	 * Inline data has no tail block to zero out.  Note that a race with
-	 * ext4_page_mkwrite() converting inline data to an extent without
-	 * holding i_rwsem is safe, as that path zeroes the full block before
-	 * copying in the inline data.
+	 * Inline data has no tail block to zero out.  Serialize against a
+	 * concurrent ext4_page_mkwrite() inline data conversion so we do not
+	 * observe transiently cleared EXT4_INODE_INLINE_DATA before block 0 is
+	 * initialized or rolled back.
 	 */
-	if (ext4_has_inline_data(inode))
-		return 0;
+	if (ext4_has_inline_data(inode) ||
+	    ext4_test_inode_state(inode, EXT4_STATE_MAY_INLINE_DATA)) {
+		bool has_inline;
+
+		down_read(&EXT4_I(inode)->xattr_sem);
+		has_inline = ext4_has_inline_data(inode);
+		up_read(&EXT4_I(inode)->xattr_sem);
+		if (has_inline)
+			return 0;
+	}
 	/* If we are processing an encrypted inode during orphan list handling */
 	if (IS_ENCRYPTED(inode) && !fscrypt_has_encryption_key(inode))
 		return 0;
@@ -7246,11 +7263,19 @@ int ext4_setattr(const struct mnt_idmap *idmap, struct dentry *dentry,
 		 * convert to extent-based storage first to prevent inconsistent
 		 * state (inline flag set but size exceeds inline capacity).
 		 */
-		if (ext4_has_inline_data(inode) &&
-		    attr->ia_size > EXT4_I(inode)->i_inline_size) {
-			error = ext4_convert_inline_data(inode);
-			if (error)
-				return error;
+		if (ext4_has_inline_data(inode) ||
+		    ext4_test_inode_state(inode, EXT4_STATE_MAY_INLINE_DATA)) {
+			bool convert_inline;
+
+			down_read(&EXT4_I(inode)->xattr_sem);
+			convert_inline = ext4_has_inline_data(inode) &&
+				attr->ia_size > EXT4_I(inode)->i_inline_size;
+			up_read(&EXT4_I(inode)->xattr_sem);
+			if (convert_inline) {
+				error = ext4_convert_inline_data(inode);
+				if (error)
+					return error;
+			}
 		}
 
 		if (shrink) {
diff --git a/fs/ext4/readpage.c b/fs/ext4/readpage.c
index c7b6cdb2e..4ebe985c6 100644
--- a/fs/ext4/readpage.c
+++ b/fs/ext4/readpage.c
@@ -326,7 +326,8 @@ int ext4_read_folio(struct file *file, struct folio *folio)
 
 	trace_ext4_read_folio(inode, folio);
 
-	if (ext4_has_inline_data(inode)) {
+	if (ext4_has_inline_data(inode) ||
+	    ext4_test_inode_state(inode, EXT4_STATE_MAY_INLINE_DATA)) {
 		ret = ext4_readpage_inline(inode, folio);
 		if (ret != -EAGAIN)
 			return ret;
@@ -345,8 +346,16 @@ void ext4_readahead(struct readahead_control *rac)
 	struct fsverity_info *vi = NULL;
 
 	/* If the file has inline data, no need to do readahead. */
-	if (ext4_has_inline_data(inode))
-		return;
+	if (ext4_has_inline_data(inode) ||
+	    ext4_test_inode_state(inode, EXT4_STATE_MAY_INLINE_DATA)) {
+		bool has_inline;
+
+		down_read(&EXT4_I(inode)->xattr_sem);
+		has_inline = ext4_has_inline_data(inode);
+		up_read(&EXT4_I(inode)->xattr_sem);
+		if (has_inline)
+			return;
+	}
 
 	if (readahead_index(rac) < DIV_ROUND_UP(inode->i_size, PAGE_SIZE))
 		vi = fsverity_get_info(inode);
-- 
2.53.0

