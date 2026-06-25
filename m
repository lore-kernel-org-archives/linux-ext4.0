Received: from mail-ej1-f41.google.com (mail-ej1-f41.google.com [209.85.218.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49AB93ADBAF
	for <linux-ext4@vger.kernel.org>; Thu, 25 Jun 2026 11:10:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.218.41
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782385813; cv=pass; b=k2xpGiWF/fU+4zDRzhHnYJOAOfZy/XryqzurtQBvd+CpQd/ZN17E8nwDmuIhuddtGu1TOBzVxzvNW9Tqz+lO3qzXxnytZ7C4FE6hUK4xvrw/22LOOjggAzzI/F+T+67ACcM506xlBh/mvKWMMmgVB+Z5VDQrhCSs1mGomlsviB8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782385813; c=relaxed/simple;
	bh=j7/JQbqIo0uqw2PZavGTbtGwk9Tr0zX0P5efL+FDgrQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=cRiGI3ZRlZh1wYvc6xkxJ3Vkfa4zfWaoC56hpOvWDspPEWRBOJnHiqcQIdip4SfdObESf2lu4LYNa8QFph/FlGbhJjkQrTjFR6IS+8TGTkMnLYhSTCGFk1YL247AlPGM5kT1MsCo+pEO1IV40m6itHgvC1rFKvDcuBnU7nyuxtA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=r0FQzYoH; arc=pass smtp.client-ip=209.85.218.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="r0FQzYoH"
Received: by mail-ej1-f41.google.com with SMTP id a640c23a62f3a-c03a466c96aso34520966b.3
        for <linux-ext4@vger.kernel.org>; Thu, 25 Jun 2026 04:10:11 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1782385810; cv=none;
        d=google.com; s=arc-20260327;
        b=kRJOp+J/pQOAjLasM1tdTjoyl/R6PainwhfWvazeLOiLarbtxkSsZUEa7pG2SK6ZCU
         KYZVEJc/maiyO0f3TIEJlu09c0C4RS6vVi52CFkjDdcL8yPiuMsIyAN0tzSAvluFDVCA
         Bwn/BSg+nKE6vHEl0R+PBcvVqTQCOn9r0NwOEY+2J6MYsixnWksGZogUy5Ku/YJDdY2P
         G66BWKJfuSQwaQT4MaL3+CteoJBVGZ1LsFmWbTIj+xt96jZkYce8vu4nPyci48iCrRTo
         T9uhqtRlHqVxWyDpnf6bPyRBD0fUWHCmO5Tcbl415mmowUk3v6AwmgZrwhDEvfmuJsX2
         fm4w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=QzT2RrU41GZyVtsRdExMDeFTArj5/TKKD1aKIx7i7Dg=;
        fh=zLpks8+MZ8tN0SVlHQSOHR3JQyYlYnqgeC2FSg349NM=;
        b=o627FINbjZ8H0j0KZuRauTZThcvJAyFwSEsCSMXoKNedIakGQde/hh5kfeOVLlzMrq
         9EW39JQEmQm+Bk8B85djiDPwMYqF69zg/Pgt1iDv24e+xJAzlbYn1YidABqcXBlfzJeV
         hdFpbybXdfbu+tHJpg48kLrgzCSTLpINbaAIas17g1guEoHEydi6GjUBQvQk+OyR2grF
         0E71BNTRNKF8V2mk3P8roMrMtChjhhG7k06trkITQJyQ1pnKPN4Wc8ayaV89aPv8eR/K
         QXeKzJkx2yzTYW6mRpFFJ2ouoQRmn7W0Wl+avtp0HWObTo5M2RmlgzUC9mswN7p5sYg5
         B/cg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782385810; x=1782990610; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=QzT2RrU41GZyVtsRdExMDeFTArj5/TKKD1aKIx7i7Dg=;
        b=r0FQzYoH0gBb+7BTtJk1NaF49K1veXALamLbakqdJxILF+otfw7XEzR4UtBPDXGJi+
         OAEw4XtDlnczOvNbihPCUgNN66OXpBx09Skadf/MP183p4rV0Q63q+qbkQ/fhv+UDCXM
         URlCN0Xmm73liORzbe6Vk6UqxKQoXixgloDo29uk8A4+tHI0ki28P5XupZRxspqAyafq
         8Zk0Xrr74vd0ALIblJukCKeER0l8Lg8a+14pJ2XBWBicn2MrW6E7OzsRWKg5ua26d8kB
         TOvI2FzM727UlDrrJFp3NJ7oHFcwLvSqWQDtKl8X/6ldRtCMScWPJID2WSjDMg8S4Wx0
         UEUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782385810; x=1782990610;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=QzT2RrU41GZyVtsRdExMDeFTArj5/TKKD1aKIx7i7Dg=;
        b=M67tHGi0UBAYdFzg2wA/cPmF/1HjFZ9sxACcD4YZaf3X1aasSxrcy44dulCNrhmGwy
         KzdNMePH4uKls5Z4SaGAG/Z9eAmkdCdj5fTkRFzog+YSzHR77u8HRQYK1gjNet386Nuq
         i2CN2GMuiEWQeExEmuRBGigANmVTlWo7puoOKtDWueibT1X3P+dzs/ue70BN3vPA/l5B
         wtFTwpApTCX7ThnaSjZYZL7v7Wf+KY1lSjbt53odHKo4pnnidCYTlWj+LHFFAXdPbVGK
         aWH47/31HlOq0OfGqJX4lv18HLPFdP2y51RsHH5EdjYa4w344+JtjnR+GqWf5BHkouqW
         B0oQ==
X-Forwarded-Encrypted: i=1; AHgh+RpWHbILH4YhRNHh6AuZPmdegUzf2LYpjksyTq0IG8nbBKcl4OPWUqfiw+DghBzrA6m2OsCa7bNEz2gq@vger.kernel.org
X-Gm-Message-State: AOJu0YyN4RVlzSVQ3q0P+jUJ+wnG6w/9vaozlVzLerao2yf1aIpCJvkH
	QDL2eOz8uCTO5zjZfXshve+IYhSmdhooBaWCF0xFgfgLhe5BxOjsGzO+61wFSVWGbFX9h4p1ZiC
	teu7OlDc6P5ptDE4n5p2bGxh75UxbUUs=
X-Gm-Gg: AfdE7ck/0W4KFMo3PaVpY9oEXnz6EUE9nilUgUEjLqg6A5N9tBVWM+8ngs7M8lFBwIv
	yaCFWux1+Xls/wWvnN9Hza6qYULz5HDwoAZ2m62GJUXKAWdnP3zjhvX04K5w5KcWsItZOhg7cZi
	VUcSx07pmMpbeKhq7g27wPKVzFa6xkxsxvGCBDJpJOnPp8rw/krpqiAxa8Yj3CDwOACmSjYIKql
	Z033lRH8YhIg10LjUhYpqO5cqW3cSZ8L60+tRD9Kkh/aYX20fOAjp6W5iIamDCrqNgylIOZfbgc
	BiSezkx+yK02OD3mPQ1Zj/CEiRez7YE=
X-Received: by 2002:a17:907:da2:b0:bfb:1853:c34c with SMTP id
 a640c23a62f3a-c1205dee227mr142684466b.14.1782385809166; Thu, 25 Jun 2026
 04:10:09 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260625065010.2332-1-aditya.ansh182@gmail.com> <emhyf7w5rac5e2bgaxnbphgo5tlbpud24utygg22dobqnhuacx@2t76kf3yooca>
In-Reply-To: <emhyf7w5rac5e2bgaxnbphgo5tlbpud24utygg22dobqnhuacx@2t76kf3yooca>
From: Aditya Prakash Srivastava <aditya.ansh182@gmail.com>
Date: Thu, 25 Jun 2026 16:39:56 +0530
X-Gm-Features: AVVi8Cd0rLoJG9xKH3CWitp2yHumJhy2oY89m_tDDrymZsKcJnfERA646N8UVdo
Message-ID: <CAK5ssPP9LcchQSwvdoj-iQSrTkM8kfPTNn_qY9LVSQyeY88wWg@mail.gmail.com>
Subject: Re: [PATCH v5] ext4: fix ABBA deadlock in ext4_xattr_inode_cache_find()
To: Jan Kara <jack@suse.cz>
Cc: tytso@mit.edu, adilger.kernel@dilger.ca, libaokun@linux.alibaba.com, 
	ritesh.list@gmail.com, yi.zhang@huawei.com, linux-ext4@vger.kernel.org, 
	linux-kernel@vger.kernel.org, Colin Ian King <colin.i.king@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Jan,

My sincere apologies for the rapid succession of patches and the noise
on the list. You are completely right; I got over-excited trying to
quickly address bugs flagged by the Sashiko-AI bot in previous
iterations, and I should have thought them through more carefully. I
will be more careful going forward.

Regarding your feedback:

You are entirely correct that 'is_freeing' is redundant. Since
find_inode_nowait() already returns NULL if the match callback returns
-1, we can simply drop that tracking variable and check !inode.

I also agree that returning -ENOENT on cache misses and unhashed checks
is much more semantically accurate than -ESTALE.

Thank you again for your patience, invaluable reviews, and guidance.

Best regards,
Aditya


On Thu, Jun 25, 2026 at 3:53=E2=80=AFPM Jan Kara <jack@suse.cz> wrote:
>
> On Thu 25-06-26 06:50:09, Aditya Srivastava wrote:
> > From: Aditya Prakash Srivastava <aditya.ansh182@gmail.com>
> >
> > Syzbot/stress-ng reported an ABBA deadlock in ext4 when exercising
> > concurrent xattr workloads (using the ea_inode mount/format option).
> >
> > The deadlock occurs between the running transaction and the eviction
> > thread:
> > - Task 1 (stress-ng): Holds a reference to a shared mbcache_entry (ce)
> >   and calls ext4_xattr_inode_cache_find() -> ext4_iget() to retrieve
> >   the corresponding EA inode. Since the EA inode is currently being
> >   evicted, ext4_iget() blocks in __wait_on_freeing_inode() waiting for
> >   eviction to complete.
> > - Task 2 (eviction thread): Currently evicting the same EA inode in
> >   ext4_evict_ea_inode(). It calls mb_cache_entry_wait_unused(oe) which
> >   blocks waiting for Task 1 to release the reference to the mbcache_ent=
ry.
> >
> > To break this deadlock, implement a new ext4_iget() configuration flag
> > named EXT4_IGET_NOWAIT. When set, perform a non-blocking lookup of the
> > inode via VFS's find_inode_nowait() API.
> >
> > If the inode is currently being evicted (marked with I_FREEING or
> > I_WILL_FREE) or created (I_CREATING), or if it is not present in the VF=
S
> > inode cache (cache miss), simply skip it (returning -ESTALE) rather tha=
n
> > waiting for eviction/creation to complete, breaking the ABBA cycle.
> >
> > Since we return -ESTALE immediately on a cache miss, we never attempt t=
o
> > allocate a new inode or call iget_locked(), completely eliminating any
> > TOCTOU race window.
> >
> > If the returned inode is I_NEW, wait for its initialization to clear vi=
a
> > wait_on_new_inode(). If initialization fails and the inode is unhashed
> > during wait_on_new_inode() waking up (e.g., due to an I/O read error in
> > another thread), safely drop the reference and return -ESTALE. This
> > unhashed check is executed unconditionally on all cache-hit pathways to
> > properly handle concurrent initialization failures.
> >
> > Finally, standard validation checks (including is_bad_inode,
> > EXT4_EA_INODE_FL, file_acl, and xattr flags) are executed as normal ins=
ide
> > check_igot_inode() to fully guarantee VFS-layer safety.
> >
> > In ext4_xattr_inode_cache_find(), invoke ext4_iget() with the new
> > EXT4_IGET_NOWAIT flag to perform the non-blocking cache search.
> >
> > Suggested-by: Jan Kara <jack@suse.cz>
> > Reported-by: Colin Ian King <colin.i.king@gmail.com>
> > Closes: https://bugzilla.kernel.org/show_bug.cgi?id=3D219283
> > Fixes: 0a46ef234756 ("ext4: do not create EA inode under buffer lock")
> > Signed-off-by: Aditya Prakash Srivastava <aditya.ansh182@gmail.com>
>
> Three patch submissions in a day? I think you are overdoing it. Please te=
st
> more, think more about what you do (i.e., really understand what the code
> does, not just whatever some AI agent suggested) and submit less.
>
> > +static int ext4_iget_match(struct inode *inode, u64 ino, void *data)
> > +{
> > +     bool *is_freeing =3D data;
> > +
> > +     if (inode->i_ino !=3D ino)
> > +             return 0;
> > +     spin_lock(&inode->i_lock);
> > +     if (inode_state_read(inode) & (I_FREEING | I_WILL_FREE | I_CREATI=
NG)) {
> > +             if (is_freeing)
> > +                     *is_freeing =3D true;
> > +             spin_unlock(&inode->i_lock);
> > +             return -1;
> > +     }
> > +     __iget(inode);
> > +     spin_unlock(&inode->i_lock);
> > +     return 1;
> > +}
> > +
> >  struct inode *__ext4_iget(struct super_block *sb, unsigned long ino,
> >                         ext4_iget_flags flags, const char *function,
> >                         unsigned int line)
> > @@ -5298,9 +5316,26 @@ struct inode *__ext4_iget(struct super_block *sb=
, unsigned long ino,
> >               return ERR_PTR(-EFSCORRUPTED);
> >       }
> >
> > -     inode =3D iget_locked(sb, ino);
> > -     if (!inode)
> > -             return ERR_PTR(-ENOMEM);
> > +     if (flags & EXT4_IGET_NOWAIT) {
> > +             bool is_freeing =3D false;
> > +
> > +             inode =3D find_inode_nowait(sb, ino, ext4_iget_match, &is=
_freeing);
> > +             if (is_freeing || !inode)
>
> is_freeing is pointless. Just drop it and use !inode.
>
> > +                     return ERR_PTR(-ESTALE);
>
> I'd prefer -ENOENT here instead of -ESTALE. It's kind of more specific.
>
> > +             if (inode_state_read_once(inode) & I_NEW)
> > +                     wait_on_new_inode(inode);
> > +
> > +             if (unlikely(inode_unhashed(inode))) {
> > +                     iput(inode);
> > +                     return ERR_PTR(-ESTALE);
>
> Here -ENOENT as well please.
>
> Otherwise the patch looks good to me.
>
>                                                                 Honza
>
> > +             }
> > +     } else {
> > +             inode =3D iget_locked(sb, ino);
> > +             if (!inode)
> > +                     return ERR_PTR(-ENOMEM);
> > +     }
> > +
> >       if (!(inode_state_read_once(inode) & I_NEW)) {
> >               ret =3D check_igot_inode(inode, flags, function, line);
> >               if (ret) {
> > diff --git a/fs/ext4/xattr.c b/fs/ext4/xattr.c
> > index 982a1f831e22..21b5670d8503 100644
> > --- a/fs/ext4/xattr.c
> > +++ b/fs/ext4/xattr.c
> > @@ -1550,7 +1550,7 @@ ext4_xattr_inode_cache_find(struct inode *inode, =
const void *value,
> >
> >       while (ce) {
> >               ea_inode =3D ext4_iget(inode->i_sb, ce->e_value,
> > -                                  EXT4_IGET_EA_INODE);
> > +                                  EXT4_IGET_EA_INODE | EXT4_IGET_NOWAI=
T);
> >               if (IS_ERR(ea_inode))
> >                       goto next_entry;
> >               ext4_xattr_inode_set_class(ea_inode);
> > --
> > 2.47.3
> >
> --
> Jan Kara <jack@suse.com>
> SUSE Labs, CR
