From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: [RFC]Ext4: journal credits reservation fixes for DIO,
	fallocate and delalloc writepages
Date: Mon, 28 Jul 2008 21:41:56 +0530
Message-ID: <20080728161156.GB4545@skywalker>
References: <48841077.500@cse.unsw.edu.au> <20080721082010.GC8788@skywalker> <1216774311.6505.4.camel@mingming-laptop> <20080723074226.GA15091@skywalker> <1217014002.6322.29.camel@mingming-laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: tytso <tytso@mit.edu>, Shehjar Tikoo <shehjart@cse.unsw.edu.au>,
	linux-ext4@vger.kernel.org
To: Mingming Cao <cmm@us.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e28smtp07.in.ibm.com ([59.145.155.7]:39878 "EHLO
	e28esmtp07.in.ibm.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754968AbYG1QMT (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 28 Jul 2008 12:12:19 -0400
Received: from d28relay02.in.ibm.com (d28relay02.in.ibm.com [9.184.220.59])
	by e28esmtp07.in.ibm.com (8.13.1/8.13.1) with ESMTP id m6SGC5XR006515
	for <linux-ext4@vger.kernel.org>; Mon, 28 Jul 2008 21:42:05 +0530
Received: from d28av04.in.ibm.com (d28av04.in.ibm.com [9.184.220.66])
	by d28relay02.in.ibm.com (8.13.8/8.13.8/NCO v9.0) with ESMTP id m6SGC5PV1786056
	for <linux-ext4@vger.kernel.org>; Mon, 28 Jul 2008 21:42:05 +0530
Received: from d28av04.in.ibm.com (loopback [127.0.0.1])
	by d28av04.in.ibm.com (8.13.1/8.13.3) with ESMTP id m6SGC5wa021826
	for <linux-ext4@vger.kernel.org>; Mon, 28 Jul 2008 21:42:05 +0530
Content-Disposition: inline
In-Reply-To: <1217014002.6322.29.camel@mingming-laptop>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Jul 25, 2008 at 12:26:42PM -0700, Mingming Cao wrote:
> 

......

> > >   */
> > >  int ext4_ext_calc_credits_for_insert(struct inode *inode,
> > >  						struct ext4_ext_path *path)
> > > @@ -1930,9 +1931,6 @@ int ext4_ext_calc_credits_for_insert(str
> > >  	 */
> > >  	needed += (depth * 2) + (depth * 2);
> > > 
> > > -	/* any allocation modifies superblock */
> > > -	needed += 1;
> > > -
> > 
> > 
> > Why are we dropping the super block modification credit ? An insert of
> > an extent can result in super block modification also. If the goal is to
> > use ext4_writepages_trans_blocks everywhere then this change is correct.
> > But i see  many place not using ext4_writepages_trans_blocks.
> > 
> ext4_writepages_trans_blocks() will take care of the credits need for
> updating superblock, for just once.ext4_ext_calc_credits_for_insert()
> calculate the credits needed for inserting a single extent, You could
> see in ext4_writepages_trans_blocks(), it will multiple it will the
> total numberof blocks. If we account for superblock credit in
> ext4_ext_calc_credits_for_insert(),  then super block updates for
> multiple extents allocation will be overaccounted, and have to remove
> that later in ext4_writepages_trans_blocks()



ext4_ext_calc_credit for insert was not doing it currently with 
path != NULL.  I attaching a patch which reflect some of the changes
I suggested.


> 
> Other places calling  ext4_ext_calc_credits_for_insert() (mostly
> migrate.c and defrag,c) are updated to add extra 4 credits, including
> superblock, inode block and quota blocks.


I guess it should not be +4 but should be +2 + 2 * EXT4_QUOTA_TRANS_BLOCKS(inode->i_sb);

> 
> > You also need to update the function comment saying that super block
> > update is not accounted.Also it doesn't account for block bitmap,
> > group descriptor and inode block update.
> > 
> 
> Credits for block bitmap and group descriptors are accounted in
> ext4_ext_calc_credits_for_insert()
> 
> inode block update is only accounted once per writepages, so it's
> accounted in
> ext4_writepages_trans_blocks()/ext4_ext_writepages_trans_blocks()
> 

....

> > >   *
> > > @@ -1142,13 +1133,13 @@ int ext4_get_block(struct inode *inode, 
> > >  	handle_t *handle = ext4_journal_current_handle();
> > >  	int ret = 0, started = 0;
> > >  	unsigned max_blocks = bh_result->b_size >> inode->i_blkbits;
> > > +	int dio_credits = EXT4_DATA_TRANS_BLOCKS(inode->i_sb);
> > 
> > Again this should be
> > 	int dio_credits = ext4_writeblocks_trans(inode, DIO_MAX_BLOCKS);
> > 
> No. DIO case is different than writepages(). When get_block() is called
> from DIO path, the get_block()  is called in a loop, and the credit is
> reserved inside the loop. Each time get_block(),will return a single
> extent, so we should use   EXT4_DATA_TRANS_BLOCKS(inode->i_sb) which is
> calculate a single chunk of allocation credits.


That is true only for extent format. With noextents we need something
like below

if (!(EXT4_I(inode)->i_flags & EXT4_EXTENTS_FL))
	dio_credits = ext4_writeblocks_trans_credits_old(inode, max_blocks);
else {
	/*
	 * For extent format get_block return only one extent
	 */
	dio_credits = EXT4_DATA_TRANS_BLOCKS(inode->i_sb);
}



> 
> ext4_da_writepages() is different, we have to reserve the credits
> outside the loop of calling get_block(), since the underlying
> get_block() could be called multiple times, we need to worse case, so
> ext4_writepages_trans_blocks() is called to handling the worse case.
> 
> > > 
> > >  	if (create && !handle) {
> > >  		/* Direct IO write... */
> > >  		if (max_blocks > DIO_MAX_BLOCKS)
> > >  			max_blocks = DIO_MAX_BLOCKS;
> > > -		handle = ext4_journal_start(inode, DIO_CREDITS +
> > > -			      2 * EXT4_QUOTA_TRANS_BLOCKS(inode->i_sb));
> > > +		handle = ext4_journal_start(inode, dio_credits);
> > >  		if (IS_ERR(handle)) {
> > >  			ret = PTR_ERR(handle);
> > >  			goto out;
> > > @@ -1327,7 +1318,7 @@ static int ext4_write_begin(struct file 
> > >  				struct page **pagep, void **fsdata)
> > >  {
> > >   	struct inode *inode = mapping->host;


....


> > 
> > > -	int bpp = ext4_journal_blocks_per_page(inode);
> > > -	int indirects = (EXT4_NDIR_BLOCKS % bpp) ? 5 : 3;
> > > +	int indirects = (EXT4_NDIR_BLOCKS % num) ? 5 : 3;
> > >  	int ret;
> > > 
> > > -	if (EXT4_I(inode)->i_flags & EXT4_EXTENTS_FL)
> > > -		return ext4_ext_writepage_trans_blocks(inode, bpp);
> > > -
> > >  	if (ext4_should_journal_data(inode))
> > > -		ret = 3 * (bpp + indirects) + 2;
> > > +		ret = 3 * (num + indirects) + 2;
> > >  	else
> > > -		ret = 2 * (bpp + indirects) + 2;
> > > +		ret = 2 * (num + indirects) + 2;
> > 
> > 
> > With non journalled moded we should just decrease num. I guess the above
> > should be
> > 	if (ext4_should_journal_data(inode))
> > 		ret = 3 * (num + indirects) + 2;
> > 	else
> > 		ret = 3 * (num + indirects) + 2 - num;
> > 
> > 
> > 
> 
> Well, I think in the journalled mode we need to journal the content of
> the indirect/double indirect blocks also, no?
> 

With non journalled mode we still need to journal the indirect, dindirect
and tindirect block so this should be

	if (ext4_should_journal_data(inode))
		ret = 3 * (num + indirects) + 2;
	else
		ret = 3 * (num + indirects) + 2 - num;

Attaching the patch for easy review



diff --git a/fs/ext4/defrag.c b/fs/ext4/defrag.c
index 7c819fd..46e9600 100644
--- a/fs/ext4/defrag.c
+++ b/fs/ext4/defrag.c
@@ -1385,8 +1385,9 @@ ext4_defrag_alloc_blocks(handle_t *handle, struct inode *org_inode,
 	struct buffer_head *bh = NULL;
 	int err, i, credits = 0;
 
-	credits = ext4_ext_calc_credits_for_single_extent(dest_inode, dest_path)
-		  + 4;
+	credits = ext4_ext_calc_credits_for_single_extent(dest_inode,
+			dest_path) + 2 +
+			2 * EXT4_QUOTA_TRANS_BLOCKS(dest_inode->i_sb);
 	err = ext4_ext_journal_restart(handle,
 				credits + EXT4_TRANS_META_BLOCKS);
 	if (err)
diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index 77f4f94..969b1e6 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -1898,6 +1898,9 @@ static int ext4_ext_rm_idx(handle_t *handle, struct inode *inode,
  * for old tree and new tree, for every level we need to reserve
  * credits to log the bitmap and block group descriptors
  *
+ * This doesn't take into account credit needed for the update of
+ * super block + inode block + quota files
+ *
  */
 int ext4_ext_calc_credits_for_single_extent(struct inode *inode,
 						struct ext4_ext_path *path)
@@ -1909,7 +1912,8 @@ int ext4_ext_calc_credits_for_single_extent(struct inode *inode,
 		depth = ext_depth(inode);
 		if (le16_to_cpu(path[depth].p_hdr->eh_entries)
 				< le16_to_cpu(path[depth].p_hdr->eh_max))
-			return 1;
+			/* 1 group desc + 1 block bitmap for allocated blocks */
+			return 2;
 	}
 
 	/*
@@ -1919,7 +1923,7 @@ int ext4_ext_calc_credits_for_single_extent(struct inode *inode,
 	 */
 	depth = 5;
 
-	/* allocation of new data block(s) */
+	/* 1 group desc + 1 block bitmap for allocated blocks */
 	needed = 2;
 
 	/*
@@ -2059,9 +2063,7 @@ ext4_ext_rm_leaf(handle_t *handle, struct inode *inode,
 			correct_index = 1;
 			credits += (ext_depth(inode)) + 1;
 		}
-#ifdef CONFIG_QUOTA
 		credits += 2 * EXT4_QUOTA_TRANS_BLOCKS(inode->i_sb);
-#endif
 
 		err = ext4_ext_journal_restart(handle, credits);
 		if (err)
@@ -3023,9 +3025,7 @@ int  ext4_ext_writeblocks_trans_credits(struct inode *inode, int nrblocks)
 	else
 		needed = nrblocks * needed  + 2;
 
-#ifdef CONFIG_QUOTA
 	needed += 2 * EXT4_QUOTA_TRANS_BLOCKS(inode->i_sb);
-#endif
 
 	return needed;
 }
@@ -3092,7 +3092,7 @@ long ext4_fallocate(struct inode *inode, int mode, loff_t offset, loff_t len)
 	/*
 	 * credits to insert 1 extent into extent tree
 	 */
-	credits =  EXT4_DATA_TRANS_BLOCKS(inode->i_sb);
+	credits = EXT4_DATA_TRANS_BLOCKS(inode->i_sb);
 	mutex_lock(&inode->i_mutex);
 retry:
 	while (ret >= 0 && ret < max_blocks) {
diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 5a394c8..d2832a1 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -1126,18 +1126,29 @@ int ext4_get_blocks_wrap(handle_t *handle, struct inode *inode, sector_t block,
 	up_write((&EXT4_I(inode)->i_data_sem));
 	return retval;
 }
+static int ext4_writeblocks_trans_credits_old(struct inode *, int);
 int ext4_get_block(struct inode *inode, sector_t iblock,
 			struct buffer_head *bh_result, int create)
 {
 	handle_t *handle = ext4_journal_current_handle();
 	int ret = 0, started = 0;
 	unsigned max_blocks = bh_result->b_size >> inode->i_blkbits;
-	int dio_credits = EXT4_DATA_TRANS_BLOCKS(inode->i_sb);
+	int dio_credits;
 
 	if (create && !handle) {
 		/* Direct IO write... */
 		if (max_blocks > DIO_MAX_BLOCKS)
 			max_blocks = DIO_MAX_BLOCKS;
+		if (!(EXT4_I(inode)->i_flags & EXT4_EXTENTS_FL))
+			dio_credits = ext4_writeblocks_trans_credits_old(inode,
+							max_blocks);
+		else {
+			/*
+			 * For extent format get_block return only one extent
+			 */
+			dio_credits = EXT4_DATA_TRANS_BLOCKS(inode->i_sb);
+		}
+
 		handle = ext4_journal_start(inode, dio_credits);
 		if (IS_ERR(handle)) {
 			ret = PTR_ERR(handle);
@@ -4310,14 +4321,18 @@ static int ext4_writeblocks_trans_credits_old(struct inode *inode, int nrblocks)
 
 	if (ext4_should_journal_data(inode))
 		ret = 3 * (nrblocks + indirects) + 2;
-	else
-		ret = 2 * (nrblocks + indirects) + 2;
+	else {
+		/*
+		 * We still need to journal update for the
+		 * indirect, dindirect, and tindirect blocks
+		 * only data blocks are not journalled
+		 */
+		ret = 3 * (nrblocks + indirects) + 2 - nrblocks;
+	}
 
-#ifdef CONFIG_QUOTA
 	/* We know that structure was already allocated during DQUOT_INIT so
 	 * we will be updating only the data blocks + inodes */
-	ret += 2*EXT4_QUOTA_TRANS_BLOCKS(inode->i_sb);
-#endif
+	ret += 2 * EXT4_QUOTA_TRANS_BLOCKS(inode->i_sb);
 
 	return ret;
 }
diff --git a/fs/ext4/migrate.c b/fs/ext4/migrate.c
index 3456094..72488ab 100644
--- a/fs/ext4/migrate.c
+++ b/fs/ext4/migrate.c
@@ -55,7 +55,8 @@ static int finish_range(handle_t *handle, struct inode *inode,
 	 *
 	 * extra 4 credits for: 1 superblock, 1 inode block, 2 quotas
 	 */
-	needed = ext4_ext_calc_credits_for_single_extent(inode, path) + 4;
+	needed = ext4_ext_calc_credits_for_single_extent(inode, path) + 2 +
+				2 * EXT4_QUOTA_TRANS_BLOCKS(inode->i_sb);;
 
 	/*
 	 * Make sure the credit we accumalated is not really high

