Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.221.49
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795420252;
	b=fQh4C2bkWbM1omI3HdGcU4SMTJ41ufg3p6JjF3GWRPZuGUgpbM4TDYa6Kc5kzAOSfi8y
	 216gw/2jhb7ESssVPI01GOlqoxwcBbWP/X9XXJoY78WfRgPV1eEy4I7T7/XHQsjbULfzA
	 LiikssOv78BLS9RoghD5s1eBFhMvB4S/bw/tTlj0Yr8iT2ncp5qdNCGTfo9xJsOqn3pUM
	 V9sgWPGnXFSS//prPrAcCczn93lfx3QA28IPixdEOXFiRLLJNnt7v6dwqt/lEWILdTAiq
	 +WRiqBj0L19Mv+oyKvT1jq+Y148ea8Zn+CJwRj79fykNxDTEGJEwhHCyLWgVFFI/zkg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795420252;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding;
	bh=v2Apz3ssdYuV5VnyxzTDD+Md8/ohbYbbEPHRSzngUIg=;
	b=Bc2b/RuKGbO1i8K18Y0DvCrXeLRZKh/3Fo6F29Huzd+vMzEqRobhR2K/hI2DbQw/Xo9P
	 s+eOuZ0VTWN/CKyfhhiVjtFfcvvF/Nwc1eaSxdWYtKqZM86W22x0cvZCDcbvDcYUY8UNo
	 yM1kYgLDCHnLPHFqURzGMfIKfClhyX96fj4mMzBBJhc3hU1FEKQOoePVVne4zVl680bC9
	 N70ZY/7v/IqOM/qvq1xrd+sdDHliMkoetlTWu6un1MnEgPGtrT6IAQMHF9ioPbz1q9Plm
	 hmczO4v2eapQr0EmPlzl76otvc+VaHFDT+22UO7YaH0OSlzIQH8nqMieerA18+3RvOg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=mwyyWKV2;
	arc=none smtp.remote-ip=209.85.221.49
Received: from mail-wr1-f49.google.com (mail-wr1-f49.google.com [209.85.221.49])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37387606A31E
	for <linux-ext4@vger.kernel.org>; Mon, 23 Nov 2026 07:50:52 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 37387606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=mwyyWKV2
Received: by mail-wr1-f49.google.com with SMTP id ffacd0b85a97d-4ac109a8a12so1609510f8f.3
        for <linux-ext4@vger.kernel.org>; Sun, 22 Nov 2026 23:50:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795420250; x=1796025050; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=v2Apz3ssdYuV5VnyxzTDD+Md8/ohbYbbEPHRSzngUIg=;
        b=mwyyWKV2bCwBrc44y03L97JcgWzABEopzoEnoI3rXn/nnCY1EEkbs8WE5c63whzE5Z
         GJqDlJyyJT5HemU8N2X0TZQtNId6emRFUJyqZLuxCzB4wMuIzv8WI83WfANSZ92GqwEO
         NVf8JjaUbrniYOTb2XhouBqWczBlk5DgKb0fEOo2R6NaVsbzCg7g2FKTc71vFUCymwKh
         Wz5V+PVuqlDoiTd+GYEmGTgAQqTCqLdQsJpIEi1jz24wf/330fnU03MA3Px8azAZnHTP
         4xlOtNihby2Gy7Y0b+JyUgTWwT5OdruRSFbAFGU869SFQ4kQAmWG9BTPZllN1G89RF8q
         kZlw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795420250; x=1796025050;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=v2Apz3ssdYuV5VnyxzTDD+Md8/ohbYbbEPHRSzngUIg=;
        b=VA0thGEr/zQ26xnILaRiUzKsiakvOxoA0i2B+LMOZGcgoRKY0sndGki4swsQ+pFu4w
         XJsbW1IdncXzetgDQZwdKPtpuz/oCQiukHqSsHEd552j0gaCt+Vjx/hhEcBf30RWhxcb
         vbrIEswlnCiBH8ehTgcCEtO/dbPq4a776XilxWdX33WIFQGfDGm1y8ndyzAl7NXP5VHO
         DG3dUdp6uVHGs0u7qbL8aMXKX5I8S53dh5O8ccKIZULpWv9/HCqICQ147U6RWtBVmdci
         RrSv3jPNiHkmfOsoXmA7OcvMRrp81lhSTxERMZ5BTanLPmZHq2dOgEkDjHgVn3Ec1dY2
         7NRA==
