Received: from mail-ot1-f54.google.com (mail-ot1-f54.google.com [209.85.210.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41CF83D3314
	for <linux-ext4@vger.kernel.org>; Wed,  5 Aug 2026 20:33:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.210.54
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785962004; cv=pass; b=IwixQoVRcOkQYZaCzBGgJ0YQXXgJK0J4xpJbD5eW+tR047Y5GdZgjhig7JPGcRVQ5wEOoNnjIxXC9zpyg/sULGQW56kJOgFZ4rW/iSdxUHQgPhXkLmtKRtC1QhMQRU/NGPbS26zwBNgWaRwTeXm9ij3KMap7fSuQPd9QHvt8b8c=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785962004; c=relaxed/simple;
	bh=GI8C7x7/1X74WCp4xq6Tj+lGkjg4R7DvkuG6i1NAga4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=saXhXbkbpq7E0LRl+EciVyoEAsZ8yFC+o94SX3VRsMIcrw/3vbP0OEDNusMe7sJAQGMIFh07NQrZEdMC2QxEO9UxbuwC2ykUreBUqaJCDyf2tpqI+ZeUIJaO5jFtSdFbo8tDpKCM1AjUUYtaxA6D0dZx6O3D3VR97uYk3AA408c=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=n/NcMRwn; arc=pass smtp.client-ip=209.85.210.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="n/NcMRwn"
Received: by mail-ot1-f54.google.com with SMTP id 46e09a7af769-7e9f69ee6f4so1314550a34.2
        for <linux-ext4@vger.kernel.org>; Wed, 05 Aug 2026 13:33:23 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1785962002; cv=none;
        d=google.com; s=arc-20260327;
        b=sGP6cA1p5foZTyWXUBax9BEkhMAZJxGr7MC5E7j/gUnQqSyz9lUE1u+7kaH+N0nv3i
         JziWPpVN+t7vryM63Lnc7ntPJoyz6y9EthmC7yaqDbYnGZ1wz3F4HVuMehe743dUVkjv
         acaL/xiILjyGXP9+Ydlr9MvxeYl3O+ziLR0k3qoI3Mln/1BKW2ZCKjFQ1ZvN2oqB2UU4
         33Nb0kWz7t3ws/p5FPdIKkLsAo8YhZKRNy4U8t2cYXYL7FWxtaGgds3ARt6KHcjYPPTl
         MvkX/6NRSKUdYVRe83d0AZvxWK5NZHzkqvLaMi5ABNGMcu+Zts7EtcUMDx2wr7HQ39fI
         MXrA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=WXwiR/pZJKH9ofJG0kWfM6Ol7KNG5CJwWwWByT6iJt0=;
        fh=eyCzEcAZ+pxqrt/N9goSnOuo3C4oaX1Gc2gNHlyh0xw=;
        b=YnGoGhDtWCC9OF+V1/6u5RcRfssTiM0kKHY/hUI6KDRMjc1PkQfeEdrh6ASQD6vA6r
         1NxGWaNshZszaf+d6bQs0TNrLgCuoUnIChVejol1kjHIYbv6k5uvCyDY6hrD5gLmKNjG
         D/m555aJruJONmt5IuX/1O3bBht2E6IFP2y43v55zai06YEBzwIL4/Zv+aZkhT24b7D5
         S89UuwwY6xLamC8G/YKqkd6Z32rePRx3d8Jkcpb0wmDiySbf2Ar/CAOovz5TSJxZU3ed
         1XzeftYEhnDNAX3G77HuJnzFsnPKOnIkDvg7Xflp+j61zE0XCpR5Bt74X6prg4JTKU3P
         Ufyw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785962002; x=1786566802; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=WXwiR/pZJKH9ofJG0kWfM6Ol7KNG5CJwWwWByT6iJt0=;
        b=n/NcMRwnKQr3USC9Vj0vBe//TMUHpANtiStZxPSBFZ6+qPbsCDp7GQHI2VgoKcrXSx
         cfUNYpERNWMGh/PX1WJf19WXWlNFhTALQ8bxQw5K4cD17giSCMDWAHvGQ4j6jFSD6FfE
         zef+zAVWwxBmtHc8xDKkgwiFYWZHxFPJROAYhmQF1bHFBWlhtnyFtsdUgj4nXr+lSyZF
         d+cykyc0n/oPSaBjHHhNO7oWCx0Q8cetc4Bw6MK4sqi76gqSMdh9bcsxkTex4IaFAMDR
         B4fJ6sRhc6UHEXDkx23/88gqj8y66vfnArHVPSrik9wg/SH4KR/knZoU/ZQylHLCYb9O
         MB5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785962002; x=1786566802;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=WXwiR/pZJKH9ofJG0kWfM6Ol7KNG5CJwWwWByT6iJt0=;
        b=UTiVvPcA2B1qeSQD0KrRIkLmRvjUUUEMkex613IdmHKDTIl23gv6vJ+m6KkNcTCjzu
         c3AcusKHV1OoemTsSNzBg9K3nDbyso/imok2njxy6FD3J4UR+oja4UH3Dnrrlbi67hYS
         UR+uMf4jJmCpL026/vBo7ZbExZagNbdero9TgIWAxtAk0A5+mCPFRm2B5NySvQ0wS5gG
         rVF+dX4297mLf5X96TeuDhpM8Si/iMykbVltYdcBguF9bVA135R8DdZkjmzbFA9IauVy
         VAqetz05MyUrR1WiaELmWyte8TtccyC6uHvZ3gGUaZjD1UVEpagmaDJcMFo6yDdjkr+t
         L99w==
X-Forwarded-Encrypted: i=1; AHgh+RpyQd/DesftNmoaVCXzJv5Od/5XiqONozoc78mRwaLVhsTGnQuqsGORsnVJfc1YeVJ3HCNdfQiPVNTU@vger.kernel.org
X-Gm-Message-State: AOJu0YxU5Vj18Dvh9ck9vE3ssjll3Qky9iGJzKsof5JikOLHBZoKUSgm
	2BuY7HP8g78DS0zk1ePgqDeAy3OOkbpVxoB7AC2TTXshqsC5dWNp/DVycz+844uJNjMlDFqUtz+
	dpmrrxD0U2jrZkDVpHlaqCPq5y4KLn8w=
X-Gm-Gg: AR+sD11rQwmumPQJm7CZk4qr6DQErhWxqnbI7AkGmIBkA+EQqXFtteze0sC3tl+kaAE
	OhJtzvMv0HhLk4xDWE88XxX5heKvJK9pCCyEbNg9TR8JRFrhuNc7WlvWZLVWMRtxMRHChzLBP34
	QjDP+kUws9Y/EIHehKunTKVbPeNug0fj1yzu0bnkrM69EcX+9AONyQsDT+08/XSVChHiueh2BIu
	MBTve4q250vpCAOVl6HUoxOkSixZAyUrtqALz2KT06dDRyC3zSQyTL/6S/KQgEbqqVQnmXx+NZ2
	ql9olc23p79RpDtafVoIBRLuhgzxWy1MBbRl4TZpN9a2
X-Received: by 2002:a05:6820:4b8e:b0:6a1:4a27:cd22 with SMTP id
 006d021491bc7-6ae968d0ddbmr5568777eaf.0.1785962002030; Wed, 05 Aug 2026
 13:33:22 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <cover.1785621505.git.coshi036@gmail.com> <f0e0fd8516487b774d8cf1384949a0c616921fbd.1785621505.git.coshi036@gmail.com>
 <ppnbgcljrjb5wqqvqiyh254wkunfutydykgbi7zheuf2mfdjqv@j6lngn5vywxj> <7qfbpj66hdtxc23lox63hqss42yo5xz2dazigf7nwdorplmec5@vv6jsnqa6viu>
In-Reply-To: <7qfbpj66hdtxc23lox63hqss42yo5xz2dazigf7nwdorplmec5@vv6jsnqa6viu>
From: Chris S <coshi036@gmail.com>
Date: Wed, 5 Aug 2026 16:33:07 -0400
X-Gm-Features: AUfX_mwz8K3T1Z_fWdMufWIMTQu1kthOhf45o3aWABfKf2Yu8afHwh21AjQl4bU
Message-ID: <CACd_6n2fBNVQF3UXth_WxGWHMLm7SysDbcQ3PrJc32nDfpMwCQ@mail.gmail.com>
Subject: Re: [PATCH 16/19] jbd2: report journal write errors with BH_Write_EIO
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

Done in v2, and 'success' it is - thanks for the follow-up, that is what
fs/buffer.c calls it.

        if (!success)
                   mark_buffer_write_io_error(bh);

Patch 21 adds a clear_buffer_write_io_error() to the success side, so the
final shape has both arms again, but nothing touches BH_Uptodate either way=
.

Best,
Chao

On Tue, Aug 4, 2026 at 5:10=E2=80=AFAM Jan Kara <jack@suse.cz> wrote:
>
> On Tue 04-08-26 10:54:37, Jan Kara wrote:
> > On Sat 01-08-26 18:01:00, Chao Shi wrote:
> > > The journal's own write completion handler,
> > > journal_end_buffer_io_sync(), reports a failed write by clearing
> > > BH_Uptodate, and the three places that wait for journal writes look f=
or
> > > that.  This series is removing that convention: a buffer whose write =
failed
> > > still holds the data that was supposed to reach the disk, and saying =
it is
> > > not up to date makes callers rewrite, re-read or WARN over data that =
was
> > > never wrong.
> > >
> > > Set BH_Write_EIO instead, with mark_buffer_write_io_error(), and test=
 it in
> > > journal_wait_on_commit_record() and in the two commit-phase waits.
> > >
> > > The two changes have to go together, because commit phase 4 waits on =
a
> > > mixed list: descriptor blocks are submitted with
> > > journal_end_buffer_io_sync(), while revoke blocks go through
> > > write_dirty_buffer() and land in bh_end_write().  bh_end_write() alre=
ady
> > > sets BH_Write_EIO, so converting the consumer alone would keep workin=
g for
> > > revoke blocks and silently stop detecting failed descriptor writes.  =
With
> > > the handler converted, both halves of the list report the same way.
> > >
> > > mark_buffer_write_io_error() is safe on all of these buffers.  The sh=
adow
> > > buffers from jbd2_journal_write_metadata_buffer() have no folio and n=
o
> > > associated mapping, so it does nothing beyond setting the flag.  Desc=
riptor
> > > and commit blocks are ordinary buffers on the journal device, and mar=
king
> > > the journal's mapping with the error is what write_dirty_buffer() alr=
eady
> > > does for revoke blocks on the same device.
> > >
> > > Signed-off-by: Chao Shi <coshi036@gmail.com>
> > > ---
> > >  fs/jbd2/commit.c | 8 ++++----
> > >  1 file changed, 4 insertions(+), 4 deletions(-)
> > >
> > > diff --git a/fs/jbd2/commit.c b/fs/jbd2/commit.c
> > > index 60273cddf434..8912786ebebb 100644
> > > --- a/fs/jbd2/commit.c
> > > +++ b/fs/jbd2/commit.c
> > > @@ -39,7 +39,7 @@ static void journal_end_buffer_io_sync(struct bio *=
bio)
> > >     if (uptodate)
> > >             set_buffer_uptodate(bh);
> > >     else
> > > -           clear_buffer_uptodate(bh);
> > > +           mark_buffer_write_io_error(bh);
> >
> > There's no need to set uptodate flag here at all (all callers set it be=
fore
> > submitting IO). So you can just simplify this to:
> >
> >       if (!uptodate)
> >               mark_buffer_write_io_error(bh);
> >
> > Also I'd rename the local variable from 'uptodate' to 'ioerr' or someth=
ing
> > like that.
>
> Sorry, not 'ioerr' but rather 'success'. I can see fs/buffer.c names it l=
ike
> that.
>
>                                                                 Honza
> --
> Jan Kara <jack@suse.com>
> SUSE Labs, CR
