From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH 2/2] e2fsck: check for encrypted directory entries with too-short file names
Date: Thu, 16 Jul 2015 18:05:40 -0400
Message-ID: <1437084340-16928-2-git-send-email-tytso@mit.edu>
References: <1437084340-16928-1-git-send-email-tytso@mit.edu>
Cc: Theodore Ts'o <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:32911 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751690AbbGPWFq (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 16 Jul 2015 18:05:46 -0400
In-Reply-To: <1437084340-16928-1-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

If there are directory entries with file names which are less than 16
bytes, it turns out that passing less than the crypto block size to
the kernel's crypto layer will cause the kernel to crash.

However, since there never should be encrypted directory entries where
the file name is less than 16 bytes (the AES block size), change
e2fsck to offer to address this corruption by deleting the directory
entry.

(We need to checks for this condition into the kernel as well.)

Signed-off-by: Theodore Ts'o <tytso@mit.edu>
---
 e2fsck/pass2.c                          |  20 ++++++++++++++++++++
 e2fsck/problem.c                        |   5 +++++
 e2fsck/problem.h                        |   3 +++
 lib/ext2fs/ext2_fs.h                    |   1 +
 tests/f_short_encrypted_dirent/expect.1 |  17 +++++++++++++++++
 tests/f_short_encrypted_dirent/expect.2 |   7 +++++++
 tests/f_short_encrypted_dirent/image.gz | Bin 0 -> 925 bytes
 tests/f_short_encrypted_dirent/name     |   1 +
 8 files changed, 54 insertions(+)
 create mode 100644 tests/f_short_encrypted_dirent/expect.1
 create mode 100644 tests/f_short_encrypted_dirent/expect.2
 create mode 100644 tests/f_short_encrypted_dirent/image.gz
 create mode 100644 tests/f_short_encrypted_dirent/name

diff --git a/e2fsck/pass2.c b/e2fsck/pass2.c
index f4913f6..2e9a90d 100644
--- a/e2fsck/pass2.c
+++ b/e2fsck/pass2.c
@@ -494,6 +494,20 @@ static int check_name(e2fsck_t ctx,
 	return ret;
 }
 
+static int encrypted_check_name(e2fsck_t ctx,
+				struct ext2_dir_entry *dirent,
+				struct problem_context *pctx)
+{
+	if (ext2fs_dirent_name_len(dirent) < EXT4_CRYPTO_BLOCK_SIZE) {
+		if (fix_problem(ctx, PR_2_BAD_ENCRYPTED_NAME, pctx)) {
+			dirent->inode = 0;
+			return 1;
+		}
+		ext2fs_unmark_valid(ctx->fs);
+	}
+	return 0;
+}
+
 /*
  * Check the directory filetype (if present)
  */
@@ -1383,6 +1397,12 @@ skip_checksum:
 		if (!encrypted && check_name(ctx, dirent, &cd->pctx))
 			dir_modified++;
 
+		if (encrypted && (dot_state) > 1 &&
+		    encrypted_check_name(ctx, dirent, &cd->pctx)) {
+			dir_modified++;
+			goto next;
+		}
+
 		if (check_filetype(ctx, dirent, ino, &cd->pctx))
 			dir_modified++;
 
diff --git a/e2fsck/problem.c b/e2fsck/problem.c
index 084131a..9ef689a 100644
--- a/e2fsck/problem.c
+++ b/e2fsck/problem.c
@@ -1613,6 +1613,11 @@ static struct e2fsck_problem problem_table[] = {
 	  N_("Fixing size of inline @d @i %i failed.\n"),
 	  PROMPT_TRUNCATE, 0 },
 
+	/* Encrypted directory entry is too short */
+	{ PR_2_BAD_ENCRYPTED_NAME,
+	  N_("Encrypted @E is too short.\n"),
+	  PROMPT_CLEAR, 0 },
+
 	/* Pass 3 errors */
 
 	/* Pass 3: Checking directory connectivity */
