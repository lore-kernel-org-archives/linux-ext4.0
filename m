Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.174
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792776348;
	b=2xyereo3OiQC5T5AvU4GbJ/LHMBu7322CMNTW+g09nZiYGidQSPw+hN59Da1ChLDlRZj
	 G9QvsX9uC6lzInm/M+u6FhG7cQevfvAGrTRCH9pUgk4nqYMAKOEzO5Wd12EKYLKRiEhVr
	 klwp2ZaXN0paHT77SDOFynLiF9I/V8u0U3FRCBZmyzxGmhmcASJvvfeOQHLZd+VcXddvv
	 GIeGrCshweKSQie9g/cdraUiqeQNwJiRyDjziLt3NfXQiN6dR2Es+bhWMkz5MjElGU4qq
	 FQZ5/I3A9tmRfCycyDOTHXGRmMS5UeL9Ik6bkPxXy9OVssXtjuz205riGDbY81CRAxw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792776348;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding;
	bh=eUl/XNYwVVA31TSAqOL0a6VbA1NPqf8fwEhYeAhXT2o=;
	b=U9Nq4viXpITp762CLFKIxqmJ/3VsoAOYcdff/QLra5Gu0y99hSKGtuFso9iR05/WOhXh
	 yVSgvUHT1vqIuNvWoJ9HATSAZEDyu3OeSTcEphqBrENDRZ/GnNZHTBGZp9o8wAesMtM9N
	 rvXFw95/sgmmq19TNEdjwe58GMxMN068wVEi0FZDUCaTlgrRYPiN+eRX6+xVfnu3od5FC
	 wd3UBcPEHfdCko1LUxJ5D63Jqw2PDj3zdsAKRi+tYelZNXTSKZljvlXq5VkQMIQpdV4I6
	 SJdjn9urx69ewKAD669lu24swzWlAM0cyrPguDJG+CnqEDzIMX8xCeJx340lbP4jY5A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=cs.unc.edu;
	spf=pass smtp.mailfrom=cs.unc.edu;
	dkim=pass header.d=cs.unc.edu header.i=@cs.unc.edu header.a=rsa-sha256 header.s=google header.b=PJtP1iNX;
	arc=none smtp.remote-ip=209.85.128.174
Received: from mail-yw1-f174.google.com (mail-yw1-f174.google.com [209.85.128.174])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87EFD606A31D
	for <linux-ext4@vger.kernel.org>; Fri, 23 Oct 2026 17:25:47 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 87EFD606A31D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=cs.unc.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cs.unc.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=cs.unc.edu header.i=@cs.unc.edu header.a=rsa-sha256 header.s=google header.b=PJtP1iNX
Received: by mail-yw1-f174.google.com with SMTP id 00721157ae682-8b05bf699easo11608537b3.2
        for <linux-ext4@vger.kernel.org>; Fri, 23 Oct 2026 10:25:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cs.unc.edu; s=google; t=1792776346; x=1793381146; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=eUl/XNYwVVA31TSAqOL0a6VbA1NPqf8fwEhYeAhXT2o=;
        b=PJtP1iNXTHWLqdEgG9k1IKU8dM9tqr0By9u+R9RrwPEk7DHjZaWPDwbf752jvAMS8a
         A+RpA9ryTA14MrkL7ba6an7yb6Q/gtb0bj5mWp26C742ApgphByX+aIPIGNEvrR4x8eL
         1pQZcCbRch1ZrlmQnx17ucgSgXHcGfJmgbQ15U2Hv1fQ4juGh4XECw8EnmEeZQxLYAOa
         VHcWGizzPOoGPQw7rpxdAtpP5+7sU4F6eaCeqbH5X8li+EobEFWE8aaCfztcFhoBLFeb
         jMu/YJ0vn4982vtMhSm1Z1ZJV8A+NDxpMPfHjYoyoPaYcX+Q2OzCzJxdjYqrYXjTuwLC
         qVCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792776346; x=1793381146;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=eUl/XNYwVVA31TSAqOL0a6VbA1NPqf8fwEhYeAhXT2o=;
        b=WnD0yER9oxQqsUXD8FjptBVlV6Cf85hp3jTku2q8YIR1hK6xWUQ8KzYNkB68qhLDC6
         SVbrvqb0pZPKNIP8e5hc6wVMh1oEoRcBaAv7+opcyPBe1mRdBwCx0zizeD8yCR84ypcR
         IX0TDbLD5iG5+QSpppv9os+HBxOUSaqTbv2S4wuhRm5VqPWy3BzJ/B1fnnmZ3QZahut6
         OKqxPJ+C0YQACrkqOL2H9L9BAwDUXGGMTTgv5Cqm9Miqh7uVEkxY5twuvERT+sHLSx7A
         0Z8SA2v//PgC0DG6FgB42TRD8uEBznGOdffBbegKYKECy9yUlLFadnws5wM0AqutxjiD
         3jJg==
