Received: from mail-ej1-f51.google.com (mail-ej1-f51.google.com [209.85.218.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1616747D952
	for <linux-ext4@vger.kernel.org>; Thu,  2 Jul 2026 11:51:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.218.51
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782993092; cv=pass; b=SHc0f5Dg82KfZVQvhZmIEYHFwrK1N28Q1dqWQwBYkH4LlO4XcZZWSjNk0B5SVwQi+BtOELq5SUSWXr78I7T5QwcISJ6cDU0GbfcQJCtG/8E/5teulGweL0CZBnUGMljmi7+5MZTfs5o3QJEyAWwIhHp5br89D+EBJFDPGUUbSFo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782993092; c=relaxed/simple;
	bh=QdY3QtTxhXcZmdOCbMnRyJ3qIJmolYOD0cVg7FoBdDE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=gXacNem4iinFymHtHO5SZEKYparoyoXcmqs1GqtWxyI6hTmYQffEUCVZRLHuzb0/xAynhy8beFkoVN4rzKRtYhyjKJrRpbgeu4aYd4ucWgkMjSBqC9oP6G0g+OMNycGKOJ71m8m5L83jds94onHPcSDTlFwrwOzj2g0aFSrYxLo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=k7Y7V1pn; arc=pass smtp.client-ip=209.85.218.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="k7Y7V1pn"
Received: by mail-ej1-f51.google.com with SMTP id a640c23a62f3a-c126e47a82cso213568066b.2
        for <linux-ext4@vger.kernel.org>; Thu, 02 Jul 2026 04:51:26 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1782993085; cv=none;
        d=google.com; s=arc-20260327;
        b=LQtBlf+Ei+dok0K2hfxj8DQCIx/WHQu8BR7Lm+DfKpbekZJOW9IJsUShY4rmBCockA
         tC2hoYfHr6aGnokSQvtTu7bOdC2O/C/xeVTZXY0vJROozfL7VSD9KdWCHeLODxjlCii6
         m4Feu2vIxmuHpZtfVET2i5Qz7HtcAZlxKYOwLRuOyjI4j36YxpLIY3p2nK6U7DBFsF3y
         0UFS9pnsl/jyr5Evyz+mE+dDcW0u/EWsv2uoKDtl6N4S4Uw77+pcuryekKWNsfp57Wir
         bC+fRl+arQatV+wgBm54XzoXZY/7/4Pa1UoHwBXnXfcPOpMp/YbKx/kyHHrzk8bEzmjT
         3Hsw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=rWYl1v1e7JfDeU1Up89AbEhIwbWvYZRnz1jVTLTQspQ=;
        fh=i9fpAK/H+2eXsf7MNxELYeb1Qy9P2GhOHezKY/vq7Qk=;
        b=nCk216MEGFE0DU9/wbdA8jPg8geaPFUanZMLKWvmfdSJx3CMSKQ6hwCvG1uSgBLUfo
         DZFmyzWcRGc8Pe/pIgd88mBlFg2fTBaXgoTCX9d7SYCdFmdEJLn8jR35TAxYkZnL7Jie
         VLCzO41kkgeasXGVxUmqBiT2NZzdTocI71hxH/ILQWHDD839VPd17Md1wlQcZM7V35Bg
         0Fx1IfQ025e7rAhXA9DLvFYytMawAy8NUib+h1eCWOBxzrMGWYUxRZowCGhc2vn/OId9
         Ar7qAQNN3ZvKrN3vlh/44A8TXP/ZKq44cptn9Z5SmfYcVdqudZCMuyd3EhYu6iwrs/JA
         9h/w==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782993085; x=1783597885; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=rWYl1v1e7JfDeU1Up89AbEhIwbWvYZRnz1jVTLTQspQ=;
        b=k7Y7V1pna7Lnw4qeArlxPD8hVlHFl5Lm9OP5iU/bbdDudVZIStVAmgQu172l6lFRKg
         AM/+0wX0CXUuVNza63259EURQCQ1J+S25gJQvEwVOVEGL16k4zL1GbCtyl1MjM+WScI0
         Oosr7XgIc5ulw2NhWk/Jv+tDKj6bSN7fomLjii/wU7ztk/0Ym52QImRFdY+k1LVVEeKV
         8u3/xRa6mP3oSUpNXqT4mJpnJU/iI9J0WxHMqeJ5vxSesy1nB22C/LHDyWmy/zsKWTt/
         3EVIb4t14BDvkIpFFnt2bzmgOQrUUxp2s6JXXUM9Uj8N0x+Swwq82FkJ/lJS+WIiKNJ4
         EqVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782993085; x=1783597885;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=rWYl1v1e7JfDeU1Up89AbEhIwbWvYZRnz1jVTLTQspQ=;
        b=T/Je00ngUIeQ0pmNZZNYZzqRbHDfXQMBaiotMeieq4gka4c83cSnQJWmGyNWlAZKPr
         fDPEauJQewkHEO1gPKWkL5cM+GoRzcqjQMxs6YCdbp7oMy4XMTybwXBTOPehCunEn2Li
         yPQQjQKWsY9awEwRTpZkNXBLRcHQ1EIbO0BdaLuHVCKvHq3ANrGOq2npuJZD307aHOdj
         KX7doYobugy8M/XrUs2nrFTysyhaBYxevDwpFy0+uiqjutByr/zVJG7xnK5miytZ0k+c
         lFZf7c+qxSEb1yLl5xTutnoiGX4LKc5nbaaHMIX2GkMak+5ZLAmGHotgoKQ5u/3Kw6nQ
         K/Xg==
X-Forwarded-Encrypted: i=1; AHgh+Rqv8iumOiUY9M/2ywCzs94RqLRnK5xYWdY9FV8Q7X9h581HA6OqTV8t7Emmec3Y7VvlLAk2/40V5irL@vger.kernel.org
X-Gm-Message-State: AOJu0YxqB6Q+2JqWT1AvE17jHJcpykHjPFURNqql18FPY/BQRmt5MJL0
	XNFbMkUWca/0bXwPDYZeQFA3XgR6JdpriSVET7zFgNkU+1RxPQw2FFDzDOyCKpbCybpIDcRM8Li
	NUX3Aqd8ePc8as+HCm7Ceh1RyNAgGVt8=
X-Gm-Gg: AfdE7ckkzM29tkI0HfVUpovhphFt72k2RxdI2tYWWKKda8wqktrCTN28FWsGS9BWDKg
	pLay+VYIR4YPFYiOGdLgLLgSjJ+x2/tHsdtBla++Ln5LNqOP3IXhYLyg4gOB19YIX+ujP0pTQx8
	jnBwbkqUbloYeU99ajPpZjJHm43S2AeIt6RZ5Y7EMQUCW8lkIwd3IO+B/oaqs2LCFTrGl1qFMTD
	87rtR+hM/J45dhHdC+lQndDlQ8eu0Mz6KjJc5UB5yInSnwZwr3vXGk+T1NU3ttClpumewGOPnXd
	s5uc7P5qpzm+o/6m0EYOBxBUgffGaqw=
X-Received: by 2002:a17:906:ba83:b0:c12:6d25:2c7a with SMTP id
 a640c23a62f3a-c12a9d7713emr283017866b.17.1782993084875; Thu, 02 Jul 2026
 04:51:24 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260702050724.1658-1-aditya.ansh182@gmail.com>
 <3sbocdflzeajcievmbdwprrgzkztd7ogn7mmjx4quptorotwak@rlzklako3yht>
 <CAK5ssPOM-rddJR6=QJ4RSCeQvamKKAbJS+NCOLbsC2eSODydkQ@mail.gmail.com> <zwfhyqxdxfigm5nced3hgsp4mygwxgwc4cxzeyl7glrmie73rm@r66bdrw7fjsj>
In-Reply-To: <zwfhyqxdxfigm5nced3hgsp4mygwxgwc4cxzeyl7glrmie73rm@r66bdrw7fjsj>
From: Aditya Prakash Srivastava <aditya.ansh182@gmail.com>
Date: Thu, 2 Jul 2026 17:21:12 +0530
X-Gm-Features: AVVi8CdYWqDQukbaQHEE63oU1BuenfjNBCFzhjf6Pjyz8BydGBgw34S5x0ChiuY
Message-ID: <CAK5ssPPPfkL889aCK_z9EnDNbKBuHRQd45uLzXpeUVrVkFkzbw@mail.gmail.com>
Subject: Re: [PATCH v2] ext4: use fsdata to track inline data write state and
 fix race
To: Jan Kara <jack@suse.cz>
Cc: "Theodore Ts'o" <tytso@mit.edu>, Andreas Dilger <adilger.kernel@dilger.ca>, 
	Baokun Li <libaokun@linux.alibaba.com>, Ojaswin Mujoo <ojaswin@linux.ibm.com>, 
	Ritesh Harjani <ritesh.list@gmail.com>, Zhang Yi <yi.zhang@huawei.com>, Tao Ma <boyu.mt@taobao.com>, 
	syzbot+0c89d865531d053abb2d@syzkaller.appspotmail.com, 
	linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Thank You Jan for your valuable inputs. As you pointed out,
CONVERT_INLINE_DATA indeed becomes unused. I will be doing
that cleanup once we sort this one out.

Coming back to this patch, I will incorporate the suggestions, test it
and will send the next revision of this patch. I agree that
interactions with FALL_BACK_TO_NONDELALLOC introduce
unnecessary cross-over of two independent paths and should be
avoided altogether.

Thanks,
Aditya

On Thu, Jul 2, 2026 at 5:04=E2=80=AFPM Jan Kara <jack@suse.cz> wrote:
>
> Hi Aditya!
>
> On Thu 02-07-26 16:19:56, Aditya Prakash Srivastava wrote:
> > I have been thinking about the VFS retry case where if we do
> > not reset the fsdata, we might end up in an infinite loop.
>
> Indeed, good spotting. I have also realized that after your patch
> CONVERT_INLINE_DATA is effectively unused and can be deleted along with
> passing fsdata to ext4_generic_write_inline_data() and
> ext4_da_convert_inline_data_to_extent(). So that would be a good cleanup
> patch on top of your fix.
>
> > The proposed fix from my side is to reintroduce setting
> > fsdata =3D NULL in the beginning of ext4_write_begin,
> > of course we should be careful not to overwrite it if it
> > has some other value. Sample code like below
> >
> > if (unlikely(ret))
> > return ret;
> >
> > /*
> >  * Reset fsdata for a vfs retry case
> > */
> > if (*fsdata !=3D (void *)FALL_BACK_TO_NONDELALLOC)
> > *fsdata =3D NULL;
>
> Hum, thinking more about this I think we should use fsdata more as flags
> than enum. So ext4_write_begin() should be doing
>
>   *fsdata =3D (void *)((unsigned long)*fsdata | EXT4_WRITE_DATA_INLINE);
>
> and ext4_write_end() should be doing (unconditionally on exit):
>
>   *fsdata =3D (void *)((unsigned long)*fsdata & ~EXT4_WRITE_DATA_INLINE);
>
> to unroll the state back. Otherwise the interactions with
> FALL_BACK_TO_NONDELALLOC and delalloc path get too tedious to verify and
> they *are* in fact independent states of the write path.
>
>                                                                 Honza
>
> >
> > trace_ext4_write_begin(inode, pos, len);
> > /*
> >  * Reserve one block more for addition to orphan list in case
> >
> > This should take care of the retry case not getting into
> > an infinite loop.
> > What do you think? I shall send you a revised version if we
> > agree on this.
> >
> > Thanks,
> > Aditya
> >
> > On Thu, Jul 2, 2026 at 4:05=E2=80=AFPM Jan Kara <jack@suse.cz> wrote:
> > >
> > > On Thu 02-07-26 05:07:24, Aditya Srivastava wrote:
> > > > From: Aditya Prakash Srivastava <aditya.ansh182@gmail.com>
> > > >
> > > > Instead of checking the live inode state (ext4_has_inline_data(inod=
e)
> > > > and ext4_test_inode_state(inode, EXT4_STATE_MAY_INLINE_DATA)) in th=
e
> > > > write_end handlers, use the fsdata parameter of the address space
> > > > operations to explicitly pass down the state in which write_begin
> > > > prepared the write.
> > > >
> > > > A concurrent thread (such as ext4_page_mkwrite()) can convert the
> > > > inline data to an extent between write_begin and write_end. If this
> > > > happens, the write_end handlers would previously miss the inline
> > > > write_end path and fall through to extent-based write_end logic.
> > > > However, since block buffers were never allocated in write_begin,
> > > > this resulted in NULL pointer dereferences or data loss because
> > > > folio_buffers(folio) was NULL.
> > > >
> > > > Define EXT4_WRITE_DATA_INLINE (3) and communicate this state via
> > > > fsdata:
> > > > 1) ext4_write_begin() and ext4_da_write_begin() explicitly set
> > > >    *fsdata to EXT4_WRITE_DATA_INLINE when an inline write is
> > > >    successfully prepared.
> > > > 2) ext4_write_end(), ext4_journalled_write_end(), and
> > > >    ext4_da_write_end() rely solely on fsdata / write_mode to
> > > >    invoke ext4_write_inline_data_end().
> > > >
> > > > Furthermore, during a buffered write, ext4_write_inline_data_end()
> > > > acquires the xattr lock after preparing the write. If a concurrent
> > > > page fault (ext4_page_mkwrite()) converts the inline data to an ext=
ent
> > > > after the write_end handlers check the state but before
> > > > ext4_write_inline_data_end() acquires the xattr write lock, the
> > > > subsequent check will trigger a kernel panic via
> > > > BUG_ON(!ext4_has_inline_data(inode)).
> > > >
> > > > Replace the BUG_ON check in ext4_write_inline_data_end() with a gra=
ceful
> > > > error-handling retry path. If the inline data is cleared after lock=
ing
> > > > the xattr, we safely release all resources (releasing iloc.bh,
> > > > unlocking/putting the folio, stopping the active journal transactio=
n
> > > > handle) and return 0 (VFS retry) to let the generic write path retr=
y
> > > > the operation safely.
> > > >
> > > > Reported-by: syzbot+0c89d865531d053abb2d@syzkaller.appspotmail.com
> > > > Closes: https://syzkaller.appspot.com/bug?extid=3D0c89d865531d053ab=
b2d
> > > > Fixes: 3fdcfb668fd7 ("ext4: add journalled write support for inline=
 data")
> > > > Suggested-by: Jan Kara <jack@suse.cz>
> > > > Signed-off-by: Aditya Prakash Srivastava <aditya.ansh182@gmail.com>
> > >
> > > Looks good! Feel free to add:
> > >
> > > Reviewed-by: Jan Kara <jack@suse.cz>
> > >
> > >                                                                 Honza
> > >
> > > > ---
> > > > Changes in v2:
> > > > - Folded the BUG_ON fix from the second patch into the first one to
> > > >   ensure bisectability across git history, as suggested by Jan Kara=
.
> > > > - Removed the pointless initialization `*fsdata =3D NULL` on entry =
to
> > > >   `ext4_write_begin()`.
> > > > - Removed the redundant check `if (fsdata)` in `ext4_write_begin()`=
.
> > > >
> > > >  fs/ext4/ext4.h   |  1 +
> > > >  fs/ext4/inline.c | 14 +++++++++++++-
> > > >  fs/ext4/inode.c  | 18 +++++++++---------
> > > >  3 files changed, 23 insertions(+), 10 deletions(-)
> > > >
> > > > diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
> > > > index b37c136ea3ab..521bd5d6321c 100644
> > > > --- a/fs/ext4/ext4.h
> > > > +++ b/fs/ext4/ext4.h
> > > > @@ -3138,6 +3138,7 @@ int do_journal_get_write_access(handle_t *han=
dle, struct inode *inode,
> > > >  void ext4_set_inode_mapping_order(struct inode *inode);
> > > >  #define FALL_BACK_TO_NONDELALLOC 1
> > > >  #define CONVERT_INLINE_DATA   2
> > > > +#define EXT4_WRITE_DATA_INLINE        3
> > > >
> > > >  typedef enum {
> > > >       EXT4_IGET_NORMAL =3D      0,
> > > > diff --git a/fs/ext4/inline.c b/fs/ext4/inline.c
> > > > index 8045e4ff270c..cfd591dc1d9c 100644
> > > > --- a/fs/ext4/inline.c
> > > > +++ b/fs/ext4/inline.c
> > > > @@ -812,7 +812,19 @@ int ext4_write_inline_data_end(struct inode *i=
node, loff_t pos, unsigned len,
> > > >                       goto out;
> > > >               }
> > > >               ext4_write_lock_xattr(inode, &no_expand);
> > > > -             BUG_ON(!ext4_has_inline_data(inode));
> > > > +             /*
> > > > +              * We could have raced with ext4_page_mkwrite() conve=
rting
> > > > +              * the inode and clearing the inline data flag, so we=
 just
> > > > +              * release resources and retry the whole write.
> > > > +              */
> > > > +             if (unlikely(!ext4_has_inline_data(inode))) {
> > > > +                     ext4_write_unlock_xattr(inode, &no_expand);
> > > > +                     brelse(iloc.bh);
> > > > +                     folio_unlock(folio);
> > > > +                     folio_put(folio);
> > > > +                     ext4_journal_stop(handle);
> > > > +                     return 0;
> > > > +             }
> > > >
> > > >               /*
> > > >                * ei->i_inline_off may have changed since
> > > > diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
> > > > index ce99807c5f5b..d3d9e1999670 100644
> > > > --- a/fs/ext4/inode.c
> > > > +++ b/fs/ext4/inode.c
> > > > @@ -1316,8 +1316,10 @@ static int ext4_write_begin(const struct kio=
cb *iocb,
> > > >                                                   foliop);
> > > >               if (ret < 0)
> > > >                       return ret;
> > > > -             if (ret =3D=3D 1)
> > > > +             if (ret =3D=3D 1) {
> > > > +                     *fsdata =3D (void *)EXT4_WRITE_DATA_INLINE;
> > > >                       return 0;
> > > > +             }
> > > >       }
> > > >
> > > >       /*
> > > > @@ -1450,8 +1452,7 @@ static int ext4_write_end(const struct kiocb =
*iocb,
> > > >
> > > >       trace_ext4_write_end(inode, pos, len, copied);
> > > >
> > > > -     if (ext4_has_inline_data(inode) &&
> > > > -         ext4_test_inode_state(inode, EXT4_STATE_MAY_INLINE_DATA))
> > > > +     if (fsdata =3D=3D (void *)EXT4_WRITE_DATA_INLINE)
> > > >               return ext4_write_inline_data_end(inode, pos, len, co=
pied,
> > > >                                                 folio);
> > > >
> > > > @@ -1560,8 +1561,7 @@ static int ext4_journalled_write_end(const st=
ruct kiocb *iocb,
> > > >
> > > >       BUG_ON(!ext4_handle_valid(handle));
> > > >
> > > > -     if (ext4_has_inline_data(inode) &&
> > > > -         ext4_test_inode_state(inode, EXT4_STATE_MAY_INLINE_DATA))
> > > > +     if (fsdata =3D=3D (void *)EXT4_WRITE_DATA_INLINE)
> > > >               return ext4_write_inline_data_end(inode, pos, len, co=
pied,
> > > >                                                 folio);
> > > >
> > > > @@ -3161,8 +3161,10 @@ static int ext4_da_write_begin(const struct =
kiocb *iocb,
> > > >                                                    foliop, fsdata, =
true);
> > > >               if (ret < 0)
> > > >                       return ret;
> > > > -             if (ret =3D=3D 1)
> > > > +             if (ret =3D=3D 1) {
> > > > +                     *fsdata =3D (void *)EXT4_WRITE_DATA_INLINE;
> > > >                       return 0;
> > > > +             }
> > > >       }
> > > >
> > > >  retry:
> > > > @@ -3299,9 +3301,7 @@ static int ext4_da_write_end(const struct kio=
cb *iocb,
> > > >
> > > >       trace_ext4_da_write_end(inode, pos, len, copied);
> > > >
> > > > -     if (write_mode !=3D CONVERT_INLINE_DATA &&
> > > > -         ext4_test_inode_state(inode, EXT4_STATE_MAY_INLINE_DATA) =
&&
> > > > -         ext4_has_inline_data(inode))
> > > > +     if (write_mode =3D=3D EXT4_WRITE_DATA_INLINE)
> > > >               return ext4_write_inline_data_end(inode, pos, len, co=
pied,
> > > >                                                 folio);
> > > >
> > > > --
> > > > 2.47.3
> > > >
> > > --
> > > Jan Kara <jack@suse.com>
> > > SUSE Labs, CR
> --
> Jan Kara <jack@suse.com>
> SUSE Labs, CR
