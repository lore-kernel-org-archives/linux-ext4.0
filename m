Received: from mail-ej2-f36.google.com (mail-ej2-f36.google.com [74.125.228.164])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D57FA47606D
	for <linux-ext4@vger.kernel.org>; Wed, 23 Sep 2026 08:53:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.228.164
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790153604; cv=pass; b=dupM2jPZBRQyB+IsO0FYQf7c9Wsok61pLruNS70jkKkY4wllK/ta5uD0GhsnpTXINi+eegReOntbxxZ1ozN9DHhoZmWStxraugByq8+xJmnO9sA/vt7q+kKGCW6hLpV0EGDc0W9dTeQ7zu18Kw426MWlDkDO0UQeOcDB2VD7cbo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790153604; c=relaxed/simple;
	bh=sd73B+0fv4kFWg1/BIpMIx0XVt6pOSOqH8NxgJdLnhs=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Hru6YYq2FzSmrDrJvKeWsCeojii/TxQd+BvGzRuhVABUzp1b9T5nJRnZ1HNolYJ67AeM0MEcrH8NgZ4w8gYC2tf4THc4CYcSNBU4iknIWk1JvkfKDn9OPfeiouUS8qfEbRgOnjq/7S49pZfhFoxDZiTYe8g4m3+YeqnVXy9d5e8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=MesPcnv+; arc=pass smtp.client-ip=74.125.228.164
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="MesPcnv+"
Received: by mail-ej2-f36.google.com with SMTP id a640c23a62f3a-c254f9f0b1eso99273666b.1
        for <linux-ext4@vger.kernel.org>; Wed, 23 Sep 2026 01:53:15 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1790153592; cv=none;
        d=google.com; s=arc-20260327;
        b=nDOxFsPfdnoTdBnofOzDbR6NyfNAuxQSBvrMBdVAQYQ+LTEL9xIjuOWvew4KhQmf6A
         Ec2i7039a+qz3iIEmbpR5kX5XyJrFSRGdacBHbbBV8dGJzcSeLZ93VTKV2x+EqN0DEQQ
         4AJCgbff3V1H28UqKd2ooIuIk+dRVShjMQ/uyiDJf6VSEhhgNS11jCk42oqBZfJ7yOZn
         nDooY6hpaJZ0IyPuIlzm020uk3DSVRv1ZkAZIx3EdJbdfRI2WqmlPjeKQJFzJWl4vMlA
         /dd30UQ/mw5Le2BCHqQfMzl/WyzIw+c7RoYd783fY66/3PxvjguzBV8MQ3pbwG1llLm6
         17Zg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=3FLZn3X7YL11DIAVkQWpw7vFctgltGOcmiwV6tG+5Ks=;
        fh=WIFEer7PYDSUHHm8y/dspnWdmGhuRWKoUi84z5WBH7s=;
        b=SUVGEAbfv2aLOWXgNjKH+MASHGdSyG2x64ssP++ZA1JIlr17V5sFPu3RqNQROFeV6W
         ZlytEQxqFEtrxwmm1B0p1mHnF0iLZc8p4g4g/l9ch7UTQX6zQ1QgkFKlTW6Xi7HRTs95
         agaGOTaWLdlCba5DWCgf0g52807/aDfVCO41TJ+C/K84pe+lR9Pc7zfMrRxgtYU4hCBA
         Qyg705DuT2VkS0+NrhyyWjaEDBFS3loMt9ksMr4wcVVxMrIJVM9GxGC2jDPwKj52XaHn
         T2LywfigE5ibwjdSzNPtY2ipFr/hZLpyRIIhxGSDJea4Fe/7J70eZHIUOCIq2ONYSfWR
         MN1Q==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790153592; x=1790758392; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=3FLZn3X7YL11DIAVkQWpw7vFctgltGOcmiwV6tG+5Ks=;
        b=MesPcnv+Gj0HST6wUepYrtVQ5V4Hcj+RKx783JSHfmhvNmhigGefBfytwDZ4SSH4pl
         neb9bZcSGdYsWqrIOuOmI/9+U153HF6RXp/QJEKPtK8uM3x/fL43PRx+5cRrqgju5fjA
         cMJY7Vy9YdqldLljYwKj1EecmIZL0XLRiMsoL+wj+VYPM4PI51nOOu8ERG9YOs6qBvwq
         myuaC0myKfaBPQm9iLkYjY9XrKAJGSu4Z2q1AOpjLNTswm39CaXZ4/tcScubYNYLq7/D
         fsMGw0eK8kBXxF3FcA69rs6NN3IhAbdKpQxe1wDoTrY5EUi4Vy2iR4nPA1fwIKTDoLXQ
         RE7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790153592; x=1790758392;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=3FLZn3X7YL11DIAVkQWpw7vFctgltGOcmiwV6tG+5Ks=;
        b=v5wlEqG6hTxH9T9n1F8x3XjYClzpKnSXFFN87yK2IrmWEaD1LZ+pgKwI6Mi4coThvI
         5Id+gOxPJMJxzVxR0BVUMZzBwR3TsY6w54dFPpxuIy+P4Kl2HpkqEBjtYpQcHndp+YkV
         5ccaQN/WFNhPzWTxnv4Gv5Xst5DpJVvRjpL85RaKEbcZ5W/oi1lBuELdAhjlGqSRh1QK
         drv0FQ/gwc4z5HnYjD+C71BNsJjnzCogwV5rQ780sLU1f7GntYYALketJV+En+f+rw3e
         oQLoBdP0QNSws7TrboIpqwNeUPa9+K4dz4HNBL/uGkAuPzvQAUA2xycnn9CT0jS02Js1
         oFeA==
