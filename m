Received: from mail-wr1-f45.google.com (mail-wr1-f45.google.com [209.85.221.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2149212F89
	for <linux-ext4@vger.kernel.org>; Sat,  1 Aug 2026 18:13:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785607996; cv=none; b=oD7Wz/yuNnOIoCn5IogkycothPdozi1C5qMKa4GM6n6NocYkkJhiprbg07Mm4cTOpfy7vgqpMsixIuc10FeFtzvIzxPbOocXNI+b5bQrI8/pzMuiZjpfnJ3TCln4cA6324hQ1errzNzvsPNiDmeVmJw2Ghm+UbaF7naqiJyGQlg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785607996; c=relaxed/simple;
	bh=zk76pPIlgRnwW4H5yCJxcPF5/z+Tp1sMEywIh5sQCJE=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=EFYkjl7S1/dB84Q0Iowu8WbQueKrk2vqXrtromjTVS2lKpohQ+cBcUwlFx2ShJgXN4tCsfaCpNYGr530ol6XA8TAhsNuTzWrInk64+d1zNWN2gRnbKfB1cVKsSxmrAv0VH3xHX7s7UDcicGRZ2ZBwAKkUfMS1WdA/90sHCzvf6Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=aIk9sTjD; arc=none smtp.client-ip=209.85.221.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="aIk9sTjD"
Received: by mail-wr1-f45.google.com with SMTP id ffacd0b85a97d-472326ca506so1522298f8f.2
        for <linux-ext4@vger.kernel.org>; Sat, 01 Aug 2026 11:13:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785607993; x=1786212793; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:message-id:date
         :subject:cc:to:from:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=TKJbOsP0LKZwFY3H7FWMxocLFf6he5uHB4weWLW4RRo=;
        b=aIk9sTjD3EgPAXuHJjlZjRQC+51okz+iFbP9yYV8NbeA2t5gtGbJxS7Z4uDslfh6BB
         tD1us4k9KnHseRHRtprObasboP3ksBYbLyHaiVP2wQRHhXav/smGMRP1ByQGjaRV3l97
         1NO+CUyI6omOCFq5CSR5OEIOXTSrd/TMkzw6+7dXXDEFxmvB6h/dNS5w7EuWpKibBg32
         jxPKfWBynGvBMFCBdzLUpb0NBZkYH0aODaB7hbXabWrHECo8lyWhjn98USxTKCkX4YN0
         Fi0rIL1EZ7Mr34Zk0/5iMAfmwM0gwwOiM3nwTnTL3jaLXDKlHhq+bZJsbqnve2PJyQsQ
         T7Gw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785607993; x=1786212793;
        h=content-transfer-encoding:content-type:mime-version:message-id:date
         :subject:cc:to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=TKJbOsP0LKZwFY3H7FWMxocLFf6he5uHB4weWLW4RRo=;
        b=OTqp/wgpHOdeb0VfUwSRbPnCPrT7Jxf5kfibayXCAyxFA7zs5RI2lgaU6PNPOzBE+j
         a7UBOu7xHffgSZLD3XMCnyocoJEXEm3VX3cuBC3RCFHp5yfzmWPu0n3/Ebh/YTBuwMxW
         V4QQifVx+6fs351xobngEz8qRFtATQLYAW6Zt3Rmdo9mPzrFlDp8H4Vw13FqPdrMKSDQ
         QgJEKnZ120miyIKPkDY2YBw6LUSEC2qP605QXmlJ0Qr1FwY9j8y8pBcykNcRVseI+I3j
         dzTQaZnEMEKoByAtLKfjUTru9zmEtGtd6Ake/INYcDo40qWD79pgb0pi2oZiR5gyF1sO
         GcJw==
X-Gm-Message-State: AOJu0YyH6g7LPxBKg0/wXoamg46GHil1+xMk/bNx3D0kdt9vz882iwvH
	x5ZXLY5ciEDdy8eAg7RE44G0hBz2pAxKZfoqkh/zQ+wVMlMz45UGgMiR0WPU/Q==
X-Gm-Gg: AR+sD13vLlDe8zt6kVBfrzHMA7br0BRYIdcxm3/sOgVz5/hfa2gNoBO8gQdsv5A/xIH
	RHyJdevQMPmRNjJtpbBMb7/xV6JcJAUfe0F43PrWfe7sjzNrXDSV23h5musfDp9/9nCylz6fdnt
	kdn4AOm3qZXPiVIXUx5oEzAjjRGF/Gc9ZFUCT84KbAUke/z5SDXqO3AeaWfg/vGHeg/+kqcKHbO
	OM2JqVZcw+5iLxRHaiNh3wUN29f2ZTCokznOgjOr1XSAVeZ0L29IYBeKWl4N4NYufLp4j4yBXiU
	0ofx2vukWO1qZhO81xnkPWK4/gTq5QED6kTmK6GdTv4rj57/NO+aoz41575ZwWeo3cQBfDjVvgN
	4bYX5z/F0QthHoe1ch1JQrLhpvB3qK+vL8S+XAFUJvCCXF1yGfjWyZN4GR6PORPrKYu3v3xLBsS
	2mkfEdCqBJ4Sal957WKe1B3BV7Uwb3xTrRxLM0D7AdHguFnlY2b+gUXXUSDyPpMWOjQ/ieGMb32
	ecjXEHn3T61XWh1n1Ex
X-Received: by 2002:a05:6000:460b:b0:47f:96e6:70a with SMTP id ffacd0b85a97d-47fd72625a6mr9829743f8f.0.1785607992536;
        Sat, 01 Aug 2026 11:13:12 -0700 (PDT)
Received: from Cluster1.powerhub ([2a0a:ef40:18b5:9e01:f5de:1ef8:371:ee89])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-47fd458adc9sm18819761f8f.27.2026.08.01.11.13.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 01 Aug 2026 11:13:12 -0700 (PDT)
From: Artem Blagodarenko <artem.blagodarenko@gmail.com>
X-Google-Original-From: Artem Blagodarenko <ablagodarenko@thelustrecollective.com>
To: linux-ext4@vger.kernel.org
Cc: adilger.kernel@dilger.ca,
	Artem Blagodarenko <ablagodarenko@thelustrecollective.com>,
	sashiko-bot <sashiko-bot@kernel.org>
Subject: [PATCH v12 00/11] Data in direntry (dirdata) feature
Date: Sat,  1 Aug 2026 14:12:14 -0400
Message-ID: <20260801181227.5198-1-ablagodarenko@thelustrecollective.com>
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

Changes in v12:

Patch 09 (dirdata LUFID rename): fix late kmalloc(edp) in
ext4_rename().

When RENAME_WHITEOUT renames a LUFID-carrying entry into a slot that
does not yet exist (!new.bh), the edp allocation for ext4_add_entry()
was placed after ext4_setent(&old, ...) had already called
ext4_setent_compact_exts() to overwrite the LUFID bytes with CFHASH
data.  An -ENOMEM failure at that point sent the error path through
ext4_resetent(), which restores the LUFID flag from the saved
file_type but cannot restore the LUFID bytes — the same lossy state
described in the "Known limitation" comment in the whiteout error
path, but triggered deterministically by memory pressure rather than
requiring a journal IO error.

Fix by hoisting the edp allocation before ext4_setent() so that if it
fails nothing has been modified.  Move edp to function scope and free
it unconditionally at end_rename.  Update the "Known limitation"
comment to note that OOM can no longer trigger this path.

Reported-by: sashiko-bot <sashiko-bot@kernel.org>
Closes: https://sashiko.dev/#/patchset/20260731235043.44068-1-ablagodarenko@thelustrecollective.com?part=11

Sashiko v11 findings NOT addressed (false positives):

Part 1 [High] — OOB read in ext4_htree_next_block when metadata_csum
is disabled.  Pre-existing, out of scope.

Part 2 [High] — OOB read when verifying a directory entry near the end
of a block buffer.  Pre-existing, not introduced by this series.

Part 4 [High] — get_dtype() broken by high file_type bits.  False
positive: EXT4_FT_MASK masks the upper bits correctly.

Part 4 [Critical] — file_type corrupted during VFS rename.  False
positive: ext4_setent() explicitly manages all dirdata flag transitions
via masking rather than full overwrite.

Part 5 [Low x2] — build failures: ext4_dir_entry_len() declaration and
dot_de reference in dx_root_limit().  False positives: sashiko reviewed
a transient version of the code that differs from the submitted patch.

Part 6 [Critical] — ext4_dir_rec_len() omitting hash space causes
overflow.  False positive: add_dirent_to_buf() explicitly adds
sizeof(struct ext4_dirent_hash) to dlen for dirdata+hash_in_dirent;
including it in both places would double-count.

Part 6 [High x4] — unvalidated rec_len to ext4_dirent_get_data_len();
name_len + dirdata integer truncation; length underflow in
make_indexed_dir() (pre-existing); rename corrupting dirdata flags.
All false positives: bounds are checked before the calls; truncation
cannot occur because dirdata is bounded by rec_len; flag management in
ext4_setent() uses masking.

Part 7 [High] — OOB read in ext4_read_inline_dir() via new
ext4_dir_entry_len() call.  False positive: size argument is correctly
bounded before reaching that path.

Part 7 [Critical] — double-fetch TOCTOU via DMA mutating de->rec_len.
False positive: DMA-mutating block device threat model does not apply
to standard ext4 usage.

Part 7 [Low x2] — build failures from ext4_find_dest_de() prototype
change and dx_show_leaf() missed rename.  False positives: series
builds cleanly; sashiko reviewed different source versions.

Part 8 [Low] — edp_dfid incompatible pointer type.  Fixed in patch 11
with explicit cast.

Part 8 [High x3] — uninitialized stack via fake '.' / '..' entries
(pre-existing); missing sizeof(dx_countlimit) in bounds check
(pre-existing); index corruption for un-migrated entries.  All
pre-existing or false positives.

Part 9 [High] — clearing EXT4_DIRENT_LUFID without compacting leaves
CFHASH at wrong offset.  False positive: ext4_setent_compact_exts()
physically slides CFHASH bytes into the vacated LUFID slot before
clearing the flag.

Part 9 [High] — missing READ_ONCE() on ddh_length in
ext4_lufid_snapshot().  False positive: dlen is a local unsigned int
variable; the compiler cannot re-fetch it from the on-disk structure
after it has been loaded into a register.

Part 10 [High x4] — uninitialized stack via fake entries (pre-existing);
OOB read parsing legacy hashes (pre-existing); memmove() in compact_exts
skips INO64 between LUFID and CFHASH; ext4_resetent() restores LUFID
flag but not bytes after compact_exts.

The INO64 concern is a false positive for the current series:
EXT4_DIRENT_INO64 is defined but no code path in this series writes
INO64 records to directory entries, so LUFID is always immediately
followed by CFHASH when both are present.

The resetent finding is the existing "Known limitation" already
documented in the whiteout error path — not a new finding.  It is
addressed in v12 for the OOM-triggered case (see Changes in v12 above);
the journal-IO-error case remains documented as a known limitation.

Part 11 [High] — unprivileged user can trigger filesystem read-only
remount by inducing memory pressure during SET_LUFID rollback.  Not a
regression; inherent in the delete-then-re-add approach shared with
other ext4 operations; per errors= mount option behavior is the
mitigation.

Part 11 [High] — case-equivalent encrypted filename re-encrypts to
larger ciphertext.  False positive: fscrypt ciphertext length equals
plaintext length for all supported modes, so a case-equivalent name
always produces an identical-length ciphertext.

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
 fs/ext4/namei.c           | 1281 +++++++++++++++++++++++++++++++------
 fs/ext4/sysfs.c           |    2 +
 include/uapi/linux/ext4.h |   14 +
 9 files changed, 1495 insertions(+), 250 deletions(-)

--
2.43.7
