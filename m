Received: from mail-ed1-f43.google.com (mail-ed1-f43.google.com [209.85.208.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C5533932F7
	for <linux-ext4@vger.kernel.org>; Tue,  4 Aug 2026 23:06:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.208.43
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785884822; cv=pass; b=JmJSU+xDp2jgXzw651nk9H/suVfub7jQUrd9ehnliX1ksS9kuQ5/Hd69G3u6/REZfilrMImF4bqQBUUP4L+Kd3fU1SNcYbyY9+gbFV7VBcAaCTLMzXbf8sq7KKrXMR9zfKl8wv/YxroUwNqaBXkux3OZMjNRvYpBK92vlO7nXs8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785884822; c=relaxed/simple;
	bh=PMpFo1HfD8khbAAlxqkyKZRs/E05UT5D9hNFmyw/iB0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=lVjnotJqvLjjkSDUNYfVtYifv7p8rB8zqlmvXu8accXFUF9fl1dHT5ofzxuebjnWiv0siuf2pphdflFL4MD6F0Gi3R6onc88SZhakqETI1J3Hh+T747jOtH8CsLio2dy4JqR7USibaNPPGXMp/qLazyLKDt7IWCRMVqRzdV8hY4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=bgsdM3GM; arc=pass smtp.client-ip=209.85.208.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="bgsdM3GM"
Received: by mail-ed1-f43.google.com with SMTP id 4fb4d7f45d1cf-6a097f5ab95so453951a12.2
        for <linux-ext4@vger.kernel.org>; Tue, 04 Aug 2026 16:06:59 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1785884818; cv=none;
        d=google.com; s=arc-20260327;
        b=pBtfPfK7SfneU42fE8APwoe2esEnedNHwPD5dZETrlykm9x4pWhiSmVmj+2Xc/R+7A
         XpBcIgBy0KOHUMFuEReI1xt8DESAvfjlz9udMSTBAoRa6RMk5HLCp3l0ZBizYMyJin7g
         a95FWA8FfRcBFeO74K4blmZNznSFdk9Og0y/2ivPHOahXUDC/Iv6Hc+WZiDifNyujpxG
         GE9TViBa6wUoAbxh675o7JjjuKo3I992XWHHYvoP/UTw5jKJN06RyKWQfRKH7SETNxAO
         dLUjIE7hzbPdeEf8vyIcXjTDYZXa4wwqi6Ha4nYz/fZNjPDnX9Fvc0qSeDyHtKp2zJqM
         fnGw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=qtp00HQe0YEhUVbmZKFkfm9h9fZb8SFvoPIno10cSVE=;
        fh=KnxuuYA9bfD5+DzKzKCfV/COsnaUQQQtJYg6kRDGt4g=;
        b=caoKhRtxIGRGVniNvP5QOJMQDj8/F94XIvxs4YZK8urM9z1O8oaV6V94wZ3GXibYg9
         kHNmHlAifZG/EOV2Nc3MoaBpFpoVNoXPoxuCiqG+Z1hkbEHg9RC83njUj8moYUQQbRBZ
         1VAxFw7VqGPvaDsegHGLZsi3+CLSXElVFdWHMLiDMuq2d4xwfN1VV1zJnWQg9IPfa42T
         puREp2V1vi9i5mz5WVhlKihbEyo5VRXPTOSe9kI6hkYCwzvS+rBSzPLcgaawbJnAgLnG
         VihfgOqz6lZ5Qsamw8ggkGsInPZPQQqoHuXcwvGqJzFa2CCdK9JTEJVsxEgim9tAN8/d
         MNSA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785884818; x=1786489618; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=qtp00HQe0YEhUVbmZKFkfm9h9fZb8SFvoPIno10cSVE=;
        b=bgsdM3GMiSGtBU4Ypwu3zN7bfu1Xk/8XJTNa6uKanVZQoX6L673+BAlnbPjqUc5fDK
         aNEIS3uKF7QDmhG3w+58+Ly5MEeo4MACPSTvvd93nQ4Z17T8cckMJR1MAr9CCgkhDW9L
         y/DsmJ/2cQWDEOTwKSnCW4LSNA6nnR3yOdXERkpd0Uj0g7RgdlSodPcBLAHiPHzr8RXw
         wQ+jyRZvUXOY7+79owb4Z0pogF4XD5OYl1xDr6GlAjIar9cOFlXFaGOGPwsoueWke5q/
         PFkA2bBtxabjL3I/tyxoNe9n/PgmvF46kB/IrabulS69Lf395CNkeJtwFjP/eDpHnUZ8
         7M2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785884818; x=1786489618;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=qtp00HQe0YEhUVbmZKFkfm9h9fZb8SFvoPIno10cSVE=;
        b=YkLliQ6yRqjdTDBBecp/3pBpisN3UcHDjEf5sj7ctETX5DPHu2T400Pt9mcXxmjHnR
         vvEliIt01RN/ksc7GqTWBU16B/aL8AzvxrsaF48em1OsiC//pp+sZuVYuQT8dMsdHn2u
         MATjTl3d0yMjklJkBvo5LFXQcjPn8O7tv4D5y4T1k1EhabUBflUYg1hJEO+bHYRdi5g0
         ITvOuXdALKF5TzSKxuf47IVn/yRnOBqgzfqzG6QPBxzWTmSVi1NlCTLD1UnX6GnqsTZY
         rHU7y8FKYAa5CzxnaEMS/fLYTkZgXyofs7R6XuTNH1wuNUZCzXqRqhDedFPuoyhx+IJD
         GmyQ==
X-Forwarded-Encrypted: i=1; AHgh+RrztOhIscYaFHAw3XDXHACjlPfoYimi+SH3M305KQJwHPld6E292ebDk+oLD7N/LFWV6efNktKqe7EZ@vger.kernel.org
X-Gm-Message-State: AOJu0YwYB1lni35YnOo6wkI3Su56azrH5kaKt9CWtv0KUpOyKiCL+sjR
	cUAJp1xhBBKbELtIAdeVAabAT87Q6eWcMIq+mGWqBIOfLCOQxPqxo7aIvAKTBFPwLltaiNbMkW/
	fCrEruXos78UWgUZCydmsBMnGolr3ukc=
X-Gm-Gg: AR+sD13KmX0scNxZMVGI4YQFrDKXUOVhhVRJsC+MgBPi1q7+5g7TH37TKHQVQbO0x0K
	dMi025xoizpG+3QHLPZrUqk49rNsj+nJXYht7jTKlIrfTP6ajyGKVckkzdL4rdKiMU6B2BLWQfT
	JECoSxNKNaYlDRzxmBzXv3OYstbeBhK2sj6ldbtlLqSU4JFNDAHvEIeNbjBCXIhD8yx6xpgZP8s
	vsw/ZfhhRl/7fxAN2hRvHeMw7rBWwo//pol3jGIenIKwi/xyh9AXneQTJTH3YfmXbZmi4M6M+iU
	sqqey4brpARCuzbuq2DU7B5v0wybLwiN1z9ovHj4ZLCFnGNBpudVep4=
X-Received: by 2002:a05:6402:5023:b0:699:12e8:1c54 with SMTP id
 4fb4d7f45d1cf-6a14f103f88mr1267020a12.5.1785884818029; Tue, 04 Aug 2026
 16:06:58 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <cover.1785621505.git.coshi036@gmail.com> <41c6fee66724e374d4682124a1eb80041e22efb9.1785621505.git.coshi036@gmail.com>
 <z5jfe6bsxhgqqgjtxcm7ass2fslc4ynizvpmzlqxtr6rrfaopu@fxzntlxafmxj>
 <anDW5UTbF2d0EQmr@casper.infradead.org> <74ts4lwsq73mce3rvc7imisot436742ykzahnogysnbklot45b@q3nhfq55knx3>
 <anHyBATDe8yQEFNi@casper.infradead.org>
In-Reply-To: <anHyBATDe8yQEFNi@casper.infradead.org>
From: Chris S <coshi036@gmail.com>
Date: Tue, 4 Aug 2026 19:06:46 -0400
X-Gm-Features: AUfX_mywycbzfMLtI3iRX8QYjwuoGt1JUOb_Y0mmTpKfptijtN3o82-3luOQJN0
Message-ID: <CACd_6n0zcg85_p=+dcVK__SECdom8K01BBsdzakuwJ1ibMhKJQ@mail.gmail.com>
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

Agreed, and done - but not in this patch, which is worth flagging because i=
t
is not obvious.

folio_mapping() is doing two jobs here.  The one you are objecting to is th=
e
swap cache mapping.  The other is that it returns NULL for a slab folio, an=
d
that is the only reason this path is safe for jbd2's shadow buffers today -
they are the slab-backed buffers this series is getting rid of, and they do
reach buffer_set_crypto_ctx() through __bh_submit().

So doing it in this patch would leave one commit where shadow buffers still
sit on slab folios, and this code reads folio->mapping directly, i.e., hand=
s
fscrypt a struct kmem_cache and dereferences ->host on it.  Fine at the end
of the series, broken in the middle of it.

v2 does it as its own patch 4, after the jbd2 change.

Chao

On Tue, Aug 4, 2026 at 10:07=E2=80=AFAM Matthew Wilcox <willy@infradead.org=
> wrote:
>
> On Tue, Aug 04, 2026 at 10:07:39AM +0200, Jan Kara wrote:
> > > Yes, agreed.  I think it's fine to add in some 'if (!bh->b_folio)'
> > > tests, but only where they're needed for the occasional consumer.  Th=
is
> > > really is a rare (but legitimate) case.
> >
> > Yes. If we were to write this code from scratch, I'd rather push for
> > forming and submitting the bio directly instead of trying to bend the b=
h
> > layer for these temporary bhs. Eventually we might want to do this clea=
nup
> > anyway (since bhs don't really buy us much in this path) but not in thi=
s
> > patch set.
>
> I think that would be better, but it is out of scope.
>
> > > > >  static void buffer_set_crypto_ctx(struct bio *bio, const struct =
buffer_head *bh,
> > > > >                                   gfp_t gfp_mask)
> > > > >  {
> > > > > -       const struct address_space *mapping =3D folio_mapping(bh-=
>b_folio);
> > > > > +       const struct address_space *mapping;
> > > > >
> > > > >         /*
> > > > >          * The ext4 journal (jbd2) can submit a buffer_head it di=
rectly created
> > > > > -        * for a non-pagecache page.  fscrypt doesn't care about =
these.
> > > > > +        * for memory that is not in the page cache at all.  fscr=
ypt doesn't
> > > > > +        * care about these.
> > > > >          */
> > > > > +       if (!bh->b_folio)
> > > > > +               return;
> > > > > +       mapping =3D folio_mapping(bh->b_folio);
> > > > >         if (!mapping)
> > > > >                 return;
> > >
> > > Do we want to call folio_mapping() here?  The only case where I can s=
ee
> > > this being useful is if we attach a buffer_head to an anonymous folio=
,
> > > and I don't see a good reason to do that.  I think this can just be
> > >
> > >     mapping =3D bh->b_folio->mapping;
> >
> > For all I know yes, bh->b_folio->mapping should be enough here. But I
> > thought folio_mapping() is kind of preferred to open-coding?
>
> It rather depends on the path we're talking about.  Looking at the
> implementation of folio_mapping(), it's actually mildly dangerous
> to call folio_mapping() in this path.  If we were ever to point a
> buffer_head at some memory on a page in swap cache, we'd get a pointer
> to a swap_address_space.  I think we'd safely crash in that case because
> mapping->host would be NULL, but in other contexts doing things to a
> swap mapping would be quite bad.
>
> So I think this should just be folio->mapping; don't risk getting a
> pointer to a swap mapping.
