Return-Path: <linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6BD9DC43217
	for <linux-ext4@archiver.kernel.org>; Fri,  4 Mar 2022 07:08:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238803AbiCDHJF (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Fri, 4 Mar 2022 02:09:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39052 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238782AbiCDHIw (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Fri, 4 Mar 2022 02:08:52 -0500
Received: from lgeamrelo11.lge.com (lgeamrelo12.lge.com [156.147.23.52])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 8E80B192CA4
        for <linux-ext4@vger.kernel.org>; Thu,  3 Mar 2022 23:07:13 -0800 (PST)
Received: from unknown (HELO lgemrelse6q.lge.com) (156.147.1.121)
        by 156.147.23.52 with ESMTP; 4 Mar 2022 16:07:09 +0900
X-Original-SENDERIP: 156.147.1.121
X-Original-MAILFROM: byungchul.park@lge.com
Received: from unknown (HELO localhost.localdomain) (10.177.244.38)
        by 156.147.1.121 with ESMTP; 4 Mar 2022 16:07:09 +0900
X-Original-SENDERIP: 10.177.244.38
X-Original-MAILFROM: byungchul.park@lge.com
From:   Byungchul Park <byungchul.park@lge.com>
To:     torvalds@linux-foundation.org
Cc:     damien.lemoal@opensource.wdc.com, linux-ide@vger.kernel.org,
        adilger.kernel@dilger.ca, linux-ext4@vger.kernel.org,
        mingo@redhat.com, linux-kernel@vger.kernel.org,
        peterz@infradead.org, will@kernel.org, tglx@linutronix.de,
        rostedt@goodmis.org, joel@joelfernandes.org, sashal@kernel.org,
        daniel.vetter@ffwll.ch, chris@chris-wilson.co.uk,
        duyuyang@gmail.com, johannes.berg@intel.com, tj@kernel.org,
        tytso@mit.edu, willy@infradead.org, david@fromorbit.com,
        amir73il@gmail.com, bfields@fieldses.org,
        gregkh@linuxfoundation.org, kernel-team@lge.com,
        linux-mm@kvack.org, akpm@linux-foundation.org, mhocko@kernel.org,
        minchan@kernel.org, hannes@cmpxchg.org, vdavydov.dev@gmail.com,
        sj@kernel.org, jglisse@redhat.com, dennis@kernel.org, cl@linux.com,
        penberg@kernel.org, rientjes@google.com, vbabka@suse.cz,
        ngupta@vflare.org, linux-block@vger.kernel.org,
        paolo.valente@linaro.org, josef@toxicpanda.com,
        linux-fsdevel@vger.kernel.org, viro@zeniv.linux.org.uk,
        jack@suse.cz, jack@suse.com, jlayton@kernel.org,
        dan.j.williams@intel.com, hch@infradead.org, djwong@kernel.org,
        dri-devel@lists.freedesktop.org, airlied@linux.ie,
        rodrigosiqueiramelo@gmail.com, melissa.srw@gmail.com,
        hamohammed.sa@gmail.com
Subject: [PATCH v4 23/24] dept: Let it work with real sleeps in __schedule()
Date:   Fri,  4 Mar 2022 16:06:42 +0900
Message-Id: <1646377603-19730-24-git-send-email-byungchul.park@lge.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1646377603-19730-1-git-send-email-byungchul.park@lge.com>
References: <1646377603-19730-1-git-send-email-byungchul.park@lge.com>
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

Dept commits the staged wait in __schedule() even if the corresponding
wake_up() has already woken up the task. Which means Dept considers the
case as a sleep. This would help Dept work for stronger detection but
also leads false positives.

It'd be better to let Dept work only with real sleeps conservatively for
now. So did it.

Signed-off-by: Byungchul Park <byungchul.park@lge.com>
---
 kernel/sched/core.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 6a422aa..2ec7cf8 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -6192,7 +6192,12 @@ static void __sched notrace __schedule(unsigned int sched_mode)
 	local_irq_disable();
 	rcu_note_context_switch(!!sched_mode);
 
-	if (sched_mode == SM_NONE)
+	/*
+	 * Skip the commit if the current task does not actually go to
+	 * sleep.
+	 */
+	if (READ_ONCE(prev->__state) & TASK_NORMAL &&
+	    sched_mode == SM_NONE)
 		dept_ask_event_wait_commit(_RET_IP_);
 
 	/*
-- 
1.9.1

