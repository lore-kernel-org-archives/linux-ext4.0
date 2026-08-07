Received: from mail-pl1-f179.google.com (mail-pl1-f179.google.com [209.85.214.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1DB2E39280D
	for <linux-ext4@vger.kernel.org>; Fri,  7 Aug 2026 17:05:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786122331; cv=none; b=Ha4aLXXh1wJ39i7HjOajmh+Q98lWkOovil2Ldi/z22en5YhIJhipdi+eRhQY3VNmmEoRnfsaAuGgC9YD/SKfxPnfl5BKa6wgYB6i5Hi/DAbTYFLpFBtawYyXSTXnN2dJktos99QUerpQBonP7HzCSCRVcUvJzv88X6QRyOktpX4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786122331; c=relaxed/simple;
	bh=eX0ZasYDtx64R2J4lQw/mZJY9ymS3HrnzTxpVFzdTII=;
	h=Content-Type:Mime-Version:Subject:From:In-Reply-To:Date:Cc:
	 Message-Id:References:To; b=CE2Du1LtUDtvOjiovaHN+We2ORmUmWGCNHS0NvUQTRrJyyNC6DM0uDW3qLzU141ZOWJxbS78YjmsLgNZ5NC96uhJev8eNFQQyUU+PZcpopvb7Z6Cu7M+JJxkYX0bySW9AAyfVQ/6pRb0OfJrl60+IC4umFn1foVaDnHc2E5RPSU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=dilger.ca; spf=pass smtp.mailfrom=dilger.ca; dkim=pass (2048-bit key) header.d=dilger-ca.20251104.gappssmtp.com header.i=@dilger-ca.20251104.gappssmtp.com header.b=t/E+OoWq; arc=none smtp.client-ip=209.85.214.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=dilger.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=dilger.ca
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=dilger-ca.20251104.gappssmtp.com header.i=@dilger-ca.20251104.gappssmtp.com header.b="t/E+OoWq"
Received: by mail-pl1-f179.google.com with SMTP id d9443c01a7336-2ccf2360620so36041895ad.3
        for <linux-ext4@vger.kernel.org>; Fri, 07 Aug 2026 10:05:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=dilger-ca.20251104.gappssmtp.com; s=20251104; t=1786122328; x=1786727128; darn=vger.kernel.org;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:content-type:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=IKOPhmsoZx6W5ioYp3LC6nts6HH4XpJ6kDd/UehpFEc=;
        b=t/E+OoWqU535Q5eQ1PQep01yqAe00rb023hKwoWHFUz4I59vC9557ioLT8vaVqyuft
         pPPNjOtAFrvAXE3Z8Z9Dm6xt+vI3wgB5zzbSAzlTTX3OyBtdyJTEAUlvS4ArNy/sUifY
         a7YMuMAtun5+y7HwmhngbivLbCgzsjqYLxjCbAufLphVcZXgokZP4c19hJndNGiqyVjd
         rQdXbiHup/GZOZrIjy06UWTVRGx/YnJwYJQ/GEVvpB8j7dRqt9fycLUd5AsKkW4tuSfx
         /OwAApaeeVPRMFvw9o550/oZY9O5mckFMGtN+hruvc8uCFvWYNT8Tf8HpnruWk7R3RLy
         +Vpw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786122328; x=1786727128;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:content-type:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=IKOPhmsoZx6W5ioYp3LC6nts6HH4XpJ6kDd/UehpFEc=;
        b=VXckwMArKB+FuomlOmEzlw3GE91EFidIzAEjpARAGYsZcWV2+SmSiiL+jirMJkwwc+
         OoN+3Jjz9bxQQIxb8CqQqQ4xv2nIjfMFdARGsU4crivwDXeb6lNNcW3hp/JqIAypqf49
         4iW+CyqNgSXYHPWGd6rauWXjaMG7QAT2ef1C96v1RtggIkRavdZUGifwkb5ymzV9qiH7
         IGVtanqynXdUepbEisNxcOzKCK2HxTXp6IQFV6FO8Zv9ZX/WWLOtpfT8c+zTWxTDYLzY
         IG556xsL3r1hdRTbQ5ygDs76HpznIzlJnuyQj10UB5+rQHSWSCvvRDJRaNyb69cNmQuQ
         bnyA==
X-Gm-Message-State: AOJu0YxjwIsnGjydNrG7uksKNhPYXfGrS/mHMZaXAiwsvORQNyw+JLjq
	nXIaIyLcB6oB5roIRvUo+lGh1QN8xYuLnrohOeQUzYLF68fLQXoUABYTsGJ5FdFXR4E=
X-Gm-Gg: AR+sD11GX6EluCrf3QKcpK7aFGbGYErmSUDtPxVtqOFl7kEVt9FLKMwshQBtT3XxP5F
	zNuR6GJ6WroI1nBVjVD2jmw2BXM4yIOFE7c1X0dwTvXqZ5kAOlxUOoECwrR8f5ebx66k3OoCK5p
	oT4CvRIMw+bCnChsz+cRvunLTta4v+w3LLVdmpxJ/rIT7++B0lJXdz7gri0JpcnmVMoMXDQ5zla
	uVrJ6NfBjEnrDIKpZOcw1f4AcIR7jU/3NL/Fldhw6td86CpxW1JvSeZyLPXfUXTEFI6g5sraeQC
	M9cLbtmYfXpfY34Q1eW8S15+yt2uwVEOcpFX4bf6KQD/fPfyikRLTrOAbih+pIHKxxbS91gEiF1
	wr5fQXueYutqskrwM4hohm1R1mGCC3nGeejG+F5y7aKnOw1z5zOCGApuw48XGpOqMGZ2YHjpFyI
	0d6inGfO2X2yPnUkN+SVnEXLY9iOYWJ/EWPlroqx/hHjyvhmiTDsEDUoF4nMiBPFXIVfKLVIUuz
	2fa48r3asz9+KmAVWW5H+n8banLjA==
X-Received: by 2002:a17:903:1aa6:b0:2c8:f34c:82c0 with SMTP id d9443c01a7336-2d106a18e41mr138248755ad.2.1786122328133;
        Fri, 07 Aug 2026 10:05:28 -0700 (PDT)
Received: from smtpclient.apple ([2604:3d09:3a84:1700:d0c2:7960:7499:e072])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2d14d57fc23sm12480325ad.31.2026.08.07.10.05.27
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 07 Aug 2026 10:05:27 -0700 (PDT)
Content-Type: text/plain;
	charset=us-ascii
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3864.100.1.1.5\))
Subject: Re: [PATCH v12 00/11] Data in direntry (dirdata) feature
From: Andreas Dilger <adilger@dilger.ca>
In-Reply-To: <CA+rD4x8W0uOg0CkoPYD3krLekLiCtDS0hCScRVEoNwzuu-77qg@mail.gmail.com>
Date: Fri, 7 Aug 2026 11:05:16 -0600
Cc: linux-ext4@vger.kernel.org,
 Artem Blagodarenko <ablagodarenko@thelustrecollective.com>
