From: "Duane Griffin" <duaneg@dghda.com>
Subject: [RFC, PATCH 3/6] jbd: only create debugfs entries if cache initialisation is successful
Date: Thu,  6 Mar 2008 01:59:11 +0000
Message-ID: <bd11bfe0ae59094e7a3fbd813dfd877f989f122f.1204685366.git.duaneg__25261.1204669394$1204769365$gmane$org@dghda.com>
References: <1204768754-29655-1-git-send-email-duaneg@dghda.com>
 <1204768754-29655-2-git-send-email-duaneg@dghda.com>
 <1204768754-29655-3-git-send-email-duaneg@dghda.com>
Cc: linux-kernel@vger.kernel.org, Theodore Tso <tytso@mit.edu>,
	sct@redhat.com, akpm@linux-foundation.org, adilger@clusterfs.com,
	Duane Griffin <duaneg@dghda.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S933427AbYCFCI1@vger.kernel.org>
In-Reply-To: <1204768754-29655-3-git-send-email-duaneg@dghda.com>
Message-Id: <bd11bfe0ae59094e7a3fbd813dfd877f989f122f.1204685366.git.duaneg@dghda.com>
In-Reply-To: <a047dfbd7855d5f484ae8a3434f6a073302505be.1204685366.git.duaneg@dghda.com>
References: <a047dfbd7855d5f484ae8a3434f6a073302505be.1204685366.git.duaneg@dghda.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

JBD debugfs entries should only be created if cache initialisation is
successful. At the moment they are being created unconditionally which will
leave them dangling if cache (and hence module) initialisation fails.

Signed-off-by: Duane Griffin <duaneg@dghda.com>
---

This patch is an independent bug fix and following patches in this series do
not depend on it.

 fs/jbd/journal.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/fs/jbd/journal.c b/fs/jbd/journal.c
index 3f334a3..a868277 100644
--- a/fs/jbd/journal.c
+++ b/fs/jbd/journal.c
@@ -1942,9 +1942,10 @@ static int __init journal_init(void)
 	BUILD_BUG_ON(sizeof(struct journal_superblock_s) != 1024);
 
 	ret = journal_init_caches();
-	if (ret != 0)
+	if (ret == 0)
+		jbd_create_debugfs_entry();
+	else
 		journal_destroy_caches();
-	jbd_create_debugfs_entry();
 	return ret;
 }
 
-- 
1.5.3.7
