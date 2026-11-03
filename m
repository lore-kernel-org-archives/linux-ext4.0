Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.54
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793713885;
	b=2iOb4U3CZ7EpcXk9Xo5k8Zi5Al9y6XA01QpCiFPq6ONnsi6G0OhM0NAnVJ26hFTHRSwp
	 zy9FjkEGNiJ4lP8BkaraLtVxingKb9IQHk7FRlwU/4mna2LqvKq9xXAbt9liDuFo52hK5
	 oWkoefU3DZ0PZ09vVDrD6hddR+sZHwEv/d+JGYJltDv/IX7rn2mB7IxpYQxVIA+dcaZjs
	 mr10TvCn0lwzDMkNJ/4aoet0Ztzml7MrUEheXEJl3YCDoXg/0mP+p4mAnW/1VH35n+uKr
	 XT9bp2pUc5MPIo+6en6LmUpKB/cjGZfhiRMArVi1E/w9nV8pK5LqF59ZXThhKYNBUjw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793713885;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:
	 X-Google-Original-From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=4OGFr7kDHZY+j8TMyBgS5H6nx5zjbqSGG4iF4apesuk=;
	b=5d1yydoN4eu7hnWCbCsjEf/fh9LWYomZmSW5wvSjUlwMmHjOdP6lfQVZt2NuLtNMSV55
	 XgZw/OFaWKMUzjRjJN5OMrq+FO/9E5KJwFuDJ5XlE8mdgDdyA3OrbNwpJvfHoUa9m5huX
	 oQySthyxFElQ9ri5fqdXzf3X4cJ4yVA5KyYG65w7wohLYkVrbnC4a+ewfeNih5N1dF8cB
	 xEFBhCmIdXDFtcTt8y5xPAkstHoW1IT7ni6ko2KHNUpLGhV4dNXusWYA9dTZNEdbAz0f6
	 adiX+uMUGOhZqJ42SvT8qcw7uz+odgsG5nTPgK26lYppqPvZggtP1e6Jpx4GzQGJoZA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=oQg6b8kq;
	arc=none smtp.remote-ip=209.85.128.54
Received: from mail-wm1-f54.google.com (mail-wm1-f54.google.com [209.85.128.54])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D567606D808
	for <linux-ext4@vger.kernel.org>; Tue,  3 Nov 2026 13:51:24 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 9D567606D808
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=oQg6b8kq
Received: by mail-wm1-f54.google.com with SMTP id 5b1f17b1804b1-4a218c463d1so28435575e9.0
        for <linux-ext4@vger.kernel.org>; Tue, 03 Nov 2026 05:51:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793713883; x=1794318683; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=4OGFr7kDHZY+j8TMyBgS5H6nx5zjbqSGG4iF4apesuk=;
        b=oQg6b8kqqZtmw54xTLuvNsvogpAN5B4RAYtCMz+ItdVAqSy6Y2Hn8efJ1bCijCgkOe
         9idF4Y5Lw9f15FiotY8uqoDCrA4RSH0jbtAH7eQ+mbUo8iQpTB40oSLVoq7L6wuBj07j
         EKuKy/4O0ukO/9U/jiY5q+fU9k45eKCTeYNCBD43nXsttEMLwC+mpNAyhFDlA983mJda
         De6S3bHZzFSJsfsSEGYQLCok6bMZnULpvoaj3kiWhrJPQhf47ADCukyM+FsxtNJ6mXEA
         oLOdWMtREqb13VmzpAgkEsrqKuBcAaycBFMpdBkjT9uMIyEWmywdY/Ap7zaFOB7FEgZn
         EfVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793713883; x=1794318683;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=4OGFr7kDHZY+j8TMyBgS5H6nx5zjbqSGG4iF4apesuk=;
        b=Ky3MLQ9EyBaKTufe8vDdDD8mjVmV97pPEK/SSKYPlzMgOm3JG9woIqyJhiCKBBxmQP
         ZgngH8lseL4sVBCOvR3Zotu0EongPniuRpor8G8ktlagiQfxL2u2l4OKGqGssh93eI9K
         1Hwb/3bPKc42LUYtz4sDF1dR8cWchp5qUSh141J89Y6rllvhIa5izaqqInpgxNF4Pri9
         u2USiYgksX2GI2GbAGJQmeGq/xXl0/2M8yzzW982541POzITKUcu2lJP/F5KUn1nTvff
         YpwFFRQKfK5jDCrGlr9Nvi5vdMUuQcCEfA0RKaU+6R5FKgg/oSgjnBjpumisuwOsMh/n
         3WNA==
