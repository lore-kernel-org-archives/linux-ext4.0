Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.43
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793276880;
	b=JHCmMox+K4pS+tLGLaPLPeHsmeTsauzEXoLuU1xcDIrtHheVlp1YhASxPGhac+bSRbzT
	 eXRpywE2FLeJAn7lIMFzxTahuDGmCn9meBXElyESOr+3oNKqusyFSrgDOaJOK5rOawAi6
	 KqcDKmMASZElfUz+pBXEVvxaOkvc40CN+jAXLrgADG8TiKR63fYXyemV/8Rb1BI17sYhK
	 7e7H2HdIqX39LmfdvmhHEx0zkzDNhqg+BTD+2RMeoUhLNRw7TmEsmhFyeCgcqKxYcO3x3
	 BDlqd01iX/JEW64Sxl4IHbzS1ZcgH6LWsyKYAmCay3u0JbXMoR9SPu4XOtYRD5g5jZw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793276880;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:
	 X-Google-Original-From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 MIME-Version:Content-Transfer-Encoding;
	bh=di6eLx91uy94f2jb8K7cWw1KNOJApZwvlckgI21+qro=;
	b=dF4j92myxh6Pefj1RZ43zoP4GmYaOV4E/uXkU3MxZ81UIprsKjJYkNipjwr3elk5wUWX
	 dEppU6oQYdw6y6tw2eGznDNWSCjothvLaIS2XCBOenqeEdPaMUNtJOSX4yyoicES8dYbJ
	 cwXs9kwads3BkChHNl1N9JubimduYXZCPJ2AAQCZqA5GRrNyzZOVhdkH9gdYWhbz/IpeJ
	 mBVS/jFL2ZFHUBwoHNcgHnYj81iEao352u6+vSwQ0CA14N8vOxAaFi/4O/fskcWyaRqKR
	 835z+/u5Jb+LhQQEX689E9JQiRwY1CDcgbTz/fXfX1rAXwV20folqWscW3MpV7VgpPA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=szUsmOyq;
	arc=none smtp.remote-ip=209.85.128.43
Received: from mail-wm1-f43.google.com (mail-wm1-f43.google.com [209.85.128.43])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE325606A31A
	for <linux-ext4@vger.kernel.org>; Thu, 29 Oct 2026 12:27:59 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org DE325606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=szUsmOyq
Received: by mail-wm1-f43.google.com with SMTP id 5b1f17b1804b1-4a207b02a2cso14424935e9.1
        for <linux-ext4@vger.kernel.org>; Thu, 29 Oct 2026 05:27:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793276878; x=1793881678; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=di6eLx91uy94f2jb8K7cWw1KNOJApZwvlckgI21+qro=;
        b=szUsmOyq/JSAu92l67+mmcmEtFc9NOfKk3T2iRKf6/fGfq+rGGn+df3vX63xEchYrV
         XBE15On6Mfyjwei8wK42aCDuSujmdpdPQuDFgkdlfOQEm7cIxsi8hnaknbORgGny6OPI
         F6Mo7+fKUVP4TtRLFepkGKXXMnTCZ/BYiV5YvLF8odY3uvyd9nNN3eONTeLIEspQXwdB
         J2VxhPTg1JQmHRoCCA5IzEQ6I1oyHjKlh+Y2FDU5TQc8XsrOUBvR4kpy95+L9u4hfZfH
         CDsUUAEPzm4zAcagfXun918erhzUCBdCajccmce4UfxDQQZfevkmtsD1FB1CaT5tt0cL
         9+TA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793276878; x=1793881678;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=di6eLx91uy94f2jb8K7cWw1KNOJApZwvlckgI21+qro=;
        b=fp6Mpmc3JtPKB+mNDREjoCVy9KgoXmhfgDq3ePbaMBMO8J/YZh5LE2GvR8IEm3vR60
         8qx/U6r0/s96QA7LEY/bqFZB2UA5PfWXYYtPjISqQiuYFGLuyeSPsAqoH2RwxTz9/Epe
         KDwxMiTOeleUJkI12sRKLos7hG2hKMbYDZiERRQ9+TZVSD61WcRNJG4FjJkCnxm2f+Gs
         YK3WpjOvoK7P+MzAgOn1P7dPLxPe3iWqXVoZhAqHsY8ONA0HU/TNEbTQ/ralUotZE5OS
         D/dsOE40gUD5NBUi1SJwPOjhTIMS3Qw4PqRAMsmN2tAOooaKsLPVSuUXMMQL+vYgagKA
         RA+g==
