Received: from mail-pf1-f171.google.com (mail-pf1-f171.google.com [209.85.210.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3F1543F092
	for <linux-ext4@vger.kernel.org>; Thu, 16 Jul 2026 20:06:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784232400; cv=none; b=S3PNVXoyk8037VwsKlXkuXUvrBCJWgkPLbVdtT8LPQ6WpBSfWI++JeJvyDoLZBPD0fK05xoreKhUA5KD90/04c9a2plM97QtFk8RkgzfAyJvSiOpnDI0u+bnT32XSNtbfed6+sBImeTA4ox9rOaq62ldB6LypVCg4YAY0l3edcs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784232400; c=relaxed/simple;
	bh=fNHHGp0EJ1x8ScHNM/7lzcXfwm8VZZI1x1y+I4XbQI0=;
	h=Content-Type:Mime-Version:Subject:From:In-Reply-To:Date:Cc:
	 Message-Id:References:To; b=XdB2/aJElXQdk9WnxfXkk/vyjLkQZG4UwEQDLr9iYBtRcowunfA3BWv7TmTIGS1gMDcUbJsqsJJ+nn+EZPuE8QbdRMwQpRL15UaBP+xXS4cnXIu5F+m4i7aCeaWaY98fit59eNX1Zo7S/iD7XP70S9dXesvrTZWLwlBxOvVwFGc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=dilger.ca; spf=pass smtp.mailfrom=dilger.ca; dkim=pass (2048-bit key) header.d=dilger-ca.20251104.gappssmtp.com header.i=@dilger-ca.20251104.gappssmtp.com header.b=NpctwYBB; arc=none smtp.client-ip=209.85.210.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=dilger.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=dilger.ca
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=dilger-ca.20251104.gappssmtp.com header.i=@dilger-ca.20251104.gappssmtp.com header.b="NpctwYBB"
Received: by mail-pf1-f171.google.com with SMTP id d2e1a72fcca58-8484a0b998fso5774815b3a.2
        for <linux-ext4@vger.kernel.org>; Thu, 16 Jul 2026 13:06:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=dilger-ca.20251104.gappssmtp.com; s=20251104; t=1784232397; x=1784837197; darn=vger.kernel.org;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:content-type:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=IhOk14OQie19o7dvSDhMtIyzpvh/v4dYOVAo+3UUl9o=;
        b=NpctwYBBG9G4G12nvNeuVsnPWU45M90UHAkn3lWcNiSkdUx1quXxYL5Bjrbq4/kNss
         YpHs8pEz22XvQstuPlocU4i/XmJEo2yj9/FeFwpyywMrFDQOyVpx6pXgZyeX/RwQj+at
         htylrTzkxLNMouJu8zAqUkH5tvMpEdhWFUKM2qaxt4d5upl1n4uaGMcuJDmKMZjWddrk
         sKNUimyRWvXdHVWEutvmV+ex5rN1nyes2g9rCzwoMzc/DoMbVt6/3lMWVqOLwEIg5Si8
         pQ8tZA2NgWesh/e0WUlFaZ51+PTopa0BvW/4IqndzqigkHbuPFdw9rR4ydsnBS3Vfxof
         U6ug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784232397; x=1784837197;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:content-type:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=IhOk14OQie19o7dvSDhMtIyzpvh/v4dYOVAo+3UUl9o=;
        b=QgM/bodSOLiPm1v8Jo7mv7iyoml/NBAU4paVKJnHYw/WAHgf0EXrn7lyawaBPNxXf/
         3ue1npEfvDfeHqUUJ/y6NYSjxDMrVFUFtT2Irh/Q5zb+DUkrynkCxpUi8XiOjm+mWhJt
         bADbg0XyVOBgjMu7ALPfzcdhtTWb6SJQo/xv93rU/BpgEcii4t/Ug6uRYrRFQpCGZUsu
         IWAVquz+HevzJqvOteR+gShDLJwoI6W2YHgs2SK73wbZSp1B0pwkwLp7dHSJ4uB5Ce2D
         UMMLryWUtsQMeuEmWBDX/GyqvhhaerzA2t1ZUcNCekD9lMYsZyTHKHjok2HGECFjNPaJ
         WU5A==
X-Forwarded-Encrypted: i=1; AHgh+RrDJ20tQWJQt7LT4L+rI2QuNaYZJq4v4D1DQOYgQIbBCHEG9cGG1+5O5m4I5i5v4TRUK7fg6/kAtorl@vger.kernel.org
X-Gm-Message-State: AOJu0YysMP6LYHQTXoAoNK/gznlvT2WEkheNZJt0LfZd8V11Fy157QHu
	wXq5zMWtv0EPFXoDjPmbSYJ+3fx9wYl6UwK7xdtPePPHSJ3vyMpmuynVQ74TrgEDS7E=
X-Gm-Gg: AfdE7cl4WLtsQI3KSnlIAyl4kg94jkHwTL47Ci0sg+y81ocqKN7dD7XUWoJLRKdnsfX
	WbKdHTw/H3Pn/k7FW7lT6ZuG8MLvQCE1AdSjInpxbBO7Cocyh6itJ7dlN0MEdJuEyPTcrEj7DTM
	dO/OPt/ctZ5SRYVpikOcg11KTlN6E/Fx542rzZLfJORjKb/iCVnQvLMpwZmhLwUqJ4yBtIY7DpE
	g44f6wyWALs3Ckt4QSctlV0SilKJi+hiIDtrYeEeeBhJZVhdEiG+lwkfoWqoPvhP7MfuFrpK/85
	DToFgwxtQG/RNCW/r+yJDUqfqHge2VpN4C8Mc/HNIGO+zEGmjlcnf4ErENuQQ41fNTfLvKKRm4e
	zQgC9N4pYTDpW32ZIV2AN8MmHvFFa2eMhoL0YTYXXsd6QBRN7thwE0pQk8/8Irr0WyT8RiOKUzn
	pO1VNeAerA3WVqSN/TNIwRF3dpY0hWz8w=
X-Received: by 2002:a05:6a00:b93:b0:848:4faa:480b with SMTP id d2e1a72fcca58-84c234f9f15mr773017b3a.12.1784232396934;
        Thu, 16 Jul 2026 13:06:36 -0700 (PDT)
Received: from smtpclient.apple ([2604:3d09:3a84:1700:3854:7eec:417a:89dd])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-84a4f7dade0sm5343740b3a.46.2026.07.16.13.06.35
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 16 Jul 2026 13:06:36 -0700 (PDT)
Content-Type: text/plain;
	charset=us-ascii
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3864.100.1.1.5\))
Subject: Re: [PATCH] ext4: check dir entry fits before reading the hash
 trailer in ext4_search_dir()