X-Gm-Message-State: APuU4Z/DX7I9ThwnjIfaFpTJbpC2q/tVVriJRk8jMCKzUqH1kbUvYzMx
	HoEmQcCSlg46LWOTF4/E/hBsy9qe1ucpxFw0gVrI/Wtg2ga7SUtrW/PK
X-Gm-Gg: AYBFou1GyLQK809g49As2ycXI2SXoUVLoegTisO4OlskCLCYNguwJp2p5qOXXdGlp4B
	o0ZVdVUzVrqHd/GbOT1DQS1jmA9rlO+nTGwVNKmkewTEci4VrNv8NehxsvRNya6L1lWmG5MZye0
	qni9TUjp4oj3xfPSeI/Gt5sNb1Ybq2t0kWMsl7U2y0Wd2oQv6LilVlAgLGIuISQc2AHyoxKRVgM
	/EKKgmbwZ+upFuZ152Ri767lC18tpcePYGsG6ZzsvStHGyD/RxtrYFsyjq4h79u1O+pKYNfRNsD
	6IqfmyWadEPEebIZA4Alyf+E9ReZyGMFfiGTmNaYuFOa5DqgXnoezgYNOo1kbBbWZUuqfQIfspJ
	nCoHSrgCuoJTlAqb9zqJysku5IgaL03Lwxnu4Bp4LZtFHvnZSpJnCsJATXFHyTqDDTlaAJdzx/U
	zBqjCDn6B4AtYaS81jgsEIofqMzZcEJJOAayjHAFDk+uMfVd3OsHBLkFgWT1HoeSOjdDAR4af1x
	CY0wun3B9oYRDSFaUUHVrfWnKtkgvs8fMbPgsziMyaP4azE9BeIV3nb2AjWJ1jGSZX6GQ7zX1nH
	rx2N+XZ9l/spsD2g9eZlFJRcGdw7csHUzmNG+vKTZiSaiBgBL8sTuIxaIEDRqwQwOsvj/EpVJyL
	tqjaePQ==
X-Received: by 2002:a05:600c:818e:b0:49f:fd40:80fa with SMTP id 5b1f17b1804b1-4ac1932aa2amr294259235e9.34.1793713882868;
        Tue, 03 Nov 2026 05:51:22 -0800 (PST)
Received: from Cluster2.powerhub ([2a0a:ef40:18b5:9e01:225:90ff:fefc:9ffe])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4b2a96fc87fsm55320335e9.12.2026.11.03.05.51.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Nov 2026 05:51:22 -0800 (PST)
From: Artem Blagodarenko <artem.blagodarenko@gmail.com>
X-Google-Original-From: Artem Blagodarenko <ablagodarenko@thelustrecollective.com>
To: fstests@vger.kernel.org
Cc: linux-ext4@vger.kernel.org,
	adilger.kernel@dilger.ca,
	ablagodarenko@thelustrecollective.com,
	Artem Blagodarenko <artem.blagodarenko@gmail.com>
Subject: [RFC PATCH v6 8/8] ext4/069: test LUFID in inline_data directory entries
Date: Tue,  3 Nov 2026 13:51:04 +0000
Message-ID: <20261103135106.610169-9-ablagodarenko@thelustrecollective.com>
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