X-Gm-Message-State: AFq9FYLV+ceYax4g4KbZpaceRTYqvSGrmXRJ082xArRp/vt3YHdMnuJs
	KurGnaFLatYzbG7oaH0ndo5np4nqiA5epdaZwSWzg8QfiHYobM4+zQsescgvNGBu
X-Gm-Gg: AYBFou1NYj3cfTDs8U+FYHQ4zeWIZKBCdXpsN+lQ2CY/PfHyyTa7ng6hkTpjksUlyFq
	0o+2Lnce/AXalbDo9sNsoqhm3oKlVMlqzN54Yry66a7WBjTp7hNqckfSvoYJxK8ipXHaNfW3U8b
	uMCXfzaHxs2xRXQMNXEZVNZ3ZCu9NwRuco33CgGBKdRxw8j7ijtvMDU0Uy9GpOMvACLuihoX2tE
	p5E0RpfXUrQ5Ii6kou+TFkLsTSjJ1jMG016kMwVffmytk2ZrnmWGUV4o7BmypegEBvHXMWzs2Hh
	qcTJkYhp7treVt1cgZl5Rtjxrj93ZiA1kD05TRh0CUMtxXhbCl6Dsmd0ko+i9HxPuC7fvTROYVt
	c32oGl7btNZ34sFWOFZ3DUFFRugkVBkEo/fxhIgbYCTYzR2ujAazxJu7711CqYPWgt1AVApyvFE
	LCYDBZOMppJS5u3nCGD/r2fqhafOWPPqSUzg2BXo5gSoy7jFMblLGPfkvLr6DeKIvWtyfiyuWmS
	Xkkp4vOEGJZ2nlmXGIed9ZlfmEnHyziPtmdn0fJ2zIG6o5jCObGuZ348aIrUY9UcDavSBSK4WGC
	JRI0SePErkRT8MJ7aW4ReZOoVxkf/QVRThkFTkKLqkEI6q7l3OVmk6p470u8
X-Received: by 2002:a05:600c:848c:b0:4a2:397:73f6 with SMTP id 5b1f17b1804b1-4a966490754mr134923325e9.8.1793276878203;
        Thu, 29 Oct 2026 05:27:58 -0700 (PDT)
Received: from Cluster2.powerhub ([2a0a:ef40:18b5:9e01:225:90ff:fefc:9ffe])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4aa7f322c46sm59729615e9.2.2026.10.29.05.27.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Oct 2026 05:27:57 -0700 (PDT)
From: Artem Blagodarenko <artem.blagodarenko@gmail.com>
X-Google-Original-From: Artem Blagodarenko <ablagodarenko@thelustrecollective.com>
To: linux-ext4@vger.kernel.org
Cc: tytso@mit.edu,
	adilger.kernel@dilger.ca,
	ablagodarenko@thelustrecollective.com
Subject: [PATCH v3 00/13] e2fsprogs: Add support for dirdata feature
Date: Thu, 29 Oct 2026 12:27:31 +0000
Message-ID: <20261029122744.230678-1-ablagodarenko@thelustrecollective.com>
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
  [PATCH v13 00/11] Data in direntry (dirdata) feature

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
 e2fsck/pass2.c                    | 151 +++++++--
 e2fsck/pass3.c                    |   7 +
 e2fsck/problem.c                  |   5 +
 e2fsck/problem.h                  |   3 +
 e2fsck/rehash.c                   | 234 +++++++++-----
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
 41 files changed, 1718 insertions(+), 133 deletions(-)
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

