From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH 17/18] e2fsck: make insert_dirent_tail more robust
Date: Fri, 25 Jul 2014 17:35:25 -0700
Message-ID: <20140726003524.28334.95739.stgit@birch.djwong.org>
References: <20140726003339.28334.54447.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: tytso@mit.edu, darrick.wong@oracle.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:17417 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752683AbaGZAf2 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 25 Jul 2014 20:35:28 -0400
In-Reply-To: <20140726003339.28334.54447.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Fix the routine that adds dirent checksum structures to the directory
block to handle oddball situations a bit more robustly.

First, when we're walking the entry array, we might encounter an
entry that ends exactly one byte before where the checksum entry needs
to start, i.e. there's space for the tail entry, but it needs to be
reinitialized.  When that happens, we should proceed until d points to
that space so that the tail entry can be initialized.

Second, it's possible that we've been fed a directory block where the
entries end just short of the end of the block.  In this case, we need
to adjust the size of the last entry to point exactly to where the
dirent tail starts.  The current code requires that entries end
exactly on the block boundary, but this is not always the case with
damaged filesystems.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 e2fsck/pass2.c                       |   15 ++++++---------
 tests/f_corrupt_dirent_tail/expect.1 |   16 ++++++++++++++++
 tests/f_corrupt_dirent_tail/expect.2 |    7 +++++++
 tests/f_corrupt_dirent_tail/image.gz |  Bin
 tests/f_corrupt_dirent_tail/name     |    1 +
 5 files changed, 30 insertions(+), 9 deletions(-)
 create mode 100644 tests/f_corrupt_dirent_tail/expect.1
 create mode 100644 tests/f_corrupt_dirent_tail/expect.2
 create mode 100644 tests/f_corrupt_dirent_tail/image.gz
 create mode 100644 tests/f_corrupt_dirent_tail/name


diff --git a/e2fsck/pass2.c b/e2fsck/pass2.c
index 925d1a2..f1299ec 100644
--- a/e2fsck/pass2.c
+++ b/e2fsck/pass2.c
@@ -740,6 +740,7 @@ static int is_last_entry(ext2_filsys fs, int inline_data_size,
 		return (offset < fs->blocksize - csum_size);
 }
 
+#define NEXT_DIRENT(d)	((void *)((char *)(d) + (d)->rec_len))
 static errcode_t insert_dirent_tail(ext2_filsys fs, void *dirbuf)
 {
 	struct ext2_dir_entry *d;
@@ -750,20 +751,15 @@ static errcode_t insert_dirent_tail(ext2_filsys fs, void *dirbuf)
 	d = dirbuf;
 	top = EXT2_DIRENT_TAIL(dirbuf, fs->blocksize);
 
-	rec_len = d->rec_len;
-	while (rec_len && !(rec_len & 0x3)) {
-		d = (struct ext2_dir_entry *)(((char *)d) + rec_len);
-		if (((void *)d) + d->rec_len >= top)
-			break;
-		rec_len = d->rec_len;
-	}
+	while (d->rec_len && !(d->rec_len & 0x3) && NEXT_DIRENT(d) <= top)
+		d = NEXT_DIRENT(d);
 
 	if (d != top) {
 		size_t min_size = EXT2_DIR_REC_LEN(
 				ext2fs_dirent_name_len(dirbuf));
-		if (min_size > d->rec_len - sizeof(struct ext2_dir_entry_tail))
+		if (min_size > top - (void *)d)
 			return EXT2_ET_DIR_NO_SPACE_FOR_CSUM;
-		d->rec_len -= sizeof(struct ext2_dir_entry_tail);
+		d->rec_len = top - (void *)d;
 	}
 
 	t = (struct ext2_dir_entry_tail *)top;
@@ -774,6 +770,7 @@ static errcode_t insert_dirent_tail(ext2_filsys fs, void *dirbuf)
 
 	return 0;
 }
