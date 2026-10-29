Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.221.52
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793276941;
	b=G0Y3lR0Jg5M6MVnGvnKGrLZE1cQ4B1xR5Jl/h//aH7RA83dG3w7RSNicTuHNsBN+oG12
	 +VN2bPvPcUixVqsk02mS0gphrHVcLrtN/JUlSwrcaLqVMaUruDzzhjtIcDDVGpdC0aAsa
	 AXBttept7jiwE8XVG0QXslO2HrSVzvqDaxxqDqFH4WzUxs6Tf7wC1N15kLoD7zIOUepnH
	 GOgotTwak2su+iQguDl2EFszq/jDUun32MKNhjfnIweFHmi3EDLyYiOffD+OMShGe2QBz
	 ZfLij8dYWJO3L5CB7ATiVpqFzq5mzPT9f3vSReBDObI18Xswczgkl+nW4kzjqq0I79g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793276941;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:
	 X-Google-Original-From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=4OGFr7kDHZY+j8TMyBgS5H6nx5zjbqSGG4iF4apesuk=;
	b=tr/rB8ML4lC6oyOjLrSARCFFloMShDcPRkikI//VSAuXXF+FnW6RD78J3J9tAQOcNpzo
	 17SF58ciSf9ciS7/+25YME0v00k0jWGg1S/0AzibQHDuZ62y6Vrn9+m6GPhDWd6c2mTYU
	 QBgOVkRicoUG+f0ov44J7Jby2y1u4ZJTy12eQxF7PoSGAEwu3ifV13MkcTWHVQ8UsFSu8
	 gcoRn5rQAslvOqSXl+QTlocvMTYHWeVGzG/6PSQLBRb4iPL1sj3mAVf0vsWibSlOLvurt
	 gbUhka0MxoWGB++B8/P6QprwmBvyQA8Xlwu3rNaBgqDItUAVcmcosCEayjVxOb3cg6Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=Skodb+wg;
	arc=none smtp.remote-ip=209.85.221.52
Received: from mail-wr1-f52.google.com (mail-wr1-f52.google.com [209.85.221.52])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42AC3606A321
	for <linux-ext4@vger.kernel.org>; Thu, 29 Oct 2026 12:29:01 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 42AC3606A321
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=Skodb+wg
Received: by mail-wr1-f52.google.com with SMTP id ffacd0b85a97d-48df4e9d2d4so1226512f8f.3
        for <linux-ext4@vger.kernel.org>; Thu, 29 Oct 2026 05:29:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793276940; x=1793881740; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=4OGFr7kDHZY+j8TMyBgS5H6nx5zjbqSGG4iF4apesuk=;
        b=Skodb+wgQoWoPeNWPw+LErtBDhy5tIGuvjoxoSdDqSdPMX5yGO8NzP4KO2pOR3jvtW
         9Mj9Mq/yoVpubpJdTmVbFeKXUp92US7YtqegxMy8yACFeoOaQaw1gra+B9vBa7SxnDa5
         b6acl5WvsQI8H6xUcJlsb81N8ktGcOrFaEGeNt6JGcibZ3cI/uSVdJb1ni3JsxaijNn4
         YSa9H4uRXiKxSFjhgS0ZIAXlzPtukLuVx0IQK7rEtcyDiGxpFyq+6pwew8o4AG/9OmPe
         5GNIywnQPckRgrr0xVBoYAZv/UaKgH7SbCEbjURiJ3XxfkVhlAR0rNu4L0+JUG3ptitM
         rKGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793276940; x=1793881740;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=4OGFr7kDHZY+j8TMyBgS5H6nx5zjbqSGG4iF4apesuk=;
        b=uaDsotM7dkX47eHO0rqIQR6I8I50sWjZ2Yk7S+KSn5IBfZGM2FryZAuRrReoaX1U/V
         9LqmeE5Ryed9HRGeSuKPzzcGkJ7WBDdbg/fqcX9ryG8+wMJClvkndRLbgm/pKpKxvxmV
         LPJumRai+u1YlDPEEghRLjB2u9uRI7+YhXxqB7T8KcGVNP2hzEs0oJh0SDYIbKluQdyB
         WqVRS/CRa2tqTuvk+zvL5yPVbKSD0gvQqFyX+1F3W/XaT0erlvMvm1i3ly2dyhAiFaZ8
         bxh7tUMvvp22yriKL9BcX++7fTWqLv1mmDpMpzJkAgSf/r3rNRew5bUDGm3Q7b34VxPl
         Y/Ag==
X-Gm-Message-State: AFq9FYKdcpFZjKFdcTv6Z0Yrlj0rAZfpEQLUeWtYyjlywW0eqGZM21uj
	GMxUceB4oAyO+9ucqPSCzSpntXSvi4kMR/iYq39dZD3GfryvMiTZ0jcR74rRQ5U8
