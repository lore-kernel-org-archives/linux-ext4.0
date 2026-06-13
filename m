Received: from mail-pj1-f41.google.com (mail-pj1-f41.google.com [209.85.216.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59AFA395AC5
	for <linux-ext4@vger.kernel.org>; Sat, 13 Jun 2026 21:42:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.216.41
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781386958; cv=pass; b=KvhN1QjmA5CvKDy2Aq1+KNjRxNzU2TjG0LvO/uu1GE3AGOuzU5vWoHtw8lpfi0W4MW3wWQuZtMmwSknYT90jiVu3ZzVy+k1bLayyeFN8jYffVD16Of01ALtfRpZGrCWAfAa9sZAPestg4MaGSxYt1zP2yVm/ZgpIrT0h6ZBMwcY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781386958; c=relaxed/simple;
	bh=jQFu4QrQL57xgpA4cjSw4CKyactirzcEJBZrobG4AdE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Ge6kyyp4zWKiWGwiWrJk0BQ25FkLkr3MioAKM1ZrzND9qDRDoVtyqYRQJLxkSuBVEjnf5UJaGsxiMmU+cUDgqFFtNBELG1euboB0t39w+IZs4WxM3LINbaCklIsZhnmTKR0OV0QQ3yWG/edHTFosgwWDRtv9lrIPdNCJHYxUtZU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=asu.edu; spf=pass smtp.mailfrom=asu.edu; dkim=pass (2048-bit key) header.d=asu.edu header.i=@asu.edu header.b=ktUVpavA; arc=pass smtp.client-ip=209.85.216.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=asu.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=asu.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=asu.edu header.i=@asu.edu header.b="ktUVpavA"
Received: by mail-pj1-f41.google.com with SMTP id 98e67ed59e1d1-36b9d265355so996063a91.2
        for <linux-ext4@vger.kernel.org>; Sat, 13 Jun 2026 14:42:34 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1781386953; cv=none;
        d=google.com; s=arc-20240605;
        b=JsTlgmEEz2e9ROMJPSjQsLwHjDoeZyW2qtNu2lZE4//K+GSGSWNmyz4i2U/QsEtKaI
         3oAP3FmAhCZKf5TYV2tgzlIqnELKCl7PFZhtcnfSpuBa+j6NNBP7KQ8RRcBlxH9Jn5tY
         cbaGgoYCSc2VAHaHVSaA2TnlFjNWwBmhipXqrsBM+z9NWFemQi9XYNHsSK0sUzcojWOW
         f526sc7T7sYnvyINPcMZdBnpiWHdeDAeeoIqPXOsih7X6DVlhf9dRagP8AJn0xuXWl9r
         7sFPcGdHpmRlcMhZYgmqeBN5BCmYaZZY22WjHeBwYGTK5ttrNTLIJNl929DfvfsmRaYq
         1yOQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=ultZNaGaqV7RNfa5QFGaS6CtECtOjYOtoxxzVnB9Lu8=;
        fh=/KsSh7Bbq0s8IsxyG9YUv+ObyE7ksXPKe14g2XxDU6M=;
        b=hnH29GpJ7HPMXN57Nk9N0e+XIVZjZ0w+1xMQIzbyRJ7LSGtBM1ycLQXq3pcv593Yob
         RjWvZOZgnJ5O+12bdY3Nue4ybWQE7tli7vZBAF/9nNiyqYx8qImzvjtlOYm13eEBM+AB
         HPGH5C/6m0SDNMTkW2tv6MXkhmZApff26AbWKlaRCXd16JuAjajr+clovBYmXtX/er5U
         TvTEMFANzwbzQxHdPDLIf2kpe675CZhAY7qJyuFR5bG4EUvL8f9T0Bjd4K+/rck4MYTb
         wsWxMrgHNhj8ZBjyWEMNbJsvdv4ZC8iFIn4hsVyynsHaEuxTEZKix85E2lwM8eJwpBnr
         dtlA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=asu.edu; s=google; t=1781386953; x=1781991753; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ultZNaGaqV7RNfa5QFGaS6CtECtOjYOtoxxzVnB9Lu8=;
        b=ktUVpavAX6zy22ITXdiXqmOFR7n6XJcu8b2BPyk2Mbs2pJg5dBoRng8R24LbyTaEtf
         Hvdsm6FlX6WpIOwZnKz+ciRJj+lo/n+aPZ7Hy0s1b75gtFIyi20V6T4JOCCntpsKvhD5
         uxB+8Oxfk/8R2u4+vGKrHN2Nnkct4ZvgQYaGGIbk0v0Fz1/vZLkDNLpxRX665ma2CI/E
         Xj0x2GxK8rn7fjSNWCdtTVLrhzcAcc2zzT6k06c3HSGPYolWWOjWcJvIlksaFA+OVOp+
         cgIaj4pG0zvO/gdDEVo33JQY6ZJekH6TZ9vwo/awnBJpakoq5ogCnBGfVr5PXZXjelJP
         otAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781386953; x=1781991753;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=ultZNaGaqV7RNfa5QFGaS6CtECtOjYOtoxxzVnB9Lu8=;
        b=oD40BlHqsl/aRrGGOqIpKNWG8HE6Rya0+W5SjLR8qkFlozz19udks6zMA42/2/m1JA
         EOyhPbPPyhE8wrl7Iv1j+WNQZ1qG1OB+3mv12Uvzc1iqzDBWwSrpQfl8hL5b37j9bqDl
         cy+jJLis5zLDceIZRj8LywzbXjpHPxrkTJAx5c6p8PSVbfvQM/d8mX+U0tchkZgOxdjy
         VueT/G76/bBUIFBy4r554YKGFpjo+hQq9HWoBSYgJrVmX2RhJ+iNlijs/AndEYArCTVa
         OewwwP6jEZGUCuW/ZaC7Idnqzz/D/DxOVzMtnAz9HszfZnOHdLvY9PyE2EFdkhbe5pwg
         aQkQ==
X-Gm-Message-State: AOJu0YzDJreujqm+GMqr40/S4/vUPd4VTCruhezaAGLSutikwrCBhefC
	ugfbZ6rUmwYfDZL0QwJDMrXyBnhGpMf911yFQkjRQUNKGHodPh8KPHMfcbCn8PP52sfWj2TQKOk
	iJafxqK3XDgRZSaKNuuWNGgNSszkaz0a/fOhJD9d+
X-Gm-Gg: Acq92OGfJJ9hal9vNW0LbZfsBF51qYpIA0D6qvrOFiaCs8Wv+UVOC9xz8vhe3ocBSTK
	7JMzqvSICGNitzEHKMAoFgD+vuiapGQNoMQ+dsKQf20w+8KyaDtMelf4I+8gjKv+QMar+CY7ouZ
	cNNSuHxdS+Xf07Bba0x0cw6+GuAeOz0w1Czteb1sAkllv6cNJ8LBk+32p0CevvgyGHdctXeD+2/
	3F/xP0eYA6akB5VZs9l6GsajY/ZGqgJS+fpcG5lEUKrYGGdEJdt+9qKZoUmjWnRb5BSZcUOhLP6
	IE5p/RwFrVM8Upasqm+r9PMvVt5UVDX0I6jADaas3Zb+inN9Mw==
X-Received: by 2002:a05:6a20:3d22:b0:3b3:fc6:622d with SMTP id
 adf61e73a8af0-3b784021914mr8858468637.38.1781386953396; Sat, 13 Jun 2026
 14:42:33 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260609010739.2278172-1-xmei5@asu.edu> <p2kykhe5532mxqgnmgyrg24cmlpcz24qn2erw3lkzabjjubbyq@i2c3mfdm7mpc>
In-Reply-To: <p2kykhe5532mxqgnmgyrg24cmlpcz24qn2erw3lkzabjjubbyq@i2c3mfdm7mpc>
From: Xiang Mei <xmei5@asu.edu>
Date: Sat, 13 Jun 2026 14:42:22 -0700
X-Gm-Features: AVVi8CdyafpTKFdj8wQD-Ft3763dPkqjS-1-9FYz98WJJ3tBPV4xU7qo8MnUM0A
Message-ID: <CAPpSM+RHdnie8BxervEMnN12DEyByyMNrFLQpMuRiB=XKd2OAg@mail.gmail.com>
Subject: Re: [PATCH net v2] ext4: fix out-of-bounds read in ext4_read_inline_dir()
To: Jan Kara <jack@suse.cz>
Cc: linux-ext4@vger.kernel.org, "Theodore Ts'o" <tytso@mit.edu>, 
	Andreas Dilger <adilger.kernel@dilger.ca>, Baokun Li <libaokun@linux.alibaba.com>, 
	Ojaswin Mujoo <ojaswin@linux.ibm.com>, Ritesh Harjani <ritesh.list@gmail.com>, 
	Zhang Yi <yi.zhang@huawei.com>, Weiming Shi <bestswngs@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Jun 10, 2026 at 3:01=E2=80=AFAM Jan Kara <jack@suse.cz> wrote:
>
> What does the 'net' in [PATCH net v2] mean?
>
Sorry, it was a mistake. It should be ext4.
> On Mon 08-06-26 18:07:39, Xiang Mei wrote:
> > ext4_read_inline_dir() reads de->rec_len / de->name past the end of its
> > inline buffer for a crafted or corrupted inline directory, triggering a
> > slab-out-of-bounds read during getdents64():
> >
> >   BUG: KASAN: slab-out-of-bounds in filldir64 (fs/readdir.c:371)
> >   Read of size 8 at addr ffff88800fd3da3c by task exploit/146
> >    ...
> >    kasan_report (mm/kasan/report.c:595)
> >    filldir64 (fs/readdir.c:371)
> >    iterate_dir (fs/readdir.c:110)
> >    ...
> >
> > The payload is copied into a buffer of exactly inline_size bytes:
> >
> >       dir_buf =3D kmalloc(inline_size, GFP_NOFS);
> >
> > but iteration runs in a logical position space extra_offset bytes large=
r
> > than the buffer (extra_size =3D extra_offset + inline_size), so the syn=
thetic
> > "." and ".." entries land at the offsets they would have in a block-bas=
ed
> > directory. A real dirent is formed at "dir_buf + pos - extra_offset", y=
et
> > the loop bounds and the ext4_check_dir_entry() length argument are all
> > expressed in the larger extra_size. Two reachable sites dereference a
> > dirent before confirming its physical offset is inside the allocation:
> >
> > In the main loop, ctx->pos is attacker-controlled via lseek() and the e=
ntry
> > is validated with extra_size, so ext4_check_dir_entry() accepts a diren=
t
> > running up to extra_offset bytes past the allocation before its length
> > check fires. ctx->pos is also a signed loff_t: an lseek() to a small va=
lue
> > below extra_offset makes "ctx->pos - extra_offset" negative, so a check
> > that only bounds the top of the buffer is bypassed by underflow and de =
is
> > formed before dir_buf.
> >
> > In the cookie-rescan loop, entered when i_version changed since the las=
t
> > readdir(2), the walk restarts from the beginning with i bounded by
> > extra_size, so as i approaches extra_size the unconditional read of
> > de->rec_len runs past the allocation before any validation.
> >
> > Both are the same defect, logical extra_size space versus the physical
> > inline_size buffer. In each loop, reject a dirent whose header would no=
t
> > fit within inline_size before forming de, and in the main loop also rej=
ect a
> > position that underflows below extra_offset. Validate the main-loop ent=
ry
> > against inline_size rather than extra_size. Entries that legitimately f=
ill
> > the inline data still pass.
> >
> > Fixes: c4d8b0235aa9 ("ext4: fix readdir error in case inline_data+^dir_=
index.")
> > Reported-by: Weiming Shi <bestswngs@gmail.com>
> > Assisted-by: Claude:claude-opus-4-8
> > Signed-off-by: Xiang Mei <xmei5@asu.edu>
>
> Thanks for the analysis and the patch. See some suggestions for improveme=
nt
> below:
>
> > @@ -1488,10 +1491,20 @@ int ext4_read_inline_dir(struct file *file,
> >                       continue;
> >               }
> >
> > +             /*
> > +              * de lives at dir_buf + ctx->pos - extra_offset, so the =
dirent
> > +              * header must fit within inline_size.  ctx->pos is a sig=
ned,
> > +              * lseek()-controlled loff_t: check the lower bound first=
, or
> > +              * ctx->pos < extra_offset underflows and points de befor=
e dir_buf.
> > +              */
> > +             if (ctx->pos < extra_offset ||
> > +                 ctx->pos - extra_offset + ext4_dir_rec_len(1, NULL) >
> > +                 inline_size)
> > +                     goto out;
>
> So I don't think this is really possible. ctx->pos isn't really fully use=
r
> controlled. When you use seek to modify ctx->pos, ext4_dir_llseek() does
> set info->cookie to invalid value so the next time we enter
> ext4_read_inline_dir() we are guaranteed to revalidate the offset and res=
et
> it to 0, dotdot_offset, or some value greater than extra_size.

You're right, thanks. The rescan path rebuilds ctx->pos, so the
underflow can't happen. I'll drop this in v3.

Xiang
>
> >               de =3D (struct ext4_dir_entry_2 *)
> >                       (dir_buf + ctx->pos - extra_offset);
> >               if (ext4_check_dir_entry(inode, file, de, iloc.bh, dir_bu=
f,
> > -                                      extra_size, ctx->pos))
> > +                                      inline_size, ctx->pos))
> >                       goto out;
> >               if (le32_to_cpu(de->inode)) {
> >                       if (!dir_emit(ctx, de->name, de->name_len,
>
> Otherwise the patch looks good.
>
>                                                                 Honza
> --
> Jan Kara <jack@suse.com>
> SUSE Labs, CR
