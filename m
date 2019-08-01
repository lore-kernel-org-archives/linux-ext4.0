Return-Path: <SRS0=Ly7y=V5=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C9CBDC32751
	for <linux-ext4@archiver.kernel.org>; Thu,  1 Aug 2019 01:16:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A75592067D
	for <linux-ext4@archiver.kernel.org>; Thu,  1 Aug 2019 01:16:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729565AbfHABQr (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Wed, 31 Jul 2019 21:16:47 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:33548 "EHLO
        Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729399AbfHABQj (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Wed, 31 Jul 2019 21:16:39 -0400
Received: from localhost ([127.0.0.1] helo=nanos.tec.linutronix.de)
        by Galois.linutronix.de with esmtp (Exim 4.80)
        (envelope-from <tglx@linutronix.de>)
        id 1hszhE-0002I1-Vj; Thu, 01 Aug 2019 03:15:57 +0200
Message-Id: <20190801010126.245731659@linutronix.de>
User-Agent: quilt/0.65
Date:   Thu, 01 Aug 2019 03:01:26 +0200
From:   Thomas Gleixner <tglx@linutronix.de>
To:     LKML <linux-kernel@vger.kernel.org>
Cc:     Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@kernel.org>,
        Sebastian Siewior <bigeasy@linutronix.de>,
        Anna-Maria Gleixner <anna-maria@linutronix.de>,
        Steven Rostedt <rostedt@goodmis.org>,
        Julia Cartwright <julia@ni.com>, Jan Kara <jack@suse.cz>,
        "Theodore Tso" <tytso@mit.edu>,
        Matthew Wilcox <willy@infradead.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
        Jan Kara <jack@suse.com>, Mark Fasheh <mark@fasheh.com>,
        Joseph Qi <joseph.qi@linux.alibaba.com>,
        Joel Becker <jlbec@evilplan.org>
Subject: [patch V2 0/7] fs: Substitute bit-spinlocks for PREEMPT_RT and
 debugging
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

Bit spinlocks are problematic if PREEMPT_RT is enabled. They disable
preemption, which is undesired for latency reasons and breaks when regular
spinlocks are taken within the bit_spinlock locked region because regular
spinlocks are converted to 'sleeping spinlocks' on RT.

Bit spinlocks are also not covered by lock debugging, e.g. lockdep. With
the spinlock substitution in place, they can be exposed via a new config
switch: CONFIG_DEBUG_BIT_SPINLOCKS.

This series handles only buffer head and jbd2, but does not touch the
hlist_bl bit-spinlock usage. See V1 for further details:

  https://lkml.kernel.org/r/20190730112452.871257694@linutronix.de

Changes vs. V1:

  - Collected reviewed-by tags for the BH_Uptodate part

  - Reworked the JBD2 part according to Jan's review:

     - Convert state lock to a regular spinlock unconditionally

     - Refactor jbd2_journal_put_journal_head() to be RT friendly by
       restricting the bit-spinlock held section to the minimum required
       operations.

       That part is probably over-engineered, but I'm sure Jan will tell me
       sooner than later.

Thanks,

        tglx


