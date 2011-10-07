From: Allison Henderson <achender@linux.vnet.ibm.com>
Subject: [Ext4 Secure Delete 6/7v4] ext4: Secure Delete: Secure delete meta data blocks
Date: Fri,  7 Oct 2011 00:11:04 -0700
Message-ID: <1317971465-8517-7-git-send-email-achender@linux.vnet.ibm.com>
References: <1317971465-8517-1-git-send-email-achender@linux.vnet.ibm.com>
Cc: Allison Henderson <achender@linux.vnet.ibm.com>
To: linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <1317971465-8517-1-git-send-email-achender@linux.vnet.ibm.com>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

This patch modifies ext4_free_blocks to securely delete meta blocks
when needed

Signed-off-by: Allison Henderson <achender@linux.vnet.ibm.com>
---
:100644 100644 17a5a57... d25bb4d... M	fs/ext4/mballoc.c
 fs/ext4/mballoc.c |    8 ++++++++
 1 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
index 17a5a57..d25bb4d 100644
--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -4607,6 +4607,14 @@ do_more:
 	if (err)
 		goto error_return;
 
+	if ((flags & EXT4_FREE_BLOCKS_METADATA) &&
+		EXT4_I(inode)->i_flags & EXT4_SECRM_FL) {
+
+		err = ext4_secure_delete_pblks(inode, block, count);
+		if (err)
+			goto error_return;
+	}
+
 	if ((flags & EXT4_FREE_BLOCKS_METADATA) && ext4_handle_valid(handle)) {
 		struct ext4_free_data *new_entry;
 		/*
-- 
1.7.1

