From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Build error with patchqueue
Date: Mon, 4 Aug 2008 23:12:09 +0530
Message-ID: <20080804174209.GA12765@skywalker>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e28smtp03.in.ibm.com ([59.145.155.3]:59722 "EHLO
	e28esmtp03.in.ibm.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751384AbYHDRmR (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 4 Aug 2008 13:42:17 -0400
Received: from d28relay04.in.ibm.com (d28relay04.in.ibm.com [9.184.220.61])
	by e28esmtp03.in.ibm.com (8.13.1/8.13.1) with ESMTP id m74HgErl002057
	for <linux-ext4@vger.kernel.org>; Mon, 4 Aug 2008 23:12:14 +0530
Received: from d28av01.in.ibm.com (d28av01.in.ibm.com [9.184.220.63])
	by d28relay04.in.ibm.com (8.13.8/8.13.8/NCO v9.0) with ESMTP id m74HgEil1773628
	for <linux-ext4@vger.kernel.org>; Mon, 4 Aug 2008 23:12:14 +0530
Received: from d28av01.in.ibm.com (loopback [127.0.0.1])
	by d28av01.in.ibm.com (8.13.1/8.13.3) with ESMTP id m74HgE64001059
	for <linux-ext4@vger.kernel.org>; Mon, 4 Aug 2008 23:12:14 +0530
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi Ted,

The patchqueue have the below build error.

CC      fs/ext4/inode.o
fs/ext4/inode.c: In function =E2=80=98ext4_delete_inode=E2=80=99:
fs/ext4/inode.c:230: error: implicit declaration of function
=E2=80=98ext4_ext_journal_restart=E2=80=99
make[1]: *** [fs/ext4/inode.o] Error 1
make: *** [fs/ext4/] Error 2
kvaneesh@skywalker:/home/opensource/patches/work-tree/linux-review-ext-=
build$make
fs/ext4/

diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index 68f148c..70829d5 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -92,7 +92,7 @@ static void ext4_idx_store_pblock(struct ext4_extent_=
idx *ix, ext4_fsblk_t pb)
 	ix->ei_leaf_hi =3D cpu_to_le16((unsigned long) ((pb >> 31) >> 1) & 0x=
ffff);
 }
=20
-static int ext4_ext_journal_restart(handle_t *handle, int needed)
+int ext4_ext_journal_restart(handle_t *handle, int needed)
 {
 	int err;
=20
diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index fe1570d..77ef18b 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -190,6 +190,7 @@ static int ext4_journal_test_restart(handle_t *hand=
le, struct inode *inode)
 /*
  * Called at the last iput() if i_nlink is zero.
  */
+int ext4_ext_journal_restart(handle_t *handle, int needed);
 void ext4_delete_inode (struct inode * inode)
 {
 	handle_t *handle;
@@ -228,7 +229,7 @@ void ext4_delete_inode (struct inode * inode)
 	 * the orphan list and set the dtime field.
 	 */
 	if (ext4_ext_journal_restart(handle, 3)) {
-	stop_handle:
+stop_handle:
 		ext4_journal_stop(handle);
 		goto no_delete;
 	}
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
