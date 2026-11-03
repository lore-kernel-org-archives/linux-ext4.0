Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.45
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793713880;
	b=Zloh9EfIbjPxX4CQII8pVHGnSoyoALvAmqNenP+XBPL26ErtAKzFsGMZhPn2bVX6l4tB
	 X3kZPPSqUp4LL2/hwbJgU3xx0KrD+xuznAB4tvNFUaEgREF3dnH/NFWqki5S3Vrc5gQbF
	 h3gC/ZnSff6xkLpalUSiDQO8kSp83E6cemcHnETPTeovhPrxGhbfZQzsIMq5IIxZwmI3A
	 BYEpDWmJFNaBiElmBxxtqgMEBS4FKfOx5zL+Q1Wh0SqMCkqaqABi1j39kCoZq+629AK/I
	 mk7w/HQQcqezdtDjVfqssjtzYomG80BHppF39D5/JgWw3vOOKgGxgqB2qQGUDq84B0Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793713880;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:
	 X-Google-Original-From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=UcfbjUbt3TsKg3vyIYDkse8xWvJAfIv3IG9VfRSpZwI=;
	b=HesN2VLqU2CDLiJh2uwsntmAQ21G500M+cuoSCv9N9suNT3OYEzB6ccjQiYAj2Au97vf
	 w6G6WNxiXpnvSP25DWhqaSlU1YJezMLXRQ3D6LLigLDTyh4/BxhQ8mcLvtxKD/ueThmZA
	 hLFR8aXWm9+OIfcg69Q+iE4s/9llRbr67WCQ/B9l9YB8c7K3QQr29nPPzT0q0og3xI5oB
	 /Zu0nxiIOd2V9H+nXBLNElZcvlpx3Bgl7w1cOY1mwfkwtrHAk+lCpCKDbAWyKbCebItKs
	 eOhM47aXVDNyG0pJEYGN6f9+LAgQd75i94bEV10dxMdNc7f1tK7SOx1Vh2udT7+zxHA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=vsBfM1S3;
	arc=none smtp.remote-ip=209.85.128.45
Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com [209.85.128.45])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95AD46085081
	for <linux-ext4@vger.kernel.org>; Tue,  3 Nov 2026 13:51:19 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 95AD46085081
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=vsBfM1S3
Received: by mail-wm1-f45.google.com with SMTP id 5b1f17b1804b1-4a2069b9710so35770915e9.2
        for <linux-ext4@vger.kernel.org>; Tue, 03 Nov 2026 05:51:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793713878; x=1794318678; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=UcfbjUbt3TsKg3vyIYDkse8xWvJAfIv3IG9VfRSpZwI=;
        b=vsBfM1S3yNF30z7HLATpJAu6biyES7KB4ZqxjZzptKkej3JDZNki8DeG6cnzVcvhF3
         4ATpDVg2mmFl3IXvRH/6w7oTVYdfnaU6qyYV7jw16s9EOsaeDpxLi8eVEjUDUiw8Xbe6
         6GoJNBpwMippVuios5zyv4VMLQOZVcATpsfUqJ15muS+mvz0VsFzQVAFb02iXVfM8QoV
         s0GQ8ZhGODq8IxN4D2aTLPn5RfaqcJxlR+W4Cx4UGLxby8MREU9JS10QWI3nhFQQCzOh
         Rl6h3TR4/SGHVvr5XwoqWBEopH9GwA6P5aw5+PC02fht3PctrhpaLtX/h+h8VIroG3HB
         FIrQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793713878; x=1794318678;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=UcfbjUbt3TsKg3vyIYDkse8xWvJAfIv3IG9VfRSpZwI=;
        b=YM8YtxCc+T5dkzX5Q2Uy+OwCta+eeZuNhKW+arYbVK13huvSWQT6rV/SjPyz/oyocz
         bMtixljed+Q7OMg6cirbeMDTEKwDhJhDgbF9PKMf6z3dFMyEEbLg8f5tnegr+T9J7JFC
         sa7vRL3fva0jaN4KSQunQVBBC4pJZy5FZLsLFkydC0tOxeZt7LQ7BBViQ62n6KAm/16u
         MMP4u9MI0S8MkqSjANw7X4SBLl9sV3kC149Nr7Cnc7Dwzx622Oy6Jy5jpLhlMBxVt0ye
         6ZpAl4Vq5/5OLV7GSyjHgbCgGKKCq1tHhStOZPP4ZlADHFiak2q1Vu343fKiYtQIxfLV
         DLYw==
