Received: from mail-wm1-f42.google.com (mail-wm1-f42.google.com [209.85.128.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66A733EDAA8
	for <linux-ext4@vger.kernel.org>; Mon, 27 Jul 2026 21:14:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785186858; cv=none; b=cg8GPOwa3RxY43gHcE534yvTYE7QnvsJcGIYpslAyDysFWvMfMBHPTE9puGPr5ANDX/gYuokXuUbvkysyuGBBJGv86oWXn7sstcyCip6ZcIP8pjfZsSaU72XvemsX8pmh1si8EBzDEvzQfguN+FQx9eKf2VDczvY4DWdEaYbSfE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785186858; c=relaxed/simple;
	bh=d7IKJg5bDTw5ywp6MRjnvF6s7F9SRAcZ+UD0l6AhUBo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VxekTguuKNJixlrI6M8Uhcho8vCiMfTJnPD0LEoRhCtZ3q1rkdxzDffNzDBjtC19jt96h8Yxxo3bNWLRURt6vVpbwPBpx3KJJXj49yr7t9UFJPBxmJS4uEg80oCK8xZZRPbY3X6pWyHukLMv0OZpGz9CwVvtwSyWRYG6SQwkkD4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=rdKBe4G9; arc=none smtp.client-ip=209.85.128.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="rdKBe4G9"
Received: by mail-wm1-f42.google.com with SMTP id 5b1f17b1804b1-493f75f7172so26649815e9.1
        for <linux-ext4@vger.kernel.org>; Mon, 27 Jul 2026 14:14:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785186855; x=1785791655; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=NznIVXcDU9ZuTVJ0oiSS7u9W5ZLavyy9yA8CeyZb6V8=;
        b=rdKBe4G9rzt2pXTXMGmxfW5D1tOrpnXfl+DPfuxnZ+iBNiK7kjBzODfSKnrqZqiuRk
         8z9jW8eRRrR/xhO6ZjIra+ZDtsGIqTayOnCVX+wS5pik2/0vpf6MAL5vrX7cLNWtflnd
         tMZkKqGGNcXVbQn7CsjRKfrAQqZvfbXkxAig9/edRBNeWP+dycQhsc6XEQL/WAtQB4qp
         lHUr6SnVGS54B7g1XqGOSmK11ZmMKi2XEXfKnhm97M79s9xW1U0KbyBQIu6gS21/PB9c
         ThvSrWqktDcHiCPnhR452tdgM1NGRnD8ZZvGp/R624MN/Ong4O6PDL1GkMIlKnq1yDH2
         uM5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785186855; x=1785791655;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=NznIVXcDU9ZuTVJ0oiSS7u9W5ZLavyy9yA8CeyZb6V8=;
        b=LVkDpa2axEIIjfUGIQyKQgi/s0JZMGu4lEUik6RhYO4bwoYDh7hllZCYxhWoJWxmkJ
         HOdL1ASPtYZkhODriuaRkwOXC9gJrSSW/9pP7b/do46RdX7u9JFBmWvQXHzUNT19JYI0
         cIr7SFZCIKrK/uhp2yj/wim5UJ5LGLNqPKKNlG9bYFOEL/31cRmXpR7yZefGgSlYYJhg
         UADvwEnePLtzPMzbhcvntrmUGBAGGNzry9sHbrskbo9In/PXYrzFUB+3NaqM2FSgTPDc
         jJVobo3uHyQ+RVeQYFFiamHI9Vsyl2zO5hYgR5De8S/zGjaCLM75v6gJfbfXqnYIc6py
         Bzpg==
X-Gm-Message-State: AOJu0Yx3fmWp6MCtHUJ/yqi4e6bpoeKRZ4IyW3S126s23GZVrKgz5JkJ
	wbsOqChKkVZ/kINE0jZ55TgXTxVb/Xt5aLTGxH7tKcaKsDQX2RQp0dbyt4akqoMK
X-Gm-Gg: AR+sD13zNjjm7T4AZLIg7Vk3G5hfMNo6VTf6T5QFbfD0MFg+Wz0aC5GKkFtQoHwMtwl
	0ANdQh4tDdVTGS0VFZPhFOr6I8KNwASp84DNbgtbqT64PdGT/k2OPxfh8sWDGri4YpAVmhpwdaB
	6r3dFB0Mg0FxNupSLJgX3X8xrLgZx8aQaes4n+RsAJSJCv3KsWVTT4+NQMD/S1GTCKWwUcLvWS3
	KskhbPzhUSyN/lxCV64VmNBbEhitdLfmzo7sC8x58fwH7209Mcdqbey00s6sEuRLkiL3W0ZY79j
	EDYSd09wHeyGHDt8irlCW6G6ysvgSRMNgOBwwOh3JOdzP8Sz84DRXHqPrSaeyF/XAQOC+f+tE8G
	BKfTyQKUpIFpBhi5omYmNLfi9FkSyS8wD+opSAExDQIzLUQEqBjTDXGYrUr207eQlLw3tbx1xXa
	SXT9hWPCFuO705kFSbVqavHy6+yRiL/nv9Gw5L4Dyb9P//
X-Received: by 2002:a05:600c:4f81:b0:493:f528:58ac with SMTP id 5b1f17b1804b1-496b56f9d75mr141775465e9.21.1785186854556;
        Mon, 27 Jul 2026 14:14:14 -0700 (PDT)
Received: from Cluster1.powerhub ([2a0a:ef40:18b5:9e01:f5de:1ef8:371:ee89])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-47f85c67339sm54987049f8f.31.2026.07.27.14.14.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Jul 2026 14:14:14 -0700 (PDT)
From: Artem Blagodarenko <artem.blagodarenko@gmail.com>
X-Google-Original-From: Artem Blagodarenko <ablagodarenko@thelustrecollective.com>
To: linux-ext4@vger.kernel.org
Cc: adilger.kernel@dilger.ca,
	Lustre Development <lustre-dev@example.com>,
	Artem Blagodarenko <artem.blagodarenko@gmail.com>
Subject: [RFC PATCH v4 8/8] ext4/069: test LUFID in inline_data directory entries
Date: Mon, 27 Jul 2026 17:13:48 -0400
Message-ID: <20260727211353.19736-17-ablagodarenko@thelustrecollective.com>
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

From: Lustre Development <lustre-dev@example.com>

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
2.43.7

