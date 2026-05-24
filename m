Received: from mail-wm1-f44.google.com (mail-wm1-f44.google.com [209.85.128.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 129D3311969
	for <linux-ext4@vger.kernel.org>; Sun, 24 May 2026 20:37:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779655048; cv=none; b=kAssZtjbzgCUdoD+G2H8wX7KE2D+lIo+McHTAhMmKk7f0Le/QX0sepbZBmxl16cwd1hYGsEcjQYnSSMBDvTjLCSltTJ9p4Cu7Vy3FmrpHZQFPj3Rlp7d+sbrM3Wzh8MNEO2ZtRdlr154eYnsFpe57MDws8lrdveYyRonwyGZvAA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779655048; c=relaxed/simple;
	bh=WJ2436+19UxA9bV0bsWlrdhM6+5WTvC4ZYeFsbKHfC8=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=kvrf7vx77pNHOFetzdhlMJbzQ0XCRIF0KfX4ZoVr7ZcEJ4LYG41QNSAFBJO0kAdM2FJ2FFZF4ohXUcDerx8E5XBunGfE/7ZeLGLmji/8oG07XDPzvtg7410bVfZcRNBw83Lyywz1ghBfg15drPR4PD8AW9KvTUKNnGzWcS+Twco=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=qeeLLMA6; arc=none smtp.client-ip=209.85.128.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="qeeLLMA6"
Received: by mail-wm1-f44.google.com with SMTP id 5b1f17b1804b1-48d146705b4so95020175e9.3
        for <linux-ext4@vger.kernel.org>; Sun, 24 May 2026 13:37:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1779655045; x=1780259845; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=p9MQdGhqO9nTzJebkyJsS0X83oLrOsluTMeAwiU1K2k=;
        b=qeeLLMA6VvZZskCeT1Ah2/7DTIiFPTcuBzdeliLhGFesquCe0+OPVUpHea8npG0Utz
         NtKGhp9hArNpvF4fwKzB6ba48mdIi0WRD4yIlN5CdFp4rEdnVnPd+zo5lAW3z+m4dGa5
         +rjE0ShVlK0RXPSQk++no4777D+BHdlRYxLkt7/YKgzw8i6tpiI/lB4/VrU7HHs3oi0K
         HPYM+PirgsB2YPWLZ6iwkbVYfTXHstazH1zJUN1vCidI/aoWovYxfZOs7hrAmUpNrYhE
         ktAwi7S1hn6s2t8VdHEJrjjR8KQoKMxe7Uy0c0fV+4obeHAsi6bCRT9IaZ21MCpC4w54
         cEIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779655045; x=1780259845;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=p9MQdGhqO9nTzJebkyJsS0X83oLrOsluTMeAwiU1K2k=;
        b=MDxCmUOlwpnliAEcYcQbmXvXa3s4eaBY83Mppwta/HQPmcaNfHy2EWqiUXG8qSWUA6
         PXpb/gfIfx3Olund+zFtXOSvRxkDW7xiDkv/UWlqihjQDgMDscYyXEHGXaAPEjur6rhC
         sD7u85oMU4r9DqtFS3kH1T/nylRrpA08kFSBjC/ElM4LGSQulxO+0/e+XD0aqwFuZ8sG
         YnZv/8RbrzCW60IzvYJ9bq5hbC+qx3EQcomHyR+6QODhHwlP3AgnCFHLLMbD9Ve6y5il
         nULagWIz/A7ZC3cCrPUsCIhgZ8+YGS9ntieXpDuPyorEIBErmgw6etaT8ZSLKFj7zOEO
         sDXQ==
X-Gm-Message-State: AOJu0YytiIceUMjxLMqtef0/i/rOSepi0mh8g16bA0oRLhX4R9Pm8kRr
	dpnHkBQqCQlhHnTbrH0A/jQ7nnz2nTEwClfzj0bjwm1Qas2lUrjOL33pmAs3Gg==
X-Gm-Gg: Acq92OGA+1e17HRRaTGRDVRn6G0Axm7ID/GI1rleXcO+zvBscP9/9MvXHlxl2B62qBa
	HgB4Kx7fhAsllitk8H9RHbKL/F9pL4PS6+GU5K5IJ/Dt+kQPqSfBPWz/he6jBGmnSvZprgtyawi
	YXM9j99FyCYOmneZ9YWPX0eddIabzPCNVKq5PlZ+u5NiB8tcvICNrTQewhsipYwsbhv7PaRWL0C
	OuDgAduYWSfEm7Wrae9japy1wv3mehq/VsiJhBpLv3q1JBoexCdzq2B36H/5iccY/MpRtF2iRnV
	AbAQeKUZJSEblHlKTSufcznt+Vr+u8ffyLkws2lg08wIDKCjnB1tDPR8yll4i/iNc3JwgRgTaR0
	MY3eqQJKaG0Gvj5kuQOPmPeJRCcWm3swP41a7fH/FsJC2AhuYkAaxC0VcSKiE6Bobx5JIkAGRXS
	QTPcz5gYvNC6ShK4cJP7RCqkYuvKU+p1WSj8VNRh++gP99qqpvOo8=
X-Received: by 2002:a05:600c:4ecc:b0:490:3c15:7146 with SMTP id 5b1f17b1804b1-490426cd872mr192729475e9.19.1779655045300;
        Sun, 24 May 2026 13:37:25 -0700 (PDT)
Received: from Cluster1.local ([2a00:23c7:90c1:9201:ef47:d559:d907:fd0b])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4904526ca50sm187279145e9.2.2026.05.24.13.37.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 24 May 2026 13:37:24 -0700 (PDT)
From: Artem Blagodarenko <artem.blagodarenko@gmail.com>
To: linux-ext4@vger.kernel.org
Cc: adilger.kernel@dilger.ca,
	Artem Blagodarenko <artem.blagodarenko@gmail.com>
Subject: [PATCH 00/13] e2fsprogs: Add support for dirdata feature
Date: Sun, 24 May 2026 16:36:45 -0400
Message-ID: <20260524203658.12406-1-artem.blagodarenko@gmail.com>
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
- unique 128-bit file identifiers
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
  with the -ld option for testing and debugging
- mke2fs/tune2fs: user-visible support for enabling the
  dirdata filesystem feature

The series also adds regression tests covering directory
optimization, duplicate directory entries, and dirdata field
preservation to ensure metadata integrity and prevent directory
corruption.

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
 lib/ext2fs/dirblock.c             |  84 +++++
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
 41 files changed, 1714 insertions(+), 133 deletions(-)
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

