Return-Path: <SRS0=RF5E=R7=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7423FC4360F
	for <linux-ext4@archiver.kernel.org>; Thu, 28 Mar 2019 21:25:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 44F8F2184E
	for <linux-ext4@archiver.kernel.org>; Thu, 28 Mar 2019 21:25:03 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="k5fGldQp"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727225AbfC1VZA (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Thu, 28 Mar 2019 17:25:00 -0400
Received: from mail-yw1-f66.google.com ([209.85.161.66]:38504 "EHLO
        mail-yw1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726268AbfC1VZA (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Thu, 28 Mar 2019 17:25:00 -0400
Received: by mail-yw1-f66.google.com with SMTP id m207so6562740ywd.5;
        Thu, 28 Mar 2019 14:25:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=+5hDRqCC4Yz7e19xR7ypxPfWKLZ6F+sf7ORQmgcR9Ps=;
        b=k5fGldQpVI0bwsgIZNr9pXognzOfQvw5xFDhUL7N+zK6kdMbOoGBjgvosPG29RWwLi
         lw29EFJqYdKmc6UHgxTRSvab4ooaaBXrtxJIklUQx+K36ExLyoD+O+Kc4ydeRy5T5lTI
         btB6Q51tBV5SLbomzbqjtuhO+exQ8c1ArjLZRFvyoFxh9syQSV1vnMIKA1IT3AdcWMOK
         NNqQ6gflcs2/UtDzHP2D/RQj5YcLQCvR+NB4mnPmHqXj9AYZjkRdbM+Jez2Xw3HZXn8h
         NCKI7RKUVTQ9xmN4h83TKgVt8ekc/AGflRYCC8phl2G1czt1AtwjA7pBn4PtSaqFIB4c
         4AbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=+5hDRqCC4Yz7e19xR7ypxPfWKLZ6F+sf7ORQmgcR9Ps=;
        b=BxP4u4dkOglQKq7V7vOXJq+PDJDnXmE3WPT4Xo9TiILYe6Fz4VEGTf9TrlG7KFMTC6
         nam6J7XfYiKYJQae63bKNnXPRlvht8dHk6k7a1UzcajZDsiWHnj3XSjjw5HQLHqv8uuh
         tAmKU0J02PojvxqxpalMJ3bLbidL/jMN1GOZ9ZLwNgwuR72PgbZyY61ej5VWyLW5z1/X
         1imRB01WwjXx+rhR9KpDxsT42yDFIBuvx3x1sx7SghErYaceR0hX6MDFhjgztmOBIK+L
         97YWz3b8a/dVZK5xFO5VxIJRZ2INj2YQsdSXlsWnJAv3zqaiVBD4bPPNWjLRanLRrX9F
         MZHw==
X-Gm-Message-State: APjAAAXSZfY4lMNygni8vy82IwWTnS8UnJgu/YJyfmBxuKxWWJyu7Oy4
        dPWvsTThy2ei0lZYNDOAD1/2n5rocFd23MMDHjQ=
X-Google-Smtp-Source: APXvYqwYYXQujvgO0SGJ/j2p6/WWoKZg2i6iM5EpYPfHmNXAa0l+VqisTK4JaZddN4+LHCMHdLa+l5R5TpIE7qfdepY=
X-Received: by 2002:a0d:e252:: with SMTP id l79mr36846886ywe.248.1553808299501;
 Thu, 28 Mar 2019 14:24:59 -0700 (PDT)
MIME-Version: 1.0
References: <155379543409.24796.5783716624820175068.stgit@magnolia> <155379545404.24796.5019142212767521955.stgit@magnolia>
In-Reply-To: <155379545404.24796.5019142212767521955.stgit@magnolia>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Thu, 28 Mar 2019 23:24:48 +0200
Message-ID: <CAOQ4uxgTQugRFJnUXA2JcHhzmPzi=PLT4H7UrZKzQzi_eCpVeg@mail.gmail.com>
Subject: Re: [PATCH 3/3] xfs: don't allow most setxattr to immutable files
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs <linux-xfs@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Ext4 <linux-ext4@vger.kernel.org>,
        Linux Btrfs <linux-btrfs@vger.kernel.org>,
        Linux MM <linux-mm@kvack.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

On Thu, Mar 28, 2019 at 7:51 PM Darrick J. Wong <darrick.wong@oracle.com> wrote:
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

I think if preventing modification of projid and extent size hints is what you
are after you should place the check in xfs_ioctl_setattr() and not in
xfs_ioctl_setattr_xflags().

Yes, it sounds tempting to block changes of xfs_ioc_setxflags(),
but it leads you to a trap of 2nd time chattr +i fails on -EPERM,
because chattr(1) doesn't optimize out the SETFLAGS ioctl
in the case of unmodified flags.
I think if you try to fix that, code will get ugly, so I suggest that
you let SETFLAGS slide.

Thanks,
Amir.

> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  fs/xfs/xfs_ioctl.c |    8 ++++++++
>  1 file changed, 8 insertions(+)
>
>
> diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
> index 2bd1c5ab5008..9cf0bc0ae2bd 100644
> --- a/fs/xfs/xfs_ioctl.c
> +++ b/fs/xfs/xfs_ioctl.c
> @@ -1067,6 +1067,14 @@ xfs_ioctl_setattr_xflags(
>             !capable(CAP_LINUX_IMMUTABLE))
>                 return -EPERM;
>
> +       /*
> +        * If immutable is set and we are not clearing it, we're not allowed
> +        * to change anything else in the inode.
> +        */
> +       if ((ip->i_d.di_flags & XFS_DIFLAG_IMMUTABLE) &&
> +           (fa->fsx_xflags & FS_XFLAG_IMMUTABLE))
> +               return -EPERM;
> +
>         /* diflags2 only valid for v3 inodes. */
>         di_flags2 = xfs_flags2diflags2(ip, fa->fsx_xflags);
>         if (di_flags2 && ip->i_d.di_version < 3)
>
