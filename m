From: Dmitry Monakhov <dmonakhov@openvz.org>
Subject: [PATCH 5/5] ext4: invalidate exntent-status-tree during extent_migration
Date: Mon, 25 Feb 2013 20:07:43 +0400
Message-ID: <1361808463-25471-5-git-send-email-dmonakhov@openvz.org>
References: <1361808463-25471-1-git-send-email-dmonakhov@openvz.org>
Cc: tytso@mit.edu, jack@suse.cz, wenqing.lz@taobao.com,
	Dmitry Monakhov <dmonakhov@openvz.org>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mailhub.sw.ru ([195.214.232.25]:23620 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759948Ab3BYQIz (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 25 Feb 2013 11:08:55 -0500
In-Reply-To: <1361808463-25471-1-git-send-email-dmonakhov@openvz.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

mext_replace_branches() will change inode's extents layout so
we have to drop corresponding cache.

TESTCASE:  301'th xfstest was not yet accepted to official xfstest's branch
and can be found here: https://github.com/dmonakhov/xfstests/commit/7b7efeee30a41109201e2040034e71db9b66ddc0

Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
---
 fs/ext4/move_extent.c |    8 ++++++++
 1 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/fs/ext4/move_extent.c b/fs/ext4/move_extent.c
index d78c33e..c1f15b2 100644
--- a/fs/ext4/move_extent.c
+++ b/fs/ext4/move_extent.c
@@ -666,6 +666,14 @@ mext_replace_branches(handle_t *handle, struct inode *orig_inode,
 	int replaced_count = 0;
 	int dext_alen;
 
+	*err = ext4_es_remove_extent(orig_inode, from, count);
+	if (*err)
+		goto out;
+
+	*err = ext4_es_remove_extent(donor_inode, from, count);
+	if (*err)
+		goto out;
+
 	/* Get the original extent for the block "orig_off" */
 	*err = get_ext_path(orig_inode, orig_off, &orig_path);
 	if (*err)
-- 
1.7.1

