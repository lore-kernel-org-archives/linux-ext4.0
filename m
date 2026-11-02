Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.218.45
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793626092;
	b=gbtwfgpcR8NZCNO+SEt9zrGEfpRSUtxV/uV1AZirEBuFNFPuIO93kdwmfyWfMqaqRueS
	 dilAJ53zN/xnZzb4oZka5EyvDfs4QWWyLN1yy/fIrK0f2oo9318ehDH00MStYOXnPe+UV
	 jilSGBCkN/argiOzo4Hl0WH4IqsrqH7vL9sVT6dToDrTHCPwSwv3NxLSfDhX6zDDPQ1bW
	 08XEmoVY+rxNGjRWkl7l73CEcYrRVuvaUr4V2TtRmINyZ93CMA90k9b+FY+U0IWaydfVw
	 yfrgQcKJoLgAdnAOuUPcpxbvRHvfIZD4UiVaiUZlDgTl+kZntBy86aeUOz3opixOBmg==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793626092;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=qjPej5w11WbikcynHTF6kveEbA3S0oHjvCfUZQriRUU=;
	b=fZBigf35ZmfCWcj2PCyFF3i2jtoeUm17mw6qakmDbpCXXv3oDThemzAakd8LUWS5SVqA
	 VAzlLDrZ4bV8M6i9XXWLRY7OtVrmKCQfPMvyThLEQh6XhtAGB37TNof8YWTGJzbuDuCHX
	 k4jT4ZCnbgn6wh5uxdPVqcTdzo0lx9yVNyvz1HiXs/M83pvy7yo4Q0UFOobmMRbloI7kx
	 7wz/1JeoOEF6uxTzTMbCKoIkhfxBRWMm6vfmKvW5iEZzlLGcZe6/+KXLJTwDpLraX82Bf
	 9ncigbVS+2JW+rcZBqDryRZQnacHgGr+Xq8WMnl6NjNWFOn+FEsazbAFfOIVHWb1LiQ==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=eYS07XxP;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.218.45
