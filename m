Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.50
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795723994;
	b=tuKNFQawhbskkyikk8VJ6TnmM/YykOv+5t2Ng0v6Q/qDQDW6maptYYxfaNBiRsBGxWpk
	 +5qIoOThbhFQfR9o0SHg/A+1XhFBuSEdtBC+evLtUsWFA10rhMk73DsnZZD8kpQ8SCjYy
	 IpIXUHOd6AbPxqJwb1l6v3bS2cpJI67DNPf+jj5FKMk2kLDJq1MjxyGh5LnXvUzEO7jOk
	 6Nb8SR99prMYSkqhgSYIKsI/WePposSeMt6BzV4a4I66J9tblaybde+w3+wqLEWsUC9mh
	 XeALC+bvMFQGdd3oXkm5i/HXyP4viZxGqnyDkaKyN+8DufN23FabiSJaa5/hz/lPXPw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795723994;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=Q38Klj330dtRWghQm6M3dh+epEB584jmasAttwXUnHw=;
	b=SqKVZ7mHQuROG9XAvY2HpRX8ynKDFONzQ+WE81l+bvtwjdAC1IQRIg07fSq+/t11dEML
	 w0nkte8HGzpBxnDjoke+YsGIAobYfejrJ1un3/SxPSUOR8l/NZ+COOGZ/A9DELlD0YHAl
	 tPMoJofIm1s5uHVtFTIog0XG2i22fi3sFliZWGMfQtknknGkGbNqXigXuEoDeUvp12eUa
	 CH6lIG8RXMesW1JV+zJlvDWaUJbUCiMTJvDnqGJi6pN9KYlM9qWigsJs7V7bYmtFUQ49E
	 hn6Asvq7CGFlrtkrx2l5yrH+UgewCXYQ6wu7ygamcmTz4yvmIjXDhzStFbTUK5FP86w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=e2b.dev;
	spf=pass smtp.mailfrom=e2b.dev;
	dkim=pass header.d=e2b.dev header.i=@e2b.dev header.a=rsa-sha256 header.s=google header.b=EkbGWBZL;
	arc=none smtp.remote-ip=209.85.128.50
Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com [209.85.128.50])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2FB5606A31E
	for <linux-ext4@vger.kernel.org>; Thu, 26 Nov 2026 20:13:13 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org E2FB5606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=e2b.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=e2b.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=e2b.dev header.i=@e2b.dev header.a=rsa-sha256 header.s=google header.b=EkbGWBZL
Received: by mail-wm1-f50.google.com with SMTP id 5b1f17b1804b1-4bba5e17cbeso21153205e9.1
        for <linux-ext4@vger.kernel.org>; Thu, 26 Nov 2026 12:13:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=e2b.dev; s=google; t=1795723992; x=1796328792; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=Q38Klj330dtRWghQm6M3dh+epEB584jmasAttwXUnHw=;
        b=EkbGWBZL7E1vaDT/CSiNF9QMvL90vs9LoPdngbpiU9CZBY0lBXIADvCvOkz2uk2OGn
         6xs2TxKNgN6tgE4UOMJ2Pv4Ib60dtjpPAm/UH6CA6kea+pWnNfn8TgQlqZ1kRaJBIBFO
         vXEEU6x0/DoI6y2rfCTaHou6SFh/QmmBpdhu6mLR2ZkVSyjQA1KaIGwyacab8wqYziFK
         7gzQQHwfKIsdUdhUPTgL2AuxtabprlxhbZidg4xdKidttwpl2EiRkP3EgLi/+vjArzbV
         vo0x1dvpDYFFBxCMghRk3bHTypsYTFuAojpzhzkwxT0aNRrZK+gZOhRhgthZ26bZ9ydV
         slKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795723992; x=1796328792;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Q38Klj330dtRWghQm6M3dh+epEB584jmasAttwXUnHw=;
        b=nfZNX5rsJhVf+furq2MD4RYmuGtq30oDx58lSVQnE+fDxqT7N3h5NFuHJREXPYPLt1
         oeLl/5A6YSZBfKWaTBOmb9Kx1787PeQz5Log7r81O3aNnzqGvzKtevs/VVucDG0Iq64j
         dmhWT7QxV9BQt0tbuR0+Pfkb9B1IyBCJCFJgt8HQOr3rlVhAZlQ7+j42vIpufmZiN/zl
         63uxe62k9O1EEu6QwJ4HzJA+8ae0CnR75j7JizwUVVwuUQWJSkXsUeoonsN2rxQeF1db
         yNzGgDr/E90SWvkrjBKyqDK9x4Y9vtFQYDGjqaMa7ZCPXVHJ/UOPRHCfL3NlAS/Btq7J
         hmIg==
