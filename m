From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [Bug 25832] kernel crashes when a mounted ext3/4 file system
 is physically removed
Date: Fri, 9 Sep 2011 15:13:54 -0400
Message-ID: <20110909191354.GC3818@thunk.org>
References: <bug-25832-13602@https.bugzilla.kernel.org/>
 <201109051744.p85HiVYe013595@demeter1.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, rockorequin@hotmail.com,
	stern@rowland.harvard.edu
To: bugzilla-daemon@bugzilla.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:46869 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759505Ab1IITN4 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 9 Sep 2011 15:13:56 -0400
Content-Disposition: inline
In-Reply-To: <201109051744.p85HiVYe013595@demeter1.kernel.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Bugzilla.kernel.org is down, so apologies to people who have
subscribed to this bug but which I didn't cc explicitly...

Rocko, Alan, could you try this patch and see what happens.  It may be
that we'll crash somewhere else; the problem is that Linux that the
low-level generic hd routines doesn't have a formal way of informing
the VFS and layers below that the disk has disappeared.  It just yanks
it out from under the file system, and we've been manually patching
around kernel crashes....

     	   	 	   	       	    - Ted

commit 6e478d46e58181ec4814f25a2fd91c6323e16ad4
Author: Theodore Ts'o <tytso@mit.edu>
Date:   Fri Sep 9 15:02:54 2011 -0400

    ext4: add ext4-specific kludge to avoid an oops after the disk disappears
    
    The del_gendisk() function uninitializes the disk-specific data
    structures, including the bdi structure, without telling anyone
    else.  Once this happens, any attempt to call mark_buffer_dirty()
    (for example, by ext4_commit_super), will cause a kernel OOPS.
    
    Fix this for now until we can fix things in an architecturally correct
    way.
    
    Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>

diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index ee2f74a..48cb615 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -414,6 +414,22 @@ static void save_error_info(struct super_block *sb, const char *func,
 	ext4_commit_super(sb, 1);
 }
 
+/*
+ * The del_gendisk() function deactivates the inode and deactivates
+ * the bdi without telling the file system.  Once this happens, any
+ * attempt to call mark_buffer_dirty() (for example, by
+ * ext4_commit_super), will cause a kernel OOPS.  This is a kludge to
+ * prevent these oops until we can put in a proper hook in
+ * del_gendisk() to inform the VFS and file system layers.
+ */
+static int block_device_ejected(struct super_block *sb)
+{
+	struct inode *bd_inode = sb->s_bdev->bd_inode;
+	struct backing_dev_info *bdi = bd_inode->i_mapping->backing_dev_info;
+
+	return bdi->dev == NULL;
+}
+
 
 /* Deal with the reporting of failure conditions on a filesystem such as
  * inconsistencies detected or read IO failures.
@@ -4072,7 +4088,7 @@ static int ext4_commit_super(struct super_block *sb, int sync)
 	struct buffer_head *sbh = EXT4_SB(sb)->s_sbh;
 	int error = 0;
 
-	if (!sbh)
+	if (!sbh || block_device_ejected(sb))
 		return error;
 	if (buffer_write_io_error(sbh)) {
 		/*
