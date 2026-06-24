Received: from mail-wr1-f42.google.com (mail-wr1-f42.google.com [209.85.221.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90EA43B42F0
	for <linux-ext4@vger.kernel.org>; Wed, 24 Jun 2026 13:50:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782309034; cv=none; b=Hdd0ggzxGiMQ5vklEqaBJCGpnaLHI9vspJnLk+SFxst044K+qtHlkI61f6DtdDTIk4HBeAZm7hIy+7+s+X0gVa5pfrZz0+LZ2pA5NmqAUU92P+WNfASCbHNcDI96dPf7YyYCLHF9168e4343Q5UkASzfMT1ZZNoRbyXueA5sPvs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782309034; c=relaxed/simple;
	bh=e+ohwOSN6LbpmLGd/izSBp6CeixeLtMlkFS2LHQyMIs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gNU6XBwhAZ4muZuRqzpg2Z8on7+aSCu8BReXBas7pXvgYZ81z/gTaM6ub0xdDDxZGOhWg9peRNyWwJqak5vRvhTaLiklDXozUmniVdwAIsNEiKkjWWHccoFxqs3CcMtT4nEhlE+mxgoa+ETUrjlnM+CcHjZz3z+5V6JfMCcTdAM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=royMmSgZ; arc=none smtp.client-ip=209.85.221.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="royMmSgZ"
Received: by mail-wr1-f42.google.com with SMTP id ffacd0b85a97d-45ef56d9b67so913206f8f.2
        for <linux-ext4@vger.kernel.org>; Wed, 24 Jun 2026 06:50:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782309031; x=1782913831; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=WJzUOqF8t8KNC63eLRFBx4UYUm1u+tRaMVpSKwDOOqQ=;
        b=royMmSgZiqDqjRG9wOOP/malDqksBRo/E8Ev2G8i2Mmdqg8bwVE4lfdRU8fGbug5Sl
         GRu6LdKjhvUM8rj4wY4J/9DoV+LjD1eXUdz0LexHnkY9tQ2BPizg2U1Yx8ZZEz9I9W9r
         BUuD8W4Qom95IILBf9ejVNI4TROQLHL7otenBEI9PR3w5QuusP6CJvlZUKNoWBtU6i8s
         9tXHk5UqMV6n+b2gmr8eQMRdTeaS/3PEL7f/b7XgF+DGKrewILRh9c7gGvWET0zYSnwW
         FYVrQZc9Rekf9MQv8nd0olbkyDQA51yhn8l+3DZxIifSXVndyoHGQf4AEkqvekQ+7Fgx
         CFhA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782309031; x=1782913831;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=WJzUOqF8t8KNC63eLRFBx4UYUm1u+tRaMVpSKwDOOqQ=;
        b=UPu0o1uqal3VwrD9Uss+SQm0wIblnNXuKQUNlSGNNjAGKgOUm4zuGpJrlkG7h07q/V
         76FB6PuzCqutzSoIpb/JEvEnSs0o3M3nQlfBU4+v6j4DZ7rJfSk/BxorYk7p4jwRFGFo
         PYd1rQstYQ9cur1uKqeuz0YcsDx8+p5iyAwr0Nqz9nBO16vxgilar6AcrJ2L9nCSUT9j
         teNKuWtf8wI0pUR8spzozTslkl9eTQVhwYtJ+gKhurYXLuC6vsWD2m5F/w2l6bhGvxCc
         EdF4FFJVWDuByCbhJ1kURJK5f+sVdFM04Yy2dMYyATsmQQ5HIWscaui+z+Iu9awkDO+A
         WTTg==
X-Gm-Message-State: AOJu0YzHgC+QdOjRtTkXCmUEriyFT4ODsUaQNeiO15wV3EkNaLC29xLh
	BOXLs+4KEjZFmhSjSArj+keenGBHoDJsLRHgF/G+g3VVLfk4gP3c7anJtEu8UN1aoT0=
X-Gm-Gg: AfdE7cnj+d85xHFn0A/nbmFZ5TGt3YWpBU2aNE1gd76M4hFk2gPb7Zv+39T3V5/GfEh
	H2L1ydDrVZI+ryYmrrBeKbpI2uotsg4jic8z2NxerFtrQpYuh3JfjMD1RqCdlVFPh7ZA54j5b4Q
	XUQdi+zB0bkDxZh2Xwy01E1qFCw+8V/7/HDPt6I1acp6Tnx5b+PxexfCLlaeUEkLwLXYtImnvYW
	u+dy1HBQsoHo1taNKmhcgUhAt/MYbUmpJiggyBKR7zPjsJgMM9gS3apDITc4j0uSkNZWEx/fu+5
	qSnv9Sdlgd/9OKZxYgCYoVAgcx5TEflaLOBu7KZAgprwSq1Wnj+t4e9wnxFjr3MZYcYdfIpYwNE
	QpEt95muX+xabbkVrujLymKuRpCrRdR/jbPnlm+5VT68sfnCQLtEoAFZY0swYhaZnlzpJ4VUyRU
	g4lfOrZYoKCIPBk+IYJ/u0iguJiHiRqCLzFsYfQ1n57hFS
X-Received: by 2002:a5d:5c0e:0:b0:460:70ae:f1a4 with SMTP id ffacd0b85a97d-46c08e64ea5mr6829056f8f.13.1782309030864;
        Wed, 24 Jun 2026 06:50:30 -0700 (PDT)
Received: from Cluster1.powerhub ([2a0a:ef40:8ee:1201:acf4:9ddd:6ede:2d9a])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-46c1e840eefsm7791658f8f.1.2026.06.24.06.50.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Jun 2026 06:50:30 -0700 (PDT)
From: Artem Blagodarenko <artem.blagodarenko@gmail.com>
X-Google-Original-From: Artem Blagodarenko <ablagodarenko@thelustrecollective.com>
To: linux-ext4@vger.kernel.org
Cc: adilger.kernel@dilger.ca,
	Artem Blagodarenko <artem.blagodarenko@gmail.com>
Subject: [RFC PATCH v3 6/6] ext4/067: LUFID and encryption+casefold+dirdata
Date: Wed, 24 Jun 2026 09:49:57 -0400
Message-ID: <20260624134957.19209-7-ablagodarenko@thelustrecollective.com>
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

Test ext4 LUFID  functionality in the complex combination of
encryption, casefold (case-insensitive), and dirdata features.

Verification uses 'debugfs ls -lD' to check for 'fid: or hash:' markers.
Tests also verify that case-insensitive lookups work correctly and that
encrypted file content is preserved after setting LUFID.

This test validates that LUFID works correctly when encryption and
casefold features are enabled, ensuring feature interactions don't
break the LUFID functionality.

Signed-off-by: Artem Blagodarenko <artem.blagodarenko@gmail.com>
---
 tests/ext4/067     | 137 +++++++++++++++++++++++++++++++++++++++++++++
 tests/ext4/067.out |   4 ++
 2 files changed, 141 insertions(+)

diff --git a/tests/ext4/067 b/tests/ext4/067
new file mode 100755
index 00000000..acb49c40
--- /dev/null
+++ b/tests/ext4/067
@@ -0,0 +1,137 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (c) 2026 The Lustre Collective. All Rights Reserved.
+# Author: Artem Blagodarenko <ablagodarenko@thelustrecollective.com>
+#
+# FS QA Test ext4/067
+#
+# Test ext4 LUFID  with encryption and casefold.
+# EXT4_IOC_SET_LUFID is an ioctl that allows LUFID data to be set on a directory entry.
+# directory name hash is stored by EXT4 when casefold and encryption features are enabled.
+
+. ./common/preamble
+_begin_fstest auto quick encrypt casefold
+
+# Import common functions
+. ./common/filter
+. ./common/encrypt
+. ./common/casefold
+. ./common/attr
+. ./common/ext4
+
+_exclude_fs ext2
+_exclude_fs ext3
+
+_require_scratch_nocheck
+_require_scratch_encryption
+_require_scratch_casefold
+_require_command "$SET_LUFID_PROG"
+
+# Check if dirdata feature is supported (required for LUFID IOCTL)
+_require_scratch_dirdata()
+{
+	if test ! -f /sys/fs/ext4/features/dirdata ; then
+		_notrun "dirdata feature not supported by kernel (required for LUFID)"
+	fi
+
+	# Verify that mkfs supports dirdata
+	if ! $MKFS_EXT4_PROG -O dirdata -n $SCRATCH_DEV &>>$seqres.full ; then
+		_notrun "mkfs.ext4 does not support dirdata feature"
+	fi
+
+	# Verify kernel can mount filesystem with encrypt+casefold+dirdata
+	if ! _scratch_mkfs -O encrypt,casefold,dirdata &>>$seqres.full ; then
+		_notrun "failed to create filesystem with encrypt+casefold+dirdata"
+	fi
+	if ! _try_scratch_mount &>>$seqres.full ; then
+		_notrun "kernel cannot mount filesystem with encrypt+casefold+dirdata"
+	fi
+	_scratch_unmount
+}
+
+_require_scratch_dirdata
+
+# Helper to add a v2 encryption key and set policy on a directory
+_setup_encrypted_dir()
+{
+	local dir=$1
+	local raw_key=$(_generate_raw_encryption_key)
+	local keyspec=$(_add_enckey $SCRATCH_MNT "$raw_key" | awk '{print $NF}')
+	_set_encpolicy $dir $keyspec
+	_casefold_set_attr $dir
+	echo $keyspec
+}
+
+# Create a filesystem with encryption, casefold, and dirdata features
+_scratch_mkfs -O encrypt,casefold,dirdata &>>$seqres.full
+_scratch_mount
+
+# Test: Create file in encrypted+casefolded directory and set three 16-byte LUFIDs
+echo "Test: Set three 16-byte LUFIDs on file in encrypted+casefolded directory"
+mkdir $SCRATCH_MNT/encrypted_dir
+_setup_encrypted_dir $SCRATCH_MNT/encrypted_dir > /dev/null
+
+echo "encrypted content" > $SCRATCH_MNT/encrypted_dir/testfile.txt
+
+lufid_payload=$'\xde\xad\xbe\xef\x01\x02\x03\x04\x11\x12\x13\x14\x21\x22\x23\x24\xca\xfe\xba\xbe\x05\x06\x07\x08\x31\x32\x33\x34\x41\x42\x43\x44\xfe\xed\xfa\xce\x09\x0a\x0b\x0c\x51\x52\x53\x54\x61\x62\x63\x64'
+expected_fid='[0xdeadbeef01020304:0x11121314:0x21222324],[0xcafebabe05060708:0x31323334:0x41424344],[0xfeedface090a0b0c:0x51525354:0x61626364]'
+
+# Set three LUFIDs on the file at the same time (48 bytes total: three 16-byte FIDs)
+# First FID:  [part1 (8 bytes):part2 (4 bytes):part3 (4 bytes)]
+# Second FID: [part1 (8 bytes):part2 (4 bytes):part3 (4 bytes)]
+# Third FID:  [part1 (8 bytes):part2 (4 bytes):part3 (4 bytes)]
+set_lufid $SCRATCH_MNT/encrypted_dir testfile.txt "$lufid_payload" >>$seqres.full 2>&1
+if [ $? -ne 0 ]; then
+	echo "FAIL: Could not set three LUFIDs on encrypted+casefolded file"
+	_scratch_unmount
+	_check_scratch_fs
+	status=1
+	exit
+fi
+
+# Verify file is still accessible
+if [ ! -f $SCRATCH_MNT/encrypted_dir/testfile.txt ]; then
+	echo "FAIL: Encrypted file not accessible after setting LUFID"
+	_scratch_unmount
+	_check_scratch_fs
+	status=1
+	exit
+fi
+
+# Verify file content is preserved
+enc_content=$(cat $SCRATCH_MNT/encrypted_dir/testfile.txt 2>/dev/null)
+if [ "$enc_content" != "encrypted content" ]; then
+	echo "FAIL: Encrypted file content not preserved after setting LUFID"
+	_scratch_unmount
+	_check_scratch_fs
+	status=1
+	exit
+fi
+
+# Test case-insensitive lookup still works with LUFID
+if [ ! -f "$SCRATCH_MNT/encrypted_dir/TESTFILE.TXT" ]; then
+	echo "FAIL: Case-insensitive lookup doesn't work with LUFID"
+	_scratch_unmount
+	_check_scratch_fs
+	status=1
+	exit
+fi
+
+echo "Successfully set and verified three 16-byte LUFIDs on encrypted+casefolded file"
+
+# Dump directory structure to verify dirdata
+if ! _dump_dir_structure $SCRATCH_MNT/encrypted_dir testfile.txt "$expected_fid"; then
+	echo "FAIL: Stored LUFID does not match expected value"
+	_scratch_unmount
+	_check_scratch_fs
+	status=1
+	exit
+fi
+
+# Cleanup and verify filesystem
+_scratch_unmount
+_check_scratch_fs
+
+# success, all done
+status=0
+exit
diff --git a/tests/ext4/067.out b/tests/ext4/067.out
new file mode 100644
index 00000000..1c9a8126
--- /dev/null
+++ b/tests/ext4/067.out
@@ -0,0 +1,4 @@
+QA output created by 067
+Test: Set three 16-byte LUFIDs on file in encrypted+casefolded directory
+Successfully set and verified three 16-byte LUFIDs on encrypted+casefolded file
+  Directory structure of encrypted_dir: OK (dirdata verified)
-- 
2.43.7