diff --git a/e2fsck/problem.h b/e2fsck/problem.h
index 5af3edf..2ff0f5e 100644
--- a/e2fsck/problem.h
+++ b/e2fsck/problem.h
@@ -963,6 +963,9 @@ struct problem_context {
 /* fixing inline dir size failed */
 #define PR_2_FIX_INLINE_DIR_FAILED	0x02004F
 
+/* Encrypted directory entry is too short */
+#define PR_2_BAD_ENCRYPTED_NAME		0x020050
+
 /*
  * Pass 3 errors
  */
diff --git a/lib/ext2fs/ext2_fs.h b/lib/ext2fs/ext2_fs.h
index 918ae70..cfeaa05 100644
--- a/lib/ext2fs/ext2_fs.h
+++ b/lib/ext2fs/ext2_fs.h
@@ -579,6 +579,7 @@ struct ext2_inode_large {
 #define EXT4_MAX_KEY_SIZE			64
 
 #define EXT4_KEY_DESCRIPTOR_SIZE		8
+#define EXT4_CRYPTO_BLOCK_SIZE			16
 
 /* Password derivation constants */
 #define EXT4_MAX_PASSPHRASE_SIZE		1024
diff --git a/tests/f_short_encrypted_dirent/expect.1 b/tests/f_short_encrypted_dirent/expect.1
new file mode 100644
index 0000000..bc64922
--- /dev/null
+++ b/tests/f_short_encrypted_dirent/expect.1
@@ -0,0 +1,17 @@
+Pass 1: Checking inodes, blocks, and sizes
+Pass 2: Checking directory structure
+Encrypted entry 'motd' in /get_shorty (12) is too short.
+Clear? yes
+
+Pass 3: Checking directory connectivity
+Pass 4: Checking reference counts
+Unattached inode 13
+Connect to /lost+found? yes
+
+Inode 13 ref count is 2, should be 1.  Fix? yes
+
+Pass 5: Checking group summary information
+
+test_filesys: ***** FILE SYSTEM WAS MODIFIED *****
+test_filesys: 13/16 files (0.0% non-contiguous), 23/100 blocks
+Exit status is 1
diff --git a/tests/f_short_encrypted_dirent/expect.2 b/tests/f_short_encrypted_dirent/expect.2
new file mode 100644
index 0000000..636c6e9
--- /dev/null
+++ b/tests/f_short_encrypted_dirent/expect.2
@@ -0,0 +1,7 @@
+Pass 1: Checking inodes, blocks, and sizes
+Pass 2: Checking directory structure
+Pass 3: Checking directory connectivity
+Pass 4: Checking reference counts
+Pass 5: Checking group summary information
+test_filesys: 13/16 files (0.0% non-contiguous), 23/100 blocks
+Exit status is 0
diff --git a/tests/f_short_encrypted_dirent/image.gz b/tests/f_short_encrypted_dirent/image.gz
new file mode 100644
index 0000000000000000000000000000000000000000..a35bfb23b51aee75da142886a39380915d629f8e
GIT binary patch
literal 925
zc-oWi=3qF(vLcj;`RyIw4(U)Ch7Tv*7cN<Qtu)ZTbOZa+SIgM>n-pR<c5KL7_%>*j
z(^<96yPY?mG@E&2T}X!Do{B($mj@T0>XKJ?{i2}6)upf~U_w`g;2sfC+aD)?O?q=J
zYdhCEiS56CAGEKWTxtB@{P6GnCsjL@687GbS|pa_+)?c$;`HR)dx7uCuP;5j+uGWx
z5fyXid+ECC?@RXWzPr8V&N2aYr#n)Q-qz?@#q=yXo>pI1dOdh|TfEJ`k9))GH$6V<
z81wqw>b{ziJ$tHepT6FI_MCm;s{*}SqPcOm%Kw%AnO&q^6UHOY7kj8!D?B7T`(UI0
z{Q6zd@59?}+*|$MY5l+5$MWj_EOh#EtY6&v+fw!ZIfd+rxzRCu{@gMC(C(UGd$N7k
zeVM19lppTBf9|=v+pqf%+ZPAzyO)!0?q_P<8+9dG{hs!ePnSK*R@h$7N&Wm;EFhxU
zNw>c4KJ)cbv%f3<?brJ9T7Jit*Z(K-$3?%`wqJjT{Dyn4{$HQ3_CEaof`5!(`B&6C
z{AGS6AMn577yA|a1^*hiM*csrE0#U%&)@sgF8o^)aOSMp=2^R0rr-PgzkBohBi+}3
z@tUj&U;5YB)8=}X-*&CdZ!K~|UeApR>h525(`Qa=Y`NOx%%y_&P3;2Zyrt(R7gq0^
ztGc;x>C_{^YgIaLpI!MT<HoMFSKiK(Ssk)@$Fyym!>n$eyp*PVZc>=V=a9{!>Qi5x
zDOz`rGs|<g)UVc>%*C_UPBF`R*_^pHc;)fnOxu@y8hYio))rN(ebK)@>*}YzqOF$Z
z_q~><Z<-kNvgu*y?9C51-234E{>Jw7oTUHnHa36!G4IEL7x(rqe*ByNo=E!H9rjmr
zGE<iBG}vQu`jCX$^T(&|#MrJ4Q+w?hvtCA4v(k?N1sF&y|I96X`eXdlnuh@*b7gsZ
zA9?-k-uqv<b5ZZ!>zB%R=4~%7`g=I+>BV@q>hs(08{GJ#o-dj6@8Wm%+5cx>U;N_8
z$qP3kb>b}k7kPhvKY#b5{BQpD<~Lr~KRuH0Ih~*1?EmiQMK9LA`?a}v=~s36*w5mx
z{lC{wHd|x#|H9k->+9p&_MF~0XTSM>v$&eS(ow1Z_~-X7N<Z}HzL?*)+!MQH>gW6y
gKX1S1)Su;gpYO0TPy!nMPrlFaZb6X&!vsbK0CU{d761SM

literal 0
Hc-jL100001

diff --git a/tests/f_short_encrypted_dirent/name b/tests/f_short_encrypted_dirent/name
new file mode 100644
index 0000000..a35028a
--- /dev/null
+++ b/tests/f_short_encrypted_dirent/name
@@ -0,0 +1 @@
+short encrypted directory entry
-- 
2.3.0