X-Forwarded-Encrypted: i=1; AKwUvBwuQd+IvoPTOYWxEkqrVpS1S28NCsZ2peTzuZQbyo0pZ+51oM9U4N5gbfgYTIWk80nFEtOLgrrJVAbg@vger.kernel.org
X-Gm-Message-State: AFq9FYI+YcXEOOliD5hHCJJIPIfsGcY59JfXJNhiMIYbdce347mQNCYa
	z3oBwh4esGKAvfF6XQ5phU2Su0HsTCMJ6zrX3kVJqUoXQdn/7CXxmwBGgN4mJt8PSg==
X-Gm-Gg: AYBFou0tAtKxIclhz6l+R3tMHvl6QojvUeyprbg0Ag0XwBmKbc9NuyHej8R9NDAKRHv
	B9w4UYgDVpEeFNDABY5V/X4LkfXCX9oiL4xoEHpl5eG2LcXCL57C799HpYfIlTn7FbALOiEFwXS
	Wz6XMk9rYnjknFHPvbFtg9cEhr/k0aJMpzLMgLgq9XbVbgNosUmn7mlWv4LN2zuAmk0nBleRWKX
	H/tyzsgFvuE5MNEedhk0uI3v7kFCJkIk/RjvWOS9DpzIhyUO/nYKm0shxY5gb1fAA+iSB0Ot09d
	492URp3iKKPrANHHnem1zugEHYrH5hovhsYnTp0558I+pB1Ytr0RHbG3CKCh+cd3Ls/iuesJlAn
	6uo16APkWX/lGIBcyjTz9el9Y4rFFzqLYOp0UZx6z80ioL3FoJghkYis5BTWye4IKCVHRvunKNA
	UlO2DIYalI1NuW4e+wGYZhfDP8TJuH23qskvMDPpsZz56Z//NH0gJRs23CYev4IhVhoAGwJ1MVb
	ew46za0gDsmh2tgPOMQPHDQgJ+QtN3AzsHrH/kBIFBqVdmVWed1OryVi6N+wl9b16osCzxVuigL
	SQ==
X-Received: by 2002:a05:690c:13:b0:8b0:e8bc:5663 with SMTP id 00721157ae682-8b157e8afb0mr18899107b3.60.1792776344880;
        Fri, 23 Oct 2026 10:25:44 -0700 (PDT)
Received: from cobra01.cs.unc.edu (cobra01.cs.unc.edu. [152.2.130.143])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-8b163d69b33sm2715067b3.23.2026.10.23.10.25.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 23 Oct 2026 10:25:44 -0700 (PDT)
From: Hengyu Liang <hengyul@cs.unc.edu>
To: tytso@mit.edu,
	linux-ext4@vger.kernel.org
Cc: adilger.kernel@dilger.ca,
	libaokun@linux.alibaba.com,
	jack@suse.cz,
	ojaswin@linux.ibm.com,
	ritesh.list@gmail.com,
	yi.zhang@huawei.com,
	yi.zhang@huaweicloud.com,
	dave.hansen@linux.intel.com,
	akpm@linux-foundation.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Subject: [PATCH v2] ext4: do not advance i_size on a buffered write that copied nothing
Date: Fri, 23 Oct 2026 13:25:32 -0400
Message-ID: <20261023172532.3271348-1-hengyul@cs.unc.edu>
X-Mailer: git-send-email 2.53.0
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

Commit 665575cff098 ("filemap: move prefaulting out of hot write path")
made generic_perform_write() call ->write_begin() and ->write_end()
before it finds out that the source buffer cannot be read.  In that
case ->write_end() is called with copied == 0.

However, ext4_write_end(), ext4_journalled_write_end() and
ext4_da_do_write_end() set i_size to pos + copied without checking
copied.  As of now, a buffered write() past EOF that fails with EFAULT
grows the file to the write offset, and the new size can reach the
disk.

The issue can be reproduced on an ext4 mount with:

    char *p = mmap(NULL, 4096, PROT_NONE,
                   MAP_PRIVATE | MAP_ANONYMOUS, -1, 0);
    int fd = open("/mnt/ext4/file", O_CREAT | O_TRUNC | O_RDWR, 0600);
    pwrite(fd, p, 4096, 1024 * 1024);   /* fails with EFAULT */
    fstat(fd, &st);

Before that commit, the result is st_size = 0.
After it, the result is st_size = 1048576.

This patch will leave i_size alone when nothing was copied, as
ext4_write_inline_data_end() already does.  The delalloc path does not
trim after a failed write, so when such a write reaches past i_size,
it also drops the folio and the delayed blocks that ->write_begin()
set up there.  Otherwise that folio stays dirty past EOF and writeback
never cleans it.

Fixes: 665575cff098 ("filemap: move prefaulting out of hot write path")
Cc: stable@vger.kernel.org
Signed-off-by: Hengyu Liang <hengyul@cs.unc.edu>
---
Changes in v2:
- Rebase onto the ext4 dev branch.
- Also trim when a failed write starts before EOF and ends past it
  (pos + len > old_size), as suggested by Zhang Yi.