X-Gm-Message-State: APuU4Z8N3sKZVJf1r3BwN5N4hl43BddhYgzNSsRtvWTTh8jHEXDGJnt5
	YW/Ud4EkIUXVDUwavZEvka5BGruBaGCzau7hzD2ob00rKIOQKkXhTHbp
X-Gm-Gg: AYBFou2AnHjDOx110tNHJdckWY+F+3q5AAqjwaH3TcHWyPHG6cl1gVh3O5Yj5Qxj0uy
	N96TZH9q5eE27jVnR3jr22GqD437nRwog9tLURPQ7AbI5zZ4+rOBF50Inwusxso6MffJ30jtwk1
	93N/Y3+EV47JQxxtQ6iOgYVje7uh5y4G7OUzFp5wTMaPd9sb8Acca9gp20GZJmUMcdzQXXEEiT0
	RgiLOPCBz0a3b3uM4jMeGw7drUVnhWH95lEMSGvUVpQHF5G3vB5AAf9u2s3V/hqb9b0chS+/TSz
	3o/8Y+ZK4lb4D7oMLj8ZX4aydopd9LbD0ymMJg/cgEB7O4EUJ9NHITJhwHWViItRCn96SrU+ZFd
	1RhZ3rQImk6SdAY5n90o2VaOb42QkMGv3IJ88XmuzYfAjMzgVgCk6882PBBIt1qWHssdRHcojO0
	XCZ6TEXL2yf9EXh0XK43TJu7IHf03lA+Q+r/++txVXMOyIVRwII15d10TjiDYcYxAjn3Jw6vMJr
	oCzXIQyF8P+dc9OlryUsanQePUpvM1hx3jk/1S/xmbDlmskAQ9Pt0OACTTvvYIMYqw4fzD6T8Dx
	EV1l4ilViFNqhdHPTpNKMorVN5YJ/kBbWki+SAZ2WxuZNPxZ5XMfOuvhvGC5
X-Received: by 2002:a05:600c:3556:b0:4a7:6bc7:f778 with SMTP id 5b1f17b1804b1-4ac1932a355mr283051635e9.30.1793713877899;
        Tue, 03 Nov 2026 05:51:17 -0800 (PST)
Received: from Cluster2.powerhub ([2a0a:ef40:18b5:9e01:225:90ff:fefc:9ffe])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4b2a96fc87fsm55320335e9.12.2026.11.03.05.51.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Nov 2026 05:51:17 -0800 (PST)
From: Artem Blagodarenko <artem.blagodarenko@gmail.com>
X-Google-Original-From: Artem Blagodarenko <ablagodarenko@thelustrecollective.com>
To: fstests@vger.kernel.org
Cc: linux-ext4@vger.kernel.org,
	adilger.kernel@dilger.ca,
	ablagodarenko@thelustrecollective.com,
	Artem Blagodarenko <artem.blagodarenko@gmail.com>
Subject: [RFC PATCH v6 3/8] ext4/065 encryption + casefold + dirdata feature combination
Date: Tue,  3 Nov 2026 13:50:59 +0000
Message-ID: <20261103135106.610169-4-ablagodarenko@thelustrecollective.com>
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

Test ext4 encryption + casefold + dirdata feature combination.
This test verifies that files created in directories with encryption,
case-insensitive (casefold), and dirdata attributes work correctly.
See ext4/064 for the same test WITHOUT dirdata feature.

Signed-off-by: Artem Blagodarenko <artem.blagodarenko@gmail.com>
---
 tests/ext4/065     | 252 +++++++++++++++++++++++++++++++++++++++++++++
 tests/ext4/065.out |  26 +++++
 2 files changed, 278 insertions(+)
 create mode 100755 tests/ext4/065
 create mode 100644 tests/ext4/065.out

