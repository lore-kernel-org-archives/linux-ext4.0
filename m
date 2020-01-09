Return-Path: <SRS0=4t8C=26=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ED9D8C33CA1
	for <linux-ext4@archiver.kernel.org>; Thu,  9 Jan 2020 23:02:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CC5852072E
	for <linux-ext4@archiver.kernel.org>; Thu,  9 Jan 2020 23:02:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728783AbgAIXCl (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Thu, 9 Jan 2020 18:02:41 -0500
Received: from excelsior.roeckx.be ([195.234.45.115]:35675 "EHLO
        excelsior.roeckx.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726267AbgAIXCl (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Thu, 9 Jan 2020 18:02:41 -0500
Received: from intrepid.roeckx.be (localhost [127.0.0.1])
        by excelsior.roeckx.be (Postfix) with ESMTP id 8B42EA8A0573;
        Thu,  9 Jan 2020 23:02:38 +0000 (UTC)
Received: by intrepid.roeckx.be (Postfix, from userid 1000)
        id 4C97F1FE0C7A; Fri, 10 Jan 2020 00:02:38 +0100 (CET)
Date:   Fri, 10 Jan 2020 00:02:37 +0100
From:   Kurt Roeckx <kurt@roeckx.be>
To:     "Theodore Y. Ts'o" <tytso@mit.edu>
Cc:     Stephan Mueller <smueller@chronox.de>,
        Andy Lutomirski <luto@amacapital.net>,
        Andy Lutomirski <luto@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux API <linux-api@vger.kernel.org>,
        Kees Cook <keescook@chromium.org>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>,
        "Ahmed S. Darwish" <darwish.07@gmail.com>,
        Lennart Poettering <mzxreary@0pointer.de>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        "Alexander E. Patrakov" <patrakov@gmail.com>,
        Michael Kerrisk <mtk.manpages@gmail.com>,
        Willy Tarreau <w@1wt.eu>,
        Matthew Garrett <mjg59@srcf.ucam.org>,
        Ext4 Developers List <linux-ext4@vger.kernel.org>,
        linux-man <linux-man@vger.kernel.org>
Subject: Re: [PATCH v3 0/8] Rework random blocking
Message-ID: <20200109230237.GA2992@roeckx.be>
References: <20191226140423.GB3158@mit.edu>
 <4048434.Q8HajmOrkZ@tauon.chronox.de>
 <20191227130436.GC70060@mit.edu>
 <15817620.rmTN4T87Wr@tauon.chronox.de>
 <20191227220857.GD70060@mit.edu>
 <20200109220230.GA39185@roeckx.be>
 <20200109224011.GD41242@mit.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200109224011.GD41242@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

On Thu, Jan 09, 2020 at 05:40:11PM -0500, Theodore Y. Ts'o wrote:
> On Thu, Jan 09, 2020 at 11:02:30PM +0100, Kurt Roeckx wrote:
> > 
> > One thing the NIST DRBGs have is prediction resistance, which is
> > done by reseeding. If you chain DRBGs, you tell your parent DRBG
> > that you want prediction resistance, so your parent will also
> > reseed. There currently is no way to tell the kernel to reseed.
> 
> It would be simple enough to add a new flag, perhaps GRND_RESEED, to
> getrandom() which requests that the kernel reseed first.  This would
> require sufficient amounts of entropy in the input pool to do the
> reseed; if there is not enough, the getrandom() call would block until
> there was enough.  If GRND_NONBLOCK is supplied, then getrandom()
> would return EAGAIN if there wasn't sufficient entropy.
> 
> Is this what you want?

I think some people might want to see it, but I think you
shouldn't add it.

> > I don't think we want that. As far as I know, the only reason for
> > using /dev/random is that /dev/urandom returns data before it
> > has sufficient entropy.
> 
> Is there any objections to just using getrandom(2)?

It provides the interface we want, so no. But there are still
people who don't have it for various reasons. OpenSSL actually
does the system call itself if libc doesn't provider a wrapper for
it.


Kurt

