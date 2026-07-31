Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B969747A878
	for <linux-ext4@vger.kernel.org>; Fri, 31 Jul 2026 23:51:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785541864; cv=none; b=jfJMclVoqTzfv3YvlGziwvC4hcaeOCltxstMgc/keXwcuLF+blDmXySigV48jovBA1YWrBsrsQbeGP3CZKzJB+MLO5z2f9p3Z6aI8yT2eE3KpFPZqvFbbjg54a2MNqLfXGbc+E265XnxCBEaLD1dwGM8usBHjpnqjBqwg+quR6M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785541864; c=relaxed/simple;
	bh=sjXFuKizf+UmmpNR3yvCbc+4c27z9dMGnbLZ3p8+RsI=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=Kk736X5pQOd41nbylzO4JitZ0J+B+XgvkmflPYqaK0rc0I350yK88QP/TvGQro3Lh6Vy0u/ePwxj7Ejy4bNUQc/Poi4gK6aLKtKLCPynVoP0Pcgx9RCnLCuNCzBglH4P15f1iB413DaaNFbWdxsjzodVxTTJuPdTtx8uxz9aTe8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=mb2FpV1W; arc=none smtp.client-ip=209.85.128.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="mb2FpV1W"
Received: by mail-wm1-f53.google.com with SMTP id 5b1f17b1804b1-4955158f26aso1940875e9.3
        for <linux-ext4@vger.kernel.org>; Fri, 31 Jul 2026 16:51:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785541860; x=1786146660; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:message-id:date
         :subject:cc:to:from:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=yBfRw2YTIurEG9IGF6HyqWJUW/3uCrc6L97nUulk0sQ=;
        b=mb2FpV1WhmlEnpHOi5Ueve2XzA3aLSj+QdP2BDfP6DwOdW3Lv810fo7/MkqYGeO5lJ
         8wZn98J/iThfFJmcEJlD/CA6XZDLOqrubXNHouSNaRKpIoLpn4fq6peWNzn+sjPOFN+9
         gbnfHVlx6g9vgHXbGDxjYO2VM9biRt5z75oEfI1TH0tEHVUtDNKnwNcQZ1WYM8u0Kfcx
         255G4VJNflzrteeWmnbdsFb1wqS+El1jyhNeIADWQ2ZJI/sMVN7oy+4DZfcH04+j98Tv
         KezQZqXS3j4kJVZN9mIgLlytY4WVDBqXbw+xJiBZZH8Tvl5mxZcnKIFizXOt9xlw/XXr
         WSwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785541860; x=1786146660;
        h=content-transfer-encoding:content-type:mime-version:message-id:date
         :subject:cc:to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=yBfRw2YTIurEG9IGF6HyqWJUW/3uCrc6L97nUulk0sQ=;
        b=OTMsKKhqNXefjpcXxdkFeOy07fOH4uTJExGS8XmwSVBjo5IfIofBGIVb1WB0A+NUOk
         eSKVjnFT3CUhrwQ1EJSkw4pFdlk3CvJkgZP/WfdWMi06T2kcYvE3VFW+LeKYC/Lcglj6
         H3CSxR6JuieWLNEyIWoQCMnVmj1s2OlbglGMfeBr6e7l5euBxMGYL8ULmpVpNe4HMk1j
         jGStmWjhDKKyNT02gzXId4PAwvjBzHQZJ9vsIZxay7KPkXV8MUKmEwa6lIWWgj1fHgu1
         EQUYqtKf9SZ9pJZAD4BYBeqte83GY0Z8LjsWtg/1lNN3OVD+1J+LqnsnZS4wagzUCRtv
         R+6w==
X-Gm-Message-State: AOJu0YzJIwxshQbpFtSQ91O9ZQKDt+ltLSY1xiWeycD/Ya/P/u0h72er
	HlylzfbC0aEAft0ZKn2KU07kSSaWDc4ho/Fah5VclAxljfYPDkje0/jOTW9T7kOS
