From: Andreas Dilger <aedilger@gmail.com>
Subject: Re: [PATCH] e2fsck: fix 64-bit journal support
Date: Tue, 22 May 2012 11:09:18 -0600
Message-ID: <422B7479-8E9A-41A4-B164-4671EE505A58@dilger.ca>
References: <E1SWe75-0007rd-TQ@tytso-glaptop.cam.corp.google.com> <4FBBAFCB.2080106@redhat.com>
Mime-Version: 1.0 (Apple Message framework v1084)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Cc: "Theodore Ts'o" <tytso@mit.edu>, linux-ext4@vger.kernel.org
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pz0-f46.google.com ([209.85.210.46]:33400 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751716Ab2EVRJ0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 22 May 2012 13:09:26 -0400
Received: by dady13 with SMTP id y13so8511853dad.19
        for <linux-ext4@vger.kernel.org>; Tue, 22 May 2012 10:09:25 -0700 (PDT)
In-Reply-To: <4FBBAFCB.2080106@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 2012-05-22, at 9:24 AM, Eric Sandeen wrote:
> On 5/21/12 8:42 PM, Theodore Ts'o wrote:
>> I just found what a somewhat disturbing bug which is still present in
>> 1.42.3 --- namely, that the journal replay code in e2fsck was not
>> properly handling 64-bit file systems correctly, by dropping the high
>> bits of the block number from the jbd2 descriptor blocks.

Hmm, we did have a bug report that would be explained by this, but it wasn't easily reproduced (dependent on metadata blocks beyond 16TB in
hindsight) and only on a test filesystem, so I hadn't had a chance to
dig into it yet.

We did do a 128TB full-filesystem data write + verification + e2fsck,
but I guess that didn't validate journal recovery.  Most filesystems
only have a fraction of data beyond 16TB, and the allocators prefer
to locate inodes/blocks at the beginning of the filesystem, so it
hasn't shown up in real usage very much.

Good catch.

