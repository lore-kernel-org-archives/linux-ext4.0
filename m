Received: from mail-wr1-f51.google.com (mail-wr1-f51.google.com [209.85.221.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5A8C336885
	for <linux-ext4@vger.kernel.org>; Fri, 19 Jun 2026 19:53:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781898798; cv=none; b=ujXcmraPERkiL7WiMkiERHigKjdUdKnM2z6HRxgA3nKoYhbVsmL3fBJRQNpYdOJsIzDTl1knyi/RoQ+QgVNh90aefXrUZwI2CN/QOj2wcBQ8hHIAnRsC0WT5p6MTK8mbcOXqgSSu/4al3DzeeiVKxgyhfHXkhjvkpH6p1y3Mdbw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781898798; c=relaxed/simple;
	bh=e+ohwOSN6LbpmLGd/izSBp6CeixeLtMlkFS2LHQyMIs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EOpRABMx3n0wsoQmHtHVYuxi1lb/cCBIFm7IPgDHSJsdVTLQ+k48YEt/US8KS5WYl1XfuoAaHdPdoFTO/vTsj4F1RcpGggaWPbgss+1/Z5DxsN5FD0MKcAPtbktyTQ0nPGeM5Z29H1O9/WRohlgKNGX9DOuRxb6b+ZxfCgg3nCM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=JsDA2fXU; arc=none smtp.client-ip=209.85.221.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="JsDA2fXU"
Received: by mail-wr1-f51.google.com with SMTP id ffacd0b85a97d-461edb387ddso2379424f8f.3
        for <linux-ext4@vger.kernel.org>; Fri, 19 Jun 2026 12:53:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1781898795; x=1782503595; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=WJzUOqF8t8KNC63eLRFBx4UYUm1u+tRaMVpSKwDOOqQ=;
        b=JsDA2fXU9Youjubc3LLIt3eXW6Q8gjS07GA1n7EV7F463XQamrakjHWVnRjCCIL5ad
         403dz8UXhxOY2CwQT2aVROQSdB8iGYy7KFUKxU6udTSm3ZP0dkwsYBMLlEE7WZ4bYUE2
         l6NTd5KsAin7lmGF6+q1ULzznzUzGwlzMQrMO/7YkrptR8vqb2jqEow8Fn+rjSq1eM9G
         U3LvuAKBngasHFGMDdCdOVWS56I9LjpJ6KuJ6mjPBiYww7Ew+EqiJepLi3ZQYoW8xUks
         a695ejdczUCaRzM/8S3LJZxSzfHkUA+/SdcPTrnc3j8ngd1unabQvh68wShZ3o6JixnD
         mElQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781898795; x=1782503595;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=WJzUOqF8t8KNC63eLRFBx4UYUm1u+tRaMVpSKwDOOqQ=;
        b=NgM7GQJooBoEOlrbqjTECw6xAMO5QnYmknqDgQJHUOc1fywpIm19CqVwPdfkyd8dAD
         EKlT533mqw+ybQ0/QKy+SfW8a5uXxZ4G5qkoI3Onrvt2BDBm1Um8t3PeWmABHMtvGoPL
         FwXh8MNeeHtkVGnljsINaNfO/pU4ji1mt/zH7S8rOzmMM0PU/5q3bnZiEvBIAdTEIrw7
         D548jP7qaT2fQiyC7L9j1XL217MeP0gnFWJW+q1RoOwUOZYn9l2VQ8gcp5+LOHpBd5Z7
         dByXqaeD+fnb1/SrVH1EQBLdhoh8Rt2FvJUTwcTzpImVfExeZhlRH2cPUb2s+5WxXnm+
         JQpg==
X-Gm-Message-State: AOJu0YzRVui+Tjwgto8z9rdlx9LPo+1FcpO3+RbFVjzvZmOXhIST5shF
	yQXpAOw6vLVy352JKWGNS/aiUnkjiAliTI4i9eHTO8B0RCMoBbsf/cxOnoRudlM9ez7NKg==
X-Gm-Gg: AfdE7cm1RH+X7IU+Jc+J8BavnuSFAistKptVXOT0S0+UT0H001nQg7SC8c0AQ5ZXn0A
	K0MUfMPgviJ+KT9TDCzXw68c7O3+ozGz6TOPoJSMq6IpDtJpxxRU1mXcoTO0x8Y6FuHOTmE7K83
	F6JgnlnJtmA8jF/wGJniaQrtXCt2HK70MKH5QNMuT8DsC93bSb5mS6ga5WM1m38dXZ82TSymOeR
	QWELQp2ivsqDsWZvInX0/APNhiNHj00oOur0Svf71/rQr0A9NEyF0WbHXvNIfEPSFzlcRS70E/R
	V6+KsV489PJDRAxItXAbYkaPGoH8gItsTDi8Fk2GEP8+8bKmg4Pu9fJvCAG8F+fcaY76lqiPm13
	1xA/O3z+A0qki28nfIajZL3tA4sPLol9WP8TTyV+ycJ2DsP4hXAmx+V1/54HpxHjggX1W4Xpi3o
	JAs5SAuDxaTlna8EbkNOOdAvf0k8v5KOJ5EeA2ufRwUaPmmWsFseFs
X-Received: by 2002:a5d:6b8d:0:b0:45e:db3b:921d with SMTP id ffacd0b85a97d-465091bbdbemr6638982f8f.31.1781898795323;
        Fri, 19 Jun 2026 12:53:15 -0700 (PDT)
Received: from Cluster1.local ([2a00:23c7:90c1:9201:ef47:d559:d907:fd0b])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-466643f4e3esm1430822f8f.8.2026.06.19.12.53.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 19 Jun 2026 12:53:14 -0700 (PDT)
From: Artem Blagodarenko <artem.blagodarenko@gmail.com>
X-Google-Original-From: Artem Blagodarenko <ablagodarenko@thelustrecollective.com>
To: linux-ext4@vger.kernel.org
Cc: adilger.kernel@dilger.ca,
	Artem Blagodarenko <artem.blagodarenko@gmail.com>
Subject: [RFC PATCH v2 6/6] ext4/067: LUFID and encryption+casefold+dirdata
Date: Fri, 19 Jun 2026 15:52:05 -0400
Message-ID: <20260619195205.29384-7-ablagodarenko@thelustrecollective.com>
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

