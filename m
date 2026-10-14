Received: from mail-ed1-f53.google.com (mail-ed1-f53.google.com [209.85.208.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97DE253CA9A
	for <linux-ext4@vger.kernel.org>; Wed, 14 Oct 2026 14:09:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.208.53
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791986968; cv=pass; b=Ca/B2PiEt4BtcPTVfcE0fljBSyX9NhbYH/9FAd/OPGq6+cYFKfSnfe5QUI1bqaHO8pOIU/ytw1L1zCfGSQe5Xsn8z1M29dyowso/vZYE3P2d7QyF2PqCHIpH5SEBcbOatU2qblNf5RsprWm1aTAl7t/+00GUuiXtH2beUE9nDeM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791986968; c=relaxed/simple;
	bh=sd73B+0fv4kFWg1/BIpMIx0XVt6pOSOqH8NxgJdLnhs=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=nAlUKz0dfjBaVWaTxcFnovZH65re4uiuDTXFlzdTIuMx6cWqWHcyYFMScjO3Usj7ZjgtIy3SbgKxxge36kNtUemhBdfQWsHiahdEDflBIQAfmVmjWg9bTVEt29M8mzDkA1ZUH69hKDW7qhMGMniu3rl/mlu/itYZ6R7sdHEr+FY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Yv9FP3sb; arc=pass smtp.client-ip=209.85.208.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Yv9FP3sb"
Received: by mail-ed1-f53.google.com with SMTP id 4fb4d7f45d1cf-6b203527bceso1346476a12.0
        for <linux-ext4@vger.kernel.org>; Wed, 14 Oct 2026 07:09:26 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1791986965; cv=none;
        d=google.com; s=arc-20260327;
        b=d/YaYxjgc6m50EY8ot/b4nPd/uGxUHS1pDWBVh9zONcPrp/WOPkD24DgSwrPE/p2aV
         qRgX94w72y09EXCH4FBKsYJikfW39S2uD+BTgA1vYwlqB8proWCs0L09Jbl/9PEJ0vDp
         loyslT21qBd8gbdbDPq2/rCILGyqjyN09u3i/2xD9ioWzCKw5/cpjvzCOFpaD8rY5CNH
         fJKdbCZ0kz4nFUlbMnVCHjR1BUGp+vG9RcJFQRLtXqK1D3sV5T4H7sJfQ5d1vAch1qoz
         lw9UB8PTwZnF5ngL9+tiBW3PM6F81DQHiSZra+rygHCKH+3xUthkJAFaxKHIUwFZOmuT
         1/EA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=3FLZn3X7YL11DIAVkQWpw7vFctgltGOcmiwV6tG+5Ks=;
        fh=WIFEer7PYDSUHHm8y/dspnWdmGhuRWKoUi84z5WBH7s=;
        b=Lc0RJVz/x8oJQ8iHv9Tedj8x16PB6NzOY5qIuVImW7jB6V0jWsje5mVhxgt8spaqwt
         NSWwf2wyZhOQxKzNUGmB0i5Nt4dqbwTs8+g3GR++QfKhPkXSSiz9XE1+kLXA5w+2PX1I
         0BTdkVq3eJx+pTkZBiLLm6waohxyNKM5a27NjruE5mCHaNwO9AsaRbA9W5lkN0SYqbbd
         Ni98oYvRHFgsVud1GeiUmZlfOHZ6UiwT3SruNnVRwhdxbKR6zZEo649BstfFzXwsaOhv
         0AdQXOZCy4+N471c0SNxshfCHnD6gmQIF90NS1sl/HT2OqkkvAGhs6xYvFlYOSPsQTZt
         kMCg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791986965; x=1792591765; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=3FLZn3X7YL11DIAVkQWpw7vFctgltGOcmiwV6tG+5Ks=;
        b=Yv9FP3sbiIObVAd7cQCkT8vTjPQW2euo9H17lTc683i6p/9tjAZHD3S9ayAId6G0zz
         dQYUlx/P+mPWnqR8kIwELDxA4rrlK+DZSm+KaUQTAMniHDkNZnPCR++KRwh7RTt9+Agi
         I9i7NLKsLJS+UmpnuE9zPi0jx6n/+/T5irpT7bVmblmpFszyxhKin/46rGpydo95BcKq
         IcyN18iUvpnSLYyb+pKCR/J6dInJLThCGAfphxMtfBW1C1+VN+CsTQ2MJ2gii8IBuZTe
         80PVez7adrbGox9g4t7B1FfYLvu9DSMHEeD0fm38bCBymSXz53Xvaub2gtunyZidBGOu
         OVQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791986965; x=1792591765;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=3FLZn3X7YL11DIAVkQWpw7vFctgltGOcmiwV6tG+5Ks=;
        b=ggT5uvUckXm4MgM2cWcEc+qXWl080CGCfw935XvQ3GAIIIDAVtPBp8LbH1gQdCPdez
         /B2uH+WrbPRnbbKiYw+KhFGImkrAdikBmGqj1s81c0A2zJRcnrSygzIy1ttCv78vULeW
         YYW+z4+Hw2+NoM/fF4SSNIL0SmGyOwerzRx2nuIpTgsgQxgA9VVXjyasahdQji6wZWl1
         Nrcjpcvc6JSDf3iJdZ2f2cFXAvtAzo0d8/M3X4lulRU6lS9ur4d0PXsLLiYQWhFsNDAf
         XszLMvjEyKtJJRvCLxj+ibUfV/WfwM57tcbOYe5i4FEEIDqottfCuaLXI+DfDprztH94
         /YJg==
X-Gm-Message-State: AFq9FYLMLzjSlFbt2/5GM/DL1ZMOlnuAeC6fJY16stXPNqllo6L/G7fr
	ClNlRZdMgZFrTHlaMYSt/KIeHBYi5wndvoUHtgskXXbLtVMGQhCs9HwyknPAK+IkJWBMSO67GOv
	XA/xuAYc+gDahh2Ks3r/bzAP+r3CYoiiwqeQJyGZ8pWLJ
X-Gm-Gg: AYBFou0ozyychU4BdHPH0zjensV8so+WGFqKBzJBHkd73svcL1VIw8hT0ibB7jsGwDI
	2kJnQDABfaXyZrb6KPZDOOAbiHeeie1ypwZlDogNlXC2gUtQmLUy5/Hi8qSVjzobXaJnyoYgpXE
	7mot5CGj6g1h60qGqGPK0CnuNlXfcTW/oVJKU8m30DdmPeK6WlB245bLAm6AgXGODDSj0BYm4wF
	/TGWL4t9flJbncps8kbzj6LJA6AN4ffRczwttymS6JSKVV6Nc7nRhZ6N8FCod/jwRAjVVigu3xJ
	v3bdMOdkmqBmll/oKsDDqeRpVV37npA+w38aepkEAjsWutaHggsOuZc41SWOSdGWJVoT
X-Received: by 2002:a17:906:dc8c:b0:c29:555e:bf2 with SMTP id
 a640c23a62f3a-c31a9fe3cf5mr1382766766b.41.1791986964194; Wed, 14 Oct 2026
 07:09:24 -0700 (PDT)
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
Date: Wed, 14 Oct 2026 22:08:45 +0800
X-Gm-Features: AclHuK_KOZRXvkZAlVmDLv2Mmd5CCVB7SGq_bvSi3dxWQZgMQy5Ldx3OdNtwlzo
Message-ID: <CANypQFZCx7iAhsMzb1-WRAMwi1T_sk34LkUX8-bDquWrez3_eQ@mail.gmail.com>
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