Received: from mail-ej1-f45.google.com (mail-ej1-f45.google.com [209.85.218.45])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4FCDC606A326
	for <linux-ext4@vger.kernel.org>; Mon,  2 Nov 2026 13:28:11 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 4FCDC606A326
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=eYS07XxP
Received: by mail-ej1-f45.google.com with SMTP id a640c23a62f3a-c34bff61551so515500066b.2
        for <linux-ext4@vger.kernel.org>; Mon, 02 Nov 2026 05:28:11 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1793626090; cv=none;
        d=google.com; s=arc-20260327;
        b=B8FXJHAacBtmvfhBbuiptWYHtRAJZmVrcCSXMYAKS78IzK6oFo7mDMDD19K+p55rCm
         8zdbl18mDoQbT5kIksYuOdy1+1R3IiIiUoTgpWD74teeEIXWnz6un3mDZtWjtRsY+ycO
         LM2QtrMeqS/s/BX/TwnO/erziBtEDbVoYnU1qmojeSh5xa5XiG7X2hU1QXc7HpThbumr
         MQbeZawHPHwokpIXsbQ3P9Xui2Nu5RjHEN8J5owRDSnw1U1rPibeL8cgMvt4EgLI19Z5
         t/Gu7Q8L37eQ/r0JGrFs0frDDOTioDJ8RMl25EpNlZhCZR+XbcQha6G+9EODBUyWB4fY
         zwaQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=qjPej5w11WbikcynHTF6kveEbA3S0oHjvCfUZQriRUU=;
        fh=oS1UGLUVvPTDbarCpezPwtUYf49/BgsV21qQ6C7K7c0=;
        b=cZTr/XZIKofvidpYb3EH3zRmVcw0SGw3l2XsjsVqOA2J95MCRTUNq4dpWWexQ7qOEq
         2ZLNsXW8DkBdSRUbV/XbZIGIS4hgm70G9ooiiEcHop02STR6QIPo8B4s6xHGuaEmy3yM
         /C30zcfdg6m0AFyl/kDk/9BmrkQNKCqGJUuIgfBpZVGB/3Yeg/uhMnBrkAnbjyGPbrUu
         U5xViS3pXN4ehbwM/N95ik23ZhMpc3p3U8YCyHDEDdUMWx8853XM+crFmTvzl0IUUxp+
         LqYyXhO3h9FePqY9ilyHkfnvoBrtHO3+IzvRMp07kqbAHMFzTWmFqZA3IsT1APnQp+80
         yijg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793626090; x=1794230890; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=qjPej5w11WbikcynHTF6kveEbA3S0oHjvCfUZQriRUU=;
        b=eYS07XxP8utYTK8HWQxrIfweY2AEeSo05MdTGi9bbVESvlC58yszyY6JPLobaWZfxc
         imk/gxvuIXAaaTqV46KdtWmW3Q1ueQHZpbb2oWgLi8gNn6uXtkdbIzybF0KYsU5j+ayW
         aKmXNPi+TN8LKEygHmb6+CngLX/IJwGYm57T1XXuB/0Hwxb0BVyeMHl6mO+yjqoQM26r
         QIGMCxuRZeD0eC9omZ6Wonuh4ev5nNkK8FsviHCI0KaI33iz9G45ISt/6jkeihUvAQhw
         AZzS1P60h62yvfPoc/o74f7YuADHPSqe7dJKIFt5i7QNTmMya1RJRdwQUTAclTJTikIQ
         PtOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793626090; x=1794230890;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=qjPej5w11WbikcynHTF6kveEbA3S0oHjvCfUZQriRUU=;
        b=rs3pG64gsWJbG5z5fW+uJwrr6F6766WXsY/3oUquv1DWSUEUypdTy+v5fu6a1oL2T5
         9F+7OvulQSG9P80flbw4ku6Tzqaf/Kt7cghXvVMJHt0EW1heS/pxKtzCwVhpJsEtCjcw
         ssKSsIjYgVlKCmSYuctUKFdwCk08chtgKnNBJSgswiwNUyuCGXnVUFpi5MeZOwj5ikvR
         akR9itim2W2+mXVT0IULvFKjT4j5CDRbjCk/PpuJlxDgPaSozPx0EeV3Qne82cspO5lR
         fvc+LwF89n6OGA8JRnoC9SAJ3Cj26PvRLvDCrQyMKRvxrdE6+MWgJUu6J2AOcZwPd9iH
         eaGw==
X-Forwarded-Encrypted: i=1; AKwUvBxPPhfHVuEELGCIDuiSW7qngkC1uneTBU1sQdZtu2ofTdjyPaES1eTaBjo31qAlaXDmKvVauvA+SvGN@vger.kernel.org
X-Gm-Message-State: APuU4Z9TLKqHwuRh5nXWbWp6WqVtNv3LAbofuZTq4n2697krWKFsmuEO
	Q28fhDUVm/EtRURBNmqgapVTz8LusXk9/7gZCNSZ3ciCuNwaEXXnkOzGeywJnDAzFnWxogM5CSR
	kLOIXaKAVyhtVYLqe4ctnk4Rcse7+ndU=
X-Gm-Gg: AYBFou0+PKkBWNJfR/yrPIJWKNdckYZPSdDyIs5i4czJ3H055rThjpTxxSGSEb19BQQ
	rRfSx4C0Za59gZygy7VfQt6KaLs+kTt9YMAAoWPyh6AXnlHKCvBzZLTmFFovYAU6u6pusqXUnGt
	Ji2jvrecOOXB8ZuAjbqRjqJ4HsNI7K6pEprlyQVF1Derh4XFfkXe7g3goh/ZfN3bSA8aPz/lVhH
	DqPpLB1NHOqX4lPaTdAyteXO7U6TBv4KJO22NMCwo7bFQZ/IEdzX4CxA2MvI4kbNVcq+E2GW1AX
	lwTtE7P/1FQtVrZvR5GwIIpCEr4GhH96E1n6kZlySx4N6WbYgzN2SCbe3EhXs9o9KVP5PulyNEI
	LUC130jvC99MM8QoQAgNJa5CfR55CjGe730d28Xs=
