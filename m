From: Eryu Guan <guaneryu@gmail.com>
Subject: [PATCH] ext4: don't remove reserved inodes in ext4_unlink()
Date: Sat, 25 Jan 2014 14:58:17 +0800
Message-ID: <1390633097-16194-1-git-send-email-guaneryu@gmail.com>
Cc: Eryu Guan <guaneryu@gmail.com>, "Theodore Ts'o" <tytso@mit.edu>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pb0-f45.google.com ([209.85.160.45]:65530 "EHLO
	mail-pb0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750889AbaAYHBR (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 25 Jan 2014 02:01:17 -0500
Received: by mail-pb0-f45.google.com with SMTP id un15so4059781pbc.32
        for <linux-ext4@vger.kernel.org>; Fri, 24 Jan 2014 23:01:16 -0800 (PST)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Corrupted ext4_dir_entry_2 struct on disk may have wrong inode number,
when the inode number is 8 (EXT4_JOURNAL_INO) and the file is deleted,
the journal inode is gone, and unmounting such a fs could trigger the
following BUG_ON() in start_this_handle().

	BUG_ON(journal->j_flags & JBD2_UNMOUNT);

	------------[ cut here ]------------
	kernel BUG at fs/jbd2/transaction.c:307!
	...
	CPU: 1 PID: 1535 Comm: umount Not tainted 3.13.0+ #14
	...
	Call Trace:
	 [<ffffffff8119f17a>] ? kmem_cache_alloc+0x1ca/0x1f0
	 [<ffffffff812850f0>] ? jbd2__journal_start+0x90/0x1e0
	 [<ffffffff81285153>] jbd2__journal_start+0xf3/0x1e0
	 [<ffffffff81242a62>] ? ext4_evict_inode+0x1b2/0x4f0
	 [<ffffffff8126d039>] __ext4_journal_start_sb+0x69/0xe0
	 [<ffffffff81242a62>] ext4_evict_inode+0x1b2/0x4f0
	 [<ffffffff811d3b8e>] evict+0x9e/0x190
	 [<ffffffff811d4373>] iput+0xf3/0x180
	 [<ffffffff8128f301>] jbd2_journal_destroy+0x191/0x220
	 [<ffffffff810b0ae0>] ? abort_exclusive_wait+0xb0/0xb0
	 [<ffffffff8125d004>] ext4_put_super+0x64/0x340
	 [<ffffffff811bbae2>] generic_shutdown_super+0x72/0xf0
	 [<ffffffff811bbd77>] kill_block_super+0x27/0x70
	 [<ffffffff811bc05d>] deactivate_locked_super+0x3d/0x60
	 [<ffffffff811bc606>] deactivate_super+0x46/0x60
	 [<ffffffff811d7f47>] mntput_no_expire+0xa7/0x140
	 [<ffffffff811d939e>] SyS_umount+0x8e/0x100
	 [<ffffffff81690c29>] system_call_fastpath+0x16/0x1b

Check inode number in ext4_unlink() and return error if the inode number
is reserved or nonexistent.

Tested by removing a reserved inode and unmounting the fs. Inodes 1-10
have been tested. Also tested by xfstests.

Cc: "Theodore Ts'o" <tytso@mit.edu>
Signed-off-by: Eryu Guan <guaneryu@gmail.com>
---

If this was the right way to go, I'll send another patch for ext3 too.

 fs/ext4/namei.c | 13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

diff --git a/fs/ext4/namei.c b/fs/ext4/namei.c
index 5a0408d..797ce98 100644
--- a/fs/ext4/namei.c
+++ b/fs/ext4/namei.c
@@ -2761,9 +2761,11 @@ end_rmdir:
 static int ext4_unlink(struct inode *dir, struct dentry *dentry)
 {
 	int retval;
+	unsigned long ino;
 	struct inode *inode;
 	struct buffer_head *bh;
 	struct ext4_dir_entry_2 *de;
+	struct super_block *sb;
 	handle_t *handle = NULL;
 
 	trace_ext4_unlink_enter(dir, dentry);
@@ -2778,13 +2780,20 @@ static int ext4_unlink(struct inode *dir, struct dentry *dentry)
 		goto end_unlink;
 
 	inode = dentry->d_inode;
+	ino = inode->i_ino;
+	sb = dir->i_sb;
 
 	retval = -EIO;
-	if (le32_to_cpu(de->inode) != inode->i_ino)
+	if (le32_to_cpu(de->inode) != ino)
 		goto end_unlink;
+	if (ino < EXT4_FIRST_INO(sb) ||
+	    ino > le32_to_cpu(EXT4_SB(sb)->s_es->s_inodes_count)) {
+		ext4_error(sb, "reserved or nonexistent inode %lu", ino);
+		goto end_unlink;
+	}
 
 	handle = ext4_journal_start(dir, EXT4_HT_DIR,
-				    EXT4_DATA_TRANS_BLOCKS(dir->i_sb));
+				    EXT4_DATA_TRANS_BLOCKS(sb));
 	if (IS_ERR(handle)) {
 		retval = PTR_ERR(handle);
 		handle = NULL;
-- 
1.8.5.3

