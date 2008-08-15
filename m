From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: [PATCH] ext4: Fix small file fragmentation
Date: Fri, 15 Aug 2008 23:22:43 +0530
Message-ID: <20080815175243.GD6511@skywalker>
References: <1218735880-10915-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <20080814231816.GA13048@mit.edu>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="ikeVEW9yuYc//A+q"
Cc: cmm@us.ibm.com, sandeen@redhat.com, linux-ext4@vger.kernel.org
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from E23SMTP05.au.ibm.com ([202.81.18.174]:45827 "EHLO
	e23smtp05.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753619AbYHORwy (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 15 Aug 2008 13:52:54 -0400
Received: from sd0109e.au.ibm.com (d23rh905.au.ibm.com [202.81.18.225])
	by e23smtp05.au.ibm.com (8.13.1/8.13.1) with ESMTP id m7FHq2KX025815
	for <linux-ext4@vger.kernel.org>; Sat, 16 Aug 2008 03:52:02 +1000
Received: from d23av02.au.ibm.com (d23av02.au.ibm.com [9.190.235.138])
	by sd0109e.au.ibm.com (8.13.8/8.13.8/NCO v9.0) with ESMTP id m7FHqpcR098130
	for <linux-ext4@vger.kernel.org>; Sat, 16 Aug 2008 03:52:51 +1000
Received: from d23av02.au.ibm.com (loopback [127.0.0.1])
	by d23av02.au.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m7FHqpjt030466
	for <linux-ext4@vger.kernel.org>; Sat, 16 Aug 2008 03:52:51 +1000
Content-Disposition: inline
In-Reply-To: <20080814231816.GA13048@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


--ikeVEW9yuYc//A+q
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Aug 14, 2008 at 07:18:17PM -0400, Theodore Tso wrote:
> On Thu, Aug 14, 2008 at 11:14:40PM +0530, Aneesh Kumar K.V wrote:
> > mballoc small file block allocation use per cpu prealloc
> > space. Use goal block when searching for the right prealloc
> > space. Also make sure ext4_da_writepages tries to write
> > all the pages for small files in single attempt
> 
> Hi Aneesh, how are you testing your patch?  I've created the following
> shell script:
> 
> -------------------------------
> #!/bin/sh
> #
> # small-files-frag-test --- test for small files fragmentation
> 
> DEVICE=/dev/thunk/testbench
> 
> mke2fs -t ext4dev $DEVICE
> mount -t ext4dev $DEVICE /mnt
> tar -C /usr -cf - bin lib | tar -C /mnt -xpf - 
> sync; sleep 5
> umount $DEVICE
> e2fsck -nfv -E fragcheck $DEVICE
> -------------------------------
> 
> ... and the results show roughly the same amount of fragmentation, and the
> same pattern.  In fact, it's a ltitle worse (30% vs 25%).
> 
>    37912 inodes used (11.57%)
>    11468 non-contiguous inodes (30.2%)
>          # of inodes with ind/dind/tind blocks: 0/0/0
>          Extent depth histogram: 32638/5
>   711894 blocks used (54.31%)
> 


I have better results with the below patch on top of the patch i sent.

   21156 inodes used (0.47%)
     158 non-contiguous inodes (0.7%)
         # of inodes with ind/dind/tind blocks: 4/4/4
  581216 blocks used (3.24%)
       0 bad blocks
       1 large file

commit 6ad9d25595aea8efa0d45c0a2dd28b4a415e34e6
Author: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
Date:   Fri Aug 15 23:19:15 2008 +0530

    move the dirty inodes to the end of the list

diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
index 1afcb11..650b021 100644
--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -4258,7 +4258,8 @@ ext4_mb_discard_lg_preallocations(struct super_block *sb,
 
 static void ext4_mb_add_n_trim(struct ext4_allocation_context *ac)
 {
-	int order, added = 0, lg_prealloc_count = 1;
+	int order, lg_prealloc_count = 1;
+	bool added = 0;
 	struct super_block *sb = ac->ac_sb;
 	struct ext4_locality_group *lg = ac->ac_lg;
 	struct ext4_prealloc_space *tmp_pa, *pa = ac->ac_pa;
diff --git a/fs/fs-writeback.c b/fs/fs-writeback.c
index 25adfc3..95eee62 100644
--- a/fs/fs-writeback.c
+++ b/fs/fs-writeback.c
@@ -163,7 +163,7 @@ void __mark_inode_dirty(struct inode *inode, int flags)
 		 */
 		if (!was_dirty) {
 			inode->dirtied_when = jiffies;
-			list_move(&inode->i_list, &sb->s_dirty);
+			list_move_tail(&inode->i_list, &sb->s_dirty);
 		}
 	}
 out:
@@ -208,7 +208,7 @@ static void redirty_tail(struct inode *inode)
  */
 static void requeue_io(struct inode *inode)
 {
-	list_move(&inode->i_list, &inode->i_sb->s_more_io);
+	list_move_tail(&inode->i_list, &inode->i_sb->s_more_io);
 }
 
 static void inode_sync_complete(struct inode *inode)

--ikeVEW9yuYc//A+q
Content-Type: application/octet-stream
Content-Disposition: attachment; filename="out.bz2"
Content-Transfer-Encoding: base64

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
/F3JFOFCQdZogdA=

--ikeVEW9yuYc//A+q--
