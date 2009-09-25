From: Andreas Dilger <adilger@sun.com>
Subject: Re: [PATCH][RFC] resize2fs and uninit_bg questions
Date: Fri, 25 Sep 2009 00:21:25 -0600
Message-ID: <20090925062125.GF10562@webber.adilger.int>
References: <20090916162457.GA84213@freezingfog.local>
 <20090916190831.GH2537@webber.adilger.int>
 <20090916204225.GB84213@freezingfog.local>
 <20090916212250.GL2537@webber.adilger.int>
 <20090916231131.GC84213@freezingfog.local>
 <20090919121909.GA1077@freezingfog.local>
 <20090923093436.GW10562@webber.adilger.int>
 <2359eed20909231228m2050cf65pa9029f931f655b10@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; CHARSET=US-ASCII
Content-Transfer-Encoding: 7BIT
Cc: tytso@mit.edu, linux-ext4@vger.kernel.org,
	Eric Sandeen <esandeen@redhat.com>
To: Will Drewry <redpig@dataspill.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from sca-es-mail-2.Sun.COM ([192.18.43.133]:43030 "EHLO
	sca-es-mail-2.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752096AbZIYGV3 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 25 Sep 2009 02:21:29 -0400
Received: from fe-sfbay-10.sun.com ([192.18.43.129])
	by sca-es-mail-2.sun.com (8.13.7+Sun/8.12.9) with ESMTP id n8P6LU6N001690
	for <linux-ext4@vger.kernel.org>; Thu, 24 Sep 2009 23:21:30 -0700 (PDT)
Content-disposition: inline
Received: from conversion-daemon.fe-sfbay-10.sun.com by fe-sfbay-10.sun.com
 (Sun Java(tm) System Messaging Server 7u2-7.04 64bit (built Jul  2 2009))
 id <0KQI00D00K5LAF00@fe-sfbay-10.sun.com> for linux-ext4@vger.kernel.org; Thu,
 24 Sep 2009 23:21:30 -0700 (PDT)
In-reply-to: <2359eed20909231228m2050cf65pa9029f931f655b10@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sep 23, 2009  14:28 -0500, Will Drewry wrote:
> That aside, I've also got a barebones kernel patch which supports lazy
> online resizing which accompanies the e2fsprogs patch above. I realize
> it is probably less-than-practical until there is an initializing
> thread, but I'd appreciate any feedback if possible -- even if just to
> ensure I'm understanding things correctly.

This is looking very good.  For prototyping the initializing thread, I
would suggest to create a "per-group initialization and check" function
(maybe just stealing the inside of the ext4_check_descriptors() loop as
a starting point) that is called inline for each group at mount time.
Add in the check for a missing INODE_ZEROED and do the zeroing there.

While that will initially just push the mke2fs time into the kernel, it
would likely be somewhat faster than running it from mke2fs because it
will not need any userspace memory, nor will there be any user->kernel
data copying going on.

Once you have that working, you can work on adding this to a kernel
thread that starts at mount time and stops when it has checked all
of the groups, or if the filesystem is being unmounted.  It probably
makes sense to only have one of these threads for the entire system
(instead of one per filesystem), so that they don't start crazy seeking
IO when there are multiple new partitions on a single disk.  That means
some kind of work queue with a list of superblocks and their groups to
check (so that when online resizing only the new groups are checked).


One recent thought I had was that we might want to distinguish between
filesystems that want lazy itable zeroing (i.e. real production filesystems)
and ones that don't want itable zeroing at all (i.e. filesystems for
testing or ones created on sparse loop devices that will always return
0s for unwritten blocks).  The latter is very useful for keeping image
size small, for VM images, etc.

IMHO for filesystems that want itable zeroing could just be a mke2fs
option, and the kernel detects this from groups that do not have
INODE_ZEROED set.  Filesystems that don't want any itable zeroing
should set COMPAT_LAZY_BG to tell the kernel not to zero the itable
(though the flag would be misnamed in that case).

