From: Dmitry Monakhov <dmonakhov@openvz.org>
Subject: Re: 2.6.33-rc1: kernel BUG at fs/ext4/inode.c:1063 (sparc)
Date: Wed, 30 Dec 2009 16:18:09 +0300
Message-ID: <87k4w4vbvy.fsf@openvz.org>
References: <a4423d670912241428n6917d2adsad887548612cf8ce@mail.gmail.com>
	<a4423d670912241449y2da43d5fi3e5a18c114b84178@mail.gmail.com>
	<87hbrfdylc.fsf@openvz.org>
	<a4423d670912251133u795338a4wd32d5cdef8c36c75@mail.gmail.com>
	<87eimir4yk.fsf@openvz.org>
	<a4423d670912271232y5bb928f7wb667ca71f1a93f8a@mail.gmail.com>
	<20091227225216.GB4429@thunk.org>
	<a4423d670912271502n13957e8boc168fdc75444dc09@mail.gmail.com>
	<20091228035159.GC4429@thunk.org> <20091230053720.GK4429@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Alexander Beregalov <a.beregalov@gmail.com>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	linux-ext4@vger.kernel.org, Jens Axboe <jens.axboe@oracle.com>,
	dmitry.torokhov@gmail.com, Jan Kara <jack@suse.cz>,
	aanisimov@inbox.ru, pl4nkton@googlemail.com