Content-Transfer-Encoding: quoted-printable
Message-Id: <A9B10667-90AF-4552-80BA-5878A167A1EF@dilger.ca>
References: <20260801181227.5198-1-ablagodarenko@thelustrecollective.com>
 <CA+rD4x8W0uOg0CkoPYD3krLekLiCtDS0hCScRVEoNwzuu-77qg@mail.gmail.com>
To: Theodore Ts'o <tytso@mit.edu>,
 Jan Kara <jack@suse.cz>
X-Mailer: Apple Mail (2.3864.100.1.1.5)

On Aug 2, 2026, at 03:39, Artem Blagodarenko =
<artem.blagodarenko@gmail.com> wrote:
>=20
>  Sashiko flagged 29 potential issues across the v12 series. I have =
gone
>  through all of them.
>=20
>  The vast majority are false positives. The most common causes:
>=20
>  - Sashiko reviewed intermediate patch states rather than the final
>  committed code (reported build failures and missing updates that do
>  not exist in the submitted series).
>  - Findings about clearing EXT4_DIRENT_LUFID without compacting
>  remaining extensions: ext4_setent_compact_exts() in patch 10 does
>  exactly this before the flag is cleared.
>  - Several findings concern pre-existing issues in make_indexed_dir(),
>  dx_release(), and the htree checksum paths that are not introduced
>  by this series.
>  - The silent-rename concern for encrypted+casefolded directories in
>  SET_LUFID: ext4_fname_setup_filename() normalizes the plaintext
>  before encrypting, so different-case input produces the same
>  ciphertext.
>=20
>  If any small issues remain after this analysis they can be addressed
>  in the normal review round with developers.
>=20
>  The series is ready for review. I would appreciate a look from the
>  ext4 maintainers.

Hi Ted, Jan,
I think that several of the early patches in this series are just code
cleanups before the main feature implementation and could be reviewed
and landed with fairly low effort.  That would help reduce the number
of patches that need to be rebased and posted each time to the list.

> Artem Blagodarenko (11):
>  ext4: validate count against limit in ext4_dx_csum_verify/_set

This is a bugfix for bad on-disk data.

>  ext4: replace ext4_dir_entry with ext4_dir_entry_2
>  ext4: add ext4_dir_entry_is_tail()
 =20
These are code cleanups in preparation for the main feature but do
not affect normal operations.

> ext4: add dirdata format definitions and access helpers

This one is reserving code points for the dirdata feature (unused).

>  ext4: refactor dx_root to support variable dirent sizes

This is also a code reorg that doesn't affect current functionality,
but a bit more involved than the previous ones in terms of changes.

>  ext4: add ext4_dir_entry_len()
>  ext4: rename ext4_dir_rec_len() and clarify dirdata usage

These ones are also code reorg/cleanup.=20

>  ext4: dirdata feature

The first one is the main functionality of the dirdata feature,
which would need the most review.  While the core of this code
has been used for many years, it has needed some changes to work
with the fscrypt+casefold feature.

>  ext4: add dirdata LUFID support for directory entry rename

This is also part of the main feature, but is split out to reduce
the initial patch size since it is somewhat isolated.

>  ext4: add dirdata set/get helpers
>  ext4: Add EXT4_IOC_SET_LUFID ioctl for setting LUFID on directory
>    entries

These ones are adding the test interface.

Cheers, Andreas





