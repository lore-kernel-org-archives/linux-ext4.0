From: Pieter Smith <pieter@boesman.nl>
Subject: [PATCH 18/56] fs/ext2: support compiling out splice
Date: Thu, 13 Nov 2014 22:22:55 +0100
Message-ID: <1415913813-362-19-git-send-email-pieter@boesman.nl>
References: <pieter@boesman.nl>
 <1415913813-362-1-git-send-email-pieter@boesman.nl>
Cc: Josh Triplett <josh@joshtriplett.org>, Jan Kara <jack@suse.cz>,
	linux-ext4@vger.kernel.org (open list:EXT2 FILE SYSTEM),
	linux-kernel@vger.kernel.org (open list)
To: pieter@boesman.nl
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1415913813-362-1-git-send-email-pieter@boesman.nl>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Compile out splice support from ext2 when the splice-family of syscalls is not
supported by the system (i.e. CONFIG_SYSCALL_SPLICE is undefined).

Signed-off-by: Pieter Smith <pieter@boesman.nl>
---
 fs/ext2/file.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/ext2/file.c b/fs/ext2/file.c
index 7c87b22..8a40d04 100644
--- a/fs/ext2/file.c
+++ b/fs/ext2/file.c
@@ -74,8 +74,8 @@ const struct file_operations ext2_file_operations = {
 	.open		= dquot_file_open,
 	.release	= ext2_release_file,
 	.fsync		= ext2_fsync,
-	.splice_read	= generic_file_splice_read,
-	.splice_write	= iter_file_splice_write,
+	SPLICE_READ_INIT(generic_file_splice_read)
+	SPLICE_WRITE_INIT(iter_file_splice_write)
 };
 
 #ifdef CONFIG_EXT2_FS_XIP
-- 
1.9.1
