Received: from smtp-relay-internal-1.canonical.com (smtp-relay-internal-1.canonical.com [185.125.188.123])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7405734D901
	for <linux-ext4@vger.kernel.org>; Thu, 26 Mar 2026 01:50:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=185.125.188.123
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774489862; cv=pass; b=YwJeK/oxLd+OAtqyQRJQCKXfG7Uf5XmxZ4vENQDe+frPqb4nQ3GipaEtCzbfiRJVhOXu+tJss+QbOxAw8svNoz2wPnZTK1S33HGK6IwBEYw4aXoFgtHBnaTz2S1LmOpoHeyXUDBJvZycCw7MY4qHSPJbld4ZI0RiiHiysNKEg0c=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774489862; c=relaxed/simple;
	bh=fL/SfWbL5buhc1ifo/6Ht3jXukidfMIMD1CqdQvUJuk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=jHZNXfvm4hGjwAxAUqygDawKpe5dRJ7cTRbo7kDUfbnV60HuWQnr804wGStk/2zlZHAx0A1tv0G6xN3cyH6/PEuAbdlzytmIUyc4D0MEW7kA9CkwUcbYCOG/YzYHCKunzrJZ7kCJLdYX3IG2PoUqZ0TH5BIvggCdCRyAIkNJ6jY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=canonical.com; spf=pass smtp.mailfrom=canonical.com; dkim=pass (4096-bit key) header.d=canonical.com header.i=@canonical.com header.b=ZeOYKHlR; arc=pass smtp.client-ip=185.125.188.123
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=canonical.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=canonical.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=canonical.com header.i=@canonical.com header.b="ZeOYKHlR"
Received: from mail-lf1-f71.google.com (mail-lf1-f71.google.com [209.85.167.71])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-relay-internal-1.canonical.com (Postfix) with ESMTPS id 239523F0B1
	for <linux-ext4@vger.kernel.org>; Thu, 26 Mar 2026 01:50:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
	s=20251003; t=1774489852;
	bh=5LiknU9YZubs1t4YbhjYt2VxOXp5xnY1wLJwJ/9hS5A=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type;
	b=ZeOYKHlRMWj8hYgFxnn7ZSGPcHvnQfu5OuG6n2RH9+SIWhGIOLr/lDFl84TBXxOrx
	 ZW25rBAlvtzZ8WwpQmpQxHhhd3PvY7ZRHlqt5ly0YQZ8M+EYrI9M0Odna3DtiNj/g6
	 xESBD5oS0a6h82BiKYqhHZ4ZK0fexFy/p2d0AAl7/ltObUEY6hdjSj0ZyYnBwUikAH
	 Hh11NgchQYzGLMYk+LRq27fFxV2Zedk60cMVIbvZVV1lldSnRJaQVIbUjNjbzEUzlj
	 nJQyAA7g65qs7hRLuQBKM/D3g+h5WBRUqxaBIKJ19ci4lPAog+4PrIBkOwjTWlEzm2
	 T6JuuMG8milxRtn3J4w7R7rU/MJNLCB0vcD5kqvwCL3B9gKpGSQ/7H/wPk+wh7GYMP
	 pGM+W1WC4Q0YDx1+RVZd0XVEIuE25f7StXGaA99D9iDpHCiplZZwsgzYkPPH6AseWY
	 M9RNNVYZ/oRZvjxZ9ytr94c9LT9u6E3w5ghqeR4z/CSS0h/Fvm0EnuNY7SjnUoyn6I
	 HBGfXdZYtWbd3i6LoedAntj3WqtzLoHqWKixXvtIcoTfAut/l530IMEE6Locpi8iCM
	 QKL7J3kP2PDVXpvMNo+32QKxPP0cWA6y1roe3hRl8r/WzV5P6UqiwxBIZzVh6jPnp0
	 HAlDGqemYb0wno8Cgr5aZvLI=