X-Forwarded-Encrypted: i=1; AL+hErFKoZKB6cbsyncRHyFzi8sGhpED4KQLt/1G6T1t7Eqen+NQcfxqvPoh5yXlD/yml56j+Ae8YZjYyc8H@vger.kernel.org
X-Gm-Message-State: APuU4Z93vUCCFmbT0fxxFaeb4X1sXVTviI1VCUMp+0XxRd5SMIFl0LSr
	XQjB2mOU0M1tky77G438y5/ib+yrSNlN/syKky2rlrtS4Rh3AdHHKELE
X-Gm-Gg: AZFdTZfuHw/Q9+bPq0xCnVbIsxvX6lHwHJWvRHUWKgY9TwYuh0bdjyoqh61xfqb6jE8
	IaZGSc5s6C9i2vU2CR4umeYjuEzqCC0Sf5aULb8s2MBIATEikazSkKzPEAccl5oC+k1EghfRD+d
	VjLs2W40hWkn1uq98ECmNNlAIm5YS2kT8U7QW4koh+az9Yro7fnQc2E+kUBDYZ5LEVBvOWTdZzA
	ok7DthnbwWlsegDZNB0J5gDCD5DccpYacquP7o2cIgvHH1+Z6CCwbzFcR5N/AwuF+NmQDEPn2SF
	fNltMrLoIoyZnKPvbyXg1tc8iz01UwyDTBJQ4BVTSlJQw5COFIiWO+ndoYs2bU8Gi4Q/X/gXDiF
	zPsI/GnKTj3uDiXvL4dlsc4/FIIwZmEUxJMnF0x0bvIUmjDD+PxO/1p8B6xUbi0l6QgkduvI2Pe
	YKyViDKgfR7YrDaR0hoTWn/hydS6oocKwIIC/un6IxXU7IwlzU5hGsJnd9iDqi9PXq1OWmaULQ5
	W1DN4ZSrLm2hUIsk1QetYmbmQ67AsXDWLO3Pgs0dZgzOmvH8mSHmvpCIqnxf+llCeWu4Ime/Xst
	48jgyYPI4qXAFRzCwwvc4B3sW+ZlKJ/42diwTL3oGIK3vaDqziEBM/E=
X-Received: by 2002:a05:6000:481c:b0:4a5:ebcc:2260 with SMTP id ffacd0b85a97d-4abb2dda518mr20350879f8f.29.1795420250368;
        Sun, 22 Nov 2026 23:50:50 -0800 (PST)
Received: from DESKTOP-V28CTA4.localdomain ([37.111.157.44])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4ab6baa3c4dsm17207033f8f.46.2026.11.22.23.50.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 22 Nov 2026 23:50:49 -0800 (PST)
From: Arbab Haider <arbabhaider649@gmail.com>
To: Theodore Ts'o <tytso@mit.edu>
Cc: Andreas Dilger <adilger.kernel@dilger.ca>,
	Jan Kara <jack@suse.cz>,
	linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org,
	Arbab Haider <arbabhaider649@gmail.com>
Subject: [PATCH v2] ext4: avoid inline data conversion race when !EXT4_STATE_MAY_INLINE_DATA
Date: Mon, 23 Nov 2026 12:48:26 +0500
Message-ID: <20261123074825.63294-2-arbabhaider649@gmail.com>
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

Commit ef09ed5d37b8 ("ext4: fix bug_on in ext4_writepages") attempted to
prevent ext4_convert_inline_data() from racing with delayed-allocation
inline data conversion by calling filemap_flush() when
EXT4_STATE_MAY_INLINE_DATA is already cleared.

However, filemap_flush() is asynchronous (WB_SYNC_NONE) and can return 0
while folio 0 is locked by a concurrent buffered write and
ext4_has_inline_data(inode) is still true.  ext4_convert_inline_data()
then proceeds to ext4_convert_inline_data_nolock() even though
EXT4_STATE_MAY_INLINE_DATA is already cleared (meaning
ext4_da_convert_inline_data_to_extent() has already moved the data into
dirty folio 0).  This causes multiple bugs:

1. If ext4_convert_inline_data_nolock() succeeds, it copies stale
   on-disk inline data into the newly allocated block instead of the
   newer dirty data in folio 0.
2. If ext4_map_blocks() fails (e.g. -ENOSPC or a corrupted block
   bitmap), ext4_destroy_inline_data_nolock() has temporarily cleared
   EXT4_INODE_INLINE_DATA and set EXT4_INODE_EXTENTS before
   ext4_restore_inline_data() restores EXT4_INODE_INLINE_DATA and
   unconditionally re-sets EXT4_STATE_MAY_INLINE_DATA.  This races with
   ext4_do_writepages() and triggers:

     kernel BUG at fs/ext4/inode.c:2949!
     RIP: 0010:ext4_do_writepages+0x25c0/0x39a0
     Call Trace:
      ext4_writepages+0x285/0x500
      do_writepages+0x205/0x520
      filemap_writeback+0x1a6/0x250
      file_write_and_wait_range+0x8c/0x150
      ext4_sync_file+0x2cf/0x950
      ext4_buffered_write_iter+0x428/0x5d0
      ext4_file_write_iter+0x7cb/0x1450