- Keep the Fixes tag and the new helper, as discussed on v1.
- v1: https://lore.kernel.org/r/20261009044656.1993196-1-hengyul@cs.unc.edu

Tested in KVM with KASAN: the reproducer above and failed writes around
EOF on delalloc, nodelalloc, bigalloc and 1k block filesystems.
e2fsck -fn reports no errors.

 fs/ext4/inode.c | 42 +++++++++++++++++++++++++++++++++++-------
 1 file changed, 35 insertions(+), 7 deletions(-)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 6ede3644a738..e96321ce17d2 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -1578,15 +1578,18 @@ static int ext4_write_end(const struct kiocb *iocb,
 	 * it's important to update i_size while still holding folio lock:
 	 * page writeout could otherwise come in and zero beyond i_size.
 	 *
+	 * If nothing was copied (e.g. the source buffer was unreadable), do
+	 * not move i_size up to pos.
+	 *
 	 * If FS_IOC_ENABLE_VERITY is running on this inode, then Merkle tree
 	 * blocks are being written past EOF, so skip the i_size update.
 	 */
-	if (!verity)
+	if (copied && !verity)
 		i_size_changed = ext4_update_inode_size(inode, pos + copied);
 	folio_unlock(folio);
 	folio_put(folio);
 
-	if (old_size < pos && !verity)
+	if (copied && old_size < pos && !verity)
 		pagecache_isize_extended(inode, old_size, pos);
 
 	/*
@@ -1697,13 +1700,13 @@ static int ext4_journalled_write_end(const struct kiocb *iocb,
 		if (!partial)
 			folio_mark_uptodate(folio);
 	}
-	if (!verity)
+	if (copied && !verity)
 		size_changed = ext4_update_inode_size(inode, pos + copied);
 	EXT4_I(inode)->i_datasync_tid = handle->h_transaction->t_tid;
 	folio_unlock(folio);
 	folio_put(folio);
 
-	if (old_size < pos && !verity)
+	if (copied && old_size < pos && !verity)
 		pagecache_isize_extended(inode, old_size, pos);
 
 	if (size_changed) {
@@ -3349,6 +3352,24 @@ static int ext4_da_should_update_i_disksize(struct folio *folio,
 	return 1;
 }
 
+/*
+ * Delalloc counterpart of ext4_truncate_failed_write(): ->write_begin() only
+ * reserved delayed blocks, so drop the page cache and the delayed extents
+ * beyond i_size and leave the blocks that are allocated there alone.
+ */
+static void ext4_da_truncate_failed_write(struct inode *inode)
+{
+	struct address_space *mapping = inode->i_mapping;
+	ext4_lblk_t lblk = EXT4_B_TO_LBLK(inode, inode->i_size);
+
+	filemap_invalidate_lock(mapping);
+	truncate_inode_pages(mapping, inode->i_size);
+	down_write(&EXT4_I(inode)->i_data_sem);
+	ext4_es_remove_extent(inode, lblk, EXT_MAX_BLOCKS - lblk);
+	up_write(&EXT4_I(inode)->i_data_sem);
+	filemap_invalidate_unlock(mapping);
+}
+
 static int ext4_da_do_write_end(struct address_space *mapping,
 			loff_t pos, unsigned len, unsigned copied,
 			struct folio *folio)
@@ -3386,12 +3407,12 @@ static int ext4_da_do_write_end(struct address_space *mapping,
 	 * checked, we need to update i_disksize here as certain
 	 * ext4_writepages() paths not allocating blocks and update i_disksize.
 	 */
-	if (new_i_size > inode->i_size) {
+	if (copied && new_i_size > inode->i_size) {
 		unsigned long end;
 
 		i_size_write(inode, new_i_size);
 		end = offset_in_folio(folio, new_i_size - 1);
-		if (copied && ext4_da_should_update_i_disksize(folio, end)) {
+		if (ext4_da_should_update_i_disksize(folio, end)) {
 			ext4_update_i_disksize(inode, new_i_size);
 			disksize_changed = true;
 		}
@@ -3400,9 +3421,16 @@ static int ext4_da_do_write_end(struct address_space *mapping,
 	folio_unlock(folio);
 	folio_put(folio);
 
-	if (pos > old_size)
+	if (copied && pos > old_size)
 		pagecache_isize_extended(inode, old_size, pos);
 
+	/*
+	 * A write reaching past i_size that copied nothing leaves i_size
+	 * alone, so trim what ->write_begin() set up beyond it.
+	 */
+	if (!copied && pos + len > old_size)
+		ext4_da_truncate_failed_write(inode);
+
 	if (!disksize_changed)
 		return copied;
 

base-commit: 8c4f6e3376348fc3162eed86a05b933921c8f9ed
-- 
2.53.0