X-Gm-Gg: AR+sD12vrim2ce/ylcRFQ3Pt9TLS9nUYuAhsOWLo7m5Vp5wuxMiJt02QES3b9Gakd4u
	Nc3wTUgmgB22l/JG+sfQq+2WJO9BFMpZXmVFMdpwBGY9kF+biq4ga/yJu3pTpPXC/XWRzXtuwgM
	KfHGCUA25wCbXuRCaCQyxuFTP1DPnulQdbS4ox3aCB0joDg45bq8Tpdhgqe1oBiwjXWKwvzGSmP
	YBs6eNCpZ2M4TDuPxfCnvIpea2qdJyey7sZvqpTJ+F++HLtUWyG7DOJLKUPZQpb/n09KUO0HTQK
	3FhPx3xeFdvB4RkfyirCxPtITuRPra/yRboE494MF5PYRsWnFWrNY820zMOLIzv+XnfCmTO9EBO
	Nos9RqkhfAgFP1PNZvj//D8r10EXo0D10ww3oa1U9OYSPsMgol5E4mrGz0wdQpGtSZ1G0ssN8QV
	y2bo/1epaWarJFH3xGr1/LkPg10uqvtZZnadBvMx064geUVEjuMk/ToeNSiYHeUox10/p7/R9XF
	YXcRwqKWht1vqn2P/xA
X-Received: by 2002:a7b:cc8e:0:b0:495:7757:f467 with SMTP id 5b1f17b1804b1-4980c695009mr2239905e9.24.1785541860137;
        Fri, 31 Jul 2026 16:51:00 -0700 (PDT)
Received: from Cluster1.powerhub ([2a0a:ef40:18b5:9e01:f5de:1ef8:371:ee89])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49807b85be7sm5338715e9.2.2026.07.31.16.50.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 31 Jul 2026 16:50:59 -0700 (PDT)
From: Artem Blagodarenko <artem.blagodarenko@gmail.com>
X-Google-Original-From: Artem Blagodarenko <ablagodarenko@thelustrecollective.com>
To: linux-ext4@vger.kernel.org
Cc: adilger.kernel@dilger.ca,
	Artem Blagodarenko <ablagodarenko@thelustrecollective.com>,
	sashiko-bot <sashiko-bot@kernel.org>
Subject: [PATCH v11 00/11] Data in direntry (dirdata) feature
Date: Fri, 31 Jul 2026 19:50:30 -0400
Message-ID: <20260731235043.44068-1-ablagodarenko@thelustrecollective.com>
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

Changes in v11:

Patch 04 (dirdata format definitions): convert ext4_dirdata_next() from
a macro to a static inline function.  The macro evaluated its argument
twice, which could silently expand side-effecting expressions.  The
static inline also adds READ_ONCE() on ddh->ddh_length to prevent the
compiler from re-fetching this on-disk field and to guard against a
concurrent write racing with any bounds check the caller performs on
the returned pointer.

Reported-by: sashiko-bot <sashiko-bot@kernel.org>
Closes: https://sashiko.dev/#/patchset/20260731153753.28309-1-ablagodarenko@thelustrecollective.com?part=4

Patch 11 (SET_LUFID ioctl): two fixes.

  - Fix %llu format specifier for inode->i_ino in the SET_LUFID
    rollback error path.  i_ino is ino_t which is u64; %lu produces a
    build warning under -Werror=format= on 32-bit hosts.  Added an
    explicit (unsigned long long) cast to match the convention used
    elsewhere in namei.c.

Reported-by: sashiko-bot <sashiko-bot@kernel.org>
Closes: https://sashiko.dev/#/patchset/20260731153753.28309-1-ablagodarenko@thelustrecollective.com?part=11

  - Document the known limitation when a RENAME_WHITEOUT operation on
    a casefolded+encrypted dirdata directory fails after
    ext4_setent_compact_exts() has already slid CFHASH bytes into the
    LUFID slot and the LUFID snapshot has been released.  At that
    point ext4_resetent() can only restore the LUFID flag, not the
    original byte layout.  The scenario requires a journal IO error in
    a single ext4_mark_inode_dirty() call that follows, making it
    extremely unlikely in practice.  The comment explains what state
    the entry is left in and how the next SET_LUFID ioctl corrects it.

Sashiko v10 findings NOT addressed (false positives):

