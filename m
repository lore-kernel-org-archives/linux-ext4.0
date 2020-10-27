Return-Path: <SRS0=Q+OU=EC=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.4 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9090CC55179
	for <linux-ext4@archiver.kernel.org>; Tue, 27 Oct 2020 07:45:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 428B8207F7
	for <linux-ext4@archiver.kernel.org>; Tue, 27 Oct 2020 07:45:06 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="jNrM7jvf"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2508023AbgJ0HpF (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Tue, 27 Oct 2020 03:45:05 -0400
Received: from mail-oi1-f193.google.com ([209.85.167.193]:44663 "EHLO
        mail-oi1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2508011AbgJ0HpF (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Tue, 27 Oct 2020 03:45:05 -0400
Received: by mail-oi1-f193.google.com with SMTP id k27so361577oij.11
        for <linux-ext4@vger.kernel.org>; Tue, 27 Oct 2020 00:45:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=WG1A3q+GZxxNqqxlUx799dEM+Gf5oi4Zi/UVtCCwffw=;
        b=jNrM7jvfPRxxd07tIAC6hcoCPl0lPXyXIhfjz3M82wA8u8RqW35dST2XvWdw+soPGr
         XzhPLgJWuBGMSpqEth9gV6D190uUIPFCKyRBrO95tjHaBREJkc7B90qblOCdXzm/rGSl
         0qS1Eh4lcQKZsukeAv/AuvW/pAvKTNqD2EnBX2Ns8aL2E3v3/LO+LjboR6rVq9eUDPkh
         oYXT1CkZ+nNEPfo2p2cjjrnErgnEJX8SJoEB9J50UhtdY9X0r0StwRpKXYee1CL4VeQM
         4ZTuIXk+hOkzE1vbAkVzIyroYLG/Ht0m2Qv0zuxt/7UCAMKb6T7GrFjWIJK/fp7MShdG
         8d6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=WG1A3q+GZxxNqqxlUx799dEM+Gf5oi4Zi/UVtCCwffw=;
        b=CzXowAAdRMwEpCWRlboj4yY422laS7gOpXDs2+L9MJYL7SWhoZotslsy3jMGA3/hL8
         76XRX2mBKmPEogJFVqCCxPfaHK1dYgZOkubNYX+IYMgRyRzFj6eX50TiejFGsNkslzWW
         6+QeKdbA8aD2dkFmK0JQQxjt9JAT++itSWoxWvjitUEdA3Z9VrtFfxbLFQ4Unq8zjecs
         D24fj2mhRbyZSWK/drIKsGQ8Hpl+ILnTNulcHC6aHGAHl5g9DbGJ1ZgsJwUFqnbM8H+2
         eGzjgkGH5u42Z8DNGycMpgDDir8P7p3FAeFU+tKOyt8TyPX64buftyOvbomyMaojwgSO
         rl1w==
X-Gm-Message-State: AOAM5327kCT3WtIuAlbVy3fYWNBxeqXHXrYVnqg3qDANYZ4y7OuDWnPV
        kjBJ3+lUKf5M9ZofM8MI6AV5s8NPytoOoiukeEvq8Q==
X-Google-Smtp-Source: ABdhPJzmEtc+5WEGyyYhU9RhAV79MqBOU0WEbvVHxMvW1J6n/n8BZyHqIE34BFg6sXrAc9mXMK78SOghyJxcS/d6XZE=
X-Received: by 2002:a54:4812:: with SMTP id j18mr609276oij.70.1603784703052;
 Tue, 27 Oct 2020 00:45:03 -0700 (PDT)
MIME-Version: 1.0
References: <20201026183523.82749-1-98.arpi@gmail.com> <CANpmjNNQtGC_jDp8TSHRHOMXi7aTQgwjtUiCWE+YqBgq-G2z5Q@mail.gmail.com>
 <f25c881d-03f9-e246-d8d4-e985d9662d04@gmail.com>
In-Reply-To: <f25c881d-03f9-e246-d8d4-e985d9662d04@gmail.com>
From:   Marco Elver <elver@google.com>
Date:   Tue, 27 Oct 2020 08:44:51 +0100
Message-ID: <CANpmjNMVjuNOh-P6dENhyk_+=AHqkZYugQ3KQS9T3qXTrUSXGA@mail.gmail.com>
Subject: Re: [PATCH v3 1/2] kunit: Support for Parameterized Testing
To:     Arpitha Raghunandan <98.arpi@gmail.com>
Cc:     Brendan Higgins <brendanhiggins@google.com>,
        skhan@linuxfoundation.org, Iurii Zaikin <yzaikin@google.com>,
        "Theodore Ts'o" <tytso@mit.edu>,
        Andreas Dilger <adilger.kernel@dilger.ca>,
        "open list:KERNEL SELFTEST FRAMEWORK" 
        <linux-kselftest@vger.kernel.org>,
        KUnit Development <kunit-dev@googlegroups.com>,
        LKML <linux-kernel@vger.kernel.org>,
        linux-kernel-mentees@lists.linuxfoundation.org,
        linux-ext4@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

On Tue, 27 Oct 2020 at 06:14, Arpitha Raghunandan <98.arpi@gmail.com> wrote:
[...]
> >> diff --git a/include/kunit/test.h b/include/kunit/test.h
> >> index a423fffefea0..16bf9f334e2c 100644
> >> --- a/include/kunit/test.h
> >> +++ b/include/kunit/test.h
> >> @@ -142,6 +142,12 @@ struct kunit_case {
> >>         void (*run_case)(struct kunit *test);
> >>         const char *name;
> >>
> >> +       /*
> >> +        * Pointer to test parameter generator function.
> >> +        * Used only for parameterized tests.
> >
> > What I meant was to give a description of the protocol, so that if
> > somebody wanted, they could (without reading the implementation)
> > implement their own custom generator without the helper macro.
> >
> > E.g. something like: "The generator function is used to lazily
> > generate a series of arbitrarily typed values that fit into a void*.
> > The argument @prev is the previously returned value, which should be
> > used to derive the next value; @prev is set to NULL on the initial
> > generator call. When no more values are available, the generator must
> > return NULL."
> >
>
> Oh okay. I am not sure if this is the best place to add documentation for this.

I think it doesn't hurt to add, but have a look at the comment above
this struct, which is already a kernel-doc comment. It probably makes
sense to move the comment there to describe the new variable.

Thanks,
-- Marco
