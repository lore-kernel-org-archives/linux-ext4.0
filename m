Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.221.46
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793713851;
	b=G64dnci/Kg1wPekEkvidYrA3U0NJ+CXw9iIShYo3uX2EKmiAoO9vD9DoqyDcJEpyOIE7
	 BV1S3S9P+LSIHGg54/maAFaNZVIwdTA9PjHtSjb/D6bbYdphiSGy1LTOqwQEn+0+ULRpb
	 y6C64WdsdU3CtB1YOS55wu81SnAXCNE8tsfbRMAuBAFXQNevDkOXUhrGjZCr/zUmY2k21
	 73djTJTWfORERiiLcDVuow33q0rg2frPjnnlB926U5fEsEV0nWqKVAcP4YttMKMHh74Kh
	 cTApY91HWCXX6uyvDDP9kNpC/KBfkMvDCqNMQYcS5whsK34lOQKt8kTMFV/Fum+Djxg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793713851;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:
	 X-Google-Original-From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ql0xavnFZfcFRMC6nvgXjYTI2Qh1EbmHPWy1X8Q21CM=;
	b=wd3GxwgeAOXOmYIJolKAOPBhbucUI58uiYKuNaxTrqAgzS1tPVDrrIpkjwoLV0+v+KJf
	 o9N6e7eNhaBebpOhdkUCtHolMxxkdyBBFXh2qMny0E4JLVTsbv5azgoQCWBZ5QSE8NwhF
	 9wiCv9X9jdVl+ZqqxvPJvSRbVhXfo1QOT5u7AkcyOvX84dMuHNWvUTXGZyQs/g2C8I6yU
	 xjI8ObSyorbQLI8qnvyWQh7ttPpB71Rl1zUQ8N4XEamux1+PNmd7RSI2OL+sWLO8tXWBq
	 gRIf33eNBZMWf5K4JNyMy5wFvCMgvoPgjJ0+QrY8hDNImPXhw+3cQmPZUSVyp6bG5nQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=awMAI13i;
	arc=none smtp.remote-ip=209.85.221.46
Received: from mail-wr1-f46.google.com (mail-wr1-f46.google.com [209.85.221.46])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 782E3606D815
	for <linux-ext4@vger.kernel.org>; Tue,  3 Nov 2026 13:50:51 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 782E3606D815
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=awMAI13i
Received: by mail-wr1-f46.google.com with SMTP id ffacd0b85a97d-48df0fa43c5so486160f8f.0
        for <linux-ext4@vger.kernel.org>; Tue, 03 Nov 2026 05:50:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793713850; x=1794318650; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=ql0xavnFZfcFRMC6nvgXjYTI2Qh1EbmHPWy1X8Q21CM=;
        b=awMAI13iiREhva7TCwczVsIJT3XwUDpaMaNg0w2wNa4Ke+8ly8seYsQLXcbIyldxyv
         U7kbEkxBKeKRiTiHPV3gkpCYfsGFhoNQuttbOUDzlbvAhVdTcj1gE94R8G4Xq8GvLPhi
         fl9bdmJQzjCFHTQ+mX623gPi9qNYQOBD/BA3/geotrrXCpgRDsB1EKexBKVRnX6GyMGe
         XDrwwvlyeZwpxZFswbgi3siuhgdydNL/PiD9kWWvNwghkJpm3UxXiyJZEPnTW3fGbiD+
         pJbLvoty/gaFcj8xRU//JtPizWyfFO0naQajlDEdiroRBrMAJSgDvEzQaHpqfGAm2Kgu
         4CPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793713850; x=1794318650;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=ql0xavnFZfcFRMC6nvgXjYTI2Qh1EbmHPWy1X8Q21CM=;
        b=jc9g61KKRTOFIwUW+O0ZjneKmdgJ5iwC+gUOjay4aDcwWIPA86lbtZELA8fnROGAcS
         1A6Mr76MiBcdKQJcPcq4Qlww14OqZjFv4KCKNgzgncfOMyjvQxlsc2yozEytEBxuFcVv
         h9y2MZpkfKM/698fZcRgp3cQ33R79qkrMssSXb1Wxt49F+/TmBopWMCabZugFdXnTBPN
         91exRfu8Iqxdeau/ilJhETmLU41v5xZCVWLQaBuOJGWWW7mMJ1Id0Z7u8RJ3JXxGWkRE
         wufy7PoIGR5Hy+BJ9eE+h+g3soXdcJVG9ErCVYgeD/W57tEULPqj6dcxzHTi9GgsmfNl
         ICUQ==
X-Gm-Message-State: APuU4Z+ZZ3qT/fYXKWE69qywBBqY1M8ZVjpRK15PmbtzV7RPWmsy/YCw
	19SZD6JeHUGS64PHbeJAoOoujDPLjMaNIZVysDz9HZ+VD5UsNadFWmmwwgYhKnJXmhU=
