Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.52
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793276940;
	b=2W42euJHNWeptBfZVnuiKGx3kt0A+czcBkLzwwgY4TE5NNoY5J2PfhadmkalgydNRHgm
	 VleZsFO6OjgizuPP9H6i2DXX/iuX53TLVqq8xzLKOL/aU1qgiRvW1/IYrNIxQyunkk2dp
	 cWYhXlXxvkg33S2U0Oa3IU7jAzDTIZH87OEtq5hsm2hWs+ZDJNTwpa4ogZ7RhGjJfFsrI
	 aTD/JP8da8jbl/XuqvcoksTLGrxBR4ETeE5+1RbTCDTDi4Mrtrd/pOdZeCPYOw8ep8UyH
	 gGT5t+ujtwLUrofxiKfUCGA2tTWoaaCSkq6cG5jNm7IF7DEiX4Gn0pKpJqhEj/rIr0A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793276940;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:
	 X-Google-Original-From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=ucLzmxD02mP2PoA262eUvmsXn6KreQU7EXQE5wyOhgE=;
	b=dMWpKkkkMGwtH+rt/AX94nmmoKoCom77SLaAIy1fVnBVbd7sliKsB5eBrhB3I89qpz6c
	 K2s9gK2a6O0UEw/vYw7d/SEKkEb4yB/Y5isa53p6nlSYTHdwPkL6IDUSDr3COBkDO6Dav
	 EZ/fL2ziSwObHCcAFF99oqEQpYRBZWGOJcQiFQDPW24THIaNkeuUJR1CC1zLunPz0O2t/
	 7eTAFg4vsB9l2CZ1YZkd/WyxcC/m2TMTAU6ynGUTX13e3NHO2pGfG200pfD6pxg+lnEKc
	 r5e6uiPl/GvD617NxRbZ11PSPabWpQhOdNZYW92G/cohBPiGfRGzDb3Ou/ZuIS6d0cg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=ixMGwD4U;
	arc=none smtp.remote-ip=209.85.128.52
Received: from mail-wm1-f52.google.com (mail-wm1-f52.google.com [209.85.128.52])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1491606A31D
	for <linux-ext4@vger.kernel.org>; Thu, 29 Oct 2026 12:28:59 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org B1491606A31D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=ixMGwD4U
Received: by mail-wm1-f52.google.com with SMTP id 5b1f17b1804b1-4a2000d5fb1so15012275e9.1
        for <linux-ext4@vger.kernel.org>; Thu, 29 Oct 2026 05:28:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793276938; x=1793881738; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=ucLzmxD02mP2PoA262eUvmsXn6KreQU7EXQE5wyOhgE=;
        b=ixMGwD4UYiIucG8LtbKLngAkQNfbfKOexzgLaKNNw5qqX8oLSfNDqqjhTXymM7TP3R
         Dqhg8mW+I5x/Ugxa9t9za9NDxgk6aE/ggpfrqHkShaQGo2Q8CAUsAq+eGVrwU6f1gJRM
         tdQhPKQNObeFbENXXPtbsuxKEAqUGG5lM8Hf1B0xILuRau6aN5FFYBVaLQgghph7+hey
         XIgoRFkI1cdCHXuA+dyqIkmcyi0I+wTUgQKNi/B3IjRGiAWdB9ETI6lLVI67BAX2FqLX
         JKidO9za9JsywcDcMmRs33oDp6wZ/nh7+wxZD1gG1LmyraRdunHKQYPVtUg0PsErS6xx
         a0AQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793276938; x=1793881738;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=ucLzmxD02mP2PoA262eUvmsXn6KreQU7EXQE5wyOhgE=;
        b=LSXbFCTLpapCvRaxbT7xicmsSAxjwzypKpbeHJX09AGOAPB5Clw+bTPdMGZ+TiuriF
         o1rMMtXCf2Pe4EFOmaY6XTBQh247ZvNbq/CiCrlVSCT6nLZk6zT5LN5OzI22cXughCHf
         PS4D7UN9mDulBRLEiBA+JVOoPz2R85C1sYq7OkUPBUMchs2mkwAldwyufb4727v8Nze9
         Io677VjXZxICdI1UuqJ4WwVVv4lt3o8BNvvr33o3Tt3Buv/v7s4As7fzW1u18pADVHXC
         fhiEYlJlUvOa3LFMsMTgF50LKDCr5vPcDrCF3f3e+ZcoMsceO45Odw4KjnnnHE0Uojek
         u0fQ==
