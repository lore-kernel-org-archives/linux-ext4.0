From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH] ext4: fix reservation overflow in ext4_da_write_begin
Date: Thu, 02 Oct 2014 10:28:42 -0500
Message-ID: <542D6F2A.70006@redhat.com>
References: <542C7331.4070200@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
To: ext4 development <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:16981 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752502AbaJBP2k (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 2 Oct 2014 11:28:40 -0400
Received: from int-mx10.intmail.prod.int.phx2.redhat.com (int-mx10.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id s92FSeDU024988
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
	for <linux-ext4@vger.kernel.org>; Thu, 2 Oct 2014 11:28:40 -0400
Received: from liberator.sandeen.net (ovpn01.gateway.prod.ext.phx2.redhat.com [10.5.9.1])
	by int-mx10.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP id s92FSdSe011609
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES128-SHA bits=128 verify=NO)
	for <linux-ext4@vger.kernel.org>; Thu, 2 Oct 2014 11:28:40 -0400
In-Reply-To: <542C7331.4070200@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Delalloc write journal reservations only reserve 1 credit,
to update the inode if necessary.  However, it may happen
once in a filesystem's lifetime that a file will cross
the 2G threshold, and require the LARGE_FILE feature to
be set in the superblock as well, if it was not set already.

This overruns the transaction reservation, and can be
demonstrated simply on any ext4 filesystem without the LARGE_FILE
feature already set:

dd if=/dev/zero of=testfile bs=1 seek=2147483646 count=1 \
	conv=notrunc of=testfile
sync
dd if=/dev/zero of=testfile bs=1 seek=2147483647 count=1 \
	conv=notrunc of=testfile

leads to:

EXT4-fs: ext4_do_update_inode:4296: aborting transaction: error 28 in __ext4_handle_dirty_super
EXT4-fs error (device loop0) in ext4_do_update_inode:4301: error 28
EXT4-fs error (device loop0) in ext4_reserve_inode_write:4757: Readonly filesystem
EXT4-fs error (device loop0) in ext4_dirty_inode:4876: error 28
EXT4-fs error (device loop0) in ext4_da_write_end:2685: error 28

Adjust the number of credits based on whether the flag is
already set, and whether the current write may extend past the
LARGE_FILE limit.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
--- 

Ok, how's this ... I do like this a lot better than the set-flag-on-
mount-or-remount, which started to get a bit icky.


diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 3aa26e9..8d362c2 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -2515,6 +2515,20 @@ static int ext4_nonda_switch(struct super_block *sb)
 	return 0;
 }
 
+/* We always reserve for an inode update; the superblock could be there too */
+static int ext4_da_write_credits(struct inode *inode, loff_t pos, unsigned len)
+{
+	if (EXT4_HAS_RO_COMPAT_FEATURE(inode->i_sb,
+                                EXT4_FEATURE_RO_COMPAT_LARGE_FILE))
+		return 1;
+
+	if (pos + len <= 0x7fffffffULL)
+		return 1;
+
+	/* We might need to update the superblock to set LARGE_FILE */
+	return 2;
+}
+
 static int ext4_da_write_begin(struct file *file, struct address_space *mapping,
 			       loff_t pos, unsigned len, unsigned flags,
 			       struct page **pagep, void **fsdata)
@@ -2565,7 +2579,8 @@ retry_grab:
 	 * of file which has an already mapped buffer.
 	 */
 retry_journal:
-	handle = ext4_journal_start(inode, EXT4_HT_WRITE_PAGE, 1);
+	handle = ext4_journal_start(inode, EXT4_HT_WRITE_PAGE,
+			ext4_da_write_credits(inode, pos, len));
 	if (IS_ERR(handle)) {
 		page_cache_release(page);
 		return PTR_ERR(handle);

