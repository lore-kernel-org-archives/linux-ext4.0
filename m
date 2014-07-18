From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH 21/24] e2fsck: clear uninit flag on directory extents
Date: Fri, 18 Jul 2014 15:55:21 -0700
Message-ID: <20140718225521.31374.49277.stgit@birch.djwong.org>
References: <20140718225200.31374.85411.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: tytso@mit.edu, darrick.wong@oracle.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:33706 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755425AbaGRWzb (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 18 Jul 2014 18:55:31 -0400
In-Reply-To: <20140718225200.31374.85411.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Directories can't have uninitialized extents, so offer to clear the
uninit flag when we find this situation.  The actual directory blocks
will be checked in pass 2 and 3 regardless of the uninit flag.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 e2fsck/pass1.c              |   16 ++++++++++++++++
 e2fsck/problem.c            |    5 +++++
 e2fsck/problem.h            |    3 +++
 tests/f_uninit_dir/expect.1 |   27 +++++++++++++++++++++++++++
 tests/f_uninit_dir/expect.2 |    7 +++++++
 tests/f_uninit_dir/image.gz |  Bin
 tests/f_uninit_dir/name     |    1 +
 7 files changed, 59 insertions(+)
 create mode 100644 tests/f_uninit_dir/expect.1
 create mode 100644 tests/f_uninit_dir/expect.2
 create mode 100644 tests/f_uninit_dir/image.gz
 create mode 100644 tests/f_uninit_dir/name


diff --git a/e2fsck/pass1.c b/e2fsck/pass1.c
index b478bca..1895ee4 100644
--- a/e2fsck/pass1.c
+++ b/e2fsck/pass1.c
@@ -2009,6 +2009,22 @@ static void scan_extent_node(e2fsck_t ctx, struct problem_context *pctx,
 			  (1 << (21 - ctx->fs->super->s_log_block_size))))
 			problem = PR_1_TOOBIG_DIR;
 
