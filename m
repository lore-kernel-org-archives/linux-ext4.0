Return-Path: <SRS0=Zm/I=YE=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 15F53ECE58C
	for <linux-ext4@archiver.kernel.org>; Fri, 11 Oct 2019 12:31:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EA1E1206A1
	for <linux-ext4@archiver.kernel.org>; Fri, 11 Oct 2019 12:31:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727953AbfJKMbN (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Fri, 11 Oct 2019 08:31:13 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:60622 "EHLO
        Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727672AbfJKMbN (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Fri, 11 Oct 2019 08:31:13 -0400
Received: from bigeasy by Galois.linutronix.de with local (Exim 4.80)
        (envelope-from <bigeasy@linutronix.de>)
        id 1iIu4Z-00008T-5V; Fri, 11 Oct 2019 14:31:07 +0200
Date:   Fri, 11 Oct 2019 14:31:07 +0200
From:   Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To:     Jan Kara <jack@suse.cz>
Cc:     Ted Tso <tytso@mit.edu>, linux-ext4@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Anna-Maria Gleixner <anna-maria@linutronix.de>,
        Julia Cartwright <julia@ni.com>
Subject: Re: [PATCH 0/7 v2] jbd2: Bit spinlock conversions
Message-ID: <20191011123105.s6qjwrlgugszk73j@linutronix.de>
References: <20190809124233.13277-1-jack@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20190809124233.13277-1-jack@suse.cz>
User-Agent: NeoMutt/20180716
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

On 2019-08-09 14:42:26 [+0200], Jan Kara wrote:
> Hello,
Hi,

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

Has this series been postponed?

> Changes since v1:
> * Fixed up compilation breakage on UP due to missing linux/spinlock.h include
> 
> 								Honza

Sebastian
