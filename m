Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.125.82.170
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794079806;
	b=1xutz604ftRePgAuQNeASwQnyL1vvk6yyu4DGTkHxzSmESVTYXXyvYwEF4QyFjWO9Q+5
	 vCBuVsGjTxri1b48aNTqjfkcOxSt2uVTRRumMjzbS4eb9472Eu7jJ0KEnMKCSM6OBZ1U7
	 wFc93y7G4pXDTjvclJcWAeiR02whLMtdjul8jQXBYO+cWvNZlGiZHGnEOPzwdd51nqGCt
	 zVvdgqTB5WTPSZNKhbhLLd54dO12Y30sZTY30IMfB8jU7YmiWM4zRpUjJNg+rrPFL/h2b
	 TrzOrxdTrN3xS9nJUojGLHxlDgne553jG2Ka/ylp0UpCvTLUJn3W28TR85gp8cPvgyw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794079806;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=gXuHBD2/RzkLVBCTVEUe11Pbt4G0CDAmveDcYmqOdLQ=;
	b=gQM8LIIpOtJ7sdJ5o5L6Soa8PmH/fX/bHX54Tk9+VC7fmBnZfO0yNR6jw39goiO2F3Iw
	 Z9HBmY5lnh/s8LW1MG+32eFBIjJy9w6aX4CTCzXOXW3JQX0ucCFCOk7z2Q4V9yQC3FPzW
	 BQ8XxACJ7ilkOPXuTsLRERNedrnu7PpMv+nghEVI0ddsRpYPZORbCk4d6v1R25XyPcnAZ
	 3t4CStNb9Q/4T90SVpKolHboz26hy68XyCYmFDDJY19NeQAc4oSj0rBJg+EWIpEBDIlji
	 E6qJJzf6OKYzZNZzzwJ3IOXt+wOSyrU8O7PYIF+e0Tdyw+MDwElOxCjJZZka2fJE1SA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=EmJrhyqw;
	arc=none smtp.remote-ip=74.125.82.170
Received: from mail-dy1-f170.google.com (mail-dy1-f170.google.com [74.125.82.170])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DFE93606A326
	for <linux-ext4@vger.kernel.org>; Sat,  7 Nov 2026 19:30:05 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org DFE93606A326
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=EmJrhyqw
Received: by mail-dy1-f170.google.com with SMTP id 5a478bee46e88-33fb4680717so21135eec.1
        for <linux-ext4@vger.kernel.org>; Sat, 07 Nov 2026 11:30:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794079805; x=1794684605; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=gXuHBD2/RzkLVBCTVEUe11Pbt4G0CDAmveDcYmqOdLQ=;
        b=EmJrhyqwdMBGj8faFamDG8CXysxUzL9vF+lZ/IQEJwMrxS2JxabiMVVLAWJT5xbBeT
         JT1VEtLA+4uhNbtcQKzxjm9otT2xluOS21ODrv484pt05jW95Pgeq004rg5whB4X8KLN
         8htfeqUYtBENdzxG6wiqWUf3Cj+V/nKmMAoP8N/JqXyqXe3pPMYykKruXoRO/rS0/otT
         YBMqbfL3iE//3crO7MmdJ2qYqsTY0/owRVEgQALPs+GF4C+qgdyh5ARBSXONC77fSWca
         KPFrHxLH5iW6blt+MPDOp6B/rUkkTGKSZ03fOU7y3i1+wNl6GBt8Zhc7LyPhkQ6keVhl
         OCkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794079805; x=1794684605;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=gXuHBD2/RzkLVBCTVEUe11Pbt4G0CDAmveDcYmqOdLQ=;
        b=2MIlnb89NNApz+jKZni2OCrP6Z+2gk5DSX78PyXNluST6Okq7HjMrExswrLfKs9b+k
         Jue5UucZaqaD0anzUHj4PNZO2iNc5Ck54qqVyDC+1YM1vu77yL505EWkGc0B19vFOJ3/
         EWty3mrfm6OPenQAIvxO/1NVdUMhvT4aqByE4wgLGvKtyBs5WyEhDrVCg21nKjBzorl2
         q522jI6LH8jv3OMnm7VgSZdfyw2jsWGSzhq9Oqa8GZXMiDDd1FOqy2N+EoFlPhhdUWT0
         Vlphwna2FfN+WtEVIpldkz5u0QGujE50sEIwry3UAuzHCa+2fs/i8yPc0+SX/FSajq+Z
         saDA==
