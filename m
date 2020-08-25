Return-Path: <SRS0=VAvg=CD=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7AC0EC433E1
	for <linux-ext4@archiver.kernel.org>; Tue, 25 Aug 2020 10:40:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5519E20706
	for <linux-ext4@archiver.kernel.org>; Tue, 25 Aug 2020 10:40:50 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="WVr/X9yV"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729710AbgHYKks (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Tue, 25 Aug 2020 06:40:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53376 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726149AbgHYKks (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Tue, 25 Aug 2020 06:40:48 -0400
Received: from mail-ot1-x341.google.com (mail-ot1-x341.google.com [IPv6:2607:f8b0:4864:20::341])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CAF32C061574;
        Tue, 25 Aug 2020 03:40:47 -0700 (PDT)
Received: by mail-ot1-x341.google.com with SMTP id t7so9987230otp.0;
        Tue, 25 Aug 2020 03:40:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=C5ZqpSMJffCKiiwFvA8SJGWVKrf2TaYte90opB8CM3k=;
        b=WVr/X9yVk2Yn+vjoOaqOCA5sWj/y4+cLzkd3vicMn3yp/cpDPYCVcmA9XVAS77IH/q
         sm8yu0svlvwwOLGtubCsQ5IbCwTuFsSuteAsty5TS5fJLNH9gAXBEsfogGfeAH00NPbC
         ThP2d8RaXC1ISXXU/dL3ydXjnxyVhX6VgotkUoAwEAZEyZDrackZpQZDA3EKpbzuwvQz
         Bf3NXlBOQqHnJJcwd+JT+XHwn55BuyCnlQBDzMJQzJVJc59KS3bkOC/sNTr6LcX/BpmJ
         4ikX32h9AYfGaE4CUnzGif4/jxzTJCAQjhmtNZ/pBRX3gBvmHPvKkUzhIu76EjoPYov1
         2Qqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=C5ZqpSMJffCKiiwFvA8SJGWVKrf2TaYte90opB8CM3k=;
        b=DVqVvev+a0t3ZwlPDRPkz7yDtfidyvZCMl7+A8x6zgpUNeqkr5xqFGRhpCNlz44CDz
         tJqGgAvvEMcen03r+Tq4X7TP739opEeYVty23Uf3fTJ1SATS5T9bWSO9scX9/Kkl+uMe
         R0+aHdYEbbHpCJXbvY3l/1JPSVoAy3NQvrKQAeXxGkgwJ7q2YCJjtDGmK999R3UXWjua
         tBiqRA52EUhsyQYOgiU7DaN3HCCVBmACC+1olso9TkY15hjZM7vL0S7lO3JFvdYwljo1
         mNw/yfU+/BrOzQalhAx4Vvl3+GANwyY1pGn8Bc8vNmiAvCbHzXocpCwgHrcXxUErQfTW
         I7ZA==
X-Gm-Message-State: AOAM532q9d1FGkA9NEGhkwZmXQPVd3s0EcTimv2eJTgR7dHrIgGosHqJ
        bO+eJi1ZRJ3FLKiZHP9hGjo2M5/BxXNQqHa+A3A=
X-Google-Smtp-Source: ABdhPJzPmvCtaKp7XhDRbFM1Hlvo+ca4CclW/nvlauENT47xUf0IisYZ0iiYmnOWGIlCcZXRm16GfohA6NYIw+lQHho=
X-Received: by 2002:a05:6830:17dc:: with SMTP id p28mr6752994ota.296.1598352045426;
 Tue, 25 Aug 2020 03:40:45 -0700 (PDT)
MIME-Version: 1.0
References: <20200505183608.10280-1-yshuiv7@gmail.com> <20200505193049.GC5694@magnolia>
 <CAGqt0zzA5NRx+vrcwyekW=Z18BL5CGTuZEBvpRO3vK5rHCBs=A@mail.gmail.com> <20200825102040.GA15394@infradead.org>
In-Reply-To: <20200825102040.GA15394@infradead.org>
From:   Yuxuan Shui <yshuiv7@gmail.com>
Date:   Tue, 25 Aug 2020 11:40:34 +0100
Message-ID: <CAGqt0zxoJZrYXS+wp7bwfsajfpaotu02oUy53VkQ5CTGcE_2hA@mail.gmail.com>
Subject: Re: [PATCH] iomap: iomap_bmap should accept unwritten maps
To:     Christoph Hellwig <hch@infradead.org>
Cc:     "Darrick J. Wong" <darrick.wong@oracle.com>,
        viro@zeniv.linux.org.uk, linux-fsdevel@vger.kernel.org,
        linux-ext4@vger.kernel.org, tytso@mit.edu, adilger.kernel@dilger.ca
Content-Type: text/plain; charset="UTF-8"
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

Hi,

On Tue, Aug 25, 2020 at 11:20 AM Christoph Hellwig <hch@infradead.org> wrote:
>
> On Tue, Aug 25, 2020 at 10:26:14AM +0100, Yuxuan Shui wrote:
> > Hi,
> >
> > Do we actually want to fix this bug or not? There are a number of
> > people actually seeing this bug.
>
> bmap should not succeed for unwritten extents.

Why not? Unwritten extents are still allocated extents.

>
> > If you think this is not the right fix, what do you think we should
> > do? If the correct fix is to make ext4 use iomap_swapfile_activate,
> > maybe we should CC the ext4 people too?
>
> Yes, ext4 should use iomap_swapfile_activate.

OK, let me CC the ext4 people.

Context:

https://bugzilla.kernel.org/show_bug.cgi?id=207585

> commit ac58e4fb03f9d111d733a4ad379d06eef3a24705 moved ext4_bmap from
> generic_block_bmap to iomap_bmap, this introduced a regression which
> prevents some user from using previously working swapfiles. The kernel
> will complain about holes while there are none.

> What is happening here is that the swapfile has unwritten mappings,
> which is rejected by iomap_bmap, but was accepted by ext4_get_block.

-- 

Regards
Yuxuan Shui