Received: by mail-lf1-f71.google.com with SMTP id 2adb3069b0e04-5a151d46c5dso529295e87.1
        for <linux-ext4@vger.kernel.org>; Wed, 25 Mar 2026 18:50:52 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1774489851; cv=none;
        d=google.com; s=arc-20240605;
        b=U6jqj5BeFuYYyHR8ley9ALxCjRmW2OX2dinsHUyA+h2PcG3tBNsE0L/tCkjHM1K0h6
         GAB0RtRZ+a2bq3xkwJUp7Jy0cMinAJFRr8VrJgN6chhAS8Ui0UgvWFecvhnPwJ2TeFRA
         pC6a6w5JefgIxsB9TUTengm+vagOy39RPOJ1Et2LGrxmZ9ZXzfd/myoXSukq58OUEYGC
         azOswkvTqdKNPNZJjdoa3srv6nLMiaCXbdOGlfblZI5vjddTbASqdsum54QAqtxQ2DvL
         VKMb2O8c8c5/tUrc5Y1y7dwn9JIX5C49DiR/84iR8T282Us2D65y1KllMulTbDc0JAJ3
         eToA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version;
        bh=5LiknU9YZubs1t4YbhjYt2VxOXp5xnY1wLJwJ/9hS5A=;
        fh=s41yDohBktKk+AXZEYu0zD7c9ki+C2i1cqjJ++d2mNg=;
        b=WoL+zt/sMpn6o1fsHsEWW8MHSCMRNnz44IV43pRrO53sTSainXRf2obNyQDCekkU0N
         3Qzr8uQQF1wg7mOh5786KAJWYqOPFZQPgvP+v+6n6q3SRqGzXz22j+KZ/dtBpXcvFYtF
         eBHShazU/cyzORN5rsObhJT6hGbpFJZYItWwz9PK9xEM/Q8nDLCRBWEQtb+XcB5kk4+V
         Vkof428GUVR+SCg9LLZGVuW/2f0ibouRadffdOQGFeE7jW4dbJja62T10am/eH/UWfkk
         QrlQ+Xa3kyqxHAn/qW9FEBI1s6RNEzc5oFUfKqKH1Fb1GB0b0JCCBlOIkKX990cd+8E3
         eX/A==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774489851; x=1775094651;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=5LiknU9YZubs1t4YbhjYt2VxOXp5xnY1wLJwJ/9hS5A=;
        b=Jr1Si36w3XoGjBY0C4QCyrvw5+OCK6mcD1FJrP/QDAlLe2hrhKdBbsHeb+CHyZlIOr
         kvF5UUcpl18DnfOYy5tSp7YUxPURa0CSd9ABtlqESOnpJWWrcorm1JVa2oPX4X3ZIbwQ
         yEbu32vA8tNOwpaVs9Cnh7T5gFO5ZbQXcAVEShK44U1h8gggM3NAShbY2IxRnpx/7dhR
         9U79LGVBLw1P8NBYWkml/YjmsCEy0HeYiaqSaoqfOWCM3aHKSBzdGSreWOScQSl7IfPy
         gEVe+A8Shx7M10d2Lwr1iCYG/MXO+eLtxVVkMb8YALR+qwznuz7TgBSZE3bo2lf/GRKw
         k+Aw==
X-Forwarded-Encrypted: i=1; AJvYcCXEV6Nu2hsy1aBqR1/+bdjE+ZiiWKKlJtPmfO/GN0O3FdIdEeXSm2ibhYET1AEgcifVHF8fB/R+m6H0@vger.kernel.org
X-Gm-Message-State: AOJu0Yw7jlj3U+kc+4p1efbl4NUxIZsx4IzGMlLwHvEBAw6syPnOwrr0
	JH9kIUMhYA59ZaXFF5jFVvdJkJvR5dbLWKIelY0zGi4qmkhCeGCVVQzfteZh/ejg5HlymvPzhp1
	R+zt8bV9Gyckk/BjnDlTR+9buCIE28g7voTac8XlmQLUtdJ8s+tUNy9aDsdrI3BZEFck+QWLS+e
	bxq2jXZkwPom6JDrnpO6IYl6Y4+8PQen0N0vj/2NAgkJO1Eh10+JlXQQ==
X-Gm-Gg: ATEYQzwrhzQMVt/0/UDosZAaQuu2kx2TTp+713tE6P9XUUjWVcU/iLTaNHkZBjXtmxB
	gp9rJfukUPV6+FXfD/LfGm9IWJqnVT85GBB3k3PiJI7UskUl3dg91eamyjoMf3c/JO1YSrPg7xB
	mllUZdEcAtfr7VIW6JCMjcE4oZTJ67VJ9VrGva9kT2pIXKMG20pGBLfO2BHY3zavRuQ3mrzrjpl
	nuOdaw=
X-Received: by 2002:ac2:55bc:0:b0:5a2:8570:299a with SMTP id 2adb3069b0e04-5a29b995643mr1360769e87.34.1774489851322;
        Wed, 25 Mar 2026 18:50:51 -0700 (PDT)
X-Received: by 2002:ac2:55bc:0:b0:5a2:8570:299a with SMTP id
 2adb3069b0e04-5a29b995643mr1360763e87.34.1774489850890; Wed, 25 Mar 2026
 18:50:50 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260128074515.2028982-1-gerald.yang@canonical.com>
 <4u2l4huoj7zsfy2u37lgdzlmwwdntgqaer7wta7ud3kat7ox2n@oxhbcqryre3r>
 <CAMsNC+s1R-AUzhe80vjxYCSRu0X9Ybp33sSMHGHKpBL6=dG2_w@mail.gmail.com>
 <bycdopvwzfaskilhk3nsljuk3gkztvoa3is466a6utuj2lozmj@pxf44ulcnqup>
 <CAMsNC+ve3dRwT1xGWB0pvBJXqBpeksf7PgbEeihcnfs=AmwVRQ@mail.gmail.com>
 <gluj62pw5pu7ag2juf5ejwsr3ghvckag7wh4zunwyk57slcrmg@42of57gybigz>
 <tmtgzmvkfag4r6lbt4i2ej5ad3bfudezcm35l27ybit25r7l4d@5o2i4cuymh5j> <CAMsNC+svSX9AiZbs1dd4qigZqBuOjuCHOjpyXzgaO0sNLUHDYA@mail.gmail.com>
