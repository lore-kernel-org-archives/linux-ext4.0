From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 33/49] ext4: Add the journal checksum feature
Date: Wed, 23 Jan 2008 14:07:04 -0800
Message-ID: <20080123140704.01249f86.akpm@linux-foundation.org>
References: <1200970948-17903-1-git-send-email-tytso@mit.edu>
	<1200970948-17903-18-git-send-email-tytso@mit.edu>
	<1200970948-17903-19-git-send-email-tytso@mit.edu>
	<1200970948-17903-20-git-send-email-tytso@mit.edu>
	<1200970948-17903-21-git-send-email-tytso@mit.edu>
	<1200970948-17903-22-git-send-email-tytso@mit.edu>
	<1200970948-17903-23-git-send-email-tytso@mit.edu>
	<1200970948-17903-24-git-send-email-tytso@mit.edu>
	<1200970948-17903-25-git-send-email-tytso@mit.edu>
	<1200970948-17903-26-git-send-email-tytso@mit.edu>
	<1200970948-17903-27-git-send-email-tytso@mit.edu>
	<1200970948-17903-28-git-send-email-tytso@mit.edu>
	<1200970948-17903-29-git-send-email-tytso@mit.edu>
	<1200970948-17903-30-git-send-email-tytso@mit.edu>
	<1200970948-17903-31-git-send-email-tytso@mit.edu>
	<1200970948-17903-32-git-send-email-tytso@mit.edu>
	<1200970948-17903-33-git-send-email-tytso@mit.edu>
	<1200970948-17903-34-git-send-email-tytso@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-kernel@vger.kernel.org, girish@clusterfs.com,
	adilger@clusterfs.com, shaggy@linux.vnet.ibm.com, cmm@us.ibm.com,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
