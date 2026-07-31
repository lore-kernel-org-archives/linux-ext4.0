Received: from mail-pg1-f170.google.com (mail-pg1-f170.google.com [209.85.215.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C941C2367D3
	for <linux-ext4@vger.kernel.org>; Fri, 31 Jul 2026 09:04:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785488645; cv=none; b=EQ6cxsgn14CFP6/XCSg43dKnHMcWozBFeFru9tnzqBAPmr0qf13h3M7sExQA1F+EM8Mr8mMZfnsWJq3bLBde1SzkfU8SZjbC1kn4H5+cUDFZJ51szXCZJbV41Snatms7VezALU0Odibt25NDLNAv5PHmiMdfSq6jcX59B9x2huc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785488645; c=relaxed/simple;
	bh=X+lxUUffc1nL8N5SdPB6j78+ZWblrGTRYDpbuIgf8SE=;
	h=Content-Type:Mime-Version:Subject:From:In-Reply-To:Date:Cc:
	 Message-Id:References:To; b=e+A0fjQyhGdAYwhE2r4E6Ef7jHfV8+KZx7R0swhDJI0UEkvzx57P6eSueiiZ2AZPei1p1TJOlCMKHWyi09hEBjcDCW7HNtdvslL93fvfPl9oNsENDk8dr02NLmlaWtcxy5UsVeeizH5TU+OfahFTN1kAvZ2ggv9+erjNxfqhYOc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=dilger.ca; spf=pass smtp.mailfrom=dilger.ca; dkim=pass (2048-bit key) header.d=dilger-ca.20251104.gappssmtp.com header.i=@dilger-ca.20251104.gappssmtp.com header.b=FdVb8Sk9; arc=none smtp.client-ip=209.85.215.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=dilger.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=dilger.ca
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=dilger-ca.20251104.gappssmtp.com header.i=@dilger-ca.20251104.gappssmtp.com header.b="FdVb8Sk9"
Received: by mail-pg1-f170.google.com with SMTP id 41be03b00d2f7-cbb8b54fcf8so662738a12.0
        for <linux-ext4@vger.kernel.org>; Fri, 31 Jul 2026 02:04:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=dilger-ca.20251104.gappssmtp.com; s=20251104; t=1785488643; x=1786093443; darn=vger.kernel.org;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:content-type:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=cm4zyI1iYO86IIZBtMdXQKPEKB2NZ6BJEG7Btqh2BT0=;
        b=FdVb8Sk94yG6HD3V13OLBa8FTnim+yYHWzBTcSDS37XCSGGrKo906kpXfv9L4rvp61
         2gm3gZ58hpc3uL4fgkCtWNbditcOWEqnOOcMzWDyw9AGr3XxcXFHpyneU/P6JoLi1l3o
         yQpf6p8SO2zBpDijEiBAuk1FaFn7kQZZ9BKoFLCmuaA2+6LMMBw7Pki32bRCX+TrQdXS
         wNAPSoyyO+obwVV0+SeHteqx22eK835e5pKw4+qgZvZSVWxoE2/1YRUlxWLcmdpe0kcu
         7ncQ2QLPVH9golPpit59bF6Ze7s5ZKeP+oDKDNTYlIFi9iMZr7ZHask+krskg0PBoqUs
         tC2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785488643; x=1786093443;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:content-type:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=cm4zyI1iYO86IIZBtMdXQKPEKB2NZ6BJEG7Btqh2BT0=;
        b=CkEhe6pYoLyEWAPfYXgkUxfdtQaOS3VpcHo7BBx+4TDKdPwEQWlCdfenPSA0QpE75l
         3wrl/w1z1cvEIaSL2KPEy4qnludsgbn5vF7czBv6SjziK4juTcMVL1dkACFGOJuteql2
         IexANZ4vcfqj2LqrSFRjIGur5CEHPxp1zC2gk+mVRkAAtehxqNjN8SGJKTzlcktEmrfu
         nZqq/fbjZUQuct8tysCWxgedrd68vsJJsJx+qgFpdfz7iN1W1uiwvE6KMOPAP3Js9Qfe
         iwhELgYtDCizo0chuQecgAl/WARdT/Qq9QZ8hxoX+2wGLgYGC2spLoZ7vrntyh4BHhjC
         R7eQ==
X-Gm-Message-State: AOJu0YzxP2XLwIosbw7gREqWRF2HJnF9qRgw5Q3eZFE1lwAJRVYm1eAK
	qOUeLaY7KJzh798RMbvPP1gXx9fZCiCyL3Ac9kK307LDg49yfkdYudpCSXAJTiZE+Uh/gEwqCu5
	v/jZ9
X-Gm-Gg: AR+sD10m31BizCbuMjdxEHBKITlXOODG1cSkvJrI7PDDz1MChJMdZ7jzC02yLp08l2h
	NrlUCajERvsN+wPHNzIOVz5ITt4/ggfUSQoAaHfdj79MEf3weAICZTkmKPGJKCKUfwxnX7WTO6n
	FDtMdXE9bTRPTzACDJkdpcmosaVn53zTW1ErjBgKzCHHpMc16gjCe910t3etgOCuL2su+NazfaE
	6vtCZ1RsBfS/UVUGzcYAacZR/Xv+LOmo2N89WA2XTPLMhNqYRSHVzChAZbEvPIwmwfr4E1nOcQi
	XoAFef0yf73vvUt8rb1fXnoSRzMQTHuO2LdGxf8yMV/EiAi63Qv2eu5FmzU466w+sReSO5L2kr4
	QUKZJ8RFohltcqoU4cAl1A/pUXbQP5zstilVRsbHnQ58cnanpRzld5mXfapmC3/TsKes1xx88vt
	u/C7oO4YAHUumDcH5nuAPvQ0CO1e9sbE4AMHkXev9NeZd0iA+521WLTdSUpbDgghp8KW+B/DykO
	R1VbH7OF0eTD1hi0A==
X-Received: by 2002:a05:6a21:394c:b0:3c4:2cf9:28a2 with SMTP id adf61e73a8af0-3c91b31c474mr1245941637.40.1785488643127;
        Fri, 31 Jul 2026 02:04:03 -0700 (PDT)
Received: from smtpclient.apple ([2604:3d09:3a84:1700:f8b1:79a1:822f:ff0e])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-cbe396ea57dsm318268a12.21.2026.07.31.02.04.02
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 31 Jul 2026 02:04:02 -0700 (PDT)
Content-Type: text/plain;
	charset=us-ascii
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3864.100.1.1.5\))
Subject: Re: [PATCH 3/3] tune2fs: Add bounds checking for extended attribute
 processing
