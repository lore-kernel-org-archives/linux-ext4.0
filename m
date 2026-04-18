Received: from mail-wm1-f52.google.com (mail-wm1-f52.google.com [209.85.128.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D9AB338593
	for <linux-ext4@vger.kernel.org>; Sat, 18 Apr 2026 22:39:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776551949; cv=none; b=Gz9RK18ITFC93kkHv8MH9Hr8w7qk8sUYYyfSEA65+s8UKVWA7fXJqBIUIO7aoNeWYQY8mj+bscrworobM6OB1ONsJY6/BLxHSUewn8NriSfp5G7ZfE5KgdAcwBgD08KcIUoxJ4xbyzQUiL1ntb6YIy7l7T3UkAI8jQvI76yK9io=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776551949; c=relaxed/simple;
	bh=TH+1KVvOdG0Ck9pqvalAAoLcVoUj0MFTTnvpwNe6ltM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Mp1Wmfg6I3Wq03B7eF2G8esrsTZ30l8F41RDlUAZctdDTkUcilOMNbdDlVuRqMPV7Y++fKh0VgzY7b4wUPaBZGZTsl0mSc/boq1fXCVlHv3KXfOjrKFF4z/oes9fZbvL6/Id3m8QEOoeIqrSWdyofrCOxPTpSVtonEnw/GyauqQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=BtfKktuC; arc=none smtp.client-ip=209.85.128.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="BtfKktuC"
Received: by mail-wm1-f52.google.com with SMTP id 5b1f17b1804b1-4888375f735so20483765e9.3
        for <linux-ext4@vger.kernel.org>; Sat, 18 Apr 2026 15:39:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1776551946; x=1777156746; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=JizdQQUWo88QZWsvp/MEmuK2lZp6YdT42tANpTBZ+Gc=;
        b=BtfKktuCFnlTKXTYspdtdTJaAKej2Zrv+nUlEwXb6JpJFTPkcu/sTEbTxWVix6tKJZ
         BIWLCcfRMLLg5x5Bx+PjsskxW8vi1IDIP79UjSWFpiSLkuWpXATCOt1aX80v2XMBU84S
         m00SIgOQDyy3f6yJ1V8nBTQe84rJPB/fDllLKBujkga15uzkS3YXs5qO6Tk5bxaLQYy7
         K0wZnj3WPRA76xwrd8U/WZtsRsJMJk3cZ0TlY8XemkITX8eCxnfNu1umjgQsA7jZWFa2
         9M9NzyrrttJZFi7xxwuDsx01W4GdmaDEGPNRBlePi3MgMshptmFB4amFdiaW/9x61bQA
         iJ0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776551946; x=1777156746;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=JizdQQUWo88QZWsvp/MEmuK2lZp6YdT42tANpTBZ+Gc=;
        b=Uu9hAwgfJkgC11JC1kFvxK5bOuvaOuhzcLC1jZJL6RA06u5wX/z6NAzyDnrAo5Yrxq
         wrGjJRifJIqkEvbJwiUOlbztpZIuLnMhgC9WjET6M04rCu+00asGPSyWlEkTnlkJIFVN
         U5oBCAWNefKTUhgdBfu8i4NuIwguEzDP7lVxq/U28jGk0dXPHenboS0NzVt1g7dx56Q9
         7mf619CjQRCiHXygAKxMdKc5m9WBl5Wxla2ZtIfRYbcCP/co9HyRlg6Cl4+BrbPl9P1h
         sLTyYfkGNsVyYK3M0qPPDNWvLNelDM/PQSHNlKEokP/1jPWbnxYbtX0IXYeUDW/Yjq6c
         MICQ==
X-Gm-Message-State: AOJu0YyzCEsTi+TwzJ0X5US4X2V4ge1dYw29Vm3aTziRadBnWc5ZXK/Y
	bXFPHpa/4Gae+jdSljwSI7/tYlpw2muS/PjV6fxRQiGn5rFLVrPxw4N4WeOmsBR+
X-Gm-Gg: AeBDiesqVZmLa+bvagqptbJ4JhkC9bRGCB+pUvqm6TmchInwrZKSimzhwscFMUn07NG
	M4LHQYj1iGCyVCTrEWQa1ul2Cbm1ECr8iNFVNNIGKJOK4tq5GAmD8M47EGhuRQX3dKpKKf7vZr9
	SHsQOLstGKSA5ntE1JhBISZqJs40YU3ZjaKzngLPG0hZK6OPTjl9rm/4S7p61PECEYhnj7GndbY
	1TG8kASN2dcggsvb191kc7kDJ/8Jo9L/oKOB3CwkYiLCWuV5FhBaifrpDUNgkmrFOps+gC1wdQc
	pxQZm0xGmH3/hUk9miB5SER1xZNHykaGW9NDahb4U54FfB90syQi5dsnhoieyWhfPFf/dw8SLWK
	hVFnrntRaZ3wwQjYE58lPNo1NawNImBUjxIjEo1YNgLzamiTEVeRfleq5ANP8x+ygFcV60kITJA
	25v/GJpZTCfZoK+JVCs/RTyCIf9eu6WdSsOYp3ZjQjcg==
X-Received: by 2002:a05:600c:a116:b0:485:b6dd:5066 with SMTP id 5b1f17b1804b1-488fb7471dbmr83261995e9.7.1776551946032;
        Sat, 18 Apr 2026 15:39:06 -0700 (PDT)
Received: from Cluster1.local ([2a00:23c7:90c1:9201:ef47:d559:d907:fd0b])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-488fc177dafsm201330545e9.4.2026.04.18.15.39.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 18 Apr 2026 15:39:05 -0700 (PDT)
From: Artem Blagodarenko <artem.blagodarenko@gmail.com>
X-Google-Original-From: Artem Blagodarenko <ablagodarenko@ddn.com>
To: linux-ext4@vger.kernel.org
Cc: adilger.kernel@dilger.ca,
	Artem Blagodarenko <artem.blagodarenko@gmail.com>
Subject: [PATCH 2/2] ext4/065 encryption + casefold + dirdata feature combination
Date: Sat, 18 Apr 2026 18:38:50 -0400
Message-ID: <20260418223850.20351-2-ablagodarenko@ddn.com>
X-Mailer: git-send-email 2.43.5
In-Reply-To: <20260418223850.20351-1-ablagodarenko@ddn.com>
References: <20260418223850.20351-1-ablagodarenko@ddn.com>
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
 tests/ext4/065     | 208 +++++++++++++++++++++++++++++++++++++++++++++
 tests/ext4/065.out |  17 ++++
 2 files changed, 225 insertions(+)
 create mode 100755 tests/ext4/065
 create mode 100644 tests/ext4/065.out

diff --git a/tests/ext4/065 b/tests/ext4/065
new file mode 100755
index 00000000..08863ac0
--- /dev/null
+++ b/tests/ext4/065
@@ -0,0 +1,208 @@
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
+_require_encrypted_casefold
+_require_scratch_dirdata
+_require_command "$CHATTR_PROG" chattr
+_require_command "$LSATTR_PROG" lsattr
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
+
+# Cleanup and verify filesystem
+_scratch_unmount
+
+# Debug: log e2fsprogs tool paths before _check_scratch_fs
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
index 00000000..e771d884
--- /dev/null
+++ b/tests/ext4/065.out
@@ -0,0 +1,17 @@
+QA output created by 065
+Test 1: Basic encrypted casefold lookup with dirdata
+Case-insensitive lookup works in encrypted dir
+Original filename preserved
+Test 2: Conflicting names in encrypted casefold dir
+Content after writes: second
+Test 3: Unicode in encrypted casefold dir
+Unicode normalization works in encrypted dir
+Test 4: Directory operations in encrypted casefold dir
+Directory case-insensitive lookup works
+Test 5: Inheritance of attributes
+Attributes inherited correctly
+Test 6: Remove and recreate with different case
+Recreated file has new case
+Test 7: Hard links in encrypted casefold dir
+Hard link case-insensitive lookup works
+Encrypted casefold tests with dirdata completed
-- 
2.43.5

