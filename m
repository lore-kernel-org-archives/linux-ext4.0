Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.52
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793713822;
	b=oOYcWa496l6NOz3UbDuVJemkCerzdMtgIQrqCAPyMARShhCFTFASu9znFBix3rrDTRhS
	 C2Cylcw7481yFQ64sIg6pspi78WMiVfCdNOYOjq02YflDtwFeg7gjyLqJKifT4gfjBU8f
	 ykI8vsH0+KcFm2YSWJ1b0IPqm1rnkba1gUlcOevhx44sRHwEHQQZEVlNolR0hG/L+xoLs
	 Sv0EHIduGytHiCHQIenC39Fx+9plEKRohA/v4TmFLFgM/Z0ZU4NWLwW8689HSqK9wfEoU
	 hE0vQPzAc+oCALl9d8iCPMExyoeqe4tdxf8Y4XiTyyEEAz4ThHMKFWpZOFgq5wU29GQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793713822;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:
	 X-Google-Original-From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 MIME-Version:Content-Transfer-Encoding;
	bh=cOYIginXDktRxiy2Y506S0DM0F7lOZIKNW0l5V1W8mw=;
	b=Z6qmtTyh1dW5RR+Mc7zvjB9izN8t7MEr/IhM1hFYLQsK2XwJ0pDIpSVT/97MxnyXIdoH
	 qz+cge0njotOsdrVXgoxq9vRm2inQk4K5IxPbtyPSAnkrGwRad9mtvuRaCS8DOgDe1p2e
	 sEnls83wieAn1bYgNCZqPIHngY4mEEVYBFwUSM6cbjPpwT9nd7RXPJVEReL14R2LUW0Jf
	 Q4aW3zYoTJQtvGkge6gVH/XSKEhTiHmv/Bf5ciY36a19XZnE64Nrzg8KoU3qiP9le8V9l
	 oZSPHoYZlqtdB/dylXwT2Yq5rXpOwYAcZymI930IwDcM4GrQLp1cQUKK0bkPdovFqqw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=Yf79eTY0;
	arc=none smtp.remote-ip=209.85.128.52
Received: from mail-wm1-f52.google.com (mail-wm1-f52.google.com [209.85.128.52])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03B63606A324
	for <linux-ext4@vger.kernel.org>; Tue,  3 Nov 2026 13:50:21 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 03B63606A324
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=Yf79eTY0
Received: by mail-wm1-f52.google.com with SMTP id 5b1f17b1804b1-4a5036bbac7so26647595e9.3
        for <linux-ext4@vger.kernel.org>; Tue, 03 Nov 2026 05:50:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793713820; x=1794318620; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=cOYIginXDktRxiy2Y506S0DM0F7lOZIKNW0l5V1W8mw=;
        b=Yf79eTY0qnb2FJj5s6p2JOH/OL8NUs+lSneM+6zOr+9WRhdQguJDlxWHLw98FTpMyk
         86UCk15/X0kMwevlJhWygECRquZzqPpU94tABZ1dSeNGlyMF/QEK8oPsMZhaIgkgLGUk
         //4DR4NTqJVQzAhaKJDh24Y1Ng+666Jqc3zlusCv7TktsiQR1C8K23ZhsOrKtEoPIBd4
         F/iu0hIUxctJWW6vk5n7y2hbLgM0V+4KMNgZYqrSVM4RBl8OnH75AACoCcJpbF3YkAXc
         ApPpjcgWseF6tM9EifPre/9WyfAjWrDrXb3gVxn+u1D2CWLGHdjssyN8IUWzq9FECoTv
         eigg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793713820; x=1794318620;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=cOYIginXDktRxiy2Y506S0DM0F7lOZIKNW0l5V1W8mw=;
        b=a441xVzWEuvBJuU6SuRZ5f+sv/SbkN25yxxLv7xi4ypxvCMPnytI2G14sZD4wm6a6n
         67Gzl36+rZJnW70KGy9GYZ9bJ9PEpnrAin4uM30mPithO+C1h1tIsr0BNw1OsTgCN5Gt
         P9UlfaghlwYSB1ak2N8HmwHNMXIHrayn56CIbf73yQTs1wZE2A40dIt/DZZY2kCpXxFR
         r9ucQBouWeWO8TObtHYv5B18t6dHsrhKkMFaAOxNLxJFE3bdREpIVFp0+OHZ7XQdVrR8
         /HahsQD0rDOTr/aqAae5lV5AEuv10GuBAN1ueAc0llQr396RDXNFjIzwOO5sklgfFaCc
         G+cg==