From: Andreas Dilger <adilger@dilger.ca>
In-Reply-To: <20260731033701.2657758-4-johunt@akamai.com>
Date: Fri, 31 Jul 2026 03:03:50 -0600
Cc: linux-ext4@vger.kernel.org,
 kknox@akamai.com,
 tytos@mit.edu
Content-Transfer-Encoding: quoted-printable
Message-Id: <571CFA6C-DE4F-4ED3-B680-C544E6B514D6@dilger.ca>
References: <20260731033701.2657758-1-johunt@akamai.com>
 <20260731033701.2657758-4-johunt@akamai.com>
To: Josh Hunt <johunt@akamai.com>
X-Mailer: Apple Mail (2.3864.100.1.1.5)

On Jul 30, 2026, at 21:37, Josh Hunt <johunt@akamai.com> wrote:
>=20
> From: Kit Knox <kknox@akamai.com>
>=20
> Add validation to prevent buffer overflow when processing extended
> attributes:
>=20
> - Check ea_inode size against maximum (64KB) before reading
> - Validate xattr entry bounds before accessing next entry
>=20
> This prevents malformed filesystem images from causing out-of-bounds =
memory
> access during UUID or checksum updates.

This looks like it will result in a totally corrupted filesystem, rather =
than
just a bad extended attribute?

> Signed-off-by: Kit Knox <kknox@akamai.com>
> ---
> misc/tune2fs.c | 19 ++++++++++++++++---
> 1 file changed, 16 insertions(+), 3 deletions(-)
>=20
> diff --git a/misc/tune2fs.c b/misc/tune2fs.c
> index 3db57632..8c292686 100644
> --- a/misc/tune2fs.c
> +++ b/misc/tune2fs.c
> @@ -775,6 +782,9 @@ static int update_xattr_entry_hashes(ext2_filsys =
fs,
>  	errcode_t retval;
>=20
>  	while (entry < end && !EXT2_EXT_IS_LAST_ENTRY(entry)) {
> +	if ((char *)end < (char *)entry + sizeof(*entry))
> +		fatal_err(EXT2_ET_EA_BAD_NAME_LEN,
> +			  "xattr entry exceeds buffer bounds");
>  	if (entry->e_value_inum) {
>  	retval =3D ext2fs_ext_attr_hash_entry2(fs, entry, NULL,
>  					     &entry->e_hash);
> @@ -784,6 +794,9 @@ static int update_xattr_entry_hashes(ext2_filsys =
fs,
>  		}
>  		entry =3D EXT2_EXT_ATTR_NEXT(entry);
>  	}
> +	if (entry > end)
> +		fatal_err(EXT2_ET_EA_BAD_NAME_LEN,
> +			  "xattr entry exceeds buffer bounds");
>  	return modified;
>  }

If the tune2fs UUID update that is changing the checksums of all inodes =
and
xattrs in the filesystem is interrupted, this will leave a filesystem =
with
half (or whatever) inodes using the new checksum and half with the old =
checksum,
rendering it mostly useless.

It would be better to just skip these bad inodes during processing and =
leave
it to e2fsck to correct them.  At least the uncorrupted inodes in the =
filesystem
(presumably a majority) will still be usable, and these xattrs will have =
a bad
checksum and presumably not be used.

Cheers, Andreas