X-Forwarded-Encrypted: i=1; AL+hErEL50pogp6AR8i5h3Mb5GgyscxatkkJwryCvnPFFio/FIN8BL0fvyEfUzTRnYMnfZeFwk1fF9hBSobR@vger.kernel.org
X-Gm-Message-State: APuU4Z9bHfE1Y26xDMzKzxNAbZFx06bsWHa6MgK4qYFW8zHDxHj5F2Be
	sxAAdIq59R3SxeTQ/TmQIIWm19bNdGuRjmWwxt7c7dCYuDy9O/y4hmvc6UULrkQ6EhQ=
X-Gm-Gg: AZFdTZfnGpttkV4+yh2lCGVywPuILai4g8CLX5Iqh/+DUjvt/+6DPZ58PkigAIsfF5I
	JKhcmy5aEO2TZkSM2xbDxpBBEXLzT8B2CVVTLqKm1OpgP1yOw7ukn4xgeMZbhewyABTxW5kj3mo
	Akgo8bvQYaNRGPy0idS7IqQ87W8//DLCtzpBDrFd/Q6nbLkNKTByIr/MPWvZ4lsfCuZQm+6NSBp
	IG6HhMO+uETEn0Ay5I7RecyChM7RZxXnxSjR9BSChdU2RFbrJ6lAdA8PFMJ4AHfHQxEW3vch0ur
	b7Yu0C6M10fgqWIOlYzk+qcMKHir3dVxGimudm/ENHTZmYVfvLzKG/K9vqKer0LBTxxOcZKAiY8
	urAef2FVvQC278CIn6YmQyGQrLKGlcqSbs0XyhUxT+A53EEAM2ISJexAMOJ7uwv5fVK+AFpjwkj
	PxeypWhZ95YycGGErAWhPMsgIUIo1W5rW47KX5X0UGNcN8DZBQHnYjrKR8yEeynwX6V8qogefim
	ATyZSyGnXvgbiTDEOPvv9fYMPNGZI1VsYhS0qnHmb+vu2OcfbTCEX0wz3b+i1gD9dcNDPHO8wOH
	noSrZa2fGHHEvjBPVI+6t/2qdVwnQ4RvNMh6cRpZxxuXlWRd
X-Received: by 2002:a05:600c:e41a:b0:4bb:9959:54b8 with SMTP id 5b1f17b1804b1-4bb9959552emr248867915e9.32.1795723992219;
        Thu, 26 Nov 2026 12:13:12 -0800 (PST)
Received: from fedora.sphynx-tuna.ts.net ([2a02:8308:397:e200:f9e9:8bad:f8cc:87a3])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4bb8538b09bsm1154281665e9.4.2026.11.26.12.13.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 Nov 2026 12:13:11 -0800 (PST)
From: =?UTF-8?q?Petr=20Van=C4=9Bk?= <petr.vanek@e2b.dev>
To: "Theodore Ts'o" <tytso@mit.edu>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	Baokun Li <libaokun@linux.alibaba.com>,
	Jan Kara <jack@suse.cz>,
	Ojaswin Mujoo <ojaswin@linux.ibm.com>,
	"Ritesh Harjani (IBM)" <ritesh.list@gmail.com>,
	Zhang Yi <yi.zhang@huawei.com>
