From: Gazala Muhamed <teamathena.nitc@gmail.com>
Subject: [PATCH v3] ext4: Make a log in dmesg when file creation fails due to
 no free inodes
Date: Tue, 31 Oct 2017 20:50:45 +0530
Message-ID: <20171031152045.vywymqu3i7ppsk4d@gaztest-VM>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: tytso@mit.edu, adilger.kernel@dilger.ca,
        linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
        teamathena.nitc@gmail.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-yw0-f196.google.com ([209.85.161.196]:50879 "EHLO
        mail-yw0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753721AbdJaPUw (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Tue, 31 Oct 2017 11:20:52 -0400
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

The error code for both "out of disk space" and "out of inodes" is the same
This is misleading to the user. Logging the exact reason helps to find
and debug the issue from the user's side.

Fix bug 197335 - https://bugzilla.kernel.org/show_bug.cgi?id=197335

---
Changes in v33
- Use ext4_warning instead of a bare printk
- Signed-off with real name
- Edit commit message

Signed-off-by: Gazala Muhamed <teamathena.nitc@gmail.com>
---
 fs/ext4/namei.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/ext4/namei.c b/fs/ext4/namei.c
index c1cf020d..4b18badd 100644
--- a/fs/ext4/namei.c
+++ b/fs/ext4/namei.c
@@ -2463,6 +2463,8 @@ static int ext4_create(struct inode *dir, struct dentry *dentry, umode_t mode,
 		ext4_journal_stop(handle);
 	if (err == -ENOSPC && ext4_should_retry_alloc(dir->i_sb, &retries))
 		goto retry;
+	else if (err == -ENOSPC)
+		ext4_warning(dir->i_sb, "No space on disk, out of inodes");
 	return err;
 }
 
-- 
2.11.0
