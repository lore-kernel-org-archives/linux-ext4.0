Received: from mail-ed1-f42.google.com (mail-ed1-f42.google.com [209.85.208.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A766F3C1406
	for <linux-ext4@vger.kernel.org>; Wed,  5 Aug 2026 17:42:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.208.42
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785951736; cv=pass; b=QgAxeHDlGRKSxvSPbi1N57Q8QoSaIsbVJa0ogOLwxw07LKAvglYG6T3Jpc+6WXRwGHtqgqpHErR5r7WQ+4VXwzsPkTaYFc4MtXlr8BFIPZcP6yjFTfllu4jI8Hfg+Bv7Ge3J+tcf+jW1baHWzJjtyKzP0+Ut/61BE+I9zsWuRGE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785951736; c=relaxed/simple;
	bh=EyaYqKudXSYNb2x8/wPi+3HpDy7w6KyE/JUWlmLyn/Y=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=IVlj8Qc3ceLwElz09N1BQcTZ/1uXpo+Ibgm/YGt1GcbKXR3cm9ZN9PPZCXetHD6I11x+S4AADgJZOKOXg6jXn8ICviooXMb+8p2eDDgbdDElbGt3+gGiwU264WVYI2e+hB64oOrGMKFFdfEgv9i7lLN2In7SOVdRfzsQWsbfzMY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=SXc9tgtX; arc=pass smtp.client-ip=209.85.208.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="SXc9tgtX"
Received: by mail-ed1-f42.google.com with SMTP id 4fb4d7f45d1cf-6983d3dae7aso202853a12.0
        for <linux-ext4@vger.kernel.org>; Wed, 05 Aug 2026 10:42:14 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1785951733; cv=none;
        d=google.com; s=arc-20260327;
        b=dM5jogzwRMr4ccC2ZcZDn+WD8T118PDKI9LuGaPw4RItTaPoCzYS63wlnfKZ1VMxH1
         GvZbnt9mkab4fIS3NP3gbwLOXGS0AheLeYEny8cSzWQCguDMe/CnJeQZ4acl1YxvoaGf
         q217jQ5v97CLRr1WwPbAPz8/tFVpY6xcR2qOj6Jh+5aHpWOODzFZBTd7hr45OFGFrdl1
         AU3KGSeVFhwV45WGFs4VxESQh1P+HeG3AHUZK4oaqkt9Jq5LyZVnx/dLmIxj5Gw945A0
         B8VFxGyWNFNwJsYweKY8hVwlxQxXBy7NiFgGboGAQXvJqwr+mBUBS2HDNpN/ShcXOMVr
         jCQA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=BXreRkBEGbHPBEEBrdZNIuUhCIMHTazKQC4iCv4R03M=;
        fh=tLEgyS+mMzpjNmZymNf6at6fnLlwn0dp1386VP1v/Dg=;
        b=S1jw0dprmBNY/3PeQl3aRgS27F/Iu+aTyhiKKoxOoHulv4S6HtUL2E0VrO4XiOBFXv
         y2bRm8rNxra50A3fgcIXLzhB1tkZ+cyNIgZUM61Onucui4RcVK8zlawkGfClQ1F+pfLA
         Pr71Kr1T+ivUXJMZyb3rx2ZqV550B6pQ13V07aI5tdVdBnoH6XjBiqNA2bwPN4akQKNh
         C2A7m5+RVOXQkp56geOd/8r9PJ4jSGspLIwYDxZf/cUFFwRSaN/NFdyoRw3g7uJ4q6Fg
         mwUm6SJt3UGwbNwLfghyrTxvaVvosXk1zUzQHVzu8mbgK8FCCRM/w51h2/RYxfenH/AY
         9f7w==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785951733; x=1786556533; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=BXreRkBEGbHPBEEBrdZNIuUhCIMHTazKQC4iCv4R03M=;
        b=SXc9tgtXVCpK1JaMvtt2vVpaBgdJGznsMoO7WsenaPOgSelGPJ4xt2CAJczmCw5w0z
         alh5gHFsAWusCoq+Mh43NzwBph52EiolV1hItKyKDZXAbQtFPtzi/mHwWFzdmdVnnOrb
         nxm2S1D5A6YNjKwOxzR+j9Y683mCzxmuIlL1bxvaCnmaeXPWYBTpRAcx/NnqApTLoHLZ
         FU2VNk50Inn8iiQizSZeP8ZwwnntyB7Eutw39eVfRzebyQJbVUgax9LRK7hicsgYZ17a
         EB2soddUn8SnzD7a1HoxZzUnaPIEpEPuIevJUa/4XjMK6bjS0usAOk77aRQlAJVpJ0KT
         BPnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785951733; x=1786556533;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=BXreRkBEGbHPBEEBrdZNIuUhCIMHTazKQC4iCv4R03M=;
        b=RGwLF+s834atKpB5jnNwuH0EYkS9RJlj7mu2vQVgAmK8+0Z154TwEVRa231KCtAh07
         i5OE/wgAzOpvWEraMUkWqlaYMY+BZfFnGvlACHZotcQnLO5VbardOaCEuoDFHcCjJA3L
         pL+UNjUu6dTzLQaocDblsxOqsxB2lxqw0SglSg2urebr44jZPe5LBExJ1ws4YIH9vLqC
         rBaefoP3TZ3PqqLeDrh55RJRegooqBEXBddi4sL9flCUoJWEF9l11FKqOfIr4+zkAP6p
         U8qa+v/6WhyO1QSNWjH67Z81fWePtnpqjVKc1Jwfi9yDkK0S/ol8FSHxfc/kMeMHsIlb
         vecA==
X-Forwarded-Encrypted: i=1; AHgh+RrQKqeE8EkDw023JNWiAzx3tq3KWAyVM+0PVV74HG2JrpkpkmJ2ujqDkUtD499IEsme5OsQFwAPzsbg@vger.kernel.org
X-Gm-Message-State: AOJu0Yzh6lmRgdrJQBz12dATq3puqF0dhnI3FT31H8vPnLBEq+m3nPOR
	eHt4i+U1uhQ8MY7zXtXSPvV224k5I4fDeLv1msMETQoTMSsTzcV1NT6OOSCwy92hpp3FQYh9160
	ma8YiOm1B+GrfVxkUhnXtzEo8QkLfur8=
X-Gm-Gg: AR+sD10yxDhx2dNQlGxsaekXx4JLsF8lTxPmLJnDHL64hREYI/usBkKHyl7PSYZwnxE
	poQAuP+hqOxdsO5f5ScMB3xKQNwe0+39q/Rgi/ooPUqYkt1iyiUdm6BeaM3kQnLRmSQNYkU65/1
	C/zvvcNtu2HmCb5L7lh1ZAYXqDJ0wRvBR3Vxh9Akv6jK4nnz2GOnoVXLcHxAnOoDJ9HZzgAHILc
	FwNTwDBeTHQlKOQJr73ONEwkg6auyn88ZAELOYlxo6WOCuDJt+Bpur5uypKXSFOCD+Mbb4ebP6m
	8n6HdSp9dYuntzKDy8siNTQ6hXIqewMrCkYJoCX0PH1L
X-Received: by 2002:a05:6402:4586:b0:69f:c929:b88 with SMTP id
 4fb4d7f45d1cf-6a18f0a9fbdmr501901a12.5.1785951732581; Wed, 05 Aug 2026
 10:42:12 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <cover.1785621505.git.coshi036@gmail.com> <41c6fee66724e374d4682124a1eb80041e22efb9.1785621505.git.coshi036@gmail.com>
 <z5jfe6bsxhgqqgjtxcm7ass2fslc4ynizvpmzlqxtr6rrfaopu@fxzntlxafmxj>
 <anDW5UTbF2d0EQmr@casper.infradead.org> <74ts4lwsq73mce3rvc7imisot436742ykzahnogysnbklot45b@q3nhfq55knx3>
 <anHyBATDe8yQEFNi@casper.infradead.org> <CACd_6n0zcg85_p=+dcVK__SECdom8K01BBsdzakuwJ1ibMhKJQ@mail.gmail.com>
In-Reply-To: <CACd_6n0zcg85_p=+dcVK__SECdom8K01BBsdzakuwJ1ibMhKJQ@mail.gmail.com>
From: Chris S <coshi036@gmail.com>
Date: Wed, 5 Aug 2026 13:42:00 -0400
X-Gm-Features: AUfX_mzn0laRrr3SVV705RV57FVYpzTyUQWOE8QEtN7_m8lMA0sJaYZzNUqNq2w
Message-ID: <CACd_6n0hCFbEnJwKbMoR5qxdQoRoicKA8OE+Th6HshkL-NiKsA@mail.gmail.com>
Subject: Re: [PATCH 02/19] buffer: allow a buffer_head to point at memory
 outside the page cache
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

Correcting myself: it is not the kmem_cache pointer that lands at that
offset.  SLAB_MATCH(compound_info, slab_cache) puts slab_cache at word 1,
while ->mapping is word 3, so what a slab folio has there is slab_list.prev=
.
Not an address_space either way, so the reason for splitting the patch
stands, but I named the wrong field.

Best,
Chao

On Tue, Aug 4, 2026 at 7:06=E2=80=AFPM Chris S <coshi036@gmail.com> wrote:
>
> Agreed, and done - but not in this patch, which is worth flagging because=
 it
> is not obvious.
>
> folio_mapping() is doing two jobs here.  The one you are objecting to is =
the
> swap cache mapping.  The other is that it returns NULL for a slab folio, =
and
> that is the only reason this path is safe for jbd2's shadow buffers today=
 -
> they are the slab-backed buffers this series is getting rid of, and they =
do
> reach buffer_set_crypto_ctx() through __bh_submit().
>
> So doing it in this patch would leave one commit where shadow buffers sti=
ll
> sit on slab folios, and this code reads folio->mapping directly, i.e., ha=
nds
> fscrypt a struct kmem_cache and dereferences ->host on it.  Fine at the e=
nd
> of the series, broken in the middle of it.
>
> v2 does it as its own patch 4, after the jbd2 change.
>
> Chao
>
> On Tue, Aug 4, 2026 at 10:07=E2=80=AFAM Matthew Wilcox <willy@infradead.o=
rg> wrote:
> >
> > On Tue, Aug 04, 2026 at 10:07:39AM +0200, Jan Kara wrote:
> > > > Yes, agreed.  I think it's fine to add in some 'if (!bh->b_folio)'
> > > > tests, but only where they're needed for the occasional consumer.  =
This
> > > > really is a rare (but legitimate) case.
> > >
> > > Yes. If we were to write this code from scratch, I'd rather push for
> > > forming and submitting the bio directly instead of trying to bend the=
 bh
> > > layer for these temporary bhs. Eventually we might want to do this cl=
eanup
> > > anyway (since bhs don't really buy us much in this path) but not in t=
his
> > > patch set.
> >
> > I think that would be better, but it is out of scope.
> >
> > > > > >  static void buffer_set_crypto_ctx(struct bio *bio, const struc=
t buffer_head *bh,
> > > > > >                                   gfp_t gfp_mask)
> > > > > >  {
> > > > > > -       const struct address_space *mapping =3D folio_mapping(b=
h->b_folio);
> > > > > > +       const struct address_space *mapping;
> > > > > >
> > > > > >         /*
> > > > > >          * The ext4 journal (jbd2) can submit a buffer_head it =
directly created
> > > > > > -        * for a non-pagecache page.  fscrypt doesn't care abou=
t these.
> > > > > > +        * for memory that is not in the page cache at all.  fs=
crypt doesn't
> > > > > > +        * care about these.
> > > > > >          */
> > > > > > +       if (!bh->b_folio)
> > > > > > +               return;
> > > > > > +       mapping =3D folio_mapping(bh->b_folio);
> > > > > >         if (!mapping)
> > > > > >                 return;
> > > >
> > > > Do we want to call folio_mapping() here?  The only case where I can=
 see
> > > > this being useful is if we attach a buffer_head to an anonymous fol=
io,
> > > > and I don't see a good reason to do that.  I think this can just be
> > > >
> > > >     mapping =3D bh->b_folio->mapping;
> > >
> > > For all I know yes, bh->b_folio->mapping should be enough here. But I
> > > thought folio_mapping() is kind of preferred to open-coding?
> >
> > It rather depends on the path we're talking about.  Looking at the
> > implementation of folio_mapping(), it's actually mildly dangerous
> > to call folio_mapping() in this path.  If we were ever to point a
> > buffer_head at some memory on a page in swap cache, we'd get a pointer
> > to a swap_address_space.  I think we'd safely crash in that case becaus=
e
> > mapping->host would be NULL, but in other contexts doing things to a
> > swap mapping would be quite bad.
> >
> > So I think this should just be folio->mapping; don't risk getting a
> > pointer to a swap mapping.
