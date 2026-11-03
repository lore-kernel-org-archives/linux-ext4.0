Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.47
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793713883;
	b=t7JX2qW9SOWw9x9BrlyLeD795X5uRboQQhHInGpESbf6ZBeh4DFpMhzEbAjAqyWLYoFE
	 vetk8qiKmZqYW5gG0vItnLVXar+1VkwzY6H9sUG9Ik1psKux8JNJuEYFd+zyM1ynEZFzw
	 WvUikZvZ12pc9ib4MrnGXufde52FJGVGr0xvJbNP0VxIbmQBKPigsLiBTsDEn0nlmJ3ut
	 PpBlP0LC1fX7fCGykfF6brkzjCwy9y5neAvxBU6mmwkELqyYCOowrMzDVuUE8DTnTz+Zk
	 qmTls/vpBHTSB2H1X8ULWUIXuuis/htZwQaZxRMn0cDwzqH2funVayw5bne6DAXcHyw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793713883;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:
	 X-Google-Original-From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Type:
	 Content-Transfer-Encoding;
	bh=N+Ur3jH9SKa+XQp3dEfnTs5dyXMeMX7UWyTETGXtqZE=;
	b=pgrBuIzEYrw/PZB1SQosQWy99x0m6lc2Ur5LkVIQIP1cfkmpaSrpODpry4q1RNZWAOzB
	 T9OY7sxpZCtX51A46lBd+uCeqcAcarWODUbWJulmCYrPz7ZE+a2EcnQNIP9k2eIlzYHnE
	 robqj9b6cH+m6+lrartNVS+p2F1uEM4H3tkWOIXgWLjHo0vpegex6+U5R33EqnA5x9cqs
	 BUFp+Y6PdlvUtg6nwvuzD7CzilpfLhFwREM9F+c4xaOI7W1O7Fkq44izA/PglnK3jGOZe
	 unqy0C9eqHw3aYHOzJETQZ8uKIaPI60cauAcAop7K2I3hmPyS0iGKoNrkEofOookBTg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=ukC+GPBz;
	arc=none smtp.remote-ip=209.85.128.47
Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com [209.85.128.47])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A1B5608509D
	for <linux-ext4@vger.kernel.org>; Tue,  3 Nov 2026 13:51:23 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 5A1B5608509D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=ukC+GPBz
Received: by mail-wm1-f47.google.com with SMTP id 5b1f17b1804b1-4a208d93758so44814895e9.3
        for <linux-ext4@vger.kernel.org>; Tue, 03 Nov 2026 05:51:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793713882; x=1794318682; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=N+Ur3jH9SKa+XQp3dEfnTs5dyXMeMX7UWyTETGXtqZE=;
        b=ukC+GPBz9hX0A3V0P1HgKuU5jAKseerxz0haRJ9q3YXAY43ilobmZvZ08fAopmlwXZ
         gacx77vGSK9yvhT6oW0k68FKU19Rg3D1eJWfvksSt4WBAzygMN6+2ABMqWPMLOtOAyr6
         HkXJ4+9JEGFx+zdJcAWzosnMT1JwcLwfpXbcrqWdYFHkk0FVz3fVV+HD9lztsSRxbI02
         HoQ2OVuPnvPKx5j4ZpVbo/20OGeDMHZiItKhOwTwciKECHqqIWx1uc0gzc324JxMyAtE
         XmxK9Zn8dJ6jlIcNtK95IQ3JSXz8wEZLfnckWFHL9FYYmauBTNoRo6TekV7lVNeN00C/
         wKOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793713882; x=1794318682;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=N+Ur3jH9SKa+XQp3dEfnTs5dyXMeMX7UWyTETGXtqZE=;
        b=Egbddxd5FuJ+bWVSJbedgRIqQu/rTYZxeav+znx3TRvoTwqGZaGnKstBb7KTrUFPoC
         clK7VOr4zc5bXTpKDjhR1svFDt0N7qqVadABlnz99fEfS2vYdwW6168XgcDuT5LEKr5+
         Rb2Wq0s+NF74zKCmFBLA7HOei4Urlt3y87j1d/7//EqrRgL1S1yAhd1PeqUTAIoNhult
         jtpQKrdW35tTe5RankxUr6rxWhKChrdL4zKswjNHPBtDX+W7UoDQ6MhxcHEl+gVTYaI7
         mbToSV0m+CW6c37XhBQwY6LBAH3VYkt1H0SjOePKLZzXiaxMcTRkRcA/WueestjuNvfs
         a/sw==
