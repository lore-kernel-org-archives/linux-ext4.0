Return-Path: <linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_IN_DEF_DKIM_WL autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4036FC63777
	for <linux-ext4@archiver.kernel.org>; Mon, 30 Nov 2020 22:23:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E1C7F2076C
	for <linux-ext4@archiver.kernel.org>; Mon, 30 Nov 2020 22:23:32 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="k/30DKax"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730608AbgK3WXP (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Mon, 30 Nov 2020 17:23:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36770 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730601AbgK3WXO (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Mon, 30 Nov 2020 17:23:14 -0500
Received: from mail-pl1-x644.google.com (mail-pl1-x644.google.com [IPv6:2607:f8b0:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC75CC0613CF
        for <linux-ext4@vger.kernel.org>; Mon, 30 Nov 2020 14:22:33 -0800 (PST)
Received: by mail-pl1-x644.google.com with SMTP id l11so7317004plt.1
        for <linux-ext4@vger.kernel.org>; Mon, 30 Nov 2020 14:22:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=5BCfceYCUFklibw9iNkTt59HaVog15eTd5t3bjImEAQ=;
        b=k/30DKaxucqttsaNv21BmbQpUbdkRX7IMney19Y1tduMHegrd/CAjDqpTb9VTFLiSc
         JqiSt1G74qTGBZcEKSlxJ3gJK12B3E3iHH2TkQ386cz2gWsDVBigYwZFoef+nSblQlY7
         vIjHZZOj2b+qYVwg/ALqtsiYPXxaMndHgWKkyqKNkkUHOY8rTSZnXReUBjG0DsTxevL5
         GAx6LHBjgvSZcDtU9E+J/BDB76C5mmp4rEuUJfLwxLF0W9SH4BjGOb/2GUKNsqowvZfX
         9qfR75HzCN2naDEWguSo9CMRLL1bN2myTp7V7364O6gnZ9SkzLRpu782zs587e5todSD
         IosA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=5BCfceYCUFklibw9iNkTt59HaVog15eTd5t3bjImEAQ=;
        b=VbFDTG0FHw0/vWj9y8l13viRX86/BHynaWPXtAPCwEeg9HdmX8C+H/z2yjrJSE8c0C
         Y2T/ljqXKdwjgWNXTKSe9K9FWxpXjbZYJAd0HOVJoEe05ZxSKQ63q/e0w73pwFSULYt4
         GFT9v+/Gx5SBYganrJMh6111X1cBWDxt4vjXvyxVHwiLqnCgHBwclBmypmYRh+oZVig5
         A7SozdzRFgdkCqQy4c6pLUAYfMAvBtqYZNmZMr4LL4K5H4yTv7GxhyU6iW8q3bRy92zA
         cz8h9ii3UZXXtAsCvUHAuODLuwqG20mPSE594OXkVLI94AqGurS9IId1egyQAsA/PkdM
         xNNg==
X-Gm-Message-State: AOAM533cyT2i4N6ufN+DRl8xg3aywQCInMLCA5/9LVa8A95aV/WWURKL
        p48ALNV5OIHu/8FoiVwd91Dks149EFqIVY9ini8UQQ==
X-Google-Smtp-Source: ABdhPJymnzMjQYaV36tfcsaWeQNndkZiyZt8GSPuPs9LDVcg2/Mtb4fw9vRNDoGfuR+OgWdHmwqJAxuCgSpXcv55qPY=
X-Received: by 2002:a17:90b:3658:: with SMTP id nh24mr1090414pjb.80.1606774953049;
 Mon, 30 Nov 2020 14:22:33 -0800 (PST)
MIME-Version: 1.0
References: <20201116054035.211498-1-98.arpi@gmail.com> <CABVgOSkoQahYqMJ3dD1_X2+rF3OgwT658+8HRM2EZ5e0-94jmw@mail.gmail.com>
 <CANpmjNOhb13YthVHmXxMjpD2JZUO4H2Z1KZSKqHeFUv-RbM5+Q@mail.gmail.com> <CABVgOSnGnkCnAyAqVoLhMGb6XV_irtYB7pyOTon5Scab8GxKtg@mail.gmail.com>
In-Reply-To: <CABVgOSnGnkCnAyAqVoLhMGb6XV_irtYB7pyOTon5Scab8GxKtg@mail.gmail.com>
From:   Brendan Higgins <brendanhiggins@google.com>
Date:   Mon, 30 Nov 2020 14:22:22 -0800
Message-ID: <CAFd5g4768o7UtOmM3X0X5upD0uF3j-=g3txi0_Ue3z8oM_Ghow@mail.gmail.com>
Subject: Re: [PATCH v9 1/2] kunit: Support for Parameterized Testing
To:     David Gow <davidgow@google.com>
Cc:     Marco Elver <elver@google.com>, "Theodore Ts'o" <tytso@mit.edu>,
        Shuah Khan <skhan@linuxfoundation.org>,
        Arpitha Raghunandan <98.arpi@gmail.com>,
        Iurii Zaikin <yzaikin@google.com>,
        Andreas Dilger <adilger.kernel@dilger.ca>,
        "Bird, Tim" <Tim.Bird@sony.com>,
        "open list:KERNEL SELFTEST FRAMEWORK" 
        <linux-kselftest@vger.kernel.org>,
        KUnit Development <kunit-dev@googlegroups.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-kernel-mentees@lists.linuxfoundation.org,
        linux-ext4@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

On Mon, Nov 23, 2020 at 11:25 PM David Gow <davidgow@google.com> wrote:
>
> On Mon, Nov 23, 2020 at 9:08 PM Marco Elver <elver@google.com> wrote:
> >
> > On Tue, 17 Nov 2020 at 08:21, David Gow <davidgow@google.com> wrote:
> > > On Mon, Nov 16, 2020 at 1:41 PM Arpitha Raghunandan <98.arpi@gmail.com> wrote:
> > > >
> > > > Implementation of support for parameterized testing in KUnit. This
> > > > approach requires the creation of a test case using the
> > > > KUNIT_CASE_PARAM() macro that accepts a generator function as input.
> > > >
> > > > This generator function should return the next parameter given the
> > > > previous parameter in parameterized tests. It also provides a macro to
> > > > generate common-case generators based on arrays. Generators may also
> > > > optionally provide a human-readable description of parameters, which is
> > > > displayed where available.
> > > >
> > > > Note, currently the result of each parameter run is displayed in
> > > > diagnostic lines, and only the overall test case output summarizes
> > > > TAP-compliant success or failure of all parameter runs. In future, when
> > > > supported by kunit-tool, these can be turned into subsubtest outputs.
> > > >
> > > > Signed-off-by: Arpitha Raghunandan <98.arpi@gmail.com>
> > > > Co-developed-by: Marco Elver <elver@google.com>
> > > > Signed-off-by: Marco Elver <elver@google.com>
> > > > ---
> > > [Resending this because my email client re-defaulted to HTML! Aarrgh!]
> > >
> > > This looks good to me! I tested it in UML and x86-64 w/ KASAN, and
> > > both worked fine.
> > >
> > > Reviewed-by: David Gow <davidgow@google.com>
> > > Tested-by: David Gow <davidgow@google.com>
> >
> > Thank you!
> >
> > > Thanks for sticking with this!
> >
> > Will these patches be landing in 5.11 or 5.12?
> >
>
> I can't think of any reason not to have these in 5.11. We haven't
> started staging things in the kselftest/kunit branch for 5.11 yet,
> though.
>
> Patch 2 will probably need to be acked by Ted for ext4 first.
>
> Brendan, Shuah: can you make sure this doesn't get lost in patchwork?

Looks good to me. I would definitely like to pick this up. But yeah,
in order to pick up 2/2 we will need an ack from either Ted or Iurii.

Ted seems to be busy right now, so I think I will just ask Shuah to go
ahead and pick this patch up by itself and we or Ted can pick up patch
2/2 later.

Cheers