X-Gm-Gg: AYBFou3j5UuNofzLWGhE4sO8QcP4pAfOn0LEIo2LX2bSLlG2nR2fB5Kl9quo6awP/O6
	QY1mlsaWFpqWIRinBw/75rUjEFiztCIenkx5DwHJXhcy2ZjuLsT3PZYKwPy589+vWkbSoe1BimB
	7eKX4BiCwjRjbUxaRhPD0wKj9if89XJoH5cbcIDtoP2eCT6xpieV1h3RwHXCK3jNOYWZrrhpR17
	yZpjG+mNZcp7Mig2UQ3SR8u4FKQiIualTTNxfh8asTnvWOWW0ixOjeb0Y5/Nr6BqpKO7ZSo95m4
	jmGD1HgoRQaZNng44qYPWibbBmiF+ti0YKoRm8Ryg2HGWXMIEAKXywwmarn7HiWepdv4Jwd+nvl
	VMG6fyJPFaLfpGWXZpinn+u+3C9J+2XyAxcM4+BoID/ZZBCFTuVo8yU634zBXxuoCGzmk/fJ/Ux
	esYyC5ulDVm5fvAe8KZ6B2jkl2vvUBdKryQqVtyzbYsPz7chRXeOGU4Ofz185vSmhVxZYwj2X5W
	xAFPPhj/GNogQLrzLR5cV03mCQWtsOs1tHoFBLin0wZ8E3sStTaveCXfZ2ddXSGhYNIBg5Y3zfr
	d8clUxmNaqKdx6K91MsdaTrDldXVUe3iJMVEXCOtwQB2PAZopPf9KNOgValj1w==
X-Received: by 2002:a05:600c:314f:b0:4a3:59c9:a744 with SMTP id 5b1f17b1804b1-4a965be619dmr112126955e9.7.1793276939523;
        Thu, 29 Oct 2026 05:28:59 -0700 (PDT)
Received: from Cluster2.powerhub ([2a0a:ef40:18b5:9e01:225:90ff:fefc:9ffe])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4aa7f7f50d3sm92477915e9.8.2026.10.29.05.28.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Oct 2026 05:28:59 -0700 (PDT)
From: Artem Blagodarenko <artem.blagodarenko@gmail.com>
X-Google-Original-From: Artem Blagodarenko <ablagodarenko@thelustrecollective.com>
To: fstests@vger.kernel.org
Cc: linux-ext4@vger.kernel.org,
	adilger.kernel@dilger.ca,
	ablagodarenko@thelustrecollective.com,
	Artem Blagodarenko <artem.blagodarenko@gmail.com>
Subject: [RFC PATCH v5 8/8] ext4/069: test LUFID in inline_data directory entries
Date: Thu, 29 Oct 2026 12:28:39 +0000
Message-ID: <20261029122842.230704-9-ablagodarenko@thelustrecollective.com>
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

Verify that a LUFID set via EXT4_IOC_SET_LUFID on an entry in an
inline_data directory is correctly stored on disk.

The test formats a filesystem with -O dirdata,inline_data, creates a
directory with two entries (small enough to remain inline), sets a LUFID
on one entry, and confirms the fid= field is present in the raw
directory data via debugfs.

The require guard probes the combined dirdata+inline_data mount so that
a kernel that accepts each feature individually but rejects the
combination emits [not run] rather than FAIL.

Signed-off-by: Artem Blagodarenko <artem.blagodarenko@gmail.com>
---
 tests/ext4/069     | 164 +++++++++++++++++++++++++++++++++++++++++++++
 tests/ext4/069.out |   7 ++
 2 files changed, 171 insertions(+)
 create mode 100755 tests/ext4/069
 create mode 100644 tests/ext4/069.out