X-Gm-Message-State: AFuF++mLxDnrau29CsSYIRNZ4GNcPE4jIenKfuvbm8VfGcOmaFa+i2C4
	hLRVqyUQIv70gEAXmxoC+7G4RmB3BB0FM3R4W5lc9mlJBjCYpueQjq2hYOgmmIvgxJYDz2rhZPe
	tAE7bSQhAy35AquxlRGqbOUVeGAF12DFXl+nnOVk=
X-Gm-Gg: AYBFou0vECBeNvZzAxGfqNBHsDCqKxTCyLxBpzJtcyLHR5/nydxUUT3Nb+ZyAHZebjI
	1+9/N5+cSV9CFyHeb4mZYWtnEcqwuLkYy6gy6OBwNP1IlXtxCGPrKKaDUJ2qmgsbOazRdQr3Tc6
	5Awwck7LAw0s4i6ZGwpwIeDfTHkBdGZXOyobd/JHPFj9eO7xJ0kHjOAr9+tlpbhR69nGpipWh74
	9IQNnGy5iKASTLSyBBNtZmb2J90oJBLb/Lnj3J02PMZqd5dNhOajxI0hykiuQWO8iNEBFeYxVz2
	xSJ3tg14ntanM5XS+IvTuFFaY81IUZPYw+QFeVCRw1zLpvg4mWMXmsu+4gXehnOpPqjg
X-Received: by 2002:a17:907:972a:b0:c29:f5d8:9c7b with SMTP id
 a640c23a62f3a-c2aadcc89c2mr161328266b.42.1790153591027; Wed, 23 Sep 2026
 01:53:11 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CANypQFZzxTAH=4QRRDoqH6VAw1daAq88NDWiQKoM7QTOnP40sg@mail.gmail.com>
 <20260916084723.877552-1-r772577952@gmail.com>
In-Reply-To: <20260916084723.877552-1-r772577952@gmail.com>
From: Jiaming Zhang <r772577952@gmail.com>
Date: Wed, 23 Sep 2026 16:52:32 +0800
X-Gm-Features: AcwNN1UMfSu8IzUIQZOKw71fWeU3uvzM62Ysf-NXrGIr3kl704yBCqU3vyMQB5A
Message-ID: <CANypQFaFf4mGrr_pLRyPgKCTDX-0vCd0nnwHenwn1xxQSa5X0w@mail.gmail.com>
Subject: Re: [PATCH] ext4: clear in-inode xattr space before adding the first xattr
To: linux-ext4@vger.kernel.org, tytso@mit.edu
Cc: adilger.kernel@dilger.ca, jack@suse.cz, libaokun@linux.alibaba.com, 
	linux-kernel@vger.kernel.org, ojaswin@linux.ibm.com, ritesh.list@gmail.com, 
	syzkaller@googlegroups.com, yi.zhang@huawei.com, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Jiaming Zhang <r772577952@gmail.com> =E4=BA=8E2026=E5=B9=B49=E6=9C=8816=E6=
