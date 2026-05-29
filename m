Received: from mail-pg1-f182.google.com (mail-pg1-f182.google.com [209.85.215.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A893D4A23
	for <linux-ext4@vger.kernel.org>; Fri, 29 May 2026 00:09:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780013377; cv=none; b=X9zX2/3cJ04hxf2qOZqNhYOgOd3m4JoXD5oKuxsxynDmDme02nlQNFNKLd/ULfdS9uXvYpht4kXD1td0OLZ7PoRCwCaytGb9esfocvGNEDIBj1K9nXy15gn7rPRPyRxycIWVFHaYCuj5XWG69YxkVHxG82ZVNhbD483LptTxT3Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780013377; c=relaxed/simple;
	bh=agoP33qqrnpF6wUa8kJcR1fjCsWgHetDJ6dBScMF6ro=;
	h=Content-Type:Mime-Version:Subject:From:In-Reply-To:Date:Cc:
	 Message-Id:References:To; b=GPlxbn6X1u9L2a+dRqPRNBDugGJFsdCCS7plIUsosX7jNjLl2yW5B7Y73RWv/BnFtDxKGlaDFG+uTJkAn7aOg7hHtFjc+EmqeYgp9rj0FSxjDB1yVvom3c1mYHE2k6Zwpz9mM2UK+RSh37Z7XTqjAjYGaD4c5BbWoyi7erq0ubo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=dilger.ca; spf=pass smtp.mailfrom=dilger.ca; dkim=pass (2048-bit key) header.d=dilger-ca.20251104.gappssmtp.com header.i=@dilger-ca.20251104.gappssmtp.com header.b=KJCZm+gQ; arc=none smtp.client-ip=209.85.215.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=dilger.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=dilger.ca
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=dilger-ca.20251104.gappssmtp.com header.i=@dilger-ca.20251104.gappssmtp.com header.b="KJCZm+gQ"
Received: by mail-pg1-f182.google.com with SMTP id 41be03b00d2f7-c85067c9ccdso3527849a12.3
        for <linux-ext4@vger.kernel.org>; Thu, 28 May 2026 17:09:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=dilger-ca.20251104.gappssmtp.com; s=20251104; t=1780013375; x=1780618175; darn=vger.kernel.org;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=INi7/vTfr9N6nEn248w6f4cK4B++dmJqe7pjpM+B4X8=;
        b=KJCZm+gQtArde24Nf3wSlblvzBP/YueLqvRKLc7RRAoEaGxsEZialX0WxcC0/LnMbb
         PF29umA6D3Cf1ffg/qWW5xqPm9Fh/xpB8NMBHjJC40hfjucr6rNKQug9+szFhYPxH7qO
         fZCOV9RAIENNybZvaTnrXLm1kibq13BfZ55MLc29aihL0e3GTnac9L92Eg6nKFU3ZUk7
         b1YXkJ+7L3GltfXUfX2CHBAaSxFhpYKkTrCPUj5+jdIGrM6gAll4lClXhDvggvgHowTm
         jIkRe86tLk2aBlCfQKiV38GCNWP1sJoY5B82Mr3/0neUnQvw7KpnyVAMilbxNJwx7GqI
         hIEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780013375; x=1780618175;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:x-gm-gg:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=INi7/vTfr9N6nEn248w6f4cK4B++dmJqe7pjpM+B4X8=;
        b=Hz7dsRohd59YJND08LSx6t29E+MjtXRkqav23FGqg1bQ09B0USNSf2x1O/+lTJvRzw
         GpunRi/yQuqZ54zy8VH0YESYAnyl/4T0ozQH3uC6oTXBLDQAIqtYDI0ykh7GULR+BsYy
         EnuBo0gCyFd5afQyF8lB8pToBGwAEPrNw+DOpuIWiFxCWTiEYA3e3csSrBecroaiydh5
         pqpnadsFIdSwjJURau/TlJVQPI4VV19Z7Mb+W9GXCqnsCVPGa3Er3YHUupNB/7ZHoKlT
         s6+m0lneOq192FDRqIayDO9q84yFmXuYG8kh3jLwSdgK18Um5U0VdMhXSchxqVUag6Mk
         kwMg==
X-Gm-Message-State: AOJu0Yw/tAvGTrGJCM5g1l84A8M4PUtU0zArg3Z7gQO4KKQJZxl3jxRb
	Y7X+VKSmp80+BxdHqsc8FgUMSrXuq7OrVlv6CIjddrXExhc5r2DZfz7+gDKEWMGNFKk=
X-Gm-Gg: Acq92OGcVq1SB1qTlhTxH6uj1crLOrbtxMPt97hP91moiLRIBL815qRx0CoPGCpEG0s
	fbng3QsE+j1ycu19X+VAnR2Mw5SZPS9/vMilHggUdSSE4o3Wu+pMFwel+feX5t8CtiyoSz5Xij2
	bBKv/1Dx6P7i75dllZjk1mcsTvlIF9iT96hySNxZl6bqoNDbJxX7gSKu5E6HsrrFQzv/9JOsi00
	cTViS7ta8FN76PoFH4y2hVxymLbKpVcD3kmI+oB24cVGFuqG2yNe6YcEuMkLP9bdtMCAMRF6p0u
	74/BnVBxJa+wHjGxeox6fE6yCDOCKoNOIc2evRK5+oiY3aHrwFGawySbQAH3IWOapw7qoc9uNvu
	aSsEtPVOdDTS1vi7k9dliSJm7d8Qe0PA5UpUmdm/kfnVaEvevO4YI4zLBV0IgJjWUB4dMl9a2v5
	Ad9k46reZxtfTGi69FzBV7ujPuVXZd3rsnmMFVaT/+TUVePOEYhKL/SDCnnzLF7BQghE1IZvOvS
	Wvgue7uLq9cYbJc
X-Received: by 2002:a05:6a00:12ea:b0:83e:f208:b113 with SMTP id d2e1a72fcca58-84212a9528emr383510b3a.7.1780013375002;
        Thu, 28 May 2026 17:09:35 -0700 (PDT)
Received: from smtpclient.apple (S01068c763f81ca4b.cg.shawcable.net. [70.77.200.158])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-8421350e367sm108789b3a.54.2026.05.28.17.09.33
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 28 May 2026 17:09:34 -0700 (PDT)
Content-Type: text/plain;
	charset=us-ascii
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3864.100.1.1.5\))
Subject: Re: [PATCH] ext4: validate dx count against limit in dx_csum
From: Andreas Dilger <adilger@dilger.ca>
In-Reply-To: <20260528160557.6956-1-ablagodarenko@thelustrecollective.com>
Date: Thu, 28 May 2026 18:09:22 -0600
Cc: linux-ext4@vger.kernel.org,
 Theodore Ts'o <tytso@mit.edu>
