Return-Path: <SRS0=/gtt=RH=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E3F48C10F03
	for <linux-ext4@archiver.kernel.org>; Mon,  4 Mar 2019 22:56:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B462820830
	for <linux-ext4@archiver.kernel.org>; Mon,  4 Mar 2019 22:56:15 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="VEzCLDAe"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726418AbfCDW4O (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Mon, 4 Mar 2019 17:56:14 -0500
Received: from mail-io1-f66.google.com ([209.85.166.66]:37903 "EHLO
        mail-io1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726066AbfCDW4O (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Mon, 4 Mar 2019 17:56:14 -0500
Received: by mail-io1-f66.google.com with SMTP id p18so5380733ioh.5;
        Mon, 04 Mar 2019 14:56:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=B+pNjSsOXVhftKuiaHhDVJpkD20xz5OLcn7WggmPyYE=;
        b=VEzCLDAeBqwxifFtfza1NN9tyR0W1ZHfTWsXWX/sLs1JrB6VnFoODFYx7lnTgaKYmr
         4J57fWRUO9f2YI1MR1bmMbpAvd0v05i+Nc9VNvyu9nTyXKY2FYijuM/WP6jNba7edqgI
         yXxiS6HAR5y7WfeJhHCozkjkSNaxYGHt18k80SnVLpelnSDOzgry/VPXzNFPVggsbejN
         +hO+z8S87Pj8d2Ht/pb7HRNveyoirab5ZpUjTASx/D574EjlE7wWjfd5KR1QB1WPGj/m
         Lwzp/3tOjJyzpMMYn9vt1lnThBCJcI+YUqsjfyE2YxH1po4Ry4bG/Uf0q3nrVGk9lpF/
         L3tQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=B+pNjSsOXVhftKuiaHhDVJpkD20xz5OLcn7WggmPyYE=;
        b=eE3SORoON+DoC8JZ96z0GMEjZUVN3kj6SRXmKtFFHZiD9C9aJBTBTS4LYrq3aW9WYe
         wCcaMsurBPwS7mtAdn58AnfYFEUkrWapW94npeB52zzrKvnagOvIY13q1PwkfcZdo3aP
         Wpv02/HKKS2RcMi9uSKNzmM00oXvApwESTryUHOL2W+ju6TCRueaQvSsOtyHATSJpaJd
         ew3eLM+z1uGFWq0EN3afyC/SeqsKKbjhB3mYKavSCcTPW+aOEyKIAdqDIW6GKVmoY3lL
         bjTsEMdftbSqFlB1IPqSmCTF6KbuuiUebLHEH9dCyDvZbt3QvWCS1MzR0jUdHNMCy/FB
         SzQg==
X-Gm-Message-State: APjAAAXSXJG2o7RTWAlaTuC7oD8RJYs6nGYvS0toGem8ubEdJ/2OEkUC
        0R2UegrLUzpg7YXju9/3bTvVTe8LvBV/RNaTQpk=
X-Google-Smtp-Source: APXvYqziTa3+m3XJlAXD8rguytyclXCWsGvSshKBfJMNqc6Zp4p4Bk1+BiWQzvhzOm7O+/WKSS+Z2zDM6HuVnN9HF/o=
X-Received: by 2002:a5e:8701:: with SMTP id y1mr12255934ioj.78.1551740173417;
 Mon, 04 Mar 2019 14:56:13 -0800 (PST)
MIME-Version: 1.0
References: <1551449184-7942-1-git-send-email-wshilong1991@gmail.com>
 <1551449184-7942-3-git-send-email-wshilong1991@gmail.com> <CAKgNAkitiDEYSZDnJ5iQ6coaE=q45BHxnG2z_bZtWs=kk+2g3w@mail.gmail.com>
 <20190304205006.GX23020@dastard>
In-Reply-To: <20190304205006.GX23020@dastard>
From:   Eugene Syromyatnikov <evgsyr@gmail.com>
Date:   Mon, 4 Mar 2019 23:56:09 +0100
Message-ID: <CACGkJdsdVPKNOnhuAza=Lnh1b=KW2N2yycp6YxJ2tsLFxWJiYg@mail.gmail.com>
Subject: Re: [PATCH 2/2] statx.2: add project support update
To:     Dave Chinner <david@fromorbit.com>
Cc:     "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>,
        Wang Shilong <wangshilong1991@gmail.com>,
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

On Mon, Mar 4, 2019 at 9:57 PM Dave Chinner <david@fromorbit.com> wrote:
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
> Basically, it's just another quota ID that can be used to account
> for files/directories in arbitrary admin defined groups. i.e. quotas
> that aren't bound by user/group identities.
>
> $ man 8 xfs_quota
> $ man 5 projects
> $ man 5 projid

Project quotas also mentioned in quotactl(2).

-- 
Eugene Syromyatnikov
mailto:evgsyr@gmail.com
xmpp:esyr@jabber.{ru|org}
