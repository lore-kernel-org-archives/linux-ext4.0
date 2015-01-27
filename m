From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH 19/54] e2fsck: salvage under-sized dirents by removing them
Date: Mon, 26 Jan 2015 23:37:37 -0800
Message-ID: <20150127073737.13308.74557.stgit@birch.djwong.org>
References: <20150127073533.13308.44994.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: tytso@mit.edu, darrick.wong@oracle.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:46093 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753650AbbA0Hhm (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 27 Jan 2015 02:37:42 -0500
In-Reply-To: <20150127073533.13308.44994.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

If the directory processing code ends up pointing to a directory entry
that's so close to the end of the block that there's not even space
for a rec_len/name_len, just substitute dummy values that will force
e2fsck to extend the previous entry to cover the remaining space.  We
can't use the helper methods to extract rec_len because that's reading
off the end of the buffer.

This isn't an issue with non-inline directories because the directory
check buffer is zero-extended so that fsck won't blow up.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 e2fsck/pass2.c                       |   49 +++++++++++++++++++++++-----------
 lib/ext2fs/ext2_fs.h                 |    5 +++
 tests/f_trunc_dirent_header/expect.1 |   15 ++++++++++
 tests/f_trunc_dirent_header/expect.2 |    7 +++++
 tests/f_trunc_dirent_header/image.gz |  Bin
 tests/f_trunc_dirent_header/name     |    1 +
 6 files changed, 60 insertions(+), 17 deletions(-)
 create mode 100644 tests/f_trunc_dirent_header/expect.1
 create mode 100644 tests/f_trunc_dirent_header/expect.2
 create mode 100644 tests/f_trunc_dirent_header/image.gz
 create mode 100644 tests/f_trunc_dirent_header/name


diff --git a/e2fsck/pass2.c b/e2fsck/pass2.c
index 26db2e6..78bc24e 100644
--- a/e2fsck/pass2.c
+++ b/e2fsck/pass2.c
@@ -672,18 +672,29 @@ static void salvage_directory(ext2_filsys fs,
 	char	*cp = (char *) dirent;
 	int left;
 	unsigned int rec_len, prev_rec_len;
-	unsigned int name_len = ext2fs_dirent_name_len(dirent);
+	unsigned int name_len;
 
-	(void) ext2fs_get_rec_len(fs, dirent, &rec_len);
+	/*
+	 * If the space left for the entry is too small to be an entry,
+	 * we can't access dirent's fields, so plumb in the values needed
+	 * so that the previous entry absorbs this one.
+	 */
+	if (block_len - *offset < EXT2_DIR_ENTRY_HEADER_LEN) {
+		name_len = 0;
+		rec_len = block_len - *offset;
+	} else {
+		name_len = ext2fs_dirent_name_len(dirent);
+		(void) ext2fs_get_rec_len(fs, dirent, &rec_len);
+	}
 	left = block_len - *offset - rec_len;
 
 	/*
 	 * Special case of directory entry of size 8: copy what's left
 	 * of the directory block up to cover up the invalid hole.
 	 */
-	if ((left >= 12) && (rec_len == 8)) {
-		memmove(cp, cp+8, left);
-		memset(cp + left, 0, 8);
+	if ((left >= 12) && (rec_len == EXT2_DIR_ENTRY_HEADER_LEN)) {
+		memmove(cp, cp+EXT2_DIR_ENTRY_HEADER_LEN, left);
+		memset(cp + left, 0, EXT2_DIR_ENTRY_HEADER_LEN);
 		return;
 	}
 	/*
@@ -692,8 +703,8 @@ static void salvage_directory(ext2_filsys fs,
 	 * record length.
 	 */
 	if ((left < 0) &&
-	    ((int) rec_len + left > 8) &&
-	    ((int) name_len + 8 <= (int) rec_len + left) &&
+	    ((int) rec_len + left > EXT2_DIR_ENTRY_HEADER_LEN) &&
+	    ((int) name_len + EXT2_DIR_ENTRY_HEADER_LEN <= (int) rec_len + left) &&
 	    dirent->inode <= fs->super->s_inodes_count &&
 	    strnlen(dirent->name, name_len) == name_len) {
 		(void) ext2fs_set_rec_len(fs, (int) rec_len + left, dirent);
@@ -928,6 +939,7 @@ static int check_dir_block(ext2_filsys fs,
 
 	ehandler_operation(_("reading directory block"));
 	if (inline_data_size) {
+		memset(buf, 0, fs->blocksize - inline_data_size);
 		cd->pctx.errcode = ext2fs_inline_data_get(fs, ino, 0, buf, 0);
 		if (cd->pctx.errcode)
 			goto inline_read_fail;
@@ -1081,15 +1093,20 @@ skip_checksum:
 		problem = 0;
 		if (!inline_data_size || dot_state > 1) {
 			dirent = (struct ext2_dir_entry *) (buf + offset);
-			(void) ext2fs_get_rec_len(fs, dirent, &rec_len);
+			/*
+			 * If there's not even space for the entry header,
+			 * force salvaging this dir.
+			 */
+			if (max_block_size - offset < EXT2_DIR_ENTRY_HEADER_LEN)
+				rec_len = EXT2_DIR_REC_LEN(1);
+			else
+				(void) ext2fs_get_rec_len(fs, dirent, &rec_len);
 			cd->pctx.dirent = dirent;
 			cd->pctx.num = offset;
-			if (((offset + rec_len) > fs->blocksize) ||
-			    (inline_data_size > 0 &&
-			     (offset + rec_len) > inline_data_size) ||
+			if ((offset + rec_len > max_block_size) ||
 			    (rec_len < 12) ||
 			    ((rec_len % 4) != 0) ||
-			    ((ext2fs_dirent_name_len(dirent) + 8) > rec_len)) {
+			    ((ext2fs_dirent_name_len(dirent) + EXT2_DIR_ENTRY_HEADER_LEN) > rec_len)) {
 				if (fix_problem(ctx, PR_2_DIR_CORRUPTED,
 						&cd->pctx)) {
 #ifdef WORDS_BIGENDIAN
@@ -1098,7 +1115,7 @@ skip_checksum:
 					 * swap routine finds a rec_len that it
 					 * doesn't like, it continues
 					 * processing the block as if rec_len
-					 * == 8.  This means that the name
+					 * == EXT2_DIR_ENTRY_HEADER_LEN.  This means that the name
 					 * field gets byte swapped, which means
 					 * that salvage will not detect the
 					 * correct name length (unless the name
@@ -1112,11 +1129,11 @@ skip_checksum:
 					 * the salvaged dirent.
 					 */
 					int need_reswab = 0;
-					if (rec_len < 8 || rec_len % 4) {
+					if (rec_len < EXT2_DIR_ENTRY_HEADER_LEN || rec_len % 4) {
 						need_reswab = 1;
 						ext2fs_dirent_swab_in2(fs,
-							((char *)dirent) + 8,
-							max_block_size - offset - 8,
+							((char *)dirent) + EXT2_DIR_ENTRY_HEADER_LEN,
+							max_block_size - offset - EXT2_DIR_ENTRY_HEADER_LEN,
 							0);
 					}
 #endif
diff --git a/lib/ext2fs/ext2_fs.h b/lib/ext2fs/ext2_fs.h
index 953cbc4..10cb650 100644
--- a/lib/ext2fs/ext2_fs.h
+++ b/lib/ext2fs/ext2_fs.h
@@ -875,9 +875,12 @@ struct ext2_dir_entry_tail {
  *
  * NOTE: It must be a multiple of 4
  */
+#define EXT2_DIR_ENTRY_HEADER_LEN	8
 #define EXT2_DIR_PAD			4
 #define EXT2_DIR_ROUND			(EXT2_DIR_PAD - 1)
-#define EXT2_DIR_REC_LEN(name_len)	(((name_len) + 8 + EXT2_DIR_ROUND) & \
+#define EXT2_DIR_REC_LEN(name_len)	(((name_len) + \
+					  EXT2_DIR_ENTRY_HEADER_LEN + \
+					  EXT2_DIR_ROUND) & \
 					 ~EXT2_DIR_ROUND)
 
 /*
diff --git a/tests/f_trunc_dirent_header/expect.1 b/tests/f_trunc_dirent_header/expect.1
new file mode 100644
index 0000000..33ce473
--- /dev/null
+++ b/tests/f_trunc_dirent_header/expect.1
@@ -0,0 +1,15 @@
+Pass 1: Checking inodes, blocks, and sizes
+Pass 2: Checking directory structure
+Directory inode 15, block #0, offset 4092: directory corrupted
+Salvage? yes
+
+Directory inode 13, block #1, offset 28: directory corrupted
+Salvage? yes
+
+Pass 3: Checking directory connectivity
+Pass 4: Checking reference counts
+Pass 5: Checking group summary information
+
+test_filesys: ***** FILE SYSTEM WAS MODIFIED *****
+test_filesys: 32/128 files (0.0% non-contiguous), 18/512 blocks
+Exit status is 1
diff --git a/tests/f_trunc_dirent_header/expect.2 b/tests/f_trunc_dirent_header/expect.2
new file mode 100644
index 0000000..df81c9d
--- /dev/null
+++ b/tests/f_trunc_dirent_header/expect.2
@@ -0,0 +1,7 @@
+Pass 1: Checking inodes, blocks, and sizes
+Pass 2: Checking directory structure
+Pass 3: Checking directory connectivity
+Pass 4: Checking reference counts
+Pass 5: Checking group summary information
+test_filesys: 32/128 files (0.0% non-contiguous), 18/512 blocks
+Exit status is 0
diff --git a/tests/f_trunc_dirent_header/image.gz b/tests/f_trunc_dirent_header/image.gz
new file mode 100644
index 0000000000000000000000000000000000000000..9c59bf4a9e4e7fa07d501e4445a55d872a2e4715
GIT binary patch
literal 2873
zcmb2|=3sa(cRYlN`R$#v{xYdD>>tvXO%PhZn%VvI>ao>rGb$cFVDvxsYHhVp?t%+h
z-if!j^sW%kx^yW(?;rP9{SQe=UoKQUe0DQCf8UYm$GX{tYtqWyrS9C?!o>f!#_owZ
z|KT&wroXp2{p@C{6Nf|ST9Mf{EekFF%xX2b{HyZbs$-nmYd<eKf80DvF(+@{FJ11B
zUkZwr+{ix_mF%CLZp3%LPU?_);huu^)rG%qNiPrEKmX^W<LjsG_nY|jL;2U=^XJz7
ze)@HOe`#r4<>$3JKCSomRK7VVW1VVJmzrC5PjL0+V19-MmaeDo9oC3Tzy3ed;6}t;
zv$HMlzQ-ssFfdg7$}KBx+0XZ<|2Q*{`#bLA_y6}MJQZG8sqc_~;&W%`Guu7x&gFF*
z>z=;ye*WtEv}fJPy~Uf23vI4c-N}*pom6{y`qN@NKSl<IhT4_S72p5ow*Ruz4rtVe
zGcU?Hf%Jjj^+57LX4sua_uu{d|46yf{_y*scNXi|PwfA;`uVDvzaKYdJ)376boNeq
zUzqXtI~##K`88?pHlGhS{=W0^)iZzp1(+7s8^oNw^V}V%{7{Bzv3^ge@%N)2v!2D(
zES$A-y5EsIpC8Vx*%&u}b^Q)$-C6(7^8@W92Fzofeeqi@Q00T0kAww?(Sbva-0_nW
zd!r&lPyIdpy72OSz54VQSv_ZSzspCysCZBqxrW*LLj9JrHWg+})rn85?%bK1_4(KI
zt#Lo+#hl;v_snbgH`?XhU(aj5y=Gr&@lXEs{G_*+H@<#7|IhNf=l(za`YfWm_O#aL
z?O)!f{eSy2`}U`DnK?hx-`~5nI<fBCt2ch@>+knIE_oAu?HW)1Q~h<v9!5+~)QGQ}
zA$!99@A^N%z3=^w?AmX(^~;W*)zY?Xn~we}JDcqK@A{((t8coi@BWd`dh7G<)1Uc%
z2LD|T9oz`?$5~}}xu5@@KhS$}|J8o;{r{i-;Xl4Fb?fZ^`)p_Zf4Fh){QpY-e|`ii
z)cl<P_5STY+#B<OOnsG8`z3x)n`-nwY0)2Vh>+^3`2O0{UNiUW)ld2}J?Z|YplAE1
zX#9VAWBZyZKlRm5)hmC~)lU5<-TCQ$4@lkrv_*ebgSD<#J5{d@mW=NFwEpP6)TL+k
zPt*AS7OXR0{nUOruvJxy{**(E-F*BfFddG9(GVC7fzc2c4S~@R7!3hxhrp^=`8(bu
KePv)!U;qGw8T+09

literal 0
HcmV?d00001

diff --git a/tests/f_trunc_dirent_header/name b/tests/f_trunc_dirent_header/name
new file mode 100644
index 0000000..e244dbf
--- /dev/null
+++ b/tests/f_trunc_dirent_header/name
@@ -0,0 +1 @@
+no space for dirent header at end of buf

