Return-Path: <SRS0=XG74=V6=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B1C1BC433FF
	for <linux-ext4@archiver.kernel.org>; Fri,  2 Aug 2019 15:14:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9014A217D6
	for <linux-ext4@archiver.kernel.org>; Fri,  2 Aug 2019 15:14:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730755AbfHBPOR (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Fri, 2 Aug 2019 11:14:17 -0400
Received: from mx2.suse.de ([195.135.220.15]:35246 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730695AbfHBPOR (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Fri, 2 Aug 2019 11:14:17 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id C11C2ACC4;
        Fri,  2 Aug 2019 15:14:15 +0000 (UTC)
Received: by quack2.suse.cz (Postfix, from userid 1000)
        id CA46A1E433B; Fri,  2 Aug 2019 17:14:14 +0200 (CEST)
From:   Jan Kara <jack@suse.cz>
To:     Ted Tso <tytso@mit.edu>
Cc:     <linux-ext4@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Anna-Maria Gleixner <anna-maria@linutronix.de>,
        Julia Cartwright <julia@ni.com>, Jan Kara <jack@suse.cz>
Subject: [PATCH 0/7] jbd2: Bit spinlock conversions
Date:   Fri,  2 Aug 2019 17:13:49 +0200
Message-Id: <20190802151356.777-1-jack@suse.cz>
X-Mailer: git-send-email 2.16.4
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

Hello,

This series is derived from Thomas' series to get rid of bit spinlocks in
buffer head code. These patches convert BH_State bit spinlock to an ordinary
spinlock inside struct journal_head and somewhat reduce the critical section
under BH_JournalHead bit spinlock so that it is fine for RT. 

Motivation from original Thomas' series:

Bit spinlocks are problematic if PREEMPT_RT is enabled. They disable
preemption, which is undesired for latency reasons and breaks when regular
spinlocks are taken within the bit_spinlock locked region because regular
spinlocks are converted to 'sleeping spinlocks' on RT.

Bit spinlocks are also not covered by lock debugging, e.g. lockdep. With
the spinlock substitution in place, they can be exposed via a new config
switch: CONFIG_DEBUG_BIT_SPINLOCKS.

WRT patch routing: Since these are non-trivial changes to JBD2 and independent
of the rest of the series from Thomas, I think it would be safest to route
them through ext4 tree where they get most testing. Thoughts?

								Honza
