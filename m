Return-Path: <SRS0=d/q4=V4=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DE90EC32751
	for <linux-ext4@archiver.kernel.org>; Wed, 31 Jul 2019 19:41:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C6807214DA
	for <linux-ext4@archiver.kernel.org>; Wed, 31 Jul 2019 19:41:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729369AbfGaTlY (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Wed, 31 Jul 2019 15:41:24 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:33039 "EHLO
        Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726334AbfGaTlX (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Wed, 31 Jul 2019 15:41:23 -0400
Received: from pd9ef1cb8.dip0.t-ipconnect.de ([217.239.28.184] helo=nanos)
        by Galois.linutronix.de with esmtpsa (TLS1.2:DHE_RSA_AES_256_CBC_SHA256:256)
        (Exim 4.80)
        (envelope-from <tglx@linutronix.de>)
        id 1hsuSw-0005XI-1F; Wed, 31 Jul 2019 21:40:50 +0200
Date:   Wed, 31 Jul 2019 21:40:42 +0200 (CEST)
From:   Thomas Gleixner <tglx@linutronix.de>
To:     Jan Kara <jack@suse.cz>
cc:     LKML <linux-kernel@vger.kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Matthew Wilcox <willy@infradead.org>,
        Ingo Molnar <mingo@kernel.org>,
        Anna-Maria Gleixner <anna-maria@linutronix.de>,
        Sebastian Siewior <bigeasy@linutronix.de>,
        Theodore Tso <tytso@mit.edu>, Julia Cartwright <julia@ni.com>,
        Jan Kara <jack@suse.com>, linux-ext4@vger.kernel.org,
        linux-fsdevel@vger.kernel.org,
        Alexander Viro <viro@zeniv.linux.org.uk>
Subject: Re: [patch 4/4] fs: jbd/jbd2: Substitute BH locks for RT and lock
 debugging
In-Reply-To: <20190731154859.GI15806@quack2.suse.cz>
Message-ID: <alpine.DEB.2.21.1907312137500.1788@nanos.tec.linutronix.de>
References: <20190730112452.871257694@linutronix.de> <20190730120321.489374435@linutronix.de> <20190731154859.GI15806@quack2.suse.cz>
User-Agent: Alpine 2.21 (DEB 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

On Wed, 31 Jul 2019, Jan Kara wrote:
> On Tue 30-07-19 13:24:56, Thomas Gleixner wrote:
> > Bit spinlocks are problematic if PREEMPT_RT is enabled. They disable
> > preemption, which is undesired for latency reasons and breaks when regular
> > spinlocks are taken within the bit_spinlock locked region because regular
> > spinlocks are converted to 'sleeping spinlocks' on RT.
> > 
> > Substitute the BH_State and BH_JournalHead bit spinlocks with regular
> > spinlock for PREEMPT_RT enabled kernels.
> 
> Is there a real need for substitution for BH_JournalHead bit spinlock?  The
> critical sections are pretty tiny, all located within fs/jbd2/journal.c.
> Maybe only the one around __journal_remove_journal_head() would need a bit
> of refactoring so that journal_free_journal_head() doesn't get called
> under the bit-spinlock.

Makes sense.

> BH_State lock is definitely worth it. In fact, if you placed the spinlock
> inside struct journal_head (which is the structure whose members are in
> fact protected by it), I'd be even fine with just using the spinlock always
> instead of the bit spinlock. journal_head is pretty big anyway (and there's
> even 4-byte hole in it for 64-bit archs) and these structures are pretty
> rare (only for actively changed metadata buffers).

Just need to figure out what to do with the ASSERT_JH(state_is_locked) case for
UP. Perhaps just return true for UP && !DEBUG_SPINLOCK?

Thanks,

	tglx
