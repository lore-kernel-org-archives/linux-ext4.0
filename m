From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH 1/2] e2fsck: check for an encrypted lost+found directory
Date: Thu, 16 Jul 2015 18:05:39 -0400
Message-ID: <1437084340-16928-1-git-send-email-tytso@mit.edu>
Cc: Theodore Ts'o <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:32909 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751586AbbGPWFp (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 16 Jul 2015 18:05:45 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

The /lost+found directory must not be encrypted, since e2fsck won't
have any keys.  If we find an encrypted lost+found directory, we
should delete the directory and recreate it.

Signed-off-by: Theodore Ts'o <tytso@mit.edu>
---
 e2fsck/pass3.c                 |  18 +++++++++++++++++-
 e2fsck/problem.c               |   5 +++++
 e2fsck/problem.h               |   3 +++
 tests/f_encrypted_lpf/expect.1 |  27 +++++++++++++++++++++++++++
 tests/f_encrypted_lpf/expect.2 |   7 +++++++
 tests/f_encrypted_lpf/image.gz | Bin 0 -> 1123 bytes
 tests/f_encrypted_lpf/name     |   1 +
 7 files changed, 60 insertions(+), 1 deletion(-)
 create mode 100644 tests/f_encrypted_lpf/expect.1
 create mode 100644 tests/f_encrypted_lpf/expect.2
 create mode 100644 tests/f_encrypted_lpf/image.gz
 create mode 100644 tests/f_encrypted_lpf/name

diff --git a/e2fsck/pass3.c b/e2fsck/pass3.c
index 1d5255f..d7b8802 100644
--- a/e2fsck/pass3.c
+++ b/e2fsck/pass3.c
@@ -100,7 +100,8 @@ void e2fsck_pass3(e2fsck_t ctx)
 
 	iter = e2fsck_dir_info_iter_begin(ctx);
 	while ((dir = e2fsck_dir_info_iter(ctx, iter)) != 0) {
-		if (ctx->flags & E2F_FLAG_SIGNAL_MASK)
+		if (ctx->flags & E2F_FLAG_SIGNAL_MASK ||
+		    ctx->flags & E2F_FLAG_RESTART)
 			goto abort_exit;
 		if (ctx->progress && (ctx->progress)(ctx, 3, count++, maxdirs))
 			goto abort_exit;
@@ -415,6 +416,12 @@ ext2_ino_t e2fsck_get_lost_and_found(e2fsck_t ctx, int fix)
 			goto unlink;
 		}
 
+		if (fix && (inode.i_flags & EXT4_ENCRYPT_FL)) {
+			if (!fix_problem(ctx, PR_3_LPF_ENCRYPTED, &pctx))
+				return 0;
+			goto unlink;
+		}
+
 		if (ext2fs_check_directory(fs, ino) == 0) {
 			ctx->lost_and_found = ino;
 			return ino;
@@ -437,6 +444,15 @@ unlink:
 		}
 		(void) e2fsck_dir_info_set_parent(ctx, ino, 0);
 		e2fsck_adjust_inode_count(ctx, ino, -1);
