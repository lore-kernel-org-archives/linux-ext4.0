From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: Bug in delayed allocation: really bad block layouts!
Date: Wed, 13 Aug 2008 16:22:22 +0530
Message-ID: <20080813105222.GG6439@skywalker>
References: <E1KSEkA-00009o-CV@closure.thunk.org> <20080811143911.GA6455@skywalker> <20080811181524.GA9769@skywalker> <20080813023205.GA8232@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e28smtp01.in.ibm.com ([59.145.155.1]:45754 "EHLO
	e28esmtp01.in.ibm.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752129AbYHMKw3 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 13 Aug 2008 06:52:29 -0400
Received: from d28relay04.in.ibm.com (d28relay04.in.ibm.com [9.184.220.61])
	by e28esmtp01.in.ibm.com (8.13.1/8.13.1) with ESMTP id m7DAqQS7032145
	for <linux-ext4@vger.kernel.org>; Wed, 13 Aug 2008 16:22:26 +0530
Received: from d28av04.in.ibm.com (d28av04.in.ibm.com [9.184.220.66])
	by d28relay04.in.ibm.com (8.13.8/8.13.8/NCO v9.0) with ESMTP id m7DAqQ7B1241152
	for <linux-ext4@vger.kernel.org>; Wed, 13 Aug 2008 16:22:26 +0530
Received: from d28av04.in.ibm.com (loopback [127.0.0.1])
	by d28av04.in.ibm.com (8.13.1/8.13.3) with ESMTP id m7DAqPLR017410
	for <linux-ext4@vger.kernel.org>; Wed, 13 Aug 2008 16:22:25 +0530
Content-Disposition: inline
In-Reply-To: <20080813023205.GA8232@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Aug 12, 2008 at 10:32:05PM -0400, Theodore Tso wrote:
> On Mon, Aug 11, 2008 at 11:45:24PM +0530, Aneesh Kumar K.V wrote:
> > On Mon, Aug 11, 2008 at 08:09:12PM +0530, Aneesh Kumar K.V wrote:
> > > Can you try this patch ? The patch make group preallocation use the goal
> > > block.
> > > 
> > 
> > Results with and without patch.
> > 
> > http://www.radian.org/~kvaneesh/ext4/lg-fragmentation/
> > 
> 
> My results match yours; seems to be a bit better, but it's not fixing
> the fundamental problem.  With the patch:
> 
>  26524: expecting 638190 actual extent phys 631960 log 1 len 1
>  26527: expecting 638191 actual extent phys 631963 log 1 len 1
>  26533: expecting 638192 actual extent phys 631976 log 1 len 5
>  26534: expecting 638193 actual extent phys 631981 log 1 len 2
>  26536: expecting 638194 actual extent phys 631984 log 1 len 6
>  26538: expecting 638195 actual extent phys 631991 log 1 len 5
>  26540: expecting 638196 actual extent phys 631997 log 1 len 2
>  26545: expecting 638197 actual extent phys 632009 log 1 len 1
>  26546: expecting 638198 actual extent phys 632010 log 1 len 6
>  26604: expecting 638199 actual extent phys 632156 log 1 len 1
> 
> Useing debugfs's stat command to look at the blocks:
> 
> 26524: (0):638189, (1):631960
> 26527: (0):638190, (1):631963
> 26533: (0):638191, (1-5):631976-631980
> 26534: (0):638192, (1-2):631981-631982
> 26536: (0):638193, (1-6):631984-631989
> 26538: (0):638194, (1-5):631991-631995
> 26540: (0):638195, (1-2):631997-631998
> 26545: (0):638196, (1):632009
> 26546: (0):638197, (1-6):632010-632015

I am not sure why we are getting single block request for inodes
26524 etc. With delayed alloc we should have got 2 block request.

> 
> Out of curiosity, I also probed the inode numbers that were out of
> sequence from above.  They seem to be mostly allocating out of the
> numbers used for the second extent, above.  
> 
> 26526: (0):631961
> 26526: (0):631962
> 26528: (0):631964
> 26529: (0):411742
> 26530: (0):631965
> 26531: (0-1):631966-631967
> 26532: (0-7):631968-631975
> 26535: (0):631983
> 26537: (0):631990
> 26541: (0-7):631999-632006
> 26542: (0):632007
> 26543: (0):632008
> 26544: (0):411743
> 26547: (0):632016
> 
> Inode  Pathname
> 26524  /lib/rhythmbox/plugins/lyrics/LyricsConfigureDialog.py
> 26525  /lib/rhythmbox/plugins/lyrics/LyrcParser.py
> 26526  /lib/rhythmbox/plugins/lyrics/LyricsParse.py
> 26527  /lib/rhythmbox/plugins/lyrics/LyricsConfigureDialog.pyc
> 26528  /lib/rhythmbox/plugins/lyrics/WinampcnParser.py
> 26529  /lib/rhythmbox/plugins/magnatune
> 26530  /lib/rhythmbox/plugins/magnatune/magnatune_logo_color_small.png
> 26531  /lib/rhythmbox/plugins/magnatune/magnatune.rb-plugin
> 26532  /lib/rhythmbox/plugins/magnatune/magnatune-prefs.glade
> 26533  /lib/rhythmbox/plugins/magnatune/MagnatuneSource.pyc
> 26534  /lib/rhythmbox/plugins/magnatune/__init__.py
> 26535  /lib/rhythmbox/plugins/magnatune/BuyAlbumHandler.py
> 26536  /lib/rhythmbox/plugins/magnatune/magnatune-purchase.glade
> 26537  /lib/rhythmbox/plugins/magnatune/TrackListHandler.py
> 26538  /lib/rhythmbox/plugins/magnatune/MagnatuneSource.py
> 26539  /lib/rhythmbox/plugins/magnatune/magnatune_logo_color_tiny.png
> 26540  /lib/rhythmbox/plugins/magnatune/__init__.pyc
> 26541  /lib/rhythmbox/plugins/magnatune/magnatune-loading.glade
> 26542  /lib/rhythmbox/plugins/magnatune/TrackListHandler.pyc
> 26543  /lib/rhythmbox/plugins/magnatune/BuyAlbumHandler.pyc
> 26544  /lib/rhythmbox/plugins/audioscrobbler
> 26546  /lib/rhythmbox/plugins/audioscrobbler/audioscrobbler-prefs.glade
> 26547  /lib/rhythmbox/plugins/audioscrobbler/audioscrobbler-ui.xml
> 
> Looks like we still have some problems with the block allocator...

The problem is with delalloc and mballoc locality group. With delalloc
we use pdflush to write the pages. Small file allocation use a per-cpu
prealloc space. In my understanding using Per-CPU prealloc space is
fine without delalloc. Because without delalloc get_block happens in the
process context at write_begin and OS scheduler will not schedule the
task to other CPU unless needed.

With delalloc we have pdflush doing block allocation and using per-cpu
may not really help here. So i tried a small patch as below. But that
didn't help much. Also the patch would increase contention on the
locality group mutex. So i guess the change is not worth. 

But with delalloc we should have got multiple block request together.
That implies we should get a single get_block request for the whole
file. I will have to instrument the kernel to understand why it is not
happening.

Even though the files are fragmented I guess we have those blocks closer
on disk right ?

diff --git a/fs/ext4/ext4_i.h b/fs/ext4/ext4_i.h
index ef7409f..734b6ef 100644
--- a/fs/ext4/ext4_i.h
+++ b/fs/ext4/ext4_i.h
@@ -163,6 +163,8 @@ struct ext4_inode_info {
 	/* mballoc */
 	struct list_head i_prealloc_list;
 	spinlock_t i_prealloc_lock;
+	/* locality group used for block allocation */
+	struct ext4_locality_group *lg;
 
 	/* allocation reservation info for delalloc */
 	unsigned long i_reserved_data_blocks;
diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
index 25fe375..293f048 100644
--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -4061,9 +4061,10 @@ static inline void ext4_mb_show_ac(struct ext4_allocation_context *ac)
  */
 static void ext4_mb_group_or_file(struct ext4_allocation_context *ac)
 {
-	struct ext4_sb_info *sbi = EXT4_SB(ac->ac_sb);
-	int bsbits = ac->ac_sb->s_blocksize_bits;
 	loff_t size, isize;
+	int bsbits = ac->ac_sb->s_blocksize_bits;
+	struct ext4_sb_info *sbi = EXT4_SB(ac->ac_sb);
+	struct ext4_inode_info *ei = EXT4_I(ac->ac_inode);
 
 	if (!(ac->ac_flags & EXT4_MB_HINT_DATA))
 		return;
@@ -4085,13 +4086,23 @@ static void ext4_mb_group_or_file(struct ext4_allocation_context *ac)
 	 * per cpu locality group is to reduce the contention between block
 	 * request from multiple CPUs.
 	 */
-	ac->ac_lg = &sbi->s_locality_groups[get_cpu()];
-	put_cpu();
+	if (ei->lg)
+		ac->ac_lg = ei->lg;
+	else {
+		ac->ac_lg = &sbi->s_locality_groups[get_cpu()];
+		ei->lg = ac->ac_lg;
+		put_cpu();
+	}
 
 	/* we're going to use group allocation */
 	ac->ac_flags |= EXT4_MB_HINT_GROUP_ALLOC;
 
-	/* serialize all allocations in the group */
+	/*
+	 * serialize all allocations in the group
+	 * If we find lot of contention we may want
+	 * to add waiters count and use other lg if
+	 * we have large number of waiters
+	 */
 	mutex_lock(&ac->ac_lg->lg_mutex);
 }
 
diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 09e3c56..08bdbf9 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -576,6 +576,7 @@ static struct inode *ext4_alloc_inode(struct super_block *sb)
 	ei->i_reserved_meta_blocks = 0;
 	ei->i_allocated_meta_blocks = 0;
 	ei->i_delalloc_reserved_flag = 0;
+	ei->lg = NULL;
 	spin_lock_init(&(ei->i_block_reservation_lock));
 	return &ei->vfs_inode;
 }
