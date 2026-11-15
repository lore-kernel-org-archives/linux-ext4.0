Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=74.125.224.52
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794750128;
	b=KrkXcbp7nolEsTGmJay5b/YD4ZfOHyjvZcnUqcTFRee3GSiO9oEUfTBhTyVzrHee5iMW
	 xbJN0RlQUTsf+orqRexT4LEqzTlV960ktW4w8pKI5k6hq4GggiNh7YwTHUCrdYAh56GMz
	 h8NfcY90LspijkRE1XsSLrX/iwS9aK+pax7ECJ4nAo73FNE+wQAIbd33TP3jspwwH/yFK
	 xceLVDcAVQ9cpFL8OdzGQUYTJo4f6Ndtj7XZwfDeZs/lW6ITUkGMESPhp0E6ZV7DKKCVH
	 /DN/v53POuJ3H/MmggvWpZexq+CLIQfYeADlNtcFfwPwnu5v09vyjPhfKPJ5e9OJp6w==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794750128;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=kXgOszMYn9vK+uSp/j0C+iMdzMuEkTmBUqbfaKTOQBo=;
	b=roQqO1E5VuocYA+wi5Go90eSZSWVA/5LqSUHYWQUYOoGyuxCsbIDsJIQbE++f3VnreO4
	 oustDbseUd2nv/DIYNY8p0rzHamihUJPsqEjEaTRQcCHj92gEX+rpXqqYrsUIMV2aUgBi
	 7QA3mlkjp3bJkzUrOIRSxhwuP4Ey+ehfFIQtEV/TOAWFmmQurjKD5FDS3xrmxUFiXQPYU
	 sad4TzP0Z7oxGABfRzsLCLX0Hsi0J6BewwoPeQE1c9nl8QJ5+BNb2TcNu+u6TJP+BbtSN
	 WNijI74Icmu4+Ri61zhgnuYlD8TUW04d+dIK9DbIz6O01drsbbVe4PMPt1Y4roPSKBA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=I7mssDJ3;
	arc=pass header.oldest-pass=0 smtp.remote-ip=74.125.224.52
Received: from mail-yx1-f52.google.com (mail-yx1-f52.google.com [74.125.224.52])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DDA5606A31A
	for <linux-ext4@vger.kernel.org>; Sun, 15 Nov 2026 13:42:08 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 5DDA5606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=I7mssDJ3
