Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.125.82.54
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794334796;
	b=KkoKv0deW9wQRGBZ/Le+6qoxC0QNpNJVl5DOFPTl8qCIq1yYeFy1n7lkb+GOLVi6SXlw
	 mq0viy09S/9lXHD/34UE7LrnI2BAJrZG7esFVv5hbE/wysdEKa+eboWGUcqDsYXIUV1gF
	 GPiS1j2WcOXsDNkQu4nLsVABCwZDhWijuvJZeuoc/uwE5zyRCbCRBGV6+Nyyh6TZWDYSG
	 ztTDVQq2OgG6RSIxfpPivC6cSTKm438dA/WIh2Zp/pXQr3+N09zUs3X+rqG78W2L18y/r
	 KeI6o6O3p+wCCqRPN52ixKAGKYREM9ZOWnGVfwzu9sXV7jmBgrzQudCud+3uFjFLI2g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794334796;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding;
	bh=u4qLTe41InUkuJCgoejpmAJ1STr0utezqlPIhAywKXY=;
	b=3QaN9QkTJZATsKIOKX2paQaZTYi1HG+Vqf1+SS4Mo38f2GwEIemWUshzC41TPLMxvvUN
	 Rg+5Wgzp19hMOpC/MwQNeCPeq0+0LhzBbRN425fPF1N0c3lm67ZjiguUxsZdLKSkZahoL
	 fmf13VNcifsvwwLuHz98QvoXFwjM30cxxaDZYtekwgyw1wnbqgjq5dVXShjxNulZ6JSMY
	 /WeRoG7DOx73y6g6dilHGEqbxK02c5mYTZ1fJqe8ydoxyvN69NK6EH4EG7r6oD1FwrTq+
	 mlmAMpz/zJhkgqktOXFtsBO8rZvxC2o2v46KWjZfbdNaTnp4T3Erhi27Cwt/aO+liXQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b="Jx/bSwFZ";
	arc=none smtp.remote-ip=74.125.82.54
Received: from mail-dl1-f54.google.com (mail-dl1-f54.google.com [74.125.82.54])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8FC7F606A31C
	for <linux-ext4@vger.kernel.org>; Tue, 10 Nov 2026 18:19:55 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 8FC7F606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=Jx/bSwFZ
Received: by mail-dl1-f54.google.com with SMTP id a92af1059eb24-1ae58d17cd9so1857639c88.1
        for <linux-ext4@vger.kernel.org>; Tue, 10 Nov 2026 10:19:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794334794; x=1794939594; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=u4qLTe41InUkuJCgoejpmAJ1STr0utezqlPIhAywKXY=;
        b=Jx/bSwFZZ3UwZmyqUCvz+YcSlM8G0/ZRUIF2J8eD4IAh365EYF1VN7BqWtuuTqyVig
         KG3k7tNNaydAUwSMTZpf1q4UPioiKJz4EDJT2sno6iYLvLhJPwXXK6A9MFJ1ngT47AY+
         UCYAvfY26WnTYr/g3Anm2CJ5Lv7pDVUS2bDTxj/D1b84vUkC6pmu0Ou9Ry88H31EQOgF
         yAc1ojTwlqYgYP8kFrw3GesWTTOGmcfzOgdiIgHHhqIA1Rl/c5ZpvrMEFBdI3jib3EPU
         xF/QH8QLhL5S1SKHK23PjlJ1b3TxgTEJyVJj1tB78QdHIUVTdOSfqOozXf7cyJHt4Yp4
         w1LA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794334794; x=1794939594;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=u4qLTe41InUkuJCgoejpmAJ1STr0utezqlPIhAywKXY=;
        b=MwD7iS4K52d2rJUQhcIFEbjG8rDbHkxmOkFKzyCGgOST81pZHGfcJu3cqbJqbr1Eq9
         IVsFBCnppnkb5+CpgW9F068i08VrFarOSRPFh6pNrYW7u4cnuA8PWIdb/0lWg1JjOZuM
         u/dNXPYZTCoepOX16ZvScnspXNfrhNd4EfPZjPiLkZPx5CEMYdVvN/RWUPX5MFFR37mA
         keML+QLL+OQhwSdzNEJHnvhDg5qXhEAO2h/rVmz1CsCENVB0EY1p5kccWhbuX3Qr43Ac
         Qz1ayk+wtNBUCDDs2/WYPGV603wLYAB9mjqj7PNfwSM/8+ynmH1TbblSOam7KKakEth+
         R9Fw==
X-Forwarded-Encrypted: i=1; AL+hErEeYLkEoEBdbzId0YGGAd1cwfFz8WXhlBpEnQA+rmYJyqbfXZiZfM46qSCaOg4kwlbX1pgelt0BI1Ix@vger.kernel.org
X-Gm-Message-State: APuU4Z8IjsNtlN6IWh/KTwmgX1mZLBwfTBDr42xG+9q/C6ckgB7TsMPn
	RtaRWldkS8L1lC3GYQz/xnrYTXT3Vrgxs+79Hna7o+Z2QYfnPTyTWeOE
