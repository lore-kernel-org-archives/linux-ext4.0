From: Carlos Maiolino <cmaiolino@redhat.com>
Subject: [PATCH v2] ext4: fix possible non-initialized variable
Date: Mon, 10 Sep 2012 18:55:48 -0300
Message-ID: <1347314148-17463-1-git-send-email-cmaiolino@redhat.com>
Cc: Carlos Maiolino <cmaiolino@redhat.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:12818 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751910Ab2IJVzy (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 10 Sep 2012 17:55:54 -0400
Received: from int-mx09.intmail.prod.int.phx2.redhat.com (int-mx09.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id q8ALtsF7027850
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-ext4@vger.kernel.org>; Mon, 10 Sep 2012 17:55:54 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

htree_dirblock_to_tree() declares a non-initialized 'err' variable, which is
passed as a reference to another functions expecting them to set this variable
with thei error codes.
It's passed to ext4_bread(), which then passes it to ext4_getblk(). If
ext4_map_blocks() returns 0 due to a lookup failure, leaving the ext4_getblk()
buffer_head uninitialized, it will make ext4_getblk() return to ext4_bread()
without initialize the 'err' variable, and ext4_bread() will return to
htree_dirblock_to_tree() with this variable still uninitialized.
htree_dirblock_to_tree() will pass this variable with garbage back to
ext4_htree_fill_tree(), which expects a number of directory entries added to the
rb-tree. which, in case, might return a fake non-zero value due the garbage left
in the 'err' variable, leading the kernel to an Oops in ext4_dx_readdir(), once
this is expecting a filled rb-tree node, when in turn it will have a NULL-ed
one, causing an invalid page request when trying to get a fname struct from
this NULL-ed rb-tree node in this line:

fname = rb_entry(info->curr_node, struct fname, rb_hash);

The patch itself initializes the err variable in htree_dirblock_to_tree() to
avoid usage mistakes by the called functions, and also fix ext4_getblk() to
return a initialized 'err' variable when ext4_map_blocks() fails a
lookup.

Signed-off-by: Carlos Maiolino <cmaiolino@redhat.com>
---
 fs/ext4/inode.c | 4 +++-
 fs/ext4/namei.c | 2 +-
 2 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index dff171c..41079f4 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -732,11 +732,13 @@ struct buffer_head *ext4_getblk(handle_t *handle, struct inode *inode,
 	err = ext4_map_blocks(handle, inode, &map,
 			      create ? EXT4_GET_BLOCKS_CREATE : 0);
 
+	/* ensure we send some value back into *errp */
+	*errp = 0;
+
 	if (err < 0)
 		*errp = err;
 	if (err <= 0)
 		return NULL;
-	*errp = 0;
 
 	bh = sb_getblk(inode->i_sb, map.m_pblk);
 	if (!bh) {
diff --git a/fs/ext4/namei.c b/fs/ext4/namei.c
index 2a42cc0..262f863 100644
--- a/fs/ext4/namei.c
+++ b/fs/ext4/namei.c
@@ -839,7 +839,7 @@ static int htree_dirblock_to_tree(struct file *dir_file,
 {
 	struct buffer_head *bh;
 	struct ext4_dir_entry_2 *de, *top;
-	int err, count = 0;
+	int err = 0, count = 0;
 
 	dxtrace(printk(KERN_INFO "In htree dirblock_to_tree: block %lu\n",
 							(unsigned long)block));
-- 
1.7.11.4

