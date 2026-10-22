Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=115.124.30.132
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792672021;
	b=AugOA6ZbatXqcLE9Ph9OLt8Gxbe/vURfZ0lpUDlpKmr9BhFOxAjXectjWmCuJYD5i08b
	 jhuJg0KE9dmNtItkI7CbckP/mk9Rsd4Uo4HtkHd2KvBEpsxgx4jNmGzqpOSxW0/OJ/qFw
	 j1MAXz0IxAyzAZI3w6JUcOPIqhfpmy9WrUQ/ax5qqcK4UmgfPAa7e3Hrm0kuQYnTr5kKr
	 0TtRIu59MRY1B1Zbzc9tBBg6Uxlv+TFWPKJa1GSp2eLcABV+4jP6dmJKSYyV4V3LMVaoj
	 koKPt1/GvRolHLDG5cOVb+UFBQnpAHfLbKB1ZoY1S0VmOzVZ29VNoKpZV0uAXwG0VAQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792672021;
	h=DMARC-Filter:DKIM-Signature:X-Alimail-AntiSpam:Received:From:To:Cc:
	 Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=zHtsQLHE6ovq3l4Z/94Incy1hLkuwupHe9qWX8o4Dws=;
	b=jX9wmlKtMhLbs71cJj/my8M//wOP3Vtv7o7NCB7uyrcHMTrOuXg0ZFI3tbfmWPWvV6WR
	 SyrI4V3lrkgEo7a3yOKwy983NGaGmf4MBZZY5akVZUQoQYapkkow+C+DB9IJ6YmMlWjyz
	 6nnjM6NIKjJ5pXSacWG2S24DzOS9CH5vRCymRrECKQm+eWWQILhoe8l7oj/zwH/75IOlD
	 YJuzPIlN4PYfK3INiw1EeY5jif80zlyb70N6A9wszfPwKPsV0bgwqExl18FxhWgZQ0tHi
	 OJkXfctSYNMRO9IBrGbcDE/9J9CsKyjN/kJFdgolo5ys9RGkg2GiqORC2ba2rC99efw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.alibaba.com;
	spf=pass smtp.mailfrom=linux.alibaba.com;
	dkim=pass header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=LdmSZwmm;
	arc=none smtp.remote-ip=115.124.30.132
Received: from out30-132.freemail.mail.aliyun.com (out30-132.freemail.mail.aliyun.com [115.124.30.132])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1EB0606A319;
	Thu, 22 Oct 2026 12:26:58 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org D1EB0606A319
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=LdmSZwmm
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1792672014; h=From:To:Subject:Date:Message-ID:MIME-Version;
	bh=zHtsQLHE6ovq3l4Z/94Incy1hLkuwupHe9qWX8o4Dws=;
	b=LdmSZwmmUvNTV5MQg4pdp7LrnoQ8ke0nmQS0zy3EK6LQB/EqAkw1BhTpUzxanhOUC8vaFD9VQEhWot0/EwhJhSZI3eOBt980UXni9FbhPLHtJ/Kz9JkVgrNjpilrNHBDNdr935hsH4zg1EaauTkOUDpKlRDSuio01+nu3PwbDdg=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R311e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033032089153;MF=libaokun@linux.alibaba.com;NM=1;PH=DS;RN=10;SR=0;TI=SMTPD_---0XDJG62f_1792671985;
Received: from x31h02109.sqa.na131.tbsite.net(mailfrom:libaokun@linux.alibaba.com fp:SMTPD_---0XDJG62f_1792671985 cluster:ay36)
          by smtp.aliyun-inc.com;
          Thu, 22 Oct 2026 20:26:54 +0800
From: Baokun Li <libaokun@linux.alibaba.com>
To: linux-ext4@vger.kernel.org
Cc: tytso@mit.edu,
	adilger.kernel@dilger.ca,
	jack@suse.cz,
	yi.zhang@huawei.com,
	ojaswin@linux.ibm.com,
	ritesh.list@gmail.com,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Subject: [PATCH v2] ext4: skip eof zeroing when the zero range covers the eof block