X-Gm-Message-State: APuU4Z84I/QXjDUvEpCY6KZLq5KMriaBJ6np3M7dIwIYCkKnQN0HB7HQ
	Ozk6CZFh/iuM+k+8whTOm7aCvUhFCtONPU5pc/aA5Q8z6sxb5GYCld9c
X-Gm-Gg: AYBFou1wAsuzirI29kD1DCORe9DaRSoVLd/P2yn0vwZtlqlEKA9NInvX/LxsRk/ngg4
	Oj5yWSEUcTf/MWGqjN64XhsRJsotdYEPFWTDQrpbymANIQDoDr4NIFw9ejNHB5xF2CfEb2qnWCa
	4QoXh3dnA+viE4rPw6R+k6oL7Ns68aKK0TQ4CufOfPiQCO7no7yfur6lGJaWPfzXNhGldGwh3v1
	+GOdJltNBiwzs14ntCV/8Z2SUiJSijEx+PQVy5DX22Ittp9m2KrYMyrf1GkWGEQNXi0YXURtccU
	7UNelx41bioeDAOsciLn99gW/EN5eet4GeWHUswmzAj5P6+3F/BZZTk15HXVBsO0cbLU0r6q0Ld
	Z/A+hgm8clu1DhFvSJz68QKJkwe+QgdSuAVndNklaT6OY4HZdrImWymERyrxJ7eqU1WJOjZtkqL
	bBfshLC8A0n15QXqRGgZ4gYYtlLyw7zu1W5Vxt7aAsUfyAUeNBQcQeCon8QQ0O7ie4SV+pRfH3I
	MUPuXsbSEWK/Zey5j8R2ZWLBlsupRqDZgjI8SoboXP+Fx7pC85r1UBbXMZWfXnRBj3lLwNYD47Q
	TIRHKlMaxQFku3uleqfswseNJtOqLSTTfrHvt6merJjmJmk7P2VP3vhyQ4KQ
X-Received: by 2002:a05:600c:4f86:b0:4a7:669c:c988 with SMTP id 5b1f17b1804b1-4ac18b7df2cmr309532605e9.23.1793713881678;
        Tue, 03 Nov 2026 05:51:21 -0800 (PST)
Received: from Cluster2.powerhub ([2a0a:ef40:18b5:9e01:225:90ff:fefc:9ffe])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4b2a96fc87fsm55320335e9.12.2026.11.03.05.51.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Nov 2026 05:51:21 -0800 (PST)
From: Artem Blagodarenko <artem.blagodarenko@gmail.com>
X-Google-Original-From: Artem Blagodarenko <ablagodarenko@thelustrecollective.com>
To: fstests@vger.kernel.org
Cc: linux-ext4@vger.kernel.org,
	adilger.kernel@dilger.ca,
	ablagodarenko@thelustrecollective.com,
	Artem Blagodarenko <artem.blagodarenko@gmail.com>
Subject: [RFC PATCH v6 7/8] ext4/068: test LUFID is carried through overwrite rename and RENAME_EXCHANGE
Date: Tue,  3 Nov 2026 13:51:03 +0000
Message-ID: <20261103135106.610169-8-ablagodarenko@thelustrecollective.com>
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
Assisted-by: Claude:claude-opus-5-5
---
 tests/ext4/068     | 202 +++++++++++++++++++++++++++++++++++++++++++++
 tests/ext4/068.out |   5 ++
 2 files changed, 207 insertions(+)
 create mode 100755 tests/ext4/068
 create mode 100644 tests/ext4/068.out

diff --git a/tests/ext4/068 b/tests/ext4/068
new file mode 100755
index 00000000..4dd30f1b
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
+$SET_LUFID_PROG $SCRATCH_MNT/rename_test src_file "$src_lufid" >>$seqres.full 2>&1 || \
+	{ echo "FAIL: could not set LUFID on src_file"; status=1; exit; }
+
+$SET_LUFID_PROG $SCRATCH_MNT/rename_test dst_file "$dst_lufid" >>$seqres.full 2>&1 || \
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
+$SET_LUFID_PROG $SCRATCH_MNT/xrename_test file_a "$a_lufid" >>$seqres.full 2>&1 || \
+	{ echo "FAIL: could not set LUFID on file_a"; status=1; exit; }
+
+$SET_LUFID_PROG $SCRATCH_MNT/xrename_test file_b "$b_lufid" >>$seqres.full 2>&1 || \
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
2.52.0

