Return-Path: <SRS0=Hf1J=AF=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0EEC0C433E0
	for <linux-ext4@archiver.kernel.org>; Wed, 24 Jun 2020 07:06:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E1F6320823
	for <linux-ext4@archiver.kernel.org>; Wed, 24 Jun 2020 07:06:35 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="Njq33ouX"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389508AbgFXHGf (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Wed, 24 Jun 2020 03:06:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38802 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389394AbgFXHGf (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Wed, 24 Jun 2020 03:06:35 -0400
Received: from mail-io1-xd41.google.com (mail-io1-xd41.google.com [IPv6:2607:f8b0:4864:20::d41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F15F2C061573
        for <linux-ext4@vger.kernel.org>; Wed, 24 Jun 2020 00:06:34 -0700 (PDT)
Received: by mail-io1-xd41.google.com with SMTP id i25so1051811iog.0
        for <linux-ext4@vger.kernel.org>; Wed, 24 Jun 2020 00:06:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=TUDOw/nswOy6VTrP5WJy+2KDltjynrxdxmkff108f3k=;
        b=Njq33ouXw7BfZKHVc+pDB9SkGbdF6p5afETL53pFlIvRM7ajVppHGB4hIvLlF8Wco0
         aXnMCCeY5BqOpZLzIRRd7VtLCYr1NpB5OjC5Hl2xt9gcx1z0RvKkDvBKqsxVE79JFxQo
         D4aul9tQLypEQy92AeIsKAPv8x2EjpGTPNDsI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=TUDOw/nswOy6VTrP5WJy+2KDltjynrxdxmkff108f3k=;
        b=Fsdn/GqvwnCCr9QtlfgiC03JyZRl2lviJaIpPDt+7xUST2UY+PWeImO/V6U0FDyei4
         2YV4j/cs9HXgJYLDkvixq4JCi273EW8N2aVTk8IRbJsejfCBYm0MWT0YdlS/bsxvW5xL
         Yvymu1E/6Jq+OwMdrUrAqW9MwMme+07mXEnhir/cdJq4R+ZBY07Ul1uQ712iBGI+L4m7
         REDG9RPdhlPvq8FSrxU84zSQ+GC5z3zu9UfzUEqf9+qxoZgehHTmtmqbADk8xIjXzKDb
         Z5V1jQKCMtEDMpPY0NA/IxVTEPN3c0MFy2Yl74Z7haRtw5I6oWIaVWpfgUyAKHse7kfk
         WLhA==
X-Gm-Message-State: AOAM531c8trvsn6gbzddx/Ofypn9hpidU6qt3TF/X/I/cSgcmiTd2E9x
        SMPNf5IXaBtNwEWWLLVYMUfxAMMeeskSjIrf1pXtJw9H
X-Google-Smtp-Source: ABdhPJxr+/M9GJbK1V8NfywyvZQP5lUY2kEKHoB0iNYJ1brgWpjhfaYK8woB+XIGMs6tKCDLFg9j/ZpMfo/z+hz28CI=
X-Received: by 2002:a02:3501:: with SMTP id k1mr27581685jaa.133.1592982394222;
 Wed, 24 Jun 2020 00:06:34 -0700 (PDT)
MIME-Version: 1.0
References: <20200624023107.182118-1-gwendal@chromium.org> <20200624024043.GA844@sol.localdomain>
In-Reply-To: <20200624024043.GA844@sol.localdomain>
From:   Gwendal Grignou <gwendal@chromium.org>
Date:   Wed, 24 Jun 2020 00:06:22 -0700
Message-ID: <CAPUE2uv0XXv40quqbKmdktgCD18DnSWh=Ekeiq2tAZOfmGmjGw@mail.gmail.com>
Subject: Re: [PATCH] tune2fs: allow remove VERITY
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     Sarthak Kukreti <sarthakkukreti@chromium.org>, tytso@mit.edu,
        linux-ext4@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

On Tue, Jun 23, 2020 at 7:40 PM Eric Biggers <ebiggers@kernel.org> wrote:
>
> On Tue, Jun 23, 2020 at 07:31:07PM -0700, Gwendal Grignou wrote:
> > Allow verity flag to be removed from the susperblock:
> > Tests:
> > - check the signed file is readable by older kernel after flag
> > is removed. EXT4_VERITY_FL replaces EXT4_EXT_MIGRATE that has been
> > removed in 2009.
> > - when a new kernel is reinstalled, check reenabling verity flag
> > allow signature to be verified (fsverity measure ...).
> >
> > Signed-off-by: Gwendal Grignou <gwendal@chromium.org>
> > ---
> >  misc/tune2fs.c | 3 ++-
> >  1 file changed, 2 insertions(+), 1 deletion(-)
> >
> > diff --git a/misc/tune2fs.c b/misc/tune2fs.c
> > index 314cc0d0..724b8014 100644
> > --- a/misc/tune2fs.c
> > +++ b/misc/tune2fs.c
> > @@ -198,7 +198,8 @@ static __u32 clear_ok_features[3] = {
> >               EXT4_FEATURE_RO_COMPAT_QUOTA |
> >               EXT4_FEATURE_RO_COMPAT_PROJECT |
> >               EXT4_FEATURE_RO_COMPAT_METADATA_CSUM |
> > -             EXT4_FEATURE_RO_COMPAT_READONLY
> > +             EXT4_FEATURE_RO_COMPAT_READONLY |
> > +             EXT4_FEATURE_RO_COMPAT_VERITY
> >  };
> >
>
> tune2fs doesn't allow removing features like encrypt, casefold, verity, extents,
> and ea_inode because it doesn't know whether there are any inodes on the
> filesystem that are using these features.  These features can't be removed if
> there are any inodes using them.
The verity case is slightly different though: beside metadata,
encrypted files are useless.
In the case of fs-verity, the file is still readable, its size is
correct. Using debugfs, I checked the merkel tree blocks appended at
the end of the file are still mapped to the file inode, they are
marked as free when the file is removed.
Are you concerned about filesystem corruption? When I re-enable the
features and load a kernel that supports fs-verity, the protected
files are signed and read-only as expected.

>
> There was recently a suggestion to make tune2fs scan the inode table to
> determine whether it is safe to remove these flags; see
> https://lkml.kernel.org/linux-ext4/C0761869-5FCD-4CC7-9635-96C18744A0F8@dilger.ca
> and
> https://lkml.kernel.org/linux-ext4/20200407053213.GC102437@sol.localdomain
The intent is to be able to rollback to an older kernel. Given the
file system will contain files protected by fs-verity, tune2fs will
not be able to remove the feature.
>
> I think you'd need to implement that in order for clearing verity to be safe.
>
> Note that misc/tune2fs.8.in would also need to be updated to remove the sentence
> that says that clearing the verity feature is unsuppported.
Will do.

Gwendal.
>
> - Eric
