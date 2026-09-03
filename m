Received: from mail-wm1-f49.google.com (mail-wm1-f49.google.com [209.85.128.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4EF03BD22E
	for <linux-ext4@vger.kernel.org>; Thu,  3 Sep 2026 22:02:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788472969; cv=none; b=M7dwVhWJ9SzC+8m8mtd/c2KDEFGVJo9aOhpsb6ch5uIm+uYlOPsLCDHGW1+UXjEVz3wnTK46kamW1j/tbZTtPrf05UKWxtmshkl2A/7Yen/0kgN1GbqkXUTb3jQfOfrT0ucWtpj1wsVAF7Qh4HJXMJbSUYMXDI+ITx7U0fqcS60=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788472969; c=relaxed/simple;
	bh=y4orxXOw55z5BNsaPUlowMfOryJzbLhUfRWU2oa78jA=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=RkinNYT/Y0Zgr5GHqGufvPMe8qSzJNzVthrSocibz3j3+TRhrt2k/shrLy4PHtaZr4Ya9apuWWCnMSik1OyShl2OOPD8Aq9Br/a1i9aO08ZsJdUeA6WJr3Hig6759gjZAm2IFKMnZ+rY8ha+tHVR/fdhVh48v+eCY2pEYtgXUlc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=gnsKzuAB; arc=none smtp.client-ip=209.85.128.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="gnsKzuAB"
Received: by mail-wm1-f49.google.com with SMTP id 5b1f17b1804b1-49cf4f81d86so2695475e9.2
        for <linux-ext4@vger.kernel.org>; Thu, 03 Sep 2026 15:02:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788472966; x=1789077766; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=IuuiL83izvKfBJnCecdXUwi5pVl5ykAPf6JFGwW6waU=;
        b=gnsKzuABehR938X9uvQCM43gDOIsV7slTwS3w7m55pdViiNGd1yrrPd+GDDdlYMNOm
         laNEbGXXehGtXdQPiJQEOu9sDXGg7LYI1jjlpmPSRPX8S1BgBAJYF2fSpy+8ivQj/n48
         BiiPpmH7ckQoeQ+Lbnjmgvt0BNOPuQRuj/6a8gOn3agNKOpHo8SoxyPXHvJmtY6nMnqV
         MNVYNBj77ik1sVv3mRngkDZRzbRPBYQxtSCfyw2rZGlRKhk7JwAyBMosezhIDB1slJAZ
         gMxGvp4NuEziJjr/a/QjxTdOAiZtap6Bs+Ai/qw/bfbG8MlkqRqACvUetNR870vzloxW
         abwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788472966; x=1789077766;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=IuuiL83izvKfBJnCecdXUwi5pVl5ykAPf6JFGwW6waU=;
        b=oCdjNGNuwLILXlGX1+Jxa1Ym+OKt4TrcuBFbyOdTkldCB/UlWMRW0rP+3VNRpQcid1
         V3cM0HmB+CjMnB0il1tb83+TxxVYE6mY6ejgL/HbVMxhTy7vn7ZyZCsJoLPrVYQaWLH+
         6FV2yZZhFA6mX4XttgQ1XeSiDJjEpkV2mcEwDISIZSZRRp/CE6lqu6qgJpw+tYK0i0M2
         rBNKRCrV0jvGSua36MiYKgeEKMvYj6p2PuJfxk/4Vx0ExKKw0qRhRd40mQTQd/YKbxe1
         g4NdP0Q+C4zJBtPCadaa+XvKc6DO9KXwwOrZJ+YLFwPk/0v7xcI/XIsj8UfEB8rdxVi0
         lxIw==
X-Gm-Message-State: AFuF++k6JesQd+I7revI6KwZqNC86F6xssJT5AKzxHe9ZVYHLaatMcvI
	kJtBEtrYbvMZj1KDsWoPO8uXXVmS4bwc8Jiy4FO4qmXqNbTiQLPbMAmnQgaMTA==
X-Gm-Gg: AYBFou2n5Wn4WoLB9y07iKESGwLp2cDslGfdi1pJNN559iDsIBZFq92B4tr6n7kuW63
	8QtoXAVV4lb4Q7kDPw8nqzuDh+C8/vZwr2zMuFlo2ghm+c1k2v8J/o1h8Kz32JuFIF0Q75txJCV
	JeoHLQEj5Yc2TMexA1M9K+h08Zzs2b0N0pkugkALNgEyszZ6qEPs6h36w7Qs/bpeXPooOAax4XQ
	a9LY6KJTb+acd3fCz/bapNC13dp1wjxtlR8qLuE0rIwUAyBGGdaG+VHVJE3Xg0OaTdKCx44i2ql
	bPdpid8RBTBJ/ArZGxDJnDZNtGnZ79oTxJO/wCIqCOeEl1ywqwl/oEcKUMCtvCUQr5wNGKRufjf
	aaB8HTKlzN3DtFssQ+vD2N1C9dIDav8L84EBatFWFi5m61RcM71SonJDqflfj9rsYfJPZzxRT44
	9BMhHc2W7dkuyXMp/kzyhUMeJwF43O6gKswWjXVbsPyouFD1VPyQnkq+8/dLXJq2+cY1XUf1zV5
	6uhNQBZil1eL0vbbgfn
X-Received: by 2002:a05:600c:548c:b0:49c:c96a:d36b with SMTP id 5b1f17b1804b1-49cf8267dd3mr14213465e9.12.1788472965502;
        Thu, 03 Sep 2026 15:02:45 -0700 (PDT)
Received: from Cluster1.powerhub ([2a0a:ef40:18b5:9e01:f5de:1ef8:371:ee89])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49cee3b0af8sm104346975e9.0.2026.09.03.15.02.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Sep 2026 15:02:45 -0700 (PDT)
From: Artem Blagodarenko <artem.blagodarenko@gmail.com>
X-Google-Original-From: Artem Blagodarenko <ablagodarenko@thelustrecollective.com>
To: linux-ext4@vger.kernel.org
Cc: adilger.kernel@dilger.ca,
	Artem Blagodarenko <ablagodarenko@thelustrecollective.com>
Subject: [RESEND v2 00/13] e2fsprogs: Add support for dirdata feature
Date: Thu,  3 Sep 2026 18:01:33 -0400
Message-ID: <20260903220146.19752-1-ablagodarenko@thelustrecollective.com>
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

