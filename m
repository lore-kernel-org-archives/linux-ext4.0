Return-Path: <SRS0=+K+T=XL=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 68417C49ED7
	for <linux-ext4@archiver.kernel.org>; Mon, 16 Sep 2019 23:18:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2A188214AF
	for <linux-ext4@archiver.kernel.org>; Mon, 16 Sep 2019 23:18:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1568675901;
	bh=k8Ff3xzif5fguLn9kTe6e2YwVW5jxHQxt8hPgzUOjSo=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:List-ID:From;
	b=dRzDfm9Ml+OdMaKs6ieJWM4Pc16r7K7QRZW5KzlJjCt+dJIivndxX5WW1xy7sjBpQ
	 nrETjk/obeGTDkpRcU5faVrlTmMEQdmYS1HIedtM8miEWwbJJZ3niaE8pXEGyn6AqD
	 05VBWjzulLhBXzoRaHSZPjmLRXEL02gDjupXn5P4=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733114AbfIPXSU (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Mon, 16 Sep 2019 19:18:20 -0400
Received: from mail-lj1-f193.google.com ([209.85.208.193]:37546 "EHLO
        mail-lj1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729943AbfIPXSU (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Mon, 16 Sep 2019 19:18:20 -0400
Received: by mail-lj1-f193.google.com with SMTP id c22so1565068ljj.4
        for <linux-ext4@vger.kernel.org>; Mon, 16 Sep 2019 16:18:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=eHtNi0a+TimuxW1u+d3PsNmzsTMMHbqdiEbQwvAU2DI=;
        b=WXA66mIqE1S4egtmENLvgyssWbOsKrwZhBbRFIiaAIR05oCwS4ealdQRJKD/DWEh3y
         Ha5Sk981WcJ+TqA+sEbflrz2FIBzz+Kd+LYdbaQMvLGJqdiVkfITbf7ZLiijaZWShWen
         RDjXcS9k5dUiLdfpQFn7HZtrdW4x1dPlKUXz8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=eHtNi0a+TimuxW1u+d3PsNmzsTMMHbqdiEbQwvAU2DI=;
        b=t6s8CZy3EnCBZUmIUxWYp4cGbrKdpTv0Q/NYQvdm1zPSG8AgUCQ6pgG7/mnj+3EjhK
         Rpel+uIUIIYQL3gqlY9xOPfG89MRtm/vhKduxegkvOkqztbeg2R+2Wm/nNjq+1MdSVYB
         ZHEEVFVIYOv2osEGiM6wuZxww3cumkuSyAC5W5zBGlqbBYtqHEwZDls73VWoPmj0K9b+
         WnkXedPVmlgGLKHzGG5SOHVaT3jb+hFNFwXSCEetfBqVF0SAFZNNMDXLyfVeRfZhEQfE
         6GOO2P01nOHhKmn6aUbXDZ+WJKNyDTOOHTwIJ7GU6rxoiIfnKOw6G3udDoxoHxMTOxw8
         fU1g==
X-Gm-Message-State: APjAAAXWPM3UblZ/VTjaaUppR10T7zMeeGxDkcGp/nlkONsFMLxgaiT2
        1ziaUyBj6spAzCEzQbb0mVFxDsG5C30=
X-Google-Smtp-Source: APXvYqxdhgXHIitf3MKUrRYFElZjBS9kzoeZZqMosyuglhFxLwujkQlMovwogbW2W5PuaRBNdPE/Eg==
X-Received: by 2002:a2e:3902:: with SMTP id g2mr176479lja.196.1568675898273;
        Mon, 16 Sep 2019 16:18:18 -0700 (PDT)
Received: from mail-lf1-f41.google.com (mail-lf1-f41.google.com. [209.85.167.41])
        by smtp.gmail.com with ESMTPSA id r6sm60163ljr.77.2019.09.16.16.18.17
        for <linux-ext4@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 16 Sep 2019 16:18:17 -0700 (PDT)
Received: by mail-lf1-f41.google.com with SMTP id u28so1298535lfc.5
        for <linux-ext4@vger.kernel.org>; Mon, 16 Sep 2019 16:18:17 -0700 (PDT)
X-Received: by 2002:ac2:5a4c:: with SMTP id r12mr345568lfn.52.1568675896897;
 Mon, 16 Sep 2019 16:18:16 -0700 (PDT)
MIME-Version: 1.0
References: <20190916014833.cbetw4sqm3lq4x6m@shells.gnugeneration.com>
 <20190916024904.GA22035@mit.edu> <20190916042952.GB23719@1wt.eu>
 <CAHk-=wg4cONuiN32Tne28Cg2kEx6gsJCoOVroqgPFT7_Kg18Hg@mail.gmail.com>
 <20190916061252.GA24002@1wt.eu> <CAHk-=wjWSRzTjwN9F5gQcxtPkAgaRHJOOOTUjVakqP-Nzg9BXA@mail.gmail.com>
 <20190916172117.GB15263@mit.edu> <CAHk-=wgs65hez6ctK7J2k46BdQzvKU5avExPOTTJsZu6iqA-ow@mail.gmail.com>
 <20190916230217.vmgvsm6o2o4uq5j7@srcf.ucam.org> <CAHk-=whwSt4RqzqM7cA5SAhj+wkORfr1bG=+yydTJPtayQ0JwQ@mail.gmail.com>
 <20190916231103.bic65ab4ifv7vhio@srcf.ucam.org>
In-Reply-To: <20190916231103.bic65ab4ifv7vhio@srcf.ucam.org>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Mon, 16 Sep 2019 16:18:00 -0700
X-Gmail-Original-Message-ID: <CAHk-=wjwJDznDUsiaXH=UCxFRQxNEpj2tTCa0GvZm2WB4+hJ4A@mail.gmail.com>
Message-ID: <CAHk-=wjwJDznDUsiaXH=UCxFRQxNEpj2tTCa0GvZm2WB4+hJ4A@mail.gmail.com>
Subject: Re: Linux 5.3-rc8
To:     Matthew Garrett <mjg59@srcf.ucam.org>
Cc:     "Theodore Y. Ts'o" <tytso@mit.edu>, Willy Tarreau <w@1wt.eu>,
        Vito Caputo <vcaputo@pengaru.com>,
        "Ahmed S. Darwish" <darwish.07@gmail.com>,
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

On Mon, Sep 16, 2019 at 4:11 PM Matthew Garrett <mjg59@srcf.ucam.org> wrote:
>
> In one case we have "Systems don't boot, but you can downgrade your
> kernel" and in the other case we have "Your cryptographic keys are weak
> and you have no way of knowing unless you read dmesg", and I think
> causing boot problems is the better outcome here.

Or: In one case you have a real and present problem. In the other
case, people are talking hypotheticals.

              Linus
