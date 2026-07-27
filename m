Received: from mail-wr1-f41.google.com (mail-wr1-f41.google.com [209.85.221.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D25D336B905
	for <linux-ext4@vger.kernel.org>; Mon, 27 Jul 2026 21:14:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785186851; cv=none; b=BPRAwEcDr3fqHxMHH7Mo9tAaZmrTYXdTrrNzPJcX+77bwrQMUC4JwrITiWa7I8EpRUO/tbG689B8lcvrQyClrBBa0HtDH7rFllPszHed/sFoQv7HpAYLacx4qTr5HqyNwl4WYQSWyXJwPKWbDJ6Gw8w+aVzqn2Rho0bIPem6Niw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785186851; c=relaxed/simple;
	bh=dZvlfr/y/C/eK6AVdShhUjZWvGh05sngdLCcFaL//nw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IKKwHNY3M4JVgDvxp0RDWsWVoNFc3AQG2h99UBcyszW1WSjjBJcJIK4SP4fxrlov+wOZ1zfxo0YKJSe42ptZ1VcND0E/yF8Flvm0HpW/4ji8N71lMYwaj1dBrmi7AHZasribn5cGfOEznvdydacONWPwR3KLB6c/Nb8IVFiYpBg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=UCAD68qC; arc=none smtp.client-ip=209.85.221.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="UCAD68qC"
Received: by mail-wr1-f41.google.com with SMTP id ffacd0b85a97d-47f703a9d05so2051919f8f.0
        for <linux-ext4@vger.kernel.org>; Mon, 27 Jul 2026 14:14:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785186848; x=1785791648; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Bj4+G0i/Z6FMhl2EzwAUD1gyO4PnykQNHd0PpT8Ht60=;
        b=UCAD68qCfnlnkscMXp73DZ9s3qLlDjGDbNUP5Pqwj6n18xb8X7dtOM4cwjuT9D3ETS
         paF90Iw/7w8Pl/FXOY2lNUotJzzb+cfadxPcjnvwTb+/oQdZ5Ao0IGMsGGjrzABt1SZ9
         YUhyOK31gBJk3mlxQt4u3lWrJGSVLDpDluAfDRC7bNEB1kzP0+RoXEYAMjrgWaojpOmf
         Vz1SM7SjDHDjb+Y+f7YSnM7hEj1an40HvlIp5UiFb3rMqjI0eescrIQOR4HGCq3tBoji
         BHG6Y2scHFrahlbk8q3JMnXbmz9QVj167zRlZFmjjBSS0QqVWU8UFuAPjWb7uSBUKaN7
         nvcg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785186848; x=1785791648;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=Bj4+G0i/Z6FMhl2EzwAUD1gyO4PnykQNHd0PpT8Ht60=;
        b=j6jawATnivdpg5t94Jr5XjsoeHC9LWjwc0TZS8O/tkUU36G/eQz2Gb30I/PQ7jkITc
         TLBrOlrdJqSziCLcnOsek7IAjtoUS25qewDKeTrn1I1jCoPgahQnjn6ME5R6YLLPMmdA
         3DGgxzJXTdsfNOD0N8gp+ZUL9kKKb0mgo0Ky+4TsmPgbcuzitp9n0U7++gMgC7n8+4Ix
         EM0a7yvHh/A0XKWFWyE5wpRTWhUyTEqr6cHu3acKMueSzZy0l3JqmLIQIMTXFY9UEz95
         Zw+N49le6rzA/0jLKyqonElHz+ZLBheNNCUXg4OD9KSTu/1TFks/3eKynTWtU/Rn7yMQ
         CApg==
X-Gm-Message-State: AOJu0YwY0HBJbSMvz+PInOGpbsjb5HsCcVdrBEgXWMvAB2xI2G3fQ5V/
	kXQzMz9mmNbzdfyRYWjfulTMEELYg1k/VxHXBPORZsqbZrxGxD+mM/AoB3asn52X
X-Gm-Gg: AR+sD10q3wSjPS+h8dfMrtusX+kD8bC+fFCH5k/M/uDSnKPr9dxWA4b2oMdGaoMEc6s
	JEJNtIzau3t1q9snpTJ3WtrjE8fchw371VPunwVh8UTGn+qDef1JGYqGTrUqpV3h7J6thsgZc/H
	HZgFrRe/3Fivn7ple3WGTzrL2IuSQCxcrusUIqhecADThBNj0+s4T/jZfG+vMCal18tg7RhoxyZ
	PkIrB9kdR5aC1gfLM+GuaZRvkAnFTUDvQQqzQo0Pjk5g21i9SOknrH05uvHlTF5EpxxsZd88VOm
	A64V3L52AFYeFHw+GYsANR9IdggZy4m1C7waI2zlqsr9SDJvBoQbnDjk/kvAfqKyhX91ygN50sS
	AFvxELrEFrFfy9JDIBSAn59+AYFEwCGuTxJb25DdWjnOg+QMwAXl5FwDXNh4RviIaQue1ksDk2Z
	Zm3zaBPX6NSNY27Y61nrkLd4gv+oRHCxn82w==
X-Received: by 2002:a05:6000:41f0:b0:47f:25e4:5c34 with SMTP id ffacd0b85a97d-47f9fe97cbdmr13014846f8f.29.1785186848047;
        Mon, 27 Jul 2026 14:14:08 -0700 (PDT)
Received: from Cluster1.powerhub ([2a0a:ef40:18b5:9e01:f5de:1ef8:371:ee89])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-47f85c67339sm54987049f8f.31.2026.07.27.14.14.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Jul 2026 14:14:07 -0700 (PDT)
From: Artem Blagodarenko <artem.blagodarenko@gmail.com>
X-Google-Original-From: Artem Blagodarenko <ablagodarenko@thelustrecollective.com>
To: linux-ext4@vger.kernel.org
Cc: adilger.kernel@dilger.ca,
	Artem Blagodarenko <artem.blagodarenko@gmail.com>
Subject: [RFC PATCH v4 5/8] ext4/066: verify LUFID dirdata operations
Date: Mon, 27 Jul 2026 17:13:42 -0400
Message-ID: <20260727211353.19736-11-ablagodarenko@thelustrecollective.com>
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

Test ext4 LUFID set/get operations on dirdata fields. This test
verifies that the EXT4_IOC_SET_LUFID ioctl can be used
to attach LUFID data to a directory entry and that `debugfs ls -lD`
can read this data.

Verification uses `debugfs ls -lD` to check for `fid:` markers,
indicating the presence of LUFID data in directory entries.

Signed-off-by: Artem Blagodarenko <artem.blagodarenko@gmail.com>
---
 tests/ext4/066     | 159 +++++++++++++++++++++++++++++++++++++++++++++
 tests/ext4/066.out |   4 ++
 2 files changed, 163 insertions(+)

diff --git a/tests/ext4/066 b/tests/ext4/066
new file mode 100755
index 00000000..979d9f1e
--- /dev/null
+++ b/tests/ext4/066
@@ -0,0 +1,159 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (c) 2026 The Lustre Collective. All Rights Reserved.
+# Author: Artem Blagodarenko <ablagodarenko@thelustrecollective.com>
+#
+# FS QA Test ext4/066
+#
+# Test the ext4 dirdata feature with LUFID ioctl functionality.
+# LUFID is a 16-byte identifier that can be attached
+# to directory entries. It is used for quick access to file metadata.
+# EXT4_IOC_SET_LUFID is an ioctl that allows LUFID data to be set on a
+# directory entry.
+
+. ./common/preamble
+_begin_fstest auto quick
+
+# Import common functions
+. ./common/filter
+. ./common/ext4
+
+_exclude_fs ext2
+_exclude_fs ext3
+
+_require_scratch_nocheck
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
+	# Verify kernel can mount filesystem with dirdata
+	if ! _scratch_mkfs -O dirdata &>>$seqres.full ; then
+		_notrun "failed to create filesystem with dirdata"
+	fi
+	if ! _try_scratch_mount &>>$seqres.full ; then
+		_notrun "kernel cannot mount filesystem with dirdata"
+	fi
+	_scratch_unmount
+}
+
+_require_scratch_dirdata
+
+_u32_to_le_hex()
+{
+	local v=$1
+	local h
+
+	h=$(printf '%08x' "$((v & 0xffffffff))")
+	printf '%s%s%s%s' "${h:6:2}" "${h:4:2}" "${h:2:2}" "${h:0:2}"
+}
+
+_build_default_expected_fid()
+{
+	local path=$1
+	local inode
+	local version
+	local ino_lo
+	local ver_hi ver_lo
+	local seq_hex oid_hex ver_hex
+
+	inode=$(stat -c '%i' "$path") || return 1
+	version=$(debugfs -R "stat <${inode}>" $SCRATCH_DEV 2>/dev/null | \
+		sed -n 's/.*Generation:[[:space:]]*\([0-9xa-fA-F]\+\).*/\1/p' | head -n 1)
+
+	if [ -z "$version" ]; then
+		return 1
+	fi
+
+	ino_lo=$((inode & 0xffffffff))
+	ver_lo=$((version & 0xffffffff))
+	ver_hi=$(((version >> 32) & 0xffffffff))
+
+	# Match lu_fid cast semantics: set_lufid stores u32 words in native memory
+	# order; debugfs reads lu_fid fields and prints f_seq/f_oid/f_ver.
+	# ext4 inode numbers are 32-bit so f_seq fits in 8 hex chars; avoid a
+	# 16-char $((16#...)) that would overflow for values >= 0x8000000000.
+	seq_hex="$(_u32_to_le_hex "$ino_lo")"
+	oid_hex="$(_u32_to_le_hex "$ver_lo")"
+	ver_hex="$(_u32_to_le_hex "$ver_hi")"
+
+	printf '[0x%x:0x%x:0x%x]' "$((16#$seq_hex))" "$((16#$oid_hex))" \
+		"$((16#$ver_hex))"
+}
+
+# Create a filesystem with dirdata feature
+_scratch_mkfs -O dirdata &>>$seqres.full
+_scratch_mount
+
+# Test: Create file and set multiple 16-byte LUFIDs on the same file
+echo "Test: Set multiple 16-byte LUFIDs on the same file"
+mkdir -p $SCRATCH_MNT/lufid_test
+echo "test content" > $SCRATCH_MNT/lufid_test/testfile.txt
+
+# Set both LUFIDs on the file at the same time (32 bytes total: two 16-byte FIDs)
+# First FID:  [part1 (8 bytes):part2 (4 bytes):part3 (4 bytes)]
+# Second FID: [part1 (8 bytes):part2 (4 bytes):part3 (4 bytes)]
+$SET_LUFID_PROG $SCRATCH_MNT/lufid_test testfile.txt >>$seqres.full
+if [ $? -ne 0 ]; then
+	echo "FAIL: Could not set both LUFIDs on testfile.txt"
+	_scratch_unmount
+	_check_scratch_fs
+	status=1
+	exit
+fi
+
+# Verify file is still accessible
+if [ ! -f $SCRATCH_MNT/lufid_test/testfile.txt ]; then
+	echo "FAIL: File not accessible after setting LUFIDs"
+	_scratch_unmount
+	_check_scratch_fs
+	status=1
+	exit
+fi
+
+# Verify file content is preserved
+content=$(cat $SCRATCH_MNT/lufid_test/testfile.txt 2>/dev/null)
+if [ "$content" != "test content" ]; then
+	echo "FAIL: File content not preserved after setting LUFIDs"
+	_scratch_unmount
+	_check_scratch_fs
+	status=1
+	exit
+fi
+
+expected_fid=$(_build_default_expected_fid $SCRATCH_MNT/lufid_test/testfile.txt)
+if [ -z "$expected_fid" ]; then
+	echo "FAIL: Could not calculate expected default LUFID"
+	_scratch_unmount
+	_check_scratch_fs
+	status=1
+	exit
+fi
+
+echo "Successfully set and verified both 16-byte LUFIDs on same file at the same time"
+
+# Dump directory structure to verify dirdata
+if ! _dump_dir_structure $SCRATCH_MNT/lufid_test testfile.txt "$expected_fid"; then
+	echo "FAIL: Stored LUFID does not match expected default value"
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
diff --git a/tests/ext4/066.out b/tests/ext4/066.out
new file mode 100644
index 00000000..4ec0fd6d
--- /dev/null
+++ b/tests/ext4/066.out
@@ -0,0 +1,4 @@
+QA output created by 066
+Test: Set multiple 16-byte LUFIDs on the same file
+Successfully set and verified both 16-byte LUFIDs on same file at the same time
+  Directory structure of lufid_test: OK (dirdata verified)
-- 
2.43.7

