From: Jan Kara <jack@suse.cz>
Subject: [PATCH] Fix bug in ext2fs_unlink
Date: Tue, 27 Nov 2007 18:03:06 +0100
Message-ID: <20071127170306.GB4617@duck.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from styx.suse.cz ([82.119.242.94]:47671 "EHLO duck.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756834AbXK0RDI (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 27 Nov 2007 12:03:08 -0500
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

  Hi,

  the patch below fixes a bug in ext2fs_unlink() I came across when testing
my changes to e2fsprogs for 64KB blocksize support... Please apply.

									Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR

----
Subject: Fix a bug in deletion of first directory entry in a second (or further) directory block

We cannot merge a removed directory entry to just arbitrary previous directory
entry. The previous entry must be in the same block. We check whether the current
entry is not the first one in the block and only if it isn't merge it to the
previous entry. 

Signed-off-by: Jan Kara <jack@suse.cz>

diff --git a/lib/ext2fs/unlink.c b/lib/ext2fs/unlink.c
index eb6527e..d459bbd 100644
--- a/lib/ext2fs/unlink.c
+++ b/lib/ext2fs/unlink.c
@@ -31,7 +31,7 @@ struct link_struct  {
  #pragma argsused
 #endif
 static int unlink_proc(struct ext2_dir_entry *dirent,
-		     int	offset EXT2FS_ATTR((unused)),
+		     int	offset,
 		     int	blocksize EXT2FS_ATTR((unused)),
 		     char	*buf EXT2FS_ATTR((unused)),
 		     void	*priv_data)
@@ -56,7 +56,7 @@ static int unlink_proc(struct ext2_dir_e
 			return 0;
 	}
 
-	if (prev)
+	if (offset)
 		/* We actually would not need to convert initial values as
 		 * they are certainly less than 64K but let's not try to be
 		 * too clever */