X-Gm-Message-State: AFq9FYIzq1bEb+KJRrM2rd3+MuP3Rw2KhyIhCTVacs1e56XIMhCzdPS7
	HA03JkFUeny+YCyhQGWua3mwOvZOPh6Dgzhbrk4nmJTsgxQhj2xV843Ig/CaTp5o
X-Gm-Gg: AYBFou3OM0q7sxQ/4Xa/DWEVhwK4MhyvAj+dDfaQ0ZqwDS0GZ+rXotRIlnFGV1zbYMi
	9WSOnpxDBHDxAauff2FjE6kUURrrBvPfVoLzvL/dRnKmIJ4SeVaZxNIpsV09C6s2QEoG2slKlyJ
	0irL0ia0Dw0q/wB/prddcHhPOAAOFbp6RBqoipTYAELNqeX5NnrjXNKnXaAc6oK6dPQUkPWP8H7
	QxS7nNgIdOBp9+RqnoEYP10stwwS+bWJZ9yGMBe/yifpt2y2Wfj/3yytHxk/9MMUEqx9JO9qFmQ
	ec3EjfI2XgT5LzsTjGmy52grWu3Co+C1KxlemdWIFIkzUnTzmmoz7Km0iD2pd+etGoqaRdiTDzP
	8C9QztZA8DS9yMNoFVzgQJ/OwethO5IS/d8EGV4tRh9FBOGYgRt39CSgcZ8IEGiCdEVd+nmJYN4
	ez3ler2nQ0n33WlZZsNg1Yadau1wO67lmHBxl3KLp8gGjgK8LDfqxLWEXyNgEWA5jxySuqCMphM
	UmmJ5BlEaG4rCOJwOxKLRYS5Uv4axXW24m8msQsoPx+nJIwAtZiM35VWbCmCdZHYhk544oErefR
	DAKF72pYF2DlgmuU9ey0w3UY6tA8Ygb5IAN07pKZ+3P/uPuOWfU/dV18/+bV
X-Received: by 2002:a05:600c:474f:b0:4a1:cd83:b23e with SMTP id 5b1f17b1804b1-4a97452869cmr120621245e9.0.1793276938077;
        Thu, 29 Oct 2026 05:28:58 -0700 (PDT)
Received: from Cluster2.powerhub ([2a0a:ef40:18b5:9e01:225:90ff:fefc:9ffe])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4aa7f7f50d3sm92477915e9.8.2026.10.29.05.28.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Oct 2026 05:28:57 -0700 (PDT)
From: Artem Blagodarenko <artem.blagodarenko@gmail.com>
X-Google-Original-From: Artem Blagodarenko <ablagodarenko@thelustrecollective.com>
To: fstests@vger.kernel.org
Cc: linux-ext4@vger.kernel.org,
	adilger.kernel@dilger.ca,
	ablagodarenko@thelustrecollective.com,
	Artem Blagodarenko <artem.blagodarenko@gmail.com>
Subject: [RFC PATCH v5 6/8] ext4/067: LUFID and encryption+casefold+dirdata
Date: Thu, 29 Oct 2026 12:28:37 +0000
Message-ID: <20261029122842.230704-7-ablagodarenko@thelustrecollective.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20261029122842.230704-1-ablagodarenko@thelustrecollective.com>
References: <20261029122842.230704-1-ablagodarenko@thelustrecollective.com>
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
 create mode 100755 tests/ext4/067
 create mode 100644 tests/ext4/067.out

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
2.52.0

