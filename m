Return-Path: <SRS0=W73r=U4=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 390B8C46478
	for <linux-ext4@archiver.kernel.org>; Sat, 29 Jun 2019 16:53:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1B9AD2086D
	for <linux-ext4@archiver.kernel.org>; Sat, 29 Jun 2019 16:53:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726882AbfF2QxK (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Sat, 29 Jun 2019 12:53:10 -0400
Received: from smtprelay0072.hostedemail.com ([216.40.44.72]:46295 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726837AbfF2QxK (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>);
        Sat, 29 Jun 2019 12:53:10 -0400
X-Greylist: delayed 456 seconds by postgrey-1.27 at vger.kernel.org; Sat, 29 Jun 2019 12:53:09 EDT
Received: from smtprelay.hostedemail.com (10.5.19.251.rfc1918.com [10.5.19.251])
        by smtpgrave03.hostedemail.com (Postfix) with ESMTP id D68C61801FA36;
        Sat, 29 Jun 2019 16:45:34 +0000 (UTC)
Received: from filter.hostedemail.com (clb03-v110.bra.tucows.net [216.40.38.60])
        by smtprelay08.hostedemail.com (Postfix) with ESMTP id 72872182CF666;
        Sat, 29 Jun 2019 16:45:32 +0000 (UTC)
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-HE-Tag: wood26_67b7f2b025644
X-Filterd-Recvd-Size: 3038
Received: from XPS-9350 (cpe-23-242-196-136.socal.res.rr.com [23.242.196.136])
        (Authenticated sender: joe@perches.com)
        by omf01.hostedemail.com (Postfix) with ESMTPA;
        Sat, 29 Jun 2019 16:45:12 +0000 (UTC)
Message-ID: <c3b83ba7f9b003dd4fb9cad885461ce93165dc04.camel@perches.com>
Subject: Re: [PATCH V2] include: linux: Regularise the use of FIELD_SIZEOF
 macro
From:   Joe Perches <joe@perches.com>
To:     Alexey Dobriyan <adobriyan@gmail.com>,
        Andreas Dilger <adilger@dilger.ca>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        Shyam Saini <shyam.saini@amarulasolutions.com>,
        kernel-hardening@lists.openwall.com, linux-kernel@vger.kernel.org,
        keescook@chromium.org, linux-arm-kernel@lists.infradead.org,
        linux-mips@vger.kernel.org, intel-gvt-dev@lists.freedesktop.org,
        intel-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org,
        netdev@vger.kernel.org, linux-ext4 <linux-ext4@vger.kernel.org>,
        devel@lists.orangefs.org, linux-mm@kvack.org,
        linux-sctp@vger.kernel.org, bpf@vger.kernel.org,
        kvm@vger.kernel.org, mayhs11saini@gmail.com
Date:   Sat, 29 Jun 2019 09:45:10 -0700
In-Reply-To: <20190629142510.GA10629@avx2>
References: <20190611193836.2772-1-shyam.saini@amarulasolutions.com>
         <20190611134831.a60c11f4b691d14d04a87e29@linux-foundation.org>
         <6DCAE4F8-3BEC-45F2-A733-F4D15850B7F3@dilger.ca>
         <20190629142510.GA10629@avx2>
Content-Type: text/plain; charset="ISO-8859-1"
User-Agent: Evolution 3.30.5-0ubuntu0.18.10.1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

On Sat, 2019-06-29 at 17:25 +0300, Alexey Dobriyan wrote:
> On Tue, Jun 11, 2019 at 03:00:10PM -0600, Andreas Dilger wrote:
> > On Jun 11, 2019, at 2:48 PM, Andrew Morton <akpm@linux-foundation.org> wrote:
> > > On Wed, 12 Jun 2019 01:08:36 +0530 Shyam Saini <shyam.saini@amarulasolutions.com> wrote:
> > I did a check, and FIELD_SIZEOF() is used about 350x, while sizeof_field()
> > is about 30x, and SIZEOF_FIELD() is only about 5x.
> > 
> > That said, I'm much more in favour of "sizeof_field()" or "sizeof_member()"
> > than FIELD_SIZEOF().  Not only does that better match "offsetof()", with
> > which it is closely related, but is also closer to the original "sizeof()".
> > 
> > Since this is a rather trivial change, it can be split into a number of
> > patches to get approval/landing via subsystem maintainers, and there is no
> > huge urgency to remove the original macros until the users are gone.  It
> > would make sense to remove SIZEOF_FIELD() and sizeof_field() quickly so
> > they don't gain more users, and the remaining FIELD_SIZEOF() users can be
> > whittled away as the patches come through the maintainer trees.
> 
> The signature should be
> 
> 	sizeof_member(T, m)
> 
> it is proper English,
> it is lowercase, so is easier to type,
> it uses standard term (member, not field),
> it blends in with standard "sizeof" operator,

yes please.

Also, a simple script conversion applied
immediately after an rc1 might be easiest
rather than individual patches.


