Received: from mail-oo1-f48.google.com (mail-oo1-f48.google.com [209.85.161.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18FE13DC4BD
	for <linux-ext4@vger.kernel.org>; Wed,  5 Aug 2026 20:34:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.161.48
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785962047; cv=pass; b=tkDQmEM/7E5K9DR+ywpAd4b2ULUXBaR4XoVC0AmT0krLOF03+1rvJgdAzMBCguh0/80L/+0kVmeMpocjy/txpuMQ+EMruTh8MKAIcrYSAcmJphwACI0Nz+6g4iRXZKFQCJBpiO92B8l7TcirYUg/nEkO3SZboSFohdsarR5QB9Y=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785962047; c=relaxed/simple;
	bh=Tq1GUshZ0URB5eunwgA44UJvtqfscr+nNVhjP+E6wLw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=a4BgJ7q1mgO11lKmOncYCKdypXg6ssnTdpZCTl6qSY5hUNF2UtxMOvGOWgEeMTw6RuYT53qh0c7+lA6hVdD9AuevrxePnAQu93aNM4S6lb03wsLAIlLTxlV0uAFfotMCAOspl0NOZnu7hHocd/zZHvzG4TVCuwodAh6bRGOzbk0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=eGqx1WOR; arc=pass smtp.client-ip=209.85.161.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="eGqx1WOR"
Received: by mail-oo1-f48.google.com with SMTP id 006d021491bc7-6ae409c12f1so965398eaf.1
        for <linux-ext4@vger.kernel.org>; Wed, 05 Aug 2026 13:34:04 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1785962044; cv=none;
        d=google.com; s=arc-20260327;
        b=j+FzM0y/RKUDnzuOTc+MsfvcnYQwHvtwRlhZfLWonZzKZj46EWZ+gV55eRrZbQMYfJ
         dB46Q6Vs2PKqGzDpEuw/IFNrl5GhAMfD/UwlRn+drwwJIEdd5icHFLaFJz0qj8Z2nw2I
         3SSV69T8hEK9TvIU+9aYQTug3VrBjLHyDTtamuyizFBBsWVatN738arRKPJZrJa+5emZ
         UC2jhG0kKpKrfXI/dGCpOsSToJoG1ftkVu8WmWpZeSm0vDKROopCnDYlb8WSZTPzP4Qq
         IIhaPM5x32xd7rXHaPjy9zK5EQTTs6Q5dprcdevY39LOQ3CP5JvDijPrgHoYceuWPjf5
         YNeA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=kA/AU2w3280P+roGG7oJQqeX77M5dx6w+CVBmDt93wg=;
        fh=JtETeS4OvuB7PK7LE0Rg17HMBByjfmTXMU3foc6PGqc=;
        b=Wt2WSCjSihnLNCLualTwBT+TWj+69I+Gh002Hiuwg+JJ02sNZS22WZ1TDAMs7TJlHD
         fNU+zCIOKeC5Z/VbNkhL6wfxmUREAWruFAAnMd9nKTYWaezqLY0MO4KIFYlOuTEU7HLr
         TAEjeox3NfoaMc8OKGNV6Gv/8m/spBdc5BS9TxOpTjXgEsGOCyG5tYEvpmxOicbrkaHH
         fntxGHk/+6PyZA5XQpkcLP36HJMhGw4syG6NkZRXGi82Zry/rX2fyd3Pzg2hTAVvkNLG
         qKtq8oM5/TCtO9obG3hUgIxiUrkdokF9+1n/pmReh1wv6b0f7uFN9jpdFe1yjiFYbrVi
         Fwsw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785962044; x=1786566844; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=kA/AU2w3280P+roGG7oJQqeX77M5dx6w+CVBmDt93wg=;
        b=eGqx1WORislurbX4DfT0fo99XWmdIrpBohj6ZAeojvHfp5QRZd2gvxubf/EHMLtse0
         hS1ALU1BJdki5m3A1TFbSIEFdINh89JTr4Co2JnPvx5bFc5G5UYsDd7ZSEmXIzw2H55m
         Qo/A/PgM7bQfiFDglJ4lGdIXKARwN6meNj6aO4aTNWqy0mTltI/5uu9t4JSGJMY+hQ2U
         xoVuCvsbmPcBPlM5ON1hRPThVqr3mFIo9neXGnocKgWzDJTzIwtTHBz0xS9PJOIYWB81
         N2e3Bkhr06salb1wwHg8EvQ1n5E67DnEYmdLyVxqOYRClnxCNJNvzd6UVdayoKKgDVVA
         DUMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785962044; x=1786566844;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=kA/AU2w3280P+roGG7oJQqeX77M5dx6w+CVBmDt93wg=;
        b=iWFeZuuf/oiZgkidkOugFidfpCg2jJvNCKhS4wOJXeLe8xAOIjE2uZF0y8Y8bmDMEF
         VJG1g5o+h1e2W9JQoCXx329ynYjEEAaM56z94f10MGcAYVjOySuKpo5Tu5cTOCFhC0+9
         dbOQDuc62VFPvsSP9ZsqYrCgLDMSaqRqzQnJqoAZNt9V8YkD5hTi9Q8h3sxJo/6D9L1T
         GKQX4tcuaIg+yDwzHLpogotubLZ+muSAuTHSZ1Ok94ZU8RPu6kXO6pomkvwhjvtvOChC
         mYURacuzLP8b75uclDlA0Yyy05Ys2abmF1D0GVnJXw3taYFwa0UDHqneIyKGJAK5JEbZ
         x8xg==
X-Forwarded-Encrypted: i=1; AHgh+Rre7Qc3LZvyszCNg6Y7F2XtE7D+rrxhO2S2urbJ08YDKamfQ239m1ci6v/Gzw6BJ3aPcZFBd33BxZ5C@vger.kernel.org
X-Gm-Message-State: AOJu0Yw2HUKXaIUOo2v31fJ29Sd1dkb8DiR32TLdNHKEi8XpGIKHy7In
	6krV09uN0hpCj7Ph9CzkgvExi2qwMW0wxJ4zvjAm60MxUBsqAlnQUwAt7Eij4Xu3w+j3r9GruTv
	B1P5pto/TyCWl2r1FuI2v/kJnRjj/AxY=
X-Gm-Gg: AR+sD11NLuYiPFc2Oe5Q5LHflX/asgzwHhmQhrNxMalhJuXOM0GcWGXDhoMXBSDA/0Z
	TKP2oLk3IMjrOdN3k4Z8RWNZDB7FmyBRtRIUlfRK05XNehgn/AbvkPGSnAYjibhXPJeFQ/RR27T
	m689yaj18kgTCfU31ajha81v7S3v20VvWoarr2d7tBeFdiHAt37VMrYnKQvHwmjd/WdTJHX44zj
	1KV8sJBE0F7I/lzyfwjV87FMrn3qWrW2t/vzeclxkKIHwTmK7Wjz/eo8a5L+HVICS22GcvKJd0c
	EaabgE2GxCZjjWbraXB6DRFznTTgdpQcmH3u0tR1TRT0
X-Received: by 2002:a05:6820:208c:b0:6ac:a539:bc41 with SMTP id
 006d021491bc7-6ae96c8ef34mr4814921eaf.12.1785962043824; Wed, 05 Aug 2026
 13:34:03 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <cover.1785621505.git.coshi036@gmail.com> <8aa2ee674d147d3630f73f7b53fef7781f2aeccc.1785621505.git.coshi036@gmail.com>
 <3dqz5hq2phvgugscfk56q2h6ukf2fc3xfgjhoat222sonbhnr3@62pmosi6frzu>
In-Reply-To: <3dqz5hq2phvgugscfk56q2h6ukf2fc3xfgjhoat222sonbhnr3@62pmosi6frzu>
From: Chris S <coshi036@gmail.com>
Date: Wed, 5 Aug 2026 16:33:51 -0400
X-Gm-Features: AUfX_myim6QhFCyzhdj6B0pWIapAMcNebREVxjcQh-jpAusyaGfXWmZ1mZSgYNA
Message-ID: <CACd_6n2WkaxmmKMi7WidJKLJF7sUGfXzXkeQp4pW1W-tjTn4OA@mail.gmail.com>
Subject: Re: [PATCH 17/19] jbd2: assert on a failed write, not on a buffer
 that is not up to date
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

Taken - v2 keeps the assertion on buffer_uptodate() and only changes the
message to "Buffer not uptodate!\n".

You are right that a write error is fine here.  I had converted it on the
grounds that BH_Uptodate stops meaning "the last write worked", but that wa=
s
answering the wrong question: what this assert is guarding is that there is
valid data to copy at all, which is still exactly what BH_Uptodate says.

Best,
Chao

On Tue, Aug 4, 2026 at 5:05=E2=80=AFAM Jan Kara <jack@suse.cz> wrote:
>
> On Sat 01-08-26 18:01:01, Chao Shi wrote:
> > jbd2_freeze_jh_data() asserts that the buffer it is about to copy out i=
s up
> > to date.  Once this series stops clearing BH_Uptodate on write error, t=
hat
> > assertion stops firing for the case it was written for, because a buffe=
r
> > whose write failed stays up to date - which is the point: the in-memory
> > copy being frozen is still the data the filesystem wants written.
> >
> > Assert on the condition that still means something went wrong.  The mes=
sage
> > loses its "Possible", because BH_Write_EIO is not a guess.
> >
> > Suggested-by: Jan Kara <jack@suse.cz>
> > Signed-off-by: Chao Shi <coshi036@gmail.com>
> ...
> > diff --git a/fs/jbd2/transaction.c b/fs/jbd2/transaction.c
> > index 5cc7d097b2ac..fdabe34a7e22 100644
> > --- a/fs/jbd2/transaction.c
> > +++ b/fs/jbd2/transaction.c
> > @@ -920,7 +920,7 @@ static void jbd2_freeze_jh_data(struct journal_head=
 *jh)
> >       char *source;
> >       struct buffer_head *bh =3D jh2bh(jh);
> >
> > -     J_EXPECT_JH(jh, buffer_uptodate(bh), "Possible IO failure.\n");
> > +     J_EXPECT_JH(jh, !buffer_write_io_error(bh), "IO failure.\n");
>
> After some more thought I think getting here a buffer_write_io_error()
> buffer is actually OK and we'll rewrite it. Instead this assert should ju=
st
> have a different message:
>
>         J_EXPECT_JH(jh, buffer_uptodate(bh), "Buffer not uptodate!\n");
>
> to verify the buffer has valid data.
>
>                                                                 Honza
>
>
> >       source =3D kmap_local_folio(bh->b_folio, bh_offset(bh));
> >       /* Fire data frozen trigger just before we copy the data */
> >       jbd2_buffer_frozen_trigger(jh, source, jh->b_triggers);
> > --
> > 2.43.0
> >
> --
> Jan Kara <jack@suse.com>
> SUSE Labs, CR
