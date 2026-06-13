Received: from mail-pf1-f169.google.com (mail-pf1-f169.google.com [209.85.210.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95375257845
	for <linux-ext4@vger.kernel.org>; Sat, 13 Jun 2026 22:16:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.210.169
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781388963; cv=pass; b=n1n+6G3GRfHflZAue4ttV1H2iwJyx36bgPtYlGS8hJOa9DcHvXDuT/dvlps8CC5Ep1leIFVd2fqGZrRKE3e2E1JqiGu8t0OuFPfKkAOltgOv/YNJJMt3vQFa1v5KCSX8ciXRAzyLl73LzVgqCX8e2wzFRuKpNEU/S0phrvdyFV8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781388963; c=relaxed/simple;
	bh=gfPG9llT8fRYRjxJuYldKY/cP5EobsF3J+I2WRLNQKY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=uxBILPgTYA55xLY0u8YGBAI1GMmrsPfWEVXkywT7oui0JTbxpt47DQNNktU7vC5o8tGRJOAvWNIqFPjpdt+MItK/+3vLiHZ7SHJHIUorAOqsvvT+sRfUU44pHxUMLZqq6nvsANTZrMvxWawJaooS6TT6n/cJkBx14WAmC71SRl0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=asu.edu; spf=pass smtp.mailfrom=asu.edu; dkim=pass (2048-bit key) header.d=asu.edu header.i=@asu.edu header.b=ACeqWnvs; arc=pass smtp.client-ip=209.85.210.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=asu.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=asu.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=asu.edu header.i=@asu.edu header.b="ACeqWnvs"
Received: by mail-pf1-f169.google.com with SMTP id d2e1a72fcca58-84275887a3fso2191020b3a.1
        for <linux-ext4@vger.kernel.org>; Sat, 13 Jun 2026 15:16:01 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1781388961; cv=none;
        d=google.com; s=arc-20240605;
        b=Qy1dN6+RVu7ZZKtB2eNb5ZdL1/mh80Kl+r8xPUlMl8/gWgufMz26btRBr7rhcxO45/
         Qn6K+2fOdUbMR6rjNkDICchF4cR0ONdqwCzm9zP6vp6Qlg5P+hIyr3BpPuyT1HLGU48E
         RXHzUToYavu1ZOW/F9roN3vevlvUROUTVrvd63gGOUE8ynv3rzzWTsk6jQ5QWKgN3daD
         qfn59pebHsu5tfhayyO/SMQCnxRHs/+2R2EJz2jadE/fuKle2omGU4Nps9//tisFr7Ay
         haybhfZ8jaOwk3ftjr41sKFvG9P8hLodUMBW43ufK1NM6xbDLp1Bfz8+95sXgGjV8XGd
         9b9g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=MSAIzyEhiIIYvGBU6bRfL2C30KbRbdKsUwB2PcICdSI=;
        fh=/KsSh7Bbq0s8IsxyG9YUv+ObyE7ksXPKe14g2XxDU6M=;
        b=fN61nx3TyB0cQ2MdIlulnIPEz/Ue7LydcCI8EzIz6XZqth8/TPPH2KaPR3Tshiw+/U
         7xh9i09wm/GF4wrULQuzqML7Fnnbzr9Koaz6dIyYp87C1exyRararPQDVhWaas/+Zkc2
         BI5pXKE2ILPWF9/zxo0+qkpXovJ/L22qEZQWtaNah6OqSCyyb9399do5luASuF32NQ6X
         12QxGvu9/7S5XzYeLsYPpBkI+jiRDKxGDiBCipt+J2MyRYMB4vXRZzz1xyyMUWP+ameO
         7Abpxihx6zuyi7t9RMQmZJNQ0JMNATmOqhFB7eCKcYkP2vrIntoKSeA8LxDqe7fMB1LU
         GHWw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=asu.edu; s=google; t=1781388961; x=1781993761; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=MSAIzyEhiIIYvGBU6bRfL2C30KbRbdKsUwB2PcICdSI=;
        b=ACeqWnvsNC5PtigFji932mRTm9ETo5I3YKNBZp0P5WfOCkv2Zd6ALlX3CCVzsiraR/
         4q9Zf3jVVZm59GhLovHhgtxcE/+V1sJgNfnSaZiE+q/p7njtckaAlWhXFfYFcP1xNr2V
         +3SvSJcFlIyf7YnIo5KS278P6828XZxRAosKtAq4EVKOLtX8KsY52/tC3JacJFt0JH5k
         s22TCTpJvQkqtVIVEnlqlSZ6D+u9306v//uD1oRlRKVU3CSDE5jusG4qyjKvoOCH6mX5
         TJx2lX+s3ZRH4HcRcdsouG6tzygnGD+U/ei2VdMT5fHjjqNUudicF5IxlVr7BGeHUoVG
         g22Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781388961; x=1781993761;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=MSAIzyEhiIIYvGBU6bRfL2C30KbRbdKsUwB2PcICdSI=;
        b=N8k52VMoiL4/zw/QB3qgo2rh+XqfHBFH3UiH8C5p4m+pIipwG7iggTHHBjZPUcjti5
         DZxTqm74qyxm8VIjvEER0wLTxdSx1LeXamcQ8Ct9eHZ+KQMATMyPeb87ARhYccNnPgW2
         DDm19chWCtHzwSErxNYr+3vgd32Ap5k+qpHcmknBdKH/ULAsoWvy+9F6jEALLZ8h4eVi
         WHmqdfNvHxvARGTp9aLWKNBeUgCAWLwet1xZ4VYt0i2hCZfWoiJ+2ib9JVQAR3ztAJIN
         vU3BgsjiBgTxEG1bjxn0+z6qNwCqAjlBAWRuD7SJA+69eNiga3GDhkZmcK1FL4Ji3t95
         IzOQ==
X-Gm-Message-State: AOJu0YyLarGa4LcWx8sufqfst8z3zx+ODw+OnE93T+SDRIEaSebDkTIm
	VTasbazDLk/cDcEq2fOJflvwKcUBTW0JmZB7eg0BTgTjn8dKuIabd7PKG2b294t9kU9fccAywiI
	frxpVKG8r8pdoOIMKnBbjzdQHFBJfF7J0SdEqJdug
X-Gm-Gg: Acq92OGjSWoZXmzgsYSkXJk/cIZzlPXNq6Mqq4bRXLokKQVwUODhInAZ9bCuM533rXy
	uptdCoC1P0O9+Klb/bRbWGxsJyCCbMuCvlv6sFcf9o9x7+4almxo36Sc1zp+ygtfS63ZeIsGMjc
	jbB95MJtl4SDM79AlVbeUkPoHv7m79vOLPtSVuS4bphdr7YOXvCfCel3mWjGpQL0gRpEom2aHWA
	ZV/U9IDcACTTIz0eCsbmhjyAzmPA9Q9boRJDCMCr/0HwQmlzt0h4EPvH9k07sTxjMXYSaRUOSC9
	Y+XSoaOX3MOJauJ51fCFBuDj+fTwmwu+vuq4QE5anmCTI/fsIw==
X-Received: by 2002:a05:6a20:7f99:b0:3b4:701f:a0ee with SMTP id
 adf61e73a8af0-3b785853bacmr7338141637.19.1781388960920; Sat, 13 Jun 2026
 15:16:00 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260609010739.2278172-1-xmei5@asu.edu> <p2kykhe5532mxqgnmgyrg24cmlpcz24qn2erw3lkzabjjubbyq@i2c3mfdm7mpc>
 <CAPpSM+TS=mXfKXqN65ic5xFA+S3YvJfa5BuSQ5VwEA1O19VqzA@mail.gmail.com>
In-Reply-To: <CAPpSM+TS=mXfKXqN65ic5xFA+S3YvJfa5BuSQ5VwEA1O19VqzA@mail.gmail.com>
From: Xiang Mei <xmei5@asu.edu>
Date: Sat, 13 Jun 2026 15:15:49 -0700
X-Gm-Features: AVVi8Cdk71VYrFdaUnyVtmP_aGSdob0ZL7uB-jKHQYU9m4gE1EMDRt6Btwt358I
Message-ID: <CAPpSM+SZzNznbLU=q4qVPFBGs0qkxQyorUCQTmQk4PbeZ65Y6Q@mail.gmail.com>
Subject: Re: [PATCH net v2] ext4: fix out-of-bounds read in ext4_read_inline_dir()
To: Jan Kara <jack@suse.cz>
Cc: linux-ext4@vger.kernel.org, "Theodore Ts'o" <tytso@mit.edu>, 
	Andreas Dilger <adilger.kernel@dilger.ca>, Baokun Li <libaokun@linux.alibaba.com>, 
	Ojaswin Mujoo <ojaswin@linux.ibm.com>, Ritesh Harjani <ritesh.list@gmail.com>, 
	Zhang Yi <yi.zhang@huawei.com>, Weiming Shi <bestswngs@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, Jun 13, 2026 at 3:06=E2=80=AFPM Xiang Mei <xmei5@asu.edu> wrote:
>
> On Wed, Jun 10, 2026 at 3:01=E2=80=AFAM Jan Kara <jack@suse.cz> wrote:
> >
> > What does the 'net' in [PATCH net v2] mean?
> >
> > On Mon 08-06-26 18:07:39, Xiang Mei wrote:
> > > ext4_read_inline_dir() reads de->rec_len / de->name past the end of i=
ts
> > > inline buffer for a crafted or corrupted inline directory, triggering=
 a
> > > slab-out-of-bounds read during getdents64():
> > >
> > >   BUG: KASAN: slab-out-of-bounds in filldir64 (fs/readdir.c:371)
> > >   Read of size 8 at addr ffff88800fd3da3c by task exploit/146
> > >    ...
> > >    kasan_report (mm/kasan/report.c:595)
> > >    filldir64 (fs/readdir.c:371)
> > >    iterate_dir (fs/readdir.c:110)
> > >    ...
> > >
> > > The payload is copied into a buffer of exactly inline_size bytes:
> > >
> > >       dir_buf =3D kmalloc(inline_size, GFP_NOFS);
> > >
> > > but iteration runs in a logical position space extra_offset bytes lar=
ger
> > > than the buffer (extra_size =3D extra_offset + inline_size), so the s=
ynthetic
> > > "." and ".." entries land at the offsets they would have in a block-b=
ased
> > > directory. A real dirent is formed at "dir_buf + pos - extra_offset",=
 yet
> > > the loop bounds and the ext4_check_dir_entry() length argument are al=
l
> > > expressed in the larger extra_size. Two reachable sites dereference a
> > > dirent before confirming its physical offset is inside the allocation=
:
> > >
> > > In the main loop, ctx->pos is attacker-controlled via lseek() and the=
 entry
> > > is validated with extra_size, so ext4_check_dir_entry() accepts a dir=
ent
> > > running up to extra_offset bytes past the allocation before its lengt=
h
> > > check fires. ctx->pos is also a signed loff_t: an lseek() to a small =
value
> > > below extra_offset makes "ctx->pos - extra_offset" negative, so a che=
ck
> > > that only bounds the top of the buffer is bypassed by underflow and d=
e is
> > > formed before dir_buf.
> > >
> > > In the cookie-rescan loop, entered when i_version changed since the l=
ast
> > > readdir(2), the walk restarts from the beginning with i bounded by
> > > extra_size, so as i approaches extra_size the unconditional read of
> > > de->rec_len runs past the allocation before any validation.
> > >
> > > Both are the same defect, logical extra_size space versus the physica=
l
> > > inline_size buffer. In each loop, reject a dirent whose header would =
not
> > > fit within inline_size before forming de, and in the main loop also r=
eject a
> > > position that underflows below extra_offset. Validate the main-loop e=
ntry
> > > against inline_size rather than extra_size. Entries that legitimately=
 fill
> > > the inline data still pass.
> > >
> > > Fixes: c4d8b0235aa9 ("ext4: fix readdir error in case inline_data+^di=
r_index.")
> > > Reported-by: Weiming Shi <bestswngs@gmail.com>
> > > Assisted-by: Claude:claude-opus-4-8
> > > Signed-off-by: Xiang Mei <xmei5@asu.edu>
> >
> > Thanks for the analysis and the patch. See some suggestions for improve=
ment
> > below:
> >
> > > @@ -1488,10 +1491,20 @@ int ext4_read_inline_dir(struct file *file,
> > >                       continue;
> > >               }
> > >
> > > +             /*
> > > +              * de lives at dir_buf + ctx->pos - extra_offset, so th=
e dirent
> > > +              * header must fit within inline_size.  ctx->pos is a s=
igned,
> > > +              * lseek()-controlled loff_t: check the lower bound fir=
st, or
> > > +              * ctx->pos < extra_offset underflows and points de bef=
ore dir_buf.
> > > +              */
> > > +             if (ctx->pos < extra_offset ||
> > > +                 ctx->pos - extra_offset + ext4_dir_rec_len(1, NULL)=
 >
> > > +                 inline_size)
> > > +                     goto out;
> >
> > So I don't think this is really possible. ctx->pos isn't really fully u=
ser
> > controlled. When you use seek to modify ctx->pos, ext4_dir_llseek() doe=
s
> > set info->cookie to invalid value so the next time we enter
> > ext4_read_inline_dir() we are guaranteed to revalidate the offset and r=
eset
> > it to 0, dotdot_offset, or some value greater than extra_size.
>
> Please ignore v3. It doesn't actually fix the original bug, and the PoC
> still triggers KASAN with v3 applied.
>
> You're right that lseek() poisons info->cookie and the next
> ext4_read_inline_dir() always takes the !inode_eq_iversion() rescan path.
> But the rescan doesn't reset ctx->pos to a safe value. It walks forward:
>
> i +=3D ext4_rec_len_from_disk(de->rec_len, extra_size);
>
> i.e. it advances i by the rec_len field of each inline dirent, which is
> attacker-controlled, and the only per-entry check is the "non-zero rec_le=
n"
> probe (which itself reads de->rec_len). It then commits "offset =3D i;
> ctx->pos =3D offset;". So the rescan can legitimately land ctx->pos at a
> position whose dirent header already lies past inline_size - it is not
> clamped to a valid in-bounds entry.
>
> The main loop then forms de =3D dir_buf + ctx->pos - extra_offset and cal=
ls
> ext4_check_dir_entry(), which dereferences de->rec_len before the length
> check fires. With v3 (which only fixed the rescan probe and the size
> argument, but had no bounds check on the committed ctx->pos), this still
> reads past the buffer:
>
> BUG: KASAN: slab-out-of-bounds in __ext4_check_dir_entry
> Read of size 2 at addr ... (0 bytes to the right of a 60-byte
> kmalloc-64 region)
> __ext4_check_dir_entry
> ext4_read_inline_dir
> iterate_dir
>
> You were right about one thing: the lower-bound (ctx->pos < extra_offset,
> "de before dir_buf") case I once guarded against can't happen, since
> ctx->pos never comes in below the dotdot offsets. v4 drops that and keeps
> only the upper-bound check in the main loop, which I've confirmed stops t=
he
> reproducer. Sorry for sending a patch I hadn't fully verified.
>
> v4 to follow.
My bad again. I didn't send out the broken v3. So the correct version
would be the corrected v3.
v3 to follow.

Xiang
>
> Xiang
>
> >
> > >               de =3D (struct ext4_dir_entry_2 *)
> > >                       (dir_buf + ctx->pos - extra_offset);
> > >               if (ext4_check_dir_entry(inode, file, de, iloc.bh, dir_=
buf,
> > > -                                      extra_size, ctx->pos))
> > > +                                      inline_size, ctx->pos))
> > >                       goto out;
> > >               if (le32_to_cpu(de->inode)) {
> > >                       if (!dir_emit(ctx, de->name, de->name_len,
> >
> > Otherwise the patch looks good.
> >
> >                                                                 Honza
> > --
> > Jan Kara <jack@suse.com>
> > SUSE Labs, CR
