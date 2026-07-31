Received: from mail-wr1-f53.google.com (mail-wr1-f53.google.com [209.85.221.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F7CA3438B2
	for <linux-ext4@vger.kernel.org>; Fri, 31 Jul 2026 15:38:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785512330; cv=none; b=EO6rZiDUDuDm/GCdiIQZ/a376MyGHPKZ3hvB5LhnZjG1Gmr/PxpJIgmZRQO8pvTyn2Iy9ncWSnvlI5iIpGyrDj5/pJeOHh609wulp8OocfPmiwo6P+ldNCULJBHhq4egB9mMOLBnAu5G6a31o1Mjz5GMqnD+6aoaGFYNRS9HyPI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785512330; c=relaxed/simple;
	bh=HCZhlHdTp73pVHbIwQQ2OULmVPHoiY8qzInRG7Ovr0k=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=j30qf4l/87/+Bj7SG9WD/+ADKXgKufmSJ+fYYA1LFK1txC4JYL/LnREJCJ75euDfBBYL/h6EKEGYxqve1GxlBRbARMa1ZVA2M1zDzJz9NUVpghTJGuAMp5UvlVlzPHUPiTh7neX29w1/uAfNokbgeMnPVgBDEX6g6+kYmpvxaq4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=fQRLoxtA; arc=none smtp.client-ip=209.85.221.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="fQRLoxtA"
Received: by mail-wr1-f53.google.com with SMTP id ffacd0b85a97d-47f7872abb6so843912f8f.3
        for <linux-ext4@vger.kernel.org>; Fri, 31 Jul 2026 08:38:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785512327; x=1786117127; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=s3euOcSUJ3o7wydN8DsXONAlft5VwhPXsM8HRV9Fgxg=;
        b=fQRLoxtAXXfV72v8JDe4fnpx86Hf9HnGMaSfJaCv5/noHQ4XinJclxq3aynn9oeOz3
         UT54R4Nj1Zs2YVuYOpL7fLQuaLOOtUHrvHaGEoeBBu7qR8l69Mt6eWc2lMsRrX1uOiO0
         9UW6sQrwbsQUHfwdBGbh7JNNCitZAyWtLZXgPKZZQVG4LIky5qkJoq+g1ad0AJJwozqU
         h2Ruq9SRx+Cgx1mZLVLN6iOHs7cpgHryokS5Aau45b+U+1allUTOMUKpde5zlAmzFrVk
         JQvqf1QoQsNLt21C8bqanBEbqbK5LLUqQRFwYaH7Q3GhWofB1yzD6cnckHpbO48BDPDT
         WyMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785512327; x=1786117127;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=s3euOcSUJ3o7wydN8DsXONAlft5VwhPXsM8HRV9Fgxg=;
        b=ONoXJ1Lvzh5xjFc39z4ZFpyMalf6YZBc3NbDfqEfTE57tuskjvu5xuAMkv4Y/JtF7a
         SX3yIYOJqzgpTfBNH9l7w0x4YTebVcVOVMk4l1jT6wOSFs0Q7dXvLOgGegU9Td9rhm5u
         LqcYJJ555qKNgwII8ZnUk6PVWPLYMjCYGnm8iYCF1+CeHjyLt2GjDOXzWM1HBw8A0UHS
         6PgwHbRifJaibSpQ/xq2Bl27EIcDoGhxZGvrM4flV4q8EQgNUWT4sD6L1qTyX1qrdfng
         nTZ+8a8c8jI1hF4vojob/CkFv2kTISjAeXu36gbYwS/NknQcX6N0ebKyFon74ZQMSkzn
         oJnA==
X-Gm-Message-State: AOJu0YxmKx6eHuwO3dIeNDx802G59lSX+OSLLntYx9Qk0+rdOrcrZUsH
	UX0rTm+n5edKWwPxbLeFtSZHK73wE4Ufsc2/l1bPL93QeAo/jKeFYCMxtjpaLZGc
X-Gm-Gg: AR+sD10AcbbfmOjiYRJIh+2GU2H4YWm7l/CSRBGc8IulMpj3XCg3sxDTskI36zSF+bW
	KL/tRpCcdRSlfjJCzlSEoQqZhoWiTkoaNyBDIsi2d0U7NOG1261Ic0bOo/+hhpDr6nLqXw8xLLT
	KZF4Oaw7PJhF2AeLYCBaCmqcQFnzXgxwH4rADhiev4jWCUeoYhGTrWqLOWWeuuF732lPyfWOb18
	I15QHdAwIRlGvhPAVDMPyRZwEFlUcYilPKLyZedEd6q/JqGeyza6m0HM8ZmXCee111/Cd2xJI6l
	bJe3SkkBipwZuJ8a04DBrV1lm3krxcmP1cYa9XsgFUB4yB+nyjS/t7CkL73VPER/vmwTJPJkZKl
	jbIelo3vtfTK/DKSQGVIAVvbixGOwkOUS1Vnb9dDs3GQHfTwu5nbQgRuGltAtHmtpL1slWDRIDb
	YRvrZdNqx2eh/jliGiiMG1YWpc/B5uRZb7w4Fh3FQeaMlMCyv1+hFNyCcH6VOEpK/s63abcmhZj
	yFTFLiMKeNayOZaEEm0
X-Received: by 2002:a5d:588d:0:b0:47f:7129:e30 with SMTP id ffacd0b85a97d-47fd72a8e52mr301624f8f.11.1785512326417;
        Fri, 31 Jul 2026 08:38:46 -0700 (PDT)
Received: from Cluster1.powerhub ([2a0a:ef40:18b5:9e01:f5de:1ef8:371:ee89])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-47fd41cfde0sm5098345f8f.3.2026.07.31.08.38.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 31 Jul 2026 08:38:46 -0700 (PDT)
From: Artem Blagodarenko <artem.blagodarenko@gmail.com>
X-Google-Original-From: Artem Blagodarenko <ablagodarenko@thelustrecollective.com>
To: linux-ext4@vger.kernel.org
Cc: adilger.kernel@dilger.ca,
	Artem Blagodarenko <ablagodarenko@thelustrecollective.com>,
	sashiko-bot <sashiko-bot@kernel.org>
Subject: [PATCH v10 00/11] Data in direntry (dirdata) feature
Date: Fri, 31 Jul 2026 11:37:34 -0400
Message-ID: <20260731153753.28309-1-ablagodarenko@thelustrecollective.com>
X-Mailer: git-send-email 2.43.7
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

EXT4 currently stores an 8-byte hash in the directory entry immediately
after the file name to support simultaneous fscrypt and casefold
functionality.

The dirdata feature provides a general mechanism to store multiple
metadata records in each directory entry after the NUL filename
terminator. The unused high 4 bits of 'file_type' indicate which
records are present; each record starts with a 1-byte length field,
providing forward compatibility.

The first user of this feature is LUFID (Locally Unique File ID), an
identifier that must survive rename and be accessible from directory
readdir without an inode lookup.

e2fsprogs support is provided in a separate patch series.

Thanks to Sashiko AI review for identifying several correctness and
safety issues in earlier versions of this series.

Changes in v10:

Reorder patches 4 and 5: "dirdata format definitions and access
helpers" now precedes "refactor dx_root to support variable dirent
sizes". The refactor patch uses ext4_dir_entry_len(), which in turn
depends on types and functions from the format definitions patch;
placing format definitions first makes the dependency explicit.

Patch 04 (dirdata format definitions): restore ext4_dirdata_next()
helper. v9 removed it as unused dead code; it is restored as a public
accessor for external consumers of the dirdata format (such as the
Lustre filesystem module) that traverse extension records without
going through ext4_dirent_get_data_len().

Patch 05 (refactor dx_root): fix OOB write in dx_get_dx_info().  The
bounds check ensured only sizeof(struct dx_root_info) (8 bytes) fits
after the '.' and '..' entries, but callers in make_indexed_dir()
immediately write the full sizeof(struct dx_entry) (8 bytes) that
follows.  A crafted image with '.' and '..' lengths summing to
(blocksize - 8) passes the old check, places dx_info at
(base + blocksize - 8), and causes all three dx_set_*() writes to land
past the end of the block buffer.  Fix by adding sizeof(struct dx_entry)
to the guard.

Reported-by: sashiko-bot <sashiko-bot@kernel.org>
Closes: https://sashiko.dev/#/patchset/20260731005430.36801-1-ablagodarenko@thelustrecollective.com?part=4

Patch 09 (LUFID rename support): fix two duplicate
ext4_fc_mark_ineligible(EXT4_FC_REASON_DIRDATA) calls.

  - __ext4_link() called ext4_fc_mark_ineligible() before invoking
    __ext4_add_entry(), which calls it again when a LUFID payload is
    present.  Remove the redundant outer call; __ext4_add_entry() is
    the authoritative site.

  - ext4_rename() called ext4_fc_mark_ineligible() unconditionally at
    the top of the dirdata block for both the !new.bh path (which goes
    through __ext4_add_entry() and marks ineligible there) and the
    new.bh path (which calls ext4_setent() and needs the mark).  Move
    the call into the new.bh branch, after ext4_setent() succeeds.

Reported-by: sashiko-bot <sashiko-bot@kernel.org>
Closes: https://sashiko.dev/#/patchset/20260731005430.36801-1-ablagodarenko@thelustrecollective.com?part=8

Patch 10 (dirdata set/get helpers): fix OOB read in
ext4_search_dir().  ext4_match() calls ext4_dirdata_get() for
casefolded+encrypted+dirdata directories, which decodes de->rec_len
and uses it as the upper bound for all pointer arithmetic.
ext4_search_dir() previously validated de_len only after ext4_match()
returned.  A crafted block with de->rec_len encoding a value larger
than the block size passes the loop guard and reaches ext4_match(),
allowing ext4_dirdata_get() to read past the end of the block buffer.
Fix by decoding and bounding de_len at the top of the loop before
ext4_match() is called.

Reported-by: sashiko-bot <sashiko-bot@kernel.org>
Closes: https://sashiko.dev/#/patchset/20260731005430.36801-1-ablagodarenko@thelustrecollective.com?part=10

Patch 11 (SET_LUFID ioctl): three fixes to ext4_dirdata_set_lufid().

  - Enforce IS_APPEND(dir) on the parent directory.  The ioctl calls
    ext4_delete_entry() directly, bypassing may_delete(), which is the
    only VFS path that enforces append-only semantics for directories.
    inode_permission() blocks IS_IMMUTABLE but not IS_APPEND.  Add an
    explicit IS_APPEND(dir) check consistent with may_delete().

  - Restore the original LUFID on rollback.  If ext4_add_entry() fails
    after ext4_delete_entry() succeeds, the rollback path previously
    re-added the entry with no LUFID, silently orphaning any FID->path
    mapping the entry carried.  Fix by snapshotting the on-disk LUFID
    before deletion with ext4_lufid_snapshot() and attaching the
    snapshot to the rollback dentry's d_fsdata, so ext4_add_entry()
    restores the original LUFID.

  - Preserve on-disk filename case for re-add.  For non-encrypted
    casefolded directories, ext4_find_entry() matches
    case-insensitively, so de->name may differ from the caller-supplied
    filename.  Using the caller's form for the re-add silently renames
    the entry.  Fix by copying de->name into a stack buffer immediately
    after the phase-2 lookup and using those bytes for both the new
    entry and the rollback entry.  For encrypted directories (with or
    without casefold), de->name holds raw ciphertext; use the plaintext
    d_name instead and let ext4_fname_setup_filename() re-derive the
    ciphertext, avoiding double-encryption.

Reported-by: sashiko-bot <sashiko-bot@kernel.org>
Closes: https://sashiko.dev/#/patchset/20260731005430.36801-1-ablagodarenko@thelustrecollective.com?part=11

Artem Blagodarenko (11):
  ext4: validate count against limit in ext4_dx_csum_verify/_set
  ext4: replace ext4_dir_entry with ext4_dir_entry_2
  ext4: add ext4_dir_entry_is_tail()
  ext4: add dirdata format definitions and access helpers
  ext4: refactor dx_root to support variable dirent sizes
  ext4: add ext4_dir_entry_len()
  ext4: rename ext4_dir_rec_len() and clarify dirdata usage
  ext4: dirdata feature
  ext4: add dirdata LUFID support for directory entry rename
  ext4: add dirdata set/get helpers
  ext4: Add EXT4_IOC_SET_LUFID ioctl for setting LUFID on directory
    entries

 fs/ext4/dir.c             |   49 +-
 fs/ext4/ext4.h            |  237 ++++++-
 fs/ext4/fast_commit.c     |    1 +
 fs/ext4/fast_commit.h     |    1 +
 fs/ext4/inline.c          |   67 +-
 fs/ext4/ioctl.c           |   85 +++
 fs/ext4/namei.c           | 1264 +++++++++++++++++++++++++++++++------
 fs/ext4/sysfs.c           |    2 +
 include/uapi/linux/ext4.h |   14 +
 9 files changed, 1470 insertions(+), 250 deletions(-)

--
2.43.7

