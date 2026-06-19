Received: from mail-wr1-f46.google.com (mail-wr1-f46.google.com [209.85.221.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90F71336885
	for <linux-ext4@vger.kernel.org>; Fri, 19 Jun 2026 19:53:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781898796; cv=none; b=BUA/vfNF2UHjdo2ACdVUyimDhxB2rQW4EBGHZYddB7jpbfr0BeFI94isWopvAoo3PC0QPh6aZHglNEbwqcgT0RYQbvAI+63SvXYPNb6G7+BTOErsfAVtTznRVktZjRATiO6NQHoITyAtZnfP4qVqaRcU49x+vySYzUUcHFxuCyc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781898796; c=relaxed/simple;
	bh=YYX4PRGccGMh1KwJovA42eQ9e8ufrAwMDe3x1S5pvyg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UQrlaG6gfYsWHZoLCnE47nxskrLlrB+fiuXmoU+DejBFdwq+0OxL+jRIa1WsI2+xsDi51SeDbzPwSuuBJ6fenYz9P55HfWYhSJ60dApb1tzxq8v3GY9A8BGhJJ5AOoSJ5/s0VP4g82pj8mbI5luQBbGd/9Q1U7GKDPqujN306DA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=my+xyp97; arc=none smtp.client-ip=209.85.221.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="my+xyp97"
Received: by mail-wr1-f46.google.com with SMTP id ffacd0b85a97d-45fd461e4a5so1900813f8f.0
        for <linux-ext4@vger.kernel.org>; Fri, 19 Jun 2026 12:53:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1781898793; x=1782503593; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=G54QCdrO+U0Xqb+6WwBKDtyTabMw6tndpTTn8FiSSP8=;
        b=my+xyp97sERfoA76OQ3WyrtrQNx8ixt3t1ux622Hz+7YUYVAdImDMGZHyDp+WSN0Gv
         m/WeV+Yle2+1OhM0izIQyRDyjqvNYreLvF+5LkAqLHjb87q7BAI5i93PcedYknpkYHAB
         Y5pvotxX1ClcYJkNAxZLPhUV8eLSbtqImGs7uM2kggWslTrc9t5rvXKgnNqm+lSJ2oTH
         fYftn8R69kLeMQAkvDX+fAwUFhuc9vS75nyQKQ0azIU7oYrnYp3wBCMCqQvIuL9Fe1Bq
         59+c94y30/p5Ftzx86VRZb9tC/Dp6ASoXhh6PfcEyiJD5UcMIUZWDW0le2SyHTWHcBaX
         GLkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781898793; x=1782503593;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=G54QCdrO+U0Xqb+6WwBKDtyTabMw6tndpTTn8FiSSP8=;
        b=Sm8TPrakXe/tk80bNVTV74vt/DWSJtR5InMtciOXN7kVpvBOzVILt6BBXUKgjh6WaB
         E1hVaZW6doK9ZMcj4Iy1BBHiABun6lLx/psQVxIfuxI6MWUVbDKOnGwQITv/wWPqrYbU
         tnGGKI/diKbDHsY4pTFRoFGUGn8CIXxbfp0yzhJNHdo2KjuQQYVF9lFe4Q9mHDh3fSk5
         pcdbxdqdGep0chRXLUYczLHoZd9uj0r+yShBMG2zw0EOZmjdScoyIOC0pQGOZ2hT53Vc
         6j9VZ6uFy/fMejeP8/fXUwrFiW19ge7GJ7WwCjB6ePLWa+DLR5ltkyJtLuhEPbikHB1/
         uRhA==
X-Gm-Message-State: AOJu0YxNVRqABj/9UKIL6qg/OO6rchBSGc9UnAde1Ck6ZbXLHRH+Dw6K
	pXusBFPhgKiNasodUgJsqOtic/TrNHNetGVmMQBBW11kxTVie8x3suJ71h1svPOrRUNCgA==
X-Gm-Gg: AfdE7cm0PX5tAci6oQ2jR72D+YAya/9uNyhAaX94gfgwFjs9pR+Lnx1i0hD0X+9o8yQ
	p0ZGe9SkFZeiO2JSDEscUU/9zRgNBUf3s7Hah9rNPGQUycjnLiLSHGBxZmfa6Vr7KSTG9Z0QQb0
	v47E+wF6Nl3Km7EbUp3lxgu3iFyIPuJQdj7/qmDYRQHLEMzNPiCPq5X17daor3zAH2tVsYsQ0eW
	/lIkRZlO4PA8EmUslNTp2B8AgrxetVkeoOc54t9ZX3SX6uvDBPABw8tc7SH7lQbxdyZf62q6yIb
	M220KKWtznpEQ/996XN86akhbXpnGAP8iozTcZNpW1G42mgDKKre9aAMwl9UWnT9E8ec0T3sLwD
	kAAxdZSgxfE9vj+/EdKzmsNbBQjH6goandP2BoR+Ylw5lfIvu+yhsTqq+EzjI4B3B+49QGRE7Sa
	6qFerP1dah9t0uDPWfWD+GRYHp3s6nPOstRDKjNgmjrg==
X-Received: by 2002:a05:6000:400d:b0:463:dc04:a848 with SMTP id ffacd0b85a97d-4656c69b9bcmr6272631f8f.16.1781898792989;
        Fri, 19 Jun 2026 12:53:12 -0700 (PDT)
Received: from Cluster1.local ([2a00:23c7:90c1:9201:ef47:d559:d907:fd0b])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-466643f4e3esm1430822f8f.8.2026.06.19.12.53.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 19 Jun 2026 12:53:12 -0700 (PDT)
From: Artem Blagodarenko <artem.blagodarenko@gmail.com>
X-Google-Original-From: Artem Blagodarenko <ablagodarenko@thelustrecollective.com>
To: linux-ext4@vger.kernel.org
Cc: adilger.kernel@dilger.ca,
	Artem Blagodarenko <artem.blagodarenko@gmail.com>
Subject: [RFC PATCH v2 2/6] ext4/064 encryption + casefold feature combination WITHOUT dirdata
Date: Fri, 19 Jun 2026 15:52:01 -0400
Message-ID: <20260619195205.29384-3-ablagodarenko@thelustrecollective.com>
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

