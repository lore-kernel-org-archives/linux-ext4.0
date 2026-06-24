Received: from mail-wr1-f52.google.com (mail-wr1-f52.google.com [209.85.221.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4B86FC0A
	for <linux-ext4@vger.kernel.org>; Wed, 24 Jun 2026 13:50:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782309031; cv=none; b=kRf+CG1BWiBcrZOl+2Zn568XxscKh1SRWtYPK3lgTjweOgbNe6W3rRcLDQZU26JowKUGUTuIw35gx3SH4FrCafquG5Zujq7eqawNGqfagF4gLtQzD5ARDZMFIvWJaSYS5wfeE7Pn92hiU7SYl1zSEvlHM50rPmDum3YYPdo6b7o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782309031; c=relaxed/simple;
	bh=YYX4PRGccGMh1KwJovA42eQ9e8ufrAwMDe3x1S5pvyg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=k2BEThWG5hl0EMhtgLwVkgx0rjJWNPyUSOCIIO2qBzQVEK10uKH6+y39YppxEE0LXT4fZugN/Y4jWw+BYb+J1v9wOa98HAEtE6/h52SvhmYE9RT8rLFwdDbFd/xPc3EctknskgtHt4ctFcPpok6so6wbLcJ3TkeThjPbHgIq26E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=R2ZNTkD8; arc=none smtp.client-ip=209.85.221.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="R2ZNTkD8"
Received: by mail-wr1-f52.google.com with SMTP id ffacd0b85a97d-45ef41adbc1so892777f8f.0
        for <linux-ext4@vger.kernel.org>; Wed, 24 Jun 2026 06:50:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782309028; x=1782913828; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=G54QCdrO+U0Xqb+6WwBKDtyTabMw6tndpTTn8FiSSP8=;
        b=R2ZNTkD8eTsa6S9GcdbhhHYFvPpHk9LHhwdAz/tVpJHGEo47+4jpJoskWsMKi782MN
         T2SMlGSTeDndd/bRES3GDEfqZJ+5mAQF4/JB96UOQEasf1o4Z3MWaiqnKTvfUY2CzgNc
         2/lWQQScq4wHthH7KopdZ+fq9kOzcli06HPbq3gxI8vjGL3evEFTxghnGQ0ruxmmcKhN
         FwRNltLdN0SHxjZ5p/5cHwOxKSBz4anAUKOs4w1gE2HhivKzc/Y5+dM+c530PvYELtCL
         NoQviHgxcreU20VCmf1RkqvsXqj2+18kgyRTwnOFwZUSqLlkVPKl2fmnaRmH8bnPO+Uz
         vDew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782309028; x=1782913828;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=G54QCdrO+U0Xqb+6WwBKDtyTabMw6tndpTTn8FiSSP8=;
        b=W0uDaElH0oobv3B9xEDAEZtaJKaCtA4ZhqKF4lhbbJ7r436RA2YVQRwOaUeTIU3lM0
         UpY8+9hCVZu6G/aAUur5BTAikaELU2F3oLg1IcBkJFYgodHHQmAJ1qbjMVef9ulDYRPS
         PWA+8YvzhVNItuvYoNlpwLe7zg2zfErcr91m5eFNEj7SSjvRaFnSJMVvB0XG2DwBGcSx
         N99uGv/KJ9155MtKK3VTrlZ4mMftYvzlc8AhE0BxAoManLjdZqGSm6k3XwGdm56B9if8
         4XacEF36VdnARX7Jdad7Q3XybOGCkgFJOLpKTQXZrLJIZCTKCKOJpWE3p/QTxfAns973
         UQnA==
X-Gm-Message-State: AOJu0YxKYpLDP14j5vRjEW4NXj2cj159qnph55gdze92+5Cd0tYQU2Z1
	Csz09tiXOQp/HRDWMEwiJQb+JrOM1nAqLVcjDL7pMvUoGeie6uRfgoCED0+LY9IhHBE=
X-Gm-Gg: AfdE7cn8zNe/LX+KW0z9zlteaUI/D8Gj6MyIFNSpd8Ev4MIN5O//v2qd1z9UdJxpWKI
	gF63CWNMLIh5rVmQnkhcZDi1HHORLofoMduADdCWZ/Byrxv8yx/y0ElH5/Giia4JsNA+aBLtWO0
	ofgKHgs8ZFSamGlZ4TGfmnCyIL8umoW3Qr+fbH/qHKrSoP1/bIWR5DGZV4Sgocy48WPf13+x6NI
	xvEsFLMdePhiWJVWOlD2KtRfVivmqMfd1Cs6sAcI28OmWBO25rqnhiXWYT0R7X6844C59b2MISa
	D6ahVFGGCOH7k5a7bsJavfeBRaDrCw/QF/IKyKVj8hyAAqbB+F2m4GSCx9UAGyabgkXyEXFYPo/
	wVVbQPySxafwZyOg6rcztShJFAkkJYst+zbgyMuNJ8+EJ3UAVavmbWk7fKerG6ldRNk/bwr/W8v
	s6xl7HCRe0kO5hwQkUXaN8rWQ057Oi5YExx2d6A8EXbeEB8O2SgCh9LRs=
X-Received: by 2002:a05:6000:29c8:b0:46c:cffc:7638 with SMTP id ffacd0b85a97d-46ccffc7729mr1875032f8f.30.1782309028223;
        Wed, 24 Jun 2026 06:50:28 -0700 (PDT)
Received: from Cluster1.powerhub ([2a0a:ef40:8ee:1201:acf4:9ddd:6ede:2d9a])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-46c1e840eefsm7791658f8f.1.2026.06.24.06.50.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Jun 2026 06:50:27 -0700 (PDT)
From: Artem Blagodarenko <artem.blagodarenko@gmail.com>
X-Google-Original-From: Artem Blagodarenko <ablagodarenko@thelustrecollective.com>
To: linux-ext4@vger.kernel.org
Cc: adilger.kernel@dilger.ca,
	Artem Blagodarenko <artem.blagodarenko@gmail.com>
Subject: [RFC PATCH v3 2/6] ext4/064 encryption + casefold feature combination WITHOUT dirdata
Date: Wed, 24 Jun 2026 09:49:53 -0400
Message-ID: <20260624134957.19209-3-ablagodarenko@thelustrecollective.com>
X-Mailer: git-send-email 2.43.7
In-Reply-To: <20260624134957.19209-1-ablagodarenko@thelustrecollective.com>
References: <20260624134957.19209-1-ablagodarenko@thelustrecollective.com>
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
 tests/ext4/064     | 153 +++++++++++++++++++++++++++++++++++++++++++++
 tests/ext4/064.out |  17 +++++
 2 files changed, 170 insertions(+)

diff --git a/tests/ext4/064 b/tests/ext4/064
new file mode 100755
index 00000000..53450927
--- /dev/null
+++ b/tests/ext4/064
@@ -0,0 +1,153 @@
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
+_require_scratch_encryption
+_require_scratch_casefold
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
2.43.7

