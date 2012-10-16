From: Adil Mujeeb <mujeeb.adil@gmail.com>
Subject: [PATCH 06/10] ext4: ialloc: Fixed coding style issue
Date: Wed, 17 Oct 2012 00:43:01 +0530
Message-ID: <1350414785-7848-6-git-send-email-mujeeb.adil@gmail.com>
References: <1350414785-7848-1-git-send-email-mujeeb.adil@gmail.com>
Cc: Adil Mujeeb <mujeeb.adil@gmail.com>
To: tytso@mit.edu, adilger.kernel@dilger.ca,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1350414785-7848-1-git-send-email-mujeeb.adil@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Fixed one of checkpatch.pl reported issue

Signed-off-by: Adil Mujeeb <mujeeb.adil@gmail.com>
---
 linux-3.7-rc1/fs/ext4/ialloc.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/linux-3.7-rc1/fs/ext4/ialloc.c b/linux-3.7-rc1/fs/ext4/ialloc.c
index fa36372..2e63f4a 100644
--- a/linux-3.7-rc1/fs/ext4/ialloc.c
+++ b/linux-3.7-rc1/fs/ext4/ialloc.c
@@ -1086,7 +1086,7 @@ unsigned long ext4_count_free_inodes(struct super_block *sb)
 }
 
 /* Called at mount-time, super-block is locked */
-unsigned long ext4_count_dirs(struct super_block * sb)
+unsigned long ext4_count_dirs(struct super_block *sb)
 {
 	unsigned long count = 0;
 	ext4_group_t i, ngroups = ext4_get_groups_count(sb);
-- 
1.7.7.3