From: Andreas Dilger <adilger@dilger.ca>
In-Reply-To: <20260709184101.441348-1-xmei5@asu.edu>
Date: Thu, 16 Jul 2026 14:06:24 -0600
Cc: Theodore Ts'o <tytso@mit.edu>,
 Baokun Li <libaokun@linux.alibaba.com>,
 Jan Kara <jack@suse.cz>,
 Ojaswin Mujoo <ojaswin@linux.ibm.com>,
 "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>,
 Zhang Yi <yi.zhang@huawei.com>,
 linux-ext4@vger.kernel.org,
 linux-kernel@vger.kernel.org,
 Daniel Rosenberg <drosen@google.com>,
 Weiming Shi <bestswngs@gmail.com>
Content-Transfer-Encoding: quoted-printable
Message-Id: <8767153C-ED7C-473A-A8FF-3A7F431979DB@dilger.ca>
References: <20260709184101.441348-1-xmei5@asu.edu>
To: Xiang Mei <xmei5@asu.edu>
X-Mailer: Apple Mail (2.3864.100.1.1.5)

On Jul 9, 2026, at 12:41, Xiang Mei <xmei5@asu.edu> wrote:
>=20
> For casefolded encrypted directories ext4 stores an 8-byte hash =
trailer
> after the name (EXT4_DIRENT_HASHES()), at an offset derived from
> de->name_len.  On the sb_no_casefold_compat_fallback() path =
ext4_match()
> reads that trailer, but ext4_search_dir()'s by-hand pre-check only =
tests
> de->name + de->name_len <=3D dlimit, which proves the name fits, not =
the
> rounded trailer.  A crafted entry whose name ends at the block =
boundary
> passes the check while EXT4_DIRENT_HASHES(de) lands past the block =
end,
> so ext4_match() reads out of bounds on an ordinary lookup.  KASAN =
reports
> it as a use-after-free when the page after the directory block holds a
> freed object:
>=20
>  BUG: KASAN: use-after-free in ext4_match (fs/ext4/namei.c:1435)
>  Read of size 4 at addr ffff888010458000 by task exploit
>  Call Trace:
>   ext4_match (fs/ext4/namei.c:1435)
>   ext4_search_dir (fs/ext4/namei.c:1470)
>   __ext4_find_entry (fs/ext4/namei.c:1268 fs/ext4/namei.c:1632)
>   ext4_lookup (fs/ext4/namei.c:1703 fs/ext4/namei.c:1769)
>   ...
>   filename_lookup (fs/namei.c:2842)
>   vfs_statx (fs/stat.c:353)
>   __do_sys_newfstatat (fs/stat.c:538)
>   do_syscall_64 (arch/x86/entry/syscall_64.c:94)
>   entry_SYSCALL_64_after_hwframe (arch/x86/entry/entry_64.S:121)
>=20
> Require, for hash-in-dirent directories, that the whole entry =
including
> the rounded trailer fits before calling ext4_match().  This is the =
same
> bound ext4_check_dir_entry() already enforces via ext4_dir_rec_len(), =
so
> no well-formed entry is rejected.  The other caller, =
ext4_find_dest_de(),
> runs ext4_check_dir_entry() first and is unaffected.
>=20
> Fixes: 471fbbea7ff7 ("ext4: handle casefolding with encryption")
> Reported-by: Weiming Shi <bestswngs@gmail.com>
> Assisted-by: Claude:claude-opus-4-8
> Signed-off-by: Xiang Mei <xmei5@asu.edu>

Reviewed-by: Andreas Dilger <adilger@dilger.ca =
<mailto:adilger@dilger.ca>>

> ---
> fs/ext4/namei.c | 2 ++
> 1 file changed, 2 insertions(+)
>=20
> diff --git a/fs/ext4/namei.c b/fs/ext4/namei.c
> index cc49ae04a6f6..3b9740c1c16d 100644
> --- a/fs/ext4/namei.c
> +++ b/fs/ext4/namei.c
> @@ -1467,6 +1467,8 @@ int ext4_search_dir(struct buffer_head *bh, char =
*search_buf, int buf_size,
>  		/* this code is executed quadratically often */
>  		/* do minimal checking `by hand' */
>  		if (de->name + de->name_len <=3D dlimit &&
> +		    (!ext4_hash_in_dirent(dir) ||
> +		     (char *)de + ext4_dir_rec_len(de->name_len, dir) <=3D=
 dlimit) &&
>  		    ext4_match(dir, fname, de)) {
>  			/* found a match - just to be sure, do
>  			 * a full check */
> --=20
> 2.43.0
>=20


Cheers, Andreas





