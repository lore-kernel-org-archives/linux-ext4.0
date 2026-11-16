Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=213.97.179.56
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794839302;
	b=uonm8N3RdaLKNApmdbmrWYc2zM9AMnyO+mRt0HdD/5JLO8U5/TemVjkL334k1uxJq2G6
	 YxEVOKH4/MQqpn/DvrqgRv9rnaJLTq/ReZQCoWTVqr+HdQtVb2LflIUvVSPPHG5czFnz4
	 m2mdSfXELRbScviA8SSBcMKavECsvC0/A85NEP9ALCJa+4ixUiLIpRMPzmxr3BCZPQpi6
	 7MuXF6ZzWi+g86JqrzKz7/GoAAtV6E8jgy/7GHd5ldIMFoBt9nOdeCvuGxpv9DTK8d1IO
	 qgUR85puZcqFyz1RK4WMQRQU+NNOB7iHX8nvTVdK32jtxn3XqBjEjWdAqJQkTeBV4RQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794839302;
	h=DMARC-Filter:DKIM-Signature:Received:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:MIME-Version:Content-Transfer-Encoding;
	bh=oufSmFNCd1LNATvdKSD+y4tOSlJeCKm87sWwke8BGcw=;
	b=i4KCXV6P6chF9WlEN/hA7mjUhMQ1ZfYBYe2rVv6IsCYIkaG++urqH4TIVTPwcIiS6BJd
	 RdaSQlo1gIf5ZHY27psVnZveIsPaVCfp7sGHx0PJR0fw4OgHdkFuNf4khn1lZJ9030Tik
	 CZnqpRvbJqQvsynC2/4NGLpqaYrmyJ+NeFFQRf7uZL17gZdgBko6RyR/55IR3HBzMoEEh
	 DbJw0WIoBohMtVh0Ari27qPDFg8G+KGscXvVCDCajG6FQpX2j3SLAR0/WXDl3qa5HReH4
	 0IRgHEGcSn56ISt+CLKY46zisLYIo1PUyXATClyTqpBKXkpbSS7IoJATmk9p/pFnexg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=igalia.com;
	spf=pass smtp.mailfrom=igalia.com;
	dkim=pass header.d=igalia.com header.i=@igalia.com header.a=rsa-sha256 header.s=20170329 header.b=dzCx2nwc;
	arc=none smtp.remote-ip=213.97.179.56
Received: from fanzine2.igalia.com (fanzine2.igalia.com [213.97.179.56])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9941606A335
	for <linux-ext4@vger.kernel.org>; Mon, 16 Nov 2026 14:28:21 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org B9941606A335
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=igalia.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=igalia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=igalia.com header.i=@igalia.com header.a=rsa-sha256 header.s=20170329 header.b=dzCx2nwc
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=igalia.com;
	s=20170329; h=Content-Transfer-Encoding:MIME-Version:Message-ID:Date:Subject:
	Cc:To:From:From:Reply-To; bh=oufSmFNCd1LNATvdKSD+y4tOSlJeCKm87sWwke8BGcw=;
	t=1794839301; x=2110199301; b=dzCx2nwcPM3ZLNkkTwaTsHGGbJa9gEqjmwRWlBa/2atbvRm
	ZYBokpvyb1svH5kOIB2gtiQCAmWvufeScyZqksYkrJxUXUfdB74beirJTLJjYpEzmiJq7J467y+ZR
	dISKCFOKQx+ofIlVB0FzZPCiE+PEEbOmOnltCZEeMwA1w6TydNDi04FvvUdGSOBCLcIRBlZBkalR9
	gz86qzWjg29lDlHAbw6EyH+bWEjJZYexFIGilPmVWPlHvPC4bodYfRu31DPffY028Kjq1bP+ymvYt
	/FEXD+RDDniyxWri6uJqEGqDlyyPrLxRRVfUNwjeEsvvVlElG2Aqqdi+I5zhX/ow==;
Received: from 87.pool92-176-6.dynamic.orange.es ([92.176.6.87] helo=perseus.local)
	by fanzine2.igalia.com with esmtpsa 
	(Cipher TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256) (Exim)
	id 1xSxgx-00000000E7o-07hk;
	Mon, 16 Nov 2026 15:28:19 +0100
