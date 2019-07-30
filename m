Return-Path: <SRS0=NlID=V3=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C0867C0650F
	for <linux-ext4@archiver.kernel.org>; Tue, 30 Jul 2019 12:08:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 985F52087F
	for <linux-ext4@archiver.kernel.org>; Tue, 30 Jul 2019 12:08:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728816AbfG3MHt (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Tue, 30 Jul 2019 08:07:49 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:56550 "EHLO
        Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727206AbfG3MHs (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Tue, 30 Jul 2019 08:07:48 -0400
Received: from localhost ([127.0.0.1] helo=nanos.tec.linutronix.de)
        by Galois.linutronix.de with esmtp (Exim 4.80)
        (envelope-from <tglx@linutronix.de>)
        id 1hsQuL-0006QB-El; Tue, 30 Jul 2019 14:07:09 +0200
Message-Id: <20190730112452.871257694@linutronix.de>
User-Agent: quilt/0.65
Date:   Tue, 30 Jul 2019 13:24:52 +0200
From:   Thomas Gleixner <tglx@linutronix.de>
To:     LKML <linux-kernel@vger.kernel.org>
Cc:     Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@kernel.org>,
        Sebastian Siewior <bigeasy@linutronix.de>,
        Anna-Maria Gleixner <anna-maria@linutronix.de>,
        Steven Rostedt <rostedt@goodmis.org>,
        Julia Cartwright <julia@ni.com>,
        "Theodore Tso" <tytso@mit.edu>,
        Matthew Wilcox <willy@infradead.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
        Jan Kara <jack@suse.com>
Subject: [patch 0/4] fs: Substitute bit-spinlocks for PREEMPT_RT and debugging
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
hlist_bl bit-spinlock usage.

For most usage sites of hlist_bl the protected sections are either really
small and do not contain any RT incompatible code or can be trivially fixed
up. In those cases converting the list_bl locking to spinlocks looks like
overkill, but it still might make sense to provide it for debugging.

The only exception for this is the code in drivers/md/dm-snap.c which has
interesting nested locking in place (via kmemcache, cgroups, block ...)
which completely escapes lockdep.

I pondered making the hlist_bl locking conditional on a per source
file define, but that does not work due to include hell.

Thoughts?

Thanks,

	tglx


