From: Team Athena <teamathena.nitc@gmail.com>
Subject: [PATCH] ext4: Log inode exhaustion to dmesg
Date: Mon, 23 Oct 2017 17:32:47 +0530
Message-ID: <20171023120247.lsupeazdwwpaisek@gaztest-VM>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: tytso@mit.edu, adilger.kernel@dilger.ca,
        linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Make a log in dmesg when file creation fails due to no free inodes.
The error code for both "out of disk space" and "out of inode" is the same.
This is misleading to the user. Logging the exact reason helps to find and
correct the issue from the users' side.

Fix bug 197335 - https://bugzilla.kernel.org/show_bug.cgi?id=197335

Signed-off-by: Team Athena <teamathena.nitc@gmail.com>
---
 fs/ext4/namei.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/ext4/namei.c b/fs/ext4/namei.c
index c1cf020d..c3990d2d 100644
--- a/fs/ext4/namei.c
+++ b/fs/ext4/namei.c
@@ -2463,6 +2463,8 @@ static int ext4_create(struct inode *dir, struct dentry *dentry, umode_t mode,
 		ext4_journal_stop(handle);
 	if (err == -ENOSPC && ext4_should_retry_alloc(dir->i_sb, &retries))
 		goto retry;
+	else if (err == -ENOSPC && printk_ratelimited())
+		printk(pr_warning "ext4: No space on disk, inode usage full");
 	return err;
 }
 
-- 
2.11.0
