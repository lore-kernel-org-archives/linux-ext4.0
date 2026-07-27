Received: from mail-wr1-f42.google.com (mail-wr1-f42.google.com [209.85.221.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28F983E639E
	for <linux-ext4@vger.kernel.org>; Mon, 27 Jul 2026 21:14:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785186858; cv=none; b=Xy8zGFoUEIzRuwyYF9rgeHyNDhwh2IatdViOEJmYsJ23HcuIkgr8tAUSPM6nwZyCxT9heN/Rt7mvudeD1tExEMKpXqeWam7IH7C1L4gRZF6r54QWRoK52nJ8dWmUKld2PFnWV9LyUizWW8+V4QCbEMCKuABbrSCAC2JHxVbN7mU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785186858; c=relaxed/simple;
	bh=e+ohwOSN6LbpmLGd/izSBp6CeixeLtMlkFS2LHQyMIs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BtZRpRzZ5bDhjaVaz5zdPu5gcl/B8JFuXlGVcEPuAbDBR1Wnyn9ZXLw0HiBnk6w6C0d/AWiUCUn3FXXLzG7mRR51pnQ8dw96kRVrTq/r8oqhDYo25lg5ism7+tjXC2mtvA3XvwsvQiQw8zOi2XfMun5MOs6GGijKxyjMmKXjwpU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=oUgjtt2e; arc=none smtp.client-ip=209.85.221.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="oUgjtt2e"
Received: by mail-wr1-f42.google.com with SMTP id ffacd0b85a97d-4798bea72f9so2042617f8f.1
        for <linux-ext4@vger.kernel.org>; Mon, 27 Jul 2026 14:14:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785186855; x=1785791655; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=WJzUOqF8t8KNC63eLRFBx4UYUm1u+tRaMVpSKwDOOqQ=;
        b=oUgjtt2e+wP3mh8uWj7pEDAwAp38eEK3MqbBxanw0E7yVDdabrZevoaHOD58ABwiqY
         oEr9CTUlOa95mHAJ2hkhIhjQDHo+O6JcJQlZ1wtxu+bmjRozxT/5ozvW9ps1KQxuUfnM
         0Gs/xe/bRx74WRVgfiVCnZLigVVWtK2k4MabTdsGiigWelUzaQAv0L198VSFgNLFPy3f
         Tryc9UIZBEOCFxGgwtVFHH4VnHpBSTu0kTLYQJAzRIiLcXj1QAm/AcjOGY66IhfdOcIR
         ZkM3XWHVldfvpWmz1V6m6os5TFdDzQ0v3gKelQ28aq3J/8/1cCJ3IdJp0jwmII5cq7H+
         BCgw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785186855; x=1785791655;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=WJzUOqF8t8KNC63eLRFBx4UYUm1u+tRaMVpSKwDOOqQ=;
        b=YNqV/HVz/iFXV7a7pZdPyOKmowoZ4jvdXDNn5/danimNE8lN73ZfU63fiFLZIubIdm
         85W1vq7gCnB31ZjW6mu4q8o1arf9+IU9i7/qQDQhQ2wJVHfvItJ972qtu/R2u3Ec083F
         A0NuD6T5QQ+k+Ppnp4Hr+T2714QRGWwwmuA5ZaaQCB/nng44BbD1bkKyoAk/+2PHTgzf
         rt/BU/jTJuM2KE1zV/jolNJuJa+T2tjKHm4ESJGS/O7ztKPT7yZRbxBh+/ngW3O3VoK/
         GHPxCnwvtqOK6ar4vKGVFrn8mWqkPNtgFPjRkB0wRTjQVwEaZn6iSrNN0by3PC3I4d9k
         8qmQ==
X-Gm-Message-State: AOJu0Yz9FjOhKt9tNvFEwc34HZdNxRUwhTOErQV/98AZdFpEhi67yw6l
	qWFqlBn9sAXAwpNoIWVvLBW/XXn2eiAT2IinfYShZ1s91/Yg5zcXNTpaKJcnQTy4
X-Gm-Gg: AR+sD11PwhIvisc+r8zur3wouBJz89bn4BX9mDm7bMGPMPb01TqdQcwK4cdNasTtnlq
	idYeEjcpiOUvlH/GOWMZozvL8+DHsG2B8LmwW0NpbxoxMa1aT7es4jvEEODryWxRnfz8zxSWqhC
	E1dT3EmPyD1xPgzfuYqVMF22DNqNR2bIot6O5MxPUJh03VltE+cD5fWq2rrRYeG1OLFhg1TZ9TE
	7XSJELjd8jjiRcw6rR2y3DXNKShuVrIivnbTFcfh3BjT+q/NYsRgMwJYTKjKCL6ncR/t7mDKdr+
	+xkmvT/hi8D4yBLC9z6qCNAfy1pjBd3Bma0r0NkXHA/8QHldMgXAAxNhJkeDurpkhmLmJzkuJWJ
	JBgr9q7BG0xdEAeUtCbeCDYg0v3iYwpmaGGy66QKANAbiJMgPKJyFtctUCqFLwa4N9j8DLMwX5A
	+cGZJ+TWp3bwuBn6a5qZ8DyCkT1qPOxt0Iy3hlf7zt/fdr
X-Received: by 2002:a05:6000:4006:b0:47f:77dc:b066 with SMTP id ffacd0b85a97d-47fafa56f52mr855316f8f.5.1785186855361;
        Mon, 27 Jul 2026 14:14:15 -0700 (PDT)
Received: from Cluster1.powerhub ([2a0a:ef40:18b5:9e01:f5de:1ef8:371:ee89])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-47f85c67339sm54987049f8f.31.2026.07.27.14.14.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Jul 2026 14:14:14 -0700 (PDT)
From: Artem Blagodarenko <artem.blagodarenko@gmail.com>
X-Google-Original-From: Artem Blagodarenko <ablagodarenko@thelustrecollective.com>
To: linux-ext4@vger.kernel.org
Cc: adilger.kernel@dilger.ca,
	Artem Blagodarenko <artem.blagodarenko@gmail.com>
Subject: [RFC PATCH v4 09/11] ext4/067: LUFID and encryption+casefold+dirdata
Date: Mon, 27 Jul 2026 17:13:49 -0400
Message-ID: <20260727211353.19736-18-ablagodarenko@thelustrecollective.com>
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

