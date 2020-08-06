Return-Path: <SRS0=Jip5=BQ=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F07E7C433DF
	for <linux-ext4@archiver.kernel.org>; Thu,  6 Aug 2020 17:29:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5255322DCC
	for <linux-ext4@archiver.kernel.org>; Thu,  6 Aug 2020 17:29:03 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="FZytDxuw"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729609AbgHFR3B (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Thu, 6 Aug 2020 13:29:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44902 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729691AbgHFRA4 (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Thu, 6 Aug 2020 13:00:56 -0400
Received: from mail-lf1-x142.google.com (mail-lf1-x142.google.com [IPv6:2a00:1450:4864:20::142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 996B0C061756
        for <linux-ext4@vger.kernel.org>; Thu,  6 Aug 2020 03:48:02 -0700 (PDT)
Received: by mail-lf1-x142.google.com with SMTP id k13so25902461lfo.0
        for <linux-ext4@vger.kernel.org>; Thu, 06 Aug 2020 03:48:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=+F2bvw4279AFpRAqqHr9VWj7UEazWN4PYw+oY2vMYa8=;
        b=FZytDxuwtIQKZP3iyMnkL/T5/O6IjGWF8fDMueWvMixfJVT0mifTHd743Bj5ndEbvF
         Ry3pSxktKyczlATkt3Yt3ovkS/7xygecOfGuZjdmwzIF1ipy2NB6pzZh7ao+//ZmTBdi
         CNueY6UNDJK95eeClCokRBbkY+gs/dvS4CmGuViCqjkLaaAk6CHbcDPe2G0ACzGAQgJk
         e2j0KobbMTFzhGr0tX49nsTraHwHmcfyZkGr3JFEYz5IDfkFrtxpTM5/yJ2kbliylX1/
         6CdNnBknNmq8X/aEHsaa3VyymRzrCUR2fqPcatDBEnKFlg1Ox34Pspo9XJ0SqdLbbNBm
         6rHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=+F2bvw4279AFpRAqqHr9VWj7UEazWN4PYw+oY2vMYa8=;
        b=P2dxVQtXFho1yKRU5xncUN11ElHEnu8/u5lJDypyrvk9fgnQ+VVLI5ol61OIpU2M9Q
         ybUmqfeRlekCEsQjfAQLE9NDAVsdu4MPIQm1QrTWGss/mpo8Nti4uQxgKk+p4i+dGAIR
         vNFcPbjVqAlr1OQIuATUfiBV8Bdfnj/sxSHSoNJVvwEXBiWP8gHSrUHljywUaxjJFI2y
         MLASstS5jxS5vQYW75LqAcBsUiykBWtV6bqYYDf1sUA//AUB/UcAwljeXzb+52/FKkS/
         bFlhnPbo/3Q58mjV8NdOYUvuv8JQrdypSRTtvi5DuEcp9123bIn/xMVRllTSVQKLzEpP
         mJcA==
X-Gm-Message-State: AOAM530rwSEdjNnHTg8mK6OXjnTGrZoG+/fJNs3Q+aNayk5f/0RW/Tri
        Qc3OSBhMf7beDyMWdfSdHSjK5LLhyFC1PaL5KV2r6w==
X-Google-Smtp-Source: ABdhPJw3YRS5JPfc1W80PkQQEw6/Xj8PLvezRr9eMiA5H0m5fq09Fro360+A1GEpHIZKK8g2u9ca4vq/md8Y6ToCaw0=
X-Received: by 2002:ac2:5e26:: with SMTP id o6mr3576663lfg.194.1596710881135;
 Thu, 06 Aug 2020 03:48:01 -0700 (PDT)
MIME-Version: 1.0
References: <20200529072017.2906-1-linus.walleij@linaro.org>
 <CAFEAcA-x0y6ufRXebckRdGSLOBzbdBsk=uw+foK4p+HDeVrA9A@mail.gmail.com>
 <CACRpkdZk-Pv49PyhtrW7ZQo+iebOapVb7L2T_cxh0SpYtcv5Xw@mail.gmail.com> <CACRpkdbOiL7=KUNa0==P+H-3SynhMt1=JweCY8ihbEZLK=b78w@mail.gmail.com>
In-Reply-To: <CACRpkdbOiL7=KUNa0==P+H-3SynhMt1=JweCY8ihbEZLK=b78w@mail.gmail.com>
From:   Linus Walleij <linus.walleij@linaro.org>
Date:   Thu, 6 Aug 2020 12:47:49 +0200
Message-ID: <CACRpkdY-w7TD89eRMJQSvhrPC7gxSPYPmMhPO2FUOxtzYRcRsg@mail.gmail.com>
Subject: Re: [PATCH v2] fcntl: Add 32bit filesystem mode
To:     "Theodore Ts'o" <tytso@mit.edu>
Cc:     Andreas Dilger <adilger.kernel@dilger.ca>,
        Ext4 Developers List <linux-ext4@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Linux API <linux-api@vger.kernel.org>,
        QEMU Developers <qemu-devel@nongnu.org>,
        Florian Weimer <fw@deneb.enyo.de>,
        Andy Lutomirski <luto@kernel.org>,
        Peter Maydell <peter.maydell@linaro.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

On Sun, Jul 19, 2020 at 2:34 PM Linus Walleij <linus.walleij@linaro.org> wrote:
> On Mon, Jul 6, 2020 at 10:54 AM Linus Walleij <linus.walleij@linaro.org> wrote:
>
> > Ted, can you merge this patch?
> >
> > It seems QEMU is happy and AFICT it uses the approach you want :)
>
> Gentle ping!

Special merge-window ping.

Shall I resend the patch?

Yours,
Linus Walleij
