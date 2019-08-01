Return-Path: <SRS0=Ly7y=V5=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 76073C433FF
	for <linux-ext4@archiver.kernel.org>; Thu,  1 Aug 2019 08:44:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 53948216C8
	for <linux-ext4@archiver.kernel.org>; Thu,  1 Aug 2019 08:44:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729454AbfHAIoP (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Thu, 1 Aug 2019 04:44:15 -0400
Received: from mx2.suse.de ([195.135.220.15]:54346 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726677AbfHAIoP (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Thu, 1 Aug 2019 04:44:15 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 5B652AE49;
        Thu,  1 Aug 2019 08:44:13 +0000 (UTC)
Received: by quack2.suse.cz (Postfix, from userid 1000)
        id 1524C1E3F4D; Thu,  1 Aug 2019 10:44:12 +0200 (CEST)
Date:   Thu, 1 Aug 2019 10:44:12 +0200
From:   Jan Kara <jack@suse.cz>
To:     Thomas Gleixner <tglx@linutronix.de>
Cc:     Jan Kara <jack@suse.cz>, LKML <linux-kernel@vger.kernel.org>,
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
Message-ID: <20190801084412.GD25064@quack2.suse.cz>
References: <20190730112452.871257694@linutronix.de>
 <20190730120321.489374435@linutronix.de>
 <20190731154859.GI15806@quack2.suse.cz>
 <alpine.DEB.2.21.1907312137500.1788@nanos.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.21.1907312137500.1788@nanos.tec.linutronix.de>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

On Wed 31-07-19 21:40:42, Thomas Gleixner wrote:
> On Wed, 31 Jul 2019, Jan Kara wrote:
> > BH_State lock is definitely worth it. In fact, if you placed the spinlock
> > inside struct journal_head (which is the structure whose members are in
> > fact protected by it), I'd be even fine with just using the spinlock always
> > instead of the bit spinlock. journal_head is pretty big anyway (and there's
> > even 4-byte hole in it for 64-bit archs) and these structures are pretty
> > rare (only for actively changed metadata buffers).
> 
> Just need to figure out what to do with the ASSERT_JH(state_is_locked) case for
> UP. Perhaps just return true for UP && !DEBUG_SPINLOCK?

Yes, that makes sense.

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