To: tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-fx0-f225.google.com ([209.85.220.225]:34021 "EHLO
	mail-fx0-f225.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751760AbZL3NSQ (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 30 Dec 2009 08:18:16 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

tytso@mit.edu writes:

> On Sun, Dec 27, 2009 at 10:51:59PM -0500, tytso@MIT.EDU wrote:
>> OK, i've been able to reproduce the problem using xfsqa test #74
>> (fstest) when an ext3 file system is mounted the ext4 file system
>> driver.  I was then able to bisect it down to commit d21cd8f6, which
>> was introduced between 2.6.33-rc1 and 2.6.33-rc2, as part of
>> quota/ext4 patch series pushed by Jan.
>
> OK, here's a patch which I think should avoid the BUG in
> fs/ext4/inode.c.  It should fix the regression, but in the long run we
> need to pretty seriously rethink how we account for the need for
> potentially new meta-data blocks when doing delayed allocation.
>
> The remaining problem with this machinery is that
> ext4_da_update_reserve_space() and ext4_da_release_space() is that
> they both try to calculate how many metadata blocks will potentially
> required by calculating ext4_calc_metadata_amount() based on the
> number of delayed allocation blocks found in i_reserved_data_blocks.
> The problem is that ext4_calc_metadata_amount() assumes that the
> number of blocks passed to it is contiguous, and what might be left
> remaining to be written in the page cache could be anything but
> contiguous.  This is a problem which has always been there, so it's
> not a regression per se; just a design flaw.
Hello, I've finally able to reproduce the issue. I'm agree with your
diagnose. But while looking in to code i've found some questions
see late in the message.
>
> The patch below should fixes the regression caused by commit d21cd8f,
> but we need to look much more closely to find a better way of
> accounting for the potential need for metadata for inodes facing
> delayed allocation.  Could people who are having problems with the BUG
> in line 1063 of fs/ext4/inode.c try this patch?
>
> Thanks!!
>
>     	      	       		    	   - Ted
>
>
> commit 48b71e562ecd35ab12f6b6420a92fb3c9145da92
> Author: Theodore Ts'o <tytso@mit.edu>
> Date:   Wed Dec 30 00:04:04 2009 -0500
>
>     ext4: Patch up how we claim metadata blocks for quota purposes
>     
>     Commit d21cd8f triggered a BUG in the function
>     ext4_da_update_reserve_space() found in fs/ext4/inode.c, which was
>     caused by fact that ext4_calc_metadata_amount() can over-estimate how
>     many metadata blocks will be needed, especially when using direct
>     block-mapped files.  Work around this by not claiming any excess
>     metadata blocks than we are prepared to claim at this point.
>     
>     Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
>
> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
> index 3e3b454..d6e84b4 100644
> --- a/fs/ext4/inode.c
> +++ b/fs/ext4/inode.c
> @@ -1058,14 +1058,23 @@ static void ext4_da_update_reserve_space(struct inode *inode, int used)
>  	mdb_free = EXT4_I(inode)->i_reserved_meta_blocks - mdb;
>  
>  	if (mdb_free) {
> -		/* Account for allocated meta_blocks */
> +		/* 
> +		 * Account for allocated meta_blocks; it is possible
> +		 * for us to have allocated more meta blocks than we
> +		 * are prepared to free at this point.  This is
> +		 * because ext4_calc_metadata_amount can over-estimate
> +		 * how many blocks are still needed.  So we may not be
> +		 * able to claim all of the allocated meta blocks
> +		 * right away.  The accounting will work out in the end...
> +		 */
>  		mdb_claim = EXT4_I(inode)->i_allocated_meta_blocks;
> -		BUG_ON(mdb_free < mdb_claim);
> +		if (mdb_free < mdb_claim)
> +			mdb_claim = mdb_free;
>  		mdb_free -= mdb_claim;
>  
>  		/* update fs dirty blocks counter */
>  		percpu_counter_sub(&sbi->s_dirtyblocks_counter, mdb_free);
> -		EXT4_I(inode)->i_allocated_meta_blocks = 0;
> +		EXT4_I(inode)->i_allocated_meta_blocks -= mdb_claim;
>  		EXT4_I(inode)->i_reserved_meta_blocks = mdb;
>  	}
>  
> @@ -1845,7 +1854,7 @@ repeat:
>  static void ext4_da_release_space(struct inode *inode, int to_free)
>  {
>  	struct ext4_sb_info *sbi = EXT4_SB(inode->i_sb);
> -	int total, mdb, mdb_free, release;
> +	int total, mdb, mdb_free, mdb_claim, release;
>  
>  	if (!to_free)
>  		return;		/* Nothing to release, exit */
> @@ -1874,6 +1883,16 @@ static void ext4_da_release_space(struct inode *inode, int to_free)
>  	BUG_ON(mdb > EXT4_I(inode)->i_reserved_meta_blocks);
>  	mdb_free = EXT4_I(inode)->i_reserved_meta_blocks - mdb;
>  
> +	if (mdb_free) {
> +		/* Account for allocated meta_blocks */
> +		mdb_claim = EXT4_I(inode)->i_allocated_meta_blocks;
> +		if (mdb_free < mdb_claim)
> +			mdb_claim = mdb_free;
> +		mdb_free -= mdb_claim;
> +
> +		EXT4_I(inode)->i_allocated_meta_blocks -= mdb_claim;
> +	}
> +
Seems what this is not enough.
Just imagine, we may have following call-trace:

 userspace pwrite(fd, d, 1000, off)
 ->ext4_da_reserve_space(inode, 1000)
   ->dq_reserve_space(1000 + md_needed)
 userspace ftruncate(fd, off) /* "off"  is the same as in pwrite call */
 ->ext4_da_invalidatepage()
   ->ext4_da_page_release_reservation()
    ->ext4_da_release_space()
<<< And we decrease ->i_allocated_meta_blocks only if (mdb_free > 0)
 userspace close(fd)
So reserved metadata blocks will leak. I'm able to reproduce it like this:
 quotacheck -cu /mnt
 quotaon /mnt
 fsstres -p 16 -d /mnt -l999999999 -n99999999&
 sleep 180
 killall -9 fsstress
 sync; sync;
 cp /mnt/aquota.user > q1
 quotaoff /mnt
 quotacheck -cu /mnt/ # recaculate real quota usage.
 cp /mnt/aquota.user > q2
 diff -up q1 q2 # in my case i've found 1 block leaked.

IMHO we may drop i_allocated_meta_block in ext4_release_file()
But while looking in to this function i've found another question
about locking
static int ext4_release_file(struct inode *inode, struct file *filp)
{
	if (EXT4_I(inode)->i_state & EXT4_STATE_DA_ALLOC_CLOSE) {
		ext4_alloc_da_blocks(inode);
		EXT4_I(inode)->i_state &= ~EXT4_STATE_DA_ALLOC_CLOSE;
<<< Seems what i_state modification must being protected by i_mutex,
 but currently caller don't have to hold it.
.....                
	}

>  	release = to_free + mdb_free;
>  
>  	/* update fs dirty blocks counter for truncate case */
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
