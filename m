Received: from mail-pl1-f174.google.com (mail-pl1-f174.google.com [209.85.214.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7511239023B
	for <linux-ext4@vger.kernel.org>; Mon, 15 Jun 2026 19:06:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.214.174
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781550390; cv=pass; b=AY/mI5ZufDP4l7+iTaL4vHWAMWq3bMb6lvRmGpiJeEUnIzFMI0NfKgh33k9JNW6HgO24nM/9tLd/rK2sOAloE+5ZnclFHJvt1WAqEfp8/pn1fJyGvIoT/zH6bywDl8sjCtFWVxELkbZz7s8rURWp1YDiQqX9kxkqDO609ar53jU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781550390; c=relaxed/simple;
	bh=tcBJ0XNB/Psn1HRgXOzLL5bqr1505GvuF+VjUV9ZTRY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=gSxcdN5VF95QH8cgiMRDGIoWauQXmwd+Ca02IvRjoiWESxSVTKvw/qJede5sT1Ai5M/bBqQI3q+Ci27L9InE1jxhSAESclMPVooI9YWt1dciX+gytm/q360EqhP+0QXYSj+VZ0MN98l9XeG83+Q7cDKvQnHq3glN8zjYW2KP2rI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=asu.edu; spf=pass smtp.mailfrom=asu.edu; dkim=pass (2048-bit key) header.d=asu.edu header.i=@asu.edu header.b=T8RxK4C7; arc=pass smtp.client-ip=209.85.214.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=asu.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=asu.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=asu.edu header.i=@asu.edu header.b="T8RxK4C7"
Received: by mail-pl1-f174.google.com with SMTP id d9443c01a7336-2c0c2a68d01so23966285ad.1
        for <linux-ext4@vger.kernel.org>; Mon, 15 Jun 2026 12:06:28 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1781550388; cv=none;
        d=google.com; s=arc-20240605;
        b=jOzU90SRSOTLxmS09ukD2NBfgP1WP+eLhm6naBdy6MnoHjUv3X2U75rBjSTSInh+4L
         MYJ5f2La1NkZNzUqNqnMxhYBJ79uqqKg5Jps0MpbOAOyirwRpg1B9cqc8+RsjY8BHCE/
         fLq7ky+R21Of08qo65ie1vdRWSh7eXFZU5E0r1Xjymmh9qShTD9yc/ix6+fjy0dMtWS/
         JcgfuIjwyNDkQbyyrpMBQaKfpqDkI3JptWpSd6Zh/5Alwljqf0YUopDdDaif1hJlKXJA
         UXxWMo0MCEOqzqNFU5T56Uw1hM6JVt8MneUakf22G0SHP0efeLywqohYFZGiBOL04Db/
         RFGg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=QimIPQfqa+wg2knBPNT03+2CPILn8vPIBgDWIEUXl40=;
        fh=/KsSh7Bbq0s8IsxyG9YUv+ObyE7ksXPKe14g2XxDU6M=;
        b=KCc6ck2Df650tvA/qzQZsk/pPRP+VExaW3ObdHmFmTe4AC3M5Fin/HFs4D/imKYXE3
         RyOQJMv8YBZtY2yaPd8kFBw/kd4Yh3JMrbHKfzmTJamfq2oo96/WRxIGNV2zBtY7BrLB
         ekxteSn9mU3CmtinCgH62eNsd9Z14TrM7HuxDlKXLFWag5jYPZpnVH9ITrYF+Mz8I50X
         jFh2KZooGZtLPUS4ENhJzmzBgDTR0r0EapfgbbUsOVOErKHG8jqvN9YSz10mewW6BWYA
         5MsJMfk5v4Q4cNjDC/rBP7cZkr2cyQVtHMtr3IK6zY7nqpnOBaeeCEEMFnTDjfEnyQdy
         pLFw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=asu.edu; s=google; t=1781550388; x=1782155188; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=QimIPQfqa+wg2knBPNT03+2CPILn8vPIBgDWIEUXl40=;
        b=T8RxK4C747QOEI9pHIhC9a446lwTvvbbDtIT3ON04+RByOYAUb/HkCdDxtOM2nn1ZF
         8FRa+xw7IZ0TJcCWX3LTCch2y92GI+B4va6U38k77YmjzCnOs0bjfgTz4DKOOdYP45Un
         AfsEQOIb2n4HjH9iHUZ+oY5TUC1EPj+X9rQhW9N0ihdoF74CL+YmqD6TFuImqFX/kzP+
         sRViiR9qmolwJxA8f4MXFrAaoozLejNZazBPTtqGl65ruwIela4vpt2a22VW0dQS1q8U
         icH/CDsu+LG/t2DKMmSuZL0+++zKrRlDPnu6w0fbC/zoG0z1IHsA7M3OA2/T8ks2MSl8
         DOtw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781550388; x=1782155188;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=QimIPQfqa+wg2knBPNT03+2CPILn8vPIBgDWIEUXl40=;
        b=rMY8ciuSreQ3dpF86LhHJPOk0FXb1v48dfaxQlAc4L9xvngWK9s49pO5jVQ9hTEQlD
         WyMgNBWrG67EqWuMnOWH19vDN20JdC5eIu7OuiGhlC4JLi5TwWvttWzOD+yvbu6NINxx
         Rgp9X1JyAI0ZOs+PdO19ZZMcDF63TuRBVFK+qoHejje2PtXeDg42LLqUTkPjvdgbdqea
         cmjDoqdZdmY8UYkcDcyqvd2jF3BCfD9GNR0zLTpMGTSjf6/EQoVAUxDg8BbacgnY6eh1
         1mYRV5u93dt6uQcVk7kxntdNKptPh/iPwXX9V5MgvZO3XkC+W1kNFwWSMPp5N5137Zvg
         ILEg==
X-Gm-Message-State: AOJu0Ywdaf2A6HCmbKfWk+By8cCxBnHGVHbds8SejmH3wx6ZDZS1hjNp
	TMoxrXZkPQ1yCRw4oQ1EMpijmaati4PcBwDEllVnNstaxVF3bEWcMHWmEXonhTidMTIijlsPnSW
	v/Xc8bTKO2rTUdlyYkPXGUyqg/b87XGW2zKa40qDF
X-Gm-Gg: Acq92OEIbqtDBRaRqLT/McKBV9mUrljlZBVX31/wFplUTQVRmRtwxGTZ0goPnwFI9ab
	QnWmIo1qcRc2joBv7uQrhzFVt2dTNmXfLq4TnQXlDQbfdOnPxDpbFYDxB0XplaBX45bEDWOKUNu
	nwVNW0195CovAOxTHMuHrOu9ZqDh7MYCYlYeXD5azTtX5Im1wUzByKkiv1061omJqfEcxdYNqcu
	HLZdCJsDY7tAIFxZqCaXPgPkDm6SmcS/+cBNdcId3IpyozzhOHYQcAnOnAvWzaVXqDHrN0X5NkJ
	v4SVQp/QOsup6kJSD2f+oDdozpMfYcqPRRfzOQpe5NdCtagY1FS8
X-Received: by 2002:a17:902:e548:b0:2c2:75c4:4b0f with SMTP id
 d9443c01a7336-2c69a0dbcd9mr5143365ad.2.1781550387802; Mon, 15 Jun 2026
 12:06:27 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260613221836.556019-1-xmei5@asu.edu> <cohsy6t4qa7pxub7knepgd6nckybqx2xt7ps33zh7fwkx6p3ac@dswnh7vxc572>
In-Reply-To: <cohsy6t4qa7pxub7knepgd6nckybqx2xt7ps33zh7fwkx6p3ac@dswnh7vxc572>
From: Xiang Mei <xmei5@asu.edu>
Date: Mon, 15 Jun 2026 12:06:15 -0700
X-Gm-Features: AVVi8Ceu-75xOawXzjGZNy3GVq7AoHN_JjvPnc8K_FJcylKoPo33yrDGfFSJHcU
Message-ID: <CAPpSM+Tjf0t++xGvoXM6mZvXha7eB_3o8anRFWf8_sErjQUSaQ@mail.gmail.com>
Subject: Re: [PATCH ext4 v3] ext4: fix out-of-bounds read in ext4_read_inline_dir()
To: Jan Kara <jack@suse.cz>
Cc: linux-ext4@vger.kernel.org, "Theodore Ts'o" <tytso@mit.edu>, 
	Andreas Dilger <adilger.kernel@dilger.ca>, Baokun Li <libaokun@linux.alibaba.com>, 
	Ojaswin Mujoo <ojaswin@linux.ibm.com>, Ritesh Harjani <ritesh.list@gmail.com>, 
	Zhang Yi <yi.zhang@huawei.com>, Weiming Shi <bestswngs@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Jun 15, 2026 at 2:27=E2=80=AFAM Jan Kara <jack@suse.cz> wrote:
>
> On Sat 13-06-26 15:18:36, Xiang Mei wrote:
> > ext4_read_inline_dir() can read a dirent header past the end of its inl=
ine
> > buffer, triggering a slab-out-of-bounds read during getdents64():
> >
> >   BUG: KASAN: slab-out-of-bounds in __ext4_check_dir_entry
> >   Read of size 2 at addr ffff88800f3dd23c by task exploit/148
> >    ...
> >    __ext4_check_dir_entry
> >    ext4_read_inline_dir
> >    iterate_dir
> >
> > The dirent payload lives in a buffer of exactly inline_size bytes:
> >
> >       dir_buf =3D kmalloc(inline_size, GFP_NOFS);
> >
> > but iteration runs in a position space extra_offset bytes larger
> > (extra_size =3D extra_offset + inline_size) so the synthetic "." and ".=
."
> > land at their block-dir offsets. A dirent is formed at "dir_buf + pos -
> > extra_offset", yet the loop bound (ctx->pos < extra_size) and the
> > ext4_check_dir_entry() length argument both use the larger extra_size. =
A
> > ctx->pos that is valid in extra_size space but whose de lies past
> > inline_size is therefore accepted, and the rescan loop's rec_len probe
> > and ext4_check_dir_entry() dereference de->rec_len before the entry is
> > rejected.
> >
> > Bound the dirent header by inline_size in both loops: break out of the
> > rescan loop once a minimum-size header no longer fits, reject such a
> > position in the main loop before forming de, and pass inline_size rathe=
r
> > than extra_size to ext4_check_dir_entry().
> >
> > Fixes: c4d8b0235aa9 ("ext4: fix readdir error in case inline_data+^dir_=
index.")
> > Reported-by: Weiming Shi <bestswngs@gmail.com>
> > Assisted-by: Claude:claude-opus-4-8
> > Signed-off-by: Xiang Mei <xmei5@asu.edu>
>
> Looks mostly good, just one simplification suggestion below:
>
> > diff --git a/fs/ext4/inline.c b/fs/ext4/inline.c
> > index 8045e4ff270c..1266c8827cca 100644
> > --- a/fs/ext4/inline.c
> > +++ b/fs/ext4/inline.c
> > @@ -1454,6 +1454,9 @@ int ext4_read_inline_dir(struct file *file,
> >                       /* for other entry, the real offset in
> >                        * the buf has to be tuned accordingly.
> >                        */
> > +                     if (i - extra_offset + ext4_dir_rec_len(1, NULL) =
>
> > +                         inline_size)
> > +                             break;
>
> Since 'i' lives in "dir logical offset space", it might be simpler to che=
ck
> this as:
>                         if (i + ext4_dir_rec_len(1, NULL) > extra_size)
>
>
> >                       de =3D (struct ext4_dir_entry_2 *)
> >                               (dir_buf + i - extra_offset);
> >                       /* It's too expensive to do a full
> > @@ -1488,10 +1491,18 @@ int ext4_read_inline_dir(struct file *file,
> >                       continue;
> >               }
> >
> > +             /*
> > +              * de lives at dir_buf + ctx->pos - extra_offset, within =
the
> > +              * kmalloc(inline_size) buffer.  Make sure its header fit=
s before
> > +              * ext4_check_dir_entry() dereferences de->rec_len.
> > +              */
> > +             if (ctx->pos - extra_offset + ext4_dir_rec_len(1, NULL) >
> > +                 inline_size)
>
> Similarly here this could be checked as:
>
>                 if (ctx->pos + ext4_dir_rec_len(1, NULL) > extra_size)
>
> which is both more consistent with the loop termination condition and sav=
es
> the conversion from logical offset to physical offset.
>
> Otherwise the patch looks good.
Thanks so much for the tips and your review. V4 has been sent.

Xiang
>
>                                                                 Honza
>
> > +                     goto out;
> >               de =3D (struct ext4_dir_entry_2 *)
> >                       (dir_buf + ctx->pos - extra_offset);
> >               if (ext4_check_dir_entry(inode, file, de, iloc.bh, dir_bu=
f,
> > -                                      extra_size, ctx->pos))
> > +                                      inline_size, ctx->pos))
> >                       goto out;
> >               if (le32_to_cpu(de->inode)) {
> >                       if (!dir_emit(ctx, de->name, de->name_len,
> > --
> > 2.43.0
> >
> --
> Jan Kara <jack@suse.com>
> SUSE Labs, CR
