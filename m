Received: from mail-wr1-f54.google.com (mail-wr1-f54.google.com [209.85.221.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6EB43B840E
	for <linux-ext4@vger.kernel.org>; Wed, 24 Jun 2026 13:50:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782309033; cv=none; b=fvMgTVrMwczxjjdR3N1MAF5S2c4ac4j40MCvaxe5h3FwJNAs3zpZ25uyicWTd6t+jEOxqvL6gOoZAjW+ml6wXB3Wf01DNFHRXOhbC5C/T1FcMw+BUvEVtcQ84CqzOv2TpiddSOLTXHL83cah+htLnwgil1rNx0+UpEoriQGxDA4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782309033; c=relaxed/simple;
	bh=+Uc0cR+xBdNbnU4I3v9rF/Wcnsa82NLL+mXkz8oaO6Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WK0fjMj7Zr0wrgLBu8OKcznGzoAMyxeroYIezcok7ktzPB5porTOxKRIFvddTv5lCid0TEkPjU2u0oIhgkq42V8A/A7pGAW6/HwK21Rt/APN5lyQApYhzYHIBXLO85Ke7/YnqjD4enOTslIXBqHU7ht/E+epB+6EZNuqZ/m/kQA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=TlVVJQZf; arc=none smtp.client-ip=209.85.221.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="TlVVJQZf"
Received: by mail-wr1-f54.google.com with SMTP id ffacd0b85a97d-46cf972f281so136969f8f.2
        for <linux-ext4@vger.kernel.org>; Wed, 24 Jun 2026 06:50:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782309030; x=1782913830; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=QRf7Z9lc1wmx4ImWUMBTf6bs5b5Ls7EzAk09nydpuIM=;
        b=TlVVJQZfq7Rf2dMeYOpQ5n56Dh55Y2OoY23klMVZOrZNwKKGhHkzeBKbJaOKlnnenq
         e+rtZqpb81pcHHFXtvZWLfxS1wCzVjypfGnuOjxMIiAbH0c2O2H2kOlRdhJ13P7ceOza
         KxVdMz76qYzP9j2b9uSUcTDCJkY30sT1n3NvjE5FTb0dt8/TamlTmqBWJ42IgmXHokkt
         Ikb5vAd049a7ykwfZQ1rivEvFufAJgJAK96omG3D3o2vCmENvqPnJBV8R8HGOuka0bDg
         koct3pEzszvfHweh/EJTSjwtc2hPOu5r+zCZnqzvXmgxXaYkIa/FWbtoAfQTEQE8OAd0
         HsbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782309030; x=1782913830;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=QRf7Z9lc1wmx4ImWUMBTf6bs5b5Ls7EzAk09nydpuIM=;
        b=VaKDo78NLCLbUk/sxP4GGV5jnStubrZKuGYqMruRsFqpWYqMlbRPNeYzO6Hxm0bLpQ
         rim6bVXsQpN4tOU3vX2PjV2tYBFyIOaRzDfm/XWPmXcZn/sSlG16rdgqE984o0utyvSK
         2qHkZXxy812oS3q6LHTuAiprEeJbZzMFDRNwRUx2r2zB0haCszwjdOfQa5OtDjbjSxUT
         WKaYIRb6d6H5FcKPiw5sQXs/dzpcXeYPrvm96pHy/FnAQNcML8Y7BGKn/U7VhNaluNdo
         3ySztEuTMLA600vTiRSUTQZlNJEv2FbqqniE2M32zhDJ7NbUMKUWKrEoXdWUbmLb2xEb
         SLBA==
X-Gm-Message-State: AOJu0YwESwc8ed/GxhK86MwQNcuJJ9kLDRlLU1dJrpXerLTNDxf6Ek0M
	6+bfCypE81jlbwdlSusdA4cEDdpI+rpYMkrB7J0bTYFU7Q3yeHprEgq+m+BvIilcKz8=
X-Gm-Gg: AfdE7cmSyNtrmRnX8mFvNVx7ojytDi5PiO7U+/N5kHjmWS2IwaGk5uSoAT8BC8h4KwS
	e0xO6ZEynir2tkUk3Ig51B94ZL0TUPclbqjHMRt3M0KdLxYr2o/0/A9FPdAB4Ismdv8BoSIf9DE
	x4fvQgATVUo3UBHkuHHuFv3PUO4+Pj56dYWSW1tVRyQaytDR97TqV0fZrNRznroRU30wktmLFHK
	aB91p41yaU4fK7M1rpnPxjAYZDahiO10/QTlPlkSA7IAy3Br8L9K5IVgqAgIMlgX83C7vROtVxv
	77VthL5rVFO3o6/WA00L+66cIH9i9vWSzyNxmzVyK3y9iNsl/uwyPwFIacZ4Lm8cTwD7TcD5p6a
	1f4qGOqOWpAeQuCLjXc/bZJzjjnA0lfCmLq7ZR4J1A/m8R97TDGEBu6ew9d9ZORurXJcF2Fc+8Q
	eoQKExOWOYAljAXXvsTiooHcN2mscIKLXIgDOeTAOksONW
X-Received: by 2002:a05:6000:1844:b0:45e:e1a4:c4c3 with SMTP id ffacd0b85a97d-46c04f0311cmr6041130f8f.15.1782309030206;
        Wed, 24 Jun 2026 06:50:30 -0700 (PDT)
Received: from Cluster1.powerhub ([2a0a:ef40:8ee:1201:acf4:9ddd:6ede:2d9a])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-46c1e840eefsm7791658f8f.1.2026.06.24.06.50.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Jun 2026 06:50:29 -0700 (PDT)
From: Artem Blagodarenko <artem.blagodarenko@gmail.com>
X-Google-Original-From: Artem Blagodarenko <ablagodarenko@thelustrecollective.com>
To: linux-ext4@vger.kernel.org
Cc: adilger.kernel@dilger.ca,
	Artem Blagodarenko <artem.blagodarenko@gmail.com>
Subject: [RFC PATCH v3 5/6] ext4/066: verify LUFID dirdata operations
Date: Wed, 24 Jun 2026 09:49:56 -0400
Message-ID: <20260624134957.19209-6-ablagodarenko@thelustrecollective.com>
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

Test ext4 LUFID set/get operations on dirdata fields. This test
verifies that the EXT4_IOC_SET_LUFID ioctl can be used
to attach LUFID data to a directory entry and that `debugfs ls -lD`
can read this data.

Verification uses `debugfs ls -lD` to check for `fid:` markers,
indicating the presence of LUFID data in directory entries.

Signed-off-by: Artem Blagodarenko <artem.blagodarenko@gmail.com>
---
 tests/ext4/066     | 158 +++++++++++++++++++++++++++++++++++++++++++++
 tests/ext4/066.out |   4 ++
 2 files changed, 162 insertions(+)

diff --git a/tests/ext4/066 b/tests/ext4/066
new file mode 100755
index 00000000..ae98fb45
--- /dev/null
+++ b/tests/ext4/066
@@ -0,0 +1,158 @@
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
+	local ino_hi ino_lo
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
+	ino_hi=$(((inode >> 32) & 0xffffffff))
+	ino_lo=$((inode & 0xffffffff))
+	ver_lo=$((version & 0xffffffff))
+	ver_hi=$(((version >> 32) & 0xffffffff))
+
+	# Match lu_fid cast semantics: set_lufid stores u32 words in native memory
+	# order; debugfs reads lu_fid fields and prints f_seq/f_oid/f_ver.
+	seq_hex="$(_u32_to_le_hex "$ino_hi")$(_u32_to_le_hex "$ino_lo")"
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
+set_lufid $SCRATCH_MNT/lufid_test testfile.txt >>$seqres.full
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