X-Gm-Gg: AYBFou0FPdX9zq0nqbFWE4Ww9xqTIRNEMAoFLG2cJyXcK21HncNcDbbHX4AgKiF6mPu
	Ye2SyirGXMNLPiD75ueKmSe/M+YJy6elqu2OuBD4uTTOLoTZJIp/ylQtrqy27zB1KCvHgRUg89h
	kpBoayvs5nEYi3QZCWqUT8WgGbSiWbMmlJv3zxIIEngH7eyPxhxRkHumSO4VLB2uLJAC4TYnpUt
	D8b2I/sD/RoZCJPLiMvChvMA+o260ZBNxRLQCuOO4VkM2pOwaNGVlXZFPAo0pfuZ6GLvT14rQrP
	OS7r6QotG/NhWfkHkQ6iu1mYlnDP0haKa26pf6m8tyM74T+nrt+IhsTBOuRIyw4/0q6QDuuk0jq
	wY24pGXamIvAENIlck2HOw3a2yX5VEPDnakTcgoPpKbkI9j5kN+jYXYUDN0ZBuik6lR8yBPLRMI
	U3Fe3NllJ58x2OJ/KDQC1IwRsw1X6Z7beAubyxuj6Vs1HtQIF0fL8DQLV7/Trls1rDC8HOaqeYj
	eOi10kRNtznUL9OCNkhHAq/FMh8A1klqRVlUwjEeJY+smx4LHvZ13mMcVSbsU+2ezzizsAMMViu
	iw9StKvxPJA3eQw0Gl3iFhHoH+U4RovGyyGlsyfWpVXO8qsWSAUzdmBx60hw
X-Received: by 2002:adf:f00f:0:b0:48e:6625:4190 with SMTP id ffacd0b85a97d-48e662541a3mr26342590f8f.7.1793713849704;
        Tue, 03 Nov 2026 05:50:49 -0800 (PST)
Received: from Cluster2.powerhub ([2a0a:ef40:18b5:9e01:225:90ff:fefc:9ffe])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48e71b78a6bsm25036829f8f.27.2026.11.03.05.50.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Nov 2026 05:50:48 -0800 (PST)
From: Artem Blagodarenko <artem.blagodarenko@gmail.com>
X-Google-Original-From: Artem Blagodarenko <ablagodarenko@thelustrecollective.com>
To: linux-ext4@vger.kernel.org
Cc: tytso@mit.edu,
	adilger.kernel@dilger.ca,
	ablagodarenko@thelustrecollective.com
Subject: [PATCH v4 00/13] e2fsprogs: Add support for dirdata feature
Date: Tue,  3 Nov 2026 13:50:24 +0000
Message-ID: <20261103135037.610132-1-ablagodarenko@thelustrecollective.com>
X-Mailer: git-send-email 2.52.0
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
  [PATCH v14 00/12] Data in direntry (dirdata) feature

Changes in v4:
- Patch 05 (e2fsck: pass2 dirdata validation and repair): add
  ext2fs_dirent_hashes(), which finds the hash of an entry in a
  casefolded+encrypted directory in its CFHASH record on a dirdata
  filesystem, and use it for the htree min/max hash check.  Pass 2 read
  the hash at the fixed position after the name, which in a dirdata
  entry is the CFHASH length byte, and reported the leaf blocks the
  kernel wrote as having bad min/max hashes.
- Patch 07 (e2fsck: directory rehashing with dirdata support): read and
  write the hash with ext2fs_dirent_hashes(), so that e2fsck -D orders
  such directories by the same hash as the kernel.  Before, the kernel's
  next inserts made the rebuilt index look unordered to e2fsck.
- Patch 13 (ext2fs: share list_dirdata code): copy the CFHASH record
  from its length byte; the shared copy started one byte late and
  printed shifted hash values.
- Found by testing with kernel v14: 12000 255-byte names in a
  casefolded+encrypted dirdata directory now pass e2fsck before and
  after e2fsck -fD and after more kernel inserts.  "make check" passes
  (396 tests, 0 failures), and every patch builds on its own.

v3: https://lore.kernel.org/linux-ext4/20261029122744.230678-1-ablagodarenko@thelustrecollective.com/

Changes in v3:
- Rebased onto e2fsprogs master (8fd79523 "Merge branch 'maint' into
  next").
- Patch 07 (e2fsck: directory rehashing with dirdata support): adapted
  to the calculate_tree() rewrite in 0e4de3c7 ("e2fsck: large dir
  rehash fix"). The new fill_index() code is kept; the only change
  there is that set_root_node() now takes the "." and ".." entries, and
  the root limit is found via root_info->info_length.
- No other changes. "make check" passes (396 tests, 0 failures), and
  every patch builds on its own.

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
 e2fsck/pass2.c                    | 154 +++++++--
 e2fsck/pass3.c                    |   7 +
 e2fsck/problem.c                  |   5 +
 e2fsck/problem.h                  |   3 +
 e2fsck/rehash.c                   | 249 ++++++++++-----
 lib/ext2fs/alloc.c                |   2 -
 lib/ext2fs/dirblock.c             |  89 ++++++
 lib/ext2fs/ext2_fs.h              |  47 ++-
 lib/ext2fs/ext2fs.h               |  54 +++-
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
 41 files changed, 1752 insertions(+), 139 deletions(-)
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


base-commit: 8fd79523d051d5ea881237f27eb1c664486e0078
-- 
2.52.0

