Received: from mail-pj1-f53.google.com (mail-pj1-f53.google.com [209.85.216.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C0CD357739
	for <linux-ext4@vger.kernel.org>; Fri, 31 Jul 2026 08:42:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785487354; cv=none; b=L+Fc8Z5ze4CekYmF74CSXD64FIQZOBemzgrdezBBnFh3yRqh59ortVrF4HyijaQHHk65Bij1EQVd78jurAW/Uxp1KOAX8+3nY85t+Hb8jmCwRP+JBctRFa2tPkyWBwSKhPJ08R4C35Hz1aO6y091J+PXgqvUbxQFo4Jeeo4OBks=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785487354; c=relaxed/simple;
	bh=HWDV1Evex+aV/mjKWAvBXR18U2LBHorY1IAkSgdaBRU=;
	h=Content-Type:Mime-Version:Subject:From:In-Reply-To:Date:Cc:
	 Message-Id:References:To; b=VTlGNptAhRx+8m6NW4YL4u7yG65ilAsyrCvh88ThVUWdFi3Qvpn+/Wzx/UtAhkWl1T15GLrzOci/a7H6FXE4N+PBSr1QbR/hTKfXpaDc1W801Vo4a2rZclXu02E+MTqo5LmrZ2Pzq96H+G5k/weNb0VEnHybZU/HWGt3Pk2whKI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=dilger.ca; spf=pass smtp.mailfrom=dilger.ca; dkim=pass (2048-bit key) header.d=dilger-ca.20251104.gappssmtp.com header.i=@dilger-ca.20251104.gappssmtp.com header.b=jjLWlx3n; arc=none smtp.client-ip=209.85.216.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=dilger.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=dilger.ca
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=dilger-ca.20251104.gappssmtp.com header.i=@dilger-ca.20251104.gappssmtp.com header.b="jjLWlx3n"
Received: by mail-pj1-f53.google.com with SMTP id 98e67ed59e1d1-382ef647e20so804459a91.1
        for <linux-ext4@vger.kernel.org>; Fri, 31 Jul 2026 01:42:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=dilger-ca.20251104.gappssmtp.com; s=20251104; t=1785487351; x=1786092151; darn=vger.kernel.org;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:content-type:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=DbbO3fr7xWt32XZ1QH337NY1sEeG568oOzLScpsGiy8=;
        b=jjLWlx3nAT/giEPTIWsgIT6HfVJZX9yFKv0b5j/ngfbk/xywdT6+J0uJ13B+KfXIvY
         e3jmNR3ISS79LHQtCuIuts/F91mugGQzs62MdT8VmIFpCFYRIQlc7bMKdYsrr6KEOZ1D
         zlyCSs8OaYDR07Ubg/MjSFO9GRiUKysgqN4yxyJQaX8hgd4eiWhyGzTVHlgNcQOQeeVC
         QIbbU6vuEUZLy1lPKP7Dm9hKJkdUlYYAKxnyxGSGnGeBZFxubPIYwbzgxoKNYxNWpJkL
         tLmI0QhQAc9SqeGse44iwkf15ClKr9I65tIhjUmCAtK65MJry8ZthHa1jlYQX1hA0mGh
         nnfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785487351; x=1786092151;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:content-type:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=DbbO3fr7xWt32XZ1QH337NY1sEeG568oOzLScpsGiy8=;
        b=mf9FZ0iTZYdtGD4jtpmu6g9mzphM67mRdklC2sbSC44OZiePOVxg/jPBpqxcxt5/LT
         HgXe+Ow4CT/t4G6iLFWc5pby0ZQBmCetmksV28QODrEdl70ne/KC3GUhnRQiaLh2HiQr
         Pl48Bw8D266HzRmy/qTJVWUqbypqg6sD1wMHFUIMpKSnr155lYtdojEFPIS3zRAO0dUY
         9rBWQQ14a8tF9SAooZ57dlqNusin6SOgrh7PP7X2rw00Y4A4E8PAyG86Dxcyg1eJ91Tk
         V1qswUnCYlQwNMaJ6mKdVoVt3fLI9IhLIa3PZt499uYDAsG+Ta7yI0ivlRJx9VKlq0PZ
         nTbA==
X-Gm-Message-State: AOJu0YwUB5CjNn0pIfcOxHgOb0RDKzNPqHIELzYKmr0PPOBB0idQJ9AG
	wdNdhr/BuK6kCzaGZZVqvr2GOAfs9o6Z73vQDSA/s6UKGVTCzJVgFDCLuEGzx4hcTBA=
X-Gm-Gg: AR+sD12J0W3RFzn75J1XWQ25CL5yEtWfLChxcAUQqzLa3q8rT4sg9mbhbgJp54olvpU
	D9ILKHSvMDXk4CdhcJz1b1m0XssdGCvZiXhZ/IppylO+nza6hnzHJHLIrefYfR+6pEHjWsSoyf6
	uIMNCrQlnF5g0rtJg3yFyJpCrtdUutXQ6LhvXE+FYpZjcXfxeWJSJlHgSaNmrg1qLOWWD4NLsFN
	yre9N8qJy9LzIBlINOBlp7t+I8mXxggy0idHsabyMvliKPtYqgRH8RyI7jyeIrx0nOEgcRF9rZn
	rYT0DWFVls2gM+u69A4EgSrm49yCRkl17rlcb8p4OeZBcIfM+QlXITpc1RGxLmZH5pow2zS54PO
	WNoLCye52uFqMq5KvsVKqpf2wndteEa2gN+FlrrWyq5wKyXU2mwq6RIPfWT5+LCVJiBppb5s2dJ
	kAOjFFxdXl9vqMi8J3Pa5axIxRsuvtxgV2OEfaSKkR75gf1hqlUjrx4OoGpuVvb+Lt+AErBiC9T
	Bg8Lu9q1mCxz0GAiQ==
X-Received: by 2002:a17:90b:5109:b0:38f:5801:dc0e with SMTP id 98e67ed59e1d1-38fb118a575mr1068630a91.15.1785487351347;
        Fri, 31 Jul 2026 01:42:31 -0700 (PDT)
Received: from smtpclient.apple ([2604:3d09:3a84:1700:ac28:4325:669e:a7ef])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-38fb2d19f7fsm395727a91.17.2026.07.31.01.42.30
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 31 Jul 2026 01:42:30 -0700 (PDT)
Content-Type: text/plain;
	charset=us-ascii
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3864.100.1.1.5\))
Subject: Re: [PATCH 1/3] resize2fs: out-of-bounds read/write in xattr entry
 scanning
