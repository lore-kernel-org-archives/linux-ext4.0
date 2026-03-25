Received: from mail-wr1-f45.google.com (mail-wr1-f45.google.com [209.85.221.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0DAD337105
	for <linux-ext4@vger.kernel.org>; Wed, 25 Mar 2026 18:36:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.221.45
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774463766; cv=pass; b=RiiI5gKipU7uvENO/Jz9gfzYp6r6WHfZ1w9FcJheioJvbd+nwpLgh+eRt+nFJ/6Xvcnfken2gqXs4VRtmuy7oUGv7mkHHvxc2Qwd3v+FcCtfq+Ij+TN0jsTGX3Oo0jeXP6lr2BtqMzCQus9PqLXX8SBma0XNQ0CWBcEIInGrkXA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774463766; c=relaxed/simple;
	bh=DU09dneRr/GRbp2qrwsAbEux7gUhzS7AtKG/4sqMSBQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=kigL0R7ILNtNeiUGRkLP3MNMHo8GBM19v69Hj9yJ2V16eFdwlBuucZGr3Fdpm0p5fFcJoNeDhMjC9pbJ5Qt0g3oxFLB2Kq27m9iHfh6/YK5Oz7gQRTYfwTADvYgBeUJD/Aka3gTmTfZF0u7tk4lHEZYhkcPj/ChaFu1+ZLvkiJM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=VYj9J+tR; arc=pass smtp.client-ip=209.85.221.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="VYj9J+tR"
Received: by mail-wr1-f45.google.com with SMTP id ffacd0b85a97d-439c6fc2910so93068f8f.0
        for <linux-ext4@vger.kernel.org>; Wed, 25 Mar 2026 11:36:01 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1774463759; cv=none;
        d=google.com; s=arc-20240605;
        b=ScfvvBoUa2q0Zj4FHywc9hTePSv5zbDcEZ/xr6bmE9cDP0lyuWweaexRhSIkcF1VJW
         xDCUMWWbYoL1fwWh1rkOMwSHQBYMxE87NDk2AxIlnZDFsrliKymrh3rzxtz5HVgq7Wnl
         OJcrYjFVKkfNEmBClzlGGLKch0XlfJOGKkl7wSen380IM13VSm//wFMEP4G3PyF++RBv
         yRxZllMsXibk4AivBx5gFM6bVfXiJ7psWw6ZfIYR1FMm2U5LLsVtPMmY8OE6tjfK36tt
         AKBcvjZVYaI0XQX/6OfzS+m57X1yv7EiZ+kFaM2D9+v9SVJZAQvvKUEO9L/zc4rvcgRB
         LlNA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=9QtV8GBTb6YR4jdqHUX7Sv2eVsBl1fbWiLDxSj4EukQ=;
        fh=lKIH3+ZG9maQBTfWpBvctjhI0SiJXvxGO+hOK4NLB9A=;
        b=ZD9NuZTj0Pk6SFGmj4vp6acg0Xd+tEMZExWjACXo9fm1ArM5TskHomYotRaulMVKdb
         gK77a1H89eQK9C6JKwNjKBszz/0zkNay1drxAcMXchlSC9cy0E1GRZhUh1+hnxKDpCqh
         dVe3WYDjzTpcYMwrxbJ+ANZ80se5c2vX2+UXxW0CuHwOUppUrujWeGc8YYh10iQaXVZt
         zHL/rs/HTaqcYdZbqo9gOp66vWekTMH3ITTXxi++GJvY9XUQzA8jClUzzlVqOjuWOJVS
         V9f3u9A2a6LZPByU2Jak/NAB15XJrs51MdhIYCqDRORhi/4HwTuSpYCkR0iEWl06fFOO
         6Mvg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1774463759; x=1775068559; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9QtV8GBTb6YR4jdqHUX7Sv2eVsBl1fbWiLDxSj4EukQ=;
        b=VYj9J+tRwEhyTKu1jFztIIyyKnSDqOC+nG/430snVSAMKZ23q3hy+/SYZlM77fAD43
         E0PZ5FG6eiApjsCDYocstimrEeDBoQ5UlxRPdT7k/PiHutdlTGzN2FHJrQSCe2rnP09/
         OARSS14vSE/zkQXqPAxP//9aclw+5uvv6/g8NELs8z/XKedJ96lKjOHcmzhGN7bRoI7F
         nj/rqFYtA0qMq5gq9nFt+wuxkMPL13zAh1Pdx36ImO2BdFb7P2YmO9Y+24fAu81Cg8sB
         M2VCdB97L+oxY+5+rZV73XMAGiPSbNRbEi6o2Shqh+6Bnk1vo2uhfDbgFIK8xaxZ1hBB
         VFPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774463759; x=1775068559;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=9QtV8GBTb6YR4jdqHUX7Sv2eVsBl1fbWiLDxSj4EukQ=;
        b=jKJ0n+88SB1o7azzdwfaskXSFFoPo+Mfj+kXbOWrpCc/CioB+o0Kt8RyeKNMvxefDo
         5RJr7IeDe/kpuS+oIWf0sHTuEtUCD3l/WnkLvQEOCkl+ayIaT65hwSrUU1dhRudwqFNY
         YOpqsjGFWn7lAV29cq08G6p/6FVerdVEWOT1UznIc1hmRKcOIduqJ2LBTWnQA1SpB9od
         KUA+ROdL9KnDb9JW2j+eO5gbQfFF610cWvHMJv0WCP2ZJafwuaIz6Fb9PhDEYqKJcDEB
         727fx/jY5SqhNaE2ceU3+5JpVdMyXF2p6/SO36mH51o0EnuxZQvRZGyoLPIuJUXD8v4H
         zukQ==
X-Forwarded-Encrypted: i=1; AJvYcCVbbcEczjsBMJ0ZlT1VLha4B9gz4xo40nX8/qk71FIhzP/SEN+tXMMzkEh1G7b16+UHytkkbLsu7iL+@vger.kernel.org
X-Gm-Message-State: AOJu0YydB3mCpu0xeJpmdm0v2ifGjHXjce7iRKqXSFF6fsfKVNOETuuV
	qckT44l6cEgqlLArPV7VgoHLbD6KM+7DttriW9MbD0j+S0LA9JwirBxOgMTPWYvJHA2YQUNx0Eq
	kLK1R1V52r40V9JfZhXuAsnEwkoHGtJE=
X-Gm-Gg: ATEYQzxhSO/eD7t/kkeoUK1qSTa1OQYQLXmZ3BLX0oer2FMWwNu7SzXCAlB4J85crwe
	VOLIKp0gySBmh+25RKNqXzJ2Mxm3OFxTWoejHKHUecG9JlYGNlHRjxIFOcGcebMfpvhGiO86QwA
	IRemk8Ttbjvvib76VlJbC/hu7Gvx+/GwRx9LVJIz99IonkHF/lo3CUCN5NEo/SMZLhTXjm27igm
	6YtGRWXdWXhjNcjFnhfq2hIbk4XphAbmAKbyiNtF67SOFKVFB9IVyL+xigg9gSKwtCatp8N8SEZ
	CP8A8w==
X-Received: by 2002:a05:6000:4381:b0:439:b6f1:cd8d with SMTP id
 ffacd0b85a97d-43b88a100a3mr6484733f8f.28.1774463758965; Wed, 25 Mar 2026
 11:35:58 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <177188733084.3935219.10400570136529869673.stgit@frogsfrogsfrogs> <177188733175.3935219.14499232455997407711.stgit@frogsfrogsfrogs>
In-Reply-To: <177188733175.3935219.14499232455997407711.stgit@frogsfrogsfrogs>
From: Joanne Koong <joannelkoong@gmail.com>
Date: Wed, 25 Mar 2026 11:35:47 -0700
X-Gm-Features: AQROBzAsyuIOQL6cuDHl9wKI-61KU4hUBnmgoj2gOGt1Tina83tHjQ4Mtdg7-gk
Message-ID: <CAJnrk1ZZV=nf2ZvsFz2gCEdFanK2c=_4X8hH5PyZ4ys-b5T8kQ@mail.gmail.com>
Subject: Re: [PATCH 3/5] fuse: implement file attributes mask for statx
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: miklos@szeredi.hu, bpf@vger.kernel.org, bernd@bsbernd.com, neal@gompa.dev, 
	linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Feb 23, 2026 at 3:07=E2=80=AFPM Darrick J. Wong <djwong@kernel.org>=
 wrote:
>
> From: Darrick J. Wong <djwong@kernel.org>
>
> Actually copy the attributes/attributes_mask from userspace.  Ignore
> file attributes bits that the VFS sets (or doesn't set) on its own.
>
> Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
> Reviewed-by: Joanne Koong <joannelkoong@gmail.com>
> ---
>  fs/fuse/fuse_i.h |   37 +++++++++++++++++++++++++++++++++++++
>  fs/fuse/dir.c    |    4 ++++
>  fs/fuse/inode.c  |    4 ++++
>  3 files changed, 45 insertions(+)
>
>
> diff --git a/fs/fuse/fuse_i.h b/fs/fuse/fuse_i.h
> index 1d4beca5c7018d..79793db3e9a743 100644
> --- a/fs/fuse/fuse_i.h
> +++ b/fs/fuse/fuse_i.h
> @@ -147,6 +147,10 @@ struct fuse_inode {
>         /** Version of last attribute change */
>         u64 attr_version;
>
> +       /** statx file attributes */
> +       u64 statx_attributes;
> +       u64 statx_attributes_mask;
> +
>         union {
>                 /* read/write io cache (regular file only) */
>                 struct {
> @@ -1236,6 +1240,39 @@ void fuse_change_attributes_common(struct inode *i=
node, struct fuse_attr *attr,
>                                    u64 attr_valid, u32 cache_mask,
>                                    u64 evict_ctr);
>
> +/*
> + * These statx attribute flags are set by the VFS so mask them out of re=
plies
> + * from the fuse server for local filesystems.  Nonlocal filesystems are
> + * responsible for enforcing and advertising these flags themselves.
> + */
> +#define FUSE_STATX_LOCAL_VFS_ATTRIBUTES (STATX_ATTR_IMMUTABLE | \
> +                                        STATX_ATTR_APPEND)
> +
> +/*
> + * These statx attribute flags are set by the VFS so mask them out of re=
plies
> + * from the fuse server.
> + */
> +#define FUSE_STATX_VFS_ATTRIBUTES (STATX_ATTR_AUTOMOUNT | STATX_ATTR_DAX=
 | \
> +                                  STATX_ATTR_MOUNT_ROOT)
> +
> +static inline u64 fuse_statx_attributes_mask(const struct inode *inode,
> +                                            const struct fuse_statx *sx)
> +{
> +       if (fuse_inode_is_exclusive(inode))
> +               return sx->attributes_mask & ~(FUSE_STATX_VFS_ATTRIBUTES =
|
> +                                              FUSE_STATX_LOCAL_VFS_ATTRI=
BUTES);
> +       return sx->attributes_mask & ~FUSE_STATX_VFS_ATTRIBUTES;
> +}
> +
> +static inline u64 fuse_statx_attributes(const struct inode *inode,
> +                                       const struct fuse_statx *sx)
> +{
> +       if (fuse_inode_is_exclusive(inode))
> +               return sx->attributes & ~(FUSE_STATX_VFS_ATTRIBUTES |
> +                                         FUSE_STATX_LOCAL_VFS_ATTRIBUTES=
);
> +       return sx->attributes & ~FUSE_STATX_VFS_ATTRIBUTES;
> +}
> +
>  u32 fuse_get_cache_mask(struct inode *inode);
>
>  /**
> diff --git a/fs/fuse/dir.c b/fs/fuse/dir.c
> index 7ac6b232ef1232..10fa47e969292f 100644
> --- a/fs/fuse/dir.c
> +++ b/fs/fuse/dir.c
> @@ -1464,6 +1464,8 @@ static int fuse_do_statx(struct mnt_idmap *idmap, s=
truct inode *inode,
>                 stat->result_mask =3D sx->mask & (STATX_BASIC_STATS | STA=
TX_BTIME);
>                 stat->btime.tv_sec =3D sx->btime.tv_sec;
>                 stat->btime.tv_nsec =3D min_t(u32, sx->btime.tv_nsec, NSE=
C_PER_SEC - 1);
> +               stat->attributes |=3D fuse_statx_attributes(inode, sx);
> +               stat->attributes_mask |=3D fuse_statx_attributes_mask(ino=
de, sx);
>                 fuse_fillattr(idmap, inode, &attr, stat);
>                 stat->result_mask |=3D STATX_TYPE;
>         }
> @@ -1568,6 +1570,8 @@ static int fuse_update_get_attr(struct mnt_idmap *i=
dmap, struct inode *inode,
>                         stat->btime =3D fi->i_btime;
>                         stat->result_mask |=3D STATX_BTIME;
>                 }
> +               stat->attributes =3D fi->statx_attributes;
> +               stat->attributes_mask =3D fi->statx_attributes_mask;

Do these need to be |=3D so we don't overwrite any vfs attributes stored
in stat already?

Thanks,
Joanne

>         }
>
>         return err;
> diff --git a/fs/fuse/inode.c b/fs/fuse/inode.c
> index 58c3351b467221..ff8b94cb02e63c 100644
> --- a/fs/fuse/inode.c
> +++ b/fs/fuse/inode.c
> @@ -286,6 +286,10 @@ void fuse_change_attributes_common(struct inode *ino=
de, struct fuse_attr *attr,
>                         fi->i_btime.tv_sec =3D sx->btime.tv_sec;
>                         fi->i_btime.tv_nsec =3D sx->btime.tv_nsec;
>                 }
> +
> +               fi->statx_attributes =3D fuse_statx_attributes(inode, sx)=
;
> +               fi->statx_attributes_mask =3D fuse_statx_attributes_mask(=
inode,
> +                                                                      sx=
);
>         }
>
>         if (attr->blksize)
>
