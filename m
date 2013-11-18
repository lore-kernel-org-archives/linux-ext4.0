From: Dmitry Monakhov <dmonakhov@openvz.org>
Subject: [PATCH] ext4: add generic uevent infrastructure
Date: Mon, 18 Nov 2013 18:38:40 +0400
Message-ID: <1384785520-607-1-git-send-email-dmonakhov@openvz.org>
Cc: Dmitry Monakhov <dmonakhov@openvz.org>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mailhub.sw.ru ([195.214.232.25]:36826 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751171Ab3KRPDJ (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 18 Nov 2013 10:03:09 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

*Purpose:
It is reasonable to annaunce fs related events via uevent infrastructure.
This patch implement only ext4'th part, but IMHO this should be usefull for
any generic filesystem.

Example: Runtime fs-error is pure async event. Currently there is no good
way to handle this situation and inform user-space about this.

*Implementation:
 Add uevent infrastructure similar to dm uevent
	FS_ACTION = {MOUNT|UMOUNT|REMOUNT|ERROR|FREEZE|UNFREEZE}
	FS_UUID
	FS_NAME
	FS_TYPE
*Open questions:
 - Is it worth to add mount option to event fields?

Please let me know what you think about this idea.

Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
---
 fs/ext4/ext4.h  |    9 +++++
 fs/ext4/super.c |   90 +++++++++++++++++++++++++++++++++++++++++++++++++++++-
 2 files changed, 97 insertions(+), 2 deletions(-)

diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index 2238e60..78cf2e6 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -2790,6 +2790,15 @@ enum ext4_state_bits {
 				 * allocated cluster. */
 };
 
+enum ext4_event_type {
+	EXT4_UA_MOUNT,
+	EXT4_UA_UMOUNT,
+	EXT4_UA_REMOUNT,
+	EXT4_UA_ERROR,
+	EXT4_UA_FREEZE,
+	EXT4_UA_UNFREEZE,
+};
+
 /*
  * Add new method to test whether block and inode bitmaps are properly
  * initialized. With uninit_bg reading the block from disk is not enough
diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index c977f4e..1113ba2 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -370,6 +370,82 @@ static void ext4_journal_commit_callback(journal_t *journal, transaction_t *txn)
 	spin_unlock(&sbi->s_md_lock);
 }
 
+static int ext4_uuid_valid(const u8 *uuid)
+{
+	int i;
+
+	for (i = 0; i < 16; i++) {
+		if (uuid[i])
+			return 1;
+	}
+	return 0;
+}
+
+/**
+ * ext4_send_uevent - prepare and send uevent
+ *
+ * @sb:		super_block
+ * @action:	action type
+ *
+ */
+int ext4_send_uevent(struct super_block *sb, enum ext4_event_type action)
+{
+	int ret;
+	struct kobj_uevent_env *env;
+	const u8 *uuid = sb->s_uuid;
+	enum kobject_action kaction = KOBJ_CHANGE;
+
+	env = kzalloc(sizeof(struct kobj_uevent_env), GFP_KERNEL);
+	if (!env)
+		return -ENOMEM;
+
+	ret = add_uevent_var(env, "FS_TYPE=%s", sb->s_type->name);
+	if (ret)
+		goto out;
+	ret = add_uevent_var(env, "FS_NAME=%s", sb->s_id);
+	if (ret)
+		goto out;
+
+	if (ext4_uuid_valid(uuid)) {
+		ret = add_uevent_var(env, "UUID=%pUB", uuid);
+		if (ret)
+			goto out;
+	}
+
+	switch (action) {
+	case EXT4_UA_MOUNT:
+		kaction = KOBJ_ONLINE;
+		ret = add_uevent_var(env, "FS_ACTION=%s", "MOUNT");
+		break;
+	case EXT4_UA_UMOUNT:
+		kaction = KOBJ_OFFLINE;
+		ret = add_uevent_var(env, "FS_ACTION=%s", "UMOUNT");
+		break;
+	case EXT4_UA_REMOUNT:
+		ret = add_uevent_var(env, "FS_ACTION=%s", "REMOUNT");
+		break;
+	case EXT4_UA_ERROR:
+		ret = add_uevent_var(env, "FS_ACTION=%s", "ERROR");
+		break;
+	case EXT4_UA_FREEZE:
+		ret = add_uevent_var(env, "FS_ACTION=%s", "FREEZE");
+		break;
+	case EXT4_UA_UNFREEZE:
+		ret = add_uevent_var(env, "FS_ACTION=%s", "UNFREEZE");
+		break;
+
+	default:
+		ret = -EINVAL;
+	}
+	if (ret)
+		goto out;
+
+	ret = kobject_uevent_env(&(EXT4_SB(sb)->s_kobj), kaction, env->envp);
+out:
+	kfree(env);
+	return ret;
+}
+
 /* Deal with the reporting of failure conditions on a filesystem such as
  * inconsistencies detected or read IO failures.
  *
@@ -409,6 +485,8 @@ static void ext4_handle_error(struct super_block *sb)
 	if (test_opt(sb, ERRORS_PANIC))
 		panic("EXT4-fs (device %s): panic forced after error\n",
 			sb->s_id);
+
+	ext4_send_uevent(sb, EXT4_UA_ERROR);
 }
 
 #define ext4_error_ratelimit(sb)					\
@@ -778,6 +856,7 @@ static void ext4_put_super(struct super_block *sb)
 	struct ext4_super_block *es = sbi->s_es;
 	int i, err;
 
+	ext4_send_uevent(sb, EXT4_UA_UMOUNT);
 	ext4_unregister_li_request(sb);
 	dquot_disable(sb, -1, DQUOT_USAGE_ENABLED | DQUOT_LIMITS_ENABLED);
 
@@ -4151,6 +4230,7 @@ no_journal:
 	ratelimit_state_init(&sbi->s_warning_ratelimit_state, 5 * HZ, 10);
 	ratelimit_state_init(&sbi->s_msg_ratelimit_state, 5 * HZ, 10);
 
+	ext4_send_uevent(sb, EXT4_UA_MOUNT);
 	kfree(orig_data);
 	return 0;
 
@@ -4679,9 +4759,10 @@ static int ext4_freeze(struct super_block *sb)
 	int error = 0;
 	journal_t *journal;
 
-	if (sb->s_flags & MS_RDONLY)
+	if (sb->s_flags & MS_RDONLY) {
+		ext4_send_uevent(sb, EXT4_UA_FREEZE);
 		return 0;
-
+	}
 	journal = EXT4_SB(sb)->s_journal;
 
 	/* Now we set up the journal barrier. */
@@ -4701,6 +4782,8 @@ static int ext4_freeze(struct super_block *sb)
 out:
 	/* we rely on upper layer to stop further updates */
 	jbd2_journal_unlock_updates(EXT4_SB(sb)->s_journal);
+	if (!error)
+		ext4_send_uevent(sb, EXT4_UA_FREEZE);
 	return error;
 }
 
@@ -4710,6 +4793,8 @@ out:
  */
 static int ext4_unfreeze(struct super_block *sb)
 {
+	ext4_send_uevent(sb, EXT4_UA_UNFREEZE);
+
 	if (sb->s_flags & MS_RDONLY)
 		return 0;
 
@@ -4934,6 +5019,7 @@ static int ext4_remount(struct super_block *sb, int *flags, char *data)
 #endif
 
 	ext4_msg(sb, KERN_INFO, "re-mounted. Opts: %s", orig_data);
+	ext4_send_uevent(sb, EXT4_UA_REMOUNT);
 	kfree(orig_data);
 	return 0;
 
-- 
1.7.1

