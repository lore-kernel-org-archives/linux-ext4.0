From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [PATCH 1/4] e2fsck: Discard only unused parts of inode table
Date: Mon, 05 Mar 2012 13:01:04 -0600
Message-ID: <4F550D70.6060708@redhat.com>
References: <1330933776-2696-1-git-send-email-lczerner@redhat.com> <4F54FBBE.8060303@redhat.com> <alpine.LFD.2.00.1203051926100.7836@dhcp-27-109.brq.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu
To: Lukas Czerner <lczerner@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:16049 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757375Ab2CETBH (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 5 Mar 2012 14:01:07 -0500
In-Reply-To: <alpine.LFD.2.00.1203051926100.7836@dhcp-27-109.brq.redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 03/05/2012 12:43 PM, Lukas Czerner wrote:
> On Mon, 5 Mar 2012, Eric Sandeen wrote:
> 
>> On 03/05/2012 01:49 AM, Lukas Czerner wrote:
>>> When calling e2fsck with '-E discard' option it might happen that
>>> valid inodes are discarded accidentally. This is because we just
>>> discard the part of inode table which lies past the free inode count.
>>> This is terribly wrong (sorry!).
>>>
>>> This patch fixes it so only the free parts of an inode table
>>> is discarded, leaving used inodes intact. This was tested with highly
>>> fragmented inode tables with block size 4k and 1k.
>>
>> Every time I look at this I have new comments.  The surrounding code
>> is confusing to read, IMHO, so don't take it too hard. ;)
>>
>>> Signed-off-by: Lukas Czerner <lczerner@redhat.com>
>>> Reported-by: Phillip Susi <psusi@ubuntu.com>
>>
>> I'll go ahead and:
>>
>> Reviewed-by: Eric Sandeen <sandeen@redhat.com>
>>
>> so hopefully we can get this in & fix the bug.
>>
>> but I have one more suggestion, which could be done as a cleanup later
>> on (I think the check_*_bitmaps could use a fair bit of cleanup for
>> clarity):
>>
>> /*
>>  * If the last inode is free, we can discard it as well.
>>  */
>> if (inodes >= first_free)
>> 	e2fsck_discard_inodes(ctx, group, first_free,
>> 					inodes - first_free + 1);
>>
>> could/should probably be something like:
>>
>> if (inodes == first_free)
>> 	e2fsck_discard_inodes(ctx, group, inodes, 1);
>>
>> I _think_ this case should only, ever, handle the last inode in the
>> group, right?
> 
> Hi Eric,
> 
> thanks for the review. It almost seems that I am not able to write
> understandable comments :). 

It's as least as likely that I cannot understand understandable code ;)

I think you are right, and my suggestion was wrong.  Sorry for the noise!

-Eric

