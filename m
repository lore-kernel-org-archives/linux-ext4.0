Received: from mail-ed1-f44.google.com (mail-ed1-f44.google.com [209.85.208.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 472D63C3F58
	for <linux-ext4@vger.kernel.org>; Wed,  5 Aug 2026 19:02:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.208.44
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785956551; cv=pass; b=sJPbU3QL2BXXPDVXdqGtuLAgkJFF4Th3OBcZJcjzicW1RlQXYG05c2k+jqMHzk9MpsUnYWDuJfjHZOyn8AVlKEv8ZsEcq3S3y5WHUjPQIQ3q1Hh9sdkZHeBYAedzobnCaCVMrEg5e1lg90pZ9WlMuSg3+Nsi0FOgwypTSMDbQXI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785956551; c=relaxed/simple;
	bh=ALS4z1Gntn76BUGW7fczi1PamcwbMhAJ+HBZQNl5qW0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=JDGE19Dqthsd1beqtYEo2nB3ede2nZ5KOZbABJBXOR1HJhyQHFVx/jXO1JLSwHDfpkmlYnReSkEFAOW3vMfTi/EjTzFnK7fO2VdcTXM0w/VcaEdTx7BqQO+7nLwj0kaVs4+9+atSwTJN/APBTY4GleK4r0/oxfWNdalCTQx8YhQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=cgZzS1Hr; arc=pass smtp.client-ip=209.85.208.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="cgZzS1Hr"
Received: by mail-ed1-f44.google.com with SMTP id 4fb4d7f45d1cf-69fab5a852cso1956662a12.0
        for <linux-ext4@vger.kernel.org>; Wed, 05 Aug 2026 12:02:21 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1785956537; cv=none;
        d=google.com; s=arc-20260327;
        b=fRjYSxW5eOOYwECqVo47yyzdnP1xKOJquoNXRBHfLRVlq0K7kEFHiv/lkN1dUDYZIM
         MqVKUG5mGmGhG+TFoT2rR6+dbxi574+Mn9vJ+FXWq2nd5dUxrNGXVrqurHN84vvJ/0qP
         1O/ZanRFVvkYFC80nOKZJ2ku1to1KFeXOteYUTuBjedzJPeIAcy3QkjCBRisZCNsy4/I
         nugxZ222Yrj/6+FFCs2nFTNObW3YFgH3/QK5SArjSfiKjWqH3WzEAD8QfSfXV1xpjG6x
         +OSge+3+4lpvtL4ayz5CpRI0uDAfIpJcs/OlSFgTetCw5c+3nFjQGt/FjG0C/PPywnrj
         Nhlg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=bXL8fOwPfzW8cmIw726T8X174t2PQj7sWrk7UD/8Cqs=;
        fh=TzYzjnfq5/R8RurSpOYwQSY8VIIxdbltgF9cCJd345I=;
        b=oRRNaSdcBcZEkFrOdde6/PK3Sfhhldyd4+L8HQ+b2JTX/yxiA7MIXe+N448hhzKLs0
         G2Te2P2azaMYofQXUG6ypwqzc0mnZUAW1MA1fGP4jh+64A70+Ce1Py4a6tFKMLE4QvVV
         z91DGXrlYOfoQNUnLbzqWOcaSCAKqbcqlLEUMVVd11VQpezDRXPgsruGu9SzdEOzdDwA
         PqKE7mI8yPSpVznh6O0rrkGGI7yxDjP/cgg9cBZr+6RM0+cCvefc0popJ1jHGEgOiIRG
         MbmlXBAbU/kEd6kJJd1z57NYobtbcRUg/25MZACkQkf5h4lNqed5P8Yhgg1AMWoXblkP
         K3Gg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785956537; x=1786561337; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=bXL8fOwPfzW8cmIw726T8X174t2PQj7sWrk7UD/8Cqs=;
        b=cgZzS1HrcybBAQzDLzBWmiQJ4n29RGThXWOxPiuU4xthiqwHH1PrJQuOiTQUn2m5id
         XPNi0w1SbVX3809FKXUwnsj/joR6GfQ4mlLN0kYS/7PiLZ4LWX0RUEmyPv3XuzsVxUtS
         xiXE1NsFQJx1gjgst5G1SxVJd9elgafqbzSCoc1+4Mz6I/fnwRbS3vpNRa9va5WKUoUV
         hQ+TM6U1e9OHmwrnwb2AVLAJG413G5yfjTpbj4UXST5B2iqG6hD8nWpRodgsBsfe34Og
         32IOALEzq4+DhovfABfJeTic+FoTBLtCE4xgac9Uz03I1/8xer0JZkKaeTlPcYEovR6S
         wIcg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785956537; x=1786561337;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=bXL8fOwPfzW8cmIw726T8X174t2PQj7sWrk7UD/8Cqs=;
        b=rlfdIEPs4Ny7qwgwWY5Xn3jZ1mHzWopfXI8ZQIDd7VyKsiOemRHzWNccoXSK4dysbq
         oVlNhdfFIV+kPYhWtqodKwXeGGiG2gts/njxnoa+87Z3q/vhovpWLGIaklpvhyfGt1Hm
         TkgZumavqEt9bYDo4BgQ2uPdjpj8tT9K8vlZgIdfru/i07ERAk5Ggq0g4ij/aQyCsbgu
         mkLbN7bzR/xILaXYmWZW0yAtVzL2zcKjYyiiwTctXb6JssI1kDWhxV7VBsqBg8A0CHbz
         nMWPGSbG8L71IWr3KIxPzkjKRN69xXL78TDhA3/j5TepPBrMI2SASoKE4NRaBJz4xwzg
         HXbw==
X-Forwarded-Encrypted: i=1; AHgh+RopjDXFhXvCH7+VZmEsMvA6ARvxWm0waXtq76kDD37fk/tA1OTHPWGzDz/+bwo0tKGBMMgF/qTUdfAY@vger.kernel.org
X-Gm-Message-State: AOJu0Yzn+/wMy5YP/00hPwa8YjbBBsVzaLGjzbTaS1z0Y6l/cE3V/tyi
	h9bgsaM22iG6L4+qeQqbh+IMJB4VlzXJ6wePB7rVLwk/oqUCvUcaLr74xr6DyMZj2oMY6L2Jvd8
	wqzPnEz6lNF3Q2zZIq9CiFGJyICqjrzQ=
X-Gm-Gg: AR+sD12UNVAIkyPsU0fWoBucBCMwCKm3GSoQr/oTuGKGJyy4kpZpvVa3cTHBDLJkiCA
	V4xaSF63Tv0QaF+/OLpkLz53AEHbxW2BdChrQ9WAvllP9wjSHjUAEFB7GoC7/sEeHZvF4/PdIrK
	hAh1szJaokfaDN/spuBAmI3Pm3dNJSf+busPOM6CKcVHLS9xARNGPcLHSRkptmsJk6Mj/CUyplH
	qcQKa18g+XyRPkbn8Y9fq+xcpcitfSyqDrxEznIO6cXzFlAt0IbGu/9natN6DbiCF0/Wn/5e1N2
	4EL6sbqYnsvzx6OXkg0MA6nTy/52BG3xKuZyJVt4KSA+
X-Received: by 2002:a05:6402:e87:b0:6a1:28d8:2306 with SMTP id
 4fb4d7f45d1cf-6a14f07bc72mr5050205a12.1.1785956536576; Wed, 05 Aug 2026
 12:02:16 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <cover.1785621505.git.coshi036@gmail.com> <2824f30bbc43e6a0b318564fa641228e9a096e37.1785621505.git.coshi036@gmail.com>
 <anDZ5YG-Ljflv7Vm@casper.infradead.org> <anFYf1iKrNLAjJMw@casper.infradead.org>
In-Reply-To: <anFYf1iKrNLAjJMw@casper.infradead.org>
From: Chris S <coshi036@gmail.com>
Date: Wed, 5 Aug 2026 15:02:05 -0400
X-Gm-Features: AUfX_myV5AVdy2Vk3b4_r8TJRgGAg0iuSL9FFYfHvWZSH4sclQZJlO_bQY1K40Y
Message-ID: <CACd_6n2GY2RRQPeKtJEuVkHcSBN-Ne2gJdHRfwxg2i=OT06MFg@mail.gmail.com>
Subject: Re: [PATCH 03/19] jbd2: point the shadow buffer at the frozen data directly
To: Matthew Wilcox <willy@infradead.org>
Cc: Jan Kara <jack@suse.cz>, Christian Brauner <brauner@kernel.org>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, linux-fsdevel@vger.kernel.org, 
	"Theodore Ts'o" <tytso@mit.edu>, Andreas Dilger <adilger.kernel@dilger.ca>, 
	Baokun Li <libaokun@linux.alibaba.com>, Ojaswin Mujoo <ojaswin@linux.ibm.com>, 
	Ritesh Harjani <ritesh.list@gmail.com>, Zhang Yi <yi.zhang@huawei.com>, 
	Bob Copeland <me@bobcopeland.com>, Namjae Jeon <linkinjeon@kernel.org>, 
	Sungjong Seo <sj1557.seo@samsung.com>, Yuezhang Mo <yuezhang.mo@sony.com>, 
	OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>, Mark Fasheh <mark@fasheh.com>, 
	Joel Becker <jlbec@evilplan.org>, Joseph Qi <joseph.qi@linux.alibaba.com>, 
	Andreas Gruenbacher <agruenba@redhat.com>, linux-ext4@vger.kernel.org, 
	ocfs2-devel@lists.linux.dev, gfs2@lists.linux.dev, 
	linux-karma-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Thank you so much.
Taken, with a change: the helper needs a matching unmap, and must not map
the folio-less case at all.

static inline void *kmap_local_bh(const struct buffer_head *bh)
{
if (!bh->b_folio)
return bh->b_data;
return kmap_local_folio(bh->b_folio, bh_offset(bh));
}

static inline void kunmap_local_bh(const struct buffer_head *bh, void *addr=
)
{
if (bh->b_folio)
kunmap_local(addr);
}

Two reasons.  kmap_local_page(virt_to_page(bh->b_data)) loses the offset
within the page, and b_frozen_data is kmalloc(b_size), which is only
guaranteed page aligned when the block size is at least PAGE_SIZE.

The second one is your other point.  With CONFIG_DEBUG_KMAP_LOCAL_FORCE_MAP=
,
__kmap_local_page_prot() maps even a lowmem page, one page at a time.  So
mapping memory that is already permanently mapped would walk this path
straight into the bs>PS problem you just described, which it is otherwise
immune to - b_data covers the whole block whatever its size.  Returning
b_data and calling kunmap_local() on it anyway is not an option either:
kunmap_local_indexed() WARNs on an address outside the fixmap range under
that config.  Hence the pair.

On the bs>PS folio path itself: agreed it is real and predates this series.
I would rather not fold a fix into this one, but I will take it - I'll look
at it separately once this has settled.

Chao

On Mon, Aug 3, 2026 at 11:12=E2=80=AFPM Matthew Wilcox <willy@infradead.org=
> wrote:
>
> On Mon, Aug 03, 2026 at 07:11:49PM +0100, Matthew Wilcox wrote:
> > On Sat, Aug 01, 2026 at 06:00:47PM -0400, Chao Shi wrote:
> > > @@ -330,6 +330,8 @@ static __u32 jbd2_checksum_data(__u32 crc32_sum, =
struct buffer_head *bh)
> > >     char *addr;
> > >     __u32 checksum;
> > >
> > > +   if (!bh->b_folio)
> > > +           return crc32_be(crc32_sum, bh->b_data, bh->b_size);
> > >     addr =3D kmap_local_folio(bh->b_folio, bh_offset(bh));
> > >     checksum =3D crc32_be(crc32_sum, addr, bh->b_size);
> > >     kunmap_local(addr);
> >
> > This is awkward.  How about ...
>
> ... Oh.  It's not just awkward.  The current code is actually wrong.
> If one uses ext4 on a bs>PS device and one has
> CONFIG_DEBUG_KMAP_LOCAL_FORCE_MAP enabled, it'll only map one
> page of the buffer and we should get a crash when trying to checksum
> the entire block.
>
> Supporting mapping multiple pages from a folio simultaneously is
> something we haven't figured out how to support.  Since HIGHMEM is
> dying (see Arnd's recent work), I'm not inclined to spend effort
> on it.
>
> We probably just need to make ext4 depend on !DEBUG_KMAP_LOCAL_FORCE_MAP
> or something?
>
> > static inline void *kmap_local_bh(const struct buffer_head *bh)
> > {
> >       if (bh->b_folio)
> >               return kmap_local_folio(bh->b_folio, bh_offset(bh));
> >       return kmap_local_page(virt_to_page(bh->b_data);
> > }
> >
> > (this is also somewhat awkward because it feels like we could just
> > return bh->b_data, but kunmap_local_indexed() does some ... stuff)
> >
> > Anyway, it all gets optimised away on non-HIGHMEM.  Or if it doesn't,
> > you can force it to ;-)
> >
> >