Received: by mail-yx1-f52.google.com with SMTP id 956f58d0204a3-67da3d03263so567947d50.1
        for <linux-ext4@vger.kernel.org>; Sun, 15 Nov 2026 05:42:08 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1794750127; cv=none;
        d=google.com; s=arc-20260327;
        b=N2htAdmJWsqwE/POfj+zjTaqtU6BviuZVdqFp2xeCwsPBrb/mlFB/tqHde49HiJg3K
         lkd69dxacSs4rGGU/o/kGIHwDh89M/QW+KNhfxzfxrKfcw31l4thX1YPgBR3Ww6Ruwdr
         Tn3FQEwRqx3PwZpTowFV0PQb5T72uwCOkoPGuwCfuamGeRj0ECXPCt5M28IH792Fn2tS
         rScotd1KMhYEGxOHOK1z82xDCWfJjZNJwqEwaAmqRipqqDoXEZUaB1onarIYI4c+joSF
         IOLQ4kGt9oX3aR7AVwmeawlKodaaML9fPWHdb7kRxGFuF/qhtefG3TPolFfIoMFwfq6l
         6qcQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=kXgOszMYn9vK+uSp/j0C+iMdzMuEkTmBUqbfaKTOQBo=;
        fh=El+PFXfeGg+T7sv5gbvtJvZ5UZQ0Tvd9eFaQM4//dPw=;
        b=PSIW2UkVeMZbgkVU3Umhyz19coaAVbeYQRXvHRVJ1GQIacD/13kaKDb0iwXZ/RoTkv
         UPN16yyNEL4wPLb3/g0DPpmYjj17727zLD96gsji/akhBB/Pm0RYKudVkrf58YWIqKwI
         CrK2CYH0CG5JKgq3BQ0bNIGThZOvbyGNAn9edwksn1DhTgKwMFIcC/R1CNAx8i4uHGJn
         r+9olzG7kga6vJWoAizXh1PFn1IUvVKOlbfb5/5MD1ZM3cRktoy2OGW2KOeo2O1hHvsL
         gVF36U0TrWEyoXLdBiCZfhleLWOQOysb5EIr92dWMOgzjHprBxRoX96vfbdy7EKDpp68
         7Frg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794750127; x=1795354927; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=kXgOszMYn9vK+uSp/j0C+iMdzMuEkTmBUqbfaKTOQBo=;
        b=I7mssDJ3NnJGjrjiAlTuGzlQOls7EGpkW/QorZHSD5CdoTPbEedp6w51bSWrnKLllT
         zrkwNYSmYr5TnEHen44G5z20e+6YiR5FR8p/rgYN8WjLtHdY7poQc9lkdS+2ZQWJiX3R
         8JP4zbC+UcSUWur4TKseb7YKCGbibOSXMRskOqmWyAb6mq+8j8XJAvqX0P1PFiVDkQwI
         BzeurOPpDogKjZoUGWKZdSQ8IoyfRJuRefVkO1UlgTja7o38EcqZNXZYSMXe5fK+7D/+
         47evuOMCrS4qiyo6o0328o7ktYU9Iaz9715kqeG5wuZ0F3jT+8UlKS/ivps0AKiaxxOz
         /t3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794750127; x=1795354927;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=kXgOszMYn9vK+uSp/j0C+iMdzMuEkTmBUqbfaKTOQBo=;
        b=H1Fmf6prYRN2Zws6+JHrK9fl/HI9Jpm3yiNVHI3tJSbdWxrvTHn38GGzepocw4pGe2
         k7NquKoOBRe8CQM/kP2g0QAr6V43qNLSAHgdRdxDawdOPeFuMcr39nT9JHlErLpHoPrv
         tjnbD2AGkSQeJ7oQxWXtZe7oHKcDetllqADCsvFlh3KBncqlm8iN7lC/efon7tstJnzB
         0FM3uyw6lqb3XmkO56BFsbzBpdQmBQAzVbpaZedIzywZv+aEfxWWGmAxheh1UyMZ2BN+
         n4Ou2mdjFTxt93vDxratolIBG8guNw+iVkvjP9RW6odWTGQ1GKcfQ3CPNObkvNDSUNrq
         f7pA==
X-Forwarded-Encrypted: i=1; AL+hErEl6rYh8W3XV47J9UtTU5Wj3ooKG8yzbzXWBoeO9gb+5jKVarULn3uRIwm0m2v+V43ALu4pxsmymGLu@vger.kernel.org
X-Gm-Message-State: APuU4Z8sSuFVzEYPzlQ1z+Jp9WBH0MHHC1TQYtCVmgkvH7iimZf/bAw6
	J0S4EiXsf0lHJs+bjk8DxvUhSeJJOdsNeTFYpegnFTMyvvgj8qp7zeumqDGx/9ldaewU5TZgZkV
	TCaqkRT+HL7lbs9evvLAe/2nG2nNFc7s=
X-Gm-Gg: AYBFou2ZpyAjcRylu3fzjprTUrNJHSce78b1H6nWS97pKDIeY+coEAEpTgm3u+UluP/
	fLIBZTfaCCS72iJfVnbgALGDX9zd4saE/SBI8yayTZOV/oSytHQCXomiAGLHdpPDp5g2NOnx47J
	C1hLZcNiNv4+zvf1mfozRXZ00UVb//9M2/Nt724vU8JhoxiYrscVx34a3z1e80hCcgLc24lI/Hw
	Ar/A9it1fxvBYzg7Ivg+UPrWrnhTkysngYXOhg37mumHYOVDMmvma2fPw53sF41m1DFPMy3YdYB
	bWwMcxyWC5vt+UU2nef5XnbE4qAS2fGhHVkhw7S3mlv8Lyqk8hao47WJ2xZEIE05cQRp4KlWHXz
	+m1/fsEUrD+6FgvER/6jQ4aBC2RIvflY6V+c4JtkViTcIpkKvRuFQ4w8iLIM2pGv/LeNXU3foRQ
	Gaar/jtIE9RvZCfqHRqJAlK9FcRG8kbK2398x1tFmjqj1WZGzi1jYuASpa12r2EZMk8fh78FUqA
	RlPHaUeT39A6FNjDt9kfyGsmZZnJ3TM