In-Reply-To: <CAMsNC+svSX9AiZbs1dd4qigZqBuOjuCHOjpyXzgaO0sNLUHDYA@mail.gmail.com>
From: Gerald Yang <gerald.yang@canonical.com>
Date: Thu, 26 Mar 2026 09:50:39 +0800
X-Gm-Features: AQROBzC5qkRVEJWUzMStw_8-1sql28Z61YBoEXnUUP9N0BkDzey6scwgVfHn69Q
Message-ID: <CAMsNC+vQceRaw9DkbQFo1p2piwcwDbTgohqt=Gtqj27n42kLTQ@mail.gmail.com>
Subject: Re: [PATCH] ext4: Fix call trace when remounting to read only in
 data=journal mode
To: Jan Kara <jack@suse.cz>
Cc: tytso@mit.edu, adilger.kernel@dilger.ca, linux-ext4@vger.kernel.org, 
	gerald.yang.tw@gmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Jan,

I'd like to ask when this will land in upstream kernel? Thanks.

On Thu, Feb 5, 2026 at 8:59=E2=80=AFPM Gerald Yang <gerald.yang@canonical.c=
om> wrote:
>
> Thanks Jan for fixing this issue, I can confirm the patch works for me to=
o.
>
>
> On Thu, Feb 5, 2026 at 5:25=E2=80=AFPM Jan Kara <jack@suse.cz> wrote:
> >
> > On Tue 03-02-26 15:50:43, Jan Kara wrote:
> > > Hello,
> > >
> > > On Fri 30-01-26 19:38:55, Gerald Yang wrote:
> > > > Thanks for sharing the findings, I'd also like to share some findin=
gs:
> > > > I tried to figure out why the buffer is dirty after calling sync_fi=
lesystem,
> > > > in mpage_prepare_extent_to_map, first I printed folio_test_dirty(fo=
lio):
> > > >
> > > > while (index <=3D end)
> > > >     ...
> > > >     for (i =3D 0; i < nr_folios; i++) {
> > > >         ...
> > > >         (print if folio is dirty here)
> > > >
> > > > and actually all folios are clean:
> > > > if (!folio_test_dirty(folio) ||
> > > >     ...
> > > >     folio_unlock(folio);
> > > >     continue;       <=3D=3D=3D=3D continue here without writing any=
thing
> > > >
> > > > Because the call trace happens before going into the above while lo=
op:
> > > >
> > > > if (ext4_should_journal_data(mpd->inode)) {
> > > >     handle =3D ext4_journal_start(mpd->inode, EXT4_HT_WRITE_PAGE,
> > > >
> > > > it checks if the file system is read only and dumps the call trace =
in
> > > > ext4_journal_check_start, but it doesn't check if there are any rea=
l writes
> > > > that will happen later in the loop.
> > > >
> > > > To confirm this, first I added 2 more lines in the reproduce script=
 before
> > > > remounting read only:
> > > > sync      <=3D=3D=3D=3D it calls ext4_sync_fs to flush all dirty da=
ta same as what's
> > > >                          called during remount read only
> > > > echo 1 > /proc/sys/vm/drop_caches       <=3D=3D=3D=3D drop clean pa=
ge cache
> > > > mount -o remount,ro ext4disk mnt
> > > >
> > > > Then I can no longer reproduce the call trace.
> > >
> > > OK, but ext4_do_writepages() has a check at the beginning:
> > >
> > >         if (!mapping->nrpages || !mapping_tagged(mapping, PAGECACHE_T=
AG_DIRTY))
> > >                 goto out_writepages;
> > >
> > > So if there are no dirty pages, mapping_tagged(mapping, PAGECACHE_TAG=
_DIRTY)
> > > should be false and so we shouldn't go further?
> > >
> > > It all looks like some kind of a race because I'm not always able to
> > > reproduce the problem... I'll try to look more into this.
> >
> > OK, the race is with checkpointing code writing the buffers while flush
> > worker tries to writeback the pages. I've posted a patch which fixes th=
e
> > issue for me.
> >
> >                                                                 Honza
> > --
> > Jan Kara <jack@suse.com>
> > SUSE Labs, CR