>> I have not had a chance to fully test to make sure we don't have other
>> bugs hiding in the 64-bit code, but it's clear no one else has had a
>> lot of time to test it either -- at least not to the extent of doing
>> power fail testing of > 16TB file systems!   :-(
> 
> Whoops.  :(
> 
> How do you decide between using "unsigned long long" and "blk64_t" below?
> 
> If they'd all been blk_t's they'd have been easier to spot, if anyone went looking, I suppose.

Makes sense.  Better to be consistent with these things, so that the
compiler and users (grep, etc) can find type mismatches and such.

>> 							- Ted
>> 
>> From 3b693d0b03569795d04920a04a0a21e5f64ffedc Mon Sep 17 00:00:00 2001
>> From: Theodore Ts'o <tytso@mit.edu>
>> Date: Mon, 21 May 2012 21:30:45 -0400
>> Subject: [PATCH] e2fsck: fix 64-bit journal support
>> 
>> 64-bit journal support was broken; we weren't using the high bits from
>> the journal descriptor blocks!  We were also using "unsigned long" for
>> the journal block numbers, which would be a problem on 32-bit systems.
>> 
>> Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
>> ---
>> e2fsck/jfs_user.h |    4 ++--
>> e2fsck/journal.c  |   33 +++++++++++++++++----------------
>> e2fsck/recovery.c |   25 ++++++++++++-------------
>> 3 files changed, 31 insertions(+), 31 deletions(-)
>> 
>> diff --git a/e2fsck/jfs_user.h b/e2fsck/jfs_user.h
>> index 9e33306..92f8ae2 100644
>> --- a/e2fsck/jfs_user.h
>> +++ b/e2fsck/jfs_user.h
>> @@ -18,7 +18,7 @@ struct buffer_head {
>> 	e2fsck_t	b_ctx;
>> 	io_channel 	b_io;
>> 	int	 	b_size;
>> -	blk_t	 	b_blocknr;
>> +	unsigned long long b_blocknr;
>> 	int	 	b_dirty;
>> 	int	 	b_uptodate;
>> 	int	 	b_err;
>> @@ -121,7 +121,7 @@ _INLINE_ size_t journal_tag_bytes(journal_t *journal)
>> /*
>>  * Kernel compatibility functions are defined in journal.c
>>  */
>> -int journal_bmap(journal_t *journal, blk64_t block, unsigned long *phys);
>> +int journal_bmap(journal_t *journal, blk64_t block, unsigned long long *phys);
>> struct buffer_head *getblk(kdev_t ctx, blk64_t blocknr, int blocksize);
>> void sync_blockdev(kdev_t kdev);
>> void ll_rw_block(int rw, int dummy, struct buffer_head *bh[]);
>> diff --git a/e2fsck/journal.c b/e2fsck/journal.c
>> index 915b8bb..bada028 100644
>> --- a/e2fsck/journal.c
>> +++ b/e2fsck/journal.c
>> @@ -44,7 +44,7 @@ static int bh_count = 0;
>>  * to use the recovery.c file virtually unchanged from the kernel, so we
>>  * don't have to do much to keep kernel and user recovery in sync.
>>  */
>> -int journal_bmap(journal_t *journal, blk64_t block, unsigned long *phys)
>> +int journal_bmap(journal_t *journal, blk64_t block, unsigned long long *phys)
>> {
>> #ifdef USE_INODE_IO
>> 	*phys = block;
>> @@ -80,8 +80,8 @@ struct buffer_head *getblk(kdev_t kdev, blk64_t blocknr, int blocksize)
>> 	if (journal_enable_debug >= 3)
>> 		bh_count++;
>> #endif
>> -	jfs_debug(4, "getblk for block %lu (%d bytes)(total %d)\n",
>> -		  (unsigned long) blocknr, blocksize, bh_count);
>> +	jfs_debug(4, "getblk for block %llu (%d bytes)(total %d)\n",
>> +		  (unsigned long long) blocknr, blocksize, bh_count);
>> 
>> 	bh->b_ctx = kdev->k_ctx;
>> 	if (kdev->k_dev == K_DEV_FS)
>> @@ -114,38 +114,39 @@ void ll_rw_block(int rw, int nr, struct buffer_head *bhp[])
>> 	for (; nr > 0; --nr) {
>> 		bh = *bhp++;
>> 		if (rw == READ && !bh->b_uptodate) {
>> -			jfs_debug(3, "reading block %lu/%p\n",
>> -				  (unsigned long) bh->b_blocknr, (void *) bh);
>> +			jfs_debug(3, "reading block %llu/%p\n",
>> +				  bh->b_blocknr, (void *) bh);
>> 			retval = io_channel_read_blk64(bh->b_io,
>> 						     bh->b_blocknr,
>> 						     1, bh->b_data);
>> 			if (retval) {
>> 				com_err(bh->b_ctx->device_name, retval,
>> -					"while reading block %lu\n",
>> -					(unsigned long) bh->b_blocknr);
>> +					"while reading block %llu\n",
>> +					bh->b_blocknr);
>> 				bh->b_err = retval;
>> 				continue;
>> 			}
>> 			bh->b_uptodate = 1;
>> 		} else if (rw == WRITE && bh->b_dirty) {
>> -			jfs_debug(3, "writing block %lu/%p\n",
>> -				  (unsigned long) bh->b_blocknr, (void *) bh);
>> +			jfs_debug(3, "writing block %llu/%p\n",
>> +				  bh->b_blocknr,
>> +				  (void *) bh);
>> 			retval = io_channel_write_blk64(bh->b_io,
>> 						      bh->b_blocknr,
>> 						      1, bh->b_data);
>> 			if (retval) {
>> 				com_err(bh->b_ctx->device_name, retval,
>> -					"while writing block %lu\n",
>> -					(unsigned long) bh->b_blocknr);
>> +					"while writing block %llu\n",
>> +					bh->b_blocknr);
>> 				bh->b_err = retval;
>> 				continue;
>> 			}
>> 			bh->b_dirty = 0;
>> 			bh->b_uptodate = 1;
>> 		} else {
>> -			jfs_debug(3, "no-op %s for block %lu\n",
>> +			jfs_debug(3, "no-op %s for block %llu\n",
>> 				  rw == READ ? "read" : "write",
>> -				  (unsigned long) bh->b_blocknr);
>> +				  bh->b_blocknr);
>> 		}
>> 	}
>> }
>> @@ -164,8 +165,8 @@ void brelse(struct buffer_head *bh)
>> {
>> 	if (bh->b_dirty)
>> 		ll_rw_block(WRITE, 1, &bh);
>> -	jfs_debug(3, "freeing block %lu/%p (total %d)\n",
>> -		  (unsigned long) bh->b_blocknr, (void *) bh, --bh_count);
>> +	jfs_debug(3, "freeing block %llu/%p (total %d)\n",
>> +		  bh->b_blocknr, (void *) bh, --bh_count);
>> 	ext2fs_free_mem(&bh);
>> }
>> 
>> @@ -237,7 +238,7 @@ static errcode_t e2fsck_get_journal(e2fsck_t ctx, journal_t **ret_journal)
>> 	journal_t		*journal = NULL;
>> 	errcode_t		retval = 0;
>> 	io_manager		io_ptr = 0;
>> -	unsigned long		start = 0;
>> +	unsigned long long	start = 0;
>> 	int			ext_journal = 0;
>> 	int			tried_backup_jnl = 0;
>> 
>> diff --git a/e2fsck/recovery.c b/e2fsck/recovery.c
>> index b669941..e94ef4e 100644
>> --- a/e2fsck/recovery.c
>> +++ b/e2fsck/recovery.c
>> @@ -71,7 +71,7 @@ static int do_readahead(journal_t *journal, unsigned int start)
>> {
>> 	int err;
>> 	unsigned int max, nbufs, next;
>> -	unsigned long blocknr;
>> +	unsigned long long blocknr;
>> 	struct buffer_head *bh;
>> 
>> 	struct buffer_head * bufs[MAXBUF];
>> @@ -133,7 +133,7 @@ static int jread(struct buffer_head **bhp, journal_t *journal,
>> 		 unsigned int offset)
>> {
>> 	int err;
>> -	unsigned long blocknr;
>> +	unsigned long long blocknr;
>> 	struct buffer_head *bh;
>> 
>> 	*bhp = NULL;
>> @@ -309,7 +309,6 @@ int journal_skip_recovery(journal_t *journal)
>> 	return err;
>> }
>> 
>> -#if 0
>> static inline unsigned long long read_tag_block(int tag_bytes, journal_block_tag_t *tag)
>> {
>> 	unsigned long long block = be32_to_cpu(tag->t_blocknr);
>> @@ -317,17 +316,16 @@ static inline unsigned long long read_tag_block(int tag_bytes, journal_block_tag
>> 		block |= (__u64)be32_to_cpu(tag->t_blocknr_high) << 32;
>> 	return block;
>> }
>> -#endif
>> 
>> /*
>>  * calc_chksums calculates the checksums for the blocks described in the
>>  * descriptor block.
>>  */
>> static int calc_chksums(journal_t *journal, struct buffer_head *bh,
>> -			unsigned long *next_log_block, __u32 *crc32_sum)
>> +			unsigned long long *next_log_block, __u32 *crc32_sum)
>> {
>> 	int i, num_blks, err;
>> -	unsigned long io_block;
>> +	unsigned long long io_block;
>> 	struct buffer_head *obh;
>> 
>> 	num_blks = count_tags(journal, bh);
>> @@ -340,7 +338,7 @@ static int calc_chksums(journal_t *journal, struct buffer_head *bh,
>> 		err = jread(&obh, journal, io_block);
>> 		if (err) {
>> 			printk(KERN_ERR "JBD: IO error %d recovering block "
>> -				"%lu in log\n", err, io_block);
>> +				"%llu in log\n", err, io_block);
>> 			return 1;
>> 		} else {
>> 			*crc32_sum = crc32_be(*crc32_sum, (void *)obh->b_data,
>> @@ -355,7 +353,7 @@ static int do_one_pass(journal_t *journal,
>> 			struct recovery_info *info, enum passtype pass)
>> {
>> 	unsigned int		first_commit_ID, next_commit_ID;
>> -	unsigned long		next_log_block;
>> +	unsigned long long	next_log_block;
>> 	int			err, success = 0;
>> 	journal_superblock_t *	sb;
>> 	journal_header_t *	tmp;
>> @@ -485,7 +483,7 @@ static int do_one_pass(journal_t *journal,
>> 			tagp = &bh->b_data[sizeof(journal_header_t)];
>> 			while ((tagp - bh->b_data + tag_bytes)
>> 			       <= journal->j_blocksize) {
>> -				unsigned long io_block;
>> +				unsigned long long io_block;
>> 
>> 				tag = (journal_block_tag_t *) tagp;
>> 				flags = be32_to_cpu(tag->t_flags);
>> @@ -499,13 +497,14 @@ static int do_one_pass(journal_t *journal,
>> 					success = err;
>> 					printk (KERN_ERR
>> 						"JBD: IO error %d recovering "
>> -						"block %ld in log\n",
>> +						"block %llu in log\n",
>> 						err, io_block);
>> 				} else {
>> -					unsigned long blocknr;
>> +					unsigned long long blocknr;
>> 
>> 					J_ASSERT(obh != NULL);
>> -					blocknr = be32_to_cpu(tag->t_blocknr);
>> +					blocknr = read_tag_block(tag_bytes,
>> +								 tag);
>> 
>> 					/* If the block has been
>> 					 * revoked, then we're all done
>> @@ -733,7 +732,7 @@ static int scan_revoke_records(journal_t *journal, struct buffer_head *bh,
>> 		record_len = 8;
>> 
>> 	while (offset < max) {
>> -		unsigned long blocknr;
>> +		unsigned long long blocknr;
>> 		int err;
>> 
>> 		if (record_len == 4)
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


Cheers, Andreas