X-Received: by 2002:a05:690e:191d:b0:678:1568:ff75 with SMTP id
 956f58d0204a3-67d89636822mr3858621d50.38.1794750127402; Sun, 15 Nov 2026
 05:42:07 -0800 (PST)
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20260918010558.8210-1-kartikey406@gmail.com>
In-Reply-To: <20260918010558.8210-1-kartikey406@gmail.com>
From: Deepanshu Kartikey <kartikey406@gmail.com>
Date: Sun, 15 Nov 2026 19:11:55 +0530
X-Gm-Features: AclHuK8jBWUIo96es8EY9xf4B-cOCsZlKh1m9ctTav1JYjSyzaFWf7NxJLRiF6o
Message-ID: <CADhLXY5Z4JVPWfYeKVL_nOOW55hdb-9ZurdBR7TJadhdZh0+Ag@mail.gmail.com>
Subject: Re: [PATCH] ext4: add bounds check for e_value_offs in ext4_read_inline_data
To: tytso@mit.edu, adilger.kernel@dilger.ca, libaokun@linux.alibaba.com, 
	jack@suse.cz, ojaswin@linux.ibm.com, ritesh.list@gmail.com, 
	yi.zhang@huawei.com
Cc: boyu.mt@taobao.com, linux-ext4@vger.kernel.org, 
	linux-kernel@vger.kernel.org, 
	syzbot+085a394c92518a04fd09@syzkaller.appspotmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Sep 18, 2026 at 6:36=E2=80=AFAM Deepanshu Kartikey
<kartikey406@gmail.com> wrote:
>
> ext4_read_inline_data() reads the location of an inline data xattr
> value directly from entry->e_value_offs without validating it against
> the actual bounds of the inode's xattr area. A corrupted filesystem
> image can set e_value_offs to an out-of-range value, causing the
> subsequent memcpy() to read from an address far outside the inode
> buffer, including memory that has already been freed and reused for
> something else. This mirrors the check already performed in
> ext4_xattr_ibody_get(), which is missing here.
>
> Add a bounds check on the computed source pointer against the end of
> the inode's xattr area before the memcpy, and reject the read with
> -EFSCORRUPTED if it would go out of bounds.
>
> Fixes: 67cf5b09a46f ("ext4: add the basic function for inline data suppor=
t")
> Reported-by: syzbot+085a394c92518a04fd09@syzkaller.appspotmail.com
> Closes: https://syzkaller.appspot.com/bug?extid=3D085a394c92518a04fd09
> Tested-by: syzbot+085a394c92518a04fd09@syzkaller.appspotmail.com
> Signed-off-by: Deepanshu Kartikey <kartikey406@gmail.com>
> ---
>  fs/ext4/inline.c | 14 ++++++++++++--
>  1 file changed, 12 insertions(+), 2 deletions(-)
>
> diff --git a/fs/ext4/inline.c b/fs/ext4/inline.c
> index ceee69a66482..2e60ab3e0db5 100644
> --- a/fs/ext4/inline.c
> +++ b/fs/ext4/inline.c
> @@ -187,6 +187,8 @@ static int ext4_read_inline_data(struct inode *inode,=
 void *buffer,
>         struct ext4_xattr_ibody_header *header;
>         int cp_len =3D 0;
>         struct ext4_inode *raw_inode;
> +       void *end, *p;
> +       u16 offset;
>
>         if (!len)
>                 return 0;
> @@ -205,13 +207,21 @@ static int ext4_read_inline_data(struct inode *inod=
e, void *buffer,
>                 goto out;
>
>         header =3D IHDR(inode, raw_inode);
> +       end =3D ITAIL(inode, raw_inode);
>         entry =3D (struct ext4_xattr_entry *)((void *)raw_inode +
>                                             EXT4_I(inode)->i_inline_off);
>         len =3D min_t(unsigned int, len,
>                     (unsigned int)le32_to_cpu(entry->e_value_size));
>
> -       memcpy(buffer,
> -              (void *)IFIRST(header) + le16_to_cpu(entry->e_value_offs),=
 len);
> +       offset =3D le16_to_cpu(entry->e_value_offs);
> +       p =3D (void *)IFIRST(header) + offset;
> +
> +       if (unlikely(p + len > end)) {
> +               EXT4_ERROR_INODE(inode, "corrupt inline xattr entry");
> +               return -EFSCORRUPTED;
> +       }
> +
> +       memcpy(buffer, p, len);
>         cp_len +=3D len;
>
>  out:
> --
> 2.43.0
>

Its been while I am following on this patch. Please let me know the
status of this patch.

It is already reviewed by Jan Kara <jack@suse.cz>
