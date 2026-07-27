Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com [209.85.128.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32CF54248A4
	for <linux-ext4@vger.kernel.org>; Mon, 27 Jul 2026 21:14:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785186850; cv=none; b=EK9jNb118wUOmrRGEDkW/4Q+eQPaanT/oq8yR3nU1dl8kTsQ61L5dNNgA4W9FZCWRhcQ6voVuoycw5HuWXdskLn44THZlQnizc+kyy10eWx896gVw8VUoSvPEXSKOlpENKr9GlzwZvbxz9tFWgQ0V+s9AimeFaiu5RR5x0Cupzg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785186850; c=relaxed/simple;
	bh=YYX4PRGccGMh1KwJovA42eQ9e8ufrAwMDe3x1S5pvyg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FM+/x5f3dwAadDH1Dxx2y+p2yb64bew7EL92pohpz0RPAM1iS63lQtQmp1K4LUYfNM+/cB053YM8ta5lnsjO/LSZqKfpqGHas+NBkBAWKYE+D1V/dET9u5Bxmsceln7y1cRpt/uFAsCiVELy84rjJ+1EHx6xb7rP71o+fCjWmNQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=O7Eg0jc2; arc=none smtp.client-ip=209.85.128.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="O7Eg0jc2"
Received: by mail-wm1-f47.google.com with SMTP id 5b1f17b1804b1-4954aff6088so27177485e9.3
        for <linux-ext4@vger.kernel.org>; Mon, 27 Jul 2026 14:14:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785186847; x=1785791647; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=G54QCdrO+U0Xqb+6WwBKDtyTabMw6tndpTTn8FiSSP8=;
        b=O7Eg0jc2t/UvVlEC/LMKix2veGNeKdsrofVRkcSzRaYdJ/M59IGI8bDz9f6Y4WG4lT
         wOBTlbPDbppni547GhzwzmX1vpPE0IEVayOF19grb+5b2iqzS58vCUawBEyezO6JMZhO
         N3bZWLqQLXAml5r4E0wiA87yoZLex8EstD1k2+OuBD8oAwBDuHa7zLTAb5NZZISjn3Pz
         swaoIh7GmjreJ1B2RLrEWSm2whdT7a94HrGGViyENRUeRSFhsiMXTreMLbZaRRah9EER
         sqI7PfFGK9xgffjM3cwbO3Q2AJo+Q/SNTsPN7Kpv3jV7XmiX5EC5CLDZBh/i3Xbt6Ya/
         fEow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785186847; x=1785791647;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=G54QCdrO+U0Xqb+6WwBKDtyTabMw6tndpTTn8FiSSP8=;
        b=mM6DCEXpfDu4mjuF1iYv6S9Eh5sA1TuefbsOn+n2E4ZyjeUbA6q5LgHY8IThWMlxmx
         CcGI8z6RAcS/BKHDbCWx4ZWnOzU/wQQ4058SAc18tL47Q3pGTb71QdQr02cc4SRQKUr3
         fgNhDdxwNR3aX5f1kDmXemmYXb6lgKbvlf8DG2sRB1j2hQxKKEvsxDeYI5uibPoHNF1G
         +QcW2Mhjth4FHvr/b26yI8kp5SCQ27oUNQnltU9h3CseGgFXf5rAzMeuZ7376/krfwaX
         dZDlGzV7nldMHXkBhhU1PI3YgtNbFG7KuGxa19OuDEjPBCdYD/epDzEr5PFdPFOWM8hJ
         7NpA==
X-Gm-Message-State: AOJu0Yzq7d6vag13G6pLv1hceqmcYS8Lxbqjgyu7EkK7DujVkHt41PAk
	aZD1f1KpkIHS75XgHF4zY5PBGXZptmZbdJihNt2QR+893VUJ0pOxMYFelZvK38Zx
X-Gm-Gg: AR+sD1019I8lA5xHIAPhuvtWxRFVp+fcTn49tgcaKlBlppiCghMz+eVSLQo4TC6T/gt
	sV+O8ocxMRIfvibY7Q2vAPvgzqMy33EXnQQQViXzvGCsnff+41SXQWUrDdVL2aG1BccErfjGr+J
	YWn81dOuEVxAkj5T+QN+FPocbUKa7ExyUfx7BmeIChkuvQnQFfrbc4ymsT+2TxChQmjc6yS+HNk
	6DJe5/tKwv3i2IRy5M75tZq1xOPwCbtbrbBbYoYz32QL9m/HDlPzWPhqNUZYNq9nm8ZJOOauRuP
	OSxCegkdF0c6sdc4rF1XT8VDy7HmI+nW7ZByOo0cXoPkXWVHXTwrucni8pC070iYWWynvFcBrM6
	FIl3Cn6BQqJWM+uhUhjupJwr7MQvaJjn5NF8peXxGhe+pfRAXMlprx0Abr84ypsjvZKSyMiHSYz
	tpTR7Qye6yzVJKtbMMTITWpr/l5lSU42IfUA==
X-Received: by 2002:a05:600c:5253:b0:495:4732:1eb9 with SMTP id 5b1f17b1804b1-496c4fce74dmr7213205e9.21.1785186847345;
        Mon, 27 Jul 2026 14:14:07 -0700 (PDT)
Received: from Cluster1.powerhub ([2a0a:ef40:18b5:9e01:f5de:1ef8:371:ee89])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-47f85c67339sm54987049f8f.31.2026.07.27.14.14.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Jul 2026 14:14:06 -0700 (PDT)
From: Artem Blagodarenko <artem.blagodarenko@gmail.com>
X-Google-Original-From: Artem Blagodarenko <ablagodarenko@thelustrecollective.com>
To: linux-ext4@vger.kernel.org
Cc: adilger.kernel@dilger.ca,
	Artem Blagodarenko <artem.blagodarenko@gmail.com>
Subject: [RFC PATCH v4 05/11] ext4/064 encryption + casefold feature combination WITHOUT dirdata
Date: Mon, 27 Jul 2026 17:13:41 -0400
Message-ID: <20260727211353.19736-10-ablagodarenko@thelustrecollective.com>
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

