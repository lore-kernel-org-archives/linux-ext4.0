Return-Path: <SRS0=5sbL=RQ=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 01B7AC43381
	for <linux-ext4@archiver.kernel.org>; Wed, 13 Mar 2019 08:23:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B39432147C
	for <linux-ext4@archiver.kernel.org>; Wed, 13 Mar 2019 08:23:53 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="grfmCkak"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726748AbfCMIXx (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Wed, 13 Mar 2019 04:23:53 -0400
Received: from merlin.infradead.org ([205.233.59.134]:44270 "EHLO
        merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726184AbfCMIXx (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Wed, 13 Mar 2019 04:23:53 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=merlin.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=ZF2JrRtdYCEp+IupjRxB3HcNFx9KSR6YnGtkaQzc/BE=; b=grfmCkakHMirMqjV7s6VgpZVg
        GBe+apnjwvyUIfnhQcYX/MvNMPZkMyubjVoEkUN4EA1XMeldh2IVPS4esTQk6Rlwp4IBw3VwADMtG
        I2JoZoKVDYNyVKJ8SxykqWlv8RKU73La94OBiBi/HFI5p2us3KfAON5Hx8HfD02wf2rvPPZ0r1Wjg
        Pr/Du1hPpMdl1NW+kbEonu1R4SaHLfDsRaiYgazTv/HbEtY12XTVfp7eiZdy/n7VMICOTgKIhls+O
        G54KnragPNFgYrR2whgk299XN8gV80X3wXsjWsBwypll+z2WR21vFYjuritoF5/hV6cpihnxBatlx
        9fNXAJXYA==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=hirez.programming.kicks-ass.net)
        by merlin.infradead.org with esmtpsa (Exim 4.90_1 #2 (Red Hat Linux))
        id 1h3zAl-0006wd-7A; Wed, 13 Mar 2019 08:23:35 +0000
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id 035E42011D47B; Wed, 13 Mar 2019 09:23:33 +0100 (CET)
Date:   Wed, 13 Mar 2019 09:23:33 +0100
From:   Peter Zijlstra <peterz@infradead.org>
To:     "Eric W. Biederman" <ebiederm@xmission.com>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        Petr Mladek <pmladek@suse.com>,
        Linux List Kernel Mailing <linux-kernel@vger.kernel.org>,
        "Rafael J. Wysocky" <rafael.j.wysocki@intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-ext4@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        Jan Kara <jack@suse.cz>
Subject: Re: [question] panic() during reboot -f (reboot syscall)
Message-ID: <20190313082333.GB5996@hirez.programming.kicks-ass.net>
References: <20190306132938.hzyb7gee5actx3l3@pathway.suse.cz>
 <CAHk-=wi=m7vcLJB2uqTPcVd603ygCeKr7NBtR5y0M8KHtMzFWg@mail.gmail.com>
 <87k1h3pyru.fsf@xmission.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87k1h3pyru.fsf@xmission.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

On Tue, Mar 12, 2019 at 04:29:25PM -0500, Eric W. Biederman wrote:
> I wonder if there is an easy way to get the scheduler to not schedule
> userspace processes once the reboot system call has started.  That
> sounds like the simple way to avoid this kind of confusion.

That sounds like adding code to a hotpath that is 'never' used.