To: "Theodore Ts'o" <tytso@MIT.EDU>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:54956 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753413AbYAWWHK (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Wed, 23 Jan 2008 17:07:10 -0500
In-Reply-To: <1200970948-17903-34-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

> On Mon, 21 Jan 2008 22:02:12 -0500 "Theodore Ts'o" <tytso@MIT.EDU> wrote:
> From: Girish Shilamkar <girish@clusterfs.com>
> 
> The journal checksum feature adds two new flags i.e
> JBD2_FEATURE_INCOMPAT_ASYNC_COMMIT and JBD2_FEATURE_COMPAT_CHECKSUM.
> 
> JBD2_FEATURE_CHECKSUM flag indicates that the commit block contains the
> checksum for the blocks described by the descriptor blocks.
> Due to checksums, writing of the commit record no longer needs to be
> synchronous. Now commit record can be sent to disk without waiting for
> descriptor blocks to be written to disk. This behavior is controlled
> using JBD2_FEATURE_ASYNC_COMMIT flag. Older kernels/e2fsck should not be
> able to recover the journal with _ASYNC_COMMIT hence it is made
> incompat.
> The commit header has been extended to hold the checksum along with the
> type of the checksum.
> 
> For recovery in pass scan checksums are verified to ensure the sanity
> and completeness(in case of _ASYNC_COMMIT) of every transaction.
> 
>  ...
>
> +static inline __u32 jbd2_checksum_data(__u32 crc32_sum, struct buffer_head *bh)

unneeded inlining.

> +{
> +	struct page *page = bh->b_page;
> +	char *addr;
> +	__u32 checksum;
> +
> +	addr = kmap_atomic(page, KM_USER0);
> +	checksum = crc32_be(crc32_sum,
> +		(void *)(addr + offset_in_page(bh->b_data)), bh->b_size);
> +	kunmap_atomic(addr, KM_USER0);
> +
> +	return checksum;
> +}

Can this buffer actually be in highmem?

>  static inline void write_tag_block(int tag_bytes, journal_block_tag_t *tag,
>  				   unsigned long long block)

More unnecessary inlining.

> +/*
> + * jbd2_journal_clear_features () - Clear a given journal feature in the
> + * 				    superblock
> + * @journal: Journal to act on.
> + * @compat: bitmask of compatible features
> + * @ro: bitmask of features that force read-only mount
> + * @incompat: bitmask of incompatible features
> + *
> + * Clear a given journal feature as present on the
> + * superblock.  Returns true if the requested features could be reset.
> + */
> +int jbd2_journal_clear_features(journal_t *journal, unsigned long compat,
> +				unsigned long ro, unsigned long incompat)
> +{
> +	journal_superblock_t *sb;
> +
> +	jbd_debug(1, "Clear features 0x%lx/0x%lx/0x%lx\n",
> +		  compat, ro, incompat);
> +
> +	sb = journal->j_superblock;
> +
> +	sb->s_feature_compat    &= ~cpu_to_be32(compat);
> +	sb->s_feature_ro_compat &= ~cpu_to_be32(ro);
> +	sb->s_feature_incompat  &= ~cpu_to_be32(incompat);
> +
> +	return 1;
> +}
> +EXPORT_SYMBOL(jbd2_journal_clear_features);

Kernel usually returns 0 on success.  So we can return a useful errno on
failure.

> +/*
> + * calc_chksums calculates the checksums for the blocks described in the
> + * descriptor block.
> + */
> +static int calc_chksums(journal_t *journal, struct buffer_head *bh,
> +			unsigned long *next_log_block, __u32 *crc32_sum)
> +{
> +	int i, num_blks, err;
> +	unsigned io_block;
> +	struct buffer_head *obh;
> +
> +	num_blks = count_tags(journal, bh);
> +	/* Calculate checksum of the descriptor block. */
> +	*crc32_sum = crc32_be(*crc32_sum, (void *)bh->b_data, bh->b_size);
> +
> +	for (i = 0; i < num_blks; i++) {
> +		io_block = (*next_log_block)++;

 unsigned <- unsigned long.

Are all the types appropriate in here?

> +		wrap(journal, *next_log_block);
> +		err = jread(&obh, journal, io_block);
> +		if (err) {
> +			printk(KERN_ERR "JBD: IO error %d recovering block "
> +				"%u in log\n", err, io_block);
> +			return 1;
> +		} else {
> +			*crc32_sum = crc32_be(*crc32_sum, (void *)obh->b_data,
> +				     obh->b_size);
> +		}
> +	}
> +	return 0;
> +}
> +
>  static int do_one_pass(journal_t *journal,
>  			struct recovery_info *info, enum passtype pass)
>  {
> @@ -328,6 +360,7 @@ static int do_one_pass(journal_t *journal,
>  	unsigned int		sequence;
>  	int			blocktype;
>  	int			tag_bytes = journal_tag_bytes(journal);
> +	__u32			crc32_sum = ~0; /* Transactional Checksums */
>  
>  	/* Precompute the maximum metadata descriptors in a descriptor block */
>  	int			MAX_BLOCKS_PER_DESC;
> @@ -419,9 +452,23 @@ static int do_one_pass(journal_t *journal,
>  		switch(blocktype) {
>  		case JBD2_DESCRIPTOR_BLOCK:
>  			/* If it is a valid descriptor block, replay it
> -			 * in pass REPLAY; otherwise, just skip over the
> -			 * blocks it describes. */
> +			 * in pass REPLAY; if journal_checksums enabled, then
> +			 * calculate checksums in PASS_SCAN, otherwise,
> +			 * just skip over the blocks it describes. */
>  			if (pass != PASS_REPLAY) {
> +				if (pass == PASS_SCAN &&
> +				    JBD2_HAS_COMPAT_FEATURE(journal,
> +					    JBD2_FEATURE_COMPAT_CHECKSUM) &&
> +				    !info->end_transaction) {
> +					if (calc_chksums(journal, bh,
> +							&next_log_block,
> +							&crc32_sum)) {

put_bh()

> +						brelse(bh);
> +						break;
> +					}
> +					brelse(bh);
> +					continue;

put_bh()

> +				}
>  				next_log_block += count_tags(journal, bh);
>  				wrap(journal, next_log_block);
>  				brelse(bh);
> @@ -516,9 +563,96 @@ static int do_one_pass(journal_t *journal,
>  			continue;
>  
> +					brelse(bh);

etc