+#undef NEXT_DIRENT
 
 static int check_dir_block(ext2_filsys fs,
 			   struct ext2_db_entry2 *db,
diff --git a/tests/f_corrupt_dirent_tail/expect.1 b/tests/f_corrupt_dirent_tail/expect.1
new file mode 100644
index 0000000..0813755
--- /dev/null
+++ b/tests/f_corrupt_dirent_tail/expect.1
@@ -0,0 +1,16 @@
+Pass 1: Checking inodes, blocks, and sizes
+Pass 2: Checking directory structure
+Directory inode 2, block #0, offset 0: directory has no checksum.
+Fix? yes
+
+Directory inode 2, block #0, offset 1012: directory corrupted
+Salvage? yes
+
+Pass 3: Checking directory connectivity
+Pass 3A: Optimizing directories
+Pass 4: Checking reference counts
+Pass 5: Checking group summary information
+
+test_filesys: ***** FILE SYSTEM WAS MODIFIED *****
+test_filesys: 11/128 files (9.1% non-contiguous), 1090/2048 blocks
+Exit status is 1
diff --git a/tests/f_corrupt_dirent_tail/expect.2 b/tests/f_corrupt_dirent_tail/expect.2
new file mode 100644
index 0000000..c42466d
--- /dev/null
+++ b/tests/f_corrupt_dirent_tail/expect.2
@@ -0,0 +1,7 @@
+Pass 1: Checking inodes, blocks, and sizes
+Pass 2: Checking directory structure
+Pass 3: Checking directory connectivity
+Pass 4: Checking reference counts
+Pass 5: Checking group summary information
+test_filesys: 11/128 files (9.1% non-contiguous), 1090/2048 blocks
+Exit status is 0
diff --git a/tests/f_corrupt_dirent_tail/image.gz b/tests/f_corrupt_dirent_tail/image.gz
new file mode 100644
index 0000000000000000000000000000000000000000..f2753080fbe81ae0ae09fb62cc9f177810694f3b
GIT binary patch
literal 2685
zcmb2|=3odBS`^I0{PynoY?)9Qh7a%0<lLT-Gy6!_S;d46a$HjbL|8XAnJMh7$S8X6
z*~MyjLE?kT>f^5*c~+=ToYV5{!NJ)|8!t51H^k}4Et&F7L2&ZqjO*ssyG`uFqC0kF
zKKsmhe`e*$H|Of&pZzZLd+*9ndR5EZS@8Mgce9m}G~aGMtL_te@s(MB@A@<DTW){O
zj(omnRqV^Xc}s3v%q<K5+`--3(YanMEb9E3Gh6%qe0conSbqIK^P4^Iew@9q>~Z#b
z+rO``&p$VBcgfes#qaGuzO9b@mSpmIcO~z7@ryS~>hAg4zu))yqsU{;YeDvBzwiBb
zW7@TpUnhUfxq4!iU8AE_!S6T8{LBA7)|~h1%KxBU*H=q_zVtrcNAKwL_y6u@=f_LT
zz1Ylv3O>BgcrSP};ZpwAg~v|q%$+sy>E*z)#g}_*=FeOA?8DADp6BcJb@o+$`g7=#
z^m-}n#QnAJ`*T+Rk9H0Hf8gKMo*yrN8<($}eq6fsU&F4e|DPV6tbWCQMZLpc=2!9o
z{~La>U$I~CkMS%2iuwl!SO35IeEx40)7`5B&8ylYUG6Vk{d?`>xi5VgDmHB4&&_7u
zn#jU};<|>t&u{!VRipoJefGbPPab^!_jKtCpUN%9{}*kRD>@R8ZoOyTS2fR98tS%I
zyH01{|7nwCw5jv$|Mp#XiskFV-p{Ij9kBOv{kPVt=k>{jALcLo>UV2SmPuJ(eWcIZ
zPkW!g`}qB7_tPKWKeIQ>{I~jfJmSmg{ZhZGAJ=b8{iDBMdfBeu7e$T-_biXlR(faN
z7#@}SuU&ra>mUEW9jv<kf9lPH^=(%_{d^v>|M`3ywSNzPE}!{mVr<;+r|(bw{=ay3
z>E8d0D4s#(H0)jP5xDMcm4fR|mHeGLl{;U(cGheQ?s3_A@AX3w_eD|fD|A+U?ZamT
ms)3`t(GVC7fzc2c4S~@R7!3jXgg}D*Pj0pYQjrV{3Jd^J4vVh<

literal 0
HcmV?d00001

diff --git a/tests/f_corrupt_dirent_tail/name b/tests/f_corrupt_dirent_tail/name
new file mode 100644
index 0000000..08259a3
--- /dev/null
+++ b/tests/f_corrupt_dirent_tail/name
@@ -0,0 +1 @@
+rebuild a directory with corrupt dirent tail

