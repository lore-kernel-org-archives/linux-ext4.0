Return-Path: <linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A9A79C4361B
	for <linux-ext4@archiver.kernel.org>; Thu,  3 Dec 2020 18:05:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 508EE20793
	for <linux-ext4@archiver.kernel.org>; Thu,  3 Dec 2020 18:05:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731609AbgLCSFc (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Thu, 3 Dec 2020 13:05:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45456 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729046AbgLCSFc (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Thu, 3 Dec 2020 13:05:32 -0500
Received: from mail-lf1-x142.google.com (mail-lf1-x142.google.com [IPv6:2a00:1450:4864:20::142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E5C32C061A4E
        for <linux-ext4@vger.kernel.org>; Thu,  3 Dec 2020 10:04:45 -0800 (PST)
Received: by mail-lf1-x142.google.com with SMTP id s27so4050431lfp.5
        for <linux-ext4@vger.kernel.org>; Thu, 03 Dec 2020 10:04:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=hyvfbSevo8Se/4y3iGk+lQg5JO2pXQRwoWZK6AVmSCc=;
        b=Gjv1aL6P6xJwooMOiOVXI2rySRClbrUY3HGVe50LjDG6cXh38kZ+sHSB/0xeLOSW+9
         KzfnPdBnHXwJGIJd7YUlF/R7CYA7zxSe6UAPykXdN+th0PqF3iMNmSPkggw3h7OtjYFq
         jXrwfcED6y2TT4DMjNHYAYn4nz6N4tLwE3MVw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=hyvfbSevo8Se/4y3iGk+lQg5JO2pXQRwoWZK6AVmSCc=;
        b=UneGJimjpOn7w0HgVYMi6lFvqrgSKMyKIxTfHPQ8cz/WnIkh8WUOAXj2qoF1hQrSuO
         oCRp/V+oA8Wt7EmshmIEFu/sI1mUdw3UlzneDSupKNp4IqsfyPduW8bFiFpB5IRGlln6
         TpN7ijiPfZZt8uuPCT1Maq4GDNWO/3Bdif22IWo35l426eKeBDtPy+A977Ya6QfaJd8m
         ZRF2cYxy2bnMggng0+iPaCK5tWCmHdelbTX+Ct6HnVTM51KicN2DsKzq0AAMGhVXZVLv
         oDf0CsNkPx1VmJOY6liM98ByCVc6qqSrdV1Xo2RuvvZLyJZy1fYkcntfDLl4eWn8en7b
         6rew==
X-Gm-Message-State: AOAM533ej9t7Wxfg9yi6BPRP9A2S3sXo+AD0XpKI73e1QvExdk57Rahd
        Dj9IawjF+Rw7hFF2vWHLlUX+8qJaqdaBDA==
X-Google-Smtp-Source: ABdhPJxsY/u6bncitaRyjV0c9pHmFwb9AJ804i9TKlNtr80ABxRdpx+Kn7ALc1r0hJlmW2xfsi1hIQ==
X-Received: by 2002:a19:82d5:: with SMTP id e204mr1843382lfd.463.1607018684168;
        Thu, 03 Dec 2020 10:04:44 -0800 (PST)
Received: from mail-lj1-f170.google.com (mail-lj1-f170.google.com. [209.85.208.170])
        by smtp.gmail.com with ESMTPSA id f27sm749974lfq.188.2020.12.03.10.04.42
        for <linux-ext4@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 03 Dec 2020 10:04:42 -0800 (PST)
Received: by mail-lj1-f170.google.com with SMTP id a1so2217556ljq.3
        for <linux-ext4@vger.kernel.org>; Thu, 03 Dec 2020 10:04:42 -0800 (PST)
X-Received: by 2002:a2e:9d83:: with SMTP id c3mr1626934ljj.314.1607018682473;
 Thu, 03 Dec 2020 10:04:42 -0800 (PST)
MIME-Version: 1.0
References: <e388f379-cd11-a5d2-db82-aa1aa518a582@redhat.com>
 <7027520f-7c79-087e-1d00-743bdefa1a1e@redhat.com> <20201202021633.GA1455219@iweiny-DESK2.sc.intel.com>
 <CAHk-=wjiU5Fq7aG0-H6QN1ZsK-U3Hw1K310N2z_eCPPDTKeysA@mail.gmail.com> <20201203024504.GA1563847@iweiny-DESK2.sc.intel.com>
In-Reply-To: <20201203024504.GA1563847@iweiny-DESK2.sc.intel.com>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Thu, 3 Dec 2020 10:04:26 -0800
X-Gmail-Original-Message-ID: <CAHk-=whWC==8VNeVG=_DwT+RT9x1uiseUDH0X9sYKMetrh6c3w@mail.gmail.com>
Message-ID: <CAHk-=whWC==8VNeVG=_DwT+RT9x1uiseUDH0X9sYKMetrh6c3w@mail.gmail.com>
Subject: Re: [PATCH 1/2] uapi: fix statx attribute value overlap for DAX & MOUNT_ROOT
To:     Ira Weiny <ira.weiny@intel.com>
Cc:     Eric Sandeen <sandeen@redhat.com>,
        Miklos Szeredi <mszeredi@redhat.com>,
        David Howells <dhowells@redhat.com>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        linux-man <linux-man@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        xfs <linux-xfs@vger.kernel.org>,
        Ext4 Developers List <linux-ext4@vger.kernel.org>,
        Xiaoli Feng <xifeng@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

On Wed, Dec 2, 2020 at 6:45 PM Ira Weiny <ira.weiny@intel.com> wrote:
> >
> > What would the typical failure cases be in practice?
>
> The failure will be a user not seeing their file operating in DAX mode when
> they expect it to.
>
> I discussed this with Dan Williams today.  He and I agreed the flag is new
> enough that we don't think users have any released code to the API just yet.
> So I think we will be ok.

Ok, thanks for verification. I've applied it locally in my tree, it
will be pushed out later today with other work..

           Linus
