Return-Path: <SRS0=rV8s=XP=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E5092C3A5A2
	for <linux-ext4@archiver.kernel.org>; Fri, 20 Sep 2019 17:26:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C75B52054F
	for <linux-ext4@archiver.kernel.org>; Fri, 20 Sep 2019 17:26:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729494AbfITR0V (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Fri, 20 Sep 2019 13:26:21 -0400
Received: from wtarreau.pck.nerim.net ([62.212.114.60]:49204 "EHLO 1wt.eu"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729485AbfITR0V (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Fri, 20 Sep 2019 13:26:21 -0400
Received: (from willy@localhost)
        by pcw.home.local (8.15.2/8.15.2/Submit) id x8KHQ9oc001842;
        Fri, 20 Sep 2019 19:26:09 +0200
Date:   Fri, 20 Sep 2019 19:26:09 +0200
From:   Willy Tarreau <w@1wt.eu>
To:     "Ahmed S. Darwish" <darwish.07@gmail.com>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        Lennart Poettering <mzxreary@0pointer.de>,
        "Theodore Y. Ts'o" <tytso@mit.edu>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        "Alexander E. Patrakov" <patrakov@gmail.com>,
        Michael Kerrisk <mtk.manpages@gmail.com>,
        Matthew Garrett <mjg59@srcf.ucam.org>,
        lkml <linux-kernel@vger.kernel.org>, linux-ext4@vger.kernel.org,
        linux-api@vger.kernel.org, linux-man@vger.kernel.org
Subject: Re: [PATCH RFC v4 1/1] random: WARN on large getrandom() waits and
 introduce getrandom2()
Message-ID: <20190920172609.GA1832@1wt.eu>
References: <20190912082530.GA27365@mit.edu>
 <CAHk-=wjyH910+JRBdZf_Y9G54c1M=LBF8NKXB6vJcm9XjLnRfg@mail.gmail.com>
 <20190914122500.GA1425@darwi-home-pc>
 <008f17bc-102b-e762-a17c-e2766d48f515@gmail.com>
 <20190915052242.GG19710@mit.edu>
 <CAHk-=wgg2T=3KxrO-BY3nHJgMEyApjnO3cwbQb_0vxsn9qKN8Q@mail.gmail.com>
 <20190918211503.GA1808@darwi-home-pc>
 <20190918211713.GA2225@darwi-home-pc>
 <CAHk-=wiCqDiU7SE3FLn2W26MS_voUAuqj5XFa1V_tiGTrrW-zQ@mail.gmail.com>
 <20190920134609.GA2113@pc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190920134609.GA2113@pc>
User-Agent: Mutt/1.6.1 (2016-04-27)
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

Hi Ahmed,

On Fri, Sep 20, 2019 at 03:46:09PM +0200, Ahmed S. Darwish wrote:
> Problem is, glibc is still *really* slow in adopting linux syscall
> wrappers, so I'm not optimistic about that...
>
> I still see the new system call as the sanest path, even provided
> the cost of a new syscall number..

New syscalls are always a pain to deal with in userland, because when
they are introduced, everyone wants them long before they're available
in glibc. So userland has to define NR_xxx for each supported arch and
to perform the call itself.

With flags adoption is instantaneous. Just #ifndef/#define, check if
the flag is supported and that's done. The only valid reason for a new
syscall is when the API changes (e.g. one extra arg, a la accept4()),
which doesn't seem to be the case here. Otherwise please by all means
avoid this in general.

Thanks,
Willy
