Return-Path: <linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 81F0DC43334
	for <linux-ext4@archiver.kernel.org>; Sun,  5 Jun 2022 00:11:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242469AbiFEALy (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Sat, 4 Jun 2022 20:11:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44782 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233798AbiFEALx (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Sat, 4 Jun 2022 20:11:53 -0400
Received: from mail-oi1-x22b.google.com (mail-oi1-x22b.google.com [IPv6:2607:f8b0:4864:20::22b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E6CA2661
        for <linux-ext4@vger.kernel.org>; Sat,  4 Jun 2022 17:11:51 -0700 (PDT)
Received: by mail-oi1-x22b.google.com with SMTP id h188so15160385oia.2
        for <linux-ext4@vger.kernel.org>; Sat, 04 Jun 2022 17:11:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=OmhgEQiwiLj0KRhK2M74z2mxVvIo3YFQOfxUEZbSrig=;
        b=STmdGgl0FBA7QOfXCQLPzpUk8chnQFsqs4wpZX2NujBAI7NkUEog68unFnBQd9VBS4
         LDUdrei69s6eirMuTid6i3zWZiwaotgM3FKGVq22DqzB7Y+W/aOWUbme0dYDIXIg5ZoB
         IOQVATQkphnHSXTE6TiXvaTUzNRDF9WMbPW32gwCkLuRIn4CE0sMiWPaHp1qMBdN/9kk
         mTQ8han3R6fXbl6EM6vIo7Lx4xPey23b7xCzJ5qmaHp9whtBLLVu2XtKE8RW382pM+cT
         gWV0nRWkL3qdcjQdUstTZ8PSitIvqbP3w5D5BoQCjfdOLbSs3ETl4xJ9OID4WKEqeEle
         gt8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=OmhgEQiwiLj0KRhK2M74z2mxVvIo3YFQOfxUEZbSrig=;
        b=d9Rvxz5iCqv+mXc3vW6bp+OcVs/fkreT/LpbDbCk7GrqPV+wPsbdGlwIgnc44/UNSD
         lAj9xOtIeWhkc7LL4nfq4TDrboMDU489dHoqPFjoR/mu1TbKqH6PXPKptnIOiuCCn6bM
         FXAqw+ExaW9A1iiGPMtXnItsfitWMQepfSL3He9VaCDd31Cw3rY4u+tISr5iXivctsRI
         QTVRgKKcOwXs/9Rqe+nflsDhYtPkUa6t1oQC0Ofc9zIqM0XO9pEytBhTXZST+EJR8CVt
         cixAQ310RzlqsrriocWxpZMZDwa1S2/cYZ4wegIhNgczVwBJnJxZHkW94nUf1E1zSJLH
         jTJw==
X-Gm-Message-State: AOAM5316A65rDk/0WxtoMBRA9QWTJO1fQn5RTyaDHIidnvIQ3IXbgMa2
        w6lDAzbtXqytncQnRszmfkzQR/v0mVxn04aeJSs=
X-Google-Smtp-Source: ABdhPJzjhmQ8JTOqblz2YCmW14SMsoas2b7nlr++qzy6y+LEP7WzI/s4pTRDDVQbtydeWHY/dmOh2uXZfXxgXwxzu5E=
X-Received: by 2002:a05:6808:144d:b0:32b:7fbc:9440 with SMTP id
 x13-20020a056808144d00b0032b7fbc9440mr9745344oiv.226.1654387909966; Sat, 04
 Jun 2022 17:11:49 -0700 (PDT)
MIME-Version: 1.0
References: <CAFDdnB38yRcZ+mQButh9UwGoh928xsZCgmjQ7r3HPEpEwdrZbg@mail.gmail.com>
 <87sfor85j1.fsf@collabora.com> <CAFDdnB3U67YJ7pivdHQaMB-CkdmvvTbcpxp1FXxBmFyAgJPknw@mail.gmail.com>
 <874k13t0tk.fsf@collabora.com>
In-Reply-To: <874k13t0tk.fsf@collabora.com>
From:   "Stephen E. Baker" <baker.stephen.e@gmail.com>
Date:   Sat, 4 Jun 2022 20:11:38 -0400
Message-ID: <CAFDdnB143WXo2sz5trAhh2nH=CJ50U3GgkgDe_YJ394=G6ongg@mail.gmail.com>
Subject: Re: simplify ext4_sb_read_encoding regression
To:     Gabriel Krisman Bertazi <krisman@collabora.com>,
        amstan@chromium.org
Cc:     linux-ext4@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

On Thu, Jun 2, 2022 at 1:47 PM Gabriel Krisman Bertazi
<krisman@collabora.com> wrote:
>
> Nothing stands out on that commit specifically and I couldn't reproduce
> it in a vm.  I've reached out to Tomeu to get my hands on that exact
> chromebook, to try to reproduce it there.  I will report back with my
> findings.
>
I reached out on the archlinuxarm IRC room and amstan offered the use
of his device.

When he boots my image he sees:
"EXT4-fs (sda2): can't mount with superblock charset: utf8-12.1.0 not
supported by the kernel. flags: 0x0."