X-Gm-Message-State: APuU4Z9gM9RCl7LZRowrVVnUqAHWr79Pxe/cNPKkLxCnmpye6MkQs95f
	fsEYdHmmJmwLr+ax4TFKJrAHYU2K5GlQkyin5uwIUJV9YGHTtl0D8x6D2aM+KNgOuSk=
X-Gm-Gg: AYBFou3EKEKYt7+FmlSDG+pJxxlAMDOY6o2qHdZGYDrGxOpj1YpC5Lw9igVune5uQDl
	0+wTNOFejGLBDov8VZpZAJjXnk6Jit0UAyg3C3noX2ZWI6OYsnwpQCUu4zOQ1JH5t+LoRVXH6pQ
	53HgMDFUaRzCQ2uXJCY/arXBUcytXKytjKg33qjQ52GQoWV9DF1NqpNHf9PFBxM+9T/bva+ab+t
	V9BZ29z//gGFP697JXyK4ujT7nlZSIkILreq/tDZVp7O5jAQGz0d82tuIfhu/SxC7bJDK5HyJqw
	tK5yJfPaTUBzegn5KVb7Jino2rssqGEiWBUMxErZ6qcbBpdTlkEVIKaIT2mIVUZA0eMopSviUsh
	lB/XAg/D2tSFyMxNwyDt1mrpvmTKTQzHitQucnzkuxH2CkYdL1gNOnyk6L5MtEk+9roTxuLV8ib
	4UTdjsG9CxoBLvFNnzscRsYZFwjf0hwCzaiV9l7Ap1xkY2RrXTzWM3uOLUoTtVDG+v9LXmq+pSY
	w/S0zxAsfrQW0u3UY4hWYIwzstFW8sR6OOrzFPT/1xtsz0QaYOTYKO8aPyp02P56tJIL2xUGQdd
	xNaXCBon8AFYwanE4AdkG0wiR87K1dZocWtBlHxXf58CgaYTmG1B05EFTYgitEDYwaAfq8Nr2oX
	UkzWZyw==
X-Received: by 2002:a05:600c:34cf:b0:4a7:c366:d791 with SMTP id 5b1f17b1804b1-4ac150b38ebmr304923585e9.1.1793713819999;
        Tue, 03 Nov 2026 05:50:19 -0800 (PST)
Received: from Cluster2.powerhub ([2a0a:ef40:18b5:9e01:225:90ff:fefc:9ffe])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4abeb77af8csm457146785e9.1.2026.11.03.05.50.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Nov 2026 05:50:19 -0800 (PST)
From: Artem Blagodarenko <artem.blagodarenko@gmail.com>
X-Google-Original-From: Artem Blagodarenko <ablagodarenko@thelustrecollective.com>
To: linux-ext4@vger.kernel.org
Cc: tytso@mit.edu,
	jack@suse.cz,
	adilger.kernel@dilger.ca,
	ablagodarenko@thelustrecollective.com
Subject: [PATCH v14 00/12] Data in direntry (dirdata) feature
Date: Tue,  3 Nov 2026 13:49:07 +0000
Message-ID: <20261103134921.610047-1-ablagodarenko@thelustrecollective.com>
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

e2fsprogs support is provided in a separate patch series:
  [PATCH v4 00/13] e2fsprogs: Add support for dirdata feature
