Return-Path: <SRS0=aCZM=QN=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AF61DC169C4
	for <linux-ext4@archiver.kernel.org>; Wed,  6 Feb 2019 11:01:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 798962184E
	for <linux-ext4@archiver.kernel.org>; Wed,  6 Feb 2019 11:01:14 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=intel-com.20150623.gappssmtp.com header.i=@intel-com.20150623.gappssmtp.com header.b="r1cfWY2E"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728057AbfBFLBO (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Wed, 6 Feb 2019 06:01:14 -0500
Received: from mail-it1-f196.google.com ([209.85.166.196]:36923 "EHLO
        mail-it1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726159AbfBFLBN (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Wed, 6 Feb 2019 06:01:13 -0500
Received: by mail-it1-f196.google.com with SMTP id b5so5339293iti.2
        for <linux-ext4@vger.kernel.org>; Wed, 06 Feb 2019 03:01:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=4VyziZ7CYiOfeK740HlMExr+At/aLD2P7WbXgkWIsQE=;
        b=r1cfWY2E7V2nbrp8LzIJk/vOEEUmaWCcrRw4lSq0MFWUZBu9WsngYVQ3Hr5GJHi9FG
         HMayVtlyDBRw1QD/QEgbIVunQyVuvCkfn9BWHPPu1pjNLRNsWUuGH9Bo8y2xd4I2VHCC
         BfY1ppLJrdgwyx6uHDWHICqE3lh/JsN/LQ6J+spuO2J1s+pF+QJ9KrPVlFUoWJtgw8+o
         lEMgey07RzG6bdR9H7pEXBfLTGMecOM/IEuH47OwEhRFG74fZ1+mOodtenF5W1fyme73
         +DahOO5aNSb8+9mpqVCkQHmSV4FQTr4Uulcqlh1dJPX9i31riDXrw6cAsiVkGUlRY5He
         14wQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=4VyziZ7CYiOfeK740HlMExr+At/aLD2P7WbXgkWIsQE=;
        b=NJK61+Pud1BPlVJE701Iu/6CFbTO6OJa2bwZ1YHokFxqiBGPWGnDdRGREsq19MpyNE
         mGffqtv1BPikjIV4/TQ34Eouq1cEyosjs+CUHbJ+SDcHVaUL+ZC70u8anMljdqjK/S7y
         BMfTl3VFPkTFp8xkSMB/xl0YxkI4U8nVmrBG9I+nhZBGCl1oy0QZpxum/3BMw9tw2O9b
         oPMHKY6mUPYx2sSYeQXvSs//fxRFeH8jyolsPT1/Zsl0QNEqjTKP9WbLwKfNETXIQk/4
         /drTXlbQmKd2Q+8da39niz39Z9/RbXHqCi1oo08QfBdN2Fh1hn3TvLPqlvJNeAa+895X
         G0mA==
X-Gm-Message-State: AHQUAuYqZeZeiO7oqGbpE3t+5bOaCxhts63BsuS6Fm5TqsqVBoTqbQEc
        7g2ZQ4ZHKdSPpHUxD6Aon7yglkoLjvVU2jk0pS7Q8Q==
X-Google-Smtp-Source: AHgI3IYGBS+Y2dqJJX8m521V14FbymalV+YR/6CSivhftMHWBt11DFMxNqGJInKs2mcXCXtsdLXAdOaF/LwupnHTgME=
X-Received: by 2002:a05:660c:a48:: with SMTP id j8mr887755itl.26.1549450872585;
 Wed, 06 Feb 2019 03:01:12 -0800 (PST)
MIME-Version: 1.0
References: <20190201183247.8148-1-ross.burton@intel.com> <20190201185950.GC10211@magnolia>
In-Reply-To: <20190201185950.GC10211@magnolia>
From:   "Burton, Ross" <ross.burton@intel.com>
Date:   Wed, 6 Feb 2019 11:01:01 +0000
Message-ID: <CAJTo0LafMp_Qsn0pmt6--A5mDVdmVJAO5LdEZH5ofieio=OUaA@mail.gmail.com>
Subject: Re: [PATCH v2] create_inode: fix copying large files
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-ext4 <linux-ext4@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

Gentle reminder to the maintainers that this patch hasn't been merged yet.

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
