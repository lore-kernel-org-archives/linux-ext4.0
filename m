Return-Path: <SRS0=bDK7=XG=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B8DD7C49ED6
	for <linux-ext4@archiver.kernel.org>; Wed, 11 Sep 2019 14:00:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8D669206A5
	for <linux-ext4@archiver.kernel.org>; Wed, 11 Sep 2019 14:00:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726762AbfIKOAF (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Wed, 11 Sep 2019 10:00:05 -0400
Received: from outgoing-auth-1.mit.edu ([18.9.28.11]:36095 "EHLO
        outgoing.mit.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726058AbfIKOAF (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Wed, 11 Sep 2019 10:00:05 -0400
Received: from callcc.thunk.org (38.85.69.148.rev.vodafone.pt [148.69.85.38] (may be forged))
        (authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
        by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id x8BDvsps004681
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 11 Sep 2019 09:57:58 -0400
Received: by callcc.thunk.org (Postfix, from userid 15806)
        id C6DC242049E; Wed, 11 Sep 2019 09:57:07 -0400 (EDT)
Date:   Wed, 11 Sep 2019 09:57:07 -0400
From:   "Theodore Y. Ts'o" <tytso@mit.edu>
To:     Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>
Cc:     linux-ext4@vger.kernel.org
Subject: Re: [PATCH 1/2] jbd2: add new tracepoint jbd2_sleep_on_shadow
Message-ID: <20190911135707.GC2740@mit.edu>
References: <20190902145442.1921-1-xiaoguang.wang@linux.alibaba.com>
 <20190907162145.GC23683@mit.edu>
 <5d96e18f-9610-208f-6db3-6a7b6a112400@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5d96e18f-9610-208f-6db3-6a7b6a112400@linux.alibaba.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

On Wed, Sep 11, 2019 at 02:52:51PM +0800, Xiaoguang Wang wrote:
> > I think maybe it might be better to use units of microseconds and then
> > change sleep to usleep so the units are clear?  This is a spinlock, so
> > it should be quick.
>
> Sorry, I may not quite understand you, do you mean that milliseconds is not precise, so
> should use microseconds? For these two patches, they do not use usleep or msleep to do
> real sleep work, they just record the duration which process takes to wait bh_shadow flag
> to be cleared or transaction to be unlocked.

Apologies, I should have been clear enough.  Yes, my concern that
milliseconds might not be fine-grained enough.  The sample results
which you showed had values of 2ms, 1ms, and 0ms.  And the single 0ms
result in particular raised the concern that we should use a
microseconds instead of milliseconds.

In fact, instead of "sleep", maybe "latency(us)" or "latency(ms)"
would be a better label?

Regards,

						- Ted
