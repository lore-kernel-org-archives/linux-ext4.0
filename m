Received: from mail-wm1-f51.google.com (mail-wm1-f51.google.com [209.85.128.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7602AC8CE
	for <linux-ext4@vger.kernel.org>; Wed, 24 Jun 2026 13:38:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782308287; cv=none; b=p2MC2eRE4cF/qr9544l+khxCS0qjMHjnTd452FuNtOg4JXNGf02rJ5faa3aIkI1R7JbELdLjmlzfDRqBV7uZZsHcaSIpipYPqhcGMk5psHQBGndYIXewoxT1LR2JJy42bhPpTzxXrjuYNlUom3rkH/KnmXnII3+3R3KMVORsUMM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782308287; c=relaxed/simple;
	bh=WqCV022ycSs7oIgbtL7S4hxfZSqxP+wZB974qEJ4qiU=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=It22ObASbd7g0fLVIB5UzSqb57AosWHXCvr5bml2hhEF10zRlwbVzSTyajXKtout4WgmfbRcxtbi1Y9M5sR05j4EjW06Ns8uBX0g7odFqk0NlV9cR3e/M6OcFmxyKMpGhckS0VVsfex216K86ZfnKZ/cg3TZP7QVAiXC24QWQzs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=hVwKmGp7; arc=none smtp.client-ip=209.85.128.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="hVwKmGp7"
Received: by mail-wm1-f51.google.com with SMTP id 5b1f17b1804b1-490b1bbcf3aso5865275e9.1
        for <linux-ext4@vger.kernel.org>; Wed, 24 Jun 2026 06:38:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782308284; x=1782913084; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=46Nlhr8HfchJg4BDwNmp4IEjMH6rk2Yc6IciD19Dw+U=;
        b=hVwKmGp75ISye1An87pAQ6rMs1tdwfFDDgwyrHl1KTseyAiCJKR22taHxr3PCZHtjN
         pCd7USl+r59gR6GAc/RRVklu2BSc631NOkH0sr/ppeOYysrRqCNVi9CaCAcDx5tmO7Ej
         HF8FInM6CcBN5HRrUIY5N5W9uPh3rQbQ6f4tsutcygwka760A4dp0wPg8jA6PWHPhfGy
         qgbNV+gIl9yaKI+Cs5BbTMC2xP4Do+2m03hgbrwHuQY/Eap4C90FhaOvs2GiG/FB3+r+
         ynIkvueSDmzHczBdqbPyQXIUBpFVW8hdQU4ToyIpQoGcPhyyxdVDdnbyrFpSiJU2aBdh
         7F7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782308284; x=1782913084;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=46Nlhr8HfchJg4BDwNmp4IEjMH6rk2Yc6IciD19Dw+U=;
        b=AfvhSusZOoMu3mYfH80leitWZrLRymVd9bcsCdHD/I4ddNpISDNuyxNBBU6e3qoDIx
         dhS2JrAQOG8fZhUskGb9Nv48Ah3PoZib7knIgwYYNWP048xZRcnkRZJAkbEXi6QRdakx
         JkN5/vCoAXN8WFRz4F0Hzsy0axj/JJ65OLj6GT8HVUmLigqXYZOSyS+7+zKyCRxmv8P1
         pdSIPqmPip8WuBr4b+PK2aveHVOeJOm3TnoJXFEhcXYiZ+kdrqPF94mxfrY0rTv1JzB3
         hpBs17J6xMJijhhanccebAe/h0ndmvZAi/Q5ziH32cKjNIadFLhrH02es8Ik8JSr5upU
         YNKQ==
X-Gm-Message-State: AOJu0YzhUcJbUZB0UYduKX+15Pdpi8CRxLyG/zngcSfXhUJ2HclW4xzV
	j/q+KBozAz4LqqoFv6WQV4k3tCan9It30S/GTGIhjYOBSfLbL+1XGpY+F/QNCuYD
X-Gm-Gg: AfdE7ckJaUA3Kug4MWnHxNzUqOdCAb04PBavEdITMOqP8Lhi+aBI0tyPzl7fDdc7vxB
	VEz1yCPi1zBW6qVbUmr0GrVd+6oBPGpXByh35zEsCxnGXlJ7z+EppMAq/S993SM30sFOtm6SAc0
	YZ/8oZzeyvdieDrx3d4Asj2rg5w8hcJRwi9WQdDCJ+cJ5pI1ikAOy3jYe/EKa0fU1WK7R2qRODT
	LMc+r2EZZIRTkwj3m8q9awWc9UxPzeyaHyEX/4pcS9Tnr8a0v/22ggoXDN4QpQuc7Tg79AA5w/v
	vV3LPP/3RUwWhuE5nX/73reFr3sHPFJmAEwUpV1rnTELM0FP1n8i+CNT4b5ptzjg8oC9QKr8HuK
	wLrnvFiJGB3UnL6kb0sqhq44kLY+9vksUaHEdTC8M44qjNp3nc7cCRxm8G6C5BbCVi5MbSobb8H
	7WHfVRNNj2jsstH1pbnZuoioIljlOBpgjjWpm1Nx2ltVtS
X-Received: by 2002:a05:600c:a318:b0:492:4c2e:9613 with SMTP id 5b1f17b1804b1-4924c2e97d2mr223171815e9.18.1782308283557;
        Wed, 24 Jun 2026 06:38:03 -0700 (PDT)
Received: from Cluster1.powerhub ([2a0a:ef40:8ee:1201:acf4:9ddd:6ede:2d9a])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4923fd33dafsm501416155e9.8.2026.06.24.06.38.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Jun 2026 06:38:03 -0700 (PDT)
From: Artem Blagodarenko <artem.blagodarenko@gmail.com>
X-Google-Original-From: Artem Blagodarenko <ablagodarenko@thelustrecollective.com>
To: linux-ext4@vger.kernel.org
Cc: adilger.kernel@dilger.ca,
	Artem Blagodarenko <ablagodarenko@thelustrecollective.com>
Subject: [PATCH v4 00/11] Data in direntry (dirdata) feature
Date: Wed, 24 Jun 2026 09:36:29 -0400
Message-ID: <20260624133642.18438-1-ablagodarenko@thelustrecollective.com>
X-Mailer: git-send-email 2.43.7
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

EXT4 currently stores a hash in the directory entry
(dirent) immediately after the file name to support
simultaneous fscrypt and casefold functionality.

It has been discussed within the EXT4 community that
this hash could instead be stored in dirdata. This
would make it the second (or third, in the case of
64-bit inode counts) user of dirdata.

At the same time, the existing format—where the hash
is placed after the file name—must continue to be
supported. With these patches, EXT4 can handle the
hash in both formats.

The first user of this feature is LUFID -
Locally Unique File ID.

Support for fscrypt and case-insensitive directories
with dirdata enabled has been verified using a
dedicated xfstest submitted to the xfstests list as
a separate patch.

e2fsprogs support is provided in a separate patches
series.

Changes in v4:
- syzbot ci actually ran the v3 series and found real,
  reproducible KASAN slab-out-of-bounds and use-after-free
  reads, all rooted in ext4_dir_entry_len() decoding
  de->rec_len with a hardcoded full-block size even when
  the entry lives in a smaller buffer (inline directory
  data). Gave it an explicit blocksize parameter and fixed
  every caller to pass the real containing-buffer size.
- dx_get_dx_info() and get_dx_countlimit() additionally
  needed dir=NULL (not just the right blocksize) when
  computing past the on-disk '.'/'..' entries, since those
  never carry the casefold+fscrypt hash regardless of the
  directory's feature flags; passing the real dir made
  ext4_dirent_rec_len() add 8 bytes of hash space that was
  never written on disk, corrupting dx_root_info's offset
  for every casefold+encrypt directory.
- ext4_dirdata_get()/ext4_dirdata_set(): fixed bounds checks
  that were off by EXT4_BASE_DIR_LEN (the 8-byte dirent
  header), a LUFID memcpy that used the wrong source/length,
  an out-of-bounds array write for maximum-length filenames,
  and an uninitialized gap byte leaking a stale memory byte
  to disk.
- EXT4_IOC_SET_LUFID: fixed ddh_length under-counting the
  header byte (silently dropping the last byte of every
  LUFID payload), rejected '.'/'..' as targets, added a
  missing inode_permission(dir, MAY_WRITE) check, and closed
  a data race on the shared i_dirdata field by also locking
  the target inode (not just the parent directory) for the
  duration it's used.
- Fixed a missing bounds check in ext4_dx_csum_verify()/
  ext4_dx_csum_set() that let an unvalidated on-disk `count`
  field drive an out-of-bounds checksum read. This bug
  predates this series, but is included as patch 1 (ahead
  of the patch that touches this function) since it was
  found via review of this series.
- Thanks to Sashiko AI review and to Xiao (xiaowu.417@qq.com)
  for reproducing several of the above with concrete crash
  logs and PoCs.

Artem Blagodarenko (11):
  ext4: validate count against limit in ext4_dx_csum_verify/_set
  ext4: replace ext4_dir_entry with ext4_dir_entry_2
  ext4: add ext4_dir_entry_is_tail()
  ext4: refactor dx_root to support variable dirent sizes
  ext4: add dirdata format definitions and access helpers
  ext4: preserve dirdata bits in get_dtype()
  ext4: add ext4_dir_entry_len() and harden dirdata parsing
  ext4: rename ext4_dir_rec_len() and clarify dirdata usage
  ext4: dirdata feature
  ext4: add dirdata set/get helpers
  ext4: Add EXT4_IOC_SET_LUFID ioctl for setting LUFID on directory
    entries

 foofile.txt               |   0
 fs/ext4/dir.c             |   9 +-
 fs/ext4/ext4.h            | 211 +++++++++++-
 fs/ext4/inline.c          |  41 ++-
 fs/ext4/ioctl.c           |  84 +++++
 fs/ext4/namei.c           | 699 +++++++++++++++++++++++++++++---------
 fs/ext4/sysfs.c           |   2 +
 include/uapi/linux/ext4.h |  13 +
 8 files changed, 861 insertions(+), 198 deletions(-)
 create mode 100644 foofile.txt

-- 
2.43.7

