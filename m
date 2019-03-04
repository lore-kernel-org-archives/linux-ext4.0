Return-Path: <SRS0=/gtt=RH=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 08CFCC4360F
	for <linux-ext4@archiver.kernel.org>; Mon,  4 Mar 2019 13:53:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CE93720652
	for <linux-ext4@archiver.kernel.org>; Mon,  4 Mar 2019 13:53:14 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="I62yiwA8"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726986AbfCDNxN (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Mon, 4 Mar 2019 08:53:13 -0500
Received: from mail-ed1-f68.google.com ([209.85.208.68]:45085 "EHLO
        mail-ed1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726972AbfCDNxM (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Mon, 4 Mar 2019 08:53:12 -0500
Received: by mail-ed1-f68.google.com with SMTP id f19so4286131eds.12;
        Mon, 04 Mar 2019 05:53:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:reply-to:from:date:message-id
         :subject:to:cc;
        bh=Aqn0FgprPpcUJTvZw9W0jjvXV1aa3LPVwcN9c3ILpd4=;
        b=I62yiwA8y+a7QOGGPEPKpG67W8Kw6l5ZiEVok/xn09H7YtY4VkCLybsMa1Q/xqh009
         jezmzbAStVTyFSSFJqy8KBj4mmSollElIVkm9PpwURvXToX6FTomHZ3qwiy6lB3/VvSz
         agL4lQIOBSL1enKmll2rR0GfScFqGlLnHoN0vGSv5E/RI3cfZpHBXOXoxQ2wNKt6wugr
         ojDTk/o4SNlIQXsTMu1r5Mj3SGio10WZwc3KzEEbEWojkSr7/ISRAPS36hW+HW7VFj1O
         OowNkhfmxXKLx6AMW1mTOWzC4peRtl7RrHGOIEJSEmgMHFbziUGWRASXbD1pdRD/qM17
         Ne3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:reply-to
         :from:date:message-id:subject:to:cc;
        bh=Aqn0FgprPpcUJTvZw9W0jjvXV1aa3LPVwcN9c3ILpd4=;
        b=ucMyxOCQM5PiEbW3FfZnVeSfA0Okn6VLWz0DorTTdHt9xmZR6WmlEbqsmyBj/oS41h
         Ho/i1ufmDZ0uG0sBN6JFoZxWNt2XRSrhELpI1TzcN3R/6wRFh/LtYbcFAO1781YLJ26L
         IXi0yXZgJvAGzzBujAoxFT1NxtDZZQCiWfiGw1NkbSVPqqtiq+JQnF+FnkbordP009mQ
         aMO2gyMLQZvn1/W9qNlpMkdxXyHl+c7N8E6h9iscitzPAl50a/8W5HzKoomZh+pXKite
         hsvBdXGr+1xPsYFi9GGpb5b9N5nnE8tZ5tBJfd/XqqV4v6VW/jA1MNQgQ3lOjxm3LakR
         JltA==
X-Gm-Message-State: APjAAAXFLRoaB75kjZvhbX11QpHn99vxTVfLp+AKC0ZsUN6DBjb/35kE
        h6QQV5hETqw2CdkbCECrZiVTQSk6PAYoMiNtS6o=
X-Google-Smtp-Source: APXvYqxanepC/uCNf2ABN1tg6/YS2wL9+JfYMoH72PgMUDkwokpqsHmvG3uJeCuvnxDAYnKeCFGeFkhxyKoMXoeIJ1E=
X-Received: by 2002:a17:906:28c7:: with SMTP id p7mr12976741ejd.235.1551707589760;
 Mon, 04 Mar 2019 05:53:09 -0800 (PST)
MIME-Version: 1.0
References: <1551449184-7942-1-git-send-email-wshilong1991@gmail.com> <1551449184-7942-3-git-send-email-wshilong1991@gmail.com>
In-Reply-To: <1551449184-7942-3-git-send-email-wshilong1991@gmail.com>
Reply-To: mtk.manpages@gmail.com
From:   "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>
Date:   Mon, 4 Mar 2019 14:52:59 +0100
Message-ID: <CAKgNAkitiDEYSZDnJ5iQ6coaE=q45BHxnG2z_bZtWs=kk+2g3w@mail.gmail.com>
Subject: Re: [PATCH 2/2] statx.2: add project support update
To:     Wang Shilong <wangshilong1991@gmail.com>
Cc:     "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
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

Hello Wang Shilong,

On Fri, 1 Mar 2019 at 15:06, Wang Shilong <wangshilong1991@gmail.com> wrote:
>
> From: Wang Shilong <wshilong@ddn.com>

I take it that these patches relate to some API changes that are not
yet merged into the kernel, right?

Also, I think we need some accompanying info to describe project IDs.
Can you point me at any documents/resources?

Thanks,

Michael

>
> Cc: linux-man@vger.kernel.org
> Signed-off-by: Wang Shilong <wshilong@ddn.com>
> ---
>  man2/statx.2 | 8 ++++++++
>  1 file changed, 8 insertions(+)
>
> diff --git a/man2/statx.2 b/man2/statx.2
> index 7265d8ace..6a9dede8b 100644
> --- a/man2/statx.2
> +++ b/man2/statx.2
> @@ -82,6 +82,7 @@ struct statx {
>         containing the filesystem where the file resides */
>      __u32 stx_dev_major;   /* Major ID */
>      __u32 stx_dev_minor;   /* Minor ID */
> +    __u32 stx_projid;      /* Project ID of file */
>  };
>  .EE
>  .in
> @@ -261,6 +262,7 @@ STATX_SIZE  Want stx_size
>  STATX_BLOCKS   Want stx_blocks
>  STATX_BASIC_STATS      [All of the above]
>  STATX_BTIME    Want stx_btime
> +STATX_PROJID   Want stx_projid
>  STATX_ALL      [All currently available fields]
>  .TE
>  .in
> @@ -412,6 +414,9 @@ The device on which this file (inode) resides.
>  .IR stx_rdev_major " and "  stx_rdev_minor
>  The device that this file (inode) represents if the file is of block or
>  character device type.
> +.TP
> +.I stx_projid
> +The file's project ID.
>  .PP
>  For further information on the above fields, see
>  .BR inode (7).
> @@ -458,6 +463,9 @@ See
>  .TP
>  .B STATX_ATTR_ENCRYPTED
>  A key is required for the file to be encrypted by the filesystem.
> +.TP
> +.B STATX_ATTR_PROJINHERIT
> +Sub directories or files will inherit parent's project ID automatically.
>  .SH RETURN VALUE
>  On success, zero is returned.
>  On error, \-1 is returned, and
> --
> 2.19.1
>


-- 
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
Linux/UNIX System Programming Training: http://man7.org/training/
