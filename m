Received: from mail-ej1-f45.google.com (mail-ej1-f45.google.com [209.85.218.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C753346FA9
	for <linux-ext4@vger.kernel.org>; Mon, 16 Mar 2026 22:17:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.218.45
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773699477; cv=pass; b=tK5qQRWmDQyuK2soxsksbV5Zs3Jm+cyB99Jm7KFdq2r7CaACAsBaymcGOgtOj5F0WjimmkwdIO0hKYJhM7Nb50z6apxufrUaHbONmGcvjgknZCw/naQAOK0awU/eTOFgNEbBa9IoUdPg9VtOaLcew447/HGf+61KenGrhxCyKzo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773699477; c=relaxed/simple;
	bh=JpCMBabWFUk2POGoFdyFinJQquafd/ZB9ukE/6A2wiE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=QdsdyE5F4K/W+gGmwgDTm9VXpBy32jZBkjdCVMLiT7ZSK/7urR2sgVYiDILCISw0h6RkZEJ8Onrl/nYgatHGsA67Iae0kc4zjvjf/3JsSfXiSjO+cGiFm2ln4SH76spxUS8KuTqMsC2wKMmlWS/roGPhWRtNnwlQDDesmpI2pr8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=jBrtT41Q; arc=pass smtp.client-ip=209.85.218.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="jBrtT41Q"
Received: by mail-ej1-f45.google.com with SMTP id a640c23a62f3a-b97905516faso337135966b.1
        for <linux-ext4@vger.kernel.org>; Mon, 16 Mar 2026 15:17:56 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1773699475; cv=none;
        d=google.com; s=arc-20240605;
        b=cXI+/FUZvnSbMcvmWqbXs7PP5cYmDs7qFNkSYoqoSSWaQ4SVDbUNVvMzBdh0fch39r
         jBdFzUdfBeyWGDq2HEsK5txVvXVZmipdyXpv+hbiCuNQ/6ADU5M46VsqBgAy9f8hivSD
         LHCnG/nOIyQXjj6kG0wtMDB6TvWGFYlFMc05fZdSms5Xjx4weu/UzZm0vfHb7BVvkabh
         y6RzYGz0TgmMLwkNc9PRZjplB1/YTIR+8RSI9JRg6hc6yQ2RRa0caAI66ljCe7dzvuFu
         FFR41jq2Zf2MfGhpvFyXpvqqypkYH5RGRqZod9emDgjuZMqaityjA+Q/4cJgy6CStFUd
         83og==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=GrMHlhHx53octvp9ydY2BNYr5u1WLiBW2FaRYe8SwUE=;
        fh=uFCXc44gmtbhOXQI1rKlaSluzuREs8NB+Ewe/IgrPlo=;
        b=cI2GzoDxbVSaT+rgdzblR9YqPji+OvuxG5AFj6NQEMSBXVUCTqHNUh4IoMC4wQpCeP
         /E2BdlZX007OBqV3QxSkLFzrG82ildn9NMfjRhwBoPOYySiiYrn5jeOyYa5nbTxsqs79
         IdOfJnMhts33H6+j+UYNECm5r8RpOWoX1wWTQI1aGCAM+/XlMIKP8HAlcBlOnYSKolcx
         rYrJ8CZHpXUvhmg+3lWClEKM4ZFaC+2y3y0RLybD+yZFTo53/UDwJ01WYsavlR6yy5y9
         nf+OduqWqnMKBbs2F4IckXGfFfCOUeV+zAPL8EvYdLYqcw2vCGD2pTe1yOaYK1c0I3zv
         IvUw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1773699475; x=1774304275; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=GrMHlhHx53octvp9ydY2BNYr5u1WLiBW2FaRYe8SwUE=;
        b=jBrtT41Qeq0qs1HPtJDAuwoG3lbeWZW2tOBJjLeDULpQXoLTgrPUjB/OEKPCTXFKLG
         joWperUgA95NoR9Wq7/Bz5fLzvyIyx6lqqQa+AXTpML3sBjfJ55/0AYHivdvjGvGkhWY
         Tbl2qYXRqV4LmHr+c9VNmPpEw9QHHqylMS5lhe8BS6VyQJeZBKWYeoRzjYOH8PoH4YJU
         OUzFac4Ob9ye3RcsT2ZKaOLfhSLM0wDxvhNSKyDLp3NEwmVdRgd6zZtX3v9GUN9bAFDa
         mXyZaiHbAOGFEmRr8Rr+Y4q9WOtW1gMmQaTAYyjzxTImYPsxJDorJ8CxgpK5FJifRVLq
         gbkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773699475; x=1774304275;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=GrMHlhHx53octvp9ydY2BNYr5u1WLiBW2FaRYe8SwUE=;
        b=TWzAmmhmwJJTfOjWGgERIxUCTKICdxhBI79UFPfmJMXlEgw+4X8v97SLLhdQOtiyiT
         vPG4e3A95d4i9QSAYNDMf+XqIrNzERU4oyW+5T59IjzHsgeb6IQSFNmzVKXXnM5kPJ4R
         kG06Z56kR5b0EAQXJo9xYJRKwMMyU+46HMD7ckfLmzpLbPQAFsHtJDGcyWnr4Cb7NIKl
         RF0QUk341axw/x0it9U/QYotE9Dq4V9PoUrQpz/4aRqRNnRoomqV2JqyLULDhj7RoKdX
         8ETBabKPxoWlA0Xd0ogtbZSeQ50u2WgA05zilWZktaP/pYzeJ9sCs3w1S+QQxs5bc99K
         5ABg==
X-Forwarded-Encrypted: i=1; AJvYcCVa+uiTJwkHe6CTcQ/GEcbncflEMGgpYy6+sJmZoxQa06KrhEWuT1ZtIGH1GD5bwnuW4i/w0TcIab/o@vger.kernel.org
X-Gm-Message-State: AOJu0YxPQ9Gw2C6IKoZQSAbmeZPb1Xw9ID8pa6OZ/PHCmIjG4idQM2E9
	e2e3hGmtJwiJlFXN7jccUWxR8SdXXwzEQLG0bKZmJnBMUBhNCT4/iqiNqYfTkyIxKwU8h22NgLX
	xaiAMrYcoDpT6rIiUxxci75ePIvR/vXl0+gOCRbY=
X-Gm-Gg: ATEYQzz5ueuXIeXnJBTigYMMj2I6SWDaQNKbJ58Hz/nSBUAzWd9UCCexSOYWpT8F3Fo
	vnJCr61jlJFE6ZLZOM2xWvfZrT6xqzIQTTGWyTEU2q8GTBdZ5TX+uK59MuMnJQdTozbgdan8cHM
	9qYctUQ6kJomXlkDnSdjDA/F3SfNxDzlikZDltKWoRSqh+4TG8Pj8uZdmkPFDfXCW5XMi4Xev4W
	YsEfrQLCVzwYuLrp9DmU+ngqRf7BEADHTjVo6XdPTK2TBzjDYXJFKWR8VSbvA2en8MICGKos2Cl
	WqHYbVXKbEltGBt1/tIoyLZAc3uWO0/9gXX/w6zCj3ZvUtbMfckyiSmm/RA4ykv4EXvGjHdPrdv
	doY1+kGzS08WCITU5QGPe/+kAciNGgvt60XezvUTa9eGxetCQ
X-Received: by 2002:a17:906:9f84:b0:b96:5a44:65 with SMTP id
 a640c23a62f3a-b976533f6aemr871594066b.30.1773699474448; Mon, 16 Mar 2026
 15:17:54 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260309230838.422074-1-nikic.milos@gmail.com> <3rvkzexi3tgx7cj3kusm2fh6yioake7j2qkh53vwkue7l3x3j5@4ztco37p2pvl>
In-Reply-To: <3rvkzexi3tgx7cj3kusm2fh6yioake7j2qkh53vwkue7l3x3j5@4ztco37p2pvl>
From: Milos Nikic <nikic.milos@gmail.com>
Date: Mon, 16 Mar 2026 15:17:27 -0700
X-Gm-Features: AaiRm50qneEcFVp9Xq7Q0bQjrw-p4bfEqhdPd2UCXRKWJjopN76Pop25FPIDwGU
Message-ID: <CAOeJtk_oC3LptcrqEuBkN_=AVRkFFQeiJW8j2H2Ems=Fqy6n+Q@mail.gmail.com>
Subject: Re: [PATCH] jbd2: gracefully abort on checkpointing state corruptions
To: Jan Kara <jack@suse.cz>
Cc: tytso@mit.edu, linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Mar 16, 2026 at 10:34=E2=80=AFAM Jan Kara <jack@suse.cz> wrote:
>
> On Mon 09-03-26 16:08:38, Milos Nikic wrote:
> > This patch targets two internal state machine invariants in checkpoint.=
c
> > residing inside functions that natively return integer error codes.
> >
> > - In jbd2_cleanup_journal_tail(): A blocknr of 0 indicates a severely
> > corrupted journal superblock. Replaced the J_ASSERT with a WARN_ON_ONCE
> > and a graceful journal abort, returning -EUCLEAN.
> >
> > - In jbd2_log_do_checkpoint(): Replaced the J_ASSERT_BH checking for
> > an unexpected buffer_jwrite state. If the warning triggers, we
> > explicitly drop the just-taken get_bh() reference and call __flush_batc=
h()
> > to safely clean up any previously queued buffers in the j_chkpt_bhs arr=
ay,
> > preventing a memory leak before returning -EUCLEAN.
> >
> > Signed-off-by: Milos Nikic <nikic.milos@gmail.com>
>
> Looks good. Feel free to add:
>
> Reviewed-by: Jan Kara <jack@suse.cz>
>
>                                                                 Honza

Hi Jan,

Thank you for the review!
Just a quick heads-up: I recently sent a v2 of this patch to the list
to address some minor feedback from Baokun (specifically, changing
-EUCLEAN to -EFSCORRUPTED, and ensuring jbd2_journal_abort is called
after __flush_batch).
Does your Reviewed-by still apply to the v2? If so, I can spin up a
quick v3 just to formally collect your tag, or if you prefer, you can
just grab v2 from the list and append it there.

Thanks, Milos


>
> > ---
> >  fs/jbd2/checkpoint.c | 17 +++++++++++++++--
> >  1 file changed, 15 insertions(+), 2 deletions(-)
> >
> > diff --git a/fs/jbd2/checkpoint.c b/fs/jbd2/checkpoint.c
> > index de89c5bef607..cdfbfd27afae 100644
> > --- a/fs/jbd2/checkpoint.c
> > +++ b/fs/jbd2/checkpoint.c
> > @@ -267,7 +267,17 @@ int jbd2_log_do_checkpoint(journal_t *journal)
> >                        */
> >                       BUFFER_TRACE(bh, "queue");
> >                       get_bh(bh);
> > -                     J_ASSERT_BH(bh, !buffer_jwrite(bh));
> > +                     if (WARN_ON_ONCE(buffer_jwrite(bh))) {
> > +                             put_bh(bh); /* drop the ref we just took =
*/
> > +                             spin_unlock(&journal->j_list_lock);
> > +                             jbd2_journal_abort(journal, -EUCLEAN);
> > +
> > +                             /* Clean up any previously batched buffer=
s */
> > +                             if (batch_count)
> > +                                     __flush_batch(journal, &batch_cou=
nt);
> > +
> > +                             return -EUCLEAN;
> > +                     }
> >                       journal->j_chkpt_bhs[batch_count++] =3D bh;
> >                       transaction->t_chp_stats.cs_written++;
> >                       transaction->t_checkpoint_list =3D jh->b_cpnext;
> > @@ -325,7 +335,10 @@ int jbd2_cleanup_journal_tail(journal_t *journal)
> >
> >       if (!jbd2_journal_get_log_tail(journal, &first_tid, &blocknr))
> >               return 1;
> > -     J_ASSERT(blocknr !=3D 0);
> > +     if (WARN_ON_ONCE(blocknr =3D=3D 0)) {
> > +             jbd2_journal_abort(journal, -EUCLEAN);
> > +             return -EUCLEAN;
> > +     }
> >
> >       /*
> >        * We need to make sure that any blocks that were recently writte=
n out
> > --
> > 2.53.0
> >
> --
> Jan Kara <jack@suse.com>
> SUSE Labs, CR
