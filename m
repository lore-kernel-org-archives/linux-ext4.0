Received: from mail-ed1-f45.google.com (mail-ed1-f45.google.com [209.85.208.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 595DE3DC850
	for <linux-ext4@vger.kernel.org>; Wed,  5 Aug 2026 19:02:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.208.45
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785956571; cv=pass; b=VdR0Q3Lxx6zvFBPl4KXu1LB8Tc1RA+27G07HJRnxfCa1AU5oU17wsBp6b0cbIesKRK/sWO9Rm6V/Vk63rLubSV3yQI824ALGA4l7Lrtg9PTztXMr4FCOUXDIIr/aar84GGdH4HPf8ZR0KKgr9j56o6PNijt7Go/ktd76UWFmWw4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785956571; c=relaxed/simple;
	bh=ZkwANXvB/ZU9t3LgTT3w1mAN0VeV9gy04VEToUnWNWY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=UuDpBCybpEFkMUTRzReQS1Rh3U9SgoLXWQL6MPWeW5MtsdeufXdlw8kA858Et8mGb2EjR3tQ0WyTf2Thx4TmjMg2HjrdH0Ah9Z5vf4d7d3NxyMDAVwJ0okN8DXNo3yfvc/SqhXV5RHE1OGs3E0EHKiu227fEoX+kfc+mV2vNdAY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=cy4Ag8wv; arc=pass smtp.client-ip=209.85.208.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="cy4Ag8wv"
Received: by mail-ed1-f45.google.com with SMTP id 4fb4d7f45d1cf-6a17cb94b26so1453197a12.3
        for <linux-ext4@vger.kernel.org>; Wed, 05 Aug 2026 12:02:42 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1785956559; cv=none;
        d=google.com; s=arc-20260327;
        b=dAxzNe90AIy2K485ttUg3nhj7CFIGYR7auseM1D3gJxFCUYDzsaTTdhGelq5uTwG+U
         pWtywX4txdQ+JDV4A6HcpKNG4nQsGsDholQWp25QVlWgXdDQ9lB2xheYz0zekztOac4m
         Z6W4wQtthztz8vuGKoZHuTt+e6jDHX2LOQujPaWXqIRmFci+5qlTEw7eZzmnztjSkstj
         SKPkDR00EAp+x3uVGBKy3FcBHDcWOiWwZESefn/IKpoyYdbOffiV8c0lbKVSGx3h3rTx
         YxNJgobllJzN0pvilAkGol1XfAFyw0horioqDbW85uwaqiI9m8ys2ySh+9a+D/i//vd2
         GvwA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=yjE4xnT39vpf/cIgIYUv/kq7g7oy4MnCKn9bbbuZ18Q=;
        fh=BwjQH9h/PWECWUPpZstwF589gXCa2+uumNXw/WiirSU=;
        b=fA0KohDUnRqyR0PnPT2ehgzL3crTC3XjzMRsft9y2Uva7GCpL6vwiHNgx/AcP5gzid
         zhu5KpefllMI0k7KBvBJ0h8bVwSDXklPec279pNjE+3BCUuv9ASSEhM8IxEAldsHP1dZ
         p6n5VCZlylvDMgnhm4bIIGmo5MCEqFM6pq26/FReyZvQhIKuGung4ZXSnAEveZI5Bcpa
         8TdTBGDNh6BG1Q58MPmGZIw7TswT1AAzm4i9vBmF8LhE7pygTcDBSCWcBOnsHAa0sjZo
         G1Co8Pik/SFaXcBvV3Jwx9Gf5NmlZztgDN+Oow6UhGXMGUDKa8IZqO/DJpSPV7qnOS71
         A1PQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785956559; x=1786561359; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=yjE4xnT39vpf/cIgIYUv/kq7g7oy4MnCKn9bbbuZ18Q=;
        b=cy4Ag8wvBKQRm+j5xKMyQfTrzjH48rFaMIGaIzz51yzz0O4p1TthGImHlGyDVOM4kB
         Hv616jq2qKqSp7yV0nncp7dKDUasSam95v1/1v4S+zBbWFJp26DFbnU4dQGzBiZX8y3O
         dtkorSi42lxmDG6BEok+PTdz3C6VH4vCc0XeGe4FGghiLRo/9QbBeUIpa8dIPLyhh8+R
         Faa8rcyQxL/tMwCEd1zoBCPf7R3twoJ6oQJsQ3q/gkHAK4dsWpKba9KG9jT7LKFucJhl
         q4nOS1YWJOz676wa72AAzKz3jZwLXAgg/wA951lkfIkgo1qDDe7MLgjD7+cTWIgCkV4+
         Xedw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785956559; x=1786561359;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=yjE4xnT39vpf/cIgIYUv/kq7g7oy4MnCKn9bbbuZ18Q=;
        b=S5lsJtI+6JnFImelVtudpvQADlAkdHoabidJmsldYNIYKwJ4jl4NHBbE4FD0nr70bZ
         XLir0mIcN//02KeZeHpxIqZTn7eV9ao+gESlaWugGKIwHYu12/cMyGxy1dR9NPBdtduy
         +RAqxN3bZECLn+2M2JYbECdO/UP81PPAbsFTISGZ3EBRcXlEtek0ghyeAA5Dr90n5864
         4MR576TXjbamvfcybI6n4Am6q16UPDhPRAxw6DOOdXkrdS0CiiW2k/ew1Z0y1jZPOs/g
         H11Pfx9Zz7l748F7fdTYe5Wfvs8afzQY8USy7TDQdCNuN4RJOnj9kiBuFLnBAZoZ6QJI
         ZFww==
X-Forwarded-Encrypted: i=1; AHgh+RoWONNlE0ZoGFHv4oN2+RPPM59uUnrYheswLnF5fCCyNkoFJ67EIRfo4eAK45/dmE+ioeQiEU8gQERD@vger.kernel.org
X-Gm-Message-State: AOJu0YyjOLxcf8/DIw+eVJhII77LcSnzLty0AXToyjGtVLtqsaCQxLQB
	kdJg59PGNAqOZpDvn8Ko3ydb9KEY1OSisWgR1gNbXIJ5iYkmWWYaywOZBmfIuz3bUeUevxEec6v
	MYcqvmdkaLKM5JcLhphGn4bi2tF9ByA4=
X-Gm-Gg: AR+sD11AShSJSphrQwVm9rnJuXuNW4MbW0V0QGe4FBymLOJ2fPjbNKAemE3jFHHjFIQ
	O9YqiFbuI3tshqRCjkn9BaUNbhnTdRtu1t+LhTdHQgT9vH+xReW4bOs58QOgbmlV/hPy09/wqfz
	xTQMWyhlZmLNA6549SBrV3d3ccj2zAmJQCki6IIB3904meXLTFYfnkBMsLLzpEoHdtVkmJbMXDp
	3fiAYOnQv4lkRVoEbFnf4W1KO/H4T01Wy4gbdz/9zQ+ApYmWw0zhAX2d5c6bYlyN8mGJHqocrOy
	n9qdkwXhMY5xKriogk5BLiZsCzCpYGZHFhKN3pdcMH/m
X-Received: by 2002:a05:6402:324d:b0:6a0:ecc9:79ad with SMTP id
 4fb4d7f45d1cf-6a14f27eb8cmr4200909a12.20.1785956559020; Wed, 05 Aug 2026
 12:02:39 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <cover.1785621505.git.coshi036@gmail.com> <2824f30bbc43e6a0b318564fa641228e9a096e37.1785621505.git.coshi036@gmail.com>
 <aqyhnzlgxo4x2v6bfpi43ueoob2drnpcxkmy7fpx3i7bcrvkzj@rm2bn66enfc3>
In-Reply-To: <aqyhnzlgxo4x2v6bfpi43ueoob2drnpcxkmy7fpx3i7bcrvkzj@rm2bn66enfc3>
From: Chris S <coshi036@gmail.com>
Date: Wed, 5 Aug 2026 15:02:27 -0400
X-Gm-Features: AUfX_mw6M87toR509y6pAXXK646xUVHCYetXkG3wp8ZS--BnNZ1uTuGmAkGSoO8
Message-ID: <CACd_6n1YDk=S1MWd=7TH29mTcyiijLQn8jZOyjGo=p9yduZ06Q@mail.gmail.com>
Subject: Re: [PATCH 03/19] jbd2: point the shadow buffer at the frozen data directly
To: Jan Kara <jack@suse.cz>
Cc: Christian Brauner <brauner@kernel.org>, Alexander Viro <viro@zeniv.linux.org.uk>, 
	Matthew Wilcox <willy@infradead.org>, linux-fsdevel@vger.kernel.org, 
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

Hi Jan,

Thanks for the suggestion - done in v2.  new_folio, new_offset and the
frozen flag are all gone; folio_set_bh() moved into the one path that
still needs it, and the two copy-out paths just set new_bh->b_data.
b_folio is already NULL out of alloc_buffer_head(), so nothing has to
clear it either.

Chao

On Tue, Aug 4, 2026 at 4:28=E2=80=AFAM Jan Kara <jack@suse.cz> wrote:
>
> On Sat 01-08-26 18:00:47, Chao Shi wrote:
> > When a metadata buffer has to be copied out before it can be journalled=
,
> > jbd2_journal_write_metadata_buffer() writes jh->b_frozen_data rather th=
an
> > the page cache copy.  b_frozen_data is kmalloc()ed, so folio_set_bh() m=
akes
> > the shadow buffer point at a slab folio.
> >
> > That is not something the buffer_head layer can reason about.  A slab f=
olio
> > overloads ->mapping, so a shadow buffer looks like it belongs to an
> > address_space when it does not.  buffer_set_crypto_ctx() already has to=
 use
> > folio_mapping() to avoid tripping over this, and it is the reason
> > mark_buffer_write_io_error() cannot be called on a shadow buffer today.
> >
> > Point the shadow buffer at the frozen data itself instead: leave b_foli=
o
> > NULL and set b_data.  The previous patch taught fs/buffer.c to submit s=
uch
> > a buffer.  The two commit-path checksum helpers are the only other user=
s of
> > the shadow buffer's contents, and they take the data directly rather th=
an
> > kmapping a folio that is already mapped.
> >
> > Note that the shadow buffer must not be passed to bh_offset() while
> > b_folio is NULL.  All four callers that can see one are handled here an=
d in
> > the previous patch.
> >
> > Tested with ext4 mounted data=3Djournal,journal_checksum on a metadata_=
csum
> > filesystem, writing files whose every block begins with the JBD2 magic =
so
> > that escaping forces the copy-out, then crashing with sysrq-b without
> > unmounting and replaying the journal on the next mount.  Recovery
> > completed, the file contents matched, e2fsck -fn was clean, and an
> > instrumented build confirmed the b_folio =3D=3D NULL path was taken.
> >
> > Suggested-by: Matthew Wilcox (Oracle) <willy@infradead.org>
> > Signed-off-by: Chao Shi <coshi036@gmail.com>
>
> ...
>
> > diff --git a/fs/jbd2/journal.c b/fs/jbd2/journal.c
> > index 09efa337649e..9e4cb04587b4 100644
> > --- a/fs/jbd2/journal.c
> > +++ b/fs/jbd2/journal.c
> > @@ -329,6 +329,7 @@ int jbd2_journal_write_metadata_buffer(transaction_=
t *transaction,
> >       struct buffer_head *new_bh;
> >       struct folio *new_folio;
> >       unsigned int new_offset;
> > +     bool frozen =3D false;
> >       struct buffer_head *bh_in =3D jh2bh(jh_in);
> >       journal_t *journal =3D transaction->t_journal;
> >
> > @@ -354,8 +355,7 @@ int jbd2_journal_write_metadata_buffer(transaction_=
t *transaction,
> >        * we use that version of the data for the commit.
> >        */
> >       if (jh_in->b_frozen_data) {
> > -             new_folio =3D virt_to_folio(jh_in->b_frozen_data);
> > -             new_offset =3D offset_in_folio(new_folio, jh_in->b_frozen=
_data);
> > +             frozen =3D true;
> >               do_escape =3D jbd2_data_needs_escaping(jh_in->b_frozen_da=
ta);
> >               if (do_escape)
> >                       jbd2_data_do_escape(jh_in->b_frozen_data);
> > @@ -400,13 +400,22 @@ int jbd2_journal_write_metadata_buffer(transactio=
n_t *transaction,
> >               jh_in->b_frozen_triggers =3D jh_in->b_triggers;
> >
> >  copy_done:
> > -             new_folio =3D virt_to_folio(jh_in->b_frozen_data);
> > -             new_offset =3D offset_in_folio(new_folio, jh_in->b_frozen=
_data);
> > +             frozen =3D true;
> >               jbd2_data_do_escape(jh_in->b_frozen_data);
> >       }
> >
> >  escape_done:
> > -     folio_set_bh(new_bh, new_folio, new_offset);
> > +     if (frozen) {
> > +             /*
> > +              * b_frozen_data is slab memory, not page cache.  Point t=
he
> > +              * buffer at it directly rather than at a slab folio, who=
se
> > +              * ->mapping is not an address_space.
> > +              */
> > +             new_bh->b_folio =3D NULL;
> > +             new_bh->b_data =3D jh_in->b_frozen_data;
> > +     } else {
> > +             folio_set_bh(new_bh, new_folio, new_offset);
> > +     }
>
> Can we please simplify the flow in this function? folio_set_bh() is now
> done only for a single branch in this function. You can move it there and
> completely avoid new_folio, new_offset, and frozen variables (you just ne=
ed
> to set new_bh->b_data in the two branches where frozen data is used).
>
>                                                                 Honza
> --
> Jan Kara <jack@suse.com>
> SUSE Labs, CR