X-Gm-Gg: AYBFou3X+VwPZ23iSQ6XmPGJEHnXYloBz9HZw+UIKEGK1LI1lRYPJb0sw99zJBP0QsB
	IHcw4h2xp8Zv11Br9i7RbFxnKuNSTRMAVvDhf+jlH0wIujXMdtHc65knILv2QSDbWVcSwEW3YCr
	gZOJ9oF/g0W//R9Q5MMwvS3Vo1Iy1t93WY1Lx0sV0zlratQjzgPW5POKLlHPJalOwht6ATRlXy3
	TqGB95kVuqXhL0Kzgjnvs1ZXevX3LbgPgPpP4GUbcgBKW8LhJe0EdJUEOho5zWRqyneU1nPmOsL
	sTdSwypYvmLVMLJgj+FFkULRpGY/8YV+gWMwkqyZ9pS3ZRX+ynicDuHmhni2nvMZ3o6vd11GpCM
	U9wpgYWaltYrBBTvkkYIw9aymQJCXEO6YwV8O2nvPF3a0RAp2bPLTdgiBUBO6IqaxQwrxwtB0q4
	3wEDQ3UUxeJWPqA7wcSez5a+eXsHthRG3PMTmhbi1gl5eM3OtfOjFkU3306q7Xpz7RZEMmioB73
	LmVSAFtaVYJKDEx52KcEo+grMxBCqW523Y+PwIWK/hc82Z4Wh5yxzUSsdPilzWUsm/z5yOkxnFt
	ynGoMG/JUPPBs0wV/YwEYZb2WjBsNuLAzO0LdwjdVY35ZMyziJ8qwJZSqOlUbOgGD3rwDvvJG/s
	FJNJGJwErGbQc2RM=
X-Received: by 2002:a05:701b:4587:b0:14c:1f57:3e86 with SMTP id a92af1059eb24-1b3b604b015mr3761570c88.47.1794334794223;
        Tue, 10 Nov 2026 10:19:54 -0800 (PST)
Received: from obadmin-Precision-3680.atlascopco.group ([136.226.232.167])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1b3b5b2ff3bsm10394386c88.11.2026.11.10.10.19.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Nov 2026 10:19:53 -0800 (PST)
From: Sahaj Chaudhari <sahaj123.sc@gmail.com>
To: fstests@vger.kernel.org
Cc: Zorro Lang <zlang@kernel.org>,
	Jan Kara <jack@suse.cz>,
	linux-ext4@vger.kernel.org
Subject: [PATCH v3] ext4: test reserved GID block allocation
Date: Tue, 10 Nov 2026 23:50:40 +0530
Message-ID: <20261110182040.798390-1-sahaj123.sc@gmail.com>
X-Mailer: git-send-email 2.43.0
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

Create a small ext4 filesystem with a nonzero reserved block pool and a
reserved GID stored in the superblock. Fill ordinary free space as an
unprivileged user outside that group, verify that another allocation is
denied, then verify that the same user can allocate a block with the
reserved group as its primary and only supplementary group.

This exercises loading s_resgid from the superblock rather than overriding
it with a resgid mount option, and detects the regression fixed by:

commit c87abbab6147 ("ext4: fix incorrect function call when initializing s_resgid")

Link: https://lore.kernel.org/r/20261008065651.3517824-1-sahaj123.sc@gmail.com
Reviewed-by: Jan Kara <jack@suse.cz>
Signed-off-by: Sahaj Chaudhari <sahaj123.sc@gmail.com>
---
Changes since v2:
- Use fsgqa2 instead of root for the fill group, and require it explicitly.
- Do not inherit external MKFS_OPTIONS; exclude journal-dependent mount
  options for the test's no-journal filesystem.
- Check tune2fs and su -g/-G support, and use the validated su executable
  consistently.
- Require the fill operation to write data and reach ENOSPC; check that
  ordinary allocation also fails specifically with ENOSPC.
- Let the check harness unmount scratch and finish with _exit 0.
- Add Jan Kara's Reviewed-by.

Testing:
- ./check ext4/309 in isolated x86-64 QEMU with fresh TEST_DEV and
  SCRATCH_DEV images passes on the fixed kernel and fails specifically
  at reserved-GID allocation on the pre-c87abbab6147 kernel.
- Both filesystems pass e2fsck -fn after each run.
- bash -n and git diff --check pass. Validation is limited to ext4/309,
  not the full xfstests suite.

 tests/ext4/309     | 75 ++++++++++++++++++++++++++++++++++++++++++++++
 tests/ext4/309.out |  2 ++
 2 files changed, 77 insertions(+)
 create mode 100755 tests/ext4/309
 create mode 100644 tests/ext4/309.out