X-Forwarded-Encrypted: i=1; AL+hErGqjjjlmoIdsqG/I0cQb5sJ8GdmPzqGla3+U2sYgK62gDlVXh9NniFAEe5qZxlx9s4zBZz3R6P0l45v@vger.kernel.org
X-Gm-Message-State: APuU4Z/wNq0l7zDs3N6bFbYlS0LUd147lio5PMZTILEa9Ah91cWnluUX
	AyNf0wRcwzdUP6Qr3lFISF8mSQKNwPvQvh4XaOB/fROSVqbV/39H1nkc
X-Gm-Gg: AYBFou1dJIu9ejCEHtU2AxMwsNsWQSQsFHYlYTeDfCcAZ/KihRrEZWnyV7F1QpDd+qZ
	Bdq23tOHLOB3qKEIRgEjXH6hQwRY3735FiCmPfnGBlZEWiKZeiVIrnWUKGFrx9xJ+nEPArA9s4P
	DhjCT/2vfCud97AqSRb2t8dWWlpkcmvlVt9X6foYVFnHfOkM3ZOQdmx4X08lO0WoEHPk89az5E9
	ryFnwFlc/rWMYKjsimL08VgRMGv2UlAIrFprjoJAvq+F9lGy4gXdSkYkMpx1ekcBCY/ADIYxt+V
	DDX/CQn04x/l/AEB7JOTpKlsseDipgbDrBp3Ggj/VtxuWFz1fogbVhXDMX5oYbTiWDHZFBg/hNm
	FcXqEph4Qmopr7DoNbR+SOn+Z3EeP88rIWcu//ckzG11M2HDjqyEZxAZnG1sB6ihGauQhoa2hhg
	rC8g1/qzXaFGY6ZkQa4vNgt+U2JsgkkrSIKcjea38Oh7SBpXG1xYu9EBG8bJHbq7038XAUw3VgP
	PAMy/3Swj08oBNo8kh4rtQZgU9lWTYwRPri5ZyH9hUG6wOy241ZEELP5Ip/by98eyxsOCFI9niN
	7RTSXyEHandxhQt7HqDEWL9ePgqtvQADW1wZlIkIG4ipiZKwvdi8aK8l6+u7IJwigfBtNg==
X-Received: by 2002:a05:7301:dd8f:b0:369:21a:dcca with SMTP id 5a478bee46e88-37256326c2dmr68219eec.10.1794079804988;
        Sat, 07 Nov 2026 11:30:04 -0800 (PST)
Received: from obadmin-Precision-3680.atlascopco.group ([136.226.232.167])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-36faaa8f1e9sm17204814eec.28.2026.11.07.11.30.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 07 Nov 2026 11:30:04 -0800 (PST)
From: Sahaj Chaudhari <sahaj123.sc@gmail.com>
To: fstests@vger.kernel.org
Cc: Zorro Lang <zlang@kernel.org>,
	Jan Kara <jack@suse.cz>,
	linux-ext4@vger.kernel.org
Subject: [PATCH v2] ext4: test reserved GID block allocation
Date: Sun,  8 Nov 2026 01:00:50 +0530
Message-ID: <20261107193050.330685-1-sahaj123.sc@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261012112109.3363168-1-sahaj123.sc@gmail.com>
References: <20261012112109.3363168-1-sahaj123.sc@gmail.com>
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

