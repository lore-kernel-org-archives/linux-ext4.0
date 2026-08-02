Received: from mail-yx1-f52.google.com (mail-yx1-f52.google.com [74.125.224.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8E2039769E
	for <linux-ext4@vger.kernel.org>; Sun,  2 Aug 2026 09:39:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.224.52
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785663580; cv=pass; b=RnpAjG5UriXx/KyHc/YsilEj5dCYHLdZ0YT+41+OACGjMulqHWybREKm566moNFX68+jhTYIiGUZ7UXNNW0bsszcejoFHDojyQ4fUU+unvuvpSfzdUeb/MgPosLbcxWLvRHg8qJjmpGLFTfylwN5D2sqjRaW/Ra1/Pebc2X5w+I=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785663580; c=relaxed/simple;
	bh=edMquinGBt4YqIw146h+ESxD8iwyi870NYm/QdJCAsE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=cxFOva5a/bpV/Jr/oFvYd5ieArAbU88a/ReR1TUO6UbrRMCIvwToGIUG/8WGsp7HiR6hFha0YkgFrvmLXVieO4ScCD53kj3weew5fDD6tPbAJ0ZZ36mTy++ND7gYE0QbBEFQNcHNPqUqO+fcG4rqi7bbND2Sy9TyH4O8XqL4dA4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=GPC8lM6I; arc=pass smtp.client-ip=74.125.224.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="GPC8lM6I"
Received: by mail-yx1-f52.google.com with SMTP id 956f58d0204a3-668296d0ff3so3361633d50.0
        for <linux-ext4@vger.kernel.org>; Sun, 02 Aug 2026 02:39:37 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1785663576; cv=none;
        d=google.com; s=arc-20260327;
        b=ZBqIoiZrT5CYbZptiX0BdPAqOJJPSYZXp0oARFNlGwTcFig23wM4WjtKCGdZUP0UT2
         NKmHE2AvnjCoI4kD4ZiWUVX8KkKAWzz1VrRK6yHrEQ81dTsVz2XfNF03ezZ8z9LdbM2X
         sBSQC0MJ52wi/P5ELAVLbXnlLV1VZbgAvfpeo4Lw67pNPktIAn3eBtz5iTSrnRN+yU30
         GLpdO0lfahIwEh4HwdSKVNLMu2IJpM2LEmwSECrYmZTNFKV4Tx22QAI2aKJ5e1k/zC/d
         yKa8aZKgY0darS9KfzsFRKQnmYVN4ucd/s7wTgLG2SMkkwNHDrLUPeqXhvI0A7LfBo8w
         Gxwg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=Nf9O5rau2c66ayM1ymE2qnYLB1gXGYrFBsmh87vrlkg=;
        fh=UPLwQAmQdet7m2hPl5F49uPnZGA61GkMZXfTuwl1GRY=;
        b=dj4DuDYGIAc2YW+sGLHd2elqwy4RdTjeRuFNjOAwrtUXHbXxZequiOcgKZbEJFKCwB
         q8V5zorzjiuGgAJQXS0ngPmob8AXurxDIOR4UunHrh5ut3r04STKN51UNThBPDxLKTq6
         Gl0EiBGCnB17AahvIDOpivpGghD7fW2K0budv7KWBrbxfWNp82xVkDYKX+FXdm06hU8/
         ZHap0SLr1aC3aQiItZn4ax2lNSKGnHDzswRXkq68Mpsdb1dUga0pRQM1mfBXIB3ud5FQ
         AUmFahBChYB9R029AJgWc5r/MI+Y2BaUiTgiDQgJX6l3eIcDGsZsckDY0oI+7cECnAyG
         zc+w==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785663576; x=1786268376; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=Nf9O5rau2c66ayM1ymE2qnYLB1gXGYrFBsmh87vrlkg=;
        b=GPC8lM6IeXNcARNhUPoPnIWcUNsvVCdnhasqKL2pyFiN4kv0PFrfeq6Lujf6Pq3N08
         a1oE2PkqSnWLOUG8KtHH46nH9BPgufM3xe9L9fhdwYmNkXePKm6kQpf3zi5chN8zHpY6
         S6RGpypdaH7xw7wl43Nr3aRUFuI6o6CbWbLDAOO/OKBA2RLXsl2to6d+kypmCfhxGRLC
         JqachWd6KrCEA1IJQzx1qLRw3lU+hE36nBvVJZcUzStFsxNe5KitNzecrFnGQ/tky55k
         +KdoZaSeuAb+tgVxiJ08AYES+Ldh4zA7cwf5RwZcyG20cexxsHbjWAy9nzBXNv/BU6vk
         8RFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785663576; x=1786268376;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Nf9O5rau2c66ayM1ymE2qnYLB1gXGYrFBsmh87vrlkg=;
        b=aooCtwzk0izeIbvykIEbra+rnpswzF40i8JGaENQ0syz8VwnhSXqTon3x2683UsSAJ
         ReZfJxduWUXNcVjWHBKANuVUg9xXWZ2/OucaT/yyVSdwJ6zGHF+pzzhtY+yY90twhgW5
         FUAqPnitLxafqtK7M1VZwUbuEOECyFB8XM57x7NBhu9Scyg1q/aORB7Ev3pMSpNxJcqU
         Kuf62a2Zqac3r4FjM3KAxVqqrK57uLKrxrm8YFYGf1V1oFaULsD3kyiLwvoRyYuBFU5m
         MQtJPiB+xelS9FHVG+xNwgCp61v784CkawTP7Wy8fH6izp+pAXPjee//V3GEDETd7GZX
         V0oA==
X-Gm-Message-State: AOJu0YxMHMYbnoJWKRVvBIbuR64D3vYMunIi5aMOs7WTHzN4w65WsJbx
	6M1AXAZWfsP6031PZznNLwnpcdF2tWJBdfSrLfa49EgBViiv+xjHb8/oBLDqTEAZqJ8aoGtHGr+
	SqwN97aSOyRk8325LOWdyTJuZrcobcCR0/UpG
X-Gm-Gg: AR+sD12QnsrkbKIRfHMgeUNUdbI+Pd2QeOgtt8icfQ3NgZ4t+pbwmoqcpzP+r7SHDoZ
	TfSx/f8vUE8lY8ZWHQgwscIj/p1n2iM5Ds4SFEeaxbAv/Gq1cm1nPDeBsu3VK1kXHye95rNzuHO
	qTThFt76nQK7fxwjA1aMCmFPwjlBASFfV6pcdnogfZWtDoo0sVLakTlpTNT8D4W8HQCfOwH7wQ+
	MLbO7FkzE+RkEFz6P6fvElAAT/al0ErptCpm6MU/f9NWJVwn/0yh3ai5tEkYo5sZECUuj1xEkbg
	ZReh+SVvaayQCazYI2mJu/Nbw+5XXh7fTSE1L9POUgBulhxDbhVA5WjTpi31m05fRrk6RWWsUOs
	=
X-Received: by 2002:a05:690e:186:b0:667:689d:531c with SMTP id
 956f58d0204a3-6694f08cc2bmr5636426d50.5.1785663576287; Sun, 02 Aug 2026
 02:39:36 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260801181227.5198-1-ablagodarenko@thelustrecollective.com>
In-Reply-To: <20260801181227.5198-1-ablagodarenko@thelustrecollective.com>
From: Artem Blagodarenko <artem.blagodarenko@gmail.com>
Date: Sun, 2 Aug 2026 10:39:25 +0100
X-Gm-Features: AUfX_myl7wrqVz62FZ5Fj3oSUCHJKt4Zh5KTFLtQX5lSJmvOw4wpluEZPqYNdmo
Message-ID: <CA+rD4x8W0uOg0CkoPYD3krLekLiCtDS0hCScRVEoNwzuu-77qg@mail.gmail.com>
Subject: Re: [PATCH v12 00/11] Data in direntry (dirdata) feature
To: linux-ext4@vger.kernel.org
Cc: adilger.kernel@dilger.ca, 
	Artem Blagodarenko <ablagodarenko@thelustrecollective.com>, 
	sashiko-bot <sashiko-bot@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi,

  Sashiko flagged 29 potential issues across the v12 series. I have gone
  through all of them.

  The vast majority are false positives. The most common causes:

  - Sashiko reviewed intermediate patch states rather than the final
  committed code (reported build failures and missing updates that do
  not exist in the submitted series).
  - Findings about clearing EXT4_DIRENT_LUFID without compacting
  remaining extensions: ext4_setent_compact_exts() in patch 10 does
  exactly this before the flag is cleared.
  - Several findings concern pre-existing issues in make_indexed_dir(),
  dx_release(), and the htree checksum paths that are not introduced
  by this series.
  - The silent-rename concern for encrypted+casefolded directories in
  SET_LUFID: ext4_fname_setup_filename() normalizes the plaintext
  before encrypting, so different-case input produces the same
  ciphertext.

  If any small issues remain after this analysis they can be addressed
  in the normal review round with developers.

  The series is ready for review. I would appreciate a look from the
  ext4 maintainers.

  Thanks,
  Artem


On Sat, 1 Aug 2026 at 19:13, Artem Blagodarenko
<artem.blagodarenko@gmail.com> wrote:
>
> EXT4 currently stores an 8-byte hash in the directory entry immediately
> after the file name to support simultaneous fscrypt and casefold
> functionality.
>
> The dirdata feature provides a general mechanism to store multiple
> metadata records in each directory entry after the NUL filename
> terminator. The unused high 4 bits of 'file_type' indicate which
> records are present; each record starts with a 1-byte length field,
> providing forward compatibility.
>
> The first user of this feature is LUFID (Locally Unique File ID), an
> identifier that must survive rename and be accessible from directory
> readdir without an inode lookup.
>
> e2fsprogs support is provided in a separate patch series.
>
> Thanks to Sashiko AI review for identifying several correctness and
> safety issues in earlier versions of this series.
>
> Changes in v12:
>
> Patch 09 (dirdata LUFID rename): fix late kmalloc(edp) in
> ext4_rename().
>
> When RENAME_WHITEOUT renames a LUFID-carrying entry into a slot that
> does not yet exist (!new.bh), the edp allocation for ext4_add_entry()
> was placed after ext4_setent(&old, ...) had already called
> ext4_setent_compact_exts() to overwrite the LUFID bytes with CFHASH
> data.  An -ENOMEM failure at that point sent the error path through
> ext4_resetent(), which restores the LUFID flag from the saved
> file_type but cannot restore the LUFID bytes =E2=80=94 the same lossy sta=
te
> described in the "Known limitation" comment in the whiteout error
> path, but triggered deterministically by memory pressure rather than
> requiring a journal IO error.
>
> Fix by hoisting the edp allocation before ext4_setent() so that if it
> fails nothing has been modified.  Move edp to function scope and free
> it unconditionally at end_rename.  Update the "Known limitation"
> comment to note that OOM can no longer trigger this path.
>
> Reported-by: sashiko-bot <sashiko-bot@kernel.org>
> Closes: https://sashiko.dev/#/patchset/20260731235043.44068-1-ablagodaren=
ko@thelustrecollective.com?part=3D11
>
> Sashiko v11 findings NOT addressed (false positives):
>
> Part 1 [High] =E2=80=94 OOB read in ext4_htree_next_block when metadata_c=
sum
> is disabled.  Pre-existing, out of scope.
>
> Part 2 [High] =E2=80=94 OOB read when verifying a directory entry near th=
e end
> of a block buffer.  Pre-existing, not introduced by this series.
>
> Part 4 [High] =E2=80=94 get_dtype() broken by high file_type bits.  False
> positive: EXT4_FT_MASK masks the upper bits correctly.
>
> Part 4 [Critical] =E2=80=94 file_type corrupted during VFS rename.  False
> positive: ext4_setent() explicitly manages all dirdata flag transitions
> via masking rather than full overwrite.
>
> Part 5 [Low x2] =E2=80=94 build failures: ext4_dir_entry_len() declaratio=
n and
> dot_de reference in dx_root_limit().  False positives: sashiko reviewed
> a transient version of the code that differs from the submitted patch.
>
> Part 6 [Critical] =E2=80=94 ext4_dir_rec_len() omitting hash space causes
> overflow.  False positive: add_dirent_to_buf() explicitly adds
> sizeof(struct ext4_dirent_hash) to dlen for dirdata+hash_in_dirent;
> including it in both places would double-count.
>
> Part 6 [High x4] =E2=80=94 unvalidated rec_len to ext4_dirent_get_data_le=
n();
> name_len + dirdata integer truncation; length underflow in
> make_indexed_dir() (pre-existing); rename corrupting dirdata flags.
> All false positives: bounds are checked before the calls; truncation
> cannot occur because dirdata is bounded by rec_len; flag management in
> ext4_setent() uses masking.
>
> Part 7 [High] =E2=80=94 OOB read in ext4_read_inline_dir() via new
> ext4_dir_entry_len() call.  False positive: size argument is correctly
> bounded before reaching that path.
>
> Part 7 [Critical] =E2=80=94 double-fetch TOCTOU via DMA mutating de->rec_=
len.
> False positive: DMA-mutating block device threat model does not apply
> to standard ext4 usage.
>
> Part 7 [Low x2] =E2=80=94 build failures from ext4_find_dest_de() prototy=
pe
> change and dx_show_leaf() missed rename.  False positives: series
> builds cleanly; sashiko reviewed different source versions.
>
> Part 8 [Low] =E2=80=94 edp_dfid incompatible pointer type.  Fixed in patc=
h 11
> with explicit cast.
>
> Part 8 [High x3] =E2=80=94 uninitialized stack via fake '.' / '..' entrie=
s
> (pre-existing); missing sizeof(dx_countlimit) in bounds check
> (pre-existing); index corruption for un-migrated entries.  All
> pre-existing or false positives.
>
> Part 9 [High] =E2=80=94 clearing EXT4_DIRENT_LUFID without compacting lea=
ves
> CFHASH at wrong offset.  False positive: ext4_setent_compact_exts()
> physically slides CFHASH bytes into the vacated LUFID slot before
> clearing the flag.
>
> Part 9 [High] =E2=80=94 missing READ_ONCE() on ddh_length in
> ext4_lufid_snapshot().  False positive: dlen is a local unsigned int
> variable; the compiler cannot re-fetch it from the on-disk structure
> after it has been loaded into a register.
>
> Part 10 [High x4] =E2=80=94 uninitialized stack via fake entries (pre-exi=
sting);
> OOB read parsing legacy hashes (pre-existing); memmove() in compact_exts
> skips INO64 between LUFID and CFHASH; ext4_resetent() restores LUFID
> flag but not bytes after compact_exts.
>
> The INO64 concern is a false positive for the current series:
> EXT4_DIRENT_INO64 is defined but no code path in this series writes
> INO64 records to directory entries, so LUFID is always immediately
> followed by CFHASH when both are present.
>
> The resetent finding is the existing "Known limitation" already
> documented in the whiteout error path =E2=80=94 not a new finding.  It is
> addressed in v12 for the OOM-triggered case (see Changes in v12 above);
> the journal-IO-error case remains documented as a known limitation.
>
> Part 11 [High] =E2=80=94 unprivileged user can trigger filesystem read-on=
ly
> remount by inducing memory pressure during SET_LUFID rollback.  Not a
> regression; inherent in the delete-then-re-add approach shared with
> other ext4 operations; per errors=3D mount option behavior is the
> mitigation.
>
> Part 11 [High] =E2=80=94 case-equivalent encrypted filename re-encrypts t=
o
> larger ciphertext.  False positive: fscrypt ciphertext length equals
> plaintext length for all supported modes, so a case-equivalent name
> always produces an identical-length ciphertext.
>
> Artem Blagodarenko (11):
>   ext4: validate count against limit in ext4_dx_csum_verify/_set
>   ext4: replace ext4_dir_entry with ext4_dir_entry_2
>   ext4: add ext4_dir_entry_is_tail()
>   ext4: add dirdata format definitions and access helpers
>   ext4: refactor dx_root to support variable dirent sizes
>   ext4: add ext4_dir_entry_len()
>   ext4: rename ext4_dir_rec_len() and clarify dirdata usage
>   ext4: dirdata feature
>   ext4: add dirdata LUFID support for directory entry rename
>   ext4: add dirdata set/get helpers
>   ext4: Add EXT4_IOC_SET_LUFID ioctl for setting LUFID on directory
>     entries
>
>  fs/ext4/dir.c             |   49 +-
>  fs/ext4/ext4.h            |  245 ++++++-
>  fs/ext4/fast_commit.c     |    1 +
>  fs/ext4/fast_commit.h     |    1 +
>  fs/ext4/inline.c          |   67 +-
>  fs/ext4/ioctl.c           |   85 +++
>  fs/ext4/namei.c           | 1281 +++++++++++++++++++++++++++++++------
>  fs/ext4/sysfs.c           |    2 +
>  include/uapi/linux/ext4.h |   14 +
>  9 files changed, 1495 insertions(+), 250 deletions(-)
>
> --
> 2.43.7
