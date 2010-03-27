From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 13549] Kernel oops while online resizing of an ext4 filesystem
Date: Sat, 27 Mar 2010 19:16:15 GMT
Message-ID: <201003271916.o2RJGFvn019746@demeter.kernel.org>
References: <bug-13549-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:50605 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753841Ab0C0TQS (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 27 Mar 2010 15:16:18 -0400
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.3/8.14.3) with ESMTP id o2RJGGg0019754
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Sat, 27 Mar 2010 19:16:17 GMT
In-Reply-To: <bug-13549-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=13549





--- Comment #18 from Eric Sandeen <sandeen@redhat.com>  2010-03-27 19:16:09 ---
Reproducer works perfectly, thanks.

So here's the issue; sbi->flex_groups[] doesn't get filled out in
ext4_fill_flex_info() because:

        if (groups_per_flex < 2) {
                sbi->s_log_groups_per_flex = 0;
                return 1;
        }

but resize is unconditionally doing this in ext4_group_add as long as the
FLEX_BG feature is set:

                atomic_add(input->free_blocks_count,
                           &sbi->s_flex_groups[flex_group].free_blocks);

so for a NULL s_flex groups it went boom.

Every other access to ->s_flex_groups checks s_log_groups_per_flex first, so
this should be the proper fix:

Index: linux-2.6/fs/ext4/resize.c
===================================================================
--- linux-2.6.orig/fs/ext4/resize.c
+++ linux-2.6/fs/ext4/resize.c
@@ -930,7 +930,8 @@ int ext4_group_add(struct super_block *s
     percpu_counter_add(&sbi->s_freeinodes_counter,
                EXT4_INODES_PER_GROUP(sb));

-    if (EXT4_HAS_INCOMPAT_FEATURE(sb, EXT4_FEATURE_INCOMPAT_FLEX_BG)) {
+    if (EXT4_HAS_INCOMPAT_FEATURE(sb, EXT4_FEATURE_INCOMPAT_FLEX_BG) &&
+        sbi->s_log_groups_per_flex) {
         ext4_group_t flex_group;
         flex_group = ext4_flex_group(sbi, input->group);
         atomic_add(input->free_blocks_count,

This fixes the reproducer, need to double check it on Alessandro's image.

-Eric

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
