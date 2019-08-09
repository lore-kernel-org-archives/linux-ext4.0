Return-Path: <SRS0=1y6H=WF=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 54E99C433FF
	for <linux-ext4@archiver.kernel.org>; Fri,  9 Aug 2019 12:42:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2D5A521783
	for <linux-ext4@archiver.kernel.org>; Fri,  9 Aug 2019 12:42:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406778AbfHIMmk (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Fri, 9 Aug 2019 08:42:40 -0400
Received: from mx2.suse.de ([195.135.220.15]:37640 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2406518AbfHIMmk (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Fri, 9 Aug 2019 08:42:40 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 1D4AEAF10;
        Fri,  9 Aug 2019 12:42:39 +0000 (UTC)
Received: by quack2.suse.cz (Postfix, from userid 1000)
        id 616771E47C2; Fri,  9 Aug 2019 14:42:38 +0200 (CEST)
From:   Jan Kara <jack@suse.cz>
To:     Ted Tso <tytso@mit.edu>
Cc:     <linux-ext4@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Anna-Maria Gleixner <anna-maria@linutronix.de>,
        Julia Cartwright <julia@ni.com>, Jan Kara <jack@suse.cz>
Subject: [PATCH 0/7 v2] jbd2: Bit spinlock conversions
Date:   Fri,  9 Aug 2019 14:42:26 +0200
Message-Id: <20190809124233.13277-1-jack@suse.cz>
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

Ted, can you pick up these patches? Thanks!

Changes since v1:
* Fixed up compilation breakage on UP due to missing linux/spinlock.h include

								Honza