Received: from berto by perseus.local with local (Exim 4.98.2)
	(envelope-from <berto@igalia.com>)
	id 1xSxgv-00000000MA8-2nVx;
	Mon, 16 Nov 2026 15:28:17 +0100
From: Alberto Garcia <berto@igalia.com>
To: linux-ext4@vger.kernel.org
Cc: Alberto Garcia <berto@igalia.com>,
	Theodore Ts'o <tytso@mit.edu>,
	Eric Biggers <ebiggers@kernel.org>,
	Baokun Li <libaokun@linux.alibaba.com>
Subject: [PATCH v2] e2fsck: set the encrypt feature if the filesystem has encrypted inodes
Date: Mon, 16 Nov 2026 15:28:11 +0100
Message-ID: <20261116142812.85180-1-berto@igalia.com>
X-Mailer: git-send-email 2.47.3
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

A filesystem without the encrypt feature can still contain encrypted
inodes, either due to corruption or because the image was crafted that
way.

e2fsck currently accepts such inodes without complaint. Since those
inodes can be decrypted, this should be fixed by setting the encrypt
feature on the filesystem.

Note that the Linux kernel does not currently support encryption when
the block size is larger than the page size. After this change, such
a filesystem will be rejected at mount time (see the kernel commit
709f0f1f1bf5, "ext4: add checks for large folio incompatibilities
when BS > PS"). However, since this depends on the page size of the
machine where the filesystem is mounted, and the kernel could lift
that limitation in the future, e2fsck does not take it into account.

Fix this by adding a new problem (PR_1_ENCRYPT_FEATURE) and a
regression test.

Signed-off-by: Alberto Garcia <berto@igalia.com>
---
Changes from v1:

- Check info->file_ranges_count == 0 so the question is not repeated
  for every single encrypted inode if the user declines to fix the
  problem [Eric Biggers].
- Add 'xgettext:no-c-format' to the PR_1_ENCRYPT_FEATURE string
  [Eric Biggers].
- Create an empty file instead of a file with data to reduce
  the size of the compressed image [Eric Biggers].

 e2fsck/encrypted_files.c                   |  14 +++++++
 e2fsck/problem.c                           |   9 +++++
 e2fsck/problem.h                           |   3 ++
 tests/f_encrypt_feature_missing/expect.1   |  12 ++++++
 tests/f_encrypt_feature_missing/expect.2   |   7 ++++
 tests/f_encrypt_feature_missing/image.gz   | Bin 0 -> 1158 bytes
 tests/f_encrypt_feature_missing/mkimage.sh |  43 +++++++++++++++++++++
 tests/f_encrypt_feature_missing/name       |   1 +
 8 files changed, 89 insertions(+)
 create mode 100644 tests/f_encrypt_feature_missing/expect.1
 create mode 100644 tests/f_encrypt_feature_missing/expect.2
 create mode 100644 tests/f_encrypt_feature_missing/image.gz
 create mode 100755 tests/f_encrypt_feature_missing/mkimage.sh
 create mode 100644 tests/f_encrypt_feature_missing/name

diff --git a/e2fsck/encrypted_files.c b/e2fsck/encrypted_files.c
index 16be2d6d..a59f0841 100644
--- a/e2fsck/encrypted_files.c
+++ b/e2fsck/encrypted_files.c
@@ -389,6 +389,20 @@ int add_encrypted_file(e2fsck_t ctx, struct problem_context *pctx)
 		return 0;
 	}
 
+	/*
+	 * If the inode is encrypted but the filesystem does not have
+	 * the encrypt feature, the fix is to set it. If the user declines,
+	 * we should not ask the same question for all the encrypted inodes
+	 * in the filesystem, so use 'file_ranges_count' to do it on the
+	 * first one only.
+	 */
+	if (info->file_ranges_count == 0 &&
+	    !ext2fs_has_feature_encrypt(ctx->fs->super) &&
+	    fix_problem(ctx, PR_1_ENCRYPT_FEATURE, pctx)) {
+		ext2fs_set_feature_encrypt(ctx->fs->super);
+		ext2fs_mark_super_dirty(ctx->fs);
+	}
+
 	/* Store this ino => policy_id mapping in the encrypted_file_info. */
 	return append_ino_and_policy_id(ctx, pctx, ino, policy_id);
 }
