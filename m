Received: from mail-wr1-f51.google.com (mail-wr1-f51.google.com [209.85.221.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C825435E930
	for <linux-ext4@vger.kernel.org>; Fri, 24 Jul 2026 21:40:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.221.51
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784929205; cv=pass; b=cS8H+YOb3KCHvbpUK1n8KlYfqNLOW3tW/yjL6KW+S1oS0ryOfd+3VOpCekQ6SfiOSen8FT8zEIpHiXKZJFCI613Ec/ry5YhD/PzDeeMxW4GyrmElfkiTbalzOx5VqhiltKvimrrCQfXnphdMCx1BtBgWaiHv5KRpyzjot8NcOfc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784929205; c=relaxed/simple;
	bh=VjT8h0C0MEwc6Wql1bkZPcWk5J5Ghn5YmfhJSDEhSWk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=g1mtmLmZLKa1U3du/N/tc1eHGOzDWL8xJSc2LlvysZOjja3VoxkjKgBFC4SgYHXiVIeAZ6bRIyzKu8hfRbQK3KSYUYXUugMWhhx/DK2IZK+MrKmzD6UX7LTX8rJ7cpwClr2UPHUxJfA0YVAqgjPVPWQXX4BnCD9gjz+G8ahpa4M=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=FpXg/nwp; arc=pass smtp.client-ip=209.85.221.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="FpXg/nwp"
Received: by mail-wr1-f51.google.com with SMTP id ffacd0b85a97d-47ddf7b09e5so885765f8f.1
        for <linux-ext4@vger.kernel.org>; Fri, 24 Jul 2026 14:40:03 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1784929202; cv=none;
        d=google.com; s=arc-20260327;
        b=ECgdQz3rcQUny17bB3o5JGZgSnW1CpMblucfi6ehDB9zdv14N+EeOZmri8pI1nKYO8
         AP4cev/YRVUb5PNW8TOPE9hLHl5pd8veN7g5X+69MnTRFEojrMtmZYqJwQ6QX3kALDVU
         L1hc2Uxb0MLJGY0jocDDjSkU6pY9sFSTML2iL+BYtK9rzPUOB7PtRFGR5PedRRzXoIFn
         AuHkxxOSkcZXHTbAOd5DfmtYHovwW70AlYdgEt6NFV1D6JztD6v76ByoM4YVHshC+m0U
         S3tAz+w6MZvUCCmFMdQti813JPiBvg5h0eyMIKS+AJta+urCyyyrYifqQFUHZSGdjSqy
         K9kw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=RAB/Z210MZmDSDWCyj7qmtTg5HLMGjGEKXw1Q9kkiO8=;
        fh=SCWnNJyKJjT2HgTLjXwQxrnAf0j/fkpWnON8Xh4F/4A=;
        b=hMw+1cT5mKeLKXKhIo3TtjxoxFBwdBPcaxqcJgA7cmPdA3HtSD63+uB3QXFKgrrokc
         DUq+yXkT+au3rQg6x9xAlMUClBBOEk1BNiqx+E9erKphgNtlNXqnlhTJBZKtLXnlWIXK
         CzMSp6t8PhGCINuss8eqEk10s1NqxUBmuNFoAblhv9tVeUjK0rkfuzgahO53Bk/g9Knk
         VGdvrjdIVFK5twoW3iV5ZrAQpwP0jIIEp+HWGG2VVKdIZeiNhpqPrmPX6tKppTnW8yVP
         ZoL1r5z7PIc3cJUcEDp86gZXZ90dR3ALHSmXznQNCuVcx/QepxNFsxTUKO1P/BSCdhHU
         Lkqw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1784929202; x=1785534002; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=RAB/Z210MZmDSDWCyj7qmtTg5HLMGjGEKXw1Q9kkiO8=;
        b=FpXg/nwpsEcnbDYbNgtN7hYZ6HKC4pBocBkVRX4UzMBx5Xw/cMmkNmElLYus4cYjYa
         MHXhm3XlJWlhuaTY2rxo+qcJ8u4K8LzLZtp2NFLA0hLTA3HjHQwoWmIYi5NYVir8Q2g3
         fw2aTZuEG2YRBN+wVKCIsfd2R4spseU9bbLRvEb67YkWmqP33NZjQ+VkUfbTJ1YgkLfL
         NOGGbwo5ibKfVgYQW/yiGUieTeBFXCODdKuin1ShfXKaIl4ScBxvjhLGZZTznW06QIEB
         PjQculeb3KJm0VN3x2P36zezi/PQZiSzyhuklQrENOaHL+MdtBUfvKxIxPlPevPsGyRe
         XHOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784929202; x=1785534002;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=RAB/Z210MZmDSDWCyj7qmtTg5HLMGjGEKXw1Q9kkiO8=;
        b=nIBBhnTjLY5xMg+h5MbQKu5yRpjavGfqidvKacDW5j+MTDs/KNU7fmHhMkEiBcpFy3
         OKbpvDcCkF5j8VfOs03ovkLg3uW644TZufIJLtJAfM/Ad18nm+w3uUyY3rdCtHOSuc9m
         iPREbGVrO0VbiA5EsyBnfajJOa+jtz84D/zq+KuIlnUfeGdFNiNCgB1wgIJeodku8/td
         6+776k2LWenOvrSw8XtYI82Y8MBjhqkc+4ggRX6EqDE59+6eKWS5V6IHCcsvz1BE6Ll7
         eZjCSMq49SyqD1hbY7RwvRUzkN+0VJimgzl5bCFQ4o/P0V4Oh4RXwHsWQPG0NaobfTKl
         BQIA==
X-Forwarded-Encrypted: i=1; AHgh+RqfY2cw/INWSOXO5bd+XGRdOvYIEjiE2cBSI1Q7saB8uK6yL/dnVt+Yc8qVPdqI7ynSp9ftqtbTA4Wa@vger.kernel.org
X-Gm-Message-State: AOJu0Ywr6mBDwvmQe4/Kq0r0fGXi9wZpbpAwrryux35YHaNO0jH+K9HV
	V8djaPKmog/tGQgdb4y86LwsjqnGy6GTQHRg5ck1NIYiq+a2p1koEYjBYD8/K9IgPH3Czg3nmGs
	xqvHHeOyGhpvfF1CASCi70QI9LkhIJVJ4UJan
X-Gm-Gg: AR+sD12+zjt4oz9Pum6axz3vpeb3vQ3oS2yngDr4/4ZQq/oXkRnTslagYwOik8IldOh
	oC641nMbXJq3BCsSsbbByJ495I1rC0xO2TuMjFK5WzVcmSihyDJU9VTjYt0POFzvu80/DJsFKrb
	Fc6sBmt8aiJHQ+myGQi6dlrhgZbsYloEUkrsyooZoMRgkSIENvYx2e47Y0brmu+NbB1vm4yvwph
	tLdyUbaWXT+kSm/H7j9opPAcULJ7MeYSqdCeNmZjaJagSkGAN1U8UemGCT3Ef9+Bo6vwH3ptOSe
	SlHUJLj8NOnf7n6PN4dDFsfSG5+K5jlVUhFtJrsX/Q==
X-Received: by 2002:a05:6000:27ce:b0:47f:928e:21f7 with SMTP id
 ffacd0b85a97d-47f928e23f7mr6329327f8f.55.1784929202068; Fri, 24 Jul 2026
 14:40:02 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260723050201.3381045-1-hch@lst.de> <20260723050201.3381045-3-hch@lst.de>
 <20260723164722.GF7380@frogsfrogsfrogs>
In-Reply-To: <20260723164722.GF7380@frogsfrogsfrogs>
From: Joanne Koong <joannelkoong@gmail.com>
Date: Fri, 24 Jul 2026 14:39:49 -0700
X-Gm-Features: AUfX_mynOUqF9g7tlIXhMduTjnHTQ0m_VqSSHi-dOSMHoEm_AgBHSxiCdTlP2Is
Message-ID: <CAJnrk1Z9wxXf+=d-+5VMcCiDiy4Q7UsBGvzwaPQtAok6avjKPw@mail.gmail.com>
Subject: Re: [PATCH 2/3] iomap: decouple simple direct I/O reads from iomap_dio_rw
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, changfengnan@bytedance.com, 
	Christian Brauner <brauner@kernel.org>, "Theodore Ts'o" <tytso@mit.edu>, Carlos Maiolino <cem@kernel.org>, 
	linux-ext4@vger.kernel.org, linux-xfs@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Jul 23, 2026 at 9:47=E2=80=AFAM Darrick J. Wong <djwong@kernel.org>=
 wrote:
>
> On Thu, Jul 23, 2026 at 07:01:40AM +0200, Christoph Hellwig wrote:
> > The pending iomap_iter_next conversion creates performance issues for t=
he
> > new simple direct I/O read fast path, because it assumes a model where
> > the iterator must be advanced at the end, which the direct I/O read fas=
t
> > path tries to avoid.
> >
> > Side step this by splitting the simple path from iomap_dio_rw, and
> > require the file systems to call into it explicitly, and pass only a
> > ->begin callback.  This allows to drop various checks for incompatible
> > features while creating a requirement for the file system to only call
> > the simple path for cases that it can handle.
> >
> > As a side-benefit we can now inline the initial part of the simple
> > direct I/O read fast path and let the compiler convert the indirect cal=
l
> > to ->begin into a direct call.
> >
> > Signed-off-by: Christoph Hellwig <hch@lst.de>
> > ---
> >  fs/ext4/ext4.h        |   3 +
> >  fs/ext4/file.c        |   4 +-
> >  fs/ext4/inode.c       |   2 +-
> >  fs/iomap/direct-io.c  | 208 ++++++++++--------------------------------
> >  fs/xfs/xfs_file.c     |  14 +--
> >  fs/xfs/xfs_iomap.c    |   2 +-
> >  fs/xfs/xfs_iomap.h    |   4 +
> >  include/linux/iomap.h |  66 ++++++++++++++
> >  8 files changed, 136 insertions(+), 167 deletions(-)
> >
> > diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
> > index b37c136ea3ab..e134c0193e2b 100644
> > --- a/fs/ext4/ext4.h
> > +++ b/fs/ext4/ext4.h
> > @@ -4007,6 +4007,9 @@ static inline void ext4_clear_io_unwritten_flag(e=
xt4_io_end_t *io_end)
> >  extern const struct iomap_ops ext4_iomap_ops;
> >  extern const struct iomap_ops ext4_iomap_report_ops;
> >
> > +int ext4_iomap_begin(struct inode *inode, loff_t offset, loff_t length=
,
> > +             unsigned flags, struct iomap *iomap, struct iomap *srcmap=
);
> > +
> >  static inline int ext4_buffer_uptodate(struct buffer_head *bh)
> >  {
> >       /*
> > diff --git a/fs/ext4/file.c b/fs/ext4/file.c
> > index eb1a323962b1..f20d92255546 100644
> > --- a/fs/ext4/file.c
> > +++ b/fs/ext4/file.c
> > @@ -91,7 +91,9 @@ static ssize_t ext4_dio_read_iter(struct kiocb *iocb,=
 struct iov_iter *to)
> >               return generic_file_read_iter(iocb, to);
> >       }
> >
> > -     ret =3D iomap_dio_rw(iocb, to, &ext4_iomap_ops, NULL, 0, NULL, 0)=
;
> > +     ret =3D iomap_dio_read_simple(iocb, to, ext4_iomap_begin);
>
> I was kinda wondering if you can pass ext4_iomap_ops.iomap_begin here
> to avoid the declaration in ext4.h?

I think it ends up being a bit cleaner to do it here, otherwise the
subsequent ext4 patch that replaces .iomap_begin()/.iomap_end() with
.iomap_next() will have to do it.

Thanks,
Joanne
