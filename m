Received: from mail-ot1-f51.google.com (mail-ot1-f51.google.com [209.85.210.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE8933D3CEB
	for <linux-ext4@vger.kernel.org>; Wed,  5 Aug 2026 20:35:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.210.51
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785962138; cv=pass; b=ripIceWzFGsCCpdFzHoiil8DYmAPhRC1fXEydO4HgsT9dPyr4whm68hZsyUVaEc237UXWlJ5cOvi9cwEZIhrPp4Iy3VrbtdfrcQNPiSipFmUn3eGjl6qv5Wu3GzT+OrNb9jjmAJMWSdWdAiom5h7d9tGj2cQy1sXGfMnLT2XVIg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785962138; c=relaxed/simple;
	bh=WSEBgYXrHwYXrkVW8w+RdPxc+qhI3MgH0bYqPdxwfqg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=SSP2mgxy6KL7ywQqGjOp05PZTsgI2oqq0YDlFlHAhraIZi7So1E8lpxoNm/mxXFaff1sgF4MqOIBqwltkGr3M9dgxdBQn1MiP45wnP4P7DVBQRg1ZbFmV4SsBUihbXi1Rt1iQGVYTa5NzCBiFIN9Ku4laSFbKuW7VKq2vevw8Cg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=pBiX+8t0; arc=pass smtp.client-ip=209.85.210.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="pBiX+8t0"
Received: by mail-ot1-f51.google.com with SMTP id 46e09a7af769-7ec1e9d3359so1032024a34.0
        for <linux-ext4@vger.kernel.org>; Wed, 05 Aug 2026 13:35:36 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1785962136; cv=none;
        d=google.com; s=arc-20260327;
        b=HFbVF2BeYGR8x4Zbyf70yoPR5q6XeKyEYPkpJBNSxfNY2ttME/kJpbjUQsi1Asg3Ln
         PHnBA9DjSZUULayBcRgyUeynR74JTqis1603KPwLkRCX2VzrrB5WDU+Ku/mCZp9FJCtn
         GK3KPC3kgMYGsQ3ZdoSi+dtt67xRWomjpdDYqLM2yHSkwbmxnBfXe+xESJ8E4qzqeA0c
         nRiCClQPKZbZR5lNFDGtSTz9v3qEGH6zc9PGX6PMPC08NwrGAmhgwEg6kMzTxuTHPLn2
         t1I2HBL7dL5+AYgP8g+CJbrDO3HcG2FsTiO+fY0Kz8O5/YElqf0OaVrbp6D/Eeh4W76V
         IDuw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=BQuE5p94CfqyEpHjKQoO3ghb1Rb0W+FJ1ncrC2gXf/s=;
        fh=JizxtMQpMdvgcK8KJsBdYntQkDKPurvhkoZRQtBA/VE=;
        b=GLNBzoqA9egesHbcvQZi3/EPB7+ZT3xrUSyPnLtLkyfboLCN3ybvXI0zCDwvTKCZRg
         QuW7dNppsZLYFbrxddCZJc3FQdVPPpUOEMR6oq73ipFfAOF4Ed1/xP2gFQjMm8W+82Wd
         faGPCn1d1Nt109xlIZmVfCOZMaO0Hfnw+K5YWWFVZKACrBl0IkbV/+BJGO5LqF6T+r+u
         hIQUT56ulNYfsa14l2Y0g1BqKBZrGzvNyLz9EdDG2ZcDfc7BXegb9ow6snqjZ6sZ7okk
         mnp3J+iu36HNXb8GhfJU9enG9zdhNp7Xnmt7PS22mLkOS46A4mMC2Gl6FxBOhv3mre2I
         3O4A==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785962136; x=1786566936; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=BQuE5p94CfqyEpHjKQoO3ghb1Rb0W+FJ1ncrC2gXf/s=;
        b=pBiX+8t0c2sfhoLa8w/2nGJ0ZxyJlfeIr+kW1cI6ayvXIybnEecMnO8NmDUFHNOAZo
         eomhg+ki+2SZHkzpS1DAXM4SEr4TxvunY0uraBRsrcGZsyDAbSdpU4T763FqTybrRk/5
         jmjbCZUIuSND8cjPFNJZdJv1uw5HDsWLN+yz4jwFBmfBoS/BDyUl6Ue72JC/ip/3wk2w
         kFlYzntR1u4/Nry9nK/NtiY65cw1H+nbhOYtpm3XfScv8VkOXU2XZsYbZVb/jxvj2iDr
         nNFbm6wC4chTG/YCBUL6bMvbqiISmlYdC6RVad1ULg04h8p1laD9bYo3zQ7MJiQ1mpe7
         jjSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785962136; x=1786566936;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=BQuE5p94CfqyEpHjKQoO3ghb1Rb0W+FJ1ncrC2gXf/s=;
        b=jVuWbXr4OA3je+Xi/6FL/ktxR/ogeh+UX0SPSnirK6eeS/OR/n0K8Xvtj0T7Ac+eRu
         uzNEcjKHAi3/JCLG5G0LfUCu+8J1YhY1bGC/URupmdhHRoFDjUJ6T4PZ4Q4mEjHY2O/z
         DKFxXhcqqHFSKITjgeRXGIPWqNQovrwWMdHHDC/8Guk1ABJk7Ma6okFq7nDKJMwb16Z+
         KiJx54sxLonT5OnXm4VuuOhK443OuV1aZvX69ueSPUJP15I6c7lXy50lw/YatpmlCFTG
         qTUZaDywZ//98y/9bZ81pvXy/Eq67OLqon+HrGJqILKU+aZFT+ma6qF+p3Y3tOHT6ojB
         3U8Q==
X-Forwarded-Encrypted: i=1; AHgh+RqOwAWL5Kyu/yH4E9OtyP/fymTd/k0k0hx8BdTXJTlhPHnyFgHFAvpNit4n1aBGoeCUZYdgV8IHWrjP@vger.kernel.org
X-Gm-Message-State: AOJu0Yy56NNCHB2pyQXA8uivjor59y69ZYDNjMDsGU5kh600d0qM5N05
	Xx5cDETGVQc/0O/U9X3wVI4+4dWOyauOBOFmwEB8FfGsBcVL7bmqqPdl1/GSxIcqu9Opgc3Zdi/
	r6I6zxZm6Y9Ju9xwXWJ0aYf5Jm3WjU1Q=
X-Gm-Gg: AR+sD13DfLsy/aOdGTZuDW6myHvwOs990ZAbz4U/Ycr/ba/sWY1UGLfh1Pr/B/jgdL3
	UpClAYsSsGxf0TbC4YIHmPU6UARtJqy8Oq/xxzXuRvaCsSJqOhCLdMCqR0IGpGtNL9skk/DCsqJ
	q/Gnz73NCs7s0v0AXgLktatT3bcaTc3Vfw4CJ09gYYPUL6DB93YYQXQA9bEs3sFp6xV6Q44kJL7
	FKhmCt2KV2CSB46VgYKIAskI4PyfaUAeqtNggIWlGvGAXiN7wq726t3/EPCKGB8j8VO4SvVO2YQ
	iUJmj4PUgIFII7kzEkjYyu936LWKUU0nlWkaJ+lkiM5o
X-Received: by 2002:a05:6820:4c89:b0:6aa:d97f:453b with SMTP id
 006d021491bc7-6ae96f98f86mr5123270eaf.28.1785962135693; Wed, 05 Aug 2026
 13:35:35 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <cover.1785621505.git.coshi036@gmail.com> <7f988ec74b5d1135d5d67771240639e57ba9e0f4.1785621505.git.coshi036@gmail.com>
 <liddhnv7367ifj3mk5qokdax5jexltpvbtxpkqpkt6qzolv7af@zll26cngckwl>
In-Reply-To: <liddhnv7367ifj3mk5qokdax5jexltpvbtxpkqpkt6qzolv7af@zll26cngckwl>
From: Chris S <coshi036@gmail.com>
Date: Wed, 5 Aug 2026 16:35:22 -0400
X-Gm-Features: AUfX_mzdjJBKSgnSNsYzRJsmY3qVZyWC6pZRSrcY0PRBQu9JTSn19N7htgMKD1Q
Message-ID: <CACd_6n0tmOQpams--XGDWcBWA9VTKgN1QOxU9i1FbbgnNCuqyw@mail.gmail.com>
Subject: Re: [PATCH 18/19] ext4, jbd2: report fast commit write errors with BH_Write_EIO
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

Done in v2 - 'success', no set_buffer_uptodate(), and the debug messages no=
w
talk about the write rather than the buffer:

     if (success) {
                   ext4_debug("%s: Block %lld written", ...);
     } else {
                   ext4_debug("%s: Block %lld write failed", ...);
                   mark_buffer_write_io_error(bh);
     }

Both arms kept so the tracing stays symmetric; patch 21 adds the
clear_buffer_write_io_error() to the first one.

Best,
Chao

On Tue, Aug 4, 2026 at 5:07=E2=80=AFAM Jan Kara <jack@suse.cz> wrote:
>
> On Sat 01-08-26 18:01:02, Chao Shi wrote:
> > ext4_end_buffer_io_sync() is the third completion handler in this
> > series that reports a failed write by clearing BH_Uptodate, and
> > jbd2_fc_wait_bufs() is the only thing that looks at the result.
> > Convert both.
> >
> > They have to move in the same patch.  The handler lives in ext4 and
> > the wait in jbd2, but neither is used by anything else: the buffers
> > are ext4's fast commit blocks, submitted by ext4_fc_submit_bh() and
> > waited for by jbd2_fc_wait_bufs().  Converting one without the other
> > silently disables fast commit write error reporting.
> >
> > Signed-off-by: Chao Shi <coshi036@gmail.com>
> > ---
> >  fs/ext4/fast_commit.c | 2 +-
> >  fs/jbd2/journal.c     | 2 +-
> >  2 files changed, 2 insertions(+), 2 deletions(-)
> >
> > diff --git a/fs/ext4/fast_commit.c b/fs/ext4/fast_commit.c
> > index 8e2259799614..8cd60c9f2272 100644
> > --- a/fs/ext4/fast_commit.c
> > +++ b/fs/ext4/fast_commit.c
> > @@ -213,7 +213,7 @@ static void ext4_end_buffer_io_sync(struct bio *bio=
)
> >       } else {
> >               ext4_debug("%s: Block %lld not up-to-date",
> >                          __func__, bh->b_blocknr);
> > -             clear_buffer_uptodate(bh);
> > +             mark_buffer_write_io_error(bh);
> >       }
>
> Again, this is only ever used for writes and buffer is guaranteed to be
> uptodate so please rename 'uptodate' to 'ioerr' and remove the setting of
> uptodate bit as well. And the ext4_debug() messages need slight update as
> well.
>
>                                                                 Honza
>
> >
> >       unlock_buffer(bh);
> > diff --git a/fs/jbd2/journal.c b/fs/jbd2/journal.c
> > index 9e4cb04587b4..ffe7a22e6699 100644
> > --- a/fs/jbd2/journal.c
> > +++ b/fs/jbd2/journal.c
> > @@ -890,7 +890,7 @@ int jbd2_fc_wait_bufs(journal_t *journal, int num_b=
lks)
> >                * Update j_fc_off so jbd2_fc_release_bufs can release re=
main
> >                * buffer head.
> >                */
> > -             if (unlikely(!buffer_uptodate(bh))) {
> > +             if (unlikely(buffer_write_io_error(bh))) {
> >                       journal->j_fc_off =3D i + 1;
> >                       return -EIO;
> >               }
> > --
> > 2.43.0
> >
> --
> Jan Kara <jack@suse.com>
> SUSE Labs, CR