+		/*
+		 * Uninitialized blocks in a directory?  Clear the flag and
+		 * we'll interpret the blocks later.
+		 */
+		if (try_repairs && is_dir && problem == 0 &&
+		    (extent.e_flags & EXT2_EXTENT_FLAGS_UNINIT) &&
+		    fix_problem(ctx, PR_1_UNINIT_DBLOCK, pctx)) {
+			extent.e_flags &= ~EXT2_EXTENT_FLAGS_UNINIT;
+			pb->inode_modified = 1;
+			pctx->errcode = ext2fs_extent_replace(ehandle, 0,
+							      &extent);
+			if (pctx->errcode)
+				return;
+			failed_csum = 0;
+		}
+
 		/* Corrupt but passes checks?  Ask to fix checksum. */
 		if (try_repairs && failed_csum) {
 			pctx->blk = extent.e_pblk;
diff --git a/e2fsck/problem.c b/e2fsck/problem.c
index a1986c6..60c02af 100644
--- a/e2fsck/problem.c
+++ b/e2fsck/problem.c
@@ -1043,6 +1043,11 @@ static struct e2fsck_problem problem_table[] = {
 	  N_("@d @i %i @b %b should be at @b %c.  "),
 	  PROMPT_FIX, 0 },
 
+	/* Extents/inlinedata flag set on a device or socket inode */
+	{ PR_1_UNINIT_DBLOCK,
+	  N_("@d @i %i has @x marked uninitialized at @b %c.  "),
+	  PROMPT_FIX, PR_PREEN_OK },
+
 	/* Pass 1b errors */
 
 	/* Pass 1B: Rescan for duplicate/bad blocks */
diff --git a/e2fsck/problem.h b/e2fsck/problem.h
index c349286..6cd3d50 100644
--- a/e2fsck/problem.h
+++ b/e2fsck/problem.h
@@ -606,6 +606,9 @@ struct problem_context {
 /* Directory inode has a missing block (hole) */
 #define PR_1_COLLAPSE_DBLOCK		0x010072
 
+/* uninit directory block */
+#define PR_1_UNINIT_DBLOCK		0x010073
+
 /*
  * Pass 1b errors
  */
diff --git a/tests/f_uninit_dir/expect.1 b/tests/f_uninit_dir/expect.1
new file mode 100644
index 0000000..f0065f1
--- /dev/null
+++ b/tests/f_uninit_dir/expect.1
@@ -0,0 +1,27 @@
+Pass 1: Checking inodes, blocks, and sizes
+Directory inode 12 has extent marked uninitialized at block 0.  Fix? yes
+
+Directory inode 14 has extent marked uninitialized at block 0.  Fix? yes
+
+Pass 2: Checking directory structure
+Directory inode 14, block #0, offset 0: directory corrupted
+Salvage? yes
+
+Missing '.' in directory inode 14.
+Fix? yes
+
+Setting filetype for entry '.' in ??? (14) to 2.
+Missing '..' in directory inode 14.
+Fix? yes
+
+Setting filetype for entry '..' in ??? (14) to 2.
+Pass 3: Checking directory connectivity
+'..' in /abc (14) is <The NULL inode> (0), should be / (2).
+Fix? yes
+
+Pass 4: Checking reference counts
+Pass 5: Checking group summary information
+
+test_filesys: ***** FILE SYSTEM WAS MODIFIED *****
+test_filesys: 14/128 files (0.0% non-contiguous), 20/512 blocks
+Exit status is 1
diff --git a/tests/f_uninit_dir/expect.2 b/tests/f_uninit_dir/expect.2
new file mode 100644
index 0000000..7b28f43
--- /dev/null
+++ b/tests/f_uninit_dir/expect.2
@@ -0,0 +1,7 @@
+Pass 1: Checking inodes, blocks, and sizes
+Pass 2: Checking directory structure
+Pass 3: Checking directory connectivity
+Pass 4: Checking reference counts
+Pass 5: Checking group summary information
+test_filesys: 14/128 files (0.0% non-contiguous), 20/512 blocks
+Exit status is 0
diff --git a/tests/f_uninit_dir/image.gz b/tests/f_uninit_dir/image.gz
new file mode 100644
index 0000000000000000000000000000000000000000..ac9131d26d9da4943e912c5ea493110727f1fbc7
GIT binary patch
literal 2604
zcmb2|=3uzrvLu*^`R(2P*}{P`3?Is;b1m&%mLYhw>5)Q50K1?p%VVXkZi$$fBl0_b
zEDjL8!q>aGxv4u_v1xMi0zRvb$qE*ndjA-ex|$bt3*3KNq-ChP@!F5Y^ZkF^+Z})M
z^y$;F`}8?uI1VI*o>$A{Se^V)jWco6Ub|fP?Dnd-H#76D@E!4R-W*vyy=6!BjG0+i
zx{iC@dRkDOSgj*>oPB23(~Q#7r=nMXv)%pc(YKTRQ%_Aj_k82eFEfkx?_PWMy7}ts
z%gXb2m)9R|o_Xx^Y|j;KMYHmM?~~<D)wwrG?=^eUo3GcH86NPTxOD%i;kE6b{-2yN
zo3G}snPl9$uUw1_3<vhFkJM{FzchY_Jp%*7hwG>7{_D4^$nyWJXFR3od;Iw4{~!9=
z7Jj*M<Yw_~Kc6}F#WuI6xoYk$_!tx+_I!Sb*UO2EkJofE0rl4JeAxH#f4i66KXxGR
zpRsZrNYnt#>-i6~3I-bPYwllmzyJFGXsPG%p<bP@e<Ml46d}_aBuvW7beMrc|7Gtt
zAj^=*{$QN8Olqr=Sn%%q@46;W-1GPMvd<^B>u@%&EizbAX!XU8lllH#{m#IshF`~%
z?%ddzRxjpiUt!MlH(<YvdjG1}bN@Ym|1qyWEPMK-&h!1}&MWR^`ukDibp5KkpZ1%q
z$$oCX(EFe9g}&Ak_5YrHjDJ#Jp1ha;cHox!bAQ&$UH=+!{P^;AwP!j1uUUsj6>ccA
zt(J?tx&E8E-t(u2<!{B$S<4<>?EL=u{rmH)a_f7-{@$#a|9k(5zx$v5zyHgA=F<P+
zU#fa!<?i0_{x{z>tlm(JM9+^Z9}R)g5Eu=C(GVC7fzc2kIs~3Q=gz$9$Hu^*zyJU<
C_B(|D

literal 0
HcmV?d00001

diff --git a/tests/f_uninit_dir/name b/tests/f_uninit_dir/name
new file mode 100644
index 0000000..d7f5bee
--- /dev/null
+++ b/tests/f_uninit_dir/name
@@ -0,0 +1 @@
+fix uninit flag on directory extents and check the dir blocks

