Return-Path: <linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4F76BC48BDF
	for <linux-ext4@archiver.kernel.org>; Tue, 15 Jun 2021 23:56:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 390876023C
	for <linux-ext4@archiver.kernel.org>; Tue, 15 Jun 2021 23:56:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231243AbhFOX6N (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Tue, 15 Jun 2021 19:58:13 -0400
Received: from bhuna.collabora.co.uk ([46.235.227.227]:39898 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229811AbhFOX6M (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Tue, 15 Jun 2021 19:58:12 -0400
Received: from [127.0.0.1] (localhost [127.0.0.1])
        (Authenticated sender: krisman)
        with ESMTPSA id A7E861F432D9
From:   Gabriel Krisman Bertazi <krisman@collabora.com>
To:     amir73il@gmail.com
Cc:     kernel@collabora.com, djwong@kernel.org, tytso@mit.edu,
        david@fromorbit.com, jack@suse.com, dhowells@redhat.com,
        khazhy@google.com, linux-fsdevel@vger.kernel.org,
        linux-ext4@vger.kernel.org,
        Gabriel Krisman Bertazi <krisman@collabora.com>
Subject: [PATCH v2 01/14] fsnotify: Don't call insert hook for overflow events
Date:   Tue, 15 Jun 2021 19:55:43 -0400
Message-Id: <20210615235556.970928-2-krisman@collabora.com>
X-Mailer: git-send-email 2.31.0
In-Reply-To: <20210615235556.970928-1-krisman@collabora.com>
References: <20210615235556.970928-1-krisman@collabora.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

Overflow events are not mergeable, so they are not hashed_events.  But,
when failing inside fsnotify_add_event, for lack of space,
fsnotify_add_event() still calls the insert hook, which adds the
overflow event to the merge list.

Avoid calling the insert hook when adding an overflow event.

Fixes: 94e00d28a680 ("fsnotify: use hash table for faster events merge")
Signed-off-by: Gabriel Krisman Bertazi <krisman@collabora.com>
---
 fs/notify/notification.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/fs/notify/notification.c b/fs/notify/notification.c
index 32f45543b9c6..033294669e07 100644
--- a/fs/notify/notification.c
+++ b/fs/notify/notification.c
@@ -106,6 +106,11 @@ int fsnotify_add_event(struct fsnotify_group *group,
 			return ret;
 		}
 		event = group->overflow_event;
+		/*
+		 * Since overflow events are not mergeable, don't insert
+		 * them in the merge hash.
+		 */
+		insert = NULL;
 		goto queue;
 	}
 
-- 
2.31.0