Cc: Deepanshu Kartikey <kartikey406@gmail.com>,
	=?UTF-8?q?Petr=20Van=C4=9Bk?= <petr.vanek@e2b.dev>,
	stable@vger.kernel.org,
	linux-ext4@vger.kernel.org
Subject: [PATCH 2/3] ext4: convert regular file inline data through the page cache
Date: Thu, 26 Nov 2026 21:12:54 +0100
Message-ID: <20261126201258.1553196-3-petr.vanek@e2b.dev>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261126201258.1553196-1-petr.vanek@e2b.dev>
References: <20261126201258.1553196-1-petr.vanek@e2b.dev>
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

ext4_convert_inline_data() moves a regular file's inline data to a new
block by copying it into the block device's buffer for that block and
journalling the buffer as metadata.  The file's own writes reach the
same block through the page cache, and nothing invalidates the
journalled copy.  When the journal checkpoints it, the stale buffer is
written over whatever the file has put in the block since.  The page
cache can also miss the data altogether: a folio read in after the
conversion reads the block from disk before the checkpoint has written
it.

Truncate, fallocate, page_mkwrite and fs-verity all convert inline
files this way, and since commit ed9356a30e59 ("ext4: convert inline
data to extents when truncate exceeds inline size") so does every
truncate that grows an inline file.  An ordinary sequence now loses
data:

  mkfs.ext4 -O inline_data /dev/vda
  mount /dev/vda /mnt
  xfs_io -f -c "pwrite -S 0x61 0 42" /mnt/f
  sync; echo 3 > /proc/sys/vm/drop_caches
  xfs_io -c "truncate 0" -c "truncate 77" -c "pwrite -S 0x62 0 77" /mnt/f
  sync; echo 3 > /proc/sys/vm/drop_caches
  od -c /mnt/f    # 77 zero bytes instead of 77 'b'

Growing the file without shrinking it first leaves the old inline bytes
on disk but loses whatever was written after the truncate, and
fallocate or an mmap write on a small inline file loses the new data
the same way.

Convert regular files the way a buffered write does in
ext4_convert_inline_data_to_extent(): copy the inline data into
folio 0, drop the inline data, map block 0 with ext4_get_block() and
dirty the folio.  The data then reaches the disk by writeback, and only
metadata goes through the journal.  The new helper differs from the
buffered-write one in three ways:

 - It always maps a written extent, never an unwritten one, so that in
   data=ordered mode the commit that drops the inline copy waits for
   the data.
 - An empty file needs no block; only the inline data is dropped.
 - If mapping the block fails, it restores the inline data instead of
   truncating the file: truncation takes invalidate_lock, which
   ext4_page_mkwrite() already holds shared.

Directories keep the old path, since their blocks are metadata.

Fixes: ed9356a30e59 ("ext4: convert inline data to extents when truncate exceeds inline size")
Cc: stable@vger.kernel.org
Signed-off-by: Petr Vaněk <petr.vanek@e2b.dev>
---
 fs/ext4/inline.c | 118 +++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 118 insertions(+)

diff --git a/fs/ext4/inline.c b/fs/ext4/inline.c
index acdc65ce4796..537857c3b4b2 100644
--- a/fs/ext4/inline.c
+++ b/fs/ext4/inline.c
@@ -1999,6 +1999,121 @@ int ext4_inline_data_truncate(struct inode *inode, int *has_inline)
 	return err;
 }
 
