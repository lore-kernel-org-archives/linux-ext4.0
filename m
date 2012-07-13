From: Lukas Czerner <lczerner@redhat.com>
Subject: [PATCH 12/12 v2] ext4: Allow punch hole with bigalloc enabled
Date: Fri, 13 Jul 2012 15:19:15 +0200
Message-ID: <1342185555-21146-12-git-send-email-lczerner@redhat.com>
References: <1342185555-21146-1-git-send-email-lczerner@redhat.com>
Cc: linux-fsdevel@vger.kernel.org, tytso@mit.edu,
	achender@linux.vnet.ibm.com, Lukas Czerner <lczerner@redhat.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <1342185555-21146-1-git-send-email-lczerner@redhat.com>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

In commits 5f95d21fb6f2aaa52830e5b7fb405f6c71d3ab85 and
30bc2ec9598a1b156ad75217f2e7d4560efdeeab we've reworked punch_hole
implementation and there is noting holding us back from using punch hole
on file system with bigalloc feature enabled.

This has been tested with fsx and xfstests.

Signed-off-by: Lukas Czerner <lczerner@redhat.com>
---
 fs/ext4/inode.c |    5 -----
 1 files changed, 0 insertions(+), 5 deletions(-)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 9e3b279..eb3565d 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -3356,11 +3356,6 @@ int ext4_punch_hole(struct file *file, loff_t offset, loff_t length)
 		return -EOPNOTSUPP;
 	}
 
-	if (EXT4_SB(inode->i_sb)->s_cluster_ratio > 1) {
-		/* TODO: Add support for bigalloc file systems */
-		return -EOPNOTSUPP;
-	}
-
 	return ext4_ext_punch_hole(file, offset, length);
 }
 
-- 
1.7.7.6

