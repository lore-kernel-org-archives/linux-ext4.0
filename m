Return-Path: <linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,FAKE_REPLY_C,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C6F33C433C1
	for <linux-ext4@archiver.kernel.org>; Mon, 22 Mar 2021 12:12:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8D8816198E
	for <linux-ext4@archiver.kernel.org>; Mon, 22 Mar 2021 12:12:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229951AbhCVMLg (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Mon, 22 Mar 2021 08:11:36 -0400
Received: from helcar.hmeau.com ([216.24.177.18]:41656 "EHLO fornost.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229933AbhCVMLK (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Mon, 22 Mar 2021 08:11:10 -0400
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.103.7])
        by fornost.hmeau.com with smtp (Exim 4.92 #5 (Debian))
        id 1lOJOW-0005vX-Up; Mon, 22 Mar 2021 23:10:54 +1100
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Mon, 22 Mar 2021 23:10:52 +1100
Date:   Mon, 22 Mar 2021 23:10:52 +1100
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Theodore Ts'o <tytso@mit.edu>
Cc:     yi.zhang@huawei.com, torvalds@linux-foundation.org,
        linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [GIT PULL] ext4 fixes for v5.12
Message-ID: <20210322121052.GA17398@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <YFgIZe4vMRDm+g8u@mit.edu>
X-Newsgroups: apana.lists.os.linux.kernel
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

Theodore Ts'o <tytso@mit.edu> wrote:
> 
> From: 曹子德(Theodore Y Ts'o) <tytso@mit.edu>

"Yue" doesn't seem to match your second character which is usually
romanised as "Tze" in Cantonese, could it be

	曹予德

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
