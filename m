From: Lukas Czerner <lczerner@redhat.com>
Subject: [PATCH 5/8] mm: pass LLONG_MAX to truncate_inode_pages_range
Date: Fri, 29 Jun 2012 12:56:07 +0200
Message-ID: <1340967370-13728-5-git-send-email-lczerner@redhat.com>
References: <1340967370-13728-1-git-send-email-lczerner@redhat.com>
Cc: linux-fsdevel@vger.kernel.org, tytso@mit.edu,
	achender@linux.vnet.ibm.com, Lukas Czerner <lczerner@redhat.com>,
	Hugh Dickins <hughd@google.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <1340967370-13728-1-git-send-email-lczerner@redhat.com>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Currently we're passing -1 to truncate_inode_pages_range() which is
actually really confusing since the argument is signed so we do not get
"huge" number as one would expect, but rather just -1. To make things
clearer and easier for truncate_inode_pages_range() just pass LLONG_MAX
since it is actually what was intended anyway.

It also makes thing easier for allowing truncate_inode_pages_range() to
handle non page aligned regions. Moreover letting the lend argument to
be negative might actually hide some bugs.

Signed-off-by: Lukas Czerner <lczerner@redhat.com>
Cc: Hugh Dickins <hughd@google.com>
---
 mm/truncate.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/mm/truncate.c b/mm/truncate.c
index 75801ac..77a693e 100644
--- a/mm/truncate.c
+++ b/mm/truncate.c
@@ -310,7 +310,7 @@ EXPORT_SYMBOL(truncate_inode_pages_range);
  */
 void truncate_inode_pages(struct address_space *mapping, loff_t lstart)
 {
-	truncate_inode_pages_range(mapping, lstart, (loff_t)-1);
+	truncate_inode_pages_range(mapping, lstart, (loff_t)LLONG_MAX);
 }
 EXPORT_SYMBOL(truncate_inode_pages);
 
-- 
1.7.7.6