diff --git a/tests/ext4/309 b/tests/ext4/309
new file mode 100755
index 00000000..e5dcd215
--- /dev/null
+++ b/tests/ext4/309
@@ -0,0 +1,75 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (c) 2026 Sahaj Chaudhari.  All Rights Reserved.
+#
+# FS QA Test No. 309
+#
+# Verify that the ext4 reserved GID can allocate blocks after ordinary
+# free space is exhausted.
+#
+. ./common/preamble
+_begin_fstest auto enospc quick
+
+_exclude_fs ext2
+_exclude_fs ext3
+_exclude_scratch_mount_option "resuid=" "resgid=" "data=" \
+	"data_err=abort" "commit=" "journal_async_commit" "journal_checksum"
+
+_fixed_by_kernel_commit c87abbab6147 \
+	"ext4: fix incorrect function call when initializing s_resgid"
+
+_require_scratch
+_require_command "$TUNE2FS_PROG" tune2fs
+_require_xfs_io_command "falloc"
+_require_user
+_require_group
+RES_GROUP=$qa_group
+_require_group fsgqa2
+FILL_GROUP=fsgqa2
+SU_PROG=$(command -v su) || _notrun "su utility required"
+"$SU_PROG" -s /bin/bash -g "$FILL_GROUP" -G "$FILL_GROUP" "$qa_user" \
+	-c true >/dev/null 2>&1 ||
+	_notrun "su with -g and -G support required"
+
+echo "Silence is golden"
+
+RESGID=$(_cat_group | awk -F: -v group="$RES_GROUP" \
+	'$1 == group { print $3 }')
+FILLGID=$(_cat_group | awk -F: -v group="$FILL_GROUP" \
+	'$1 == group { print $3 }')
+[ "$RESGID" != "$FILLGID" ] || _notrun "reserved and fill groups are identical"
+[ "$(id -u "$qa_user")" -ne 0 ] || _notrun "test user is root"
+TEST_FILE="$SCRATCH_MNT/ext4_resgid.fill"
+
+MKFS_OPTIONS="-m 10 -N 1024 -O ^has_journal" \
+	_scratch_mkfs_sized $((16 * 1024 * 1024)) 4096 >>"$seqres".full 2>&1
+"$TUNE2FS_PROG" -u 0 -g "$RESGID" "$SCRATCH_DEV" >>"$seqres".full 2>&1 ||
+	_fail "could not set scratch filesystem reserved GID"
+_scratch_mount
+
+touch "$TEST_FILE"
+chmod 0666 "$TEST_FILE"
+
+FILL_OUTPUT=$("$SU_PROG" -s /bin/bash -g "$FILL_GROUP" -G "$FILL_GROUP" \
+	"$qa_user" -c "$XFS_IO_PROG -f -c 'pwrite 0 16M' '$TEST_FILE'" 2>&1)
+FILL_STATUS=$?
+printf '%s\n' "$FILL_OUTPUT" >>"$seqres".full
+printf '%s\n' "$FILL_OUTPUT" | grep -q "pwrite: No space left on device" ||
+	_fail "space-fill operation did not reach ENOSPC (status $FILL_STATUS)"
+FILL_SIZE=$(_get_filesize "$TEST_FILE") ||
+	_fail "could not determine space-fill file size"
+[ "$FILL_SIZE" -gt 0 ] || _fail "space-fill operation wrote no data"
+
+if ALLOC_OUTPUT=$("$SU_PROG" -s /bin/bash -g "$FILL_GROUP" -G "$FILL_GROUP" \
+	"$qa_user" -c "$XFS_IO_PROG -c 'falloc 16M 4k' '$TEST_FILE'" 2>&1); then
+	_fail "ordinary user allocated from the reserved pool"
+fi
+printf '%s\n' "$ALLOC_OUTPUT" >>"$seqres".full
+printf '%s\n' "$ALLOC_OUTPUT" | grep -q "fallocate: No space left on device" ||
+	_fail "ordinary allocation failed for a reason other than ENOSPC"
+
+"$SU_PROG" -s /bin/bash -g "$RES_GROUP" -G "$RES_GROUP" "$qa_user" -c \
+	"$XFS_IO_PROG -c 'falloc 16M 4k' '$TEST_FILE'" \
+	>>"$seqres".full 2>&1 || _fail "reserved GID failed to allocate a block"
+
+_exit 0
diff --git a/tests/ext4/309.out b/tests/ext4/309.out
new file mode 100644
index 00000000..56330d65
--- /dev/null
+++ b/tests/ext4/309.out
@@ -0,0 +1,2 @@
+QA output created by 309
+Silence is golden

base-commit: d07dca72d2455f4ba8c660ad4c008541ccccb707
-- 
2.43.0

