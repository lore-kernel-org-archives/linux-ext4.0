From: Lukas Czerner <lczerner@redhat.com>
Subject: [PATCH 2/4 v2] ext4: Fix trimmed block count computing
Date: Fri,  2 Mar 2012 13:11:56 +0100
Message-ID: <1330690318-22627-2-git-send-email-lczerner@redhat.com>
References: <1330690318-22627-1-git-send-email-lczerner@redhat.com>
Cc: tytso@mit.edu, Lukas Czerner <lczerner@redhat.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:56678 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751496Ab2CBMMI (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 2 Mar 2012 07:12:08 -0500
In-Reply-To: <1330690318-22627-1-git-send-email-lczerner@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Currently when there is not enough free block in the block group to
discard (grp->bb_free < minlen) the 'trimmed' is bumped up anyway with
the number of discarded blocks from the previous iteration. Fix this
by bumping up 'trimmed' only if the ext4_trim_all_free() was actually
run.

Signed-off-by: Lukas Czerner <lczerner@redhat.com>
---
v2: nothing changed

 fs/ext4/mballoc.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
index 16a3aeb..f20688e 100644
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