+		/*
+		 * If the old lost+found was a directory, we've just
+		 * disconnected it from the directory tree, which
+		 * means we need to restart the directory tree scan.
+		 * The simplest way to do this is restart the whole
+		 * e2fsck operation.
+		 */
+		if (LINUX_S_ISDIR(inode.i_mode))
+			ctx->flags |= E2F_FLAG_RESTART;
 	} else if (retval != EXT2_ET_FILE_NOT_FOUND) {
 		pctx.errcode = retval;
 		fix_problem(ctx, PR_3_ERR_FIND_LPF, &pctx);
diff --git a/e2fsck/problem.c b/e2fsck/problem.c
index 23d2183..084131a 100644
--- a/e2fsck/problem.c
+++ b/e2fsck/problem.c
@@ -1750,6 +1750,11 @@ static struct e2fsck_problem problem_table[] = {
 	  N_("Insufficient space to recover lost files!\nMove data off the @f and re-run e2fsck.\n\n"),
 	  PROMPT_NONE, 0 },
 
+	/* Lost+found is encrypted */
+	{ PR_3_LPF_ENCRYPTED,
+	  N_("/@l is encrypted\n"),
+	  PROMPT_CLEAR, 0 },
+
 	/* Pass 3A Directory Optimization	*/
 
 	/* Pass 3A: Optimizing directories */
diff --git a/e2fsck/problem.h b/e2fsck/problem.h
index e0b5d14..5af3edf 100644
--- a/e2fsck/problem.h
+++ b/e2fsck/problem.h
@@ -1048,6 +1048,9 @@ struct problem_context {
 /* Insufficient space to recover lost files */
 #define PR_3_NO_SPACE_TO_RECOVER	0x03001A
 
+/* Lost+found is encrypted */
+#define PR_3_LPF_ENCRYPTED		0x03001B
+
 /*
  * Pass 3a --- rehashing diretories
  */
diff --git a/tests/f_encrypted_lpf/expect.1 b/tests/f_encrypted_lpf/expect.1
new file mode 100644
index 0000000..7e215b7
--- /dev/null
+++ b/tests/f_encrypted_lpf/expect.1
@@ -0,0 +1,27 @@
+Pass 1: Checking inodes, blocks, and sizes
+Pass 2: Checking directory structure
+Pass 3: Checking directory connectivity
+Unconnected directory inode 12 (/???)
+Connect to /lost+found? yes
+
+/lost+found is encrypted
+Clear? yes
+
+/lost+found not found.  Create? yes
+
+Restarting e2fsck from the beginning...
+Pass 1: Checking inodes, blocks, and sizes
+Pass 2: Checking directory structure
+Pass 3: Checking directory connectivity
+Unconnected directory inode 11 (/???)
+Connect to /lost+found? yes
+
+Pass 3A: Optimizing directories
+Pass 4: Checking reference counts
+Inode 12 ref count is 3, should be 2.  Fix? yes
+
+Pass 5: Checking group summary information
+
+test_filesys: ***** FILE SYSTEM WAS MODIFIED *****
+test_filesys: 13/64 files (0.0% non-contiguous), 13/100 blocks
+Exit status is 1
diff --git a/tests/f_encrypted_lpf/expect.2 b/tests/f_encrypted_lpf/expect.2
new file mode 100644
index 0000000..6a59947
--- /dev/null
+++ b/tests/f_encrypted_lpf/expect.2
@@ -0,0 +1,7 @@
+Pass 1: Checking inodes, blocks, and sizes
+Pass 2: Checking directory structure
+Pass 3: Checking directory connectivity
+Pass 4: Checking reference counts
+Pass 5: Checking group summary information
+test_filesys: 13/64 files (0.0% non-contiguous), 13/100 blocks
+Exit status is 0
diff --git a/tests/f_encrypted_lpf/image.gz b/tests/f_encrypted_lpf/image.gz
new file mode 100644
index 0000000000000000000000000000000000000000..7c89e07a5d96ecaef3d7ba57a5bb627760f0580f
GIT binary patch
literal 1123
zc-oWi=3pp!y*!kO`RyJ544F^~h7aG>q<t?r%v!M}L-EB*jbqM1AMY!!)!@+DCZ*5C
z)tTwN<f2;By&%C?OBFZ-T~*Y(uQqW7>9S^v8n!oevFEBTV2QpgYT7H_x-P$5-K<4d
zOgHb&zq${pY4>j5?5{MQ`R03>xgvx3>VG26nzMp=mb^H9d$Y|U7t>SyyI)<o*Ql$R
zq%rl~f6KNRx2!IIdsKY1W~bKux64G_H%Yj0Df-0SwysQid+g9cX>*(1U(c0Sy)ImH
zH+ub@t<PrfZeMO^WAfv*^Zfk2mn&|4-naC4q2f`g+}0}<#mw=+hI8NdAMdOEc(S(K
z_QS7v)BE=QIdhP8f2Q{NS?gN8dzctvYEG^HxH~8&xbp9P@mWp_Fa5i^`2F46;&D5E
z#r)2lIlJoC3q}Tp1OJ_0Ui!BG9`o;|EDQ_`CW}7({{L1n&Gu(H<1OcDU%!OdAO4-|
z9{ugdiyJ>m4=?tAE5S9jvgy24)TWQej~$bjytVK08&06cH90G%&A<8Q_`K)gx~u>D
zmxa8p2Z}B*eD(j$yoKVYUvtYIV+IOHZT+X;7xQo8FL@y6%6}l?kPM*?pJ)E@AEf8P
zj?({Uc<=Yt%w6?w=ZtNqFaCZxdHeeRMIWXv?eAW@d1^lUn$y48d1XPCdKiiwiYUC_
zc<<-4zn7OUpZDYKwUf{Ds`p#m6`j>51yX_w{HR{qR|9gm$r^!8J7>K5UsPjYVg2XY
zvfRzy&)Jh+=cKkJ#NM;dI0Xuouq6`QiEDPecX(g(`JZq3neu-des9gSm%C&8>)n}$
z+k5#K$OGa*&sXkc?*176)TT(OWxm<6saF+qJSum8Uhz%L$vgF?P|~lPWme0kZ9bLj
z``_sQIqg^0&(hCbG5>$~{&n;JtM7h2TmLtMLwNV4QxE@1U9Ug0et&)5&wqtC%RZ;n
z_SgSz{(AQRvDshG?*CR{_4Vm*|9Xz?OFr+DxOz`#&H6b<UPZ>#{nva_xKD5O#c95C
w_Wr+mYQNR_`gOnKUspc67x>2NX4vAt-!tpKGmHWTsk`%=8_wl3IIuAQ03~OkqyPW_

literal 0
Hc-jL100001

diff --git a/tests/f_encrypted_lpf/name b/tests/f_encrypted_lpf/name
new file mode 100644
index 0000000..b74259c
--- /dev/null
+++ b/tests/f_encrypted_lpf/name
@@ -0,0 +1 @@
+encrypted lost+found directory
-- 
2.3.0

