Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com [209.85.128.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 078A4338593
	for <linux-ext4@vger.kernel.org>; Sat, 18 Apr 2026 22:38:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776551939; cv=none; b=Qy0/kO6WKU83vCBHq16LhAVc/RvCpvu00mq6vA2E1+7TXYrvIdbq3dIWKKx89ofvizEUPzglZlSYI+IGz2llwvWv7DF9+MfWBYl7y7wU504hwFcFdZPBVn6bDJFDum7AEVTioPY+APcMWlbiXgFInHyVZoxwoczyBDkak/6cYKs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776551939; c=relaxed/simple;
	bh=e2ZXz9El51g1RD6EKfetxbYKJLS2iylvtEyIUN89uSU=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=n6ODkVOdCXsa7NWI0FKTdi/VKK/SrL/z49eZ8TI2vZips8evD5L1y95ANF/rGByu7gh6PoWO3yTNE+Ze6Q+NGLfjOlmCnI+8Qbsm+tklpB/4OTeEfy0k+R4gnLBXaFjOnVUp1aRYZCQZliYoJnbwwRLwjX9I4gqSlRQdo18ZMKc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=fXtV+82l; arc=none smtp.client-ip=209.85.128.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="fXtV+82l"
Received: by mail-wm1-f45.google.com with SMTP id 5b1f17b1804b1-483487335c2so16831785e9.2
        for <linux-ext4@vger.kernel.org>; Sat, 18 Apr 2026 15:38:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1776551936; x=1777156736; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=JOLVEsbAJOmJN5pZrazzA23v63Rjq08BMGljx81/Nek=;
        b=fXtV+82lZQ3rZy7NdgW+8lNZgXG3i2BCFqIxjJPLZlKE50JRSTRsj1Is/d81eMRy7i
         IhAJ0RFA3PbDH17lQGRDlppje9lyQynqdFl83CcBOlqC8QhD45P0qhSWwVmExuZCrG1r
         ToZwjmMzBGfn3KWprmVpQTfz2NCsK/3FXPkFiwSiqd6rCCwFczrTaV2+Y6/1/mPArmyW
         8oaVHYh3aG6rXK5ynqn6+nVg80dKKFdOnXBQbMUfWiiTdRmYQ/QXBGpiyfooKCwnMj0B
         YKKo3gLJb88lut1hh3gRRmpJ5iL5nsMOplwGbuoZSWIOiN4bM1cC16S0eBcd3eFACgAd
         AO0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776551936; x=1777156736;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=JOLVEsbAJOmJN5pZrazzA23v63Rjq08BMGljx81/Nek=;
        b=p0FqmrJzgJ/OTrSHT39XtGwUH0KZ7bosJIuVHQTY+uhQoh6+Zh7h4zdQdQ47V00Pbu
         bNLQwWE/fE2AJOgDIWpZpvrXpI5syiu3HDD6iWiDV3r2cM6hiw6t2kXarDdwe8ScYBtt
         o57kNv8YeDCc26dyr3wsazCsxagFUNlANclhgdb6TMERG7Ye/UbDAPuVY8bN/kupGbG4
         OThNp1K9kzaU/XbmaFhr+pJSjpZfr6EXDt/sNFSgXjdPTde86nTq3UmwD3/PX6mnxzs7
         qF1E6D5uG+TIAll0jl0zUEoCChZCIrD6/flFyP8qxRYl10LVHJ/LaGtxJjP42gBZgs6B
         YSKg==
X-Gm-Message-State: AOJu0Yza0qHKxuQS6Q3Duap/tPz+Y62D4xHdZ+SWzrhkMIq6ahVyslP7
	hM0NjW5/s6Ls8DU3/dGrl3DxrKIVzf22rOIUc3swytAP40Gn4zQdmhe+BLXZoh8t
X-Gm-Gg: AeBDietF8V/+3iPG13B0eaeOUVyrxwnCB7BIP7LQth3t6ZcShhzbZA44SmEOiStZk26
	iic08ECu3yiO2y9W7bANEVGhgMDepfZAZ956AtYjciiNBTs3FCyjsFzwOzO4KZbG7RMDN8+yo7j
	4lcT5cR+WA1RTQjW+0TBOGdTBuo8NHB2lZ0Qt6TVUhpDbr34v8gGRII1TCRvecJvfF8BZ7xKanY
	xfsaCvizbM0yfQgA5i2qindUP+5XD+YHFM+hyENOtnq4O0Z1vjpzImNe59VIOEKBSQAFVCigi/i
	CLcIk++4Tup8wJv1v8df+yZyGKyFqVNULWY5bYPjoqGgLgJ0Cn68VnXP/96XHdcNzoAXQc7Gu/e
	8x+nE/J7SeBAUWjVc7689zU24xbou5JBaYcTznOGOxht/eF91Dc+nF0EH2DYqZ8PEn+H88t5dvD
	V5GWTSt3yTnTtbHLFsFt2fg2bNrAbfnW6zo0KSLg/nWA==
X-Received: by 2002:a05:600c:46c8:b0:488:ae4e:51a5 with SMTP id 5b1f17b1804b1-488fb778d5dmr114709675e9.15.1776551935889;
        Sat, 18 Apr 2026 15:38:55 -0700 (PDT)
Received: from Cluster1.local ([2a00:23c7:90c1:9201:ef47:d559:d907:fd0b])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-488fc177dafsm201330545e9.4.2026.04.18.15.38.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 18 Apr 2026 15:38:55 -0700 (PDT)
From: Artem Blagodarenko <artem.blagodarenko@gmail.com>
X-Google-Original-From: Artem Blagodarenko <ablagodarenko@ddn.com>
To: linux-ext4@vger.kernel.org
Cc: adilger.kernel@dilger.ca,
	Artem Blagodarenko <artem.blagodarenko@gmail.com>
Subject: [PATCH 1/2] ext4/064 encryption + casefold feature combination WITHOUT dirdata
Date: Sat, 18 Apr 2026 18:38:49 -0400
Message-ID: <20260418223850.20351-1-ablagodarenko@ddn.com>
X-Mailer: git-send-email 2.43.5
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Artem Blagodarenko <artem.blagodarenko@gmail.com>

This test verifies that files created in directories with both
encryption and case-insensitive (casefold) attributes work correctly.
See ext4/065 for the same test WITH dirdata feature enabled.

Signed-off-by: Artem Blagodarenko <artem.blagodarenko@gmail.com>
---
 tests/ext4/064     | 154 +++++++++++++++++++++++++++++++++++++++++++++
 tests/ext4/064.out |  17 +++++
 2 files changed, 171 insertions(+)
 create mode 100755 tests/ext4/064
 create mode 100644 tests/ext4/064.out

diff --git a/tests/ext4/064 b/tests/ext4/064
new file mode 100755
index 00000000..6ad865a9
--- /dev/null
+++ b/tests/ext4/064
@@ -0,0 +1,154 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+#
+# Copyright (c) 2026 The Lustre Collective.  All Rights Reserved.
+# Author: Artem Blagodarenko <ablagodarenko@thelustrecollective.com>
+#
+# FS QA Test ext4/064
+#
+# Test ext4 encryption + casefold feature combination WITHOUT dirdata.
+# This test verifies that files created in directories with both
+# encryption and case-insensitive (casefold) attributes work correctly.
+# See ext4/065 for the same test WITH dirdata feature enabled.
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
+_require_scratch_nocheck
+_require_encrypted_casefold
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
+# Create a filesystem with both encrypt and casefold features
+_scratch_mkfs -O encrypt,casefold &>>$seqres.full
+_scratch_mount
+
+# Test 1: Create an encrypted + casefolded directory and verify lookups work
+echo "Test 1: Basic encrypted casefold lookup"
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
+_check_scratch_fs
+
+echo "Encrypted casefold tests completed"
+
+# success, all done
+status=0
+exit
diff --git a/tests/ext4/064.out b/tests/ext4/064.out
new file mode 100644
index 00000000..0197e51e
--- /dev/null
+++ b/tests/ext4/064.out
@@ -0,0 +1,17 @@
+QA output created by 064
+Test 1: Basic encrypted casefold lookup
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
+Encrypted casefold tests completed
-- 
2.43.5

