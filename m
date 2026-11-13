Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=213.97.179.56
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794586918;
	b=ALZZzuj2ChJdNpVkPwp9QAt5UwySHE3Tph/2HREJrpU++1Tqn2rH4LkTXtGM82UAzFNu
	 d8rw3wmzVnuxAomxTH8JYAnG4wTg2xzfPm2vZP1iOlNrR8Lf7Rh4BA+Ni8D6n9J/EergS
	 a+mMUs6a6DT/+3DWUOxOgOhKAoVBzrK+JW2KpswdXxf75FVAFgBhF42Xd7iXqFDol7oRB
	 GJgnqXuWl92G02VFRuV7aL26lArSGpmY8b3kpdHC2UXZO8tLpKg7AXNCRwaJQ5SgTgOkr
	 Dd7ClrPg3MUwOc7rEypx7ROUA33+eYYB9oBq08xFjzjFsknL6V2WeISk2P2ryROpdwA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794586918;
	h=DMARC-Filter:DKIM-Signature:Received:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:MIME-Version:Content-Transfer-Encoding;
	bh=wrk2gHoBi1Mfs1qN7Vq39nUReG2Os6pkxNM67/hr4is=;
	b=skRJRgOVGiWxN+Uj+S+hjAsQCMcryUAjBTCSDlGRxJsDsLM8k3Jg+qbn9hvlB1SG4D0s
	 uIZHeRbf0shMkK0VxMWoCLxKrQRBKFObv8OT3sIu+FJbQV8ox5YPHFcvZD9CNx2Vu1OHM
	 6ll7rO2aPN+5J6QXIqP6GHQjQtpMLFY62mIhW+AdClI8GfGocpyVEubKvJvQXcZHZHhA0
	 SJodO8IsC93j2s2fnAuoUhSg0o1E1h4ac848UZAjkoFrx0bO6Nb0JLDn84FBMbIBkrofe
	 57+K9YXx0RS0An/v2fx2AS9c7cOQrumtzUeLZ9RNgVrwEbFxSyHWF8P32LdPf9iY1uA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=igalia.com;
	spf=pass smtp.mailfrom=igalia.com;
	dkim=pass header.d=igalia.com header.i=@igalia.com header.a=rsa-sha256 header.s=20170329 header.b=rEgT8iCw;
	arc=none smtp.remote-ip=213.97.179.56
Received: from fanzine2.igalia.com (fanzine2.igalia.com [213.97.179.56])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BAC5A606A884
	for <linux-ext4@vger.kernel.org>; Fri, 13 Nov 2026 16:21:56 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org BAC5A606A884
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=igalia.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=igalia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=igalia.com header.i=@igalia.com header.a=rsa-sha256 header.s=20170329 header.b=rEgT8iCw
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=igalia.com;
	s=20170329; h=Content-Transfer-Encoding:MIME-Version:Message-ID:Date:Subject:
	Cc:To:From:From:Reply-To; bh=wrk2gHoBi1Mfs1qN7Vq39nUReG2Os6pkxNM67/hr4is=;
	t=1794586916; x=2109946916; b=rEgT8iCwuDArGFw7lnxIUePT3M+s3nAx8DVToVZw9pu5olu
	1k0epdpuWMI67ItZY3cy6o0YZ9S8t5qPsxhchlSwa40QWquF0g1P6OhVitVBInt0S6ni4/xjr334v
	9vyM3J6ZzhMC09JPLcVsMILOIspXA4+hERomuky2ehNoAprmAtL2eenGwtdw6txri4EWJueTzJ6AT
	q+5s8RYJf0EUs6Xxvdvzt8keBROH0XNzN7Ukq6mfpiePD50AZpM6NJTcJK1aUDrk6NlIlzKhSU1bV
	ghYKSoGMe+mJH9F2eNR+HO2uBq3wzRGHIhhyw3qr46uDErOsm0UI939iMNNK8ekw==;
Received: from ip40.wifi.igalia.com ([192.168.12.40] helo=zeus.local)
	by fanzine2.igalia.com with esmtpsa 
	(Cipher TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256) (Exim)
	id 1xRu2D-00AGDo-6P; Fri, 13 Nov 2026 17:21:53 +0100
Received: from berto by zeus.local with local (Exim 4.98.2)
	(envelope-from <berto@igalia.com>)
	id 1xRu2D-00000003SVz-0GQv;
	Fri, 13 Nov 2026 17:21:53 +0100
