Received: from mail-wr1-f41.google.com (mail-wr1-f41.google.com [209.85.221.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B76F33E5EFF
	for <linux-ext4@vger.kernel.org>; Mon, 27 Jul 2026 21:14:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785186854; cv=none; b=MH36RU3cw7REpBvSFv8ORC4K5p7N5Llp7E7f4/5LMKlBM+HWQnSnmjtj+beGO6nVg3BkDzWKvP6AO/nWpdR8gdolFGOTQHls643Bczo+Co8AdW8CgtWe2F8Byvuv+hC6z+9LdL03m7YHzJ9t/MKAZZxhOdikHlz6MMlPK+4AD+4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785186854; c=relaxed/simple;
	bh=PWiDWTLOg0ZDr6hEbZ//Bry7LXO5Ro9O1QYZOJcdOS4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ckCf7IwuStH5DoE+qCb8KirvEwgCCO4FZZGTMjq76FE98aJBczDJy1K/gn8QorQvXYE3ROy1CAqdk0kNsi8Qf15gPopKApG+TCHM0wbBqylFrzUt9p1GNJkfIhaiIwnqY4EgbVf+4p9DslTX0rPXan2Be/vCYSjePfaonsUiniE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=WnnUjbDB; arc=none smtp.client-ip=209.85.221.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="WnnUjbDB"
Received: by mail-wr1-f41.google.com with SMTP id ffacd0b85a97d-4720f3bf164so174239f8f.1
        for <linux-ext4@vger.kernel.org>; Mon, 27 Jul 2026 14:14:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785186851; x=1785791651; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=LhYF6OPzgqjOGbw+aWFcd96c8GRn+UKgaedw+zmeS7s=;
        b=WnnUjbDBpOF9RLq0Bib5NMm/6Aw1lmC7VWJgAkawowTd1nRGuMfXxr9DSey+R3Agze
         0k7uHNLVQrsFBKm6cP5wHP8Hid9o/XPLYovd2zYm2BH6B6lNrGm9ByxQCW42uunOHzsA
         ZSBJCG/6HKGCPA+BhV0mQVc8VrVslvLbOq9agbvgH3Da9L/DzO0jMsj+6wYcvE93JAKQ
         4te1QHoc7vsXt0r9FCQwZCc8CJuCuoIMxHUmntT5p0i0lhLRVOJ85wQM00WlpVQ0OHg/
         08QD31ysXgMqJ6G2wQuFVkBa/hcdoXOMxMCnBX5Pf9qLJ2Z7ZBlrubSx60WDD5B6ehMV
         2UPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785186851; x=1785791651;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=LhYF6OPzgqjOGbw+aWFcd96c8GRn+UKgaedw+zmeS7s=;
        b=CPDpbutQ7G+tEe5YyfQTAWRHR4zj4LI2YXTCsXFddewwVq7T7XrNAVvEuzfSqg/BPR
         TxorAbXu0WzZ+4/ndK57/lKSpS3H1OtE5DC4OsFbllmWz6YrK4Fzwa6UR2w5b2l+ccy3
         Rbbhwk5t3DC1dDZSta4XBm798imEF1sj3OFFnV/lb7sUYRdevBvh1Xqg3SHZO9oq3O0P
         RUfek0ixI+0VyNoZYgQF/Guob8GTwkUKYHqP/LW/bxlrEmzGv2oDy986Gk1AzroGmFPL
         ppsFInUwnsLFCELqRAB6HKMw/hKxQbVcq2omqzsttlkal5WDIMccy6CeM4FpQfMwcuBP
         i+6A==
X-Gm-Message-State: AOJu0Yw3veGAX3Ckeqm0KpSd44KNINFp5rEy9XPFsTxOaH1NUIaQsoY+
	CXQ1PvnYqcCgMuriqYWrmTF/bHwl1YuOXsV19WvaZJIEFJRfN7cOgI1ry0iL1uWo
X-Gm-Gg: AR+sD13GUcAGIOsg0MbHVzGpx9L7qajgWYqAhNjaJ3No5BVpeILTOW+nH5eVNWN1nYO
	XzR4cGq5GocDtzta1b7GwTwN5Ob9VTnaE9XaHmeaciwqApouqYSyNt6UFIvHHUd1iNtthWAchxS
	VOWTfCyXPJ3FvPb1FogGZZrQnop30AjWcQpyANTebQX4dyDeNercUfxhW8SPxZemralWFZv0cMy
	YJmQJdRWgxxhZ6f/fBTfZJVgN7A58d6LI5ycQntKY6O4mXpzCIzeLtVT+2u8dUWP2hbiT1bY4Wx
	AlpUXbVI/DdR68GEuIYWRaOyQ/0oFGdNgbiR9Yi2EKNYqaBNM5GsChZe0R1FsQCo2WUzVS/ZUdX
	GnUttQ5tRMGBXlMPhslDi/+Yh0FzI5L1heU8QWDhHWmAA++jFo547cK8jSfFJNYdA6BQWF3snup
	yyqoT95Aqg5OeD/Eov5pHq0AMdKfkOUgh3gA==
X-Received: by 2002:a05:6000:2887:b0:47f:8a21:b760 with SMTP id ffacd0b85a97d-47fb0324a81mr408988f8f.4.1785186851042;
        Mon, 27 Jul 2026 14:14:11 -0700 (PDT)
Received: from Cluster1.powerhub ([2a0a:ef40:18b5:9e01:f5de:1ef8:371:ee89])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-47f85c67339sm54987049f8f.31.2026.07.27.14.14.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Jul 2026 14:14:10 -0700 (PDT)
From: Artem Blagodarenko <artem.blagodarenko@gmail.com>
X-Google-Original-From: Artem Blagodarenko <ablagodarenko@thelustrecollective.com>
To: linux-ext4@vger.kernel.org
Cc: adilger.kernel@dilger.ca,
	Artem Blagodarenko <ablagodarenko@thelustrecollective.com>,
	Artem Blagodarenko <artem.blagodarenko@gmail.com>
Subject: [RFC PATCH v4 7/8] ext4/068: test LUFID is carried through overwrite rename and RENAME_EXCHANGE
Date: Mon, 27 Jul 2026 17:13:45 -0400
Message-ID: <20260727211353.19736-14-ablagodarenko@thelustrecollective.com>
X-Mailer: git-send-email 2.43.7
In-Reply-To: <20260727211353.19736-1-ablagodarenko@thelustrecollective.com>
References: <20260727211353.19736-1-ablagodarenko@thelustrecollective.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Two-part test for the fix in ext4_setent() that copies LUFID dirdata
payload through rename:

Test 1 (overwrite rename): create two files in a dirdata directory, set
distinct 16-byte LUFIDs on each via EXT4_IOC_SET_LUFID, then rename the
source file over the destination.  After rename the destination slot must
carry the source inode's LUFID, not the stale LUFID of the replaced inode.

Test 2 (RENAME_EXCHANGE): same setup with two files, then swap them with
renameat2 -x.  After the exchange each slot must carry the LUFID of the
inode that moved into it.

Uses all-same-byte LUFID payloads (0xAA.../0xBB...) so the expected FID
string is trivially known without parsing inode numbers.

Signed-off-by: Artem Blagodarenko <artem.blagodarenko@gmail.com>
---
 tests/ext4/068     | 202 +++++++++++++++++++++++++++++++++++++++++++++
 tests/ext4/068.out |   5 ++
 2 files changed, 207 insertions(+)

diff --git a/tests/ext4/068 b/tests/ext4/068
new file mode 100755
index 00000000..650920f3
--- /dev/null
+++ b/tests/ext4/068
@@ -0,0 +1,202 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (c) 2026 The Lustre Collective. All Rights Reserved.
+# Author: Artem Blagodarenko <ablagodarenko@thelustrecollective.com>
+#
+# FS QA Test ext4/068
+#
+# Test that the LUFID dirdata extension is correctly carried through rename.
+#
+# When a file with a LUFID is renamed over another file that also has a LUFID
+# (overwrite rename), the destination directory entry must end up with the
+# source inode's LUFID, not the stale LUFID of the destination inode that was
+# replaced.
+#
+# Also tests RENAME_EXCHANGE (cross-rename): each file's LUFID must follow its
+# inode to the new slot.
+
+. ./common/preamble
+_begin_fstest auto quick
+
+# Import common functions
+. ./common/filter
+. ./common/ext4
+. ./common/renameat2
+
+_exclude_fs ext2
+_exclude_fs ext3
+
+_require_scratch_nocheck
+_require_command "$SET_LUFID_PROG"
+_require_renameat2 exchange
+
+# Check if dirdata feature is supported (required for LUFID IOCTL)
+_require_scratch_dirdata()
+{
+	if test ! -f /sys/fs/ext4/features/dirdata ; then
+		_notrun "dirdata feature not supported by kernel (required for LUFID)"
+	fi
+
+	if ! $MKFS_EXT4_PROG -O dirdata -n $SCRATCH_DEV &>>$seqres.full ; then
+		_notrun "mkfs.ext4 does not support dirdata feature"
+	fi
+
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
+# _get_entry_fid DIR ENTRYNAME
+#
+# Print the fid= value for the named entry inside DIR, as shown by
+# "debugfs ls -lD".  DIR must be a path relative to the filesystem root
+# (e.g. "rename_test/subdir").  Returns 1 if the entry or its fid is not found.
+_get_entry_fid()
+{
+	local dir=$1
+	local entry=$2
+	local dir_name
+
+	# debugfs cd takes a path; basename handles nested dirs
+	dir_name=$(basename "$dir")
+
+	# Flush dirty filesystem buffers before reading the raw device via debugfs.
+	sync
+	echo 3 > /proc/sys/vm/drop_caches
+
+	local fid
+	fid=$({
+		echo "cd $dir_name"
+		echo "ls -lD ."
+		echo "quit"
+	} | debugfs $SCRATCH_DEV 2>/dev/null | \
+		grep -E " ${entry}$" | grep -o "fid=[^ ]*" | sed 's/^fid=//')
+
+	if [ -z "$fid" ]; then
+		return 1
+	fi
+	echo "$fid"
+}
+
+# Create a filesystem with the dirdata feature
+_scratch_mkfs -O dirdata &>>$seqres.full
+_scratch_mount
+
+# -----------------------------------------------------------------------
+# Test 1: overwrite rename — LUFID follows the source inode
+# -----------------------------------------------------------------------
+echo "Test 1: overwrite rename copies LUFID from source to destination slot"
+
+mkdir -p $SCRATCH_MNT/rename_test
+
+echo "src" > $SCRATCH_MNT/rename_test/src_file
+echo "dst" > $SCRATCH_MNT/rename_test/dst_file
+
+# Use three 16-byte FIDs per entry to verify multi-FID LUFID handling.
+# src carries FIDs 0xAA×16, 0xCC×16, 0xEE×16 (48 bytes total payload).
+# dst carries FIDs 0xBB×16, 0xDD×16, 0x11×16 (48 bytes total payload).
+src_lufid=$'\xaa\xaa\xaa\xaa\xaa\xaa\xaa\xaa\xaa\xaa\xaa\xaa\xaa\xaa\xaa\xaa\xcc\xcc\xcc\xcc\xcc\xcc\xcc\xcc\xcc\xcc\xcc\xcc\xcc\xcc\xcc\xcc\xee\xee\xee\xee\xee\xee\xee\xee\xee\xee\xee\xee\xee\xee\xee\xee'
+dst_lufid=$'\xbb\xbb\xbb\xbb\xbb\xbb\xbb\xbb\xbb\xbb\xbb\xbb\xbb\xbb\xbb\xbb\xdd\xdd\xdd\xdd\xdd\xdd\xdd\xdd\xdd\xdd\xdd\xdd\xdd\xdd\xdd\xdd\x11\x11\x11\x11\x11\x11\x11\x11\x11\x11\x11\x11\x11\x11\x11\x11'
+src_fid_expected='[0xaaaaaaaaaaaaaaaa:0xaaaaaaaa:0xaaaaaaaa],[0xcccccccccccccccc:0xcccccccc:0xcccccccc],[0xeeeeeeeeeeeeeeee:0xeeeeeeee:0xeeeeeeee]'
+dst_fid_expected='[0xbbbbbbbbbbbbbbbb:0xbbbbbbbb:0xbbbbbbbb],[0xdddddddddddddddd:0xdddddddd:0xdddddddd],[0x1111111111111111:0x11111111:0x11111111]'
+
+set_lufid $SCRATCH_MNT/rename_test src_file "$src_lufid" >>$seqres.full 2>&1 || \
+	{ echo "FAIL: could not set LUFID on src_file"; status=1; exit; }
+
+set_lufid $SCRATCH_MNT/rename_test dst_file "$dst_lufid" >>$seqres.full 2>&1 || \
+	{ echo "FAIL: could not set LUFID on dst_file"; status=1; exit; }
+
+# Overwrite rename: src_file → dst_file
+mv $SCRATCH_MNT/rename_test/src_file $SCRATCH_MNT/rename_test/dst_file
+
+if [ -e $SCRATCH_MNT/rename_test/src_file ]; then
+	echo "FAIL: src_file still exists after rename"
+	_scratch_unmount; _check_scratch_fs; status=1; exit
+fi
+
+# After rename the dst_file slot must carry src's LUFID
+fid=$(_get_entry_fid rename_test dst_file)
+if [ $? -ne 0 ] || [ -z "$fid" ]; then
+	echo "FAIL: no fid found for dst_file after rename"
+	_scratch_unmount; _check_scratch_fs; status=1; exit
+fi
+
+if [ "$fid" != "$src_fid_expected" ]; then
+	echo "FAIL: dst_file has wrong LUFID after overwrite rename"
+	echo "  expected: $src_fid_expected"
+	echo "  got:      $fid"
+	_scratch_unmount; _check_scratch_fs; status=1; exit
+fi
+
+echo "PASS: dst_file carries src inode's LUFID after overwrite rename"
+
+# -----------------------------------------------------------------------
+# Test 2: RENAME_EXCHANGE — each LUFID follows its inode to the new slot
+# -----------------------------------------------------------------------
+echo "Test 2: RENAME_EXCHANGE swaps LUFIDs along with inodes"
+
+mkdir -p $SCRATCH_MNT/xrename_test
+
+echo "aaa" > $SCRATCH_MNT/xrename_test/file_a
+echo "bbb" > $SCRATCH_MNT/xrename_test/file_b
+
+a_lufid=$'\xaa\xaa\xaa\xaa\xaa\xaa\xaa\xaa\xaa\xaa\xaa\xaa\xaa\xaa\xaa\xaa\xcc\xcc\xcc\xcc\xcc\xcc\xcc\xcc\xcc\xcc\xcc\xcc\xcc\xcc\xcc\xcc\xee\xee\xee\xee\xee\xee\xee\xee\xee\xee\xee\xee\xee\xee\xee\xee'
+b_lufid=$'\xbb\xbb\xbb\xbb\xbb\xbb\xbb\xbb\xbb\xbb\xbb\xbb\xbb\xbb\xbb\xbb\xdd\xdd\xdd\xdd\xdd\xdd\xdd\xdd\xdd\xdd\xdd\xdd\xdd\xdd\xdd\xdd\x11\x11\x11\x11\x11\x11\x11\x11\x11\x11\x11\x11\x11\x11\x11\x11'
+a_fid_expected='[0xaaaaaaaaaaaaaaaa:0xaaaaaaaa:0xaaaaaaaa],[0xcccccccccccccccc:0xcccccccc:0xcccccccc],[0xeeeeeeeeeeeeeeee:0xeeeeeeee:0xeeeeeeee]'
+b_fid_expected='[0xbbbbbbbbbbbbbbbb:0xbbbbbbbb:0xbbbbbbbb],[0xdddddddddddddddd:0xdddddddd:0xdddddddd],[0x1111111111111111:0x11111111:0x11111111]'
+
+set_lufid $SCRATCH_MNT/xrename_test file_a "$a_lufid" >>$seqres.full 2>&1 || \
+	{ echo "FAIL: could not set LUFID on file_a"; status=1; exit; }
+
+set_lufid $SCRATCH_MNT/xrename_test file_b "$b_lufid" >>$seqres.full 2>&1 || \
+	{ echo "FAIL: could not set LUFID on file_b"; status=1; exit; }
+
+# Cross-rename: exchange file_a and file_b
+$here/src/renameat2 -x \
+	$SCRATCH_MNT/xrename_test/file_a \
+	$SCRATCH_MNT/xrename_test/file_b >>$seqres.full 2>&1 || \
+	{ echo "FAIL: renameat2 -x failed"; status=1; exit; }
+
+# After exchange: the slot named file_a must carry b's LUFID (b's inode is now there)
+# and the slot named file_b must carry a's LUFID.
+fid_a=$(_get_entry_fid xrename_test file_a)
+if [ $? -ne 0 ] || [ -z "$fid_a" ]; then
+	echo "FAIL: no fid found for file_a after exchange"
+	_scratch_unmount; _check_scratch_fs; status=1; exit
+fi
+
+fid_b=$(_get_entry_fid xrename_test file_b)
+if [ $? -ne 0 ] || [ -z "$fid_b" ]; then
+	echo "FAIL: no fid found for file_b after exchange"
+	_scratch_unmount; _check_scratch_fs; status=1; exit
+fi
+
+if [ "$fid_a" != "$b_fid_expected" ]; then
+	echo "FAIL: file_a slot has wrong LUFID after exchange"
+	echo "  expected (b's LUFID): $b_fid_expected"
+	echo "  got:                  $fid_a"
+	_scratch_unmount; _check_scratch_fs; status=1; exit
+fi
+
+if [ "$fid_b" != "$a_fid_expected" ]; then
+	echo "FAIL: file_b slot has wrong LUFID after exchange"
+	echo "  expected (a's LUFID): $a_fid_expected"
+	echo "  got:                  $fid_b"
+	_scratch_unmount; _check_scratch_fs; status=1; exit
+fi
+
+echo "PASS: LUFIDs correctly swapped after RENAME_EXCHANGE"
+
+# Cleanup and verify filesystem
+_scratch_unmount
+_check_scratch_fs
+
+# success, all done
+status=0
+exit
diff --git a/tests/ext4/068.out b/tests/ext4/068.out
new file mode 100644
index 00000000..ceb00698
--- /dev/null
+++ b/tests/ext4/068.out
@@ -0,0 +1,5 @@
+QA output created by 068
+Test 1: overwrite rename copies LUFID from source to destination slot
+PASS: dst_file carries src inode's LUFID after overwrite rename
+Test 2: RENAME_EXCHANGE swaps LUFIDs along with inodes
+PASS: LUFIDs correctly swapped after RENAME_EXCHANGE
-- 
2.43.7

