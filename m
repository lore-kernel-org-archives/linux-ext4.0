Return-Path: <SRS0=KkTy=XM=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D0E82C4CECD
	for <linux-ext4@archiver.kernel.org>; Tue, 17 Sep 2019 01:42:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A115B206A1
	for <linux-ext4@archiver.kernel.org>; Tue, 17 Sep 2019 01:42:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1568684520;
	bh=qyph07UWpAex17FgoCL1r5b+7tyl4ETGGhdXOzgUefU=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:List-ID:From;
	b=HtM3GwCBts/9vvWwBVXWj5xz6dy/gJ7kpaU8PsBgA9ix2PW41zT1rHMLM9REWCl9l
	 JsTk2P+ovN8Ll+aeaENghMIr5Fbb1xTxisqfIm/DPMcN558acwxRkwo5oTpSRAADSD
	 kUxBOg8Y6r/bPlMq/OMAe9jZKBN7GzhWag0I4W6E=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391751AbfIQBmA (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Mon, 16 Sep 2019 21:42:00 -0400
Received: from mail-lj1-f196.google.com ([209.85.208.196]:38819 "EHLO
        mail-lj1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728211AbfIQBl7 (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Mon, 16 Sep 2019 21:41:59 -0400
Received: by mail-lj1-f196.google.com with SMTP id y23so1765372ljn.5
        for <linux-ext4@vger.kernel.org>; Mon, 16 Sep 2019 18:41:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=eFonvhfNYcxKepSfnQcuhKAjMEuQmhnrqu5ZWiTPe6o=;
        b=Bmy2g+SI64cuFudCSab745GhMwBUH8vFBHoCEPyte/aVPJTeqvf0Ub3G6d17emIl2S
         cXEEoOWnhpdJi6yi8YT0lVGj2snzwX9DRJYCmT2Fi2PkFCGtXGxs2cGseskytXSyw5ue
         jAlwgncWpCtsxiLRT6WPIAxhjk0PtHEWVcWT4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=eFonvhfNYcxKepSfnQcuhKAjMEuQmhnrqu5ZWiTPe6o=;
        b=QbpbQeYOxcXp+oTp7dPCOD9UPROmVAVACyTLRa7UgnC5dcV7IcNNXHDWvJ+NAZl6Ji
         DbSEJ+bDrJYoY0BhqAu7qKEJafect8WwQtxDhrJuSkxpHPXfisTV1m9XQTgg9N8Wzea2
         NCmlK52S515MApEiOj5GH3oKRPKLd/OxWsLEc1f0kfWtBI7PH4kY8PzcdtTo+CM4w/Jq
         mbYQYzNHbGWjEyPs82YO82dxZXQ+j6GN9XQfxPY1EeOgeufj2RArr6YZ2gF0yWZ9fHAx
         5khyw7ezhkrjYAn4yCEL4G80M96tpt5jSbVeHRfsrXOiT9bQYDpQeJkGX5TrB/PRuPlX
         Bb1g==
X-Gm-Message-State: APjAAAWS6IwLQF+/+xnzUeNoO29ednPVTPLHEfUjM8wtYzRwO2N0xFfE
        8TBfAL4nkoYWbrBQLeIm8z2WhYUREfE=
X-Google-Smtp-Source: APXvYqyDiPCaYV+XViDMdqmMlrGA9qu4dQg+qrRAs1+wADldz+3HzvMAfKkRlHiQuI8A2Qcmv0fH+w==
X-Received: by 2002:a2e:7a16:: with SMTP id v22mr390573ljc.61.1568684516946;
        Mon, 16 Sep 2019 18:41:56 -0700 (PDT)
Received: from mail-lf1-f51.google.com (mail-lf1-f51.google.com. [209.85.167.51])
        by smtp.gmail.com with ESMTPSA id f21sm120189lfm.90.2019.09.16.18.41.52
        for <linux-ext4@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 16 Sep 2019 18:41:53 -0700 (PDT)
Received: by mail-lf1-f51.google.com with SMTP id r2so1462990lfn.8
        for <linux-ext4@vger.kernel.org>; Mon, 16 Sep 2019 18:41:52 -0700 (PDT)
X-Received: by 2002:ac2:5a4c:: with SMTP id r12mr577900lfn.52.1568684512695;
 Mon, 16 Sep 2019 18:41:52 -0700 (PDT)
MIME-Version: 1.0
References: <20190916042952.GB23719@1wt.eu> <CAHk-=wg4cONuiN32Tne28Cg2kEx6gsJCoOVroqgPFT7_Kg18Hg@mail.gmail.com>
 <20190916061252.GA24002@1wt.eu> <CAHk-=wjWSRzTjwN9F5gQcxtPkAgaRHJOOOTUjVakqP-Nzg9BXA@mail.gmail.com>
 <20190916172117.GB15263@mit.edu> <CAHk-=wgs65hez6ctK7J2k46BdQzvKU5avExPOTTJsZu6iqA-ow@mail.gmail.com>
 <20190916230217.vmgvsm6o2o4uq5j7@srcf.ucam.org> <CAHk-=whwSt4RqzqM7cA5SAhj+wkORfr1bG=+yydTJPtayQ0JwQ@mail.gmail.com>
 <20190916231103.bic65ab4ifv7vhio@srcf.ucam.org> <CAHk-=wjwJDznDUsiaXH=UCxFRQxNEpj2tTCa0GvZm2WB4+hJ4A@mail.gmail.com>
 <20190916232922.GA7880@darwi-home-pc> <CAHk-=wh2PuYtuUVt523j20cTceN+ps8UNJY=uRWQuRaDeDyLQw@mail.gmail.com>
 <BEF07E89-E36D-480F-AB1E-25C80C9DABE7@srcf.ucam.org>
In-Reply-To: <BEF07E89-E36D-480F-AB1E-25C80C9DABE7@srcf.ucam.org>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Mon, 16 Sep 2019 18:41:36 -0700
X-Gmail-Original-Message-ID: <CAHk-=whfPwei+yf9vBgfSuG5HDtiYmt3nOu9Js+vkTYSrMf2ow@mail.gmail.com>
Message-ID: <CAHk-=whfPwei+yf9vBgfSuG5HDtiYmt3nOu9Js+vkTYSrMf2ow@mail.gmail.com>
Subject: Re: Linux 5.3-rc8
To:     Matthew Garrett <mjg59@srcf.ucam.org>
Cc:     "Ahmed S. Darwish" <darwish.07@gmail.com>,
        "Theodore Y. Ts'o" <tytso@mit.edu>, Willy Tarreau <w@1wt.eu>,
        Vito Caputo <vcaputo@pengaru.com>,
        Lennart Poettering <mzxreary@0pointer.de>,
        Andreas Dilger <adilger.kernel@dilger.ca>,
        Jan Kara <jack@suse.cz>, Ray Strode <rstrode@redhat.com>,
        William Jon McCann <mccann@jhu.edu>,
        "Alexander E. Patrakov" <patrakov@gmail.com>,
        zhangjs <zachary@baishancloud.com>, linux-ext4@vger.kernel.org,
        lkml <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

On Mon, Sep 16, 2019 at 6:24 PM Matthew Garrett <mjg59@srcf.ucam.org> wrote:
>
> Exactly the scenario where you want getrandom() to block, yes.

It *would* block. Just not forever.

And btw, the whole "generate key at boot when nothing else is going
on" is already broken, so presumably nobody actually does it.

See why I'm saying "hypothetical"? You're doing it again.

> >Then you have to ignore the big warning too.
>
> The big warning that's only printed in dmesg?

Well, the patch actually made getrandom() return en error too, but you
seem more interested in the hypotheticals than in arguing actualities.

          Linus
