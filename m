Received: from mail-wr1-f41.google.com (mail-wr1-f41.google.com [209.85.221.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05B453E51FF
	for <linux-ext4@vger.kernel.org>; Mon, 27 Jul 2026 21:14:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785186852; cv=none; b=KSGki+A20BuuLbk+N2hzZGJOcjoW1c0bFg174K1aDjWC9mNkvOG1AxJTXh1qCfZTdeiSegh+q9Rc6osc43mIH18V51Xe+/dCmrRc3c7KQBYZfnUTIONwQocV6IxH4/SewM2p64gpClEgcPhqAqLCkf0wWYrkjpi4foN9+hL/Hhg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785186852; c=relaxed/simple;
	bh=CKvhWxOHYEeaWDVUP9lJdxf5XBJ0qAwqwSXdJpgQhw4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rxer9XTtj8cXxm6jqXLoy/vPAZT3sieZoE7U0PdLX1L1O3O+cu6b76QhFzAM3ag1QTIihVoQzhYqOaKs8a81fBx2zUpZQolnPmxCAcBX9tPblg8IK1xVlrSLxzpeX6AcRjk75nkXqWgeZOoxOkoTPEQZWTZNjJzxsVBN9vYmU30=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=dqNv+o2+; arc=none smtp.client-ip=209.85.221.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="dqNv+o2+"
Received: by mail-wr1-f41.google.com with SMTP id ffacd0b85a97d-47ddf7b09e5so3206067f8f.1
        for <linux-ext4@vger.kernel.org>; Mon, 27 Jul 2026 14:14:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785186849; x=1785791649; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=xbjmFUN9Mmjq0j0wxf3xleVyMEccRIm4DhxX60/DY/U=;
        b=dqNv+o2+VjY6dxYex9wEUN1MetQ1V8/R4t2VfhHfAqp/OopH2v1pkqP4GeRoXCieeG
         MPa83Ddp4t4PeZM2KkQe20BdniUQoR5AtNJxX8fRp5+UxVBkTpDiNd1feMk6zjr2hn6J
         yHkoYHjdTMcLWlFnrLhd9QY2f7AVBg/INWt11stapKDDXJrNKFMK8yK44qoMgpRut1uH
         S+NK35I0ObXlqmcDdJoqddT/Cus++nWNNvLTWzf6Hwk+9P7mfGzCiIeF0sO6fuZ9tt6v
         /Gv+rW5i8Jwos/5+wUpm22vg3FggYIsTUfNloNIxUuydJPTQ5o8BNZBnBldYOBt6tUjK
         wwyg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785186849; x=1785791649;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=xbjmFUN9Mmjq0j0wxf3xleVyMEccRIm4DhxX60/DY/U=;
        b=NBY1fZ11bC2HrsD6DSh2bWmAiKGc2BmV7F0Nww8iZIpgqK4dXi/sEBk+N2GHmXw9Fs
         ipAEKz9Qjqajnzd1WQdMqqWx4O+uYOugpEWn2s17blWI0z2WafIsXvCD3XOa/exB2YBV
         Pabjk1ccQkpAIvHxuMDWLNMTYe3zlLZpCpThplMbQi9vKthJXsY+UVxlY47gRkRP7oyU
         jTQIwFooXL3Vt25B+kvGP+KaBAnDvu6K8AOgEb+9EIO4xWdFo/V0JwbHYi4fEzkU5eyJ
         VlOPtC5PIGClfJeQJdR3loIsZgoOx91NsGeK10f42sr7PQmS8BJomw6xClha7CHKsHB6
         HBxA==
X-Gm-Message-State: AOJu0YzhEKWrcLRAjyHThzLLdVM9OyXmtGk6AD8XouFfhzQLdkKZmEGG
	93E6NufgJEJyqSO4khf4tgyE8KTPCBMXk4VpFh+Bw2u0x9NkXpwmkrTQ0TXXLPZ1
X-Gm-Gg: AR+sD12JFX9q07r+y35oZV71MGf54GxMBz+DLQAVbgJ/AQhl4C1HOWkgkSwwEcrkNnU
	WlwpZxfjqGLhzJWIOj1uUzviEljOPEQctQJ/QQAIs0/ZzjmOoh8u6iDqrznkVqjYtS1pbgDfg4S
	fZXmYsAM+PIq3AF8TDx7uq+Ev1iKwfHnJb/6tD1LpCSuPKNJt/1C+fjPCaDs4AGNBNu4IVrrlTV
	xYupQgtXWFTpTkcEDfwV86Cu+tNFOmikLGbZANMgP6wgIOSBYcOLkaKaIHoVL7JBSGOcSE0inMz
	EkOl1XQ0Wt+g2vL4mdlJmq/8Vjw1ss/tnjRGelrECWEHW0US3KqOg2w6UvdNaPUyxvP5k7qxZak
	qr3+N+n4TGCsQ+vd25E8F9DKi/BCikMcRpwuCRspI1Ey+x19YrMnBvhmM0BIksQCKdd1ykGdfba
	ftpzpT2BqG2Dw2NrC/ynu2KmgIXqYjVkHc+A==
X-Received: by 2002:a05:6000:240a:b0:47d:e5b7:8f2b with SMTP id ffacd0b85a97d-47f9fea2bb4mr13261871f8f.53.1785186849141;
        Mon, 27 Jul 2026 14:14:09 -0700 (PDT)
Received: from Cluster1.powerhub ([2a0a:ef40:18b5:9e01:f5de:1ef8:371:ee89])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-47f85c67339sm54987049f8f.31.2026.07.27.14.14.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Jul 2026 14:14:08 -0700 (PDT)
From: Artem Blagodarenko <artem.blagodarenko@gmail.com>
X-Google-Original-From: Artem Blagodarenko <ablagodarenko@thelustrecollective.com>
To: linux-ext4@vger.kernel.org
Cc: adilger.kernel@dilger.ca,
	Artem Blagodarenko <artem.blagodarenko@gmail.com>
Subject: [RFC PATCH v4 06/11] ext4/065 encryption + casefold + dirdata feature combination
Date: Mon, 27 Jul 2026 17:13:43 -0400
Message-ID: <20260727211353.19736-12-ablagodarenko@thelustrecollective.com>
X-Mailer: git-send-email 2.43.7
In-Reply-To: <20260727211353.19736-1-ablagodarenko@thelustrecollective.com>
References: <20260727211353.19736-1-ablagodarenko@thelustrecollective.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Artem Blagodarenko <artem.blagodarenko@gmail.com>

Test ext4 encryption + casefold + dirdata feature combination.
This test verifies that files created in directories with encryption,
case-insensitive (casefold), and dirdata attributes work correctly.
See ext4/064 for the same test WITHOUT dirdata feature.

Signed-off-by: Artem Blagodarenko <artem.blagodarenko@gmail.com>
---
 tests/ext4/065     | 252 +++++++++++++++++++++++++++++++++++++++++++++
 tests/ext4/065.out |  26 +++++
 2 files changed, 278 insertions(+)

diff --git a/tests/ext4/065 b/tests/ext4/065
new file mode 100755
index 00000000..b86d3146
--- /dev/null
+++ b/tests/ext4/065
@@ -0,0 +1,252 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (c) 2026 The Lustre Collective.  All Rights Reserved.
+# Author: Artem Blagodarenko <ablagodarenko@thelustrecollective.com>
+#
+# FS QA Test ext4/065
+#
+# Test ext4 encryption + casefold + dirdata feature combination.
+# This test verifies that files created in directories with encryption,
+# case-insensitive (casefold), and dirdata attributes work correctly.
+# See ext4/064 for the same test WITHOUT dirdata feature.
+#
+. ./common/preamble
+_begin_fstest auto quick encrypt casefold
+
+# get standard environment and checks
+. ./common/filter
+. ./common/encrypt
+. ./common/casefold
+. ./common/attr
+. ./common/ext4
+
+_exclude_fs ext2
+_exclude_fs ext3
+
+# Check if dirdata feature is supported and can be used with encrypt+casefold
+_require_scratch_dirdata()
+{
+	if test ! -f /sys/fs/ext4/features/dirdata ; then
+		_notrun "dirdata feature not supported by kernel"
+	fi
+
+	# Debug: log e2fsprogs tool paths and versions
+	echo "=== _require_scratch_dirdata debug info ===" >> $seqres.full
+	echo "E2FSCK_PROG: $E2FSCK_PROG" >> $seqres.full
+	echo "E2FSCK_PROG resolved: $(type -P e2fsck)" >> $seqres.full
+	echo "MKFS_EXT4_PROG: $MKFS_EXT4_PROG" >> $seqres.full
+	echo "fsck -t ext4 resolves to: $(type -P fsck.ext4)" >> $seqres.full
+	$E2FSCK_PROG -V >> $seqres.full 2>&1
+	$MKFS_EXT4_PROG -V >> $seqres.full 2>&1
+	echo "=== end debug info ===" >> $seqres.full
+
+	# Also verify that mkfs supports dirdata
+	if ! $MKFS_EXT4_PROG -O dirdata -n $SCRATCH_DEV &>>$seqres.full ; then
+		_notrun "mkfs.ext4 does not support dirdata feature"
+	fi
+
+	# Verify kernel can mount filesystem with encrypt+casefold+dirdata
+	echo "Running: _scratch_mkfs -O encrypt,casefold,dirdata" >> $seqres.full
+	if ! _scratch_mkfs -O encrypt,casefold,dirdata &>>$seqres.full ; then
+		_notrun "failed to create filesystem with encrypt+casefold+dirdata"
+	fi
+	if ! _try_scratch_mount &>>$seqres.full ; then
+		_notrun "kernel cannot mount filesystem with encrypt+casefold+dirdata"
+	fi
+	_scratch_unmount
+}
+
+_require_scratch_nocheck
+_require_scratch_encryption
+_require_scratch_casefold
+_require_scratch_dirdata
+_require_xfs_io_command "set_encpolicy"
+_require_xfs_io_command "add_enckey"
+
+# Helper to add a v2 encryption key and set policy on a directory
+_setup_encrypted_casefold_dir()
+{
+	local dir=$1
+	local raw_key=$(_generate_raw_encryption_key)
+	local keyspec=$(_add_enckey $SCRATCH_MNT "$raw_key" | awk '{print $NF}')
+	_set_encpolicy $dir $keyspec
+	_casefold_set_attr $dir
+	echo $keyspec
+}
+
+# Create a filesystem with encrypt, casefold, and dirdata features
+# Debug: log e2fsprogs tool paths and versions
+echo "=== e2fsprogs debug info ===" >> $seqres.full
+echo "E2FSCK_PROG: $E2FSCK_PROG" >> $seqres.full
+echo "E2FSCK_PROG resolved: $(type -P e2fsck)" >> $seqres.full
+echo "MKFS_EXT4_PROG: $MKFS_EXT4_PROG" >> $seqres.full
+echo "FSCK_OPTIONS: $FSCK_OPTIONS" >> $seqres.full
+echo "fsck -t ext4 resolves to: $(type -P fsck.ext4)" >> $seqres.full
+$E2FSCK_PROG -V >> $seqres.full 2>&1
+$MKFS_EXT4_PROG -V >> $seqres.full 2>&1
+echo "=== end e2fsprogs debug info ===" >> $seqres.full
+
+_scratch_mkfs -O encrypt,casefold,dirdata &>>$seqres.full
+_scratch_mount
+
+# Test 1: Create an encrypted + casefolded directory and verify lookups work
+echo "Test 1: Basic encrypted casefold lookup with dirdata"
+mkdir $SCRATCH_MNT/test1
+_setup_encrypted_casefold_dir $SCRATCH_MNT/test1 > /dev/null
+
+# Create file with lowercase, lookup with uppercase
+echo "hello" > $SCRATCH_MNT/test1/testfile.txt
+if [ -f "$SCRATCH_MNT/test1/TESTFILE.TXT" ]; then
+	echo "Case-insensitive lookup works in encrypted dir"
+else
+	echo "FAIL: Case-insensitive lookup failed in encrypted dir"
+fi
+
+# Verify the exact name on disk is preserved
+if _casefold_check_exact_name "$SCRATCH_MNT/test1" "testfile.txt"; then
+	echo "Original filename preserved"
+else
+	echo "FAIL: Original filename not preserved"
+fi
+if ! _dump_dir_structure $SCRATCH_MNT/test1; then
+	_scratch_unmount
+	_check_scratch_fs
+	status=1
+	exit
+fi
+
+# Test 2: Create files with different case variations
+echo "Test 2: Conflicting names in encrypted casefold dir"
+mkdir $SCRATCH_MNT/test2
+_setup_encrypted_casefold_dir $SCRATCH_MNT/test2 > /dev/null
+
+echo "first" > $SCRATCH_MNT/test2/MyFile.txt
+# This should fail or overwrite since "MYFILE.TXT" is equivalent
+echo "second" > $SCRATCH_MNT/test2/MYFILE.TXT 2>/dev/null
+content=$(cat $SCRATCH_MNT/test2/myfile.txt)
+echo "Content after writes: $content"
+if ! _dump_dir_structure $SCRATCH_MNT/test2; then
+	_scratch_unmount
+	_check_scratch_fs
+	status=1
+	exit
+fi
+
+# Test 3: Unicode normalization in encrypted casefold dir
+echo "Test 3: Unicode in encrypted casefold dir"
+mkdir $SCRATCH_MNT/test3
+_setup_encrypted_casefold_dir $SCRATCH_MNT/test3 > /dev/null
+
+# Test with UTF-8 characters
+fr_file1=$(echo -e "cafe\xcc\x81.txt")
+fr_file2=$(echo -e "caf\xc3\xa9.txt")
+echo "french" > "$SCRATCH_MNT/test3/$fr_file1"
+if [ -f "$SCRATCH_MNT/test3/$fr_file2" ]; then
+	echo "Unicode normalization works in encrypted dir"
+else
+	echo "FAIL: Unicode normalization failed in encrypted dir"
+fi
+if ! _dump_dir_structure $SCRATCH_MNT/test3; then
+	_scratch_unmount
+	_check_scratch_fs
+	status=1
+	exit
+fi
+
+# Test 4: Directory operations in encrypted casefold dir
+echo "Test 4: Directory operations in encrypted casefold dir"
+mkdir $SCRATCH_MNT/test4
+_setup_encrypted_casefold_dir $SCRATCH_MNT/test4 > /dev/null
+
+mkdir $SCRATCH_MNT/test4/SubDir
+if [ -d "$SCRATCH_MNT/test4/SUBDIR" ]; then
+	echo "Directory case-insensitive lookup works"
+else
+	echo "FAIL: Directory case-insensitive lookup failed"
+fi
+if ! _dump_dir_structure $SCRATCH_MNT/test4; then
+	_scratch_unmount
+	_check_scratch_fs
+	status=1
+	exit
+fi
+
+# Test 5: Verify inheritance of casefold+encryption in subdirectories
+echo "Test 5: Inheritance of attributes"
+mkdir $SCRATCH_MNT/test5
+_setup_encrypted_casefold_dir $SCRATCH_MNT/test5 > /dev/null
+
+mkdir $SCRATCH_MNT/test5/child
+echo "data" > $SCRATCH_MNT/test5/child/file.txt
+if [ -f "$SCRATCH_MNT/test5/CHILD/FILE.TXT" ]; then
+	echo "Attributes inherited correctly"
+else
+	echo "FAIL: Attributes not inherited"
+fi
+if ! _dump_dir_structure $SCRATCH_MNT/test5; then
+	_scratch_unmount
+	_check_scratch_fs
+	status=1
+	exit
+fi
+
+# Test 6: Remove and recreate with different case
+echo "Test 6: Remove and recreate with different case"
+mkdir $SCRATCH_MNT/test6
+_setup_encrypted_casefold_dir $SCRATCH_MNT/test6 > /dev/null
+
+echo "original" > $SCRATCH_MNT/test6/RemoveMe.txt
+rm $SCRATCH_MNT/test6/REMOVEME.TXT
+echo "recreated" > $SCRATCH_MNT/test6/REMOVEME.TXT
+if _casefold_check_exact_name "$SCRATCH_MNT/test6" "REMOVEME.TXT"; then
+	echo "Recreated file has new case"
+else
+	echo "FAIL: Recreated file case incorrect"
+fi
+if ! _dump_dir_structure $SCRATCH_MNT/test6; then
+	_scratch_unmount
+	_check_scratch_fs
+	status=1
+	exit
+fi
+
+# Test 7: Hard links in encrypted casefold dir
+echo "Test 7: Hard links in encrypted casefold dir"
+mkdir $SCRATCH_MNT/test7
+_setup_encrypted_casefold_dir $SCRATCH_MNT/test7 > /dev/null
+
+echo "linkdata" > $SCRATCH_MNT/test7/original.txt
+ln $SCRATCH_MNT/test7/original.txt $SCRATCH_MNT/test7/hardlink.txt
+if [ -f "$SCRATCH_MNT/test7/HARDLINK.TXT" ]; then
+	echo "Hard link case-insensitive lookup works"
+else
+	echo "FAIL: Hard link case-insensitive lookup failed"
+fi
+if ! _dump_dir_structure $SCRATCH_MNT/test7; then
+	_scratch_unmount
+	_check_scratch_fs
+	status=1
+	exit
+fi
+
+# Cleanup and verify filesystem
+_scratch_unmount
+
+# Dirdata analysis summary
+echo ""
+echo "Dirdata analysis:"
+echo "=== e2fsprogs debug info (before _check_scratch_fs) ===" >> $seqres.full
+echo "E2FSCK_PROG: $E2FSCK_PROG" >> $seqres.full
+echo "E2FSCK_PROG resolved: $(type -P e2fsck)" >> $seqres.full
+echo "fsck -t ext4 resolves to: $(type -P fsck.ext4)" >> $seqres.full
+echo "FSCK_OPTIONS: $FSCK_OPTIONS" >> $seqres.full
+$E2FSCK_PROG -V >> $seqres.full 2>&1
+echo "=== end e2fsprogs debug info ===" >> $seqres.full
+
+_check_scratch_fs
+
+echo "Encrypted casefold tests with dirdata completed"
+
+# success, all done
+status=0
+exit
diff --git a/tests/ext4/065.out b/tests/ext4/065.out
new file mode 100644
index 00000000..c1316430
--- /dev/null
+++ b/tests/ext4/065.out
@@ -0,0 +1,26 @@
+QA output created by 065
+Test 1: Basic encrypted casefold lookup with dirdata
+Case-insensitive lookup works in encrypted dir
+Original filename preserved
+  Directory structure of test1: OK (dirdata verified)
+Test 2: Conflicting names in encrypted casefold dir
+Content after writes: second
+  Directory structure of test2: OK (dirdata verified)
+Test 3: Unicode in encrypted casefold dir
+Unicode normalization works in encrypted dir
+  Directory structure of test3: OK (dirdata verified)
+Test 4: Directory operations in encrypted casefold dir
+Directory case-insensitive lookup works
+  Directory structure of test4: OK (dirdata verified)
+Test 5: Inheritance of attributes
+Attributes inherited correctly
+  Directory structure of test5: OK (dirdata verified)
+Test 6: Remove and recreate with different case
+Recreated file has new case
+  Directory structure of test6: OK (dirdata verified)
+Test 7: Hard links in encrypted casefold dir
+Hard link case-insensitive lookup works
+  Directory structure of test7: OK (dirdata verified)
+
+Dirdata analysis:
+Encrypted casefold tests with dirdata completed
-- 
2.43.7

