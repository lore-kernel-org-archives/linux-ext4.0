From: "Duane Griffin" <duaneg@dghda.com>
Subject: [PATCH 3/3] jbd2: only create debugfs and stats entries if cache initialisation is successful
Date: Fri,  7 Mar 2008 01:31:24 +0000
Message-ID: <dcb02b202f5a84c79c9e8b1b0102e6ad52ed3b53.1204844851.git.duaneg__22530.7393623099$1204853624$gmane$org@dghda.com>
References: <1204853484-25968-1-git-send-email-duaneg@dghda.com>
 <1204853484-25968-2-git-send-email-duaneg@dghda.com>
Cc: linux-kernel@vger.kernel.org, Theodore Tso <tytso@mit.edu>,
	sct@redhat.com, akpm@linux-foundation.org, adilger@clusterfs.com,
	Duane Griffin <duaneg@dghda.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1765903AbYCGBcp@vger.kernel.org>
In-Reply-To: <1204853484-25968-2-git-send-email-duaneg@dghda.com>
Message-Id: <dcb02b202f5a84c79c9e8b1b0102e6ad52ed3b53.1204844851.git.duaneg@dghda.com>
In-Reply-To: <5e28cd633c71f6354a203a43000cbe5fef045589.1204844851.git.duaneg@dghda.com>
References: <5e28cd633c71f6354a203a43000cbe5fef045589.1204844851.git.duaneg@dghda.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

jbd2 debugfs and stats entries should only be created if cache initialisation
is successful. At the moment they are being created unconditionally which will
leave them dangling if cache (and hence module) initialisation fails.

Signed-off-by: Duane Griffin <duaneg@dghda.com>
---
 fs/jbd2/journal.c |    8 +++++---
 1 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/fs/jbd2/journal.c b/fs/jbd2/journal.c
index 0d8a595..9d48419 100644
--- a/fs/jbd2/journal.c
+++ b/fs/jbd2/journal.c
@@ -2315,10 +2315,12 @@ static int __init journal_init(void)
 	BUILD_BUG_ON(sizeof(struct journal_superblock_s) != 1024);
 
 	ret = journal_init_caches();
-	if (ret != 0)
+	if (ret == 0) {
+		jbd2_create_debugfs_entry();
+		jbd2_create_jbd_stats_proc_entry();
+	} else {
 		jbd2_journal_destroy_caches();
-	jbd2_create_debugfs_entry();
-	jbd2_create_jbd_stats_proc_entry();
+	}
 	return ret;
 }
 
-- 
1.5.3.7