From: Alberto Garcia <berto@igalia.com>
To: linux-ext4@vger.kernel.org
Cc: Alberto Garcia <berto@igalia.com>,
	Theodore Ts'o <tytso@mit.edu>,
	Eric Biggers <ebiggers@kernel.org>,
	Baokun Li <libaokun@linux.alibaba.com>
Subject: [PATCH] e2fsck: set the encrypt feature if the filesystem has encrypted inodes
Date: Fri, 13 Nov 2026 17:21:41 +0100
Message-ID: <20261113162143.824544-1-berto@igalia.com>
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
 e2fsck/encrypted_files.c                   |   7 ++++
 e2fsck/problem.c                           |   8 ++++
 e2fsck/problem.h                           |   3 ++
 tests/f_encrypt_feature_missing/expect.1   |  12 ++++++
 tests/f_encrypt_feature_missing/expect.2   |   7 ++++
 tests/f_encrypt_feature_missing/image.gz   | Bin 0 -> 5566 bytes
 tests/f_encrypt_feature_missing/mkimage.sh |  43 +++++++++++++++++++++
 tests/f_encrypt_feature_missing/name       |   1 +
 8 files changed, 81 insertions(+)
 create mode 100644 tests/f_encrypt_feature_missing/expect.1
 create mode 100644 tests/f_encrypt_feature_missing/expect.2
 create mode 100644 tests/f_encrypt_feature_missing/image.gz
 create mode 100755 tests/f_encrypt_feature_missing/mkimage.sh
 create mode 100644 tests/f_encrypt_feature_missing/name

diff --git a/e2fsck/encrypted_files.c b/e2fsck/encrypted_files.c
index 16be2d6d..9ddce4da 100644
--- a/e2fsck/encrypted_files.c
+++ b/e2fsck/encrypted_files.c
@@ -389,6 +389,13 @@ int add_encrypted_file(e2fsck_t ctx, struct problem_context *pctx)
 		return 0;
 	}
 
+	/* The inode is encrypted, so the filesystem needs the encrypt feature */
+	if (!ext2fs_has_feature_encrypt(ctx->fs->super) &&
+	    fix_problem(ctx, PR_1_ENCRYPT_FEATURE, pctx)) {
+		ext2fs_set_feature_encrypt(ctx->fs->super);
+		ext2fs_mark_super_dirty(ctx->fs);
+	}
+
 	/* Store this ino => policy_id mapping in the encrypted_file_info. */
 	return append_ino_and_policy_id(ctx, pctx, ino, policy_id);
 }
diff --git a/e2fsck/problem.c b/e2fsck/problem.c
index e433281f..d8766a65 100644
--- a/e2fsck/problem.c
+++ b/e2fsck/problem.c
@@ -1319,6 +1319,14 @@ static struct e2fsck_problem problem_table[] = {
 	  N_("@i %i references EA inode but @S is missing EA_INODE feature\n"),
 	  PROMPT_FIX, PR_PREEN_OK, 0, 0, 0 },
 
+	/*
+	 * Encrypted inode found but the filesystem is missing the
+	 * encrypt feature
+	 */
+	{ PR_1_ENCRYPT_FEATURE,
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
index 00000000..6a2a02d7
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
+test_filesys: 13/128 files (0.0% non-contiguous), 20/128 blocks
+Exit status is 1
diff --git a/tests/f_encrypt_feature_missing/expect.2 b/tests/f_encrypt_feature_missing/expect.2
new file mode 100644
index 00000000..8fee27c1
--- /dev/null
+++ b/tests/f_encrypt_feature_missing/expect.2
@@ -0,0 +1,7 @@
+Pass 1: Checking inodes, blocks, and sizes
+Pass 2: Checking directory structure
+Pass 3: Checking directory connectivity
+Pass 4: Checking reference counts
+Pass 5: Checking group summary information
+test_filesys: 13/128 files (0.0% non-contiguous), 20/128 blocks
+Exit status is 0
diff --git a/tests/f_encrypt_feature_missing/image.gz b/tests/f_encrypt_feature_missing/image.gz
new file mode 100644
index 0000000000000000000000000000000000000000..d3e627e7338e73b24713e41d7c41ffcf42479745
GIT binary patch
literal 5566
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

literal 0
HcmV?d00001

diff --git a/tests/f_encrypt_feature_missing/mkimage.sh b/tests/f_encrypt_feature_missing/mkimage.sh
new file mode 100755
index 00000000..ca36a3fd
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
+echo foo > $dir/encrypted_file
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

