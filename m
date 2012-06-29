From: Lukas Czerner <lczerner@redhat.com>
Subject: [PATCH 3/8] shmem: pass LLONG_MAX to shmem_truncate_range
Date: Fri, 29 Jun 2012 12:56:05 +0200
Message-ID: <1340967370-13728-3-git-send-email-lczerner@redhat.com>
References: <1340967370-13728-1-git-send-email-lczerner@redhat.com>
Cc: linux-fsdevel@vger.kernel.org, tytso@mit.edu,
	achender@linux.vnet.ibm.com, Lukas Czerner <lczerner@redhat.com>,
	Hugh Dickins <hughd@google.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:15142 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754147Ab2F2K40 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 29 Jun 2012 06:56:26 -0400
In-Reply-To: <1340967370-13728-1-git-send-email-lczerner@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Currently we're passing -1 to shmem_truncate_range which can then call
truncate_inode_pages_range() which is actually really confusing since the
argument is signed so we do not get "huge" number as one would expect,
but rather just -1. To make things clearer and easier for
truncate_inode_pages_range() just pass LLONG_MAX since it is actually what
was intended anyway.

It also makes thing easier for allowing truncate_inode_pages_range() to
handle non page aligned regions. Moreover letting the lend argument to
be negative might actually hide some bugs.

Signed-off-by: Lukas Czerner <lczerner@redhat.com>
Cc: Hugh Dickins <hughd@google.com>
---
 mm/shmem.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/mm/shmem.c b/mm/shmem.c
index a15a466..470ee75 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -2960,7 +2960,8 @@ void shmem_unlock_mapping(struct address_space *mapping)
 
 void shmem_truncate_range(struct inode *inode, loff_t lstart, loff_t lend)
 {
-	truncate_inode_pages_range(inode->i_mapping, lstart, lend);
+	truncate_inode_pages_range(inode->i_mapping, lstart,
+				   lend == -1 ? LLONG_MAX : last);
 }
 EXPORT_SYMBOL_GPL(shmem_truncate_range);
 
-- 
1.7.7.6