diff --git a/tests/ext4/069 b/tests/ext4/069
new file mode 100755
index 00000000..b8b3e459
--- /dev/null
+++ b/tests/ext4/069
@@ -0,0 +1,164 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (c) 2026 The Lustre Collective. All Rights Reserved.
+# Author: Artem Blagodarenko <ablagodarenko@thelustrecollective.com>
+#
+# FS QA Test ext4/069
+#
+# Regression test for inline directory + dirdata LUFID loss.
+#
+# ext4_add_dirent_to_inline() was passing NULL instead of dfid to
+# ext4_insert_dentry_data(), silently dropping the LUFID for every entry
+# created while the directory fits in the inode's inline-data area.
+#
+# The test creates a directory small enough to stay inline, sets a LUFID
+# on one of its entries, and verifies the LUFID is present on disk via
+# debugfs.  Without the fix, debugfs reports no fid= field and the test
+# fails.
+
+. ./common/preamble
+_begin_fstest auto quick
+
+. ./common/filter
+. ./common/ext4
+
+_exclude_fs ext2
+_exclude_fs ext3
+
+_require_scratch_nocheck
+_require_command "$SET_LUFID_PROG"
+
+_require_scratch_dirdata()
+{
+	if test ! -f /sys/fs/ext4/features/dirdata ; then
+		_notrun "dirdata feature not supported by kernel"
+	fi
+	if ! $MKFS_EXT4_PROG -O dirdata -n $SCRATCH_DEV &>>$seqres.full ; then
+		_notrun "mkfs.ext4 does not support dirdata feature"
+	fi
+	if ! _scratch_mkfs -O dirdata,inline_data &>>$seqres.full ; then
+		_notrun "failed to create filesystem with dirdata+inline_data"
+	fi
+	if ! _try_scratch_mount &>>$seqres.full ; then
+		_notrun "kernel cannot mount filesystem with dirdata+inline_data"
+	fi
+	_scratch_unmount
+}
+
+_require_scratch_ext4_feature "inline_data"
+_require_scratch_dirdata
+
+# ---- helpers ----------------------------------------------------------------
+
+_u32_to_le_hex()
+{
+	local v=$1
+	local h
+	h=$(printf '%08x' "$((v & 0xffffffff))")
+	printf '%s%s%s%s' "${h:6:2}" "${h:4:2}" "${h:2:2}" "${h:0:2}"
+}
+
+_build_default_expected_fid()
+{
+	local path=$1
+	local inode version ino_lo ver_lo ver_hi seq_hex oid_hex ver_hex
+
+	inode=$(stat -c '%i' "$path") || return 1
+	version=$(debugfs -R "stat <${inode}>" $SCRATCH_DEV 2>/dev/null | \
+		sed -n 's/.*Generation:[[:space:]]*\([0-9xa-fA-F]\+\).*/\1/p' | head -1)
+	[ -z "$version" ] && return 1
+
+	ino_lo=$((inode & 0xffffffff))
+	ver_lo=$((version & 0xffffffff))
+	ver_hi=$(((version >> 32) & 0xffffffff))
+
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
+# Confirm the directory inode carries the Inline_Data flag.
+_check_inline()
+{
+	local dir=$1
+	local inode flags
+
+	inode=$(stat -c '%i' "$dir")
+	flags=$(debugfs -R "stat <${inode}>" $SCRATCH_DEV 2>/dev/null | \
+		sed -n 's/^.*Flags: \([0-9a-fx]*\).*$/\1/p')
+	# EXT4_INLINE_DATA_FL = 0x10000000
+	if (( (16#${flags#0x}) & 0x10000000 )); then
+		return 0
+	fi
+	return 1
+}
+
+# ---- test -------------------------------------------------------------------
+
+echo "== Create dirdata + inline_data filesystem =="
+_scratch_mkfs -O dirdata,inline_data &>>$seqres.full
+_scratch_mount
+
+TESTDIR=$SCRATCH_MNT/inline_dir
+mkdir "$TESTDIR"
+
+# Two entries keep the directory comfortably within the inline-data area
+# (~160 bytes available in a 256-byte inode) so ext4 does not convert it
+# to an on-disk block before we set the LUFID.
+echo "content" > "$TESTDIR/file_a"
+echo "content" > "$TESTDIR/file_b"
+
+sync
+
+echo "== Verify directory is inline =="
+if ! _check_inline "$TESTDIR"; then
+	echo "SKIP: directory was not kept inline (inode too small or inline_data inactive)"
+	_scratch_unmount
+	status=0
+	exit
+fi
+echo "  inline_dir: inline data confirmed"
+
+echo "== Set LUFID on file_a (inline directory entry) =="
+$SET_LUFID_PROG "$SCRATCH_MNT/inline_dir" file_a >>$seqres.full
+if [ $? -ne 0 ]; then
+	echo "FAIL: set_lufid returned error"
+	_scratch_unmount
+	_check_scratch_fs
+	status=1
+	exit
+fi
+
+expected=$(_build_default_expected_fid "$TESTDIR/file_a")
+if [ -z "$expected" ]; then
+	echo "FAIL: could not compute expected LUFID"
+	_scratch_unmount
+	_check_scratch_fs
+	status=1
+	exit
+fi
+
+sync
+
+echo "== Verify LUFID stored in inline directory entry =="
+# _dump_dir_structure reads from the raw block device via debugfs and
+# reports the fid= field written by ext4_dirdata_set().  Before the fix,
+# ext4_add_dirent_to_inline() passed NULL instead of dfid, so no fid=
+# field was written and this check would fail.
+if ! _dump_dir_structure "$TESTDIR" file_a "$expected"; then
+	_scratch_unmount
+	_check_scratch_fs
+	status=1
+	exit
+fi
+
+_scratch_unmount
+_check_scratch_fs
+
+status=0
+exit
diff --git a/tests/ext4/069.out b/tests/ext4/069.out
new file mode 100644
index 00000000..2c8c4d9f
--- /dev/null
+++ b/tests/ext4/069.out
@@ -0,0 +1,7 @@
+QA output created by 069
+== Create dirdata + inline_data filesystem ==
+== Verify directory is inline ==
+  inline_dir: inline data confirmed
+== Set LUFID on file_a (inline directory entry) ==
+== Verify LUFID stored in inline directory entry ==
+  Directory structure of inline_dir: OK (dirdata verified)
-- 
2.52.0