From: Andreas Dilger <adilger@dilger.ca>
In-Reply-To: <20260731033701.2657758-2-johunt@akamai.com>
Date: Fri, 31 Jul 2026 02:42:19 -0600
Cc: linux-ext4@vger.kernel.org,
 kknox@akamai.com,
 tytos@mit.edu
Content-Transfer-Encoding: quoted-printable
Message-Id: <7457784C-3BD0-44DD-9682-6AEA69335995@dilger.ca>
References: <20260731033701.2657758-1-johunt@akamai.com>
 <20260731033701.2657758-2-johunt@akamai.com>
To: Josh Hunt <johunt@akamai.com>
X-Mailer: Apple Mail (2.3864.100.1.1.5)

On Jul 30, 2026, at 21:36, Josh Hunt <johunt@akamai.com> wrote:
>=20
> From: Kit Knox <kknox@akamai.com>
>=20
> The fix_ea_entries() function iterates over extended attribute entries
> using the loop condition "while (entry < end && =
!EXT2_EXT_IS_LAST_ENTRY(entry))".
> This check is insufficient because:
>=20
>  1. It does not verify the full 16-byte ext2_ext_attr_entry structure =
fits
>     within the buffer before accessing its fields. With fewer than 16 =
bytes
>     remaining, evaluating EXT2_EXT_IS_LAST_ENTRY() reads past the =
buffer.
>=20
>  2. A crafted e_name_len value can cause EXT2_EXT_ATTR_NEXT() to =
advance
>     past the buffer boundary, and subsequent iterations read/write =
beyond
>     allocated memory.
>=20
>  3. When entry->e_value_inum > last_ino, resize2fs writes to =
entry->e_value_inum,
>     potentially corrupting heap memory.
>=20
> Additionally, fix_ea_ibody_entries() does not validate i_extra_isize =
before
> using it to compute xattr offsets. A malformed inode with an invalid
> i_extra_isize value (unaligned or too large) causes out-of-bounds =
reads
> when accessing the ea_magic field.
>=20
> Signed-off-by: Kit Knox <kknox@akamai.com>
> ---
> resize/resize2fs.c | 21 ++++++++++++++++++++-
> 1 file changed, 20 insertions(+), 1 deletion(-)

This seems reasonable.

Reviewed-by: Andreas Dilger <adilger@dilger.ca =
<mailto:adilger@dilger.ca>>

Cheers, Andreas