and the fstests coverage in:
  [RFC PATCH v6 0/8] ext4: tests for the dirdata feature

As Andreas noted in the v12 thread, the first patches are bugfixes,
code cleanups and reorganisation that could be reviewed and merged ahead
of the main feature.  In v14 these are patches 1-8, and the feature is
patches 9-12.  Patch 02 is new: it fixes a bug in current upstream for
casefolded+encrypted directories and does not depend on the rest.

Changes in v14 (addresses the Sashiko review of v13 and two kernel test
robot reports; no human review yet).  Patch numbers below are v14's;
v13 patch N is v14 patch N+1 from patch 02 on.

- New patch 02, a fix for an upstream bug that the Sashiko comment on
  v13 patch 05 led to: on casefolded+encrypted directories the kernel
  computes the index node limit one smaller than e2fsck does.  e2fsck
  reports index nodes written by the kernel as corrupt leaf blocks, and
  the kernel refuses index nodes written by e2fsck -D ("dx entry: limit
  510 != node limit 509").  Reproduced on ext4.git dev without this
  series.  The patch uses the e2fsck value and still accepts the old
  one.  It does not depend on the rest of the series.

- Patch 05: declare the hash words of struct ext4_dirent_hash as plain
  __le32 fields, which clang -Wunaligned-access reported for the nested
  struct inside the packed one (lkp, 202610301711.NaWjQ2jw).

- Patch 06:
  * dx_get_dx_info() finds ".." through the rec_len of ".", as
    make_indexed_dir(), get_dx_countlimit() and ext4_htree_fill_tree()
    do, so a "." entry with slack can no longer put dx_root_info on top
    of "..".  It also checks that the root has room for dx_root_info,
    two dx_entry slots and the dx_tail.
  * make_indexed_dir() looks up dx_root_info before it appends a block
    or wipes the old entries, so a failure leaves the directory as it
    was.
  * v13 changed dx_node_limit() here, which made the kernel reject the
    index nodes it had written itself; that is now patch 02.

- Patch 07: ext4_dir_rec_len() keeps reserving the casefold+fscrypt hash
  on dirdata filesystems.  ext4_dir_entry_len() returns the larger of
  the length with the dirdata records and the length with the hash at
  its fixed offset, so an entry without a valid CFHASH record still
  covers the bytes the fallback readers use (Sashiko on v13 06, 08, 10).
  dx_root_limit() cannot underflow.

- Patch 08: add_dirent_to_buf() checks that the entry do_split() hands
  over has room for the new entry before anything is written.

- Patch 09: the dirdata size of a new entry is computed in one helper
  used by ext4_find_dest_de(), add_dirent_to_buf() and the inline-data
  path.  get_dx_countlimit() includes struct dx_countlimit in its bound.
  The fake "." and ".." entries in ext4_inlinedir_to_tree() are zeroed.

- Patch 10: ext4_setent() removes a LUFID record by moving the records
  after it down, and adds one in place when the entry has room.  On a
  failed RENAME_WHITEOUT rename, ext4_resetent() puts the LUFID
  snapshot back instead of only setting the flag, so the entry is not
  left with CFHASH bytes where LUFID is expected.  ext4_lufid_snapshot()
  reads ddh_length once.

- Patch 11: ext4_setent_compact_exts() is gone (patch 10 covers it, and
  INO64 records are now moved too).  The legacy hash read in
  ext4_dirdata_get() is bounds-checked.

- Patch 12:
  * the LUFID payload is limited to 48 bytes, so a split 1k block always
    has room for the largest entry;
  * ext4_dirdata_set_lufid() calls dquot_initialize(), honours DIRSYNC,
    checks strict casefold names before deleting the entry, re-adds the
    stored name (decrypted in encrypted casefolded directories) and
    sets up both names before deleting, so the rollback does not
    allocate;
  * it no longer locks the target inode, which protected nothing and
    could invert the lock order on a corrupted directory;
  * its stack frame dropped from 1104 to 560 bytes on x86_64 (lkp,
    202610302057.dZ9WDGS4).

Not changed: ext4_dir_entry_len() still parses dirdata without checking
the superblock feature, because callers pass a NULL inode for "." and
"..".  The parse stays inside rec_len, and the overflow it could lead to
is closed by the check in patch 08.

Tested on ext4.git dev in a VM: every patch builds with W=1, and with
DX_DEBUG (with -Wno-missing-prototypes, which DX_DEBUG already needs on
ext4.git dev); fstests
ext4/064-069 pass with and without -O dirdata; 1k-block directories with
255-byte names and 48-byte LUFIDs split cleanly; a RENAME_WHITEOUT that
fails with ENOSPC keeps the old LUFID; a multi-level casefolded+encrypted
directory (12000 255-byte names, with and without dirdata) passes
e2fsck v4 before and after e2fsck -fD and after more kernel inserts.

v13: https://lore.kernel.org/linux-ext4/20261029122413.230409-1-ablagodarenko@thelustrecollective.com/

Changes in v13 (v13 patch numbers):

- Rebased onto ext4.git dev (8c4f6e337634 "ext4: introduce a mount
  option for iomap buffered I/O path").

- Patch 07: also rename the ext4_dir_rec_len() callers added upstream
  since v12 by:
    bc4b7b0414c3 ("ext4: validate readdir offset before accessing dirent")
    9333cc809f0a ("ext4: fix out-of-bounds read in ext4_read_inline_dir()")
    c7e6b863d298 ("ext4: check dir entry fits before reading the hash
                   trailer in ext4_search_dir()")

- Patch 10: keep the hash-trailer bounds check added by c7e6b863d298 in
  ext4_search_dir(), together with the new buf_size argument to
  ext4_match().

- Every patch now builds on its own. In v12 patches 05-10 only built
  with the whole series applied (Sashiko's build-failure reports on
  parts 5 and 7 were correct). The final code is unchanged; only hunks
  moved between patches:
    05: ext4_dir_entry_len() moved here from 06, since dx_get_dx_info()
        is its first user; dx_root_limit() no longer calls
        dx_get_dx_info() before 06 changes its signature;
        dx_node_limit() keeps ext4_dir_rec_len() until the rename in 07.
    07: add_dirent_to_buf() passes dlen = 0 to ext4_find_dest_de(), as
        the inline-data caller already does, until 08 computes it;
        dx_show_leaf() (DX_DEBUG) is renamed here too.
    08: the (struct ext4_dirent_fid *) cast in ext4_dentry_get_fid() is
        added here instead of in 11.
  Each patch was built with W=1 and with DX_DEBUG.

v12: https://lore.kernel.org/linux-ext4/20260801181227.5198-1-ablagodarenko@thelustrecollective.com/

Changes in v12:
- Patch 09: allocate edp in ext4_rename() before ext4_setent() so that
  an -ENOMEM cannot leave a RENAME_WHITEOUT source entry with the LUFID
  flag restored but its bytes already overwritten.


Artem Blagodarenko (12):
  ext4: validate count against limit in ext4_dx_csum_verify/_set
  ext4: use the e2fsck limit for htree index nodes
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

 fs/ext4/dir.c             |   53 +-
 fs/ext4/ext4.h            |  295 ++++++++-
 fs/ext4/fast_commit.c     |    1 +
 fs/ext4/fast_commit.h     |    1 +
 fs/ext4/inline.c          |   66 +-
 fs/ext4/ioctl.c           |   87 +++
 fs/ext4/namei.c           | 1326 ++++++++++++++++++++++++++++++-------
 fs/ext4/sysfs.c           |    2 +
 include/uapi/linux/ext4.h |   14 +
 9 files changed, 1570 insertions(+), 275 deletions(-)


base-commit: 8c4f6e3376348fc3162eed86a05b933921c8f9ed
-- 
2.52.0

