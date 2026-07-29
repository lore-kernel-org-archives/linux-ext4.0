Received: from mail-wr1-f47.google.com (mail-wr1-f47.google.com [209.85.221.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CCEC948BD34
	for <linux-ext4@vger.kernel.org>; Wed, 29 Jul 2026 18:57:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.221.47
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785351467; cv=pass; b=c8GYKeQgyFfTHOTiVPndo9a9QsaLnLoR1d+7poj3r0UtsjoK4rfaKM/1nXcHRrRijQpLwUZOZMwyb8MK9GJ6yGh9wOo8XP6XgVvXzyzykuw9UUvdvWQQeCuarfzoD5s/qIbJwNyDQequ1H1vnAZMD4NezjM4GIBRri7JzM9yVIU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785351467; c=relaxed/simple;
	bh=KPTM8WsrM+BqDuldSkxfB5b9uV+pWlsBXXIQBR+/rKI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=hLY9YxlyJVTBzve74YE8dBtxF5K/FLg0QwEiCopDdeFgptY7tEy+UgCsL9t121dDBaznaCj4gRVACRM5ZzFbOLSoLrln8IMFIMzace+ou2iQsDHUUuTpm8C0BC3NhLqnniLOqBxmfxEvtRp146pnHHUBqyvaI8XeHIqAp+XzuSQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=HG0tt/YA; arc=pass smtp.client-ip=209.85.221.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="HG0tt/YA"
Received: by mail-wr1-f47.google.com with SMTP id ffacd0b85a97d-4728c12ba97so894824f8f.0
        for <linux-ext4@vger.kernel.org>; Wed, 29 Jul 2026 11:57:45 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1785351464; cv=none;
        d=google.com; s=arc-20260327;
        b=kOlQPY90cjEBPFdtq+plpbH+cnoSNSAUFogvFi7hTULSJar3dGVPM9qmaM5xgquroi
         Eqp0Q/1MeM2OqhIkDMgPYlxl7b5QdTHeZ/v6ClXG2/vTpIeiMeTxP+IHaKxN1LCKAmct
         H8tqyoZcZrHvGKOgO8bgL8bN2bidrlrpgxs0jWZ9QgNuzyJr6H48xyXVlp+J7R/WAYTf
         JsBKDsB0q948D9f+lX7k1ZZDO4i7FchVIBsYx4/nhEmP4V6J8Xo+9p0prPsH58No3JHk
         dd9JL8gFmbMJsKVzmohQvzPbGkCiuPM9a8ZxcaaTfy4wTWgFD1g5OHS1w2U8fXCMTlJg
         oTqw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=hrYoz+dHSHJ6SiWtUtRhVIViWrdquT77cC2xckRZ/s4=;
        fh=mWffUfqfDGbITeouBcPrqXe29TMDgfgl9pkLrzU0GDY=;
        b=WYIUZyV2wlGn8d4DZP49pUHEilN06SyCmrVPt3AUeVZuGqDJ7pLR7ZZofF4M4dsvjb
         ytBD7G332s7CkdPhUBTUslUAPgrsYHUAPVD2qFSnHkYf46HuaBnNgVoTT9POY5jUp9zm
         UwkHx71pRZyroVAP33LS6aOkMfnwPy/fRny8bAZNRgAo7ujX4F+qvx//ByEb86CAKhKT
         a95deipHuODXZy3g0rz260JimjJo3kL3eI1BNaGDNybr4uzS6krHYVVNbbqS1WTDI/Yd
         PfU9W7cuDWdiCiVOUafv/tnBtnrlOEqMAIiDiPEqsDmdA6jI1xXg/O+TOsvMooTblNZ6
         mscw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785351464; x=1785956264; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=hrYoz+dHSHJ6SiWtUtRhVIViWrdquT77cC2xckRZ/s4=;
        b=HG0tt/YA/SSLfwLylBcNQhEwFyWO1drr3eRQ2k8B23pLjX/HI/2cb2evXopALFvuuk
         MAFC6cRYVjBdqMBoSW2+zuwN84/HqCRN3O40w/7tZWCeNwv0TUt3vAD+BiGVToHDx+g0
         1/1vFeXQ2C3WQFDDua64DpArALa8XLd6ttONE70FinI5kKaDBY6Hdwmtp92A6XKzD4CQ
         S+/6R412oyLDPlk13gILEfPil8d/9Ca6o0sb2L0ETV1/MSAC8sLudxzOpLpVP4Ys8gVS
         sUjqUqBnjydvSZW21v4EyZOx+/hTh3+245DMaYmGIIEveluYyb1EcsfN6VIQ6/qQOOHD
         Qreg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785351464; x=1785956264;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=hrYoz+dHSHJ6SiWtUtRhVIViWrdquT77cC2xckRZ/s4=;
        b=CYMbxqmk4JcnlKPF48c3M/K3ZeABGUL3CbMsCG8PQZB2TLQ/fyRhKLpuPpkmAHXaCX
         2eL8cHeauNUmLkyaBlDVGBGXHGMC1S9wh94h6TSmmSMp/LY3mG70nCIfJly6wOoDYo2B
         Fk0kTZyvxVeFsbI4ZOtai8xULaK8WQfEpesrx9ZHfzTQDliO0XmZUihZNC8CKqCEI9ps
         CmaCwxslqgiMLpFMg+qDMFFhKMbi0H8AxVyu5AquJl4oBB+h2GQGpsh0Zspi+ITqd/q1
         9bnn9IriozbRAh/lVt+9B1cwzYSpxurEMuENWSjzrZw8DTySL0X/ova9iYC7sQFTJTUW
         YHIQ==
X-Forwarded-Encrypted: i=1; AHgh+RoQLLjiOwkkI94SFs8F6l9B/0WDeXx51xWM3VNlepFTSBRJzWddDxtidkR8AsutH+pZKvpy+lciBkVO@vger.kernel.org
X-Gm-Message-State: AOJu0YwF/La+YIEKz9/9AMoX8FUmB+XCwcp+Ne2eMl8RBw/4XNTK1wwL
	8iQ5KXxIOLO1hkMx6oXKHmz2rVXLhjTUMJhQtQIO1VTRHigN/dshFVPCXUxc+pCifUiWIab4nJy
	+dAmxCcDGTR6EjTNVxEXLRDztAi2TJAM=
X-Gm-Gg: AR+sD134MPFRPfEsQbkXPEgC7VJQjDz14EhpfyVSL93LvH0CleWIiapIeUdF821TOOy
	BgA0bfaLYnUX3ZJ1CJgwrKL4hHQoJKujcyCfNoNBnC78wf3ih7v2JAgYOmPEt3fBjU003SknXKO
	kp1ap9W+udqwwNqKpSivx76FpZfbJych1EjPffQdwSi1Z1kk8VuTJ4kS7toGLtcPjK+jmXzymm1
	RDCf13ZYt65G6OJRAYqxLEzttosg0joDFiZd/HIc366eH0SD8M0vLVRIqAjyS6xpGRvAA86Y/61
	u60gdEkjYOGxINrdsFRjty3e8vt8pDVzVnIUsEH19j9Fjm6UxI6k9efFu3h3K/l2Yaf1izvDrPE
	+c+t2T/+KtpTvDzEgJxr+Srps
X-Received: by 2002:a05:6000:288a:b0:47f:8e78:4d0c with SMTP id
 ffacd0b85a97d-47fc66738eamr85810f8f.48.1785351463693; Wed, 29 Jul 2026
 11:57:43 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260727211758.1116539-1-joannelkoong@gmail.com>
 <20260727211758.1116539-21-joannelkoong@gmail.com> <20260727223345.GI2901224@frogsfrogsfrogs>
In-Reply-To: <20260727223345.GI2901224@frogsfrogsfrogs>
From: Joanne Koong <joannelkoong@gmail.com>
Date: Wed, 29 Jul 2026 11:57:32 -0700
X-Gm-Features: AUfX_mw2AKZ6T_CPZERPb2AZJh9r8QLmI1mksg1KCuOzXLA3WT8egaBLm2tNcG4
Message-ID: <CAJnrk1Z7Z3F3_Gee0Ej0n_0-2LPxJq=4rxmw=xg+e2ryoa6MNQ@mail.gmail.com>
Subject: Re: [PATCH v4 20/21] iomap: pass iomap_iter_next_fn directly instead
 of struct iomap_ops
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christian Brauner <brauner@kernel.org>, hch@lst.de, linux-fsdevel@vger.kernel.org, 
	changfengnan@bytedance.com, kbusch@kernel.org, 
	Matthew Wilcox <willy@infradead.org>, Jan Kara <jack@suse.cz>, Jonathan Corbet <corbet@lwn.net>, 
	David Sterba <dsterba@suse.com>, Gao Xiang <xiang@kernel.org>, Namjae Jeon <linkinjeon@kernel.org>, 
	tytso@mit.edu, Jaegeuk Kim <jaegeuk@kernel.org>, Miklos Szeredi <miklos@szeredi.hu>, 
	Andreas Gruenbacher <agruenba@redhat.com>, Mikulas Patocka <mikulas@artax.karlin.mff.cuni.cz>, 
	Hyunchul Lee <hyc.lee@gmail.com>, 
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>, Carlos Maiolino <cem@kernel.org>, 
	Damien Le Moal <dlemoal@kernel.org>, libaokun@linux.alibaba.com, linux-ext4@vger.kernel.org, 
	linux-xfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Jul 27, 2026 at 3:33=E2=80=AFPM Darrick J. Wong <djwong@kernel.org>=
 wrote:
>
> > diff --git a/fs/xfs/xfs_iomap.h b/fs/xfs/xfs_iomap.h
> > index cffcec532ea6..d2d3c84d93f9 100644
> > --- a/fs/xfs/xfs_iomap.h
> > +++ b/fs/xfs/xfs_iomap.h
> > @@ -53,14 +53,22 @@ int xfs_read_iomap_begin(struct inode *inode, loff_=
t offset,
> >               loff_t length, unsigned flags, struct iomap *iomap,
> >               struct iomap *srcmap);
> >
> > -extern const struct iomap_ops xfs_buffered_write_iomap_ops;
> > -extern const struct iomap_ops xfs_direct_write_iomap_ops;
> > -extern const struct iomap_ops xfs_zoned_direct_write_iomap_ops;
> > -extern const struct iomap_ops xfs_read_iomap_ops;
> > -extern const struct iomap_ops xfs_seek_iomap_ops;
> > -extern const struct iomap_ops xfs_xattr_iomap_ops;
> > -extern const struct iomap_ops xfs_dax_write_iomap_ops;
> > -extern const struct iomap_ops xfs_atomic_write_cow_iomap_ops;
> > +int xfs_buffered_write_iomap_next(const struct iomap_iter *iter,
> > +             struct iomap *iomap, struct iomap *srcmap);
>
> I wonder, would it make more sense to have a macro to define the forward
> declaration?  e.g.
>
> #define DECLARE_IOMAP_NEXT(name) \
>         int name(...)
>
> DECLARE_IOMAP_NEXT(xfs_buffered_write_iomap_next);
>
> Hm?
>
> Though feel free to say "declaration macros suck!" because they do.
> Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
>

I think this makes sense given that the definitions are generated with
macros. I'll include this change in v5.

Thanks,
Joanne