+/*
+ * Move a regular file's inline data to block 0 through the page cache, as a
+ * buffered write does, so the data reaches the disk by writeback.  It must not
+ * be journalled as a metadata block: checkpointing that copy later would
+ * overwrite whatever the file has written to the block since.
+ */
+static int ext4_convert_inline_data_reg(struct inode *inode)
+{
+	struct address_space *mapping = inode->i_mapping;
+	int ret, ret2, needed_blocks, no_expand, retries = 0;
+	unsigned int inline_size, len;
+	struct buffer_head *bh;
+	struct ext4_iloc iloc;
+	struct folio *folio;
+	handle_t *handle;
+	void *buf;
+
+	needed_blocks = ext4_chunk_trans_extent(inode, 1);
+
+	ret = ext4_get_inode_loc(inode, &iloc);
+	if (ret)
+		return ret;
+
+retry:
+	buf = NULL;
+	handle = ext4_journal_start(inode, EXT4_HT_WRITE_PAGE, needed_blocks);
+	if (IS_ERR(handle)) {
+		ret = PTR_ERR(handle);
+		goto out_brelse;
+	}
+
+	folio = __filemap_get_folio(mapping, 0, FGP_WRITEBEGIN | FGP_NOFS,
+				    mapping_gfp_mask(mapping));
+	if (IS_ERR(folio)) {
+		ret = PTR_ERR(folio);
+		goto out_stop;
+	}
+
+	ext4_write_lock_xattr(inode, &no_expand);
+	ret = 0;
+	if (!ext4_has_inline_data(inode))
+		goto out_unlock;
+
+	inline_size = ext4_get_inline_size(inode);
+	len = min_t(loff_t, inline_size, i_size_read(inode));
+	if (len > i_blocksize(inode)) {
+		EXT4_ERROR_INODE(inode, "inline data size %u exceeds block size",
+				 len);
+		ret = -EFSCORRUPTED;
+		goto out_unlock;
+	}
+
+	ext4_fc_track_inode(handle, inode);
+	if (!len) {
+		ret = ext4_destroy_inline_data_nolock(handle, inode);
+		goto out_unlock;
+	}
+
+	buf = kmalloc(inline_size, GFP_NOFS);
+	if (!buf) {
+		ret = -ENOMEM;
+		goto out_unlock;
+	}
+	ret = ext4_read_inline_data(inode, buf, inline_size, &iloc);
+	if (ret < 0)
+		goto out_unlock;
+
+	if (!folio_test_uptodate(folio)) {
+		ret = ext4_read_inline_folio(inode, folio);
+		if (ret < 0)
+			goto out_unlock;
+	}
+
+	ret = ext4_destroy_inline_data_nolock(handle, inode);
+	if (ret)
+		goto out_unlock;
+
+	/*
+	 * A written extent, not an unwritten one: in data=ordered mode the
+	 * commit that drops the inline copy then waits for the data.
+	 */
+	ret = ext4_block_write_begin(handle, folio, 0, len, ext4_get_block);
+	if (ret) {
+		ext4_restore_inline_data(handle, inode, &iloc, buf, inline_size);
+		goto out_unlock;
+	}
+
+	bh = folio_buffers(folio);
+	clear_buffer_new(bh);
+	if (ext4_should_journal_data(inode)) {
+		ret = do_journal_get_write_access(handle, inode, bh);
+		if (!ret) {
+			folio_mark_dirty(folio);
+			ret = ext4_handle_dirty_metadata(handle, NULL, bh);
+		}
+	} else {
+		block_commit_write(folio, 0, len);
+	}
+
+out_unlock:
+	ext4_write_unlock_xattr(inode, &no_expand);
+	folio_unlock(folio);
+	folio_put(folio);
+out_stop:
+	ret2 = ext4_journal_stop(handle);
+	if (!ret)
+		ret = ret2;
+	kfree(buf);
+	if (ret == -ENOSPC && ext4_should_retry_alloc(inode->i_sb, &retries))
+		goto retry;
+out_brelse:
+	brelse(iloc.bh);
+	return ret;
+}
+
 int ext4_convert_inline_data(struct inode *inode)
 {
 	int error, needed_blocks, no_expand;
@@ -2022,6 +2137,9 @@ int ext4_convert_inline_data(struct inode *inode)
 			return 0;
 	}
 
+	if (S_ISREG(inode->i_mode))
+		return ext4_convert_inline_data_reg(inode);
+
 	needed_blocks = ext4_chunk_trans_extent(inode, 1);
 
 	iloc.bh = NULL;
-- 
2.56.1

