Received: from mail-yw1-f172.google.com (mail-yw1-f172.google.com [209.85.128.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50D322E0412
	for <linux-ext4@vger.kernel.org>; Tue, 10 Mar 2026 01:47:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.128.172
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773107265; cv=pass; b=BRF9jnVMl//itBr+LjjLTQQOEwfPaZpfbqG69W7xB0XLdQuX+h33MiX8OgB0lD5yQUiFH8vxOGtU2zmEh69V+Ayjtst8Jm3NlaQEMh4AQ15XPSjRGt7JwXHugBiocVperBmgbQCL9b9/bab3GtigLTmz4LOINUX2eCC4Ni1lEx8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773107265; c=relaxed/simple;
	bh=UPMa6xgG3LM9+Nwf/dXzLKcFwczVPcNQahg+dPhaK+M=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=QE21wTe8CNMOB6XR6R0t2dszuzsDAfS7VlbHCBwzfOdoDfDEal0LiSdnSTnMTPAVRCE6pW8b0LLiP1ljzYYdpFdqGPzV2L5lewdi8EP9QLrbPsip+RBzIiutSUhJFOuFnNg/kJSoGFM1aheUHfCin8SffspLwNslgFJz0XqH62U=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=CGIrvzas; arc=pass smtp.client-ip=209.85.128.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="CGIrvzas"
Received: by mail-yw1-f172.google.com with SMTP id 00721157ae682-79800183233so167364377b3.1
        for <linux-ext4@vger.kernel.org>; Mon, 09 Mar 2026 18:47:42 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1773107261; cv=none;
        d=google.com; s=arc-20240605;
        b=BpifWTcCUhYYzIM2vRSeq085NPIC8pNrDLkWXbRdurPViqxifID3bYARB8WYCEnibf
         kAdwz5p2mUukmbAAllIugBIB41wJ1nL8G2uKLUGQ3QH7WUivQiOgSxxAKRg+rGmxCXhc
         YWK4Sbt1QUJ5b6uTtDz+zIuOOSYi8w9AgM3DaNorzr9ryLrvJh2khD5FdGdy0uXeGmsR
         p63ct5BAUKqA6MYCkk9dIiTraWpg9qiIv736t+csDlkivnYknYEssBCKnmTXDiT86g2W
         4tcHZfS6nZpNvoJmTw/Di7KLYNWuSnlVecRVcHI5ErqfSERgkv7SYXXbcmoFuIIV9t+y
         8YIQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=OTZMlLJPL1UA9q9adEkklMKU1Oh84O2m52X9NniWPGM=;
        fh=ZoofJVupeQq3V1d+jf3gKtwdnpZ1rYOVMOiK3QgF4S8=;
        b=Rbd014FmazOG5p3+iQ/lGgwDCBU8oL+8CGb/6vnSnNAvYKswu7yKqt0pKupgU1JbxZ
         Pcj2mry/cuGNnwGpnUUyNCtEUkorR6ltoB07uwWO6x3Ar9RTm6rdHurWYGWaYchFWlzx
         5id1fPtUiEu31cROD+pCGFkTG4biuGrmg0PjHb2vC1kyIrNd7lBCKG24IWybiJ0IENsN
         YIaap/81emQlcLoDssFypetZ5+of1pGBbEJWNAPS1mcQ8Ry2Edj8FABIGGGx3x91dllC
         HV1Ko0KVmywlAXig894U11ZFxqZeerxd41SldE2UKuQz7rDMcqOwdRZOvHBlIBDsehOI
         tKHw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1773107261; x=1773712061; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=OTZMlLJPL1UA9q9adEkklMKU1Oh84O2m52X9NniWPGM=;
        b=CGIrvzas55lWGpX7D75iKlm1Gdauu+XKgHDjVeuk0RWe9prxUdh/IJ2EvRjOgW7wDD
         m8LCNi7MuakuOq/Cha1exzFpqo+yMfRwlXUUO9IlKd1JPDO5poY/MFlyC1ZF2uWkSV7i
         6BSk87k3AwEUOZfYZoGDoZF+CXOc1SY7VXpxBqH6MMvEB2h8pQpKcuVDOavu/TCA6lD0
         zW8Cri0wZRLJ7r3UPEPpZpe46/w9rWHXnwsMhchz8JS9A4bhUyHAZo6nB5V9zI0tsAnP
         HrcfeQYb9VsL0U0QDvcOWe5WIweucyBznJvtI0+G3pSorzUkmKwj/E1i6ShFgFJlafdx
         d8xA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1773107261; x=1773712061;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=OTZMlLJPL1UA9q9adEkklMKU1Oh84O2m52X9NniWPGM=;
        b=CRwNKWZZkWoSgMAg4eGdcJ4P7XDi4Kplxo6AdqG5urpYeW+1uvAemqYkJ9K7CfqzCq
         NDOzyXJgWAQqWRd1QviinxzzvSakSRnz/QBj9ByvC35vrTRrRLmdus7aVDs6wWfOryFo
         wPnDytAcxA+jvszpH4IeIHTk0pEX2fqJWe1tS3why81FVGquh7XLpkevM/RipXCe1CAM
         z0BJljXrWpkQlMrioo0coLzW1hyQHVUwIDWh82IHN3CuuZPiQfJqu8DbO27oKsplgNxU
         sbDb3NZML+J5mhPRnTUa8Yxjp7Z1vGU7VLN8DPEAof4q1qogWMPFNKeET0ERVjR6yhQ+
         RRdw==
X-Gm-Message-State: AOJu0YxHYImjNCSQDD6p3jPdb/W/0vvRwfS4i2jhycQoh+SWCUlkyZCz
	NuwpVZegwAQlItQW/oFOmrLhTL4BK1V+f6wMdTl1rRQgVHSythHqw+vAiuzvaS3BQmaeHcjWJg6
	+BbOV0x98/5r46zK0JKiJcaZ4TsQ6T14=
X-Gm-Gg: ATEYQzymGkgBzWf0OeJ6EfZgSCIo23aiKRaYIPDy6xYPIdh8QDCwjBnCOmRY+cQk0+p
	58zVt9LBnOE/q+PmiKQQNybIBrQ139tSE9HoXF2egEGtoxntmEXvNUJUFSXpIhZuH/zUYG77t5C
	HIOs6TcVRsFQsXb8Iw37/gWlOQIL+BMF/FBi/YBZ7YjTEGuiAN4eaqbkUUPiqr94W2MKFQHmzuz
	nO8mV+/E4tJ8rzuB8+lgwrhtfhoLlzXfljMiX2X5RUcfEZgrx45L+lwpnd9f/u5wcRkQyY7jx9Z
	V4PeDrY58uGAtGZd2xrPyFEgjgtr1JToEK3U96O82c8sg2ML
X-Received: by 2002:a05:690c:670d:b0:794:c2fc:73b1 with SMTP id
 00721157ae682-7990a67e7b6mr17961677b3.2.1773107261315; Mon, 09 Mar 2026
 18:47:41 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260224231429.31361-1-kartikey406@gmail.com>
In-Reply-To: <20260224231429.31361-1-kartikey406@gmail.com>
From: Deepanshu Kartikey <kartikey406@gmail.com>
Date: Tue, 10 Mar 2026 07:17:27 +0530
X-Gm-Features: AaiRm50x8-JEz1vCso63n7zsLVsL7KYXyPiYurmYcoCnboFsMMO5c5aM9_N22Mc
Message-ID: <CADhLXY7wcj5TBfr7u0WOc=8ZLgDn9kAb7YDa8s9AFvv6sXqP3Q@mail.gmail.com>
Subject: Re: [PATCH] ext4: add bounds check in ext4_xattr_ibody_get() to
 prevent out-of-bounds access
To: tytso@mit.edu, adilger.kernel@dilger.ca
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org, 
	syzbot+fb32afec111a7d61b939@syzkaller.appspotmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Feb 25, 2026 at 4:44=E2=80=AFAM Deepanshu Kartikey
<kartikey406@gmail.com> wrote:
>
> When mounting a corrupted ext4 filesystem, the inode's i_extra_isize
> can be set to a value that leaves insufficient space in the inode for
> the inline xattr header and entries. While ext4_iget() validates that
> i_extra_isize fits within the inode size, it does not account for the
> additional sizeof(ext4_xattr_ibody_header) needed by IHDR/IFIRST.
>
> This results in IFIRST(header) pointing at or beyond ITAIL(raw_inode),
> leaving no room for even the 4-byte terminator entry. When
> xattr_find_entry() is subsequently called, IS_LAST_ENTRY() reads 4
> bytes from this out-of-bounds pointer, triggering a use-after-free.
>
> For example, with EXT4_INODE_SIZE=3D256 and i_extra_isize=3D124:
>   - ext4_iget() check: 128 + 124 =3D 252 <=3D 256, passes
>   - IFIRST =3D offset 252 + 4 (xattr header) =3D 256
>   - ITAIL  =3D 256
>   - IS_LAST_ENTRY() reads 4 bytes at offset 256, past the inode buffer
>
> Fix this by validating in ext4_xattr_ibody_get() that there is enough
> space between IFIRST(header) and ITAIL for at least a 4-byte read
> before calling xattr_find_entry(). Return -EFSCORRUPTED if the inline
> xattr region is too small.
>
> Reported-by: syzbot+fb32afec111a7d61b939@syzkaller.appspotmail.com
> Closes: https://syzkaller.appspot.com/bug?extid=3Dfb32afec111a7d61b939
> Tested-by: syzbot+fb32afec111a7d61b939@syzkaller.appspotmail.com
> Signed-off-by: Deepanshu Kartikey <kartikey406@gmail.com>
> ---
>  fs/ext4/xattr.c | 7 +++++++
>  1 file changed, 7 insertions(+)
>
> diff --git a/fs/ext4/xattr.c b/fs/ext4/xattr.c
> index 7bf9ba19a89d..5080ec44228a 100644
> --- a/fs/ext4/xattr.c
> +++ b/fs/ext4/xattr.c
> @@ -652,6 +652,13 @@ ext4_xattr_ibody_get(struct inode *inode, int name_i=
ndex, const char *name,
>         header =3D IHDR(inode, raw_inode);
>         end =3D ITAIL(inode, raw_inode);
>         entry =3D IFIRST(header);
> +
> +       if ((void *)entry + sizeof(__u32) > end) {
> +               EXT4_ERROR_INODE(inode, "inline xattr region overflow");
> +               error =3D -EFSCORRUPTED;
> +               goto cleanup;
> +       }
> +
>         error =3D xattr_find_entry(inode, &entry, end, name_index, name, =
0);
>         if (error)
>                 goto cleanup;
> --
> 2.34.1
>

Hi,

Gentle ping on this patch. It has been about two weeks since I
submitted it.

This fixes a KASAN use-after-free in xattr_find_entry() reported by
syzbot. The issue occurs when a corrupted ext4 filesystem has an
i_extra_isize value that leaves insufficient space for inline xattr
entries. The syzbot test has confirmed the fix.

syzbot report: https://syzkaller.appspot.com/bug?extid=3Dfb32afec111a7d61b9=
39

Please let me know if there are any concerns or if any changes are
needed.

Thanks,
Deepanshu Kartikey