> The reason the comment is there is that we
> usually do:
> 
> 	if (inodes > first_free)
> 
> but in this particular case we do
> 
> 	if (inodes >= first_free)
> 
> And we have '=' there because at that point we might have last inode
> which is free. But because we will not have another iteration on that
> group, there will not be another 'used' inode which will result the code
> to go in the 'if (bitmap)' branch discarding that last inode. So we have
> to discard the last inode as well.
> 
> However, doing (inodes == first_free) would be wrong, because we might
> have more free inodes at the end of the inode table so first_free will
> be smaller than inodes (which is actually the usual case as we do in the
> 'if (bitmap)' branch).
> 
> So the comment:
> 
> 	If the last inode is free, we can discard it as well.
> 
> is simply there 'because' we will only hit this if the last inode is
> free and we have to discard it as well (thus the '>=').
> 
> Hope that makes sense, I am not very good at explaining things :)
> 
> Thanks!
> -Lukas
> 
>>
>> -Eric
>>
>>> ---
>>>  e2fsck/pass5.c |   90 +++++++++++++++++++++++++++++++++++++++++--------------
>>>  1 files changed, 67 insertions(+), 23 deletions(-)
>>>
>>> diff --git a/e2fsck/pass5.c b/e2fsck/pass5.c
>>> index 1e836e3..ee73dd5 100644
>>> --- a/e2fsck/pass5.c
>>> +++ b/e2fsck/pass5.c
>>> @@ -94,6 +94,52 @@ static void e2fsck_discard_blocks(e2fsck_t ctx, io_manager manager,
>>>  		ctx->options &= ~E2F_OPT_DISCARD;
>>>  }
>>>  
>>> +/*
>>> + * This will try to discard number 'count' inodes starting at
>>> + * inode number 'start' within the 'group'. Note that 'start'
>>> + * is 1-based, it means that we need to adjust it by -1 in this
>>> + * function to compute right offset in the particular inode table.
>>> + */
>>> +static void e2fsck_discard_inodes(e2fsck_t ctx, int group,
>>> +				  int start, int count)
>>> +{
>>> +	ext2_filsys fs = ctx->fs;
>>> +	blk64_t blk, num;
>>> +	int orig = count;
>>> +
>>> +	/*
>>> +	 * Sanity check for 'start'
>>> +	 */
>>> +	if ((start < 1) || (start > EXT2_INODES_PER_GROUP(fs->super))) {
>>> +		printf("PROGRAMMING ERROR: Got start %d outside of group %d!"
>>> +		       " Disabling discard\n",
>>> +			start, group);
>>> +		ctx->options &= ~E2F_OPT_DISCARD;
>>> +	}
>>> +
>>> +	if ((ctx->options & E2F_OPT_NO) || !(ctx->options & E2F_OPT_DISCARD))
>>> +		return;
>>> +
>>> +	/*
>>> +	 * Start is inode number within the group which starts
>>> +	 * counting from 1, so we need to adjust it.
>>> +	 */
>>> +	start -= 1;
>>> +
>>> +	/*
>>> +	 * We can discard only blocks containing only unused
>>> +	 * inodes in the table.
>>> +	 */
>>> +	blk = DIV_ROUND_UP(start,
>>> +		EXT2_INODES_PER_BLOCK(fs->super));
>>> +	count -= (blk * EXT2_INODES_PER_BLOCK(fs->super) - start);
>>> +	blk += ext2fs_inode_table_loc(fs, group);
>>> +	num = count / EXT2_INODES_PER_BLOCK(fs->super);
>>> +
>>> +	if (num > 0)
>>> +		e2fsck_discard_blocks(ctx, fs->io->manager, blk, num);
>>> +}
>>> +
>>>  #define NO_BLK ((blk64_t) -1)
>>>  
>>>  static void print_bitmap_problem(e2fsck_t ctx, int problem,
>>> @@ -435,6 +481,7 @@ static void check_inode_bitmaps(e2fsck_t ctx)
>>>  	int		skip_group = 0;
>>>  	int		redo_flag = 0;
>>>  	io_manager	manager = ctx->fs->io->manager;
>>> +	unsigned long long	first_free = fs->super->s_inodes_per_group + 1;
>>>  
>>>  	clear_problem_context(&pctx);
>>>  	free_array = (int *) e2fsck_allocate_memory(ctx,
>>> @@ -497,6 +544,7 @@ redo_counts:
>>>  				 * are 0, count the free inode,
>>>  				 * skip the current block group.
>>>  				 */
>>> +				first_free = 1;
>>>  				inodes = fs->super->s_inodes_per_group - 1;
>>>  				group_free = inodes;
>>>  				free_inodes += inodes;
>>> @@ -561,50 +609,46 @@ redo_counts:
>>>  		ctx->options &= ~E2F_OPT_DISCARD;
>>>  
>>>  do_counts:
>>> +		inodes++;
>>>  		if (bitmap) {
>>>  			if (ext2fs_test_inode_bitmap2(ctx->inode_dir_map, i))
>>>  				dirs_count++;
>>> +			if (inodes > first_free) {
>>> +				e2fsck_discard_inodes(ctx, group, first_free,
>>> +						      inodes - first_free);
>>> +				first_free = fs->super->s_inodes_per_group + 1;
>>> +			}
>>>  		} else if (!skip_group || csum_flag) {
>>>  			group_free++;
>>>  			free_inodes++;
>>> +			if (first_free > inodes)
>>> +				first_free = inodes;
>>>  		}
>>>  
>>> -		inodes++;
>>>  		if ((inodes == fs->super->s_inodes_per_group) ||
>>>  		    (i == fs->super->s_inodes_count)) {
>>> -
>>> -			free_array[group] = group_free;
>>> -			dir_array[group] = dirs_count;
>>> -
>>> -			/* Discard inode table */
>>> -			if (ctx->options & E2F_OPT_DISCARD) {
>>> -				blk64_t used_blks, blk, num;
>>> -
>>> -				used_blks = DIV_ROUND_UP(
>>> -					(EXT2_INODES_PER_GROUP(fs->super) -
>>> -					group_free),
>>> -					EXT2_INODES_PER_BLOCK(fs->super));
>>> -
>>> -				blk = ext2fs_inode_table_loc(fs, group) +
>>> -				      used_blks;
>>> -				num = fs->inode_blocks_per_group -
>>> -				      used_blks;
>>> -				e2fsck_discard_blocks(ctx, manager, blk, num);
>>> -			}
>>> -
>>> +			/*
>>> +			 * If the last inode is free, we can discard it as well.
>>> +			 */
>>> +			if (inodes >= first_free)
>>> +				e2fsck_discard_inodes(ctx, group, first_free,
>>> +						      inodes - first_free + 1);
>>>  			/*
>>>  			 * If discard zeroes data and the group inode table
>>>  			 * was not zeroed yet, set itable as zeroed
>>>  			 */
>>>  			if ((ctx->options & E2F_OPT_DISCARD) &&
>>> -			    (io_channel_discard_zeroes_data(fs->io)) &&
>>> +			    io_channel_discard_zeroes_data(fs->io) &&
>>>  			    !(ext2fs_bg_flags_test(fs, group,
>>> -						  EXT2_BG_INODE_ZEROED))) {
>>> +						   EXT2_BG_INODE_ZEROED))) {
>>>  				ext2fs_bg_flags_set(fs, group,
>>>  						    EXT2_BG_INODE_ZEROED);
>>>  				ext2fs_group_desc_csum_set(fs, group);
>>>  			}
>>>  
>>> +			first_free = fs->super->s_inodes_per_group + 1;
>>> +			free_array[group] = group_free;
>>> +			dir_array[group] = dirs_count;
>>>  			group ++;
>>>  			inodes = 0;
>>>  			skip_group = 0;
>>
>>
> 

