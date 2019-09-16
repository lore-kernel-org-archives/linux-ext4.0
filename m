Return-Path: <SRS0=+K+T=XL=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=FAKE_REPLY_C,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4D563C49ED7
	for <linux-ext4@archiver.kernel.org>; Mon, 16 Sep 2019 03:52:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2CB7720890
	for <linux-ext4@archiver.kernel.org>; Mon, 16 Sep 2019 03:52:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728999AbfIPDwy (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Sun, 15 Sep 2019 23:52:54 -0400
Received: from helcar.hmeau.com ([216.24.177.18]:33832 "EHLO fornost.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727387AbfIPDwy (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Sun, 15 Sep 2019 23:52:54 -0400
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.0.7])
        by fornost.hmeau.com with smtp (Exim 4.89 #2 (Debian))
        id 1i9i41-0000sf-QO; Mon, 16 Sep 2019 13:52:34 +1000
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Mon, 16 Sep 2019 13:52:28 +1000
Date:   Mon, 16 Sep 2019 13:52:28 +1000
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     "Theodore Y. Ts'o" <tytso@mit.edu>
Cc:     torvalds@linux-foundation.org, darwish.07@gmail.com,
        adilger.kernel@dilger.ca, jack@suse.cz, rstrode@redhat.com,
        mccann@jhu.edu, zachary@baishancloud.com,
        linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: Linux 5.3-rc8
Message-ID: <20190916035228.GA1767@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190911160729.GF2740@mit.edu>
X-Newsgroups: apana.lists.os.linux.kernel
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

Theodore Y. Ts'o <tytso@mit.edu> wrote:
>
> Ultimately, though, we need to find *some* way to fix userspace's
> assumptions that they can always get high quality entropy in early
> boot, or we need to get over people's distrust of Intel and RDRAND.
> Otherwise, future performance improvements in any part of the system
> which reduces the number of interrupts is always going to potentially
> result in somebody's misconfigured system or badly written
> applications to fail to boot.  :-(

Can we perhaps artifically increase the interrupt rate while the
CRNG is not initialised?

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