=97=A5=E5=91=A8=E4=B8=89 16:47=E5=86=99=E9=81=93=EF=BC=9A
>
> An inode can hold extended attributes in the space that follows its extra
> fields, whose size is given by i_extra_isize.  When ext4 loads an inode,
> ext4_iget_extra_inode() validates that space only if it starts with the
> xattr magic, and only then sets EXT4_STATE_XATTR.  Without the magic, the
> space is treated as empty and is not checked.
>
> ext4_xattr_ibody_set() passes the space to ext4_xattr_set_entry() whether
> or not EXT4_STATE_XATTR is set.  ext4_xattr_set_entry() walks the entries
> there to find min_offs, the lowest value offset.  That offset decides
> whether the new value fits and where the value is copied:
>
>         free =3D min_offs - ((void *)last - s->base) - sizeof(__u32);
>         ...
>         void *val =3D s->base + min_offs - new_size;
>
> A crafted image can leave non-zero bytes in that space without the magic
> where ext4 looks for it, for example by shrinking i_extra_isize.  Those
> bytes are parsed as entries, and an entry that claims an in-inode value a=
t
> offset 0 sets min_offs to 0.  Because free is a size_t, the subtraction
> then wraps around to a huge value, and the free space check passes althou=
gh
> the value does not fit.  The value is copied new_size bytes before the
> start of the space, over the inode's own fields and, for a large value, t=
he
> memory in front of the inode.
>
> On a kernel without KASAN, the copy corrupts memory: it overwrites the
> inode's own fields and, for a large value, also the memory in front of th=
e
> inode.  The bytes and their length are decided by the setxattr() caller.
> Nothing is freed and reused here, so the use-after-free in the report onl=
y
> reflects where the write happened to land.
>
> Triggering this issue requires mounting a crafted image, which needs
> CAP_SYS_ADMIN or automounting of removable media; after that, any
> setxattr() on the file reaches this path.  The issue was found by fuzzing
> and has not been seen in production; a reproducer is available in the
> linked report.
>
> Clear the space in ext4_xattr_ibody_set() before calling
> ext4_xattr_set_entry() when EXT4_STATE_XATTR is not set, so that the walk
> starts from the empty entry list.
>
> Fixes: ac27a0ec112a ("[PATCH] ext4: initial copy of files from ext3")
> Closes: https://lore.kernel.org/lkml/CANypQFZzxTAH=3D4QRRDoqH6VAw1daAq88N=
DWiQKoM7QTOnP40sg@mail.gmail.com/
> Cc: stable@vger.kernel.org
> Assisted-by: Claude Code:claude-opus-5
> Signed-off-by: Jiaming Zhang <r772577952@gmail.com>
> ---
>  fs/ext4/xattr.c | 4 ++++
>  1 file changed, 4 insertions(+)
>
> diff --git a/fs/ext4/xattr.c b/fs/ext4/xattr.c
> index 5c310747b965..2e5f39b710bd 100644
> --- a/fs/ext4/xattr.c
> +++ b/fs/ext4/xattr.c
> @@ -2274,6 +2274,10 @@ int ext4_xattr_ibody_set(handle_t *handle, struct =
inode *inode,
>                 if (IS_ERR(ea_inode))
>                         return PTR_ERR(ea_inode);
>         }
> +
> +       if (!ext4_test_inode_state(inode, EXT4_STATE_XATTR))
> +               memset(s->first, 0, s->end - (void *)s->first);
> +
>         error =3D ext4_xattr_set_entry(i, s, handle, inode, ea_inode,
>                                      false /* is_block */);
>         if (error) {
> --
> 2.43.0
>

Friendly ping, please tell me if any further change is needed.
