Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66AB53F075A
	for <linux-ext4@vger.kernel.org>; Wed, 14 Oct 2026 16:11:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791994309; cv=none; b=BTqYKIc5R1YV8dsP8OJgr/iEGdZV/+ebcvfsq/J60GjOH+1FsXl0rxyAr6rfQ0Xuj+RRgRUm6VMuduoRH2gUqYSAepf+1bf8iAy7XB4z4oH4O9f6IuNOdhkVjNead/MUvLu+6FnTSWMwLKWDaRR66/XfVzrdBIg5cJ3zWdmFRh0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791994309; c=relaxed/simple;
	bh=XiUd1a/9S7PL57cb+1mAKiPUhriOuOBrSA+pOERyx6k=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=lgIph70nv3OL3Dz3eEJVZduCmcEBz3axNQ8jI6/YccXJoXWYXYZdKk02Z0exO+Pd/1yywKhOgHzqgfsc6DNxhVDV32aTYdVEiRkqKOB/UgzgAgzVLVzlztRvDKrjjILVO0vBrteq4WDh3BNKNtdcCVyFQj2smaIYqG0MsYsfa9g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=EWntehCr; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="EWntehCr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B767A1F000C4;
	Wed, 14 Oct 2026 16:11:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791994304;
	bh=Kqh4nqRU2O7HdhLjcbRAoJBKYGZ1AzqUUtwv/yNEayI=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=EWntehCrD1jC9jAKFRy+vjFbfS54cM/5/+3sthUTmUw9sJk9ExWV5CirpTSaltVJb
	 /RdRMVGu8A9W8DEx/IZugW+3PQR5ALcDz97iqD9Mh0SIQP1MxGs9VS00J+YtSx2k9S
	 iRN4GFJL9V0ulLmdQXc0CzHE1Dnj4nhux64uzmszauHSe4slx9kUpTtvpUKQJQivzB
	 +fDoJe+4ljgNbWEQu7QNrYx94B65N3MSEYVgpMunCkom5O41e4zNVTPcJzYNnoV+Xw
	 my7sklffMVRhF95apgus09+cvVwjigEAyq73o/+h92Par2+lRvmtv3uF7+drM6CljI
	 Q16ID3Hlv2lzQ==
Message-ID: <sashiko-outbox-171517@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 5.10] ext4: fix out-of-bounds read in
 ext4_read_inline_dir()
Reply-To: sashiko-reviews@lists.linux.dev
To: "Mikhail Dmitrichenko" <mdmitrichenko@astralinux.ru>
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu
In-Reply-To: <20261014153817.239-1-mdmitrichenko@astralinux.ru>
References: <20261014153817.239-1-mdmitrichenko@astralinux.ru>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 14 Oct 2026 16:11:44 +0000
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>

> From: Xiang Mei <xmei5@asu.edu>
>=20
> commit 9333cc809f0a89e001b814155a6cb8903a6274df upstream.
>=20
> ext4_read_inline_dir() can read a dirent header past the end of its inline
> buffer, triggering a slab-out-of-bounds read during getdents64():
>=20
>   BUG: KASAN: slab-out-of-bounds in __ext4_check_dir_entry
>   Read of size 2 at addr ffff88800f3dd23c by task exploit/148
>    ...
>    __ext4_check_dir_entry
>    ext4_read_inline_dir
>    iterate_dir
>=20
> The dirent payload lives in a buffer of exactly inline_size bytes:
> [ ... ]
> Signed-off-by: Theodore Ts'o <tytso@mit.edu>
> [ mdmitrichenko: use EXT4_DIR_REC_LEN(1) instead of
>   ext4_dir_rec_len(1, NULL), which does not exist in 5.10; both compute
>   the same minimal dirent length. ]
> Signed-off-by: Mikhail Dmitrichenko <mdmitrichenko@astralinux.ru>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261014153817.239-=
1-mdmitrichenko@astralinux.ru?part=3D1

