Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.51
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793713882;
	b=uo7lHfW3HpbChIQo1VkoMvfZjZFo7RcLkyPYKOKfc86eY8EFBBZik0mSmvX0/W8yLcWH
	 WDWXIPF4eyed0jkacIyQuma2hM+CVYBCJD2YQaR2tJeqf1RVrVvNuDR1NiMS57RLPeMcS
	 Up8G/z2VzVT3ec0zcNBfbJ5nSnqRnndi6Zwh8POMA21tluMiMGMVyszpgxQ1FiHS8KKrt
	 I+tN5a9msU8TorYK4qF5+sFuXWL1SGRss9mO21jUc/CKJ73DGpr8jK0vcgk3EF5XasjNG
	 XB7vf7UAVpy6OX2u+YcM95PPRt2OOLE+FDJ5KgmgKy/Z1Ey9sUYjJDcEXMpEIct6ePw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793713882;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:
	 X-Google-Original-From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=EwSYmBPXLPw1tk7iLfciWOV5ID+lkPR/nxuVHvPcV1Y=;
	b=v1zghG4qM0cvJBA0O6YkrdSD41HiSKAmrrgm+qc3pr+g8nDUYAcCRNBLt6Mo4XM6cliw
	 rPLQbnhejqFPQu6/RCvR4RP0BNZzPd2T1tY7GobE1jjSGx6qxGSxQsp0g5ZNEOXF3GQEN
	 ESGOOZKlSR8smzQCB7C7rHtLvMnMOmoeuierG4dcaV2tsvQskwQ3ZxesP1WHRvMAissJU
	 zyQPyXal6c0Z944EuJmHu27iROH4BtZlejWJtvaMlTBiZNAcpcksCp3b2HGsvx3k3N62w
	 khWrCNO6Q6lymDpidncpwYSVMW68hGAxTCfBswMOSTeuC4Ig2PsigIGA/mAaZ6gVVBg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=ZZM4W2rQ;
	arc=none smtp.remote-ip=209.85.128.51
Received: from mail-wm1-f51.google.com (mail-wm1-f51.google.com [209.85.128.51])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30AF16085098
	for <linux-ext4@vger.kernel.org>; Tue,  3 Nov 2026 13:51:22 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 30AF16085098
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=ZZM4W2rQ
Received: by mail-wm1-f51.google.com with SMTP id 5b1f17b1804b1-4a2000d5fb1so28892185e9.1
        for <linux-ext4@vger.kernel.org>; Tue, 03 Nov 2026 05:51:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793713881; x=1794318681; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=EwSYmBPXLPw1tk7iLfciWOV5ID+lkPR/nxuVHvPcV1Y=;
        b=ZZM4W2rQvOHVsaLgeCAMlg7bD/6YIJ4w0BrvvgSUTeHFAJuLxaD+T3Kv/cHdlx0JCZ
         cp3NiMB9gGdIhRC2yrIxiXutSZmGYz8INZPYbxOjuPRIkAo5EDTDRqBuMfJ+V1DAwD+v
         83cI47GrbDTvdBETdOoITox+u/0Fd+G2/UJ/I2GKD5zuHN6K2Y9UWZUdClA8e5dR/Omy
         wYiFywNgnfAkq1oNR5q72Q5IITMCK7YTeqkazail1HyF+IaXpOB7m5xiwPOeKyX56DIJ
         y0IPlgF+ZBV3pd4Lw8IxEyo9KmTJnvY0jXO+HCWFrXNuVybDu9/RDC+W/h77dJBRd0sl
         YrOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793713881; x=1794318681;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=EwSYmBPXLPw1tk7iLfciWOV5ID+lkPR/nxuVHvPcV1Y=;
        b=Fv8Rw6lxxmXBOTAkWrP4TJsiSCTihRjUyGpIGOt/18iNhCC5Y/cRUHLO9SA0OMBUnS
         FNcLydYROLywO0s4PGaiRywGPGTzSIo1OmGpAdEw7cUxneAN3/2X19X1teCwsWFbtZ/R
         Tr7HUigp4zS25i8G2fQZLVJGUY3Gkn7sgD+P51Jl2bK12zmFtnXHvkqxstR6h4i0OYzj
         EpBbcR9tDcs65k/1vFkxGYDPrWCKXdv8wn7qmI3jGBB1TrOhLHIhZRVqaTcl8niQ39My
         DSBAuhai/Huqe9NmUptq/BUEwzbLl84EsqPUlgADic/TSh2+2iK2Bj0Qe4VzwyqjNNxm
         CB8w==
