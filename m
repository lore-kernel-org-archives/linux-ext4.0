Return-Path: <SRS0=NJ1U=Y3=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 746A9CA9EB0
	for <linux-ext4@archiver.kernel.org>; Sun,  3 Nov 2019 19:02:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5078721929
	for <linux-ext4@archiver.kernel.org>; Sun,  3 Nov 2019 19:02:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728069AbfKCTCn (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Sun, 3 Nov 2019 14:02:43 -0500
Received: from outgoing-auth-1.mit.edu ([18.9.28.11]:49694 "EHLO
        outgoing.mit.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727322AbfKCTCn (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Sun, 3 Nov 2019 14:02:43 -0500
Received: from callcc.thunk.org (ip-12-2-52-196.nyc.us.northamericancoax.com [196.52.2.12])
        (authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
        by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id xA3J1gL9011616
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sun, 3 Nov 2019 14:01:43 -0500
Received: by callcc.thunk.org (Postfix, from userid 15806)
        id 71748420311; Sun,  3 Nov 2019 14:01:41 -0500 (EST)
Date:   Sun, 3 Nov 2019 14:01:41 -0500
From:   "Theodore Y. Ts'o" <tytso@mit.edu>
To:     Jan Kara <jack@suse.cz>
Cc:     linux-ext4@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Anna-Maria Gleixner <anna-maria@linutronix.de>,
        Julia Cartwright <julia@ni.com>
Subject: Re: [PATCH 0/7 v2] jbd2: Bit spinlock conversions
Message-ID: <20191103190141.GA8037@mit.edu>
References: <20190809124233.13277-1-jack@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190809124233.13277-1-jack@suse.cz>
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

On Fri, Aug 09, 2019 at 02:42:26PM +0200, Jan Kara wrote:
> Hello,
> 
> This series is derived from Thomas' series to get rid of bit spinlocks in
> buffer head code. These patches convert BH_State bit spinlock to an ordinary
> spinlock inside struct journal_head and somewhat reduce the critical section
> under BH_JournalHead bit spinlock so that it is fine for RT. 
> 
> Motivation from original Thomas' series:
> 
> Bit spinlocks are problematic if PREEMPT_RT is enabled. They disable
> preemption, which is undesired for latency reasons and breaks when regular
> spinlocks are taken within the bit_spinlock locked region because regular
> spinlocks are converted to 'sleeping spinlocks' on RT.
> 
> Bit spinlocks are also not covered by lock debugging, e.g. lockdep. With
> the spinlock substitution in place, they can be exposed via a new config
> switch: CONFIG_DEBUG_BIT_SPINLOCKS.
> 
> Ted, can you pick up these patches? Thanks!

I've landed this patch set on the ext4 git tree.  Thanks!

     	    	       	      	       - Ted
