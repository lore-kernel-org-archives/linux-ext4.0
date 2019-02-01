Return-Path: <SRS0=gd00=QI=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0F1FDC282D8
	for <linux-ext4@archiver.kernel.org>; Fri,  1 Feb 2019 11:08:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id ADBE321900
	for <linux-ext4@archiver.kernel.org>; Fri,  1 Feb 2019 11:08:24 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=intel-com.20150623.gappssmtp.com header.i=@intel-com.20150623.gappssmtp.com header.b="TsM4A951"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729935AbfBALIY (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Fri, 1 Feb 2019 06:08:24 -0500
Received: from mail-it1-f173.google.com ([209.85.166.173]:36533 "EHLO
        mail-it1-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729721AbfBALIY (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Fri, 1 Feb 2019 06:08:24 -0500
Received: by mail-it1-f173.google.com with SMTP id c9so9208067itj.1
        for <linux-ext4@vger.kernel.org>; Fri, 01 Feb 2019 03:08:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to;
        bh=0Tz26VA82mYvnTO73gwEPARQOo0V0TcjsrdJX5mPSgE=;
        b=TsM4A951p6Ui+NhItqkp1XxQDH/UgiPrERqUoTLnigpQk0vv7C+7gUC+waFPuhu6C5
         nH1uH+EZ8/Ejbqa2Cs1q/q4XppuToPk+2a+UZUB1qIy5zfGIropxiNG9ewINPD2tiFsw
         ucA5C3hrmBxvZPj41UXo2Cv0euwH3lUs0nCCZyvcsDHnLMQdKJG7nR8U08ihysqUGszw
         odiHfEKmyiMOAWylaIyZQBVtHUVnnU6A7CcCWYKxMR4wuLUgmTEjXpa5cxKOef5+GJwe
         dG3HbjWg6frQ9gLU38Lp2HMUuLlr5ZA+oJeqAXn/WoZ3QHtcB8Z9M9g8j3zkROtNQlE8
         9aJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to;
        bh=0Tz26VA82mYvnTO73gwEPARQOo0V0TcjsrdJX5mPSgE=;
        b=Z3cI9jH2d0PI3/ikGrx1Crz8Xc58V3kpIQN7SfLmgjP0/7vQHFf3S6vwozSv72N+zy
         LjxzNZJUAHMs0Bw7+HVFDeT2nzYGfHrnev7ZzZZPWVsUPK/DA/PRtPzZynZoJkj1yM1B
         ERaEpZxz5SH26lMgva8Pl+TlFBMXQpmO2E+UqAFUC8nq208hizJwv/gEAdrL3j9dFOCp
         mHJqw37qdbugvmtO+0LtKEfn32OG6EIYjGGEVjj9TFL15t30x/PEE7DwydHguBxEphwb
         qZ6bstS6zgmgB2UladQQ2/4XOgVtFyz7GSAJxZdpU2h1UK0YF06Pw9ZGvvkS12JmWxaB
         8vUw==
X-Gm-Message-State: AHQUAubMyl2DP5PqCu+fWMZRH9Rwud8nzDWi3WTg0gxwpo4pRDZBrk1C
        gyQ2+GY3xHJLUISX5BDhYyguty1i93/5+yNjA5ORQmjb
X-Google-Smtp-Source: AHgI3IaIwYpP2Hx/QfBNC2T/5YmopFSj07URSPsm7+ntgLPW/IWZb+bQMXp0wB1iOPNz2QaR4e7CEEkGdbihqmnRx68=
X-Received: by 2002:a24:c601:: with SMTP id j1mr833167itg.130.1549019303214;
 Fri, 01 Feb 2019 03:08:23 -0800 (PST)
MIME-Version: 1.0
References: <CAJTo0LYhwc978ywMkZ1v3xZHsW4DVwrszKnPoewvzvNixD_Pcg@mail.gmail.com>
 <CAJTo0LbADyD3oE8roCRtEMdV5FX2GCzGPOBeh=vTS2GEJ8KTTA@mail.gmail.com>
In-Reply-To: <CAJTo0LbADyD3oE8roCRtEMdV5FX2GCzGPOBeh=vTS2GEJ8KTTA@mail.gmail.com>
From:   "Burton, Ross" <ross.burton@intel.com>
Date:   Fri, 1 Feb 2019 11:08:12 +0000
Message-ID: <CAJTo0LYih0HK6o8MtxLxjES7sE=3OT9tuMzrUXLQ3uj_s7XNvA@mail.gmail.com>
Subject: Re: Writing large files into a ext4 with mkfs is truncating files
To:     linux-ext4 <linux-ext4@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

Got a patch, posting now.

Ross

On Fri, 1 Feb 2019 at 09:44, Burton, Ross <ross.burton@intel.com> wrote:
>
> On Fri, 1 Feb 2019 at 00:14, Burton, Ross <ross.burton@intel.com> wrote:
> > $ cmp fs/foo  /mnt/foo
> > fs/foo /mnt/foo differ: byte 1073741825, line 4194938
> >
> > Okay that's not the 4GB boundary.
>
> $ bc
> obase=2
> 1073741825
> 1000000000000000000000000000001
>
> That's 2^30.  I'm guessing a signed type is used somewhere?
>
> Ross
