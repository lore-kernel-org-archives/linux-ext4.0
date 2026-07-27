Received: from mail-wm1-f43.google.com (mail-wm1-f43.google.com [209.85.128.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97FE63E5ED8
	for <linux-ext4@vger.kernel.org>; Mon, 27 Jul 2026 21:13:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785186813; cv=none; b=PGuVvKkeA+L5a2ICJWHFuPkrK9kIcHv3pssPc1jHOQcidWBrew6PY7j+rOUJRQRE9coGgcyGJVCx76kQq3v2cp6BvmHxarT/1b0vJypL6ubFb/ID1G9OyE8vGNosDCTGRb2ZYLhXW+TBUQTo8wXwIXiyO6yGIsBPqvz6IgUCzHo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785186813; c=relaxed/simple;
	bh=y4orxXOw55z5BNsaPUlowMfOryJzbLhUfRWU2oa78jA=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=WimrHOs7r63XvmjN9MyoVRqpT9JFO8JGoprdi40bim/Pq8NqFp0Fyat4ryv/BUFg3CVu3g4SvSzPfa9MS5Vax1+M6FB4SSFzlIOBOCEomZVnFowSnstPArstORRxS7lZzgI7pSN5A/ufEQistHkkbIc+MBsQ4pFhXxmbWtt7YRs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=SCo1OJVh; arc=none smtp.client-ip=209.85.128.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="SCo1OJVh"
Received: by mail-wm1-f43.google.com with SMTP id 5b1f17b1804b1-495437bb891so2789995e9.1
        for <linux-ext4@vger.kernel.org>; Mon, 27 Jul 2026 14:13:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785186810; x=1785791610; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=IuuiL83izvKfBJnCecdXUwi5pVl5ykAPf6JFGwW6waU=;
        b=SCo1OJVheH02Bwh3PiycmDVs+J/T7AoAwD50C8KoOEzhv3/O1cHJqg7j2sXWocHGv/
         6vX92TWF4VqLEaaS418XmsroGvdImh+0CvTRyyH/uvSlQAAUM37yCDSNv5CCAovBdlCE
         XyXQeF0PcPWYhmvqptVDMRHJLpazbSVqLmppgTCoQrbdu343Z0F5gSywOvKcF0+w1nTb
         degQvl2Qcc56ilC8Po4nzQws9ydNvLI+/W+BjHCzs8Z27qugyAYvNeaj6EGabd3/pYoS
         KrTpEtthVq/osfzTT8ZcwItoDkAoTKWg3Aazqbifabaa5klwgmHiL6E7Qbs6J8LsvmCf
         jciw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785186810; x=1785791610;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=IuuiL83izvKfBJnCecdXUwi5pVl5ykAPf6JFGwW6waU=;
        b=Cr+ucm4fbfk3kUaBneas//t3W/lCHar5nvjVf06+00dcL2lBQDhC/Yt/qm9aLXSmO0
         w3hES1EmH96KShXt4zMYlUNCte81ljVfY+YavtA8Dn0nggo5gjQi3hLwAKlCfmOmBDop
         ZQad771RBxJtRHavTTOw7E4vDfDCVCPdAFK1lTzslbdDXkLy0YQad/jkrTNwtXcZVeCr
         XL3nOTHG+r8CDx1Y9f19fAgV2ZS5M38JOmK26fW8BQ3qsRZOrgcKr6o3Hw9USitZF+qP
         DvPdv4cjXqs4Y1V6RlVEnZx6UxHSP0ZUnJIgFRI+HIl8CyM0J5xsYiX5QkctoUTcLkKC
         nA4Q==
X-Gm-Message-State: AOJu0YxjyweJGudIvlxzwczVQaJhPPQhXxgZovlKMzzzbamqEAUyljmJ
	xLwCetRz9JbfihYZT7xZGbe3Hd/NrdYS7iNXIasmnzC9d+6oMhCofTqpoBxmfg==
X-Gm-Gg: AR+sD12/zLLiVHVbuJW2dgpUxRtzYOwSrijB28bUNpsuMGX5bytw6ewgvIS4Y2XK8H5
	x2XpJ2b7xHgh1+cZRCiJhMLhBw1moW0eeW/xVBxObF7/185M71NcN+1KASv7bISRcuCkF2cKTHs
	mJFsH9zW1KB5S6sHh6mZPOxYrJdP44ie7G2zOCad0OiHYJKc6ec9w2X1vgNg73x1fh+72OPH57z
	4eBTkcTAItwMGy2R6U8NDR+hngY+TCCRbc+Sfk99b3DNBQPchcahKRmH/pzjS7D+Bn9fjaiOh3j
	aM2PZiijTe5fAOo5nJBxx4y2HrC/+QlGHZyX6pZSephJZzZ8fFFfq93jisG9STNlijI4ck07cTW
	2OflWxvg/R9TlKrFijbMi9xvFqjnbXh0uMWQ8ADbcWRdKSeVg0wwnenNz8aZ8NRXyFXYzNc/bWk
	ng0jKcO3OhDkw950PeSFdFe8lJlgVdlslBVrx5n/EOIDkQ
X-Received: by 2002:a05:600c:4585:b0:495:6934:4146 with SMTP id 5b1f17b1804b1-496c567ab59mr3117245e9.11.1785186809761;
        Mon, 27 Jul 2026 14:13:29 -0700 (PDT)
Received: from Cluster1.powerhub ([2a0a:ef40:18b5:9e01:f5de:1ef8:371:ee89])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4957b842691sm270073775e9.1.2026.07.27.14.13.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Jul 2026 14:13:29 -0700 (PDT)
From: Artem Blagodarenko <artem.blagodarenko@gmail.com>
X-Google-Original-From: Artem Blagodarenko <ablagodarenko@thelustrecollective.com>
To: linux-ext4@vger.kernel.org
Cc: adilger.kernel@dilger.ca,
	Artem Blagodarenko <ablagodarenko@thelustrecollective.com>
Subject: [PATCH v2 00/13] e2fsprogs: Add support for dirdata feature
Date: Mon, 27 Jul 2026 17:13:09 -0400
Message-ID: <20260727211322.19686-1-ablagodarenko@thelustrecollective.com>
X-Mailer: git-send-email 2.43.7
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add support for the INCOMPAT_DIRDATA feature, which allows
storing extra metadata in directory entries beyond the file
name. This provides a unified mechanism for extending directory
entries with additional information, including:

- hashes for encryption + casefold support
- unique 128-bit file identifiers (LUFID)
- high bits of 64-bit inode numbers
- future directory entry extensions

If directory hashes were stored before the dirdata feature was
introduced, the legacy hash format continues to be supported for
backward compatibility.

This series adds e2fsprogs support for DIRDATA, including:

- libext2fs: dirdata infrastructure and helper functions
- e2fsck: validation, repair, and reporting support for
  dirdata fields
- debugfs: display of dirdata fields in directory listings
  with the -lD option for testing and debugging
- mke2fs/tune2fs: user-visible support for enabling the
  dirdata filesystem feature

The series also adds regression tests covering directory
optimization, duplicate directory entries, and dirdata field
preservation to ensure metadata integrity and prevent directory
corruption.

The companion kernel series is:
  [PATCH v6 00/11] Data in direntry (dirdata) feature

Changes in v2:
- debugfs ls -lD: fixed LUFID printing to copy the dirdata bytes into
  a local struct lu_fid via memcpy before byte-swapping and printing,
  instead of casting a potentially unaligned pointer in-place
  (adilger review).
- debugfs ls -lD: added a loop to print all LUFIDs stored in a single
  dirdata entry as a comma-separated list, not only the first one
  (adilger review).
- debugfs ls -lD: added labeled formatting for EXT4_DIRENT_CFHASH
  ("hash: 0x%08x, minor_hash: 0x%08x") and a generic hex dump
  fallback for unknown dirdata types (adilger review).
- debugfs ls: fixed the -D option position in the usage string to
  follow -d alphabetically (adilger review).
- mke2fs/tune2fs: removed restrictions that blocked dirdata from being
  combined with casefold, fscrypt, or inline_data. These were
  Lustre-specific osd-ldiskfs limitations, not upstream ext4
  constraints (adilger review).
- mke2fs/tune2fs: switched from raw s_feature_incompat flag tests to
  the ext2fs_has_feature_dirdata() accessor throughout (adilger review).
- ext2_get_dirdata_field_size(): removed the spurious +1 (NUL
  terminator) from individual field sizes; the NUL separator byte is
  accounted for only in ext2_get_dirdata_size() (adilger review; this
  was causing off-by-one errors in pass2 dirdata validation).
- get_dirent_fid() in message.c: changed the signature to return the
  FID array as an out-parameter and the byte count as the return value,
  allowing the caller to print all FIDs comma-separated (adilger review).
- pass3 fix_dotdot_proc(): preserve the dirdata bits in name_len when
  adjusting the dotdot entry's inode number.
- ext2fs_get_dx_root_info(): use EXT2_DIRENT_REC_LEN(de) instead of
  EXT2_NEXT_DIRENT(de) to step past the dotdot entry, so dirdata
  appended to the dotdot dirent is correctly skipped (adilger review).

Artem Blagodarenko (13):
  ext2fs: Consolidate duplicate min/max macros
  ext2fs: Clean up directory entry handling APIs
  ext2fs: dirdata infrastructure and core functions
  libext2fs: add helper for dx_root_info lookup
  e2fsck: pass2 dirdata validation and repair
  e2fsck: dirdata message formatting and pass3 support
  e2fsck: directory rehashing with dirdata support
  debugfs: add dirdata display support
  mke2fs/tune2fs: add dirdata feature support
  e2fsck: add test suite for directory optimization
  e2fsck: add test suite for duplicate directory entries
  e2fsck: add test suite for dirdata-specific optimization
  ext2fs: share list_dirdata code

 debugfs/debugfs.8.in              |   7 +-
 debugfs/htree.c                   |   2 +-
 debugfs/ls.c                      |  14 +-
 debugfs/ncheck.c                  |   3 +
 e2fsck/message.c                  |   2 +
 e2fsck/pass1.c                    |   4 +-
 e2fsck/pass2.c                    | 151 +++++++--
 e2fsck/pass3.c                    |   7 +
 e2fsck/problem.c                  |   5 +
 e2fsck/problem.h                  |   3 +
 e2fsck/rehash.c                   | 235 +++++++++-----
 lib/ext2fs/alloc.c                |   2 -
 lib/ext2fs/dirblock.c             |  89 ++++++
 lib/ext2fs/ext2_fs.h              |  47 ++-
 lib/ext2fs/ext2fs.h               |  32 +-
 lib/ext2fs/fallocate.c            |   1 -
 lib/ext2fs/inline_data.c          |  14 +-
 lib/ext2fs/lfsck.h                |  47 +++
 lib/ext2fs/link.c                 |  11 +-
 lib/ext2fs/newdir.c               |   4 +-
 misc/e4defrag.c                   |   1 -
 misc/mke2fs.c                     |   1 +
 misc/tune2fs.c                    |   2 +
 tests/f_dir_optimize/expect.1     | 511 ++++++++++++++++++++++++++++++
 tests/f_dir_optimize/expect.2     | 511 ++++++++++++++++++++++++++++++
 tests/f_dir_optimize/image.gz     | Bin 0 -> 102520 bytes
 tests/f_dir_optimize/name         |   1 +
 tests/f_dir_optimize/script       |  36 +++
 tests/f_dirdata_dup_de/expect.1   |  37 +++
 tests/f_dirdata_dup_de/expect.2   |   7 +
 tests/f_dirdata_dup_de/image.gz   | Bin 0 -> 79307 bytes
 tests/f_dirdata_dup_de/name       |   1 +
 tests/f_dirdata_mfid/expect.1     |  35 ++
 tests/f_dirdata_mfid/expect.2     |   7 +
 tests/f_dirdata_mfid/image.gz     | Bin 0 -> 116296 bytes
 tests/f_dirdata_mfid/name         |   1 +
 tests/f_dirdata_optimize/expect.1 |  10 +
 tests/f_dirdata_optimize/expect.2 |   7 +
 tests/f_dirdata_optimize/image.gz | Bin 0 -> 32121 bytes
 tests/f_dirdata_optimize/name     |   1 +
 tests/f_dirdata_optimize/script   |   3 +
 41 files changed, 1719 insertions(+), 133 deletions(-)
 create mode 100644 lib/ext2fs/lfsck.h
 create mode 100644 tests/f_dir_optimize/expect.1
 create mode 100644 tests/f_dir_optimize/expect.2
 create mode 100644 tests/f_dir_optimize/image.gz
 create mode 100644 tests/f_dir_optimize/name
 create mode 100644 tests/f_dir_optimize/script
 create mode 100644 tests/f_dirdata_dup_de/expect.1
 create mode 100644 tests/f_dirdata_dup_de/expect.2
 create mode 100644 tests/f_dirdata_dup_de/image.gz
 create mode 100644 tests/f_dirdata_dup_de/name
 create mode 100644 tests/f_dirdata_mfid/expect.1
 create mode 100644 tests/f_dirdata_mfid/expect.2
 create mode 100644 tests/f_dirdata_mfid/image.gz
 create mode 100644 tests/f_dirdata_mfid/name
 create mode 100644 tests/f_dirdata_optimize/expect.1
 create mode 100644 tests/f_dirdata_optimize/expect.2
 create mode 100644 tests/f_dirdata_optimize/image.gz
 create mode 100644 tests/f_dirdata_optimize/name
 create mode 100644 tests/f_dirdata_optimize/script

-- 
2.43.7

