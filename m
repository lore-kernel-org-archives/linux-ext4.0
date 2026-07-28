Received: from mail-wm1-f48.google.com (mail-wm1-f48.google.com [209.85.128.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 360AB3B27C6
	for <linux-ext4@vger.kernel.org>; Tue, 28 Jul 2026 23:44:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785282249; cv=none; b=HCZaNvbly/2xx+FEx7SNOsyKX8/6lEdWjpAxYW40J0PAGArtP+6HxzRQhW86lly3IQ+E/Ry/iTtfCnSgQh20mwZJPEtWXHOIslzj+gPlOYXhO2YbCXqORc6QX+gMTjWCwlmVP2YkQL/U710dEgQxh7KzT3K7hQ+UQ8Q09w7TcRo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785282249; c=relaxed/simple;
	bh=oOSagGYnIQwnSA/7LvTtBLylOL6htgAfCCBE7qxtzxY=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=G7t9BMNFrnpj4H3fKTFhUQZVdM58EyMpojDD7TidCsMWSB0teB56JzFXHXEVahsBAO8cxLNwm+APc1tS3UlJn97zsG0SL6JlVDBqSoIZN/umhsMrzCeNghEuSTSmfIAEQX+Ml2QlOJoFDpQyv8tBmprDJdJX2nPo5+NNSKmLYK8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=a45FUTew; arc=none smtp.client-ip=209.85.128.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="a45FUTew"
Received: by mail-wm1-f48.google.com with SMTP id 5b1f17b1804b1-496bb7cdf51so3651965e9.2
        for <linux-ext4@vger.kernel.org>; Tue, 28 Jul 2026 16:44:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785282245; x=1785887045; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:message-id:date
         :subject:cc:to:from:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=rvekxCAiMQZ9wv/sAsHjGxevIxQCiVq6roqrdAL9A6I=;
        b=a45FUTewq/HSMOT0WnzD3JRs+uRUR4LGVHLwC1qLLXRRU2C8ik58juXMvXquaUDArR
         LBBjQ07Z44Y4TeuiIFZuwZ35DDonjFNwSU1gPrCNqRhdXS7UZom+i1k0GgULj+OyaJaP
         ukmxrxOXv+qCP9JbdeVDO0YV4aH2cd2/UmZaX7wmpnLME3epY9hMqRuXYalOCDLao/UN
         ydU/nl5XJl79g/8mTLZPPUrHRWLRhsjkvW2WVrTm5ajqjk3ZpBgg+kAsa/Jq+ALsdWMQ
         Bm2vefswpVIMY8i4GTTys7WfguoSSSb5m2NwnTi5S6vQbbBm9rqalOZoEOEB8sdjaWaa
         09Rw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785282245; x=1785887045;
        h=content-transfer-encoding:content-type:mime-version:message-id:date
         :subject:cc:to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=rvekxCAiMQZ9wv/sAsHjGxevIxQCiVq6roqrdAL9A6I=;
        b=gWsBEOhXEvWIbmlza1wSincYsQXebCuoEsoR2ba/Z0nwie7ekf4xdNaJmxGXhsi7hr
         SiR3NEooVHEBc09zcMjPTjGxBgAbPgJN74BiikPWUxAsFlgdDspCDGtpa36K0WQ4++Z1
         zggZH/pv5o0qaxgJ9iSUDmImU7VXhk1ZGTT30lyp6ubpM6qoTr/sytkBXCI18We75J7K
         p/jFMQDlmUW0b6qqNlqkIWMdMB9Pi/R3xBwyT24WbU4NHLXGh/4/BgNjbGt7S4XZFIML
         31EtGcnkGVUPcij4KsXU/M7yGXDjgAZ37rLVsdCjA7Pj2GujNaFq9caAC28srEUjFy9k
         lv/Q==
X-Gm-Message-State: AOJu0YxBMI5P0RukvEt+zHdZLnO2Q8BY62HFGYtbKSvHZaFSGBEiwe06
	f6q1q1dO+OqBI49e4AzXL3YteVf8R2N1R53X+mJxp1bOZV/4HdOV4P5K/Cp+4g==
X-Gm-Gg: AR+sD11+Wqj6BBBFZeYPQs0FjFoW96H+5BnSHn4aMvRW31/n8a1nnJDrx1MohPG+Bd5
	s9Tnph5GBm+10FhYvjj8QPEkGBHT5f8EiBHQG15Bz14ULv0fMEUizjMGa1ywPblXFOSEzo7W8DP
	UK4UTDGTQMd2fQWgRSi8e+FyxGENnYxN60SgsD7bIh0l10FRsix/lB1cgscWGn7GmjtvvX5EGGc
	udw6KpVCRvwTySVqUmIb7YX6L987ksMEknXF2Nqq7Bi26G3rxXI7fFhEtSF5d2SyDJsZ4qi8u27
	ViRVSk3GIUxk5a9Q5eojGEl1AEGId1wFY5sbz3FqiqXngzruOEtCsKGD6KQIQTotLmqpmusKNWu
	UpcoCKc+q/CYprJro0Y+14RDUEbno4pGN6bR6xxyMF+7iCui6jfkVmQU+pdLs1q7g6dlA7WGH9s
	qb/u9eK1T+ODeqB/oRq1NMFsd2QOJOZXrTDTu8/hfr+3pnOv9Ncb6x4ECu6EWy57Optd2Ykw845
	XJJScNiY13UGHlLCViP
X-Received: by 2002:a05:600c:1f8c:b0:495:52a5:8829 with SMTP id 5b1f17b1804b1-496c642c7e2mr52149835e9.11.1785282245129;
        Tue, 28 Jul 2026 16:44:05 -0700 (PDT)
Received: from Cluster1.powerhub ([2a0a:ef40:18b5:9e01:f5de:1ef8:371:ee89])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-496fa499a96sm13980365e9.3.2026.07.28.16.44.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Jul 2026 16:44:04 -0700 (PDT)
From: Artem Blagodarenko <artem.blagodarenko@gmail.com>
X-Google-Original-From: Artem Blagodarenko <ablagodarenko@thelustrecollective.com>
To: linux-ext4@vger.kernel.org
Cc: adilger.kernel@dilger.ca,
	Artem Blagodarenko <ablagodarenko@thelustrecollective.com>
Subject: [PATCH v7 00/11] Data in direntry (dirdata) feature
Date: Tue, 28 Jul 2026 19:42:11 -0400
Message-ID: <20260728234226.51753-1-ablagodarenko@thelustrecollective.com>
X-Mailer: git-send-email 2.43.7
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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

Changes in v7:

This version addresses all actionable items raised by the Sashiko AI
review of v6.  Several of the bot's flags were false positives because
the bot reviews each patch in isolation without knowledge of subsequent
patches in the same series; those are documented below for the record.

ISSUES FIXED BY LATER PATCHES IN THE SERIES (false positives)
--------------------------------------------------------------

[v6 08/11] "ext4_insert_dentry_data() ignores void *data" [High]
[v6 09/11] "ext4_add_entry() path fails to write LUFID" [High]
  Both fixed in patch 10/11 ("ext4: add dirdata set/get helpers"),
  which replaces the inline hash-writing code with ext4_dirdata_set(),
  wiring up the data parameter properly.  The call is at namei.c:2347.

[v6 08/11] "unsafe_memcpy receives a C comment" [Low]
  The block comment was intentional as an annotation; converted to a
  string literal per the macro contract.

[v6 11/11] "ABBA deadlock between i_rwsem and JBD2 handle" [High]
  False positive: the ioctl acquires inode_lock() and then calls
  ext4_dirdata_set_lufid(), which opens a journal handle internally.
  This follows the standard ext4 pattern used in ext4_setattr() and
  others -- VFS lock is held over a short journal handle, not the
  reverse.

[v6 11/11] "Error path loses directory entry" [High]
  False positive: the delete-then-re-add sequence in the ioctl goes
  through ext4_add_entry() which itself is journalled; a failure there
  triggers the journal abort path, not silent corruption.

[v6 07/11] "Incomplete renames break build" [Low]
  The rename of ext4_dir_rec_len() and the updated ext4_find_dest_de()
  signature are complete within the series; Sashiko was reviewing the
  intermediate state of patch 07 only.

[v6 04/11, 06/11] Critical issues around dx_get_dx_info() offset
calculation and dx_root_limit() callers passing integers as pointers
  Both are false positives: the refactoring in patch 04 is internally
  consistent and the callers were updated in the same patch.

[v6 05/11, 07/11] TOCTOU / READ_ONCE in ext4_dirent_get_data_len()
  These fields are read from a locked buffer_head in a journalled
  context; the "malicious block device" threat model does not apply
  here.

GENUINE ISSUES FIXED IN V7
---------------------------

Patch 04 (dx_root refactor): add upper-bound rec_len checks in
dx_get_dx_info() for both '.' and '..' entries to prevent an
out-of-bounds pointer advance on a corrupted directory block.  Add
a missing info_length validation in dx_root_limit() to avoid returning
a negative limit when the dx_root header is malformed.

Patch 05 (dirdata format definitions): convert ext4_dirdata_next() from
a macro to a static inline function to prevent double-evaluation of the
ddh argument.  Restructure struct ext4_dentry_param to store the LUFID
payload as a raw __u8 flexible array (edp_dfid[]) rather than embedding
struct ext4_dirent_fid directly; embedding a struct with a flexible
array member inside another struct violates C99 §6.7.2.1p2 and breaks
CONFIG_FORTIFY_SOURCE because __builtin_object_size() cannot reason
about the embedded flexible-array tail.

Patch 08 (dirdata feature): guard the dirdata extension parsing in
ext4_htree_store_dirent() with ext4_has_feature_dirdata() to prevent
misinterpreting stale or corrupted upper file_type bits on filesystems
where the feature is not enabled.  Document data1/data2 in
ext4_init_new_dir_data() as reserved for callers that need to embed
dirdata into the '.' and '..' entries of a new directory; the in-place
write path requires proper decoding via ext4_dentry_get_fid() and a
dotdot write path, neither of which is implemented here, so the
parameters are reserved with a comment rather than wired through
incorrectly.

Patch 09 (LUFID rename support): fix ext4_setent() to return -ENODATA
when the source inode carries a LUFID but the destination entry has no
LUFID slot, rather than silently dropping the LUFID and returning
success.  Fix the size-mismatch branch to clear all dirdata extension
flags (via &= EXT4_FT_MASK) instead of only ~EXT4_DIRENT_LUFID:
extensions are encoded in flag order (LUFID precedes INO64 and CFHASH),
so clearing LUFID alone while leaving trailing flags set causes a parser
to misread the orphaned LUFID bytes as the start of the next extension.
struct ext4_dirent_fid holds a flexible array of struct ext4_fid, so
the mismatch path is reachable when entries carry different numbers of
FIDs.

Patch 10 (dirdata set/get helpers): change ext4_dirdata_set() from void
to int return and propagate the error through ext4_insert_dentry_data()
and add_dirent_to_buf().  Previously a bounds-check failure called
EXT4_ERROR_INODE() but returned void, so the caller continued and
committed a directory entry to disk with the LUFID silently absent
while reporting success to userspace.

Patch 11 (EXT4_IOC_SET_LUFID ioctl): add an explicit check_sticky()
call in ext4_dirdata_set_lufid() after resolving the target inode.
inode_permission(MAY_WRITE) alone does not enforce the sticky-bit
restriction: on a world-writable sticky directory an unprivileged user
passes the MAY_WRITE check without any capability, yet sticky prevents
modifying another user's entry.  The new check mirrors what
may_delete_dentry() does in the standard VFS unlink/rename path.

Artem Blagodarenko (11):
  ext4: validate count against limit in ext4_dx_csum_verify/_set
  ext4: replace ext4_dir_entry with ext4_dir_entry_2
  ext4: add ext4_dir_entry_is_tail()
  ext4: refactor dx_root to support variable dirent sizes
  ext4: add dirdata format definitions and access helpers
  ext4: add ext4_dir_entry_len()
  ext4: rename ext4_dir_rec_len() and clarify dirdata usage
  ext4: dirdata feature
  ext4: add dirdata LUFID support for directory entry rename
  ext4: add dirdata set/get helpers
  ext4: Add EXT4_IOC_SET_LUFID ioctl for setting LUFID on directory
    entries

 fs/ext4/dir.c             |   34 +-
 fs/ext4/ext4.h            |  239 ++++++++-
 fs/ext4/fast_commit.c     |    1 +
 fs/ext4/fast_commit.h     |    1 +
 fs/ext4/inline.c          |   51 +-
 fs/ext4/ioctl.c           |   84 +++
 fs/ext4/namei.c           | 1023 ++++++++++++++++++++++++++++++-------
 fs/ext4/sysfs.c           |    2 +
 include/uapi/linux/ext4.h |   14 +
 9 files changed, 1223 insertions(+), 226 deletions(-)

--
2.43.7

