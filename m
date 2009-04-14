From: Nick Piggin <nickpiggin@yahoo.com.au>
Subject: Re: [patch 42/51] ext2: fix data corruption for racing writes
Date: Tue, 14 Apr 2009 23:02:02 +1000
Message-ID: <200904142302.03702.nickpiggin@yahoo.com.au>
References: <200904132140.n3DLeELl024735@imap1.linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: torvalds@linux-foundation.org, jack@suse.cz, cmm@us.ibm.com,
	linux-ext4@vger.kernel.org, yinghan@google.com
To: akpm@linux-foundation.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp111.mail.mud.yahoo.com ([209.191.84.64]:31927 "HELO
	smtp111.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751330AbZDNNCM (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Tue, 14 Apr 2009 09:02:12 -0400
In-Reply-To: <200904132140.n3DLeELl024735@imap1.linux-foundation.org>
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Thanks for the fix. I meant to ask but forgot: I guess you have checked
that no other ext/minix derived filesystem has similar problems? I did
attempt to reproduce with ext3 but couldn't. I don't know enough of
the code to say whether it does not exist though.

Thanks,
Nick

On Tuesday 14 April 2009 07:40:14 akpm@linux-foundation.org wrote:
> From: Jan Kara <jack@suse.cz>
> 
> If two writers allocating blocks to file race with each other (e.g. 
> because writepages races with ordinary write or two writepages race with
> each other), ext2_getblock() can be called on the same inode in parallel. 
> Before we are going to allocate new blocks, we have to recheck the block
> chain we have obtained so far without holding truncate_mutex.  Otherwise
> we could overwrite the indirect block pointer set by the other writer
> leading to data loss.
> 
> The below test program by Ying is able to reproduce the data loss with ext2
> on in BRD in a few minutes if the machine is under memory pressure:
> 
> long kMemSize  = 50 << 20;
> int kPageSize = 4096;
> 
> int main(int argc, char **argv) {
> 	int status;
> 	int count = 0;
> 	int i;
> 	char *fname = "/mnt/test.mmap";
> 	char *mem;
> 	unlink(fname);
> 	int fd = open(fname, O_CREAT | O_EXCL | O_RDWR, 0600);
> 	status = ftruncate(fd, kMemSize);
> 	mem = mmap(0, kMemSize, PROT_READ | PROT_WRITE, MAP_SHARED, fd, 0);
> 	// Fill the memory with 1s.
> 	memset(mem, 1, kMemSize);
> 	sleep(2);
> 	for (i = 0; i < kMemSize; i++) {
> 		int byte_good = mem[i] != 0;
> 		if (!byte_good && ((i % kPageSize) == 0)) {
> 			//printf("%d ", i / kPageSize);
> 			count++;
> 		}
> 	}
> 	munmap(mem, kMemSize);
> 	close(fd);
> 	unlink(fname);
> 
> 	if (count > 0) {
> 		printf("Running %d bad page\n", count);
> 		return 1;
> 	}
> 	return 0;
> }
> 
> Cc: Ying Han <yinghan@google.com>
> Cc: Nick Piggin <nickpiggin@yahoo.com.au>
> Signed-off-by: Jan Kara <jack@suse.cz>
> Cc: Mingming Cao <cmm@us.ibm.com>
> Cc: <linux-ext4@vger.kernel.org>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> ---
> 
>  fs/ext2/inode.c |   44 +++++++++++++++++++++++++++++++++-----------
>  1 file changed, 33 insertions(+), 11 deletions(-)
> 
> diff -puN fs/ext2/inode.c~ext2-fix-data-corruption-for-racing-writes fs/ext2/inode.c
> --- a/fs/ext2/inode.c~ext2-fix-data-corruption-for-racing-writes
> +++ a/fs/ext2/inode.c
> @@ -590,9 +590,8 @@ static int ext2_get_blocks(struct inode 
>  
>  	if (depth == 0)
>  		return (err);
> -reread:
> -	partial = ext2_get_branch(inode, depth, offsets, chain, &err);
>  
> +	partial = ext2_get_branch(inode, depth, offsets, chain, &err);
>  	/* Simplest case - block found, no allocation needed */
>  	if (!partial) {
>  		first_block = le32_to_cpu(chain[depth - 1].key);
> @@ -602,15 +601,16 @@ reread:
>  		while (count < maxblocks && count <= blocks_to_boundary) {
>  			ext2_fsblk_t blk;
>  
> -			if (!verify_chain(chain, partial)) {
> +			if (!verify_chain(chain, chain + depth - 1)) {
>  				/*
>  				 * Indirect block might be removed by
>  				 * truncate while we were reading it.
>  				 * Handling of that case: forget what we've
>  				 * got now, go to reread.
>  				 */
> +				err = -EAGAIN;
>  				count = 0;
> -				goto changed;
> +				break;
>  			}
>  			blk = le32_to_cpu(*(chain[depth-1].p + count));
>  			if (blk == first_block + count)
> @@ -618,7 +618,8 @@ reread:
>  			else
>  				break;
>  		}
> -		goto got_it;
> +		if (err != -EAGAIN)
> +			goto got_it;
>  	}
>  
>  	/* Next simple case - plain lookup or failed read of indirect block */
> @@ -626,6 +627,33 @@ reread:
>  		goto cleanup;
>  
>  	mutex_lock(&ei->truncate_mutex);
> +	/*
> +	 * If the indirect block is missing while we are reading
> +	 * the chain(ext3_get_branch() returns -EAGAIN err), or
> +	 * if the chain has been changed after we grab the semaphore,
> +	 * (either because another process truncated this branch, or
> +	 * another get_block allocated this branch) re-grab the chain to see if
> +	 * the request block has been allocated or not.
> +	 *
> +	 * Since we already block the truncate/other get_block
> +	 * at this point, we will have the current copy of the chain when we
> +	 * splice the branch into the tree.
> +	 */
> +	if (err == -EAGAIN || !verify_chain(chain, partial)) {
> +		while (partial > chain) {
> +			brelse(partial->bh);
> +			partial--;
> +		}
> +		partial = ext2_get_branch(inode, depth, offsets, chain, &err);
> +		if (!partial) {
> +			count++;
> +			mutex_unlock(&ei->truncate_mutex);
> +			if (err)
> +				goto cleanup;
> +			clear_buffer_new(bh_result);
> +			goto got_it;
> +		}
> +	}
>  
>  	/*
>  	 * Okay, we need to do block allocation.  Lazily initialize the block
> @@ -683,12 +711,6 @@ cleanup:
>  		partial--;
>  	}
>  	return err;
> -changed:
> -	while (partial > chain) {
> -		brelse(partial->bh);
> -		partial--;
> -	}
> -	goto reread;
>  }
>  
>  int ext2_get_block(struct inode *inode, sector_t iblock, struct buffer_head *bh_result, int create)
> _
> 

