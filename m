Received: from mail-ej1-f44.google.com (mail-ej1-f44.google.com [209.85.218.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 461FB3C09E9
	for <linux-ext4@vger.kernel.org>; Thu,  2 Jul 2026 10:50:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.218.44
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782989412; cv=pass; b=KUWM82fu7m9HXJmqoVd1akbzk4lBspLWi3azCriay3Vfl8w8wUv9DPvJeuCSXGQMI3+XSV/t8jy8gca85oTWM0mfx/pzt/fwJq7xb1Ht3A2klCgiuvjZ6uq4XtI7Ne9g+tyAIEG6KO93Ccj52i3rOo6q+oAyLH+Sr/GsAMjrIvM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782989412; c=relaxed/simple;
	bh=nRVQORHH+waSKM7nYm/jWn8Tmrr2vTYPhG0zxKHb4As=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=YW5OT7C0ShKx0L59BMlVxU20MJAU6DisCJKl1r9eO5XOoltsejcnlYrr4uqg3hrEwb7/q1ftoponQM0EOiNraraXUKp6ow4vWBtYBMPLJO1H5VDJMAd9X+9oI3gOykWgtRhjEI6UyP2EeaUbTEoDagrzyD2qdmZb9IhTc710Sjs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Wz4Mzk1b; arc=pass smtp.client-ip=209.85.218.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Wz4Mzk1b"
Received: by mail-ej1-f44.google.com with SMTP id a640c23a62f3a-c12a1a3cdb9so154310066b.0
        for <linux-ext4@vger.kernel.org>; Thu, 02 Jul 2026 03:50:09 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1782989408; cv=none;
        d=google.com; s=arc-20260327;
        b=mu2NdwsQcmdzaP3y9YWapP+b/4t6sda4kYAa/M4icp8lfgYUBlSAA/KFPy+6oZQGH/
         aLLIFXlGJDbKWO6LoNhdJEzH/uLCeT3HEkmtaDnOEMHpdx/NxXPLP0ZZWXz7GP+rVxs1
         lDngv1PLhEFTedagfJAwDAJcneqgTYkN0CczxMPgn8F3u/BNII+ZFiPMqpsGcC6w35wf
         SEEYt6lcOS2yvvaCFr2CsHnuTFuxiR8hLPYddTZ9ukdsJwl8hKcECmbVQRhpQJyGL+zo
         lMDdK2cdXRwOblmkUjdhOYeOKfkwm66FHXSKon7mcf9hvbWlZ6O08AyCV7K0pHEBpZ+P
         1GwA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=bi73C6N4+DnOk6f4jrg/1UNCT/tKhKZx1/6Zk1LhCdk=;
        fh=6Kf3oLuvf60opiUUrgI1+fm6cDKQXMAsXzczZ/Mq03Q=;
        b=MQ94J6wUJnDhUyF4GL/cGy4Ox4ar7O5BWB26qdk9IC5I+bdsrf8SZXluBD3iE28G1u
         rJHwGsIh3pMZO9vobwdHvej2IG5rdOkPm3o0uLIKLZQHSLTx5Xeew2d+ve4/nWKph1d4
         r+TpcBFzIdemsZKRkBnbLzkavedG6hae2i9uovv2ePfFbriEzCeeKk1sUZwJUqWquLXW
         vrm31DW44EOa4KIyObWxEAtVQdRLeev7tCu3Rya3MnP5Du54zhKS0E/yhAPWBrXEy6bU
         GgHb2UsQUz5h5gmSIdx++fU7kSq+lzXokU7t5EhXqpwnoMOpXgD+1Wm7Y6iSi9t/6UmP
         z39g==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782989408; x=1783594208; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=bi73C6N4+DnOk6f4jrg/1UNCT/tKhKZx1/6Zk1LhCdk=;
        b=Wz4Mzk1bIhDk1GQMWWCVZMqIGZDNQVclutE9zdhkIUPaXrMOWaCuep4ueBph/VtCc5
         I1sB8rbZiuoE9iJfOQdVvE3LyzwKBhxx6ZWZQK4GLhFUp785heytkxFFBt4PLvt6I2Fa
         rJBqMohHasMCWsBLq8JSTUZ8yogPvrRd7m3ZnApZpx9qzK77XQwZb0tWdiv4i5hDqVkg
         gCczIoDTOv0n2/kBoEjOC0xKkaQdnIrjTqUOfdqj801Urtg0w7yNJDdsgKcn3XsK3AqI
         fBLQehYqsw6GaXnZ1EcNWkjZj2lV7bLW9NBFzzPXQjsu3dKBkX4aoG66IUnc26ecJ4hT
         Ybkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782989408; x=1783594208;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=bi73C6N4+DnOk6f4jrg/1UNCT/tKhKZx1/6Zk1LhCdk=;
        b=Ra/Wn1Saw7xPTq6oO5qg1V1kBCiOSxJN3Z78JvHat7IOLpD+wDRI38nd5ycqSY2e91
         Yyf5JhyAZ59J08zF8wUwmXtKQy4zo3EPVGBc7pHjymXZquZL1LcjiekM1xvUIoSpudZ2
         L8IEIiYL6R9KQ4v6IlHfN2010WewXE2PEvKP5l4oZjAqyMaPjBqqqTGAiMPfqM6GNfXA
         2LK9v9DxoeERh6UfDEk026ihekoKwQbpChgOJfJPPfo6mN8YsRkgzU5f3ssOpvGCtBTH
         4Zz2FIEa2FY+gHe4Cw7BYgI/nI1GkV4OAeUtC+CEbYPUFxe/6mB0AqHmlAaMmLNZJGxr
         3qXw==
X-Forwarded-Encrypted: i=1; AHgh+RrIXc9hSniqOM0KubCo6KvQyKPbuAnJvpXbMMdboGECe2YXIFeBxqTZGOvZuaqk7lLgSzik0JW85Zmb@vger.kernel.org
X-Gm-Message-State: AOJu0YyVxRhudJYNY3vqrk10NfinWarB2s3QOYGvjdN5Xu4QLfCZtcL9
	/YhNxkcS1TgVMAQsK0UqKe8qMEvyvr2stxV6a2iyj3FS/3g9NKOIudQ55MqRCShv5fiOyW0qS/c
	AdBtDyTqX02XDj2wJdpCD/fHauTLcdv8=
X-Gm-Gg: AfdE7cm0DdVGkFLE9r+sG1ZisWTwVX2GeqTtwyaD0ToBE2yVMTlZvfsB8zuYrhFy4zY
	OJ3TpJ2p+zDp17gal8UeW4z2MIM8JEm3kSYp7SwUwKYFO93PBr0eivw9Py7JKKqRJLXuA2mgQGS
	Huv+Xkdb5mjKh735HpqRI2fZfwuMVHcLRdphlnfJEvi8i6CdGPETiAmI5uY7/3b9vmFMx8d5KJv
	28+A1qy3Sbc2AgDNd35VKqUE3SZ6xTMiYTx5SK04gd0U6f8iAXxJPmymfZlGdrKA1e6/q6hgDR4
	48wPGiulGwSz7SdGG49YrXLThrJonDk=
X-Received: by 2002:a17:906:ae0e:b0:c12:9eb4:48bd with SMTP id
 a640c23a62f3a-c12ae72fc90mr164727266b.50.1782989408050; Thu, 02 Jul 2026
 03:50:08 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260702050724.1658-1-aditya.ansh182@gmail.com> <3sbocdflzeajcievmbdwprrgzkztd7ogn7mmjx4quptorotwak@rlzklako3yht>
In-Reply-To: <3sbocdflzeajcievmbdwprrgzkztd7ogn7mmjx4quptorotwak@rlzklako3yht>
From: Aditya Prakash Srivastava <aditya.ansh182@gmail.com>
Date: Thu, 2 Jul 2026 16:19:56 +0530
X-Gm-Features: AVVi8Ccql2TyDF2-A-t19H3z8y7I5hQGpn6x2NA4nJaDHzITMgwuuJw19BPJ9T8
Message-ID: <CAK5ssPOM-rddJR6=QJ4RSCeQvamKKAbJS+NCOLbsC2eSODydkQ@mail.gmail.com>
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

Hi Jan,

I have been thinking about the VFS retry case where if we do
not reset the fsdata, we might end up in an infinite loop.

See below

________________________________

Phase 1: Preparing the inline write (Thread 1)

VFS entry: Userspace calls write(). The kernel enters
generic_perform_write().

Setup: VFS defines void *fsdata =3D NULL on the stack.

Begin: ext4_write_begin() is invoked.

The file is inline, so it prepares an inline write.

It sets *fsdata =3D (void *)EXT4_WRITE_DATA_INLINE.

It returns success (0).

Data copy: VFS copies the userspace data into the page/folio.

________________________________

Phase 2: The race and inline conversion (Thread 2)

Concurrent conversion: While Thread 1 is preparing the write,
Thread 2 triggers a page fault (ext4_page_mkwrite()).

Conversion complete: Thread 2 converts the inode from inline
data to standard extents, clearing
EXT4_STATE_MAY_INLINE_DATA and the inode's inline-data
flag.

________________________________

Phase 3: write_end() and the first retry (Thread 1)

End attempt: VFS calls ext4_write_end().

Inline path: ext4_write_end() sees
fsdata =3D=3D EXT4_WRITE_DATA_INLINE and routes the write to
ext4_write_inline_data_end().

Conversion detected: ext4_write_inline_data_end() acquires
the xattr lock and checks ext4_has_inline_data(inode).

Since Thread 2 converted the file, the check returns
false.

Retry requested: ext4_write_inline_data_end() releases its
locks/resources and returns 0, telling the VFS that the
write should be retried from the beginning.

________________________________

Phase 4: The VFS retry and the bug (Thread 1)

Retry: generic_perform_write() receives 0 and executes
goto retry;.

Stale fsdata: The retry: label is after the
fsdata =3D NULL initialization. Therefore:

fsdata is not reset to NULL.

It still contains EXT4_WRITE_DATA_INLINE.

Second begin: ext4_write_begin() is called again.

Since *fsdata =3D NULL was removed from
ext4_write_begin(), *fsdata is left unchanged and
still contains EXT4_WRITE_DATA_INLINE.

Since the file is no longer inline,
ext4_write_begin() prepares a normal extent-based
write.

Second end: VFS calls ext4_write_end().

It checks whether
fsdata =3D=3D EXT4_WRITE_DATA_INLINE.

Although this write was prepared as an extent write,
the check is still true because fsdata is stale.

Loop closes: ext4_write_end() incorrectly routes the write
to ext4_write_inline_data_end() again.

It acquires the xattr lock, sees that the inode no
longer contains inline data, releases its resources,
and returns 0 again.

Infinite loop: VFS jumps back to retry:. Since fsdata is
never cleared, the same sequence repeats indefinitely.
________________________________

The proposed fix from my side is to reintroduce setting
fsdata =3D NULL in the beginning of ext4_write_begin,
of course we should be careful not to overwrite it if it
has some other value. Sample code like below

if (unlikely(ret))
return ret;

/*
 * Reset fsdata for a vfs retry case
*/
if (*fsdata !=3D (void *)FALL_BACK_TO_NONDELALLOC)
*fsdata =3D NULL;

trace_ext4_write_begin(inode, pos, len);
/*
 * Reserve one block more for addition to orphan list in case

This should take care of the retry case not getting into
an infinite loop.
What do you think? I shall send you a revised version if we
agree on this.

Thanks,
Aditya

On Thu, Jul 2, 2026 at 4:05=E2=80=AFPM Jan Kara <jack@suse.cz> wrote:
>
> On Thu 02-07-26 05:07:24, Aditya Srivastava wrote:
> > From: Aditya Prakash Srivastava <aditya.ansh182@gmail.com>
> >
> > Instead of checking the live inode state (ext4_has_inline_data(inode)
> > and ext4_test_inode_state(inode, EXT4_STATE_MAY_INLINE_DATA)) in the
> > write_end handlers, use the fsdata parameter of the address space
> > operations to explicitly pass down the state in which write_begin
> > prepared the write.
> >
> > A concurrent thread (such as ext4_page_mkwrite()) can convert the
> > inline data to an extent between write_begin and write_end. If this
> > happens, the write_end handlers would previously miss the inline
> > write_end path and fall through to extent-based write_end logic.
> > However, since block buffers were never allocated in write_begin,
> > this resulted in NULL pointer dereferences or data loss because
> > folio_buffers(folio) was NULL.
> >
> > Define EXT4_WRITE_DATA_INLINE (3) and communicate this state via
> > fsdata:
> > 1) ext4_write_begin() and ext4_da_write_begin() explicitly set
> >    *fsdata to EXT4_WRITE_DATA_INLINE when an inline write is
> >    successfully prepared.
> > 2) ext4_write_end(), ext4_journalled_write_end(), and
> >    ext4_da_write_end() rely solely on fsdata / write_mode to
> >    invoke ext4_write_inline_data_end().
> >
> > Furthermore, during a buffered write, ext4_write_inline_data_end()
> > acquires the xattr lock after preparing the write. If a concurrent
> > page fault (ext4_page_mkwrite()) converts the inline data to an extent
> > after the write_end handlers check the state but before
> > ext4_write_inline_data_end() acquires the xattr write lock, the
> > subsequent check will trigger a kernel panic via
> > BUG_ON(!ext4_has_inline_data(inode)).
> >
> > Replace the BUG_ON check in ext4_write_inline_data_end() with a gracefu=
l
> > error-handling retry path. If the inline data is cleared after locking
> > the xattr, we safely release all resources (releasing iloc.bh,
> > unlocking/putting the folio, stopping the active journal transaction
> > handle) and return 0 (VFS retry) to let the generic write path retry
> > the operation safely.
> >
> > Reported-by: syzbot+0c89d865531d053abb2d@syzkaller.appspotmail.com
> > Closes: https://syzkaller.appspot.com/bug?extid=3D0c89d865531d053abb2d
> > Fixes: 3fdcfb668fd7 ("ext4: add journalled write support for inline dat=
a")
> > Suggested-by: Jan Kara <jack@suse.cz>
> > Signed-off-by: Aditya Prakash Srivastava <aditya.ansh182@gmail.com>
>
> Looks good! Feel free to add:
>
> Reviewed-by: Jan Kara <jack@suse.cz>
>
>                                                                 Honza
>
> > ---
> > Changes in v2:
> > - Folded the BUG_ON fix from the second patch into the first one to
> >   ensure bisectability across git history, as suggested by Jan Kara.
> > - Removed the pointless initialization `*fsdata =3D NULL` on entry to
> >   `ext4_write_begin()`.
> > - Removed the redundant check `if (fsdata)` in `ext4_write_begin()`.
> >
> >  fs/ext4/ext4.h   |  1 +
> >  fs/ext4/inline.c | 14 +++++++++++++-
> >  fs/ext4/inode.c  | 18 +++++++++---------
> >  3 files changed, 23 insertions(+), 10 deletions(-)
> >
> > diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
> > index b37c136ea3ab..521bd5d6321c 100644
> > --- a/fs/ext4/ext4.h
> > +++ b/fs/ext4/ext4.h
> > @@ -3138,6 +3138,7 @@ int do_journal_get_write_access(handle_t *handle,=
 struct inode *inode,
> >  void ext4_set_inode_mapping_order(struct inode *inode);
> >  #define FALL_BACK_TO_NONDELALLOC 1
> >  #define CONVERT_INLINE_DATA   2
> > +#define EXT4_WRITE_DATA_INLINE        3
> >
> >  typedef enum {
> >       EXT4_IGET_NORMAL =3D      0,
> > diff --git a/fs/ext4/inline.c b/fs/ext4/inline.c
> > index 8045e4ff270c..cfd591dc1d9c 100644
> > --- a/fs/ext4/inline.c
> > +++ b/fs/ext4/inline.c
> > @@ -812,7 +812,19 @@ int ext4_write_inline_data_end(struct inode *inode=
, loff_t pos, unsigned len,
> >                       goto out;
> >               }
> >               ext4_write_lock_xattr(inode, &no_expand);
> > -             BUG_ON(!ext4_has_inline_data(inode));
> > +             /*
> > +              * We could have raced with ext4_page_mkwrite() convertin=
g
> > +              * the inode and clearing the inline data flag, so we jus=
t
> > +              * release resources and retry the whole write.
> > +              */
> > +             if (unlikely(!ext4_has_inline_data(inode))) {
> > +                     ext4_write_unlock_xattr(inode, &no_expand);
> > +                     brelse(iloc.bh);
> > +                     folio_unlock(folio);
> > +                     folio_put(folio);
> > +                     ext4_journal_stop(handle);
> > +                     return 0;
> > +             }
> >
> >               /*
> >                * ei->i_inline_off may have changed since
> > diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
> > index ce99807c5f5b..d3d9e1999670 100644
> > --- a/fs/ext4/inode.c
> > +++ b/fs/ext4/inode.c
> > @@ -1316,8 +1316,10 @@ static int ext4_write_begin(const struct kiocb *=
iocb,
> >                                                   foliop);
> >               if (ret < 0)
> >                       return ret;
> > -             if (ret =3D=3D 1)
> > +             if (ret =3D=3D 1) {
> > +                     *fsdata =3D (void *)EXT4_WRITE_DATA_INLINE;
> >                       return 0;
> > +             }
> >       }
> >
> >       /*
> > @@ -1450,8 +1452,7 @@ static int ext4_write_end(const struct kiocb *ioc=
b,
> >
> >       trace_ext4_write_end(inode, pos, len, copied);
> >
> > -     if (ext4_has_inline_data(inode) &&
> > -         ext4_test_inode_state(inode, EXT4_STATE_MAY_INLINE_DATA))
> > +     if (fsdata =3D=3D (void *)EXT4_WRITE_DATA_INLINE)
> >               return ext4_write_inline_data_end(inode, pos, len, copied=
,
> >                                                 folio);
> >
> > @@ -1560,8 +1561,7 @@ static int ext4_journalled_write_end(const struct=
 kiocb *iocb,
> >
> >       BUG_ON(!ext4_handle_valid(handle));
> >
> > -     if (ext4_has_inline_data(inode) &&
> > -         ext4_test_inode_state(inode, EXT4_STATE_MAY_INLINE_DATA))
> > +     if (fsdata =3D=3D (void *)EXT4_WRITE_DATA_INLINE)
> >               return ext4_write_inline_data_end(inode, pos, len, copied=
,
> >                                                 folio);
> >
> > @@ -3161,8 +3161,10 @@ static int ext4_da_write_begin(const struct kioc=
b *iocb,
> >                                                    foliop, fsdata, true=
);
> >               if (ret < 0)
> >                       return ret;
> > -             if (ret =3D=3D 1)
> > +             if (ret =3D=3D 1) {
> > +                     *fsdata =3D (void *)EXT4_WRITE_DATA_INLINE;
> >                       return 0;
> > +             }
> >       }
> >
> >  retry:
> > @@ -3299,9 +3301,7 @@ static int ext4_da_write_end(const struct kiocb *=
iocb,
> >
> >       trace_ext4_da_write_end(inode, pos, len, copied);
> >
> > -     if (write_mode !=3D CONVERT_INLINE_DATA &&
> > -         ext4_test_inode_state(inode, EXT4_STATE_MAY_INLINE_DATA) &&
> > -         ext4_has_inline_data(inode))
> > +     if (write_mode =3D=3D EXT4_WRITE_DATA_INLINE)
> >               return ext4_write_inline_data_end(inode, pos, len, copied=
,
> >                                                 folio);
> >
> > --
> > 2.47.3
> >
> --
> Jan Kara <jack@suse.com>
> SUSE Labs, CR
