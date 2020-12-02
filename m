Return-Path: <linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 719BAC83012
	for <linux-ext4@archiver.kernel.org>; Wed,  2 Dec 2020 16:19:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2BD2221D7F
	for <linux-ext4@archiver.kernel.org>; Wed,  2 Dec 2020 16:19:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730718AbgLBQTg (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Wed, 2 Dec 2020 11:19:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59638 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730709AbgLBQTf (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Wed, 2 Dec 2020 11:19:35 -0500
Received: from mail-vk1-xa42.google.com (mail-vk1-xa42.google.com [IPv6:2607:f8b0:4864:20::a42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9CA02C0613CF
        for <linux-ext4@vger.kernel.org>; Wed,  2 Dec 2020 08:18:55 -0800 (PST)
Received: by mail-vk1-xa42.google.com with SMTP id s135so521156vkh.6
        for <linux-ext4@vger.kernel.org>; Wed, 02 Dec 2020 08:18:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=szeredi.hu; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=K37eg33TEYHBPIc9hdERySXaT7ddLk31VnYDOJlDBsg=;
        b=Qh43GnRo7YfF7QXgCietAKT8+vkZPBqYJF1+My0HDqIs9rZIo8YSN5dPnKbhJt35/O
         Bk92brV0mfpexLTOm4P1D2e/jzzHq0aEycI6SbiBHQ4W9TdRZzRMWRILKTnT50xTSA2i
         iPs17ztWvUY6GyDcrTIIhpbuNNzPUr9ojKwfs=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=K37eg33TEYHBPIc9hdERySXaT7ddLk31VnYDOJlDBsg=;
        b=D0Se+P03Nr66o5UR9AgtkqFPGW46pF8C3nV6U6MsMTYAfVxAvPBE5f+iGS/nbxx6BF
         5INRLG2jbE4gMN45t1u8/sTY3qzkeSJ+e/Q0Dm1cL8J4XMNPA9Yp9TbHjQjsjOSCMa76
         J4YlXM6hi89C1q2unhbOG60Ucb9doVKSe3ITR91/Rvrsp5TUuiv7Mam2AEzu/9bdq3R0
         DSAHbn2uAFWEkKHKGAjqmTusXxmvXpN8/c2LAPuQx2q8v5f6GKlRMMsiZpKpFcFLogHs
         w/K10jNmodTOek/YyV8Qpgyhl0DxZTH8A25uTHjIXkGWyDXX0WlU88bYMDnZbz1TJV7/
         gjIQ==
X-Gm-Message-State: AOAM533iO1b3KRCALXFoKDGm/70b2L3snbbVs3uoZvSo0CM3EZ2+74/L
        xC/EQ2UjZwbBnBziUKuj6VZN2Oss+8/dM8bKtIfnog==
X-Google-Smtp-Source: ABdhPJyTxGZ9z1k1i/Ix1wYvY05DOpOo2yBinjoa08BbT+ejSo+v8144fC3Nldom8dhjeZdLqBssK9ANee91fT78mH4=
X-Received: by 2002:a1f:e7c2:: with SMTP id e185mr2204229vkh.23.1606925934724;
 Wed, 02 Dec 2020 08:18:54 -0800 (PST)
MIME-Version: 1.0
References: <3e28d2c7-fbe5-298a-13ba-dcd8fd504666@redhat.com> <20201202160049.GD1447340@iweiny-DESK2.sc.intel.com>
In-Reply-To: <20201202160049.GD1447340@iweiny-DESK2.sc.intel.com>
From:   Miklos Szeredi <miklos@szeredi.hu>
Date:   Wed, 2 Dec 2020 17:18:43 +0100
Message-ID: <CAJfpegt6w4h28VLctpaH46r2pkbcUNJ4pUhwUqZ-zbrOrXPEEQ@mail.gmail.com>
Subject: Re: [PATCH V2] uapi: fix statx attribute value overlap for DAX & MOUNT_ROOT
To:     Ira Weiny <ira.weiny@intel.com>
Cc:     Eric Sandeen <sandeen@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Miklos Szeredi <mszeredi@redhat.com>,
        David Howells <dhowells@redhat.com>,
        linux-fsdevel@vger.kernel.org,
        linux-man <linux-man@vger.kernel.org>,
        linux-kernel@vger.kernel.org, xfs <linux-xfs@vger.kernel.org>,
        linux-ext4@vger.kernel.org, Xiaoli Feng <xifeng@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

On Wed, Dec 2, 2020 at 5:03 PM Ira Weiny <ira.weiny@intel.com> wrote:
>
> On Tue, Dec 01, 2020 at 05:21:40PM -0600, Eric Sandeen wrote:
> > [*] Note: This needs to be merged as soon as possible as it's introducing an incompatible UAPI change...
> >
> > STATX_ATTR_MOUNT_ROOT and STATX_ATTR_DAX got merged with the same value,
> > so one of them needs fixing. Move STATX_ATTR_DAX.
> >
> > While we're in here, clarify the value-matching scheme for some of the
> > attributes, and explain why the value for DAX does not match.
> >
> > Fixes: 80340fe3605c ("statx: add mount_root")
> > Fixes: 712b2698e4c0 ("fs/stat: Define DAX statx attribute")
> > Reported-by: David Howells <dhowells@redhat.com>
> > Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> > Reviewed-by: David Howells <dhowells@redhat.com>
>
> Reviewed-by: Ira Weiny <ira.weiny@intel.com>

Stable cc also?

Cc: <stable@vger.kernel.org> # 5.8

Thanks,
Miklos
