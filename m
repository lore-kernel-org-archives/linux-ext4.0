Received: from mail-wr1-f50.google.com (mail-wr1-f50.google.com [209.85.221.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 492BA4964F
	for <linux-ext4@vger.kernel.org>; Fri, 19 Jun 2026 19:53:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781898797; cv=none; b=InvzjxuaAoXXBxfxEEOfVEfDwc2AcrQEtD+rlETLUXiWh6/7tYM1m3o1k7UtRlqcQqzIg1f19DyD028SF5bBr29dc+fYZAYRRfWOQgBmKCdT7b4ga9LBgk9pIBUwJLt1/fb7oG8NUpJACOH5K8FI+3PqHOFNAivz/1aTx2HgAYQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781898797; c=relaxed/simple;
	bh=emGQHAjptxZoYiC8mXoPbThWW+m7nZS8zdC7cE7py50=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mV9wd46QBSm5Bmn8X1Ck+379neVLYPA6bUggGoermXM+v5NLJfP2/fI3+5/7dLSWL0ULOOQHvVmSvmULEfn8GxIvkYYjk+rGlu7BBOg7uXzf0f49Ktk4+3hc3BHUKtlVAAJCzi1ixF3rKpJsS0JggTvZ5Xw/lKGZjVp4cRClYr0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=fYpqf8XL; arc=none smtp.client-ip=209.85.221.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="fYpqf8XL"
Received: by mail-wr1-f50.google.com with SMTP id ffacd0b85a97d-45fd461e4a5so1900818f8f.0
        for <linux-ext4@vger.kernel.org>; Fri, 19 Jun 2026 12:53:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1781898794; x=1782503594; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=U2mnVk0kMz0EbLumvr8FvtNeW7qSZ4DHc+Ma141ddk8=;
        b=fYpqf8XLtshcu76MRTrpgJQNuUZwLwR8NWG1ziA+/4qv5Z288+ICCNKdlYL8ekfr8T
         MzbvcK9rjft6qSXNAerRocVTfb4VwdS5CADbbzq2eTOUJGX4ocb/tJZmKHlBVLmf7Zia
         eeM4fcSXX/c3RNUdfniE5hO3Q3cFOrmAm+eqLyWgKJ+A+w2NwTU85SWxdMlcOz6CE0Vo
         pbxvX43Ho+2/RZOaFpck7c7v7nfgJ5xWmwsYhr1P65yc5TuEuuuslrwNRHxh+FKCbbz/
         nfRhlzP63P1quwO54NLyEBq0jr4NFvc7hA2S/oBg0kqGd+Rkz5hvfrYWPdIjbwflD0Uv
         s7Zw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781898794; x=1782503594;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=U2mnVk0kMz0EbLumvr8FvtNeW7qSZ4DHc+Ma141ddk8=;
        b=B1iXZ9WkHvk32zhKl/wSGKw+F94gQZGXH+hLdVgbQYO1rnx2LSvGwNXU+UbrJpIwwV
         zWAm8F5RKzabmc8LtLQ1+aYEwk74OdOD1sXTGmN8K58mNRdDfCzb4Sf/Mm4g+hZMipEy
         HXvEM+wZOdWwhF9EqyupxYpFQhfMk/2Tj/iTFhhDf6g7lXFWk8AdtwnXVdbzaBVHKQbP
         U7ybtieTY+jGgWMB+A9176kwfMJXMG7lJboL3ExfFGSYzAfImd5MRT5ODJTS6rOlLzEW
         fAQ7tGUHnQF3LnBA8Qs+b3yU8eVmEtJsAOE/2x2I9HpcOnbFi9QBGvpvF21dKiGFQ0k3
         nfDw==
X-Gm-Message-State: AOJu0Yy7h6en2gz0iVh0IxyxPzT/D7iNKDxsHIqCJ+LJEnn20p14hT/i
	BFvdi28DordESPD3VxdOJeKvr7IuTkwLgtTCrTlapvPWw4c0Oz6ewBS2V3rCQ1U5tR0HQg==
X-Gm-Gg: AfdE7cma+JrxI64k/O2sjldh5kuMcsDAMXwDnHFUmPKI66bjSc72HA0x63r0bgucpmR
	VLGxww7cU9Rhy/c0xzxQCbKBomt8ro7xqYWLsbQMSeuWnACgwh9IxnNrUyja4q6bCZDkB3DUEut
	n1Y7MkcThLjLorbzYFkrSm5ZyR9HVCvsNm/cbGKYHSGfXXCGRJXKCYNuN5xZ7/qwDbnpOjIuf2R
	tMC0yNCWmdvyLlBFq18F6AxCHcm7FuK+HrxeliRTjxwclnMSSUQuTE4Y+ZImW5GYhnILb0LW339
	OtbrpuKrrnx+cAJr16DQWGjI1ZoQAr4FQs0sP02GvRgRAJslFJ8Q3HydmlHHiD9D6OE7c7I4Ll2
	TWDnT2AofebjJwuuvaBuDV6Wlh9ms+llVuhamncEknNpK1UEhgP2GUFJLEI3fJ2ajbZbXUVMKHM
	ZlKlSEh46rKQmTk059v6dCdV7s6BsB1ZT07iJeBiRWUA==
X-Received: by 2002:a05:6000:4308:b0:461:9ffe:1db0 with SMTP id ffacd0b85a97d-4656dff26c2mr6490039f8f.24.1781898793564;
        Fri, 19 Jun 2026 12:53:13 -0700 (PDT)
Received: from Cluster1.local ([2a00:23c7:90c1:9201:ef47:d559:d907:fd0b])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-466643f4e3esm1430822f8f.8.2026.06.19.12.53.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 19 Jun 2026 12:53:13 -0700 (PDT)
From: Artem Blagodarenko <artem.blagodarenko@gmail.com>
X-Google-Original-From: Artem Blagodarenko <ablagodarenko@thelustrecollective.com>
To: linux-ext4@vger.kernel.org
Cc: adilger.kernel@dilger.ca,
	Artem Blagodarenko <artem.blagodarenko@gmail.com>
Subject: [RFC PATCH v2 3/6] ext4/065 encryption + casefold + dirdata feature combination
Date: Fri, 19 Jun 2026 15:52:02 -0400
Message-ID: <20260619195205.29384-4-ablagodarenko@thelustrecollective.com>
X-Mailer: git-send-email 2.43.7
In-Reply-To: <20260619195205.29384-1-ablagodarenko@thelustrecollective.com>
References: <20260619195205.29384-1-ablagodarenko@thelustrecollective.com>
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
 tests/ext4/065     | 217 +++++++++++++++++++++++++++++++++++++++++++++
 tests/ext4/065.out |  26 ++++++
 2 files changed, 243 insertions(+)

diff --git a/tests/ext4/065 b/tests/ext4/065
new file mode 100755
index 00000000..0ad7a382
--- /dev/null
+++ b/tests/ext4/065
@@ -0,0 +1,217 @@
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
+_dump_dir_structure $SCRATCH_MNT/test1
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
+_dump_dir_structure $SCRATCH_MNT/test2
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
+_dump_dir_structure $SCRATCH_MNT/test3
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
+_dump_dir_structure $SCRATCH_MNT/test4
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
+_dump_dir_structure $SCRATCH_MNT/test5
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
+_dump_dir_structure $SCRATCH_MNT/test6
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
+_dump_dir_structure $SCRATCH_MNT/test7
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

