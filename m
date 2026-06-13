Received: from mail-pj1-f51.google.com (mail-pj1-f51.google.com [209.85.216.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B86AF3A6B8D
	for <linux-ext4@vger.kernel.org>; Sat, 13 Jun 2026 22:06:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.216.51
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781388401; cv=pass; b=CLfB/e7Xyf5COhdLHUASVq/cLjNjUkWSR16ggjHaqwkt9AQi1jW+759tW16P+NNeUi8YRMdZLgrBljnavybeoWP5aLcA+JyWspf/6i4iUPGbVrPVbZEQmpUHvZLFLG+ClLdo2I/bMclGsXmCwRcDpWiDajAhfR9J8pENDq9bgHE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781388401; c=relaxed/simple;
	bh=smYpYroXbRMxeElrClAUPBRpLfHIP1hnfQBrFTAhqps=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Tk74PagxNj9/eGcNfAcBkEskXzCaSv0jlN0iHySHiKdGxF3CI1INuzKhzs+4/de/lCP70hyVPFur1wsVhuUbts86i2NlLNFg4FhylDsazUob/UqpMx8s1JnrKzcC9aMe2c28dxMJnUdbE72iOV/uA/z5b8JNSkrNQoXwID8d6n0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=asu.edu; spf=pass smtp.mailfrom=asu.edu; dkim=pass (2048-bit key) header.d=asu.edu header.i=@asu.edu header.b=OniaztyD; arc=pass smtp.client-ip=209.85.216.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=asu.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=asu.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=asu.edu header.i=@asu.edu header.b="OniaztyD"
Received: by mail-pj1-f51.google.com with SMTP id 98e67ed59e1d1-36c68964315so1158202a91.2
        for <linux-ext4@vger.kernel.org>; Sat, 13 Jun 2026 15:06:28 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1781388388; cv=none;
        d=google.com; s=arc-20240605;
        b=WUkE6T3zKD3SPTF6o4r34iaWX39lvN+DuEyv0vd5lpJQ0anJW/56yXVz1CeHzBtfU7
         OkpBbypsDlG799YBYtYYlhQrru6vx8R2ADbuosqDj66W5paJS1qtduuVwBrses+JKPZb
         xRPAR1FggH4ZQFAT528cT7UepEUgk776mBjzbw4oEQAS1pl2l7gomsk6rOo406vKsnIL
         A+kb18R6escdheMTyfnHhf2c4ktU3uK2y2FFPaSoCL5YKFCMN4dOUIBRZ1E5oJ/rb2Xt
         0I09tmTx5KWX2eUJ2G+ajzBnaklYZcCJZBYhrMWx7EpWTt4d8OAo0IK9gLDSEVsi3GLL
         O/Pw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=vYxmNl+Ra7ib6Ur/a3W5FBzrxAR+q39iMHHS4yEQ9RU=;
        fh=/KsSh7Bbq0s8IsxyG9YUv+ObyE7ksXPKe14g2XxDU6M=;
        b=XadNlXDbYS+AsUJ+gHUv44ZVDbyn0TZCor/W4kpJrCwZOdY1pzgjkaOA7F6Ss9PAlK
         nWiTLG1WPFnzM7L754+2Cf/WK0B18Ll7oDZPjIglXp72snbNF2nSfZALn1h0Jy26aKty
         03NAyDCTpoyppf4CzA87lq+0GzaYzNFF/0FiNeW/vpN78e+s1VSzWvURXdcwCNWiIAVH
         Qm1oG5x9rP0N52He6YjaS2sCWvl2S/QV/oQ4xjx+nc22cmd6OwC8C8041iuWkcUgIOo4
         PQViiIhEyO2pWKO7mgJV6Qrr+fVjHTMZNjzsf+6H/2Xf12GAXZ43SwvbJS8hCzDb+2HF
         YlsA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=asu.edu; s=google; t=1781388388; x=1781993188; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=vYxmNl+Ra7ib6Ur/a3W5FBzrxAR+q39iMHHS4yEQ9RU=;
        b=OniaztyDQod45FGF7+DLcGKQ7Pq3qbrP5bFyvhSOtHZm1VJNBWNKiYTEcS3YQ5Cljg
         mrn5mdEVy1IwliJ9ygeSttDhsEjmSxMugw2iQXyMxXRqhAIcn0mjhtCizwzONExiGQEv
         d6KQCz1hWFif9aaGuTXDD1at5F41SrdoH6ewW80459/rMvt6InTiVP32vQX/d815ZEi8
         tLjGYMrl+kA3et5aKJ01PpH/9/5VCMqq7hVmNPrzdnp6NQ04AUYiXFT8KWuwyiWIi9bY
         Q/1LDkfWDYHdhimWsF0kW27PSsr0YTFA1lDE+HW2ieQGHqLgN5Y//7e4Au26+6OjulLL
         HcQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781388388; x=1781993188;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=vYxmNl+Ra7ib6Ur/a3W5FBzrxAR+q39iMHHS4yEQ9RU=;
        b=eYcOG9Dvd34JNFgSHI1qmXbbwp9Wby+EA4BFYHMx9ungTB5dxSQ6t1SUbcjPNAvdQ5
         m17/5yf9sE8WGLnCKBLigU0PKBAJ/BZEoPXA6d3P2ZteyHPwPD7MURjR5RJLj/HIzvGl
         bUaDHJGDnK/vwqfBK5zqIKhNKErbSyWHad2ti6DemlZtV7YA4VH4onKs/VaceCDABSzj
         g3u6crb32ufqOr2CXK9bvACcsx7/MR0+TYwWQkaElnOPpdVkdfxw17y4SUIk5seu5EuF
         48cRmXIt/sZbl169StC/ulnptbw87ZmNmdVyHyHOeSK9CgcbpqvezKUikbxwCh7lrjz1
         rRUQ==
X-Gm-Message-State: AOJu0YyFIR1rwZvb+tQ8op6N8ep02tQrw13mUWfY/wfJ4MNJdbAIEj9c
	y3g2dqB3Iub2BeE5zxAVNqRdII+QlImb1Yo1kqX0ESjglRvWrk8a4wGoT4jtM2w6kACbllSD2E4
	A4OwTbVNzGYJ6mJ2ip8bhe+nvlstUcjnsjVn9XDTG
X-Gm-Gg: Acq92OF6Xt8KyBbH5ovfbhR59Ub9oGEIi70G/QLAfw1cPTJbonQ4Cbxi3gpl1a2mT4j
	eNQcaLDvrW74Dz8klUOrCIruX7Y+LGobW6uCN0jetREfqXxFWhA3UGcsJWsEUMCxgFkKYGvzeTH
	87NSawyue/BxJQW4ewpoIw5sCqNJrDlscJj3jFxfPCNGU6iWdwOKG+Ta9rCEgnzptoryqhQPAsF
	BIcqHpJG1Ou9U678NztrqrbLRr8TCuDNN/XDeCUQ7Rq8V4vBh3EtsvJPBaI2bJhNfEPr8GV8CU2
	aq3kqTESRZfE+j8DGQB6I3tBv9hB26U88l01X7A=
X-Received: by 2002:a17:90a:c890:b0:36d:a510:f8eb with SMTP id
 98e67ed59e1d1-37a01846de6mr9119887a91.3.1781388387992; Sat, 13 Jun 2026
 15:06:27 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260609010739.2278172-1-xmei5@asu.edu> <p2kykhe5532mxqgnmgyrg24cmlpcz24qn2erw3lkzabjjubbyq@i2c3mfdm7mpc>
In-Reply-To: <p2kykhe5532mxqgnmgyrg24cmlpcz24qn2erw3lkzabjjubbyq@i2c3mfdm7mpc>
From: Xiang Mei <xmei5@asu.edu>
Date: Sat, 13 Jun 2026 15:06:16 -0700
X-Gm-Features: AVVi8CfU1313IV9FsfYZ3OfXHdp075s9mtVMB3nuUfFOothBauzf0nZjfbWMNRA
Message-ID: <CAPpSM+TS=mXfKXqN65ic5xFA+S3YvJfa5BuSQ5VwEA1O19VqzA@mail.gmail.com>
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

Please ignore v3. It doesn't actually fix the original bug, and the PoC
still triggers KASAN with v3 applied.

You're right that lseek() poisons info->cookie and the next
ext4_read_inline_dir() always takes the !inode_eq_iversion() rescan path.
But the rescan doesn't reset ctx->pos to a safe value. It walks forward:

i +=3D ext4_rec_len_from_disk(de->rec_len, extra_size);

i.e. it advances i by the rec_len field of each inline dirent, which is
attacker-controlled, and the only per-entry check is the "non-zero rec_len"
probe (which itself reads de->rec_len). It then commits "offset =3D i;
ctx->pos =3D offset;". So the rescan can legitimately land ctx->pos at a
position whose dirent header already lies past inline_size - it is not
clamped to a valid in-bounds entry.

The main loop then forms de =3D dir_buf + ctx->pos - extra_offset and calls
ext4_check_dir_entry(), which dereferences de->rec_len before the length
check fires. With v3 (which only fixed the rescan probe and the size
argument, but had no bounds check on the committed ctx->pos), this still
reads past the buffer:

BUG: KASAN: slab-out-of-bounds in __ext4_check_dir_entry
Read of size 2 at addr ... (0 bytes to the right of a 60-byte
kmalloc-64 region)
__ext4_check_dir_entry
ext4_read_inline_dir
iterate_dir

You were right about one thing: the lower-bound (ctx->pos < extra_offset,
"de before dir_buf") case I once guarded against can't happen, since
ctx->pos never comes in below the dotdot offsets. v4 drops that and keeps
only the upper-bound check in the main loop, which I've confirmed stops the
reproducer. Sorry for sending a patch I hadn't fully verified.

v4 to follow.

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
