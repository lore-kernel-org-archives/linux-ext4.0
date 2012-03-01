From: Lukas Czerner <lczerner@redhat.com>
Subject: [PATCH 2/5] ext4: Fix trimmed block count computing
Date: Thu,  1 Mar 2012 11:16:42 +0100
Message-ID: <1330597005-751-2-git-send-email-lczerner@redhat.com>
References: <1330597005-751-1-git-send-email-lczerner@redhat.com>
Cc: tytso@mit.edu, Lukas Czerner <lczerner@redhat.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:14468 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965335Ab2CAKQ4 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 1 Mar 2012 05:16:56 -0500
In-Reply-To: <1330597005-751-1-git-send-email-lczerner@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Currently then if there is not enough free block in the block group to
discard (grp->bb_free >= minlen) the 'trimmed' is bumped up anyway with
the number of discarded blocks from the previous block group. Fix this
by bumping up 'trimmed' only if the ext4_trim_all_free() was actually
run.

Signed-off-by: Lukas Czerner <lczerner@redhat.com>
---
 fs/ext4/mballoc.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
index 5798cf3..e907cf9 100644
--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -5083,8 +5083,8 @@ int ext4_trim_fs(struct super_block *sb, struct fstrim_range *range)
 				ret = cnt;
 				break;
 			}
+			trimmed += cnt;
 		}
-		trimmed += cnt;
 
 		/*
 		 * For every group except the first one, we are sure
-- 
1.7.4.4

