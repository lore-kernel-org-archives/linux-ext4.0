Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.53
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793276939;
	b=hYnrtdbO79M+Vcr/oguIGDfBxCustcVvaj9GoEStcan2+4ojZKgZmkTqNQm4e5fzKlgs
	 RmPlgTwhQNrGkd0VRd7Bmxf6VIQM8m3GXlG18IxmRKw3BnROhMXEaCcyTvTTgTItQbc54
	 qxC5ePG9KvmA5pkjIKy3WJK0wqTdHfkk4z9Ry9f0WvroNXu/ishQiED2ILSwjWDEwZGCW
	 RvstZAyqr3eL12fMmdmBUaiFN6Ydi88SBlmvprLKMJf0Vz2E52kAYA0Mk3Qd+pacX0Mn4
	 AS1M+LxSv37aaka7+9IwRZud1cGZRCDpCgHi3dBym/ZUtxddD60QXPuepjVm6gR2cfA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793276939;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:
	 X-Google-Original-From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=PXp20XL3Gp1jxPMTn0MCFAQ9adhBIzNFQfhJNEp9ekc=;
	b=48HdrIZ4w9UKz51K+fFyfxmbVM2XCkr1FlGmB7m5+H3aRQqd8UA1UqQZdjKij1VyNra/
	 IrF2TJ/7dk2cUYPUC7RsV1wRoLgVhpu5tCyvwDdZMNwA8mWN/CrkfdiT9slOgLqJmRrfF
	 pUibw1/FkErdU2lFxfo9evrqvmwbJRo+EnOeykDL2EvKxXoKTOBe9mX6yiNu/HOckNkmO
	 CM1YALXvW+KrhN6+kdbXBO6awMTWMFfIqSYGyGOd0JqOY3bDQR26C3UxsVoA0F63XsZAd
	 rdUl2Mnc7dEgHhQnvrqOMGot1PTYUHtBEJsmvDW2Z9ZKRSt4Fx/d/XeenfjnrXxA9pg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=YrZCBS9c;
	arc=none smtp.remote-ip=209.85.128.53
Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED833606A320
	for <linux-ext4@vger.kernel.org>; Thu, 29 Oct 2026 12:28:58 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org ED833606A320
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=YrZCBS9c
Received: by mail-wm1-f53.google.com with SMTP id 5b1f17b1804b1-4a5177d78c7so20498215e9.2
        for <linux-ext4@vger.kernel.org>; Thu, 29 Oct 2026 05:28:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793276937; x=1793881737; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=PXp20XL3Gp1jxPMTn0MCFAQ9adhBIzNFQfhJNEp9ekc=;
        b=YrZCBS9cJjtd4vUk53UWdrb83wr1lZRsshmPWUV4Yh1sE5VBpXiegCIDXFlxZ6bq08
         vBT6rvgC/Cxeg2py8h8ryaB6aqQ8s0H74aoe2EMumNePCsdsJKyDRiCLBrLP0KQDUGGL
         yBOpgksTltD2+PaX3YSQJ98dKHdqbOOSvqWFTyJobQqZrgMmnLqGuF4AyUMzsOG8C1cn
         8HAD9LJ+dHTyGTs+MsP9M8n1ySWH7UcfcbOrG71m2yZdy+fOLPShIm8s5EG3WZkhVF7t
         14iEXDi0CcJzLrdooJfXKZ74MhzvRKCGEfWBaPZ9Gb23UEVV+lk9v5MOcYycB7Eo9O5c
         As5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793276937; x=1793881737;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=PXp20XL3Gp1jxPMTn0MCFAQ9adhBIzNFQfhJNEp9ekc=;
        b=MRGa76a9Cjp3BWbGtim5tz49dWE4LiQL2LwCCSzIc/w5AHubrmsyWfSP3QSJCXG392
         UXtrkekoy3N+a7OoUpFJcacKVW66PdU5OlkcLv3NdOs0Qk3EHqud3tyJIfLC4UYrbdK0
         79XgX1t6+wGvemcKzt8j6df+6Qf39eJeWhGPtZZnUPWSK2iZkN/Gy4lkqMg1hhyiGbx6
         Ktw47YqKoxbujOYqtqYFfBcWVxTk4xvZOtjqzh0n4D/kjR4RWS73y/2T6dTNHEIEr/jG
         0rQ07LuLmty80uPKCRGzOj7ZuVTeMclzjI9XY5EfhOG3P2mhQiGeIjpxY3+JS1rZOHqx
         ddLg==