Date: Thu, 22 Oct 2026 20:26:25 +0800
Message-ID: <20261022122625.1744363-1-libaokun@linux.alibaba.com>
X-Mailer: git-send-email 2.43.7
In-Reply-To: <sashiko-outbox-181121@kernel.org>
References: <sashiko-outbox-181121@kernel.org>
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

ext4_zero_range() drops the page cache of the range before allocating,
to avoid exposing stale cached data.  However, the dropped page can be
read back by the eof zeroing:

  fallocate(fd, FALLOC_FL_ZERO_RANGE, 0, 4096)
    ext4_zero_range()
      ext4_truncate_page_cache_block_range(0, 4096)
        truncate_pagecache_range(0, 4095)
          truncate_inode_pages_range()
            delete_from_page_cache_batch()  # drops the page
      ext4_alloc_file_blocks(..., 4096)
        ext4_block_zero_eof(512, LLONG_MAX) # not block aligned
          ext4_load_tail_bh()
             __filemap_get_folio(FGP_WRITEBEGIN | FGP_ACCESSED)
             # FGP_CREAT reads the dropped page back
             # zeroes [512,1024), marks the buffer dirty
        ext4_map_blocks(...)  # converts the extent to unwritten
        ext4_update_inode_size(4096)

The bytes below the old EOF keep the stale disk content.  The page is
left dirty, so read() returns old data while O_DIRECT reads zeroes, and
a write into the same block is not converted and is lost until the page
is dropped:

  page [0, 4096), 1k block size, file ends at 512
   0            512          1024                      4096
   |--- data ----|-- tail ---|---- zero range ----------|
   | old data    |           |                          |

For example:

  $ xfs_io -f -c "pwrite -S 1 0 512" f
  $ sync
  $ fallocate -z -o 0 -l 4096 f
  $ xfs_io -c "pread -v 0 16" f  # old data, not zeroes

FALLOC_FL_WRITE_ZEROES hits the same path.  ext4_issue_zeroout() zeroes
the block on disk without updating the page cache, and the block stays
written.  Therefore, writeback of the dirty page overwrites the zeroes
with old data.

Since the whole eof block is converted to unwritten or zeroed out,
zeroing it here is redundant.  Therefore, skip the zeroing when this
allocation covers the eof block entirely.

Fixes: c4602a1d09ec ("ext4: move zero partial block range functions out of active handle")
Fixes: f4265b8d32c4 ("ext4: add FALLOC_FL_WRITE_ZEROES support")
Cc: stable@vger.kernel.org
Signed-off-by: Baokun Li <libaokun@linux.alibaba.com>
---
Changes since v1:
 * Also skip the eof zeroing for FALLOC_FL_WRITE_ZEROES, which
   reads the dropped page back in the same way (Reported by Sashiko).
 * Corrected the Fixes tags: the ZERO_RANGE regression comes from
   c4602a1d09ec, and f4265b8d32c4 introduced the WRITE_ZEROES one.
 * Fixed the call chains in the commit message.

v1: https://patch.msgid.link/20261022065342.3569693-1-libaokun@linux.alibaba.com

This hunk does not apply to v6.17 - v7.0, where the eof zeroing is
done inside the allocation loop; those trees need a manual backport.

 fs/ext4/extents.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index ad0d80e33f60..b05015b8b62c 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -4639,8 +4639,15 @@ static int ext4_alloc_file_blocks(struct file *file, loff_t offset, loff_t len,
 	credits = ext4_chunk_trans_blocks(inode, len_lblk);
 	depth = ext_depth(inode);
 
-	/* Zero to the end of the block containing i_size */
-	if (new_size > old_size) {
+	/*
+	 * Zero to the end of the block containing i_size.
+	 * Loading the eof block back before it is converted to unwritten
+	 * or zeroed out may leave the page cache inconsistent with the
+	 * disk, and zeroing it is redundant, so skip it.
+	 */
+	if (new_size > old_size &&
+	    !(in_range(old_size >> blkbits, map.m_lblk, map.m_len) &&
+	      (flags & EXT4_GET_BLOCKS_CONVERT_UNWRITTEN || alloc_zero))) {
 		ret = ext4_block_zero_eof(inode, old_size, LLONG_MAX);
 		if (ret)
 			return ret;
-- 
2.43.7

