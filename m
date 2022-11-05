Return-Path: <linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3051BC4332F
	for <linux-ext4@archiver.kernel.org>; Sat,  5 Nov 2022 06:01:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229720AbiKEGBm (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Sat, 5 Nov 2022 02:01:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60078 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229663AbiKEGBf (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Sat, 5 Nov 2022 02:01:35 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4CB463055C;
        Fri,  4 Nov 2022 23:01:33 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DCD35B830C2;
        Sat,  5 Nov 2022 06:01:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91D10C433D7;
        Sat,  5 Nov 2022 06:01:31 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.96)
        (envelope-from <rostedt@goodmis.org>)
        id 1orCFj-007OtV-2V;
        Sat, 05 Nov 2022 02:01:59 -0400
Message-ID: <20221105060159.614390819@goodmis.org>
User-Agent: quilt/0.66
Date:   Sat, 05 Nov 2022 02:00:50 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-kernel@vger.kernel.org
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Stephen Boyd <sboyd@kernel.org>,
        Guenter Roeck <linux@roeck-us.net>,
        Anna-Maria Gleixner <anna-maria@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Theodore Tso" <tytso@mit.edu>, Jan Kara <jack@suse.com>,
        linux-ext4@vger.kernel.org
Subject: [PATCH v4a 26/38] timers: jbd2: Use timer_shutdown() before freeing timer
References: <20221105060024.598488967@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

From: "Steven Rostedt (Google)" <rostedt@goodmis.org>

Before a timer is freed, timer_shutdown() must be called. Note that it is
assumed that the timer is not running while being freed, so only
timer_shutdown() is used, and not timer_shutdown_sync().

Link: https://lore.kernel.org/all/20221104054053.431922658@goodmis.org/

Cc: "Theodore Ts'o" <tytso@mit.edu>
Cc: Jan Kara <jack@suse.com>
Cc: linux-ext4@vger.kernel.org
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 fs/jbd2/journal.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/jbd2/journal.c b/fs/jbd2/journal.c
index 2696f43e7239..57d2445d8c8b 100644
--- a/fs/jbd2/journal.c
+++ b/fs/jbd2/journal.c
@@ -2157,6 +2157,8 @@ int jbd2_journal_destroy(journal_t *journal)
 	J_ASSERT(journal->j_checkpoint_transactions == NULL);
 	spin_unlock(&journal->j_list_lock);
 
+	timer_shutdown(&journal->j_commit_timer);
+
 	/*
 	 * OK, all checkpoint transactions have been checked, now check the
 	 * write out io error flag and abort the journal if some buffer failed
-- 
2.35.1
