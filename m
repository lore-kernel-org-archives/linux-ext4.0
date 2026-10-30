Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.219.43
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793333131;
	b=P0WSIyKQMxaSxycOt8q92TWPjRxYu9vqXT8n2Ps1kZnpqQw4bO56PdHdCVbTjBlQd9Oj
	 3hRddAiHDYkBfqEssbEq5imit1Xx6d+rdQSEZ/6ii9vI3ReFkNBj3S5Q3vH3ys8lHP+JP
	 lQpVlf3kDgTnNoNDUmBFeKgDQ+OzZgjFoZX72VZoCZTHkiYKwger3I219OiqfJaz9e3Hw
	 0IiIpEY6HDt6as7r0X4Bj9+ZidgK/0AoVHd0jcsaLODf/HAorgCmGa40baYfA2EY+7IxD
	 DEG6j3eRtQkMsWanvf3mdqFWUh/vFe5bKgYT4yarDcy1Pp7HMUGv73RmCNEZV3Maukg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793333131;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding;
	bh=inldKJPdjUUjviysI9T8tJ8KvrfY36K+5GvzIRj3mzM=;
	b=x9usuC1Be2Ivhnjkfi04pRycmOZxqFRj6S2v79MAS+8xEyQeWaHgDSrV8H+D7pLu8fTV
	 cswZne4VkTy97gSOh1K4FBATCCJ3wet5YtclFq9Ezv8ZvqKGANvX5C/2OHGn7XqE7SkYQ
	 B7X8S2mdzIzKYA0OYiDNfHe8ZyRHr2Ev6VNol5p3y0fVESUDRZRJ9/X/+6CRaqVkZqkeH
	 3zVWMBe7p5j1gy8vNNV8NC4WvnMXZwL9N/HbVUWxRbukv6pB2P6sasTPCzPOVfIEcFxp7
	 LufEiODb0jURSd1k40aBwcWTX/AxKoEYkB5Kudxy593Xzf46BA2jzvG4OjkFpZj00aQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=cs.unc.edu;
	spf=pass smtp.mailfrom=cs.unc.edu;
	dkim=pass header.d=cs.unc.edu header.i=@cs.unc.edu header.a=rsa-sha256 header.s=google header.b=B6BcJVh1;
	arc=none smtp.remote-ip=209.85.219.43
Received: from mail-qv1-f43.google.com (mail-qv1-f43.google.com [209.85.219.43])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A13C606A31D
	for <linux-ext4@vger.kernel.org>; Fri, 30 Oct 2026 04:05:30 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 6A13C606A31D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=cs.unc.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cs.unc.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=cs.unc.edu header.i=@cs.unc.edu header.a=rsa-sha256 header.s=google header.b=B6BcJVh1
Received: by mail-qv1-f43.google.com with SMTP id 6a1803df08f44-91c73c63116so3575296d6.2
        for <linux-ext4@vger.kernel.org>; Thu, 29 Oct 2026 21:05:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cs.unc.edu; s=google; t=1793333129; x=1793937929; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=inldKJPdjUUjviysI9T8tJ8KvrfY36K+5GvzIRj3mzM=;
        b=B6BcJVh1LIQiZ3lYnDbQEJJwlpdtM3BZwI22Anwj8q1oOkusRP3UreS0rDXWcIZQ5V
         4SCwvoVme9KrGXAYL8h0RmuL/E/o9n+qmfuBgZI/JwjKiG4lmztVBoq4SCVMnWsfvDgb
         Wz7gRJslWGgTdk0Zo5GLioKBl9ezpEpMVe2ac4GywI/rIf/yRspzohF5bGWgojngQ7SG
         ZctQgULHEXRXzrnH++KMG10pD50ncAdF5wdtuZ3b4YS1/gIoPwMb12vaRuVU9ppgEwxA
         f5SF/Jx+dDMy3rB6g3UW44HdhkWJQ6cqIW2WVk4UjHUIi4YOesmqgiQZAIAb/FJXupWD
         M78w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793333129; x=1793937929;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=inldKJPdjUUjviysI9T8tJ8KvrfY36K+5GvzIRj3mzM=;
        b=Lg8zoRNmZCKkKQ2H/XJdD+GuPWMKrWdr5qJzGy6K8Vqu6p+a11KpscIlBgV2hkdu9c
         hlLsEEMWYOK0iMJWNytwTD1g+yU+vtPxGdpkej1EW8cph5fMLyFi1WGjJIz1jVArO+yu
         UFmQP7Z+rjTUF/i54MvT9yQUUQ+YjWO3bCBwpo/ac2/f4z1hZYXJqulcqtE3psnfMfx5
         koe1DxTPfeW4CdoVEIPgQTKt+aT3Hu3s/EhpuS5RIEmA5YG66VbIbinMYnTOh6bZU7bC
         bsoZXzecPapL2HhaGcCH5vYE5KXEfUTcjnjOipkzyDmfhr8ztwraHcvuPbbpKDE9xyrQ
         xrjg==