X-Gm-Message-State: AFq9FYKyU5UZaOa9BiXqbuBcUOEAZC4+NHS8/LdfWm/WOXVwF5rUd5pD
	ZbUQuP3fwpEw/angRkae3DK1sPP1NidSAtFA3+tI4/BbUsz/qVSPwys22mvlweDy
X-Gm-Gg: AYBFou2lizKKEdGixrlyTGD6MzXG10YzfN86/HoK8rJcMc5kbru5uM4SvplWa7aWIAx
	GhP+HnX21LeR2Me5Qx2PQccnyWHiwRh9J5TyurpVBF6ojS+Ejbl0nRwH1TkV4HW7EH4ZULNPcOt
	c8XzvfXPl5gowkQSWVEjl0KVAL9E+c4jqsTsrQ3nFguwXuaRd/9FwNSyY5LYyxa8yTytUW9WudQ
	4prZcJJvJ5YyE8CrnaRk4+ofJJ+O+qZbCC49HrkrUuJ3XuZrdLkpE+/NQvDwf5uWLwpWG/fIw7n
	UHHOTZ74MAOFTcQD5+IWeO16byJLrlaDFCqV9CpkDnWzmPbXgWW0cwPk0cx6MeWjpzrTb9eCKmP
	9d3VMDI99p+HoYk26c4efc11LEqdj17UPcLQv825wlt8LShYIYhEAvwFQP5kbMIHZ0zfyV4cj4j
	sIJ4jAMswPlPUWq6+dySdN2zuyGqkON1Zf70ZLgpGT6yQZifmiqhT3X7lNj+lhOZqgyoj31oVH2
	W6Ou+1UBFmmaQ1GH/aVnDc/4fDapAA4GZoiDvmN3Tfku/omw16F3Dhwi4NQo/XyEfgtZsrMUHwG
	PA9mdkQnalvI9sZLvqMHGHcDHc4PuBNeo7HvvOEPLb2Pe3z10GFW1w7/NpTh
X-Received: by 2002:a05:600c:4e42:b0:4a0:27eb:49b with SMTP id 5b1f17b1804b1-4a9678c276dmr120311025e9.30.1793276937398;
        Thu, 29 Oct 2026 05:28:57 -0700 (PDT)
Received: from Cluster2.powerhub ([2a0a:ef40:18b5:9e01:225:90ff:fefc:9ffe])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4aa7f7f50d3sm92477915e9.8.2026.10.29.05.28.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Oct 2026 05:28:57 -0700 (PDT)
From: Artem Blagodarenko <artem.blagodarenko@gmail.com>
X-Google-Original-From: Artem Blagodarenko <ablagodarenko@thelustrecollective.com>
To: fstests@vger.kernel.org
Cc: linux-ext4@vger.kernel.org,
	adilger.kernel@dilger.ca,
	ablagodarenko@thelustrecollective.com,
	Artem Blagodarenko <artem.blagodarenko@gmail.com>
Subject: [RFC PATCH v5 5/8] ext4/066: verify LUFID dirdata operations
Date: Thu, 29 Oct 2026 12:28:36 +0000
Message-ID: <20261029122842.230704-6-ablagodarenko@thelustrecollective.com>
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
 create mode 100755 tests/ext4/066
 create mode 100644 tests/ext4/066.out

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
2.52.0