X-Received: by 2002:a17:907:7212:b0:c2e:3f49:df04 with SMTP id
 a640c23a62f3a-c4ca793bcd1mr794308466b.1.1793626089392; Mon, 02 Nov 2026
 05:28:09 -0800 (PST)
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261021085635.3633692-1-r772577952@gmail.com>
In-Reply-To: <20261021085635.3633692-1-r772577952@gmail.com>
From: Jiaming Zhang <r772577952@gmail.com>
Date: Mon, 2 Nov 2026 21:27:28 +0800
X-Gm-Features: AclHuK8kt_THxReORpsQp5Tyrq7frAGmxk4veLrbcHUVI_TWp6z1LJSbwSMGjP0
Message-ID: <CANypQFYcKGJP7BxP-UAiKUXQ2Uw+H06WJY7kkCxuVQ742QbK_Q@mail.gmail.com>
Subject: Re: [PATCH v2] ext4: clear in-inode xattr space before adding the
 first xattr
To: jack@suse.cz, linux-ext4@vger.kernel.org, tytso@mit.edu, 
	adilger.kernel@dilger.ca
Cc: libaokun@linux.alibaba.com, linux-kernel@vger.kernel.org, 
	ojaswin@linux.ibm.com, ritesh.list@gmail.com, stable@vger.kernel.org, 
	yi.zhang@huawei.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Jiaming Zhang <r772577952@gmail.com> =E4=BA=8E2026=E5=B9=B410=E6=9C=8821=E6=
=97=A5=E5=91=A8=E4=B8=89 16:56=E5=86=99=E9=81=93=EF=BC=9A
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
> When EXT4_STATE_XATTR is not set, zero the first 32 bits of the space in
> ext4_xattr_ibody_set() before calling ext4_xattr_set_entry().  These are
> the bits IS_LAST_ENTRY() reads, so the space is treated as empty and the
> walk stops before reading any stale entry.
>
> Fixes: ac27a0ec112a ("[PATCH] ext4: initial copy of files from ext3")
> Closes: https://lore.kernel.org/lkml/CANypQFZzxTAH=3D4QRRDoqH6VAw1daAq88N=
DWiQKoM7QTOnP40sg@mail.gmail.com/
> Cc: stable@vger.kernel.org
> Assisted-by: Claude Code:claude-opus-5-5
> Signed-off-by: Jiaming Zhang <r772577952@gmail.com>
> ---
> Changes in v2:
> - Zero only the first 32 bits space instead of the whole space.
> - Add a comment above the check.
> - v1: https://lore.kernel.org/lkml/20260916084723.877552-1-r772577952@gma=
il.com/
>
>  fs/ext4/xattr.c | 8 ++++++++
>  1 file changed, 8 insertions(+)
>
> diff --git a/fs/ext4/xattr.c b/fs/ext4/xattr.c
> index 5c310747b965..8e1fd26329d3 100644
> --- a/fs/ext4/xattr.c
> +++ b/fs/ext4/xattr.c
> @@ -2274,6 +2274,14 @@ int ext4_xattr_ibody_set(handle_t *handle, struct =
inode *inode,
>                 if (IS_ERR(ea_inode))
>                         return PTR_ERR(ea_inode);
>         }
> +
> +       /*
> +        * Make sure xattr space is properly initialized so that
> +        * IS_LAST_ENTRY() returns true for its first entry
> +        */
> +       if (!ext4_test_inode_state(inode, EXT4_STATE_XATTR))
> +               *(__u32 *)s->first =3D 0;
> +
>         error =3D ext4_xattr_set_entry(i, s, handle, inode, ea_inode,
>                                      false /* is_block */);
>         if (error) {
> --
> 2.43.0
>

Friendly ping, please tell me if any further change is needed.