Maybe it makes sense to keep COMPAT_LAZY_BG for filesystems that haven't
had their itables zeroed, but want it, and add a new COMPAT_NO_ZERO flag
that indicates the kernel shouldn't zero itables at all?   Ted?

> Signed-off-by: Will Drewry <redpig@dataspill.org>
> diff --git a/fs/ext4/resize.c b/fs/ext4/resize.c
> index 68b0351..faf9263 100644
> --- a/fs/ext4/resize.c
> +++ b/fs/ext4/resize.c
> @@ -261,13 +261,31 @@ static int setup_new_group_blocks(struct super_block *sb,
>  		   input->inode_bitmap - start);
>  	ext4_set_bit(input->inode_bitmap - start, bh->b_data);
> 
> -	/* Zero out all of the inode table blocks */
> +	/* Zero out all of the inode table blocks except if the fs supports lazy
> +	 * itables. */
> +	lazy = EXT4_HAS_RO_COMPAT_FEATURE(sb,
> +	         EXT4_FEATURE_RO_COMPAT_GDT_CSUM) &&

(style) This continuation should be aligned with the '(' on the previous line.

> +	       EXT4_HAS_COMPAT_FEATURE(sb, EXT4_FEATURE_COMPAT_LAZY_BG);
> +	if (lazy) {
> +		ext4_debug("lazy_bg for inode blocks "
> +			   "%#04llx (+%d) - %#04llx (+%d) ",
> +			   input->inode_table, input->inode_table - start,
> +			  input->inode_table + sbi->s_itb_per_group - 1,

(style) the indenting doesn't match (first 2 lines are correct), last one not

> +			  (input->inode_table - start) + sbi->s_itb_per_group - 1);

(style) wrap at 80 columns, or in this case, remove a few spaces to make
line 80 columns wide.

(suggestion) It might make sense to print this debug message with the
inode table geometry regardless of whether it is lazy or not, and just
indicate in the message whether it will be zeroed or not.

>  	for (i = 0, block = input->inode_table, bit = block - start;
>  	     i < sbi->s_itb_per_group; i++, bit++, block++) {
>  		struct buffer_head *it;
> 
>  		ext4_debug("clear inode block %#04llx (+%d)\n", block, bit);
> 
> +		/* Even though we don't initialize the inode table, we need
> +		 * to mark the blocks used by it for later init. */
> +		if (lazy) {
> +			ext4_set_bit(bit, bh->b_data);
> +			continue;
> +		}

(suggestion) I prefer not to do the same operation in two different parts
of the loop, as this does, since if there are other changes to the code
later the "if (lazy)" clause will get increasing code duplication.

 Better would be a conditional here that only did the loop internals if
not lazy, like:


 	for (i = 0, block = input->inode_table, bit = block - start;
 	     i < sbi->s_itb_per_group; i++, bit++, block++) {
 		struct buffer_head *it;

 		ext4_debug("clear inode block %#04llx (+%d)\n", block, bit);

		/* If the filesystem is not using lazy initialization then we
		 * need zero the inode table blocks to avoid e2fsck issues. */
		if (!lazy) {
			if ((err = extend_or_restart_transaction(handle, 1,bh)))
				goto exit_bh;

			if (IS_ERR(it = bclean(handle, sb, block))) {
				err = PTR_ERR(it);
				goto exit_bh;
			}
			ext4_handle_dirty_metadata(handle, NULL, it);
			brelse(it);
		}
		ext4_set_bit(bit, bh->b_data);
	}

It could also be an "if (lazy) goto set_bit;", but given the small size
of the conditional I think the above is still pretty readable and not
too much indented.

The rest of it looks good.

Cheers, Andreas
--
Andreas Dilger
Sr. Staff Engineer, Lustre Group
Sun Microsystems of Canada, Inc.