diff --git a/e2fsck/problem.c b/e2fsck/problem.c
index e433281f..a1640d1c 100644
--- a/e2fsck/problem.c
+++ b/e2fsck/problem.c
@@ -1319,6 +1319,15 @@ static struct e2fsck_problem problem_table[] = {
 	  N_("@i %i references EA inode but @S is missing EA_INODE feature\n"),
 	  PROMPT_FIX, PR_PREEN_OK, 0, 0, 0 },
 
+	/*
+	 * Encrypted inode found but the filesystem is missing the
+	 * encrypt feature
+	 */
+	{ PR_1_ENCRYPT_FEATURE,
+	  /* xgettext:no-c-format */
+	  N_("@i %i is encrypted but @S is missing ENCRYPT feature\n"),
+	  PROMPT_FIX, PR_PREEN_OK, 0, 0, 0 },
+
 	/* Pass 1b errors */
 
 	/* Pass 1B: Rescan for duplicate/bad blocks */
diff --git a/e2fsck/problem.h b/e2fsck/problem.h
index ef15b8c8..ae1bde26 100644
--- a/e2fsck/problem.h
+++ b/e2fsck/problem.h
@@ -740,6 +740,9 @@ struct problem_context {
 /* Inode references EA inode but ea_inode feature is not enabled */
 #define PR_1_EA_INODE_FEATURE			0x010092
 
+/* Encrypted inode found but encrypt feature is not enabled */
+#define PR_1_ENCRYPT_FEATURE			0x010093
+
 /*
  * Pass 1b errors
  */
diff --git a/tests/f_encrypt_feature_missing/expect.1 b/tests/f_encrypt_feature_missing/expect.1
new file mode 100644
index 00000000..7ba07067
--- /dev/null
+++ b/tests/f_encrypt_feature_missing/expect.1
@@ -0,0 +1,12 @@
+Pass 1: Checking inodes, blocks, and sizes
+Inode 12 is encrypted but superblock is missing ENCRYPT feature
+Fix? yes
+
+Pass 2: Checking directory structure
+Pass 3: Checking directory connectivity
+Pass 4: Checking reference counts
+Pass 5: Checking group summary information
+
+test_filesys: ***** FILE SYSTEM WAS MODIFIED *****
+test_filesys: 13/128 files (0.0% non-contiguous), 19/128 blocks
+Exit status is 1
diff --git a/tests/f_encrypt_feature_missing/expect.2 b/tests/f_encrypt_feature_missing/expect.2
new file mode 100644
index 00000000..0e84de9d
--- /dev/null
+++ b/tests/f_encrypt_feature_missing/expect.2
@@ -0,0 +1,7 @@
+Pass 1: Checking inodes, blocks, and sizes
+Pass 2: Checking directory structure
+Pass 3: Checking directory connectivity
+Pass 4: Checking reference counts
+Pass 5: Checking group summary information
+test_filesys: 13/128 files (0.0% non-contiguous), 19/128 blocks
+Exit status is 0
diff --git a/tests/f_encrypt_feature_missing/image.gz b/tests/f_encrypt_feature_missing/image.gz
new file mode 100644
index 0000000000000000000000000000000000000000..2a700cbabdb0a783d85d5321fb73b1f03b4f12a3
GIT binary patch
literal 1158
zcmb2|=HQt5^H&xVb7pR0dMd-)yS^DB;W7*#X1)vxp1fn@jiie~iVAfP7qu_iE1?^q
z|Lu|LbRie>U0G#^&plh<5vcj-U^B;}I1w+wDOwtjJP$4qxz(-kNZeLrPlxNCCkt33
z)6c9qGQlJGvHSJ=`9II^F*km5ruwwaKmM|^W`-XDZ%;jXtnzD8$L6<zV!h0lu3l9C
zpW~^_^XhA9{~?7l+f46ipSiX+GBxs>oV;q_zt1P$-(}x#{p<7NTIXVRzk71EvaMN5
zgS17ae>?W~>ZxTr0<@29-ErY|uulGpy!Y$Bei6HVoo&_8dHaH7rk|S4Rr~Z-%k8Sy
z-};wNkBO~*6p{IBYjyUybN=hM>)tlsBs)3P?-SSYyVqlGxlK77Bk<?z@sGFi{ljJL
z%U^z&x!b$$)=NKTh6;O=PoM96{$uZV%5p9f0|SHavbgz1tN4H{lez1eKGy>o8AZL7
z^^b4fGyf>_=J%V2r&2B&hW##f^e#Jd;(3eu?KvuSvHSAEq<YUE+#b}hJ@NXxl)|0a
zJs<UJ4FCNNzwCbXaN)826MO1Ee2ek>Jb&HBPxD_at=??gnd$kY{qj=Jv-S6${<W|B
zC(henuY36X@w#79&wqUTbG3SXR{j5ZzvpHyu}rA?=cYF!_IUG$$?Kjky?JvQudq$M
z#IvU2c5iDw-g!}lwfB$yom>BY$Hh%0_pX1{*W>xOsd~>Jd+D{CzwPf^`*Y#S|I7Yn
zE_v>MJ%80-<7n;sch;=?_s{Fy=XdJAt;Ho6fqujZDyC|9{J(A2Beq||{o<n~mu5{#
zX9-@MJ9Wpl4cm<Z?#+0|-6Z`pCge`Us#lgkLw@|vkTv};e~SP7f1t4qYL^#s14R$~
zkq43n|Jk9|+*`UW;m!U3`TnQAf0j+GetKZ4>t?>Xo1dJwRNk6<{@W`<sJc;V2!(*!
PBgwn>Bo8n!a4-M>RjqK7

literal 0
HcmV?d00001

diff --git a/tests/f_encrypt_feature_missing/mkimage.sh b/tests/f_encrypt_feature_missing/mkimage.sh
new file mode 100755
index 00000000..e1d89282
--- /dev/null
+++ b/tests/f_encrypt_feature_missing/mkimage.sh
@@ -0,0 +1,43 @@
+#!/bin/bash
+
+# This is the script that was used to create the image.gz in this directory.
+#
+# It creates a filesystem with an encrypted directory and file, and then
+# clears the encrypt feature flag.  e2fsck should notice that the
+# filesystem contains encrypted inodes and offer to set the feature again.
+#
+# This must be run as root on a kernel with ext4 encryption support.
+
+# For the purposes of this test both v1 and v2 policies are equally fine.
+# v2 policies need fscryptctl from https://github.com/google/fscryptctl
+policy_version=1
+
+set -e -u
+umask 0022
+
+mkdir -p mnt
+umount mnt &> /dev/null || true
+
+# Create an image with the 'encrypt' feature set
+dd if=/dev/zero of=image bs=4096 count=128
+mke2fs -O encrypt -b 4096 -N 128 image
+mount image mnt
+
+# Create an encrypted directory (ino 12) containing an encrypted file (ino 13)
+dir=mnt/edir
+mkdir $dir
+if [ "$policy_version" = "2" ]; then
+	policy="$(head -c 32 /dev/zero | fscryptctl add_key mnt)"
+	fscryptctl set_policy "$policy" $dir
+else
+	echo password | e4crypt add_key $dir
+fi
+touch $dir/encrypted_file
+
+umount mnt
+rmdir mnt
+
+# Clear the encrypt feature, leaving the encrypted inodes in place
+debugfs -w -R "feature -encrypt" image
+
+gzip -9 -f image
diff --git a/tests/f_encrypt_feature_missing/name b/tests/f_encrypt_feature_missing/name
new file mode 100644
index 00000000..51def291
--- /dev/null
+++ b/tests/f_encrypt_feature_missing/name
@@ -0,0 +1 @@
+encrypted inode but no encrypt feature
-- 
2.47.3