X-Forwarded-Encrypted: i=1; AKwUvByfqhCu9jsdtXgxvI9v6XSOHbJ8r9bUQHX+c7V9F2Kx1PuPmDSVUQusAhr7nZX0CrBr77VZcTqdM6zt@vger.kernel.org
X-Gm-Message-State: AFq9FYKBB4WzJVdc+M7a+6bNTl4srzD03CDGzLFXolr1hm19hxYHTaKH
	aWMP4GvIbUvBwW5XPnGpzu7LVbmu2cLTo4XNXohINIV8dKQU5ihzLppbtMLEJwj+8Q==
X-Gm-Gg: AYBFou3ZGRhm/uXcgH2CkDiwl0QZnewXa7aFVGIGo5B20xemz9nwPt5lxu7M6Ewj1rc
	4I14DXAMKvpk33mgp5yYAWLrhVwiNRj7PnIj1up0npoljvsCNZsdWS3b4zg5C5GZzOrQGUXSGMP
	8AZtBxPv5MQZsteUkV7Dgn1XmHeLr6YJSV64q0d0rvV1YvyOkFZqxnwi0VB9nJLJ0y3Wep4Q1AD
	4of/nzLSyA3TfOf5lZuys4bj2g3FGf74BN3hMOnd3HvN+cNRJ5OcYuYN0YyOiXzwbwfT54dmihg
	w2exy6h2IKxzQ6EovnqF8dNQful48aq/1Nzi0cd3qxCEEpUoP9GnHLQTZuKcOINC2xYzn5FkXRa
	mqwLbD3i1UmP8RFfXCFq2VHlHQA1QsTXYnQ4dCrMNFMavwkn4D1nx859W2i9kQk4/+6etpPgspF
	Ckd1qsysGkFAGOh/GzYgRzbavfz+N2TtXyej7YNNaUucxGhNBhhE/+8Wcpj8nzDFB43YbFQpKmb
	l51lPURB8mrl2aonxRM8eSjWA65bfy1UlmtB4NC+ko+DdU3UqitabqYTX1QPjprIZExaPVbw1Ye
	QkU/sAuyAkv6mzPNjZ92t9nGW7sSO2V8yjMJu6bXlS3sXRQGTlaonTnQWgtZDuMHUM0gwgxE0w=
	=
X-Received: by 2002:a05:6214:5bc5:b0:91c:7da5:2185 with SMTP id 6a1803df08f44-91ca4bb4a15mr17162136d6.38.1793333128998;
        Thu, 29 Oct 2026 21:05:28 -0700 (PDT)
Received: from cobra01.cs.unc.edu (cobra01.cs.unc.edu. [152.2.130.143])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-91ca7f4367dsm4659526d6.20.2026.10.29.21.05.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Oct 2026 21:05:27 -0700 (PDT)
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
	yizhang089@gmail.com,
	dave.hansen@linux.intel.com,
	akpm@linux-foundation.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Subject: [PATCH v3] ext4: do not advance i_size on a buffered write that copied nothing
Date: Fri, 30 Oct 2026 00:05:20 -0400
Message-ID: <20261030040520.4138904-1-hengyul@cs.unc.edu>
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
ext4_write_inline_data_end() already does.  Unlike ext4_write_end(),
the delalloc path does not trim after a short write, so the folio and
the delayed blocks that ->write_begin() set up beyond i_size are left
behind, and the blocks stay reserved until the inode is evicted.  When
the write ends beyond i_size, drop them as well.

Fixes: 665575cff098 ("filemap: move prefaulting out of hot write path")
Cc: stable@vger.kernel.org
Signed-off-by: Hengyu Liang <hengyul@cs.unc.edu>
---
Changes in v3:
- Also trim after a short copy: drop the '!copied' check and compare
  pos + len with i_size after the update, as ext4_write_end() does
  (Zhang Yi).
- Reword the last paragraph of the commit message.
- v2: https://lore.kernel.org/r/20261023172532.3271348-1-hengyul@cs.unc.edu

Tested in KVM with KASAN: the reproducer above, failed writes around
EOF, and short copies on delalloc, nodelalloc and 1k block filesystems.
e2fsck -fn reports no errors.

 fs/ext4/inode.c | 39 ++++++++++++++++++++++++++++++++-------
 1 file changed, 32 insertions(+), 7 deletions(-)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 6ede3644a738..9c20876629bc 100644
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
@@ -3400,9 +3421,13 @@ static int ext4_da_do_write_end(struct address_space *mapping,
 	folio_unlock(folio);
 	folio_put(folio);
 
-	if (pos > old_size)
+	if (copied && pos > old_size)
 		pagecache_isize_extended(inode, old_size, pos);
 
+	/* Drop what ->write_begin() prepared beyond the resulting i_size. */
+	if (pos + len > inode->i_size)
+		ext4_da_truncate_failed_write(inode);
+
 	if (!disksize_changed)
 		return copied;
 

base-commit: 8c4f6e3376348fc3162eed86a05b933921c8f9ed
-- 
2.53.0

