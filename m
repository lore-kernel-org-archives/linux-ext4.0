Received: from mail-yx1-f51.google.com (mail-yx1-f51.google.com [74.125.224.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC4C45B206
	for <linux-ext4@vger.kernel.org>; Wed,  7 Oct 2026 03:30:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.224.51
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791343833; cv=pass; b=poJIGnniZPUbk8undjh1zacTDRNNGn1bjOaOdZF2nmDGVjMkfejOC54jkYNgPynoeeKhgWN0IEwS3NX19vfjh+5P8ztzcPdbNLQdpdB1j5HmhIvx5uhyqUxo/pJuWdhk+V9ISDdiRPmPTmYxLkiQKZWQZz96yaYtiaOeq0LsMO0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791343833; c=relaxed/simple;
	bh=UJjG7YQB/XZoKvnWM5FDfqOIQ0JIYp5rinf2O9Fj9J8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=JoMawSqGHJA5JWuHWXnqMCeSpGqHDhsFCVQGnmiAo/zLVsM/zwsbsINI0V/cDC5/aRN7sGZNbu5Sh0fJb7u76ZMdm3dHVY+N/AhwR1PmK0f8fust0u9R/hegtR3qgsJ4mJq7g6rcwAFYWFp3gRUR1j9SJR6vY2DLTQHLB6QMF+Y=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=SMXNPD0g; arc=pass smtp.client-ip=74.125.224.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="SMXNPD0g"
Received: by mail-yx1-f51.google.com with SMTP id 956f58d0204a3-6767d92cde6so1269096d50.0
        for <linux-ext4@vger.kernel.org>; Tue, 06 Oct 2026 20:30:31 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1791343831; cv=none;
        d=google.com; s=arc-20260327;
        b=VpkqG6E/tpiPjw8/HWlSvgkqBR+Jjflmak2fTQSj68mUI7gyooOp6Lko7alJ3cxiMj
         WHWNrsHajnhM02IVzD1RiyVRl6m50y87+9fLkG1Dco8SZ5dY6shSsABwVvVYHEmcUs3G
         QyUIHxasgZGE+13WjjwA6PDDNKV9GrrUAGG767rYn0GjygWUSEW3Gt8+ILigzyZyVuz0
         udbmvD1jq+dlhy16YgxCBjRkTA6tAWZ55IwFlTzrSIQVY/U21AOy2F18p6GEs9iRzhsf
         6QG6Z1mBamljRQIbPxWNHJQyJwV8UXSUu+FoCG+nQddZdZ518eQsKYmonFjhsDFFKJrq
         FvOg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=bj7qdb9JKHM+aQdEnEvqhywIWqaQWXOgPRxHvLl5wx0=;
        fh=68UP8ogH6yr6u7UODhdjhUirTxJe/rKkv08l2zW5p+4=;
        b=NOTwmz1RD/hEl1+3OgDbDeQwY2NEwEcqh2sS+4vDGTweJ5JUJLQXPmHUQSwUy5jXcf
         d9XWtEGeaSTOi/X+CftQnYkTK+Ha9fg4gK78nP+hIv8NT7o/u2D2J/Zb1FsPi27lloJp
         OSIf0v5wgHZBPxXxMwJ2N4Ibu+2uc/3mKN1kxm9kCJNzG2nuz6n5RoG+Rk/FaYBp3QQy
         tJboi0Y6X8j1TGuqDeB2daYR1ZEoUFoNtQ4CLe+myqTR/+j/jm9zOPlufL9oQryksvZR
         ouPoaSSb3O1cBldrJHWvo8jJ7fC33MEvixSdlS1zifF9WmqeEdvDSIZWBF/DQiAvxdi6
         WY8w==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791343831; x=1791948631; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=bj7qdb9JKHM+aQdEnEvqhywIWqaQWXOgPRxHvLl5wx0=;
        b=SMXNPD0gFhuA4J/xULHLAr2v38jGdJ0BvV+NdQ0d7ttBKyACqGioEUnpNxJvPm5hAM
         lGTJHUEmZL2L4QLuYIqEyJa1JscX6lrMJ/oTm5gus45JiZF1Uk/ueCHCQDtquj8RVu+C
         sICxGoe7/J3iDpnL4PfKbYlH54j1uAeAaPSEtA1JqLksx84eskOuE1/3S0c8Q6zjoIYm
         wKVBRVuv5BKmHAxZzGhksZSJGw6NTXCZZbsYG0bsAnzEHwQIui3ZjdGFq7Jgu6mjfm7S
         f9hLhkj820zC+ISCtoL1SWSY+nt5Eb+/JyEAfLF+io2w7U5ukkLHH8xCY0dne3g6Vpod
         zZQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791343831; x=1791948631;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=bj7qdb9JKHM+aQdEnEvqhywIWqaQWXOgPRxHvLl5wx0=;
        b=ivU6wb33s+TcbPYlj5vctMgtcrSuSwfgS5gqaglp+8keXnazZ+CIc6NU9+AQYtbw/2
         uJFm083cbBikUoyHSCT9QvvisPB34crryGrYUgYBue8bjLHnHaRZXph/svMSupsc3j6U
         HcxIpQWpTzZeHHh4TaNJiT5lRbe4hcFtNdz/qVJD6vPE3bB0YiW2r96QLU+F39vWYNS9
         ZsBT6CBX3SeasFUTz1h1dufYBxlQsdEIjNEbQmb4wYK3p7mqyZljmz/Iq263QB+P6wwl
         zoNlE//KasUPxlUGf3+Ba9OBamY0WaHl0g+FsuLYbRZj6vp4EUsgg7GYL/ef8ToFOcXv
         WS3A==
X-Forwarded-Encrypted: i=1; AKwUvBwErx8bw33/z4M4slEoiqYPby3qBET4sJx49H2dfF2JdvOoZa+PSLRo76FLcDasBO0tAZTo95Jhpi8/@vger.kernel.org
X-Gm-Message-State: AFq9FYIKIns9VCcKSGsuy/sZCS5lOPAZhW6rT9+1B3/TUbrf2gEtDPSw
	33G8bD3QAJ+h+0bOlc2VBI9CQyDrJa41/Sw6jSSkbZh+vmgF2yJ8YpCIm8XIANW3qaqfGV+2F7y
	1hbOPJnNd0/lT1mWL4eD9oeDdcTyTxyY=
X-Gm-Gg: AYBFou1aMGX/VaGfydXINHboyj0FC0U9+0lziqVOZbxtS8sID4WaQlHopQTGzwisdbC
	6V24RgPwnB5TaxtqgoHhgemnacPzWnsEqG8rThNHgqfI+tykTzfJyX9NNBGiRT73EGrF5CE+oCg
	Q51qu8oX+ML4QXmWKCs0OFz4lU2ekgeZJ8yt2FRboO9UZO9Wt7F9SvcsjfEDMZEabXwJf5qmxvE
	BwGI2X5pLmcENMD5khOYsSciLb13YFIR7w8M2PhtTcjCkYfjxSJcak+RpodQt7pvXidZ9WXvgmK
	/L2iBuvhBB+edb4tagkLtMeiWKShva7mxMVugGth5yl2ZUfPTfq8diuC
X-Received: by 2002:a05:690e:b82:b0:677:d251:ccd9 with SMTP id
 956f58d0204a3-6790a2e4aaemr706401d50.48.1791343830632; Tue, 06 Oct 2026
 20:30:30 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20261006070005.1209234-1-swinds24@gmail.com> <s3rlm3edtb4hfcggiqkqotywfhobjnwmc2v373nwvkwihitstg@66kypvunlqqm>
In-Reply-To: <s3rlm3edtb4hfcggiqkqotywfhobjnwmc2v373nwvkwihitstg@66kypvunlqqm>
From: Hsiu-Hsien Lee <swinds24@gmail.com>
Date: Wed, 7 Oct 2026 11:30:18 +0800
X-Gm-Features: AclHuK_ceOw_gBw80HWG9dguUdx4fCwV1VJRW3JaZysAs4dIBQAAHlWXB_Up5xk
Message-ID: <CACi0_7afNW5KNZVNL40GUrCL9+Ly6oDrKPA-hNu2RQ_u51UZ+w@mail.gmail.com>
Subject: Re: [PATCH] ext4: don't fail journal recovery on an incomplete fast commit
To: Jan Kara <jack@suse.cz>
Cc: "Theodore Ts'o" <tytso@mit.edu>, linux-ext4@vger.kernel.org, 
	Andreas Dilger <adilger.kernel@dilger.ca>, Harshad Shirwadkar <harshadshirwadkar@gmail.com>, 
	Baokun Li <libaokun@linux.alibaba.com>, Ojaswin Mujoo <ojaswin@linux.ibm.com>, 
	Ritesh Harjani <ritesh.list@gmail.com>, Zhang Yi <yi.zhang@huawei.com>, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Thanks for the review. It makes sense, and I'll drop the warning and the
helper and use ext4_debug() in v2.

- Jerry


Jan Kara <jack@suse.cz> =E6=96=BC 2026=E5=B9=B410=E6=9C=887=E6=97=A5=E9=80=
=B1=E4=B8=89 =E4=B8=8A=E5=8D=8812:08=E5=AF=AB=E9=81=93=EF=BC=9A
>
> On Tue 06-10-26 15:00:05, Hsiu-Hsien Lee wrote:
> > If the system crashes while the first fast commit after a full commit i=
s
> > being written, the fast commit area can hold the head of that fast
> > commit without a valid tail.  ext4_fc_replay_scan() treats this as an
> > error as long as no valid tail has been seen: an invalid tag length or
> > an unknown tag returns -ECANCELED, a tail with a wrong tid or checksum
> > returns -EFSBADCRC.  jbd2_journal_recover() then fails, the file system
> > can be mounted neither read-write nor read-only, and the regular journa=
l
> > transactions committed before the fast commit are not replayed either:
> >
> >   JBD2: journal recovery failed
> >   EXT4-fs (sdb): error loading journal
> >
> > The tail is written last and fsync() does not return before it has
> > completed, so an incomplete fast commit was never reported as durable.
> > Handle it like jbd2 handles a transaction without a valid commit block:
> > stop the scan and replay what is valid.  This is already what happens
> > when an earlier fast commit in the area has a valid tail.  Log a
> > warning so that the dropped fast commit is visible.
> >
> > Reproducer, with the power cut emulated by copying the device while it
> > is mounted:
> >
> >   mkfs.ext4 -O fast_commit /dev/sdb
> >   mount /dev/sdb /mnt; mkdir /mnt/d
> >   create 20 files in /mnt/d; sync
> >   write a fragmented file and modify the 20 files, fsync one file
> >       (one fast commit spanning several blocks)
> >   copy /dev/sdb while still mounted, then zero the block holding the
> >   fast commit tail in the copy
> >   mount the copy
> >
> > Without this patch the mount fails as above.  With it, the mount
> > succeeds, the state after sync is recovered and e2fsck finds no errors.
> > The same holds when a full commit precedes the torn fast commit, in
> > which case the full commit is now replayed as well.
> >
> > Fixes: 8016e29f4362 ("ext4: fast commit recovery path")
> > Assisted-by: Claude Opus 5.5
> > Signed-off-by: Hsiu-Hsien Lee <swinds24@gmail.com>
> > ---
> >  fs/ext4/fast_commit.c | 36 +++++++++++++++++++++++++++++-------
> >  1 file changed, 29 insertions(+), 7 deletions(-)
> >
> > diff --git a/fs/ext4/fast_commit.c b/fs/ext4/fast_commit.c
> > index 0cac890cf370..5649447b9524 100644
> > --- a/fs/ext4/fast_commit.c
> > +++ b/fs/ext4/fast_commit.c
> > @@ -2427,6 +2427,26 @@ static bool ext4_fc_value_len_isvalid(struct ext=
4_sb_info *sbi,
> >       return false;
> >  }
> >
> > +/*
> > + * The fast commit area ends with an invalid tag or a tail that does n=
ot
> > + * match.  This is how a fast commit that was only partially written b=
efore
> > + * a crash looks like: its tail is written last and fsync() only retur=
ns
> > + * after the tail write has completed, so nobody was told that this fa=
st
> > + * commit is durable and it can simply be dropped, the same way jbd2 d=
rops
> > + * a transaction without a valid commit block.  Everything up to the l=
ast
> > + * valid tail is still replayed.
> > + */
> > +static int ext4_fc_replay_scan_end(struct super_block *sb,
> > +                                struct ext4_fc_replay_state *state,
> > +                                int off, const char *reason)
> > +{
> > +     if (!state->fc_replay_num_tags)
> > +             ext4_msg(sb, KERN_WARNING,
> > +                      "ignoring incomplete fast commit at block %d: %s=
",
> > +                      off, reason);
>
> I don't think there's need to print any message when discovering incomple=
te
> fast commit. As you mention, it is a perfectly normal situation (similarl=
y
> as incomplete normal transaction we spot in a journal). I'd perhaps just
> print ext4_debug() message (and I don't think conditioning on
> fc_replay_num_tags makes sense in that case. So probably just drop the
> helper function and print the debug message and set the return value
> inline...
>
>                                                                 Honza
>
> > +     return JBD2_FC_REPLAY_STOP;
> > +}
> > +
> >  /*
> >   * Recovery Scan phase handler
> >   *
> > @@ -2440,7 +2460,9 @@ static bool ext4_fc_value_len_isvalid(struct ext4=
_sb_info *sbi,
> >   * This function returns JBD2_FC_REPLAY_CONTINUE to indicate that SCAN=
 is
> >   * incomplete and JBD2 should send more blocks. It returns JBD2_FC_REP=
LAY_STOP
> >   * to indicate that scan has finished and JBD2 can now start replay ph=
ase.
> > - * It returns a negative error to indicate that there was an error. At=
 the end
> > + * It returns a negative error to indicate that there was an error. An=
 invalid
> > + * or incomplete fast commit at the end of the area is not an error, s=
ee
> > + * ext4_fc_replay_scan_end(). At the end
> >   * of a successful scan phase, sbi->s_fc_replay_state.fc_replay_num_ta=
gs is set
> >   * to indicate the number of tags that need to replayed during the rep=
lay phase.
> >   */
> > @@ -2489,8 +2511,8 @@ static int ext4_fc_replay_scan(journal_t *journal=
,
> >               val =3D cur + EXT4_FC_TAG_BASE_LEN;
> >               if (tl.fc_len > end - val ||
> >                   !ext4_fc_value_len_isvalid(sbi, tl.fc_tag, tl.fc_len)=
) {
> > -                     ret =3D state->fc_replay_num_tags ?
> > -                             JBD2_FC_REPLAY_STOP : -ECANCELED;
> > +                     ret =3D ext4_fc_replay_scan_end(sb, state, off,
> > +                                                   "invalid tag length=
");
> >                       goto out_err;
> >               }
> >               ext4_debug("Scan phase, tag:%s, blk %lld\n",
> > @@ -2530,8 +2552,8 @@ static int ext4_fc_replay_scan(journal_t *journal=
,
> >                               state->fc_regions_valid =3D
> >                                       state->fc_regions_used;
> >                       } else {
> > -                             ret =3D state->fc_replay_num_tags ?
> > -                                     JBD2_FC_REPLAY_STOP : -EFSBADCRC;
> > +                             ret =3D ext4_fc_replay_scan_end(sb, state=
, off,
> > +                                                           "invalid ta=
il");
> >                       }
> >                       state->fc_crc =3D 0;
> >                       break;
> > @@ -2551,8 +2573,8 @@ static int ext4_fc_replay_scan(journal_t *journal=
,
> >                               EXT4_FC_TAG_BASE_LEN + tl.fc_len);
> >                       break;
> >               default:
> > -                     ret =3D state->fc_replay_num_tags ?
> > -                             JBD2_FC_REPLAY_STOP : -ECANCELED;
> > +                     ret =3D ext4_fc_replay_scan_end(sb, state, off,
> > +                                                   "unknown tag");
> >               }
> >               if (ret < 0 || ret =3D=3D JBD2_FC_REPLAY_STOP)
> >                       break;
> > --
> > 2.43.0
> >
> --
> Jan Kara <jack@suse.com>
> SUSE Labs, CR
