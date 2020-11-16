Return-Path: <linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 20AEAC5519F
	for <linux-ext4@archiver.kernel.org>; Mon, 16 Nov 2020 13:50:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CADDB2227F
	for <linux-ext4@archiver.kernel.org>; Mon, 16 Nov 2020 13:50:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728752AbgKPNuf (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Mon, 16 Nov 2020 08:50:35 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:39115 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727248AbgKPNue (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Mon, 16 Nov 2020 08:50:34 -0500
Received: from mail-wr1-f72.google.com ([209.85.221.72])
        by youngberry.canonical.com with esmtps (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <mauricio.oliveira@canonical.com>)
        id 1keets-0002Br-0h
        for linux-ext4@vger.kernel.org; Mon, 16 Nov 2020 13:50:32 +0000
Received: by mail-wr1-f72.google.com with SMTP id v5so11083670wrr.0
        for <linux-ext4@vger.kernel.org>; Mon, 16 Nov 2020 05:50:32 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=8cftLcfcc+49VWAqvawkZOJxhoRB57qpK4TLnSigujo=;
        b=PDpi/fVYJOPL6FF6L39siw1JKoPOlzIoh85RzqXuRTpGMpj1Y4U+xSdRCYSNmDtd5s
         +IG+zG/qQBLP3wY3dskyaCgYRP8wF4bT2FRbtt72dmn0VL8xQI9IH2q1A2P6w/oa6g7V
         cQL2F6E0xqC9ECvb91vASw9G6a0IBEYAb/QBpW2CZjpXdiePf/12uzW1+xffsbGdBf6g
         b01GQfz6+i8RL+4G574yhv2M9/8Nayn3xlwJChTzbJ7xZ/koOIUKAP3vUiLLOoLPMJXb
         tTLrebcBPvzmgXv4t2Bk9t8tSZC2UPZQ80tNHgs7XI7Nqtm7NYmN7W7eZqHM34DCSmrs
         0b1w==
X-Gm-Message-State: AOAM530z56YexDZPjakRMUBi5dQIzWcAsA7uYj5G5cxSKzk3aFSO3ezL
        U/im1hJyC95adnJg37z6st4YAItQ7w+aI4vn62+x0lBe7rM9RKIljKIZjiqmN9ZUC6EL5IFbFSQ
        kHt6mm5Kj5LOURMP7Q/oYuRxpPkaBuLPaTryBcBPy4CUv1ifzal7w+EI=
X-Received: by 2002:a1c:3c8a:: with SMTP id j132mr15314508wma.75.1605534631114;
        Mon, 16 Nov 2020 05:50:31 -0800 (PST)
X-Google-Smtp-Source: ABdhPJx9FZ+LW7QK8IxvfYKw8HZM2nBmqOroIn8kydjvs7JXbwrLCYUogyLsAlSID8SwZrvJAHfNt/83skS0HoJSbjw=
X-Received: by 2002:a1c:3c8a:: with SMTP id j132mr15314490wma.75.1605534630968;
 Mon, 16 Nov 2020 05:50:30 -0800 (PST)
MIME-Version: 1.0
References: <68b9650e-bef2-69e2-ab5e-8aaddaf46cfe@huawei.com>
In-Reply-To: <68b9650e-bef2-69e2-ab5e-8aaddaf46cfe@huawei.com>
From:   Mauricio Oliveira <mauricio.oliveira@canonical.com>
Date:   Mon, 16 Nov 2020 10:50:18 -0300
Message-ID: <CAO9xwp12E1wjErfX-Ef6+OKnme_ENOx22Hh=44g9cLn7aBr3-w@mail.gmail.com>
Subject: Re: [Bug report] journal data mode trigger panic in jbd2_journal_commit_transaction
To:     yangerkun <yangerkun@huawei.com>
Cc:     "Theodore Y . Ts'o" <tytso@mit.edu>, adilger.kernel@dilger.ca,
        Jan Kara <jack@suse.cz>, linux-ext4@vger.kernel.org,
        "zhangyi (F)" <yi.zhang@huawei.com>, Hou Tao <houtao1@huawei.com>,
        zhangxiaoxu5@huawei.com, Ye Bin <yebin10@huawei.com>,
        hejie3@huawei.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

Hi Kun,

On Sat, Nov 14, 2020 at 5:18 AM yangerkun <yangerkun@huawei.com> wrote:
> While using ext4 with data=journal(3.10 kernel), we meet a problem that
> we think may never happend...
[...]

Could you please confirm you mean 5.10-rc* kernel instead of 3.10?
(It seems so as you mention a recent commit below.)  Thanks!

> For now, what I have seen that can dirty buffer directly is
> ext4_page_mkwrite(64a9f1449950 ("ext4: data=journal: fixes for
> ext4_page_mkwrite()")), and runing ext4_punch_hole with keep_size
> /ext4_page_mkwrite parallel can trigger above warning easily.
[...]


-- 
Mauricio Faria de Oliveira
