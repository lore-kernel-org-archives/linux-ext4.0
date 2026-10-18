Received: from mail-yw1-f174.google.com (mail-yw1-f174.google.com [209.85.128.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3A0743CE7B
	for <linux-ext4@vger.kernel.org>; Sun, 18 Oct 2026 10:52:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.128.174
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792320726; cv=pass; b=m2K7zgL02EO+aANatyk+UlN1RA1elJ/mnt4Erw9w6LuVUIK16BGiuFG6ZiqI89FSrFPl6m/yvVW7VOdSWBjRGrgrGBrXPzcCodFtTJJaqIoiSJfX+7eKb5fSJz5Cxww6Zm3cfdiOs/RCGC3PKBnogS6DMysB8lMfIOHU4ItE1as=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792320726; c=relaxed/simple;
	bh=FjAmGFb5Z/FtzEUXBBKcleHQV4GQvHQNOycQ/OdknCo=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=dzm6IRWu7LzbejoIuhNl82wBKAHouSbTIGym9FDkymwn6QHX2RlkcsQAlQEjnUGJEILKQvq78hUOtdi+A49dIMwztPZFF7g+QEQiG80WrPegfqSXPGARFyJlhXrzVL80lu6F4wjqyNgyVVXhSfmKhRbYM6UpVx9BBeVz153hRtA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=hv5LgVKD; arc=pass smtp.client-ip=209.85.128.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="hv5LgVKD"
Received: by mail-yw1-f174.google.com with SMTP id 00721157ae682-8ab395abf79so8707837b3.0
        for <linux-ext4@vger.kernel.org>; Sun, 18 Oct 2026 03:52:03 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1792320723; cv=none;
        d=google.com; s=arc-20260327;
        b=TA9ep0psCvoFH8RyryhO7H+DB7YiLbc+dM4WAbKUGvQthuMM1Sd6qE1GYf07a3Cxfp
         51X9k/9HBNDqwMjfuYsHwjP4BgqwCuZuYPTSwraYnziFoJG3xCg31gBSda/Iv8lHAyZ7
         Z9jsiziJjqqzAbbXXRTqhuJ1Nc2n3sucYpLkjVv1fgBFKMKitp2g5FbJBwVbq74ciTqN
         iy7CEzRp4aQiZ/HxC0z/nGH3iCd+pBxsrougO1ZJsju8dCLADV/lAF7V1/4ld5+qryNP
         GPI1qZlblYOrmxFZaZAIoDSGQV4Pd9mh96F7Hr7MSNNoLPNNx3ytH4ITMi1erUF36yU+
         JOpA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=655HfIRnuBnH15jd00A0aRrEFCWU3hKV5ZzM3Eenf08=;
        fh=+zm/eTcrkxN44Yvks6Zmrn0FxyQt3+BIqgeE3DmcSts=;
        b=a/Nyp33Odo0KNt/TDMLk7oeQn8OwnEjV44F12KVkMfteGWI7J4E4WmLcEli1H5Tha7
         8tmkUgWRUOaXpatPnRLKsy2QnHazuLx2wYLC+fICOOXx2TTF7gI8+5K+sH12emArtIXY
         PVoVkGu38jeQJtVgVqFv/JI4fadoXbjJHcEL9V5EW/jDq+3/zJ9+2rrvc3ZAlcBslVbq
         W6ErFuAZKyX5fx0NIB1mLOtunCntPuJ2tqJG8CsV9qs+Fsq5VklICdxuetbU2tPGHQ8y
         Ro3mED/JDwDeYvHYJZvGKdkimlRcjfnZECGeJ3/vv15NFvhfwlM6phEwx6FnXBscVnjh
         gYIQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792320723; x=1792925523; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=655HfIRnuBnH15jd00A0aRrEFCWU3hKV5ZzM3Eenf08=;
        b=hv5LgVKD3t6lY0+F9pre/EjVcuMoHDvwyxlB9MQLvT/qCYncpLZkcgAwE3ddqVyPvw
         lmIc5vfKWR7KkBfvqLU5dVjazEv6ZSoPnO/9R07Y8PITVICpyTodHp3JMhqHjhpXvkIf
         iHtoyJLxu1FXrf98FMS/htk7Px8NW0zgmCsJiA2Lv/rtXBuNLPJ6/xKRCh0giTn9cH1M
         exVP3K27I7+HXR+c/oClCDK6W/o8SLEe7NxXqQk/I+tyYX+NlLahn+gw2d64sYkOqjV2
         XGCPcUBmuEp90mbzyCgwPDB9zQKdPMx6Os0tGxmbKA/W+AY/LQ0YgXNKAy/Tqrr77gJ4
         /3Fw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792320723; x=1792925523;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=655HfIRnuBnH15jd00A0aRrEFCWU3hKV5ZzM3Eenf08=;
        b=Mb9E6JcJieI5vm3lI3QmHH7mh2AbNNjuTKNQZvL3zXXKeNFTZH4lt4CnrEnHLyzKfi
         pkjtUgWqXznrwo7vQW3+1dLdhKUL/ZIzxMfuzz6HRKEW26KylVU+7o5pFa+TLx+lOTkg
         7IJRrTXES40V2LszKNoiI+NTlS/04oFbRPXhh7OgUa36kugu7IlUOZVKkqHElU53aLqz
         kHkc8t1wFCCvSiJ9Mi/eWqlhSwzEGoVKCtUISTRCGVB6k7kEtPpCgP6GREyXuz6W2aTM
         OiRFeof6Q7Xy0mZJuq6L+29KZmKzXJ6+7LBdORZAUpIFAWvKt/niAffFDsW8n9db4bfW
         n8qQ==
X-Forwarded-Encrypted: i=1; AKwUvByhE+z2LviEV2smimDCZWKzraU2mMOtAWCZphpFmd+SUG02neGsfKlp0zFwG2KBR/5UaEZC+dzD3+na@vger.kernel.org
X-Gm-Message-State: AFq9FYIcKTketxuPwOnYMpL3Q1MVpdlDymBkfDqZMdp4qaT+foi5Vi9T
	tJIKO+p9fsS2or0FaDjBSFk39+lY/whQDSA1XOmfEnttVA5OxLsryDCgxP7tIyTQggBibbYddEG
	hmiArvqGn6vcRZJD6SFTPzTqe8jK8K4E=
X-Gm-Gg: AYBFou1Hl3UgPySFK9u7ZbRR+qJINkSBbMwcqIy/9aDj8EF0me6kpcwPwLEaSufEi5b
	6b5jhf1c5rcA5VFn6TnUsXenin0NyTvwi9f4w0ngbR2W6Yvp4sO86LLaZFimuvJ13bwe8ET9Zy+
	wE6tpzMzn76sMF1MNUfJsjI0EJIQVu0E4s5VstARo8gSwMiD0DncOgZuA50jeBIwUXNNgMHp8Ih
	lmnCeEKoU8IK3D4gB9UXNfdH+j8CFxfs6Ywyt5YaLU8uEQj5MQRxxaJrK8PHWBZaJoBGZUE4F4G
	82mcZ1KoTME95xCEWkPvEp45NOKvVE1jpB8EZXOw/BELDnN9BLhaTrrsRCnOFrtUyNXg+61PV58
	ha/pQlxQsgQYxdiRfwwkaPb3a8t526Kfkl/lsQ9nJ5dnp
X-Received: by 2002:a05:690c:e20d:10b0:8b0:a587:9447 with SMTP id
 00721157ae682-8b0f21c2da3mr12611097b3.38.1792320722695; Sun, 18 Oct 2026
 03:52:02 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260918010558.8210-1-kartikey406@gmail.com>
In-Reply-To: <20260918010558.8210-1-kartikey406@gmail.com>
From: Deepanshu Kartikey <kartikey406@gmail.com>
Date: Sun, 18 Oct 2026 16:21:50 +0530
X-Gm-Features: AclHuK8aVnC8gzsDYmPb8OAIpyj3q95lgZlFST7HT3zcvet7GCGaej0KDEehlUE
Message-ID: <CADhLXY6zY5ntkQwephgK3HZAg=xGMGaiY1kywu_58FuNgkUDrw@mail.gmail.com>
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

Gentle Reminder. Please let me know the status of this patch.
It is already  Reviewed-by: Jan Kara <jack@suse.cz>

Thanks

Deepanshu