X-Gm-Message-State: APuU4Z/zJLhr7H2KzFjVtM1lbSMZO+r5qO+E5yhW8fWG76EkTI8c9+6h
	uHJ9xcl5BV6xZPcAFHxpcL3beKn2bD9m6HouecL7LuMONb3z8cEax7SR
X-Gm-Gg: AYBFou0/jBYEUpg8AYK4ukWkhNIIkMKppLROCNlaJZ8LOjgLGDvDJOZciCUJJWyZomo
	p9KYVudpHCjRGmhPKRVg7mJWFD6565JrZ2J7E8ONC2YMlfLVeD850X3LPVk/lT/tE9O+MMTXul7
	mNH51QEogZv/Z6e+2XYOxdRkI8WhHJKsXyiEoTKSzJsc4xuBmF49jmdOyvRROxHGfKDaWPn8NmX
	dSHlXydIepBXBiLePHBlqDe7er4tqjPw3UvKDA1vjaPGPuHC8hTelXsu1gM1HStbyY6tp4wBBP9
	9ajBX5kRjLiNU92zbGyXB7mvvymphXRVtsUsf7l+XPFOljauc2118QZ35eQPux7N+M8MumeJgZ3
	MiKKniQFKyrgbzyq+pHg/naNuAE981FHNfG29quababTXEmw0OYHYusXhAyarFA7Zl2u0FnYmgO
	APH+Tx8F3XT2p6LKeIz8f+2ZvFODEUltJ+7g3xVaWFRku68T90FOermR5N2zcpz48a+13VuRCrV
	4pf0YKAx5zmUOb3AwcFzlwNEJjic+rE8IaD598KUSfvaEYz23GvCdtZgFBGMj3Qw1ZienofuEy/
	kwlnxBiwxzxkb15YiwXM61XsBP/xUIMmm0R23aw/RENZOaG8cMOoo7cWnhE0
X-Received: by 2002:a05:600c:8b06:b0:4a2:d:5ccc with SMTP id 5b1f17b1804b1-4ac17b2bc63mr310059355e9.10.1793713880479;
        Tue, 03 Nov 2026 05:51:20 -0800 (PST)
Received: from Cluster2.powerhub ([2a0a:ef40:18b5:9e01:225:90ff:fefc:9ffe])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4b2a96fc87fsm55320335e9.12.2026.11.03.05.51.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Nov 2026 05:51:20 -0800 (PST)
From: Artem Blagodarenko <artem.blagodarenko@gmail.com>
X-Google-Original-From: Artem Blagodarenko <ablagodarenko@thelustrecollective.com>
To: fstests@vger.kernel.org
Cc: linux-ext4@vger.kernel.org,
	adilger.kernel@dilger.ca,
	ablagodarenko@thelustrecollective.com,
	Artem Blagodarenko <artem.blagodarenko@gmail.com>
Subject: [RFC PATCH v6 6/8] ext4/067: LUFID and encryption+casefold+dirdata
Date: Tue,  3 Nov 2026 13:51:02 +0000
Message-ID: <20261103135106.610169-7-ablagodarenko@thelustrecollective.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20261103135106.610169-1-ablagodarenko@thelustrecollective.com>
References: <20261103135106.610169-1-ablagodarenko@thelustrecollective.com>
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
Assisted-by: Claude:claude-opus-5-5
---
 tests/ext4/067     | 137 +++++++++++++++++++++++++++++++++++++++++++++
 tests/ext4/067.out |   4 ++
 2 files changed, 141 insertions(+)
 create mode 100755 tests/ext4/067
 create mode 100644 tests/ext4/067.out

diff --git a/tests/ext4/067 b/tests/ext4/067
new file mode 100755
index 00000000..bd3dca48
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
+$SET_LUFID_PROG $SCRATCH_MNT/encrypted_dir testfile.txt "$lufid_payload" >>$seqres.full 2>&1
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

