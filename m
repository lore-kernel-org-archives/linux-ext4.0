Return-Path: <SRS0=gd00=QI=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A9293C282D8
	for <linux-ext4@archiver.kernel.org>; Fri,  1 Feb 2019 18:32:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 66CA3218A6
	for <linux-ext4@archiver.kernel.org>; Fri,  1 Feb 2019 18:32:17 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=intel-com.20150623.gappssmtp.com header.i=@intel-com.20150623.gappssmtp.com header.b="xIgBkEu7"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726495AbfBAScR (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Fri, 1 Feb 2019 13:32:17 -0500
Received: from mail-it1-f196.google.com ([209.85.166.196]:38127 "EHLO
        mail-it1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725797AbfBAScQ (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Fri, 1 Feb 2019 13:32:16 -0500
Received: by mail-it1-f196.google.com with SMTP id z20so11218250itc.3
        for <linux-ext4@vger.kernel.org>; Fri, 01 Feb 2019 10:32:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=5+uHPQ/WwBZSH+fvo2HTpUnqFi+YNjf1IN/bTarj72Q=;
        b=xIgBkEu7KF5BOGhTXp1ki16IFoIvyuUldw1dQgXbzzIoDRSqti5KGR+2haEIYkHk8C
         r5XHjmII8mEdVrPBoGW1C6EYgPvzxzw4NOUJm3f5MHjha5W1/ZfvU3D6cjcYClRyCdlL
         GBMmnP+hrDws+6tTbrjjFpcpS6n1hS7pFJmwiGzyK0zGFwRJqmn8UOKIT1BwYFoO9o2M
         mo/x1uHUKnheV6wYskT2bAG/NfEOb0C7O9JEaCI5/KsH3Sa/7r7PdnMzjm6waZPT1FhR
         NslgFUIIY3m4RsY94EgbIuG8wNlAhVW3yLXs1SvtRXS3iULCFZYeHk2xv1uDKFDeUZ5r
         sOJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=5+uHPQ/WwBZSH+fvo2HTpUnqFi+YNjf1IN/bTarj72Q=;
        b=CnHWZMc2VMera7VJB8+LeLkFxWIbR9v5cPUSwhX5X/luc6uwviy9Z4KAc/j32Q65RH
         IgRPhwtA0AxY5EhQmdbZj4ctpCqc7OfArT2gY/V3+hvgNQx+3AR4Va+Jmftu7u3t2i2P
         Uc91Jz3Mte7p6l0D8YMRA8T1/b2uwln07LQkkKhN2FxnDQ8bLBijvKfj86Avd3g2M6V0
         HRehp0YA1ZFbgD4ng0Btmj5Wn8O9c59HkoZl33+7KE6IrDfhQiCQR7i3Wg9xH9hA8d/l
         AcECbcQy8mqJLuozcGtqOTqYFhJRFrNR4pzXBM28jbPcZxCjs2S/hBp4gpa24aXmEsfu
         cPOg==
X-Gm-Message-State: AHQUAuZz1SQYt/Ytf2rj6LVEXjI1If8h8wSxkt1drib4DkAp4O/2G5UP
        IzmeD+XtNhT/46kLwi5+0cVm08T77presSTB8/Me+w==
X-Google-Smtp-Source: AHgI3IaWb4Ja07aMxbvZjdf5H+E9zMX7bcDTm1zXdFe+YxNfufzzEkisXe6rmxo41Q8L3E9G1mYCBa2C5Fzbx1FNS0k=
X-Received: by 2002:a24:8e43:: with SMTP id h64mr2108390ite.26.1549045935761;
 Fri, 01 Feb 2019 10:32:15 -0800 (PST)
MIME-Version: 1.0
References: <20190201125159.31880-1-ross.burton@intel.com> <20190201174715.GB10211@magnolia>
In-Reply-To: <20190201174715.GB10211@magnolia>
From:   "Burton, Ross" <ross.burton@intel.com>
Date:   Fri, 1 Feb 2019 18:32:04 +0000
Message-ID: <CAJTo0LZbC9n4AJR4mvnxHxGCPQOnqzbkfXkrwZuL-70-EewmUQ@mail.gmail.com>
Subject: Re: [PATCH] create_inode: fix copying large files
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-ext4 <linux-ext4@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

Yeah, you're right, thanks for the review.

Ross

On Fri, 1 Feb 2019 at 17:47, Darrick J. Wong <darrick.wong@oracle.com> wrote:
>
> On Fri, Feb 01, 2019 at 12:51:59PM +0000, Ross Burton wrote:
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
> > ---
> >  misc/create_inode.c | 4 ++--
> >  1 file changed, 2 insertions(+), 2 deletions(-)
> >
> > diff --git a/misc/create_inode.c b/misc/create_inode.c
> > index 05aa6363..f106dcda 100644
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
> > @@ -481,7 +481,7 @@ static errcode_t try_lseek_copy(ext2_filsys fs, int fd, struct stat *statbuf,
> >                       return EXT2_ET_UNIMPLEMENTED;
> >
> >               data_blk = data & ~(fs->blocksize - 1);
>
> Do we need to cast this one too?  ^^^^^^^
>
> (Looks reasonable otherwise...)
>
> --D
>
> > -             hole_blk = (hole + (fs->blocksize - 1)) & ~(fs->blocksize - 1);
> > +             hole_blk = (hole + (off_t)(fs->blocksize - 1)) & ~(off_t)(fs->blocksize - 1);
> >               err = copy_file_chunk(fs, fd, e2_file, data_blk, hole_blk, buf,
> >                                     zerobuf);
> >               if (err)
> > --
> > 2.11.0
> >
