Return-Path: <linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BF187C11F67
	for <linux-ext4@archiver.kernel.org>; Tue, 29 Jun 2021 19:12:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A7BBE61DD6
	for <linux-ext4@archiver.kernel.org>; Tue, 29 Jun 2021 19:12:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235500AbhF2TPH (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Tue, 29 Jun 2021 15:15:07 -0400
Received: from bhuna.collabora.co.uk ([46.235.227.227]:34908 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235336AbhF2TPH (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Tue, 29 Jun 2021 15:15:07 -0400
Received: from [127.0.0.1] (localhost [127.0.0.1])
        (Authenticated sender: krisman)
        with ESMTPSA id 880CE1F431AF
From:   Gabriel Krisman Bertazi <krisman@collabora.com>
To:     amir73il@gmail.com
Cc:     djwong@kernel.org, tytso@mit.edu, david@fromorbit.com,
        jack@suse.com, dhowells@redhat.com, khazhy@google.com,
        linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
        Gabriel Krisman Bertazi <krisman@collabora.com>,
        kernel@collabora.com
Subject: [PATCH v3 08/15] fsnotify: Support passing argument to insert callback on add_event
Date:   Tue, 29 Jun 2021 15:10:28 -0400
Message-Id: <20210629191035.681913-9-krisman@collabora.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210629191035.681913-1-krisman@collabora.com>
References: <20210629191035.681913-1-krisman@collabora.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

FAN_FS_ERROR requires some initialization to happen from inside the
insert hook.  This allows a user of fanotify_add_event to pass an
argument to be sent to the insert callback.

Signed-off-by: Gabriel Krisman Bertazi <krisman@collabora.com>
---
 fs/notify/fanotify/fanotify.c        | 5 +++--
 fs/notify/inotify/inotify_fsnotify.c | 2 +-
 fs/notify/notification.c             | 6 ++++--
 include/linux/fsnotify_backend.h     | 7 +++++--
 4 files changed, 13 insertions(+), 7 deletions(-)

diff --git a/fs/notify/fanotify/fanotify.c b/fs/notify/fanotify/fanotify.c
index 4f2febb15e94..aba06b84da91 100644
--- a/fs/notify/fanotify/fanotify.c
+++ b/fs/notify/fanotify/fanotify.c
@@ -695,7 +695,8 @@ static __kernel_fsid_t fanotify_get_fsid(struct fsnotify_iter_info *iter_info)
  * Add an event to hash table for faster merge.
  */
 static void fanotify_insert_event(struct fsnotify_group *group,
-				  struct fsnotify_event *fsn_event)
+				  struct fsnotify_event *fsn_event,
+				  const void *data)
 {
 	struct fanotify_event *event = FANOTIFY_E(fsn_event);
 	unsigned int bucket = fanotify_event_hash_bucket(group, event);
@@ -779,7 +780,7 @@ static int fanotify_handle_event(struct fsnotify_group *group, u32 mask,
 
 	fsn_event = &event->fse;
 	ret = fsnotify_add_event(group, fsn_event, fanotify_merge,
-				 fanotify_insert_event);
+				 fanotify_insert_event, NULL);
 	if (ret) {
 		/* Permission events shouldn't be merged */
 		BUG_ON(ret == 1 && mask & FANOTIFY_PERM_EVENTS);
diff --git a/fs/notify/inotify/inotify_fsnotify.c b/fs/notify/inotify/inotify_fsnotify.c
index d1a64daa0171..a003a64ff8ee 100644
--- a/fs/notify/inotify/inotify_fsnotify.c
+++ b/fs/notify/inotify/inotify_fsnotify.c
@@ -116,7 +116,7 @@ int inotify_handle_inode_event(struct fsnotify_mark *inode_mark, u32 mask,
 	if (len)
 		strcpy(event->name, name->name);
 
-	ret = fsnotify_add_event(group, fsn_event, inotify_merge, NULL);
+	ret = fsnotify_add_event(group, fsn_event, inotify_merge, NULL, NULL);
 	if (ret) {
 		/* Our event wasn't used in the end. Free it. */
 		fsnotify_destroy_event(group, fsn_event);
diff --git a/fs/notify/notification.c b/fs/notify/notification.c
index 32f45543b9c6..0d9ba592d725 100644
--- a/fs/notify/notification.c
+++ b/fs/notify/notification.c
@@ -83,7 +83,9 @@ int fsnotify_add_event(struct fsnotify_group *group,
 		       int (*merge)(struct fsnotify_group *,
 				    struct fsnotify_event *),
 		       void (*insert)(struct fsnotify_group *,
-				      struct fsnotify_event *))
+				      struct fsnotify_event *,
+				      const void *),
+		       const void *insert_data)
 {
 	int ret = 0;
 	struct list_head *list = &group->notification_list;
@@ -121,7 +123,7 @@ int fsnotify_add_event(struct fsnotify_group *group,
 	group->q_len++;
 	list_add_tail(&event->list, list);
 	if (insert)
-		insert(group, event);
+		insert(group, event, insert_data);
 	spin_unlock(&group->notification_lock);
 
 	wake_up(&group->notification_waitq);
diff --git a/include/linux/fsnotify_backend.h b/include/linux/fsnotify_backend.h
index b1590f654ade..8222fe12a6c9 100644
--- a/include/linux/fsnotify_backend.h
+++ b/include/linux/fsnotify_backend.h
@@ -526,11 +526,14 @@ extern int fsnotify_add_event(struct fsnotify_group *group,
 			      int (*merge)(struct fsnotify_group *,
 					   struct fsnotify_event *),
 			      void (*insert)(struct fsnotify_group *,
-					     struct fsnotify_event *));
+					     struct fsnotify_event *,
+					     const void *),
+			      const void *insert_data);
+
 /* Queue overflow event to a notification group */
 static inline void fsnotify_queue_overflow(struct fsnotify_group *group)
 {
-	fsnotify_add_event(group, group->overflow_event, NULL, NULL);
+	fsnotify_add_event(group, group->overflow_event, NULL, NULL, NULL);
 }
 
 static inline bool fsnotify_is_overflow_event(u32 mask)
-- 
2.32.0

