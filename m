Received: from mail-ed1-f50.google.com (mail-ed1-f50.google.com [209.85.208.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C041B34B1A5
	for <linux-ext4@vger.kernel.org>; Tue,  4 Aug 2026 23:01:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.208.50
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785884486; cv=pass; b=WoAft1EMVMA5X+2Ipcv4k8J+Q9sxsXo4nNlBDihoErERFXkrHNejyuR5o/8R/L+z59mOzpJac5yepwlT4xsBY0kyCoVSHBJAmMxsiGl6k6VqfO/op797o11PSk6WmTfi4rpKj1CseLZakkrM8iCLwWsdHGC7T4ukIYUsVGl9sOY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785884486; c=relaxed/simple;
	bh=IopsMBq3Iqrmhpt1GvIJX0f0inBUyip79dSnD2RW0vI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=kIxHSXMuVglkg7mHRFcnLbasCx6uCQ2Yj+xx6f3tnRnVy4Gn1sj/IBY2ieMtywoaorP0E4atX0bOdWQAPHPo9zTCX2W1sFKoh3fXASFNxWVFL7sFCk1dowCM2kU5MJ/xR6txln6WRXxjqwCErVVXFDooIwUvcFwi3gaqJvjn05k=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=d684zmVV; arc=pass smtp.client-ip=209.85.208.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="d684zmVV"
Received: by mail-ed1-f50.google.com with SMTP id 4fb4d7f45d1cf-6a0de062db5so502517a12.1
        for <linux-ext4@vger.kernel.org>; Tue, 04 Aug 2026 16:01:24 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1785884483; cv=none;
        d=google.com; s=arc-20260327;
        b=Bs+UtOD7nXRrn7WTOfeSsPED1UYV3tvlLIUjG2Whkkzc5ESCHLwcGhF7E7x2ugy1Sl
         7L3ZxV14c3+mVmcsv94f4fAIqi/f1cn4IHxEuwpnqmccebLodxVJxXWdiK7sKN7labQZ
         gX1CAW0UP0rsGnnzFyQphNQWIW3yIYLRaHV4d4vKaVCoe0RPEpZki7eTyXjesEJXDtGG
         kiUCGbkE3ED9/R+2mqqLIB4p4OhAnJi2kHUFHfH0P32Hs+cN+v6ufpiskbbLIz1IBeqw
         k9WCNXux5/jVaFEgOTBRgD3Do20H4AB0lBp387Bksqz/VJlCkZxPUhTxpru/37XGs//7
         FdMw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=1yp2h2soLRnEcYsxIwWN6JD3tw9DOEM8R0hdKPhFP8g=;
        fh=i6hkR4RoQmKC+B8IYK2GHd9aM2c6WOublGKb5IDjilE=;
        b=OS/gvT0lYhCV1sgjCy24EQnouYmFPKqNJ83EHL0WD7FOZqO10+Oq5jlGka7bIXzPZG
         0uBqPxnc0IDHBtVxDPgYoVY1Y8wRDa1MZE7Ir60C19sIfRsptYIp8IVCg+iRgxC3ZxVX
         lXmcgFb1biRWtiGQ7Vs29cGbXKf1NWJH0GEOx0vYdxQrcbz+4hLAIs8BQUzgLDyeSMg8
         XlcR8O3RuKmVd3yEXEG44g//B9GFIetggyFUBhMIIMMYBxiMCtuvXk1F5fL2fXFBtZI7
         gWE08J9pNy9xUv2yRpsM8gGYdRKe1Sz5x0QjJWOWcQH1bToxMtTM/v7Ypsi948CqQyvr
         2E7g==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785884483; x=1786489283; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=1yp2h2soLRnEcYsxIwWN6JD3tw9DOEM8R0hdKPhFP8g=;
        b=d684zmVVUDvH76KTkE/JHRALhH1p6ct83GO0P/OUAvjVKRKjUYr60lu7WumTn26RkW
         DUA2h0zETTlE1ynnXhM2kewN946wyPLdsAEyeq4j+gJBLUgKKPdIFJdYau2eVSm3SReH
         YwwcSQnDz4eqfoeATePu3q9LqreStNKh874fklLTf3k3o85UX0Bl9Hmbi+YO+RgTd1wP
         jsYwQtb90SuyRp695eKHRAIsCl4WxAGoVHC+RWn0DZzomRdZVGKScqPsWgCdnjF3bWOB
         u7MNXXNVxDDglPBSP9Oh5jUZ4gYCHq0k9c31m8QgpSjaDGb3+DPMQZxkxppHOauTDReY
         XEiA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785884483; x=1786489283;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=1yp2h2soLRnEcYsxIwWN6JD3tw9DOEM8R0hdKPhFP8g=;
        b=oJbRCXkVHdJvtoQ/rfQ/osXZT3pI0kWA0MXpriTycn/+QCX0n6jrvHYLbt85VPCEdM
         SSVZsFkspZMLRgf5EGicG8lDl8rjK5nQgNrTsKeAnqtOUuq4wCHJmX54+hjaUIkthovl
         rr17RcHL8cmwsYPS4jnzLaeOyFrBlm4TxaVRjeyrKg9o42U1hHBEJUxSOEMv7rNm3tOs
         o0rSEevGSS0RnUZQGmFz7xX2ba3RNPhd5Arvyk5PVo1mPRabw7M1njT+giCVH4M/ARVv
         olMN5WVjqc4ikqn5fn9jKBjdt0ZoAln01doMkham5VsU/DsJITaiQdN0mmoLldoIw/42
         /jjg==
X-Forwarded-Encrypted: i=1; AHgh+Rpcf6o6X8NibCfwaKuA4nEz3ooQs0caSwWXntfH299BiUMRYBaz0/LgV20yShs46TE0W4l7p80WftAm@vger.kernel.org
X-Gm-Message-State: AOJu0YzqS4fbR34AZRbyK2DellD9OmCTTXbwOhJdohPU2Cs2MAbP5JMN
	bsKNPhnEVOi4FOMa5aBqWTe1wu6SeaqmdRfbhHcRKL04qoMgBZxJI9pQqGSy7YKhrtLiEH8vufQ
	9MGsTAWBwS0GCAWZTbcbNVxVz/5M+6P0=
X-Gm-Gg: AR+sD10GnalBdTlemq+UxNq/Wj+MK62Uhx8z7FW8X1mtwgferCVdMjo481f5Jhd6eFC
	zHuAlDjdwirVWfCD+5cZ2gSdtpA5MGMtjuyrsIdDvn6an8r10f1mMLImLOq1pYp8tuup8W1jTld
	TEzTGJakggiMDtuN6qHB4BpLM0GFE912ygrDvDR7+XlnTKh/qXga0H/+D/Ua1yf/Ntu5K53XL5H
	rSXSPCa5b/4P+WfPFIpCAQFcwA7N0joZ/XfX0YHFwTgNnZKTte6P0goE/9eniv6G9AkPQO9GLsZ
	0xh5H3cny2d3PrIEdbskVK1A1b4JIWre2tmphkyTd0McD3awbAjoGf/q
X-Received: by 2002:a05:6402:1f4b:b0:69f:d4b7:9476 with SMTP id
 4fb4d7f45d1cf-6a14f0e51c5mr1269188a12.4.1785884482828; Tue, 04 Aug 2026
 16:01:22 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <cover.1785621505.git.coshi036@gmail.com> <3aa278c3b75de2bca8a94ec0c0e40922b1170881.1785621505.git.coshi036@gmail.com>
 <k6v2pwtt67ifaeqyeiv5fiwuui7vttyet3firu6v3huxbq334q@jhl56exixqru>
In-Reply-To: <k6v2pwtt67ifaeqyeiv5fiwuui7vttyet3firu6v3huxbq334q@jhl56exixqru>
From: Chris S <coshi036@gmail.com>
Date: Tue, 4 Aug 2026 19:01:10 -0400
X-Gm-Features: AUfX_mxYao6cSkbq9heyNF_IuXvbT2WPjBf_yLUjm-kTEtW0_MWXVTs6WeiPsWA
Message-ID: <CACd_6n3dYd6PatZqCEBcctkfzA0AzVMZJfPvdAxUA01zhXbAEQ@mail.gmail.com>
Subject: Re: [PATCH 19/19] buffer: stop clearing BH_Uptodate when a write fails
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

Hi Jan, Thanks for your suggestion, changes on v2.

Write completion no longer touches BH_Uptodate in either direction, here
and in the jbd2 and ext4 fast commit handlers.  I instrumented all four
with WARN_ONCE(success && !buffer_uptodate(bh)) and exercised ext4
(data=3Djournal, fast_commit, -o sync), vfat and exfat - creates, rewrites,
hardlinks, renames, deletes.  It never fired.

The BH_Write_EIO change is a separate patch at the end, since it has to
move all five handlers and __bh_submit() together to stay bisectable.
gfs2's handler is in it too; it already marked errors this way and needed
the matching clear.  __bh_submit() keeps set_buffer_req(), and the local
'op' goes with the clear - it had no other user.

Chao

On Tue, Aug 4, 2026 at 5:19=E2=80=AFAM Jan Kara <jack@suse.cz> wrote:
>
> On Sat 01-08-26 18:01:03, Chao Shi wrote:
> > A buffer whose write failed still holds exactly the data the filesystem
> > asked to be written.  It is the disk that is out of date, not the buffe=
r.
> > Clearing BH_Uptodate says the opposite, and callers act on it:
> >
> >  - mark_buffer_dirty() has a WARN_ON_ONCE(!buffer_uptodate(bh)).  A
> >    filesystem that dirties the buffer again after a failed write - whic=
h is
> >    the normal way to retry - trips it.  That is the warning this series
> >    started from.
> >
> >  - a buffer that is not up to date gets re-read from disk, which replac=
es
> >    the data the filesystem was trying to write with the stale on-disk c=
opy,
> >    silently.
> >
> >  - the window between the write completing and the buffer being marked =
not
> >    up to date is visible to anyone holding the folio lock, so the state=
 is
> >    not even self consistent while it lasts.
> >
> > BH_Write_EIO already records the failure, and by now every place in the
> > tree that needs to know about it tests that flag instead: the two core
> > helpers in this file, adfs, exfat, ext2, ext4, fat, gfs2, jbd2, ocfs2 a=
nd
> > omfs, converted one filesystem at a time in the preceding patches.  The
> > private completion handlers in jbd2 and ext4 fast commit were converted
> > along with their waiters.  Nothing is left that reads BH_Uptodate to fi=
nd
> > out whether a write failed, so the clears can go.
> >
> > Found by FuzzNvme.
> >
> > Signed-off-by: Chao Shi <coshi036@gmail.com>
> > ---
> >  fs/buffer.c | 2 --
> >  1 file changed, 2 deletions(-)
> >
> > diff --git a/fs/buffer.c b/fs/buffer.c
> > index ac978d9090c2..0002f0736398 100644
> > --- a/fs/buffer.c
> > +++ b/fs/buffer.c
> > @@ -207,7 +207,6 @@ void bh_end_write(struct bio *bio)
> >       } else {
> >               buffer_io_error(bh, ", lost sync page write");
> >               mark_buffer_write_io_error(bh);
> > -             clear_buffer_uptodate(bh);
> >       }
> >       unlock_buffer(bh);
> >  }
> > @@ -441,7 +440,6 @@ void bh_end_async_write(struct bio *bio)
> >       } else {
> >               buffer_io_error(bh, ", lost async page write");
> >               mark_buffer_write_io_error(bh);
> > -             clear_buffer_uptodate(bh);
> >       }
> >
> >       first =3D folio_buffers(folio);
>
> Please remove setting of the uptodate flag from these functions as well.
> Write IO completion shouldn't really touch the uptodate flag at all...
>
> Hum, maybe we should actually clear the BH_Write_EIO flag on successful
> write completion in all the end io handlers. And then we can drop the
> clearing from __bh_submit(). And this will actually also address the
> concern Sahiko raised (mostly harmless but still) that if the user gets t=
o
> check BH_Write_EIO after another process managed to redirty the buffer an=
d
> resubmit it for IO, it can miss detecting IO error that happened.
>
>                                                                 Honza
> --
> Jan Kara <jack@suse.com>
> SUSE Labs, CR
