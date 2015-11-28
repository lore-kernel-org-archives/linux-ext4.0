From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH] e2fsck: zap extent-format inode with no extent header
Date: Sat, 28 Nov 2015 13:51:32 -0800
Message-ID: <20151128215132.GD10580@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Bo Branten <bosse@acc.umu.se>, linux-ext4@vger.kernel.org
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:35127 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751968AbbK1Vvl (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 28 Nov 2015 16:51:41 -0500
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

The kernel requires all inodes with the extent flag set to have a
valid extent tree header in i_block.  The ext2fs_extent_open2 prefers
to initialize the header if i_block is zeroed, but e2fsck never writes
the new header to disk.  Since the kernel won't create inodes with the
flag and no header anyway, zap such files.

Reported-by: Bo Branten <bosse@acc.umu.se>
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 e2fsck/pass1.c                     |   13 +++++++++++++
 e2fsck/problem.c                   |    5 +++++
 e2fsck/problem.h                   |    3 +++
 tests/f_extents/expect.1           |    3 +--
 tests/f_zeroed_ext_header/expect.1 |   22 ++++++++++++++++++++++
 tests/f_zeroed_ext_header/expect.2 |    7 +++++++
 tests/f_zeroed_ext_header/image.gz |  Bin
 tests/f_zeroed_ext_header/name     |    1 +
 8 files changed, 52 insertions(+), 2 deletions(-)
 create mode 100644 tests/f_zeroed_ext_header/expect.1
 create mode 100644 tests/f_zeroed_ext_header/expect.2
 create mode 100644 tests/f_zeroed_ext_header/image.gz
 create mode 100644 tests/f_zeroed_ext_header/name

diff --git a/e2fsck/pass1.c b/e2fsck/pass1.c
index 0a8e23e..bc986c9 100644
--- a/e2fsck/pass1.c
+++ b/e2fsck/pass1.c
@@ -2820,7 +2820,20 @@ static void check_blocks_extents(e2fsck_t ctx, struct problem_context *pctx,
 	ext2_ino_t		ino = pctx->ino;
 	errcode_t		retval;
 	blk64_t                 eof_lblk;
+	struct ext3_extent_header	*eh;
 
+	/* Check for a proper extent header... */
+	eh = (struct ext3_extent_header *) &inode->i_block[0];
+	retval = ext2fs_extent_header_verify(eh, sizeof(inode->i_block));
+	if (retval) {
+		if (fix_problem(ctx, PR_1_MISSING_EXTENT_HEADER, pctx))
+			e2fsck_clear_inode(ctx, ino, inode, 0,
+					   "check_blocks_extents");
+		pctx->errcode = 0;
+		return;
+	}
+
+	/* ...since this function doesn't fail if i_block is zeroed. */
 	pctx->errcode = ext2fs_extent_open2(fs, ino, inode, &ehandle);
 	if (pctx->errcode) {
 		if (fix_problem(ctx, PR_1_READ_EXTENT, pctx))
diff --git a/e2fsck/problem.c b/e2fsck/problem.c
index 6a35e93..971b0ad 100644
--- a/e2fsck/problem.c
+++ b/e2fsck/problem.c
@@ -1119,6 +1119,11 @@ static struct e2fsck_problem problem_table[] = {
 	  N_("@i %i on bigalloc @f cannot be @b mapped.  "),
 	  PROMPT_FIX, 0 },
 
+	/* Inode has corrupt extent header */
+	{ PR_1_MISSING_EXTENT_HEADER,
+	  N_("@i %i has corrupt @x header.  "),
+	  PROMPT_CLEAR_INODE, 0 },
+
 	/* Pass 1b errors */
 
 	/* Pass 1B: Rescan for duplicate/bad blocks */
diff --git a/e2fsck/problem.h b/e2fsck/problem.h
index 943024b..bc1a5d5 100644
--- a/e2fsck/problem.h
+++ b/e2fsck/problem.h
@@ -654,6 +654,9 @@ struct problem_context {
 /* bigalloc fs cannot have blockmap files */
 #define PR_1_NO_BIGALLOC_BLOCKMAP_FILES		0x010080
 
+/* missing extent header */
+#define PR_1_MISSING_EXTENT_HEADER		0x010081
+
 /*
  * Pass 1b errors
  */
diff --git a/tests/f_extents/expect.1 b/tests/f_extents/expect.1
index e9d9e5b..da65f94 100644
--- a/tests/f_extents/expect.1
+++ b/tests/f_extents/expect.1
@@ -27,8 +27,7 @@ Inode 17 extent tree (at level 1) could be shorter.  Fix? yes
 
 Inode 17, i_blocks is 32, should be 0.  Fix? yes
 
-Error while reading over extent tree in inode 18: Corrupt extent header
-Clear inode? yes
+Inode 18 has corrupt extent header.  Clear inode? yes
 
 Inode 18, i_blocks is 2, should be 0.  Fix? yes
 
diff --git a/tests/f_zeroed_ext_header/expect.1 b/tests/f_zeroed_ext_header/expect.1
new file mode 100644
index 0000000..2613e9f
--- /dev/null
+++ b/tests/f_zeroed_ext_header/expect.1
@@ -0,0 +1,22 @@
+Pass 1: Checking inodes, blocks, and sizes
+Inode 12 has corrupt extent header.  Clear inode? yes
+
+Pass 2: Checking directory structure
+Entry 'testa' in / (2) has deleted/unused inode 12.  Clear? yes
+
+Pass 3: Checking directory connectivity
+Pass 4: Checking reference counts
+Pass 5: Checking group summary information
+Inode bitmap differences:  -12
+Fix? yes
+
+Free inodes count wrong for group #0 (115, counted=116).
+Fix? yes
+
+Free inodes count wrong (115, counted=116).
+Fix? yes
+
+
+test_filesys: ***** FILE SYSTEM WAS MODIFIED *****
+test_filesys: 12/128 files (0.0% non-contiguous), 15/256 blocks
+Exit status is 1
diff --git a/tests/f_zeroed_ext_header/expect.2 b/tests/f_zeroed_ext_header/expect.2
new file mode 100644
index 0000000..177288f
--- /dev/null
+++ b/tests/f_zeroed_ext_header/expect.2
@@ -0,0 +1,7 @@
+Pass 1: Checking inodes, blocks, and sizes
+Pass 2: Checking directory structure
+Pass 3: Checking directory connectivity
+Pass 4: Checking reference counts
+Pass 5: Checking group summary information
+test_filesys: 12/128 files (0.0% non-contiguous), 15/256 blocks
+Exit status is 0
diff --git a/tests/f_zeroed_ext_header/image.gz b/tests/f_zeroed_ext_header/image.gz
new file mode 100644
index 0000000000000000000000000000000000000000..67a43341680f578cddb53f54ff7702887dbff384
GIT binary patch
literal 1447
zcmb2|=3o$(j|yXAetXw2TR2dL;X`?N>kKz(Z^1b^>YCHe^o6qAm0?+$7xp+r+H2hf
zM}xmSuWtD6Z<xQJd3N{W*=a)UN{gy%rti++U}aC1zI>nm-}_HRKy-ZmaoZi!TNvhq
z%-!SRwBqR5?GkT4{oT@2*X(yw&+5mHGIQR&_vWtmtc&;|^Sb%G*QvKTl{c<RTu(l8
z<i>8B|G!S}ojuij{=4(_6}z?;$vm%m_;mN@?bq`1_e9)yWfLD&IlumX)Xw}LHpet4
zCNVJhOxUu=-u~+T|M}wI|1dBx90+-7`}=SmkoDky`N<l2AY<9xgnRSX*UKIWw5u;D
z&=vc-=>O6@!K3qL21sUwe_X-#-yz*x?Dy*SC-tAMTb7qC$<zJu<mUO~^RFI0w%<gD
zZ>zQNVyUkCW-EF({tw@Mber7qz1@bd?%w}dE}|TNum0ZUBFk@j<?f&NYplLM`JdFr
zhcR~QwLoi;z%jl5`}aqATspS?dgiSRk=HTePNsJ=wr<w$kG?&-zpHfp*8;1Pv);aO
zELJ~#-F*LC?N_fi?yFe*wcxjBv2k{a^-OPWplQO%WhwvuC$F3FpBcytUiMB1NHzSl
p2a*Z@_<<w{$Sg0N4q=UwqaiRF0z)wb9=QDGRO%~w&%hwS004O^>~R19

literal 0
HcmV?d00001

diff --git a/tests/f_zeroed_ext_header/name b/tests/f_zeroed_ext_header/name
new file mode 100644
index 0000000..31394cf
--- /dev/null
+++ b/tests/f_zeroed_ext_header/name
@@ -0,0 +1 @@
+zap inode with zeroed extent header