Use su and xfs_io for the credential changes and allocations instead of
adding a dedicated C helper. Exclude mount options that override the
reserved IDs and skip configurations without the required users, groups
or fallocate support.

Link: https://lore.kernel.org/r/20261008065651.3517824-1-sahaj123.sc@gmail.com
Signed-off-by: Sahaj Chaudhari <sahaj123.sc@gmail.com>
---
Changes since v1:
- Replace the C helper and its build registration with su and xfs_io,
  following Jan's and Zorro's suggestions.
- Set both primary and supplementary groups explicitly, and compare
  ordinary and reserved-GID allocations using the same unprivileged UID.
- Exclude resuid/resgid mount overrides; leave _user_do unchanged.

Review:
https://lore.kernel.org/all/j2dthue3fzup753jrndn6kh44qfvihx2bylmiwcoxubnrxpgdk@zx6shyx3hbb6/
https://lore.kernel.org/all/aurRSqrRkEfyp6M7@zlang-mailbox/

Testing:
- Exact ./check ext4/309 in x86-64 QEMU: ordinary allocation is denied
  after filling free space; reserved-GID allocation succeeds on the fixed
  kernel. The pre-c87abbab6147 kernel fails at the reserved-GID allocation
  as expected. Both TEST_DEV and SCRATCH_DEV pass e2fsck -fn afterward.
- Exact ./check ext4/309 passes natively on an AM642 ARM64 board running
  6.12.57-ti-gd00ea986335d; both loop-backed filesystems pass e2fsck -fn.
- Validation is limited to ext4/309, not the full xfstests suite.

 tests/ext4/309     | 63 ++++++++++++++++++++++++++++++++++++++++++++++
 tests/ext4/309.out |  2 ++
 2 files changed, 65 insertions(+)
 create mode 100755 tests/ext4/309
 create mode 100644 tests/ext4/309.out

diff --git a/tests/ext4/309 b/tests/ext4/309
new file mode 100755
index 00000000..3bd12009
--- /dev/null
+++ b/tests/ext4/309
@@ -0,0 +1,63 @@
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
+_exclude_scratch_mount_option "resuid=" "resgid="
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
+_require_group root
+FILL_GROUP=root
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
+MKFS_OPTIONS="-m 10 -N 1024 -O ^has_journal $MKFS_OPTIONS" \
+	_scratch_mkfs_sized $((16 * 1024 * 1024)) 4096 >>"$seqres".full 2>&1
+"$TUNE2FS_PROG" -u 0 -g "$RESGID" "$SCRATCH_DEV" >>"$seqres".full 2>&1
+_scratch_mount
+
+touch "$TEST_FILE"
+chmod 0666 "$TEST_FILE"
+
+su -s /bin/bash -g "$FILL_GROUP" -G "$FILL_GROUP" "$qa_user" -c \
+	"$XFS_IO_PROG -f -c 'pwrite 0 16M' '$TEST_FILE'" \
+	>>"$seqres".full 2>&1
+
+if su -s /bin/bash -g "$FILL_GROUP" -G "$FILL_GROUP" "$qa_user" -c \
+	"$XFS_IO_PROG -c 'falloc 16M 4k' '$TEST_FILE'" \
+	>>"$seqres".full 2>&1; then
+	_fail "ordinary user allocated from the reserved pool"
+fi
+
+su -s /bin/bash -g "$RES_GROUP" -G "$RES_GROUP" "$qa_user" -c \
+	"$XFS_IO_PROG -c 'falloc 16M 4k' '$TEST_FILE'" \
+	>>"$seqres".full 2>&1 || _fail "reserved GID failed to allocate a block"
+
+_scratch_unmount
+status=0
+exit
diff --git a/tests/ext4/309.out b/tests/ext4/309.out
new file mode 100644
index 00000000..56330d65
--- /dev/null
+++ b/tests/ext4/309.out
@@ -0,0 +1,2 @@
+QA output created by 309
+Silence is golden
-- 
2.43.0
