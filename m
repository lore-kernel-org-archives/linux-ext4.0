Return-Path: <SRS0=gd00=QI=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8B374C282DA
	for <linux-ext4@archiver.kernel.org>; Fri,  1 Feb 2019 19:16:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5B60A218AF
	for <linux-ext4@archiver.kernel.org>; Fri,  1 Feb 2019 19:16:45 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=intel-com.20150623.gappssmtp.com header.i=@intel-com.20150623.gappssmtp.com header.b="x4nH9wgx"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731269AbfBATQo (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Fri, 1 Feb 2019 14:16:44 -0500
Received: from mail-it1-f195.google.com ([209.85.166.195]:37457 "EHLO
        mail-it1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731265AbfBATQl (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Fri, 1 Feb 2019 14:16:41 -0500
Received: by mail-it1-f195.google.com with SMTP id b5so11434041iti.2
        for <linux-ext4@vger.kernel.org>; Fri, 01 Feb 2019 11:16:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=VE78OIQKDVd/z4h+cpEyPynnqRzDaDtG6cgsqZxEWJw=;
        b=x4nH9wgxKakQBSJfSXCWBma87VCjeIvgY0yVhIw1ZaAK/0lamiHtjjQwyf1RxhOaE4
         h87ubmzBAPI6lfBi/KgerJBuADSMcErv58w3ZfiBcRxohfRLqRwDkWV4E26MqmC9PrKb
         d6mDsLyK/QWJaR9xpmI40NWepUAqRoftZaTEekltFfUySu8OuYZF4bQT71g05TxyimqH
         gSbbydeziIm8jkIQiPKaboJlceS+P4SN9mvgYEbOo+aqU5UgycSN85eKUBhco+3ovEGn
         ars7h2j9SimpNmy4tmVp+JSDCyCfyZVQEOPTauuARO2FGUW5O9yJFOOnC0fdbWSN3sqf
         SV4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=VE78OIQKDVd/z4h+cpEyPynnqRzDaDtG6cgsqZxEWJw=;
        b=pb0pd2NrI4wftETdkVB8PRtnEQdGlxuI+XdATVwyYU5im3AnCPTbEfmm7maOtSUA7t
         19H9T7WUdlyWOObi7blymw3izGAOmn3bK/+7PEUmajBsG0ikzPDIOThG30RMhPPKhhuG
         YEk7aNVcfYuHpD0PL6vIeKzKW2u0X9qA4l1mEWQbKB99lmJ+OoluzIAs03t53MYJBXpE
         gtm2dcRx4dCfPAADJq4RQIhA0xoCdoT4zWy+14s8WIGa2Rv+SzZwvwboLcaZhEpbCjJS
         AUDYgmaP6Hq7Hr0RZmLtQ7jRHk/N8JLSbrVYa+X3GTrm6t2W7LAYmRTHlCR0yBRzqQi8
         V79w==
X-Gm-Message-State: AHQUAuaWWszVemjfA43rJ11ko14N/eGk/qcPW8BG4F/eiB/AaIOuIhrI
        XAp+Vu1CE5jMcLbXWtI+8/3dX9j2ms557fmMwNX+4w==
X-Google-Smtp-Source: AHgI3IaCGzzQxCgsqaJGm1Q0NNOZu4mP9O12UQYPi+dcliDjEE9Z+tDAM+jnBpY50AQ9uBMoeyEO/acG9Xgjw6fUQgA=
X-Received: by 2002:a24:8e43:: with SMTP id h64mr2218543ite.26.1549048600561;
 Fri, 01 Feb 2019 11:16:40 -0800 (PST)
MIME-Version: 1.0
References: <20190201183247.8148-1-ross.burton@intel.com> <20190201185950.GC10211@magnolia>
In-Reply-To: <20190201185950.GC10211@magnolia>
From:   "Burton, Ross" <ross.burton@intel.com>
Date:   Fri, 1 Feb 2019 19:16:29 +0000
Message-ID: <CAJTo0LYmsT+_Y+tNobeB2RWZ0Ezz05HoRLuMK_377a1+jHsFMw@mail.gmail.com>
Subject: Re: [PATCH v2] create_inode: fix copying large files
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-ext4 <linux-ext4@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

Obviously this was a problem that the test suite should have spotted.
Would it be simple enough to write a test suite to make a 4.1GB file,
put in in a ext with -d, and the md5 the file in the file system?  I
was using sudo and loopback mounts which isn't really ideal for the
test suite.

Ross

On Fri, 1 Feb 2019 at 18:59, Darrick J. Wong <darrick.wong@oracle.com> wrote:
>
> On Fri, Feb 01, 2019 at 06:32:47PM +0000, Ross Burton wrote:
> > When copying large files into a ext filesystem at mkfs time the copy fails at
> > 2^31 bytes in.  There are two problems:
> >
> > copy_file_chunk() passes an offset (off_t, 64-bit typically) to
> > ext2fs_file_lseek() which expects a ext2_off_t (typedef to __u32) so the value
> > is truncated. Solve by calling ext2fs_file_llseek() which takes a u64 offset
> > instead.
> >
> > try_lseek_copy() rounds the data and hole offsets as found by lseek() to block
> > boundaries, but the calculation gets truncated to 32-bits.  Solve by casting the
> > 32-bit blocksize to off_t to ensure this doesn't happen.
> >
> > Signed-off-by: Ross Burton <ross.burton@intel.com>
>
> Looks ok,
> Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
>
> --D
>
> > ---
> >  misc/create_inode.c | 6 +++---
> >  1 file changed, 3 insertions(+), 3 deletions(-)
> >
> > diff --git a/misc/create_inode.c b/misc/create_inode.c
> > index 05aa6363..1b35c769 100644
> > --- a/misc/create_inode.c
> > +++ b/misc/create_inode.c
> > @@ -438,7 +438,7 @@ static errcode_t copy_file_chunk(ext2_filsys fs, int fd, ext2_file_t e2_file,
> >                               ptr += blen;
> >                               continue;
> >                       }
> > -                     err = ext2fs_file_lseek(e2_file, off + bpos,
> > +                     err = ext2fs_file_llseek(e2_file, off + bpos,
> >                                               EXT2_SEEK_SET, NULL);
> >                       if (err)
> >                               goto fail;
> > @@ -480,8 +480,8 @@ static errcode_t try_lseek_copy(ext2_filsys fs, int fd, struct stat *statbuf,
> >               if (hole < 0)
> >                       return EXT2_ET_UNIMPLEMENTED;
> >
> > -             data_blk = data & ~(fs->blocksize - 1);
> > -             hole_blk = (hole + (fs->blocksize - 1)) & ~(fs->blocksize - 1);
> > +             data_blk = data & ~(off_t)(fs->blocksize - 1);
> > +             hole_blk = (hole + (off_t)(fs->blocksize - 1)) & ~(off_t)(fs->blocksize - 1);
> >               err = copy_file_chunk(fs, fd, e2_file, data_blk, hole_blk, buf,
> >                                     zerobuf);
> >               if (err)
> > --
> > 2.11.0
> >
