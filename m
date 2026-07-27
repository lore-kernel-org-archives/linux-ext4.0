Received: from mail-wr1-f50.google.com (mail-wr1-f50.google.com [209.85.221.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23EF83F660E
	for <linux-ext4@vger.kernel.org>; Mon, 27 Jul 2026 21:14:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785186860; cv=none; b=EOEtXtsQjWyPGuBbFvz1Sxc7uxU2anB6oCnbKD2+v6+JTRFAf4fN5732G6zWmlI+hlbOlTf0JEABOn89T2jy8XFxzFMS7NkRYkazLBr9wC4L1r1cwivy3vbA6agNKkLxFE95FMn5TN9aDd+xvojs+kXlQsv+tkc/j77a4ojDE2I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785186860; c=relaxed/simple;
	bh=PWiDWTLOg0ZDr6hEbZ//Bry7LXO5Ro9O1QYZOJcdOS4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=N5GiUEVFsOc4tZLdOnMrjlzCy0xb5lyqCQub6VYCLvDP/7w6P6mbiXkRxBlsAfdtjd6TWfSsgzbyK3NePf9rALQLbgtxTOyXAzX2Xak+HOMYtRQxh498sqbMjTFV5BXxRfyz/eqDoARmky4nGmSu93Ku+ekDUdN1nUc8EOBrsEQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=DRKLFOE1; arc=none smtp.client-ip=209.85.221.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="DRKLFOE1"
Received: by mail-wr1-f50.google.com with SMTP id ffacd0b85a97d-47f93b2fe4cso2329009f8f.0
        for <linux-ext4@vger.kernel.org>; Mon, 27 Jul 2026 14:14:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785186856; x=1785791656; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=LhYF6OPzgqjOGbw+aWFcd96c8GRn+UKgaedw+zmeS7s=;
        b=DRKLFOE1ZveIomvLK05yZibogEhYZHSY0GZDAcrLSqk0oecTXF27W/y/4SU6L0y3BK
         f+pwBHZxeqZZp5uWRSCyKlzETvdnckVEvEae3EPMtom9SOa2gnBzFHQQbmxmMaf89VaA
         ENUGlQFyh7RJN7N6r7NCdrsGooo/aXsCP53ry3PKOaQf/Ue/cgXCIphwk9NRuiaEbh2d
         uWdr2qtjvO0aWLURrVFy4wob9XBknfz3pou9IsxexKJj7eqvWkgGoR/X4pX5hqzZNW78
         qN2JyiId1EvDrTp7hKmrNwdh7616PxiR7b4qOdj0kFATbrZ/esaEnUO8Jhvy/j2xWVn0
         tcqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785186856; x=1785791656;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=LhYF6OPzgqjOGbw+aWFcd96c8GRn+UKgaedw+zmeS7s=;
        b=No7qZAuVqxA+H9YVjg6xDeRJGTPWpOGgpJfzSUS7AmySxx0qS1RZGv0zlwCEknv0i3
         K01wLXbDp79GVW1zmurD4q9VJ3ySu4SZoQYbBjNNlnmnHJ83Lj2B7AfS+USyvLkTsBwn
         4/2etZee0nGI1DQr8BHoRHU8HepUTzXBe4QXt4rpWGtuF5WGnMfsc3PgJ+KPe5FyzVLZ
         DamgZ3/56C1dTPTifibsKzDQxMXV4DwcjYwMo6t/lbyQRtLFY3ceFl75PDi/1kyaoX2b
         GAS/66UL43cOTHZ1GsrstyQXl6URe2XO0ASwR4CyI9bkRvnUXJHIHBxKaqWSwU4KqRmv
         qMMw==
X-Gm-Message-State: AOJu0YzVizbvORgvWaqj+eI72Ifq2PzlZTZfjW7/RfccInlN7rUjd0Kr
	cMMJGXsSjMUr4tja07r34ZKVNeJj/t3vbQ/SYGBkxLD/hCNQ8ajSfgkjbhx/SitH
X-Gm-Gg: AR+sD119MiqMssPqSPVLr3v1Rf8muSYdvlFuB/fAIFnSRpk5M9j1DLN14YiXFwiNyqV
	Yd6kHEf7vpbXzYFMrwcz3A4LG1U0DGrUQP4A3KXZvyJ6u5wKSPI1Xh9BAp4LZkHu24ssG7Uhkuf
	zOjPuFa1lKEZ3kAvdxzL+t7yoXXVlREfTOEIISxewqgA7Xj8vHdd5YB5AYLIRFSDTJ8RBDAczuz
	O9AoGMGqR0nZoW/oEimR0Z0DuhmA0df89VztcDVwl9E1lTDybf/VjLi7nDuTBa9cSPHxL/sou/x
	Ganr7iVpR8waylUDAxqFVQMpQW5ynpWP3UUqtmwp+nlpjhEbcO1CBV3d5i6DTUCQoHsgyY1Zp5z
	dIx/7rLkWIgs+/WxgxWUvvaJTIyWMHUBI9ooK4XlwwX7HAww8ydyWDCmkk4J8iZpTilEgShT+7v
	74tvDx/FBT1sePevAphZBw/5sdoUb+yjRGtg==
X-Received: by 2002:a05:6000:2889:b0:47f:8112:f793 with SMTP id ffacd0b85a97d-47f9fc8ee6fmr13436352f8f.13.1785186856355;
        Mon, 27 Jul 2026 14:14:16 -0700 (PDT)
Received: from Cluster1.powerhub ([2a0a:ef40:18b5:9e01:f5de:1ef8:371:ee89])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-47f85c67339sm54987049f8f.31.2026.07.27.14.14.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Jul 2026 14:14:15 -0700 (PDT)
From: Artem Blagodarenko <artem.blagodarenko@gmail.com>
X-Google-Original-From: Artem Blagodarenko <ablagodarenko@thelustrecollective.com>
To: linux-ext4@vger.kernel.org
Cc: adilger.kernel@dilger.ca,
	Artem Blagodarenko <ablagodarenko@thelustrecollective.com>,
	Artem Blagodarenko <artem.blagodarenko@gmail.com>
Subject: [RFC PATCH v4 10/11] ext4/068: test LUFID is carried through overwrite rename and RENAME_EXCHANGE
Date: Mon, 27 Jul 2026 17:13:50 -0400
Message-ID: <20260727211353.19736-19-ablagodarenko@thelustrecollective.com>
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