diff --git a/tests/ext4/065 b/tests/ext4/065
new file mode 100755
index 00000000..b86d3146
--- /dev/null
+++ b/tests/ext4/065
@@ -0,0 +1,252 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (c) 2026 The Lustre Collective.  All Rights Reserved.
+# Author: Artem Blagodarenko <ablagodarenko@thelustrecollective.com>
+#
+# FS QA Test ext4/065
+#
+# Test ext4 encryption + casefold + dirdata feature combination.
+# This test verifies that files created in directories with encryption,
+# case-insensitive (casefold), and dirdata attributes work correctly.
+# See ext4/064 for the same test WITHOUT dirdata feature.
+#
+. ./common/preamble
+_begin_fstest auto quick encrypt casefold
+
+# get standard environment and checks
+. ./common/filter
+. ./common/encrypt
+. ./common/casefold
+. ./common/attr
+. ./common/ext4
+
+_exclude_fs ext2
+_exclude_fs ext3
+
+# Check if dirdata feature is supported and can be used with encrypt+casefold
+_require_scratch_dirdata()
+{
+	if test ! -f /sys/fs/ext4/features/dirdata ; then
+		_notrun "dirdata feature not supported by kernel"
+	fi
+
+	# Debug: log e2fsprogs tool paths and versions
+	echo "=== _require_scratch_dirdata debug info ===" >> $seqres.full
+	echo "E2FSCK_PROG: $E2FSCK_PROG" >> $seqres.full
+	echo "E2FSCK_PROG resolved: $(type -P e2fsck)" >> $seqres.full
+	echo "MKFS_EXT4_PROG: $MKFS_EXT4_PROG" >> $seqres.full
+	echo "fsck -t ext4 resolves to: $(type -P fsck.ext4)" >> $seqres.full
+	$E2FSCK_PROG -V >> $seqres.full 2>&1
+	$MKFS_EXT4_PROG -V >> $seqres.full 2>&1
+	echo "=== end debug info ===" >> $seqres.full
+
+	# Also verify that mkfs supports dirdata
+	if ! $MKFS_EXT4_PROG -O dirdata -n $SCRATCH_DEV &>>$seqres.full ; then
+		_notrun "mkfs.ext4 does not support dirdata feature"
+	fi
+
+	# Verify kernel can mount filesystem with encrypt+casefold+dirdata
+	echo "Running: _scratch_mkfs -O encrypt,casefold,dirdata" >> $seqres.full
+	if ! _scratch_mkfs -O encrypt,casefold,dirdata &>>$seqres.full ; then
+		_notrun "failed to create filesystem with encrypt+casefold+dirdata"
+	fi
+	if ! _try_scratch_mount &>>$seqres.full ; then
+		_notrun "kernel cannot mount filesystem with encrypt+casefold+dirdata"
+	fi
+	_scratch_unmount
+}
+
+_require_scratch_nocheck
+_require_scratch_encryption
+_require_scratch_casefold
+_require_scratch_dirdata
+_require_xfs_io_command "set_encpolicy"
+_require_xfs_io_command "add_enckey"
+
+# Helper to add a v2 encryption key and set policy on a directory
+_setup_encrypted_casefold_dir()
+{
+	local dir=$1
+	local raw_key=$(_generate_raw_encryption_key)
+	local keyspec=$(_add_enckey $SCRATCH_MNT "$raw_key" | awk '{print $NF}')
+	_set_encpolicy $dir $keyspec
+	_casefold_set_attr $dir
+	echo $keyspec
+}
+
+# Create a filesystem with encrypt, casefold, and dirdata features
+# Debug: log e2fsprogs tool paths and versions
+echo "=== e2fsprogs debug info ===" >> $seqres.full
+echo "E2FSCK_PROG: $E2FSCK_PROG" >> $seqres.full
+echo "E2FSCK_PROG resolved: $(type -P e2fsck)" >> $seqres.full
+echo "MKFS_EXT4_PROG: $MKFS_EXT4_PROG" >> $seqres.full
+echo "FSCK_OPTIONS: $FSCK_OPTIONS" >> $seqres.full
+echo "fsck -t ext4 resolves to: $(type -P fsck.ext4)" >> $seqres.full
+$E2FSCK_PROG -V >> $seqres.full 2>&1
+$MKFS_EXT4_PROG -V >> $seqres.full 2>&1
+echo "=== end e2fsprogs debug info ===" >> $seqres.full
+
+_scratch_mkfs -O encrypt,casefold,dirdata &>>$seqres.full
+_scratch_mount
+
+# Test 1: Create an encrypted + casefolded directory and verify lookups work
+echo "Test 1: Basic encrypted casefold lookup with dirdata"
+mkdir $SCRATCH_MNT/test1
+_setup_encrypted_casefold_dir $SCRATCH_MNT/test1 > /dev/null
+
+# Create file with lowercase, lookup with uppercase
+echo "hello" > $SCRATCH_MNT/test1/testfile.txt
+if [ -f "$SCRATCH_MNT/test1/TESTFILE.TXT" ]; then
+	echo "Case-insensitive lookup works in encrypted dir"
+else
+	echo "FAIL: Case-insensitive lookup failed in encrypted dir"
+fi
+
+# Verify the exact name on disk is preserved
+if _casefold_check_exact_name "$SCRATCH_MNT/test1" "testfile.txt"; then
+	echo "Original filename preserved"
+else
+	echo "FAIL: Original filename not preserved"
+fi
+if ! _dump_dir_structure $SCRATCH_MNT/test1; then
+	_scratch_unmount
+	_check_scratch_fs
+	status=1
+	exit
+fi
+
+# Test 2: Create files with different case variations
+echo "Test 2: Conflicting names in encrypted casefold dir"
+mkdir $SCRATCH_MNT/test2
+_setup_encrypted_casefold_dir $SCRATCH_MNT/test2 > /dev/null
+
+echo "first" > $SCRATCH_MNT/test2/MyFile.txt
+# This should fail or overwrite since "MYFILE.TXT" is equivalent
+echo "second" > $SCRATCH_MNT/test2/MYFILE.TXT 2>/dev/null
+content=$(cat $SCRATCH_MNT/test2/myfile.txt)
+echo "Content after writes: $content"
+if ! _dump_dir_structure $SCRATCH_MNT/test2; then
+	_scratch_unmount
+	_check_scratch_fs
+	status=1
+	exit
+fi
+
+# Test 3: Unicode normalization in encrypted casefold dir
+echo "Test 3: Unicode in encrypted casefold dir"
+mkdir $SCRATCH_MNT/test3
+_setup_encrypted_casefold_dir $SCRATCH_MNT/test3 > /dev/null
+
+# Test with UTF-8 characters
+fr_file1=$(echo -e "cafe\xcc\x81.txt")
+fr_file2=$(echo -e "caf\xc3\xa9.txt")
+echo "french" > "$SCRATCH_MNT/test3/$fr_file1"
+if [ -f "$SCRATCH_MNT/test3/$fr_file2" ]; then
+	echo "Unicode normalization works in encrypted dir"
+else
+	echo "FAIL: Unicode normalization failed in encrypted dir"
+fi
+if ! _dump_dir_structure $SCRATCH_MNT/test3; then
+	_scratch_unmount
+	_check_scratch_fs
+	status=1
+	exit
+fi
+
+# Test 4: Directory operations in encrypted casefold dir
+echo "Test 4: Directory operations in encrypted casefold dir"
+mkdir $SCRATCH_MNT/test4
+_setup_encrypted_casefold_dir $SCRATCH_MNT/test4 > /dev/null
+
+mkdir $SCRATCH_MNT/test4/SubDir
+if [ -d "$SCRATCH_MNT/test4/SUBDIR" ]; then
+	echo "Directory case-insensitive lookup works"
+else
+	echo "FAIL: Directory case-insensitive lookup failed"
+fi
+if ! _dump_dir_structure $SCRATCH_MNT/test4; then
+	_scratch_unmount
+	_check_scratch_fs
+	status=1
+	exit
+fi
+
+# Test 5: Verify inheritance of casefold+encryption in subdirectories
+echo "Test 5: Inheritance of attributes"
+mkdir $SCRATCH_MNT/test5
+_setup_encrypted_casefold_dir $SCRATCH_MNT/test5 > /dev/null
+
+mkdir $SCRATCH_MNT/test5/child
+echo "data" > $SCRATCH_MNT/test5/child/file.txt
+if [ -f "$SCRATCH_MNT/test5/CHILD/FILE.TXT" ]; then
+	echo "Attributes inherited correctly"
+else
+	echo "FAIL: Attributes not inherited"
+fi
+if ! _dump_dir_structure $SCRATCH_MNT/test5; then
+	_scratch_unmount
+	_check_scratch_fs
+	status=1
+	exit
+fi
+
+# Test 6: Remove and recreate with different case
+echo "Test 6: Remove and recreate with different case"
+mkdir $SCRATCH_MNT/test6
+_setup_encrypted_casefold_dir $SCRATCH_MNT/test6 > /dev/null
+
+echo "original" > $SCRATCH_MNT/test6/RemoveMe.txt
+rm $SCRATCH_MNT/test6/REMOVEME.TXT
+echo "recreated" > $SCRATCH_MNT/test6/REMOVEME.TXT
+if _casefold_check_exact_name "$SCRATCH_MNT/test6" "REMOVEME.TXT"; then
+	echo "Recreated file has new case"
+else
+	echo "FAIL: Recreated file case incorrect"
+fi
+if ! _dump_dir_structure $SCRATCH_MNT/test6; then
+	_scratch_unmount
+	_check_scratch_fs
+	status=1
+	exit
+fi
+
+# Test 7: Hard links in encrypted casefold dir
+echo "Test 7: Hard links in encrypted casefold dir"
+mkdir $SCRATCH_MNT/test7
+_setup_encrypted_casefold_dir $SCRATCH_MNT/test7 > /dev/null
+
+echo "linkdata" > $SCRATCH_MNT/test7/original.txt
+ln $SCRATCH_MNT/test7/original.txt $SCRATCH_MNT/test7/hardlink.txt
+if [ -f "$SCRATCH_MNT/test7/HARDLINK.TXT" ]; then
+	echo "Hard link case-insensitive lookup works"
+else
+	echo "FAIL: Hard link case-insensitive lookup failed"
+fi
+if ! _dump_dir_structure $SCRATCH_MNT/test7; then
+	_scratch_unmount
+	_check_scratch_fs
+	status=1
+	exit
+fi
+
+# Cleanup and verify filesystem
+_scratch_unmount
+
+# Dirdata analysis summary
+echo ""
+echo "Dirdata analysis:"
+echo "=== e2fsprogs debug info (before _check_scratch_fs) ===" >> $seqres.full
+echo "E2FSCK_PROG: $E2FSCK_PROG" >> $seqres.full
+echo "E2FSCK_PROG resolved: $(type -P e2fsck)" >> $seqres.full
+echo "fsck -t ext4 resolves to: $(type -P fsck.ext4)" >> $seqres.full
+echo "FSCK_OPTIONS: $FSCK_OPTIONS" >> $seqres.full
+$E2FSCK_PROG -V >> $seqres.full 2>&1
+echo "=== end e2fsprogs debug info ===" >> $seqres.full
+
+_check_scratch_fs
+
+echo "Encrypted casefold tests with dirdata completed"
+
+# success, all done
+status=0
+exit
diff --git a/tests/ext4/065.out b/tests/ext4/065.out
new file mode 100644
index 00000000..c1316430
--- /dev/null
+++ b/tests/ext4/065.out
@@ -0,0 +1,26 @@
+QA output created by 065
+Test 1: Basic encrypted casefold lookup with dirdata
+Case-insensitive lookup works in encrypted dir
+Original filename preserved
+  Directory structure of test1: OK (dirdata verified)
+Test 2: Conflicting names in encrypted casefold dir
+Content after writes: second
+  Directory structure of test2: OK (dirdata verified)
+Test 3: Unicode in encrypted casefold dir
+Unicode normalization works in encrypted dir
+  Directory structure of test3: OK (dirdata verified)
+Test 4: Directory operations in encrypted casefold dir
+Directory case-insensitive lookup works
+  Directory structure of test4: OK (dirdata verified)
+Test 5: Inheritance of attributes
+Attributes inherited correctly
+  Directory structure of test5: OK (dirdata verified)
+Test 6: Remove and recreate with different case
+Recreated file has new case
+  Directory structure of test6: OK (dirdata verified)
+Test 7: Hard links in encrypted casefold dir
+Hard link case-insensitive lookup works
+  Directory structure of test7: OK (dirdata verified)
+
+Dirdata analysis:
+Encrypted casefold tests with dirdata completed
-- 
2.52.0

