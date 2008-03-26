From: Jan Kara <jack@suse.cz>
Subject: [PATCH] ext4: Fix update of mtime and ctime on rename
Date: Wed, 26 Mar 2008 11:55:26 +0100
Message-ID: <20080326105526.GE7835@duck.suse.cz>
References: <20080326104614.GD7835@duck.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
	Al Viro <viro@ZenIV.linux.org.uk>
To: Andrew Morton <akpm@linux-foundation.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from styx.suse.cz ([82.119.242.94]:43170 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753706AbYCZKz1 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 26 Mar 2008 06:55:27 -0400
Content-Disposition: inline
In-Reply-To: <20080326104614.GD7835@duck.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

The patch below makes ext4 update mtime and ctime of the directory
into which we move file even if the directory entry already exists.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/ext4/namei.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/fs/ext4/namei.c b/fs/ext4/namei.c
index 28aa2ed..d04bc73 100644
--- a/fs/ext4/namei.c
+++ b/fs/ext4/namei.c
@@ -2347,6 +2347,9 @@ static int ext4_rename (struct inode * old_dir, struct dentry *old_dentry,
 					      EXT4_FEATURE_INCOMPAT_FILETYPE))
 			new_de->file_type = old_de->file_type;
 		new_dir->i_version++;
+		new_dir->i_ctime = new_dir->i_mtime =
+					ext4_current_time(new_dir);
+		ext4_mark_inode_dirty(handle, new_dir);
 		BUFFER_TRACE(new_bh, "call ext4_journal_dirty_metadata");
 		ext4_journal_dirty_metadata(handle, new_bh);
 		brelse(new_bh);
-- 
1.5.2.4