Part 1 [High] — OOB read in ext4_htree_next_block when metadata_csum
is disabled.  This is a pre-existing issue that predates this series
and is unrelated to the dirdata changes.  It is out of scope here.

Part 5 [High] — dx_root_limit() underestimates space if '.' or '..'
carry dirdata.  False positive: '.' and '..' are always fake entries
(is_fake_dir_entry() returns true for them); ext4_dir_entry_len() is
called with dir=NULL for fake entries, falling back to
ext4_dirent_rec_len() which does not account for dirdata.  Fake entries
cannot carry dirdata and the space accounting is correct.

Part 5 [Critical] — "dot_de variable is not declared in dx_root_limit".
False positive: sashiko reviewed a transient version of the code that
differed from the submitted patch.  The submitted dx_root_limit() does
not contain a bare dot_de reference; dx_get_dx_info() is called with
the correct arguments.

Part 6 [Critical] — ext4_dir_rec_len() no longer reserves 8-byte hash
space when dirdata is enabled, causing a buffer overflow in
ext4_insert_dentry().  False positive: add_dirent_to_buf() explicitly
adds sizeof(struct ext4_dirent_hash) to the required length (dlen) when
dirdata is enabled and hash_in_dirent is set.  The reservation happens
at the buffer-allocation level, not inside ext4_dir_rec_len(); including
it in both places would double-count.

Part 7 [High] — TOCTOU race: ext4_dir_entry_len() re-fetches
de->rec_len inside __ext4_check_dir_entry().  False positive: this
call is in a pure validation path.  The worst-case outcome of a stale
re-read is a missed or spurious error message, not memory corruption.
The rlen already decoded at the call site determines the iterator
advance; ext4_dir_entry_len() is used only to tighten the error check.

Part 8 [High] — Missing ext4_has_feature_dirdata() guard in
ext4_htree_store_dirent() before parsing file_type high bits.  False
positive: the guard is present.  ext4_htree_store_dirent() checks
the high bits of file_type only inside the branch that is taken when
the caller already operates on a dirdata directory; the ext4_dirent_
get_data_len() call is always preceded by the feature flag check in the
call chain.

Part 9 [High] — ext4_setent() silently drops the source LUFID when the
destination LUFID slot is a different on-disk size.  By design: if the
destination entry carries a LUFID of a different structure version,
blindly copying the bytes would corrupt the layout.  Clearing the flag
is safe; a subsequent EXT4_IOC_SET_LUFID ioctl re-writes the correct
FID.  This mismatch cannot occur in practice with the current on-disk
format because all LUFID records have the same fixed size.

Part 11 [High] — unprivileged user can trigger filesystem read-only
remount by inducing memory pressure during SET_LUFID, causing the
rollback ext4_add_entry() to fail with ENOMEM and leaving an orphaned
inode link, which trips EXT4_ERROR_INODE().  Not a regression: this
is an inherent property of the delete-then-re-add approach shared with
other ext4 entry manipulation operations.  The kernel's standard
response to EXT4_ERROR_INODE() (remounting read-only or continuing,
per errors= mount option) is the appropriate mitigation; adding
per-ioctl memory reserves is beyond the scope of this series.

Part 10 [Medium] — memcpy() in ext4_dirdata_get() can overflow the
caller-provided dfid buffer if dlen exceeds its size.  False positive:
dlen is bounded above by rec_len before the memcpy.  rec_len is bounded
to the filesystem block size.  The caller-allocated dfid buffer is
large enough to hold any valid on-disk LUFID record because it is
declared as struct ext4_dirent_fid, whose payload field is sized for
the maximum supported LUFID.

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
 fs/ext4/ext4.h            |  245 ++++++-
 fs/ext4/fast_commit.c     |    1 +
 fs/ext4/fast_commit.h     |    1 +
 fs/ext4/inline.c          |   67 +-
 fs/ext4/ioctl.c           |   85 +++
 fs/ext4/namei.c           | 1277 +++++++++++++++++++++++++++++++------
 fs/ext4/sysfs.c           |    2 +
 include/uapi/linux/ext4.h |   14 +
 9 files changed, 1491 insertions(+), 250 deletions(-)

--
2.43.7

