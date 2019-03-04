Return-Path: <SRS0=/gtt=RH=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ABAD4C43381
	for <linux-ext4@archiver.kernel.org>; Mon,  4 Mar 2019 21:16:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6C44E206DD
	for <linux-ext4@archiver.kernel.org>; Mon,  4 Mar 2019 21:16:43 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="LZvTMz/m"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726143AbfCDVQn (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Mon, 4 Mar 2019 16:16:43 -0500
Received: from mail-ed1-f66.google.com ([209.85.208.66]:36863 "EHLO
        mail-ed1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726038AbfCDVQm (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Mon, 4 Mar 2019 16:16:42 -0500
Received: by mail-ed1-f66.google.com with SMTP id g9so5436711eds.3;
        Mon, 04 Mar 2019 13:16:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:reply-to:from:date:message-id
         :subject:to:cc;
        bh=VmsdV+KTPGQZbnfb5jq1Awj+bzoanXMXyJt5cyx9rVk=;
        b=LZvTMz/mdbSDE7s6WiDGCqa5woJLURJH3Qr98M0n9ZjNHAPRnK2XyBJNTEN3xBJ5DG
         ovIzPwdrKF/JHKYJt1FDHTt6gX7FSY4B7VFxECajNYnfXkrOAhJe4fn2NeBld/JWXxNp
         BeSSJzMpaHM8FS3CEE3z6w+skEbsHMkbMJZP9a+JeBm2dWT+eS8O3eUdv2B2oLia4IoF
         C8gwctul/S/A33QHExmdyBdMkpNJ+CAxQ3PuYnDk2vFbNyhVFN9vgXZpokr5xHIZ2XjT
         ExSR/i3F7eBr9sdCrGeHPhyOaAdFaEcgYdJUSNY0aLrXWA2SHv/Sq8CRaeZvWLeHjiC4
         8rqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:reply-to
         :from:date:message-id:subject:to:cc;
        bh=VmsdV+KTPGQZbnfb5jq1Awj+bzoanXMXyJt5cyx9rVk=;
        b=qwTgWkqI9tdIeIa/ddwN3LYfMP4SHQviThpRen4opP8AgDIN0GZh53qiRx8glWJ1Sp
         vKgiX8nqQ/u2Xxxe5kyvyWMu7vtdMTZd//hmvT9X4AWtHoupHuSwDztPvD9xFXyzdM/Q
         sNMg4IBSv+ngMgTf9o1YyralBer1qapbPTcPL8fYpdc8H1TM1DfCx/8Ozr7+ScIIyHNK
         25CqKmLmu3c6HPpIjbjKfABcLXR3a7214g7D9m9WW6x++1r+vFhRfR05Ty85pB1njLf2
         x3NPLX3FmBgKFvAgaXRGMS/vA6bMOBcOtwY6bJnj6umr3ukpORwL7rlTU/8KqmVk8MQV
         WShw==
X-Gm-Message-State: APjAAAUPDX1WTBK1VjdEnZzzUhZjBIfwvC4mLGqWs66RW0s1kPU86RIS
        pLC0cKaKXN/P9Sx4P2a1SqM6MZJH6JYiJC0YOcF6wQ==
X-Google-Smtp-Source: APXvYqyycYVQj2JaNxrU8jFoaD+iYaev2o6MPNgxjccy8O1Dto8IupS7rziR82/H6mgQRFSppJ05mfB5dIkioBM/aFA=
X-Received: by 2002:a50:d8c2:: with SMTP id y2mr17055106edj.65.1551734200430;
 Mon, 04 Mar 2019 13:16:40 -0800 (PST)
MIME-Version: 1.0
References: <1551449184-7942-1-git-send-email-wshilong1991@gmail.com>
 <1551449184-7942-3-git-send-email-wshilong1991@gmail.com> <CAKgNAkitiDEYSZDnJ5iQ6coaE=q45BHxnG2z_bZtWs=kk+2g3w@mail.gmail.com>
 <20190304205006.GX23020@dastard>
In-Reply-To: <20190304205006.GX23020@dastard>
Reply-To: mtk.manpages@gmail.com
From:   "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>
Date:   Mon, 4 Mar 2019 22:16:29 +0100
Message-ID: <CAKgNAki3teB9-9D-D2yObqLfAB4VUdr-Pg0qz735RfHmP+YzBg@mail.gmail.com>
Subject: Re: [PATCH 2/2] statx.2: add project support update
To:     Dave Chinner <david@fromorbit.com>
Cc:     Wang Shilong <wangshilong1991@gmail.com>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        Ext4 Developers List <linux-ext4@vger.kernel.org>,
        xfs <linux-xfs@vger.kernel.org>,
        linux-f2fs-devel@lists.sourceforge.net, lixi@ddn.com,
        Andreas Dilger <adilger@dilger.ca>,
        Wang Shilong <wshilong@ddn.com>,
        linux-man <linux-man@vger.kernel.org>,
        "Darrick J. Wong" <darrick.wong@oracle.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

Hi Dave,
On Mon, 4 Mar 2019 at 21:50, Dave Chinner <david@fromorbit.com> wrote:
>
> On Mon, Mar 04, 2019 at 02:52:59PM +0100, Michael Kerrisk (man-pages) wrote:
> > Hello Wang Shilong,
> >
> > On Fri, 1 Mar 2019 at 15:06, Wang Shilong <wangshilong1991@gmail.com> wrote:
> > >
> > > From: Wang Shilong <wshilong@ddn.com>
> >
> > I take it that these patches relate to some API changes that are not
> > yet merged into the kernel, right?
> >
> > Also, I think we need some accompanying info to describe project IDs.
> > Can you point me at any documents/resources?
>
> Probably "best" documented in the man pages that ship with xfsprogs.

But, these IDs are a kernel construct, right? Is their scope limited
just to XFS, or do other filesystems have the concept also?

Cheers,

Michael

> Basically, it's just another quota ID that can be used to account
> for files/directories in arbitrary admin defined groups. i.e. quotas
> that aren't bound by user/group identities.
>
> $ man 8 xfs_quota
> $ man 5 projects
> $ man 5 projid
