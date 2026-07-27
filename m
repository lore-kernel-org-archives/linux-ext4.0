Received: from mail-wr1-f51.google.com (mail-wr1-f51.google.com [209.85.221.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD455429026
	for <linux-ext4@vger.kernel.org>; Mon, 27 Jul 2026 21:14:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785186853; cv=none; b=RSVs0zpeE5wUCOgMsfyJO9b6Z3aYO/6hk6+4sBfKuGMGqT9cRpFpvd6hnlJeaIIYC8ulGS4SwHmc49BBtVd44RC7Sa6omn9rF5Uz7OA2RTSJqvZfTt5OTwr8E/6DSwutgnQCK5myInH8Bq45SeCQq93byMgSDlk9/iDUu6Q1Ou4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785186853; c=relaxed/simple;
	bh=e+ohwOSN6LbpmLGd/izSBp6CeixeLtMlkFS2LHQyMIs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gAJdCSp9oCXg7D5yAtqwtM5RJCBeq59n0AcoW5run8sabwiiqvyAQR4/HjdlGha4BFpEG2nZeX02YsD6nBER5xTP7UpuRJnjr8uT8+A7+DkN3ejjgkMcFnebjzt5vdm3UEJrY01S4dlUaEdz1NoXIyV6vuwXAa5G5ImdNjO0o24=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=YrQFkc3q; arc=none smtp.client-ip=209.85.221.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="YrQFkc3q"
Received: by mail-wr1-f51.google.com with SMTP id ffacd0b85a97d-47f752b3423so1949007f8f.3
        for <linux-ext4@vger.kernel.org>; Mon, 27 Jul 2026 14:14:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785186850; x=1785791650; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=WJzUOqF8t8KNC63eLRFBx4UYUm1u+tRaMVpSKwDOOqQ=;
        b=YrQFkc3q73kahslbpdWKTIVZDE1akgNdyWowsqvRVb0j6gNSdav8HshivHvwyQfR0K
         I0o+DIdjatIk7V+24oolDeLFGFeijihE+dEGGW018DuAxiTUd1jF41H1OFq1wvOeEhuj
         wDcK/4UfILzXdt4LmMzWVymGiMmb0CM7wJr39yjEbW00WdbAcbE2RmRpQKHyCYMxCoAP
         n26keZrjYEkz/68D+TRSAZ5DrZLphZDuVWqt/Sud6ZZGJZX3aiOEdTuoTsxgXLxLMisH
         ezqzEnYIngxgEMHVcK8uga55nZZ62zNxpJeSLKWV+4nS2XMnEsZF7xmHXSfNj5nHGXEC
         8TlA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785186850; x=1785791650;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=WJzUOqF8t8KNC63eLRFBx4UYUm1u+tRaMVpSKwDOOqQ=;
        b=CcxqXaIKioXDjWvQW82Gf9BHiS6QQSrz9F9uBxOmb6Yl6vHls8Kf5sDxvsrJhKeRDQ
         Apecxja9jQpuetDBA5d8DF4HbFzTAI8osHrGWatQxzLmHbVuNdhlB+nf8WM75PCSUNS1
         D7IzKtTWXVWD8DqNvoJWTlsBUPogBIZMvVpfReZ/uex5TDWov2env6x2H/o92ZVLdP5A
         12Kk9NCKpTOwhO7vE8Zvx395TOnPWNBAblWM8rB3zn6sLb0UERCZuoHpZUxy9MrP7QwH
         XDjRcEM7XjLN/LEcYAuwB136XsotZ0wwwMWmZm10KrfN9o6DZGifHuxMStEWypBrz6+v
         ggvA==
X-Gm-Message-State: AOJu0YwYdNMwlQbZWO6qFj7uA1yRSkirEmZ3vIbJV/T/G/aEUTIVrvpY
	VRTSuQewHYwxkVhNTcdUiGZOw5nsDmo0d56mfpiCMZLTHfJblVzBkpG4QhM0qFwm
X-Gm-Gg: AR+sD10mWOWa3i8XYUgmpXncpnS7sBO6yadFGKIuaS48/+hDc8gBsSz10Lk90EXKn3V
	bpqHLPbTYXWA27ePCfgKRXh86DtFpUohBVVVIjw/hPkKke75nKqDrIN+hdw1uFNBs/sDK1cZbkw
	1wk3g29oPzaGtMKVhqO/IBB2MRm90EqXrp6WQalIXT9x5AO8ZMOhcC2HOUdhVKnoZ1VCnk3lhpy
	Z2LCa1gLN0w+XlYnFDWoPgjiRUxZc+jscxTwdzofGiX7RiobEd00luEj6jLk5lhcXJ7HKM+xrsG
	22Lf/ucZ4ttMTQ6zC6lpggq1ZNHlC9kmuzGXExAEyDvkCi7OFaBYB5jEX6PpXoDDRcNqbmEgReM
	3jJXzjfYKK7j+tT/WUd2I1QbDOq4XIyzelYVwehprRO3A5f3vZvI+qYd+/QM0nIL7Yfmq+8eDoN
	0bAJRgWIJXnn6xaBqZEJMgM8Uk3TUrKPrr0A==
X-Received: by 2002:a5d:5f43:0:b0:47f:96f9:a99f with SMTP id ffacd0b85a97d-47fafa5e6bemr931253f8f.13.1785186849961;
        Mon, 27 Jul 2026 14:14:09 -0700 (PDT)
Received: from Cluster1.powerhub ([2a0a:ef40:18b5:9e01:f5de:1ef8:371:ee89])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-47f85c67339sm54987049f8f.31.2026.07.27.14.14.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Jul 2026 14:14:09 -0700 (PDT)
From: Artem Blagodarenko <artem.blagodarenko@gmail.com>
X-Google-Original-From: Artem Blagodarenko <ablagodarenko@thelustrecollective.com>
To: linux-ext4@vger.kernel.org
Cc: adilger.kernel@dilger.ca,
	Artem Blagodarenko <artem.blagodarenko@gmail.com>
Subject: [RFC PATCH v4 6/8] ext4/067: LUFID and encryption+casefold+dirdata
Date: Mon, 27 Jul 2026 17:13:44 -0400
Message-ID: <20260727211353.19736-13-ablagodarenko@thelustrecollective.com>
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

Test ext4 LUFID  functionality in the complex combination of
encryption, casefold (case-insensitive), and dirdata features.

Verification uses 'debugfs ls -lD' to check for 'fid: or hash:' markers.
Tests also verify that case-insensitive lookups work correctly and that
encrypted file content is preserved after setting LUFID.

This test validates that LUFID works correctly when encryption and
casefold features are enabled, ensuring feature interactions don't
break the LUFID functionality.

Signed-off-by: Artem Blagodarenko <artem.blagodarenko@gmail.com>
---
 tests/ext4/067     | 137 +++++++++++++++++++++++++++++++++++++++++++++
 tests/ext4/067.out |   4 ++
 2 files changed, 141 insertions(+)

diff --git a/tests/ext4/067 b/tests/ext4/067
new file mode 100755
index 00000000..acb49c40
--- /dev/null
+++ b/tests/ext4/067
@@ -0,0 +1,137 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (c) 2026 The Lustre Collective. All Rights Reserved.
+# Author: Artem Blagodarenko <ablagodarenko@thelustrecollective.com>
+#
+# FS QA Test ext4/067
+#
+# Test ext4 LUFID  with encryption and casefold.
+# EXT4_IOC_SET_LUFID is an ioctl that allows LUFID data to be set on a directory entry.
+# directory name hash is stored by EXT4 when casefold and encryption features are enabled.
+
+. ./common/preamble
+_begin_fstest auto quick encrypt casefold
+
+# Import common functions
+. ./common/filter
+. ./common/encrypt
+. ./common/casefold
+. ./common/attr
+. ./common/ext4
+
+_exclude_fs ext2
+_exclude_fs ext3
+
+_require_scratch_nocheck
+_require_scratch_encryption
+_require_scratch_casefold
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
+	# Verify kernel can mount filesystem with encrypt+casefold+dirdata
+	if ! _scratch_mkfs -O encrypt,casefold,dirdata &>>$seqres.full ; then
+		_notrun "failed to create filesystem with encrypt+casefold+dirdata"
+	fi
+	if ! _try_scratch_mount &>>$seqres.full ; then
+		_notrun "kernel cannot mount filesystem with encrypt+casefold+dirdata"
+	fi
+	_scratch_unmount
+}
+
+_require_scratch_dirdata
+
+# Helper to add a v2 encryption key and set policy on a directory
+_setup_encrypted_dir()
+{
+	local dir=$1
+	local raw_key=$(_generate_raw_encryption_key)
+	local keyspec=$(_add_enckey $SCRATCH_MNT "$raw_key" | awk '{print $NF}')
+	_set_encpolicy $dir $keyspec
+	_casefold_set_attr $dir
+	echo $keyspec
+}
+
+# Create a filesystem with encryption, casefold, and dirdata features
+_scratch_mkfs -O encrypt,casefold,dirdata &>>$seqres.full
+_scratch_mount
+
+# Test: Create file in encrypted+casefolded directory and set three 16-byte LUFIDs
+echo "Test: Set three 16-byte LUFIDs on file in encrypted+casefolded directory"
+mkdir $SCRATCH_MNT/encrypted_dir
+_setup_encrypted_dir $SCRATCH_MNT/encrypted_dir > /dev/null
+
+echo "encrypted content" > $SCRATCH_MNT/encrypted_dir/testfile.txt
+
+lufid_payload=$'\xde\xad\xbe\xef\x01\x02\x03\x04\x11\x12\x13\x14\x21\x22\x23\x24\xca\xfe\xba\xbe\x05\x06\x07\x08\x31\x32\x33\x34\x41\x42\x43\x44\xfe\xed\xfa\xce\x09\x0a\x0b\x0c\x51\x52\x53\x54\x61\x62\x63\x64'
+expected_fid='[0xdeadbeef01020304:0x11121314:0x21222324],[0xcafebabe05060708:0x31323334:0x41424344],[0xfeedface090a0b0c:0x51525354:0x61626364]'
+
+# Set three LUFIDs on the file at the same time (48 bytes total: three 16-byte FIDs)
+# First FID:  [part1 (8 bytes):part2 (4 bytes):part3 (4 bytes)]
+# Second FID: [part1 (8 bytes):part2 (4 bytes):part3 (4 bytes)]
+# Third FID:  [part1 (8 bytes):part2 (4 bytes):part3 (4 bytes)]
+set_lufid $SCRATCH_MNT/encrypted_dir testfile.txt "$lufid_payload" >>$seqres.full 2>&1
+if [ $? -ne 0 ]; then
+	echo "FAIL: Could not set three LUFIDs on encrypted+casefolded file"
+	_scratch_unmount
+	_check_scratch_fs
+	status=1
+	exit
+fi
+
+# Verify file is still accessible
+if [ ! -f $SCRATCH_MNT/encrypted_dir/testfile.txt ]; then
+	echo "FAIL: Encrypted file not accessible after setting LUFID"
+	_scratch_unmount
+	_check_scratch_fs
+	status=1
+	exit
+fi
+
+# Verify file content is preserved
+enc_content=$(cat $SCRATCH_MNT/encrypted_dir/testfile.txt 2>/dev/null)
+if [ "$enc_content" != "encrypted content" ]; then
+	echo "FAIL: Encrypted file content not preserved after setting LUFID"
+	_scratch_unmount
+	_check_scratch_fs
+	status=1
+	exit
+fi
+
+# Test case-insensitive lookup still works with LUFID
+if [ ! -f "$SCRATCH_MNT/encrypted_dir/TESTFILE.TXT" ]; then
+	echo "FAIL: Case-insensitive lookup doesn't work with LUFID"
+	_scratch_unmount
+	_check_scratch_fs
+	status=1
+	exit
+fi
+
+echo "Successfully set and verified three 16-byte LUFIDs on encrypted+casefolded file"
+
+# Dump directory structure to verify dirdata
+if ! _dump_dir_structure $SCRATCH_MNT/encrypted_dir testfile.txt "$expected_fid"; then
+	echo "FAIL: Stored LUFID does not match expected value"
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
diff --git a/tests/ext4/067.out b/tests/ext4/067.out
new file mode 100644
index 00000000..1c9a8126
--- /dev/null
+++ b/tests/ext4/067.out
@@ -0,0 +1,4 @@
+QA output created by 067
+Test: Set three 16-byte LUFIDs on file in encrypted+casefolded directory
+Successfully set and verified three 16-byte LUFIDs on encrypted+casefolded file
+  Directory structure of encrypted_dir: OK (dirdata verified)
-- 
2.43.7