Content-Transfer-Encoding: quoted-printable
Message-Id: <71AB6638-1EF8-4098-837E-3A5E32549B7D@dilger.ca>
References: <20260528160557.6956-1-ablagodarenko@thelustrecollective.com>
To: Artem Blagodarenko <artem.blagodarenko@gmail.com>
X-Mailer: Apple Mail (2.3864.100.1.1.5)

On May 28, 2026, at 10:05, Artem Blagodarenko =
<artem.blagodarenko@gmail.com> wrote:
>=20
> From: Artem Blagodarenko <artem.blagodarenko@gmail.com>
>=20
> Sashiko AI, during inspection of the "ext4: replace ext4_dir_entry
> with ext4_dir_entry_2" series, reported a missing bounds check on
> count against limit in DX block checksum verification and setup
> paths.
>=20
> The code validates that limit fits within block boundaries, but does
> not verify that count <=3D limit. A maliciously crafted filesystem =
image
> could therefore provide an artificially large count value.
>=20
> Since ext4_dx_csum() uses count to determine the checksum region
> size, this may result in an out-of-bounds access crossing page
> boundaries into unmapped memory, potentially leading to a crash during
> checksum verification.
>=20
> The same issue exists in ext4_dx_csum_set().
>=20
> The bug was not introduced by the patch under review, so the fix is =
sent
> separately.
>=20
> Signed-off-by: Artem Blagodarenko artem.blagodarenko@gmail.com

Reviewed-by: Andreas Dilger <adilger@dilger.ca =
<mailto:adilger@dilger.ca>>

> ---
> fs/ext4/namei.c | 6 ++++--
> 1 file changed, 4 insertions(+), 2 deletions(-)
>=20
> diff --git a/fs/ext4/namei.c b/fs/ext4/namei.c
> index a316fc2ac41b..20b7bac69889 100644
> --- a/fs/ext4/namei.c
> +++ b/fs/ext4/namei.c
> @@ -472,7 +472,8 @@ static int ext4_dx_csum_verify(struct inode =
*inode,
> }
> limit =3D le16_to_cpu(c->limit);
> count =3D le16_to_cpu(c->count);
> - if (count_offset + (limit * sizeof(struct dx_entry)) >
> + if (!count || count > limit ||
> +    count_offset + (limit * sizeof(struct dx_entry)) >
>    EXT4_BLOCK_SIZE(inode->i_sb) - sizeof(struct dx_tail)) {
> warn_no_space_for_csum(inode);
> return 0;
> @@ -501,7 +502,8 @@ static void ext4_dx_csum_set(struct inode *inode, =
struct ext4_dir_entry_2 *diren
> }
> limit =3D le16_to_cpu(c->limit);
> count =3D le16_to_cpu(c->count);
> - if (count_offset + (limit * sizeof(struct dx_entry)) >
> + if (!count || count > limit ||
> +    count_offset + (limit * sizeof(struct dx_entry)) >
>    EXT4_BLOCK_SIZE(inode->i_sb) - sizeof(struct dx_tail)) {
> warn_no_space_for_csum(inode);
> return;
> --=20
> 2.43.7
>=20


Cheers, Andreas





