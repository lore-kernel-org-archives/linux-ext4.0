Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com [209.85.128.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E317538944E
	for <linux-ext4@vger.kernel.org>; Wed, 29 Jul 2026 19:54:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785354872; cv=none; b=m9uDNkc1UrDxlXRi3M0xyS6sTROn6GomUJJ/n9FOuMD+qmLm09JSFx9EfCA7nJCS170wQp6KT5RojXKz7aiiWHnQ3YBv/vuLZjyId2l1ZJseQ6IDeE4a5lfig66RDRlrih3TmuPDROm239ZP5iSo4jDDY0GispxSO6Js5po96X0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785354872; c=relaxed/simple;
	bh=ZFA7d+UrNzfG4zGhm1J8mWfzeL9nObwNkoLpv8d0RUk=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=A+ZYxA8me5+HHmj+3TMVA1ni2ZsqpPNi+BDNvsO3g2Tsqrd45oGlhcKb67+M8W3WYPFGwUbFc0d/0T9yNcsIJb1JEMXipO8M1spCQNQl5LxZDVB8KYmHuI+qDosHwKcH4D/TEywASupTH2DDueZ+V25nWKnyPCDT1iLuMcEYSw8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ZiZbcpD2; arc=none smtp.client-ip=209.85.128.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ZiZbcpD2"
Received: by mail-wm1-f47.google.com with SMTP id 5b1f17b1804b1-49545ba3d4eso6213525e9.3
        for <linux-ext4@vger.kernel.org>; Wed, 29 Jul 2026 12:54:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785354869; x=1785959669; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=u+iF8UqpGZO0rLcCSUEsfrAUg04xqkSRYYgaj9HHG3M=;
        b=ZiZbcpD2QOvQUN4D6qFkx4CkJrUYv+4jLWKmzWLyiRP04kOU0eVbGtpncwJk0dKSnq
         P0WvOjhaqy2z2CF9MkD4fEUm/7zVKC9BkdQHcCVnEj/8amn5n17ixJTdTjBwIIMnYpky
         N51lNhxok1hFbCXMHKjX3Soaax5N8hpR6SqF0+MimjdKtb+4N25NyhMyeGB8wDARQUpt
         vSjVn+iDp/T1DiZGVVyuqtVqkITfVYNKYRg3y07oXjycYMu++Z4+E+LiDevOH/Snrzro
         2nmeYCjWU6eaAN33RK5NizNdaHrOxkVGfMi17ENcji2uUMXLrcJZMW+p1RKxEAhjiRAx
         JWPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785354869; x=1785959669;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=u+iF8UqpGZO0rLcCSUEsfrAUg04xqkSRYYgaj9HHG3M=;
        b=iNOleaYB5yU8zjbtGdqRzm9OOd/gUyEthpwnnXTAMHFqX29JHiBTaoKtU7uRB0Yrog
         xl9i2cSL/Aq4QfM2ddcbAPbQfpcIuZZ9NPT8lrue88U29tv5SFx7aAQzrNNTEnJkKvMZ
         P64YyWNYBrgsLJEyMUISWn4nTc6/bHQH3CNAuYnvEphtKhw+gSwLO8JvOwyZp49rb75f
         ASOhaetM6Sifl0ovFbvs/844w14XbAfolo9tS23YZdwFTJEYRdYLyXUJb0qH/SNuHD+H
         JZ0f93G2WIvlzAtciiLoqlP+CIR/EHBjLNfrqlU/xZZx5Fv6L8khwYlRz/+0ftPRdi4V
         TMyA==
X-Gm-Message-State: AOJu0YyTerWeBQvrANc4Y9BwV/BiCggafK0//2X4+tWvy2vYkjtXn8qW
	8RY0e6tb5w9B2lU4DZ0RxTVkNSrbUtgeLkspEMzguPFx/1scweFELRL9n4d1PuK8
X-Gm-Gg: AR+sD115l5YdvAR+eewgT+yGE1VApZoqpgag2Hlf5xE25/3nse/BGLzU1jtoRxNyrRl
	UWOpAxznWwLyUBKEqbaODXfz2f7P46LXIjYICQm30KkKul0j4B5Otf7ob79V5X9Vxrrf9ArHhhH
	nu/KztPJQtp9TKPTDMczRAM2kNYWw70bt3X44DvzjnOKNmpSGpAxJ0MTwNLjsF2Bl0wRD6HWFJB
	0MUcdpdXjvSTlL3tEUilz9GpIS2M7VNA2mn7BISS9hCzo0+M0pAN9BVHcr4Fi37kp2ti+wFe73r
	qHdHvgySwB+vxJv2fmPXffiiNSLUYPxlOpPyluhvXfeObaejpNSlILHSLlhiuHQAnqtSRK+BJZW
	ukbmnCHKJ9wxjwC+E5WGDm2nV8a05mcDa0CC+daJrGer/iVw1nfF5QMokBC7q+VVyHzz+x/suSI
	BFbGpTEfTp/d60VGZuA4VWlsmPDiulBTsWZMxPQ24uaJmhvZZlUZHgEBhszuY7vJJlirLTC43HO
	zdZQcCCNiBPfYZNN2rv
X-Received: by 2002:a05:600c:3b90:b0:495:6478:2dbc with SMTP id 5b1f17b1804b1-496c641067dmr97163105e9.6.1785354868809;
        Wed, 29 Jul 2026 12:54:28 -0700 (PDT)
Received: from Cluster1.powerhub ([2a0a:ef40:18b5:9e01:f5de:1ef8:371:ee89])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4976bd6d226sm82076865e9.10.2026.07.29.12.54.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Jul 2026 12:54:28 -0700 (PDT)
From: Artem Blagodarenko <artem.blagodarenko@gmail.com>
X-Google-Original-From: Artem Blagodarenko <ablagodarenko@thelustrecollective.com>
To: linux-ext4@vger.kernel.org
Cc: adilger.kernel@dilger.ca,
	Artem Blagodarenko <ablagodarenko@thelustrecollective.com>
Subject: [PATCH v8 00/11] Data in direntry (dirdata) feature
Date: Wed, 29 Jul 2026 15:53:18 -0400
Message-ID: <20260729195333.20626-1-ablagodarenko@thelustrecollective.com>
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

Changes in v8:

This version addresses all actionable items raised by the Sashiko AI
review of v7. Several of the bot's flags were false positives because
the bot reviews each patch in isolation without knowledge of subsequent
patches in the same series;

Those are got comments for Sashiko:

[v7 08/11] "data1/data2 parameters in ext4_init_new_dir_data() are
unused dead code" [Medium]
  Intentional reservation: callers that embed dirdata into the '.' and
  '..' entries of a new directory will pass data here. The in-place
  write path requires proper decoding via ext4_dentry_get_fid() and a
  dotdot write path, neither of which is in scope for this series. The
  parameters are documented with a comment rather than wired through
  incorrectly.

[v7 10/11] "ext4_dirdata_get() called on a zero-initialized
dx_hash_info in ext4_match() may misread hash" [Medium]
  False positive: ext4_dirdata_get() with hinfo=NULL simply skips the
  hash read. The ext4_match() caller passes a real hinfo; the concern
  does not apply.

[v7 04/11] "dx_get_dx_info() advances by ext4_dir_entry_len() (minimum)
not the actual rec_len" [Low]
  For '.' and '..' in htree root blocks, rec_len equals the minimum
  exactly: ext4 writes these entries at the tightest valid size. The
  minimum and the actual are the same value in all reachable cases.

Fixed:

Patch 04 (dx_root refactor): fix dx_release() to loop over all
EXT4_HTREE_LEVEL frame slots and release every non-NULL buffer_head
when dx_get_dx_info() returns IS_ERR. The v7 code only freed
frames[0].bh, leaking the remaining buffer_heads for any htree deeper
than one level.

Patch 05 (dirdata format definitions): read ddh->ddh_length with
READ_ONCE() in ext4_dirent_get_data_len() to prevent the compiler from
re-fetching the disk field between the bounds check and the use (a
compiler TOCTOU, distinct from the journalling TOCTOU). Return 0 on
out-of-bounds or zero-length records instead of a partial dlen; a
partial dlen caused callers to compute an inflated minimum slot size,
which could fail to find a free slot in a non-full directory block.

Patch 09 (LUFID rename support): the v7 fix for the no-LUFID-slot case
in ext4_setent() returned -ENODATA, which broke rename of any non-LUFID
inode into a LUFID-carrying slot. Changed to clear the EXT4_DIRENT_LUFID
bit from file_type and continue, so the rename succeeds and the stale
flag is removed. The v7 fix for the size-mismatch case cleared all
dirdata flags via &= EXT4_FT_MASK; this also cleared EXT4_DIRENT_CFHASH,
which sits at a fixed offset after the LUFID bytes. Changed to leave the
existing bytes and flags in place so the CFHASH extension remains at its
correct offset; the stale LUFID bytes are correctable by a subsequent
EXT4_IOC_SET_LUFID call.

Patch 10 (dirdata set/get helpers): fix ext4_match() to read the
casefold+fscrypt hash via ext4_dirdata_get() when EXT4_DIRENT_CFHASH is
set and the dirdata feature is enabled. The v7 code used the fixed-offset
EXT4_DIRENT_HASH() macro unconditionally; when an entry carries a LUFID
before its CFHASH extension, the fixed offset points into the LUFID bytes
rather than the hash, causing lookup failures on those entries. Apply the
same fix to htree_dirblock_to_tree(), dx_make_map(), and
ext4_inlinedir_to_tree(): un-migrated entries (no EXT4_DIRENT_CFHASH
flag) use the legacy fixed-offset path; migrated entries use
ext4_dirdata_get() to find the hash at its variable offset.

Patch 11 (EXT4_IOC_SET_LUFID ioctl): restructure ext4_dirdata_set_lufid()
into two phases to satisfy the VFS lock-ordering rule that all inode locks
must be acquired before starting a jbd2 transaction. Phase 1 looks up the
entry without a journal handle, calls iget() to get a stable reference,
runs check_sticky(), and locks the child inode. Phase 2 starts the journal,
re-finds the entry, and verifies the inode number still matches (TOCTOU
guard against a concurrent unlink+create between the two lookups). In v7
this function started the journal while the directory lock was already held
but before the child lock, inverting the required journals-last ordering.
Add MAY_EXEC to the inode_permission() call in ext4_ioctl_set_lufid():
directory entry lookup requires execute permission, not only write.
Add explicit IS_IMMUTABLE / IS_APPEND checks: inode_permission() does not
cover immutable/append-only flags for the directory owner.

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
 fs/ext4/ext4.h            |  239 +++++++-
 fs/ext4/fast_commit.c     |    1 +
 fs/ext4/fast_commit.h     |    1 +
 fs/ext4/inline.c          |   67 ++-
 fs/ext4/ioctl.c           |   87 +++
 fs/ext4/namei.c           | 1110 ++++++++++++++++++++++++++++++-------
 fs/ext4/sysfs.c           |    2 +
 include/uapi/linux/ext4.h |   14 +
 9 files changed, 1317 insertions(+), 238 deletions(-)

-- 
2.43.7

