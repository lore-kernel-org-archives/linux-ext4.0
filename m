Return-Path: <SRS0=EtEF=SK=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E700BC282DD
	for <linux-ext4@archiver.kernel.org>; Mon,  8 Apr 2019 06:21:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B716520880
	for <linux-ext4@archiver.kernel.org>; Mon,  8 Apr 2019 06:21:00 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Rx88oJdv"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726456AbfDHGVA (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Mon, 8 Apr 2019 02:21:00 -0400
Received: from mail-yb1-f195.google.com ([209.85.219.195]:41421 "EHLO
        mail-yb1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725854AbfDHGVA (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Mon, 8 Apr 2019 02:21:00 -0400
Received: by mail-yb1-f195.google.com with SMTP id c15so4713389ybk.8;
        Sun, 07 Apr 2019 23:20:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=V1hfycwz+T8gKzXC1mEa3ufVAa0p9RIkob73pxd6Heg=;
        b=Rx88oJdvfbYbHfcyuYhp/HIwLgUliSzUzf9wUqkfo+IG9Z0gjcB0ovemEo39/g6R2n
         8qaI4yWCYPfJoYKsvt5Uf5MVQKmswZHay9LLbBrLO2DR0vTauFX9K16ah59wQTB11CNQ
         UTsQv7oRxk7OslVY9/BvCl1MRWQHP+TsICnT3deM71isDZlLeengy3I6gcpHFLK6baHi
         3NNKjrM/PX5QZvK4V0a24M9XEerAsp/08KEIDdUxbzKtKlRMmVCE5qcPSqCsc9+bBXwt
         5GzRnOXccH+HSbmR3tAGSJSg1+oOkOzXHDH7STRQzbbMDPqH7sBi3xMWfWwbJgckEAiC
         aCRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=V1hfycwz+T8gKzXC1mEa3ufVAa0p9RIkob73pxd6Heg=;
        b=Xsz/QQJlqkh2cqrFpkkRaiyX5kE06ysQgMQBHOACbPW3Ef1AOTx5B+STdSd5DFKeh+
         fnd9iQgFrAzU/8DGe6V4kxWpOp3H2xKsr357HJa+3zW/Rq8yR5rHAmczE8hwVMx8i5iA
         zukCJhGLVJp1czW1wnXOP3VJsklAWTgxIxMBmc85W0cVIyNtlcFoQ8FEZkbaGi7sjbro
         LeVNCp7X8FxsUZ6aFki1giHIn+8+tpR7HuHY3KMSmfhtzGsa+hMv1hy/PRJ6vBLhvjx2
         lgM7L/hNbRgm09Yar4otWMGnzAHp5hWRXqusoaTG5647+0Sm6JPgLvjcVJXOGDhh/hes
         Yerg==
X-Gm-Message-State: APjAAAVuVXq/rS2X2mZXTMkp4sDeR397IWI7PYJIufkm18ZJszFaFAaV
        +F40CVwsBzO8QaR+8Zk9mqwVjGQ66NM9wlZ8H5c=
X-Google-Smtp-Source: APXvYqzcGihYsVJQygsz2fv91+mltqJC2lziBlhN0kcSkp2OBWv1mBujCpf/ni6MLrdLjhPaYvcJ/pI6OO9/8E2ylPQ=
X-Received: by 2002:a25:6b06:: with SMTP id g6mr22871030ybc.214.1554704459044;
 Sun, 07 Apr 2019 23:20:59 -0700 (PDT)
MIME-Version: 1.0
References: <155466882175.633834.15261194784129614735.stgit@magnolia> <155466884962.633834.14320700092446721044.stgit@magnolia>
In-Reply-To: <155466884962.633834.14320700092446721044.stgit@magnolia>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Mon, 8 Apr 2019 09:20:47 +0300
Message-ID: <CAOQ4uxj4WLX8sWbnm11Ps+rmCNTPecV-w9YUzJfKDtDs+qTx3Q@mail.gmail.com>
Subject: Re: [PATCH 4/4] xfs: don't allow most setxattr to immutable files
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     Dave Chinner <david@fromorbit.com>,
        linux-xfs <linux-xfs@vger.kernel.org>,
        Linux MM <linux-mm@kvack.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Ext4 <linux-ext4@vger.kernel.org>,
        Linux Btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

On Sun, Apr 7, 2019 at 11:28 PM Darrick J. Wong <darrick.wong@oracle.com> wrote:
>
> From: Darrick J. Wong <darrick.wong@oracle.com>
>
> The chattr manpage has this to say about immutable files:
>
> "A file with the 'i' attribute cannot be modified: it cannot be deleted
> or renamed, no link can be created to this file, most of the file's
> metadata can not be modified, and the file can not be opened in write
> mode."
>
> However, we don't actually check the immutable flag in the setattr code,
> which means that we can update project ids and extent size hints on
> supposedly immutable files.  Therefore, reject a setattr call on an
> immutable file except for the case where we're trying to unset
> IMMUTABLE.
>
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Did you miss my comment on v1, or do you not think this use case
is going to hurt any application that is not a rootkit?

chattr +i foo => OK
chattr +i foo => -EPERM

Thanks,
Amir.
