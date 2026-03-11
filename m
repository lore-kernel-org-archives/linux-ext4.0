Received: from outgoing.mit.edu (outgoing-auth-1.mit.edu [18.9.28.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1CA89331203
	for <linux-ext4@vger.kernel.org>; Wed, 11 Mar 2026 14:12:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=18.9.28.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773238338; cv=none; b=PWX470a2mTQzYHgU8kW4hF5Ms9BfvYkdQAD06yGVDnQkc2fcGejDqHvKSs+UWLaT0TjsLs2hmoTxcyT7IW/kGzJX4sdQsa6RXBmlZHSFhrzEDheQ2+GM1i6hFHKCVQAFM6TytV+TTcYz+t2YY+CrcReMoxGLj6ol3mt+zz8Lk80=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773238338; c=relaxed/simple;
	bh=sbi8PiBmxZrygGAaf16ycgK96+2JscyHa2Wp90VuFKg=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=idhs9Plu8a1EpEQ5maktElE3X2Kr/Jzp51jbrrT1cgUqkt8IW5IOECxRrHDTUW4JGbBwyZLEBbFybjyBCDHIsWs7152jgCyVofq8/GNULyxStwKCNXUMOxdQp81X9w8e869H5ULA3VQDYapVbuwtH6Xw6UnFQqpo8IKDN1mxZ+w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu; spf=pass smtp.mailfrom=mit.edu; dkim=pass (2048-bit key) header.d=mit.edu header.i=@mit.edu header.b=ABIEUYaT; arc=none smtp.client-ip=18.9.28.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mit.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=mit.edu header.i=@mit.edu header.b="ABIEUYaT"
Received: from trampoline.thunk.org (pool-173-48-111-151.bstnma.fios.verizon.net [173.48.111.151])
	(authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
	by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 62BEBwrJ028692
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 11 Mar 2026 10:12:00 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mit.edu; s=outgoing;
	t=1773238320; bh=RLnZyyR9hVnNc5UaXakGClmv+GZYeFYucUHPcTXGv64=;
	h=From:Subject:Date:Message-ID:MIME-Version;
	b=ABIEUYaTMJL3xLpjayRFxkXV6sQYLVZVSYPUT8Py8dV5+ZSkKqJEu6DvEftl5g9FZ
	 WRFv6r70zgJNeLjZXfn9sR9mnzvmKk85WbrUFdIqOWhYeK8N4d8XgMdLYkl0ISramG
	 PG4IOafM06lyMVB1ss/w4roM3uIY66n2ay63x3mBhw9NaLKBSG1Ti6YP89GrnonWUV
	 iQPxvgNe0fbGxo8vYF/AH4qZk7YbxGnpSV99F7CFFnfqdlMHhJkTwjoQlXTp63j0cs
	 VV3h4YlyhmhiRfrehjERUlQU1w8pFAmD6iTzYDvQm6rylecbjIlRf+aoiws8Lxv4mP
	 a5dYz0nwuwnzg==
Received: by trampoline.thunk.org (Postfix, from userid 15806)
	id 9DEBA2E00D6; Wed, 11 Mar 2026 10:11:58 -0400 (EDT)
From: "Theodore Ts'o" <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Cc: Baokun Li <libaokun@linux.alibaba.com>, "Theodore Ts'o" <tytso@mit.edu>
Subject: [PATCH] Fix default orphan file size calculations
Date: Wed, 11 Mar 2026 10:11:50 -0400
Message-ID: <20260311141150.120724-1-tytso@mit.edu>
X-Mailer: git-send-email 2.51.0
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Due to missing parenthesis around the #defines for
EXT4_{MAX,DEFAULT}_ORPHAN_FILE_SIZE, the default number of blocks
assigned to the orphan file was calculated as 2 when the file system
has more than 2**21 blocks:

   % mke2fs  -t ext4 -Fq /tmp/foo.img 8191M
   /tmp/foo.img contains a ext4 file system
           created on Wed Mar 11 09:54:04 2026
   % debugfs -R "extents <12>" /tmp/foo.img
   debugfs 1.47.4 (6-Mar-2025)
   Level Entries       Logical          Physical Length Flags
    0/ 0   1/  1     0 -   510    9255 -    9765    511

   % mke2fs  -t ext4 -Fq /tmp/foo.img 8192M
   /tmp/foo.img contains a ext4 file system
           created on Wed Mar 11 09:54:11 2026
   % debugfs -R "extents <12>" /tmp/foo.img
   debugfs 1.47.4 (6-Mar-2025)
   Level Entries       Logical          Physical Length Flags
    0/ 0   1/  1     0 -     1    9255 -    9256      2  <======

In addition, looking at how the defaults was calculated, there were
some unit mismatches where number of blocks was compared with number
of bytes, and number of blocks divided by the blocksize.  As a result,
the number of blocks was much larger than before when the file system
blocksize was 1k, and much smaller than when the file system was 64k,
which was a bit surprising.

This caused a libblockdev regression test to fail when it created an
ext4 file system using a 1k blocksize and had a size of 138240k.
Before e2fsprogs 1.47.4, the size of the orphan file was 33k; but in
e2fsprogs 1.47.4, the size of the orphan file became 135k.  This
pushed the overhead just over 10%, which triggered the test failure.

So simplify the calculation so that default of the orphan file ranges
from 32 file system blocks and EXT4_DEFAULT_ORPHAN_SIZE, and avoids
the use of the file system blocksize.

Fixes: 6f03c698ef53 ("libext2fs: fix orphan file size > kernel limit with large blocksize")
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
---
 lib/ext2fs/ext2fs.h |  4 ++--
 lib/ext2fs/orphan.c | 12 ++++++------
 2 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/lib/ext2fs/ext2fs.h b/lib/ext2fs/ext2fs.h
index d9df007c4..92da4d140 100644
--- a/lib/ext2fs/ext2fs.h
+++ b/lib/ext2fs/ext2fs.h
@@ -1819,8 +1819,8 @@ errcode_t ext2fs_set_data_io(ext2_filsys fs, io_channel new_io);
 errcode_t ext2fs_rewrite_to_io(ext2_filsys fs, io_channel new_io);
 
 /* orphan.c */
-#define EXT4_MAX_ORPHAN_FILE_SIZE	8 << 20
-#define EXT4_DEFAULT_ORPHAN_FILE_SIZE	2 << 20
+#define EXT4_MAX_ORPHAN_FILE_SIZE	(8 << 20)
+#define EXT4_DEFAULT_ORPHAN_FILE_SIZE	(2 << 20)
 extern errcode_t ext2fs_create_orphan_file(ext2_filsys fs, blk_t num_blocks);
 extern errcode_t ext2fs_truncate_orphan_file(ext2_filsys fs);
 extern e2_blkcnt_t ext2fs_default_orphan_file_blocks(ext2_filsys fs);
diff --git a/lib/ext2fs/orphan.c b/lib/ext2fs/orphan.c
index 40b1c5c72..b894f2468 100644
--- a/lib/ext2fs/orphan.c
+++ b/lib/ext2fs/orphan.c
@@ -218,18 +218,18 @@ out:
 
 /*
  * Find reasonable size for orphan file. We choose orphan file size to be
- * between 32 filesystem blocks and EXT4_DEFAULT_ORPHAN_FILE_SIZE, and not
- * more than 1/fs->blocksize of the filesystem unless it is really small.
+ * between 32 filesystem blocks and EXT4_DEFAULT_ORPHAN_FILE_SIZE.
  */
 e2_blkcnt_t ext2fs_default_orphan_file_blocks(ext2_filsys fs)
 {
 	__u64 num_blocks = ext2fs_blocks_count(fs->super);
-	e2_blkcnt_t blks = EXT4_DEFAULT_ORPHAN_FILE_SIZE / fs->blocksize;
+	e2_blkcnt_t blks = num_blocks / 4096;
+	e2_blkcnt_t max_blks = EXT4_DEFAULT_ORPHAN_FILE_SIZE / fs->blocksize;
 
-	if (num_blocks < 128 * 1024)
+	if (blks < 32)
 		blks = 32;
-	else if (num_blocks < EXT4_DEFAULT_ORPHAN_FILE_SIZE)
-		blks = num_blocks / fs->blocksize;
+	if (blks > max_blks)
+		blks = max_blks;
 	return (blks + EXT2FS_CLUSTER_MASK(fs)) & ~EXT2FS_CLUSTER_MASK(fs);
 }
 
-- 
2.51.0