3. A concurrent ext4_da_convert_inline_data_to_extent() can also clear
   EXT4_STATE_MAY_INLINE_DATA between the initial check in
   ext4_convert_inline_data() and acquiring ext4_write_lock_xattr().

Fix this in ext4_convert_inline_data() by:
- Using synchronous filemap_write_and_wait() instead of filemap_flush()
  when !EXT4_STATE_MAY_INLINE_DATA.
- Returning -EIO instead of proceeding to
  ext4_convert_inline_data_nolock() if ext4_has_inline_data(inode) is
  still true after writeback.
- Re-checking EXT4_STATE_MAY_INLINE_DATA under ext4_write_lock_xattr()
  (which serializes against ext4_da_convert_inline_data_to_extent()) and
  retrying via filemap_write_and_wait() if it was cleared concurrently.

Tested locally in QEMU (x86_64, 4 CPUs, KASAN+UBSAN) using a concurrent
mmap + O_SYNC write reproducer on an inline_data ext4 image: hit
kernel BUG at fs/ext4/inode.c:2949 on mount #1 in <1s before the patch,
and completed 32 fresh mount/race iterations in 10s with zero BUG,
WARNING, or KASAN reports after the patch.

Fixes: ef09ed5d37b8 ("ext4: fix bug_on in ext4_writepages")
Cc: stable@vger.kernel.org
Signed-off-by: Arbab Haider <arbabhaider649@gmail.com>
---
Changes in v2:
- Address Sashiko AI review feedback: instead of preserving
  EXT4_STATE_MAY_INLINE_DATA on error in ext4_convert_inline_data_nolock(),
  prevent ext4_convert_inline_data() from calling
  ext4_convert_inline_data_nolock() at all when EXT4_STATE_MAY_INLINE_DATA
  is already cleared (using filemap_write_and_wait(), returning -EIO if
  inline data remains, and re-checking under xattr_sem).
- Fix commit description inaccuracy regarding ext4_create_inline_data().

 fs/ext4/inline.c | 23 +++++++++++++++++++----
 1 file changed, 19 insertions(+), 4 deletions(-)

diff --git a/fs/ext4/inline.c b/fs/ext4/inline.c
index ceee69a66..f644b229e 100644
--- a/fs/ext4/inline.c
+++ b/fs/ext4/inline.c
@@ -1977,6 +1977,7 @@ int ext4_convert_inline_data(struct inode *inode)
 	handle_t *handle;
 	struct ext4_iloc iloc;
 
+retry:
 	if (!ext4_has_inline_data(inode)) {
 		ext4_clear_inode_state(inode, EXT4_STATE_MAY_INLINE_DATA);
 		return 0;
@@ -1984,14 +1985,21 @@ int ext4_convert_inline_data(struct inode *inode)
 		/*
 		 * Inode has inline data but EXT4_STATE_MAY_INLINE_DATA is
 		 * cleared. This means we are in the middle of moving of
-		 * inline data to delay allocated block. Just force writeout
-		 * here to finish conversion.
+		 * inline data to delay allocated block. Force synchronous
+		 * writeout here to finish conversion.
 		 */
-		error = filemap_flush(inode->i_mapping);
+		error = filemap_write_and_wait(inode->i_mapping);
 		if (error)
 			return error;
 		if (!ext4_has_inline_data(inode))
 			return 0;
+		/*
+		 * Writeback did not clear inline data (e.g. filesystem is in
+		 * emergency state). Do not proceed to
+		 * ext4_convert_inline_data_nolock(), which would read stale
+		 * on-disk inline data or race with writeback.
+		 */
+		return -EIO;
 	}
 
 	needed_blocks = ext4_chunk_trans_extent(inode, 1);
@@ -2008,8 +2016,15 @@ int ext4_convert_inline_data(struct inode *inode)
 	}
 
 	ext4_write_lock_xattr(inode, &no_expand);
-	if (ext4_has_inline_data(inode))
+	if (ext4_has_inline_data(inode)) {
+		if (!ext4_test_inode_state(inode, EXT4_STATE_MAY_INLINE_DATA)) {
+			ext4_write_unlock_xattr(inode, &no_expand);
+			ext4_journal_stop(handle);
+			brelse(iloc.bh);
+			goto retry;
+		}
 		error = ext4_convert_inline_data_nolock(handle, inode, &iloc);
+	}
 	ext4_write_unlock_xattr(inode, &no_expand);
 	ext4_journal_stop(handle);
 out_free:
-- 
2.53.0

