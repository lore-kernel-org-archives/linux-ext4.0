From: Lukas Czerner <lczerner@redhat.com>
Subject: Re: [PATCH 1/2] e2fsck: Discard only unused parts of inode table
Date: Thu, 23 Feb 2012 14:05:29 +0100 (CET)
Message-ID: <alpine.LFD.2.00.1202231044410.7723@dhcp-27-109.brq.redhat.com>
References: <1329840132-16808-1-git-send-email-lczerner@redhat.com> <4F458D99.30802@redhat.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Lukas Czerner <lczerner@redhat.com>, linux-ext4@vger.kernel.org,
	tytso@mit.edu, psusi@ubuntu.com
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:56995 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752218Ab2BWNFg (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 23 Feb 2012 08:05:36 -0500
In-Reply-To: <4F458D99.30802@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, 22 Feb 2012, Eric Sandeen wrote:

> On 2/21/12 10:02 AM, Lukas Czerner wrote:
> > When calling e2fsck with '-E discard' option it might happen that
> > valid inodes are discarded accidentally. This is because we just
> > discard the part of inode table which lies past the highest used
> > inode. This is terribly wrong (sorry!).
> > 
> > This patch fixes it so only the free parts of an inode table
> > is discarded, leaving used inodes intact. This was tested with highly
> > fragmented inode tables with block size 4k and 1k.
> > 
> > Signed-off-by: Lukas Czerner <lczerner@redhat.com>
> > Reported-by: Phillip Susi <psusi@ubuntu.com>
> > ---
> >  e2fsck/pass5.c |   59 +++++++++++++++++++++++++++++++++++--------------------
> >  1 files changed, 37 insertions(+), 22 deletions(-)
> > 
> > diff --git a/e2fsck/pass5.c b/e2fsck/pass5.c
> > index 1e836e3..9cc4a20 100644
> > --- a/e2fsck/pass5.c
> > +++ b/e2fsck/pass5.c
> > @@ -94,6 +94,26 @@ static void e2fsck_discard_blocks(e2fsck_t ctx, io_manager manager,
> >  		ctx->options &= ~E2F_OPT_DISCARD;
> >  }
> 
> I could really use a comment here.  Is "start" the inode nr within
> the group?  Is the first inode in the group 0 or 1?  The calling
> function's loop starts at inode 1 ... but based on some testing
> it looks like you call the first free inode in an empty group
> "inode 0" so I'll assume that, but comments please.

Yes, it should be that way. I'll comment it.

> 
> 
> > +static void e2fsck_discard_inodes(e2fsck_t ctx, int group,
> > +				  int start, int count)
> 
> I'm not sure if ints are good here, but it's what the calling
> function uses, I guess.

Unfortunately it is a bit messy, but this is only within one group so
int should be enough.

> 
> > +{
> > +	ext2_filsys fs = ctx->fs;
> > +	blk64_t blk, num;
> > +
> > +	/*
> > +	 * We can discard only blocks containing only unused
> > +	 * inodes in the table.
> > +	 */
> > +	blk = DIV_ROUND_UP(start,
> > +		EXT2_INODES_PER_BLOCK(fs->super));
> > +	count -= (blk * EXT2_INODES_PER_BLOCK(fs->super) - start);
> > +	blk += ext2fs_inode_table_loc(fs, group);
> > +	num = count / EXT2_INODES_PER_BLOCK(fs->super);
> > +
> > +	if (num > 0)
> > +		e2fsck_discard_blocks(ctx, fs->io->manager, blk, num);
> > +}
> 
> I can't make intuitive sense of that at all, and had to count on my fingers
> and draw diagrams.  Maybe it's just my old brain.  :(

No worries, I needed to use diagrams like that as well ;).

> 
> Let's say we have 4 inode blocks in this table, with
> 1 == used, 0 == unused, and we start counting inodes at 0.
> 
> |1111111100000000|0000000000000000|0000000000000000|0000000000000001|
>  012345678 <- start
> 
> so start = 8, count = 55 (note one inode used at the end)
> 
> In this case we should get:
> 
> blk = 1 (DIV_ROUND_UP(8, 16)) - ok, that's next block after the partial block
> count = 55 - ((1 * 16) - 8) = 47
> num = 47 / 16 = 2
> 
> Ok, so that works, assuming the first inode in the group is "0"
> 
> We can make a filesystem kind of like that, to test it:
> 
> # mkfs.ext4 -I 256 -b 4096 -N 256 -G 1 -g 256 /dev/loop0 1024

This does not have anything to do with this patch, but just out of
curiosity try this:

mkfs.ext4 -I 256 -b 4096 -N 256 -G 1 -g 256 /dev/loop0 1024
mount /dev/loop0 /mnt/test
mkdir /mnt/test/dir
for i in $(seq 17); do touch /mnt/test/dir/$i; done
umount /mnt/test
fsck.ext4 -fn /dev/loop0

You'll be surprised :)


> 
> with 4 groups each having 64 inodes.
> 
> If I run a e2fsck -E discard on that fresh filesystem, with some debugging, I see:
> 
> Pass 5: Checking group summary information
> got start 12 count 51; count reduced to 47 inodes, discarding 2 blocks starting at block 36
> 
> Ok, that is a little weird; on a fresh filesystem lost+found/ is 11, so the first free
> inode is 12; but now we seem to have started counting at 1, not 0?
> 
> got start 0 count 63; count reduced to 63 inodes, discarding 3 blocks starting at block 291
> got start 0 count 63; count reduced to 63 inodes, discarding 3 blocks starting at block 514
> got start 0 count 63; count reduced to 63 inodes, discarding 3 blocks starting at block 803
> 
> Oh, now we're back to "the first inode in the group is 0"  :(
> 
> And here it looks like we are not discarding all the free blocks in the completely-free tables;
> the last group has:
> 
>   Inode table at 803-806 (+35)
>   217 free blocks, 64 free inodes, 0 directories, 64 unused inodes
> 
> but we only discarded 803 through 805, for example, because we were only told to discard
> 63 inodes, not 64 as I'd have expected since 64 are free.
> 
> I can't really make heads or tails out of how we got here, the calling function is so
> messy it's really hard for me to keep track of.  I think perhaps a clean up series
> for the calling function first, and then we can try to properly extend it...?
> 
> I think we need ultra-careful attention to which variables are 0-based and which
> are 1-based, for starters.

You're right. There is a problem that we might discard one
block less because of:

                       if (first_free > inodes)
                               first_free = inodes;

which should really be

                       if (first_free > inodes - 1)
                               first_free = inodes - 1;

The reason is that inodes variable starts from 1. But we really need the
first_free inode to be counted from 0. Then the rest of the code should
be fine.

I was probably confused by the output of dumpe2fs which counts inodes
from 1.

But anyway, I think that the best would be to just comply with the inode
number counting (start from 1) and then just adjust start in
e2fsck_discard_inodes(). I think that it would be more obvious.

> 
> For e2fsck_discard_inodes() I wonder if it could be made more intuitive by:
> 
> 1) find first totally free block based on start
> 2) find last totally free block based on the last free inode (start+count-1)
> 3) find free block length, free_length = last_blk - first_blk + 1
> 4) e2fsck_discard_blocks(..., ..., first_blk, free_length);
> 
> i.e. get rid of the count -= ...
> 
> _assuming_ we start counting at 0:
> 
> 	/* round up to next block after a partially free one */
> 	first_blk = DIV_ROUND_UP(start,
> 		EXT2_INODES_PER_BLOCK(fs->super));
> 	first_blk += ext2fs_inode_table_loc(fs, group);
> 
> 	last_free_inode = start + count - 1;
> 
> 	/* round down to block before a partially free one */
> 	last_blk = last_free_inode / EXT2_INODES_PER_BLOCK(fs->super));
> 	free_blks = last_blk - first_blk + 1;
> 	if (free_blks > 0)
> 		e2fsck_discard_blocks(ctx, fs->io->manager, first_blk, free_blks);
> 
> I probably have off-by-ones there too, but you get the idea...

Well, the readability is better, however we can not do this. The reason
is that on the level of granularity of blocks when (last_blk == first_blk)
there is no way to say if the blocks has been entirely free or not.

So we need to do this:

1. Adjust the start (start -= 1) - because we pass inode number into the
function which starts with 1.
2. find first totally free block based on start
3. Adjust the count by the number of free inodes we skipped to find
first totally free block.
4. Compute number of totally free blocks from count
5. e2fsck_discard_blocks

And it is actually what I did in this patch, except the changes I
described above.

What do you think ? Do you agree with this approach ?

Thanks!
-Lukas

> 
> -Eric
> 
> > +
> >  #define NO_BLK ((blk64_t) -1)
> >  
> >  static void print_bitmap_problem(e2fsck_t ctx, int problem,
> > @@ -422,6 +442,7 @@ static void check_inode_bitmaps(e2fsck_t ctx)
> >  	ext2_ino_t	i;
> >  	unsigned int	free_inodes = 0;
> >  	int		group_free = 0;
> > +	int		first_free = fs->super->s_inodes_per_group;
> >  	int		dirs_count = 0;
> >  	int		group = 0;
> >  	unsigned int	inodes = 0;
> > @@ -497,6 +518,7 @@ redo_counts:
> >  				 * are 0, count the free inode,
> >  				 * skip the current block group.
> >  				 */
> > +				first_free = 0;
> >  				inodes = fs->super->s_inodes_per_group - 1;
> >  				group_free = inodes;
> >  				free_inodes += inodes;
> > @@ -561,37 +583,27 @@ redo_counts:
> >  		ctx->options &= ~E2F_OPT_DISCARD;
> >  
> >  do_counts:
> > +		inodes++;
> >  		if (bitmap) {
> >  			if (ext2fs_test_inode_bitmap2(ctx->inode_dir_map, i))
> >  				dirs_count++;
> > +			if (inodes - 1 > first_free) {
> > +				e2fsck_discard_inodes(ctx, group, first_free,
> > +						      inodes - first_free - 1);
> > +				first_free = fs->super->s_inodes_per_group;
> > +			}
> >  		} else if (!skip_group || csum_flag) {
> >  			group_free++;
> >  			free_inodes++;
> > +			if (first_free > inodes)
> > +				first_free = inodes;
> >  		}
> >  
> > -		inodes++;
> >  		if ((inodes == fs->super->s_inodes_per_group) ||
> >  		    (i == fs->super->s_inodes_count)) {
> > -
> > -			free_array[group] = group_free;
> > -			dir_array[group] = dirs_count;
> > -
> > -			/* Discard inode table */
> > -			if (ctx->options & E2F_OPT_DISCARD) {
> > -				blk64_t used_blks, blk, num;
> > -
> > -				used_blks = DIV_ROUND_UP(
> > -					(EXT2_INODES_PER_GROUP(fs->super) -
> > -					group_free),
> > -					EXT2_INODES_PER_BLOCK(fs->super));
> > -
> > -				blk = ext2fs_inode_table_loc(fs, group) +
> > -				      used_blks;
> > -				num = fs->inode_blocks_per_group -
> > -				      used_blks;
> > -				e2fsck_discard_blocks(ctx, manager, blk, num);
> > -			}
> > -
> > +			if (inodes - 1 > first_free)
> > +				e2fsck_discard_inodes(ctx, group, first_free,
> > +						      inodes - first_free - 1);
> >  			/*
> >  			 * If discard zeroes data and the group inode table
> >  			 * was not zeroed yet, set itable as zeroed
> > @@ -599,12 +611,15 @@ do_counts:
> >  			if ((ctx->options & E2F_OPT_DISCARD) &&
> >  			    (io_channel_discard_zeroes_data(fs->io)) &&
> >  			    !(ext2fs_bg_flags_test(fs, group,
> > -						  EXT2_BG_INODE_ZEROED))) {
> > +						   EXT2_BG_INODE_ZEROED))) {
> >  				ext2fs_bg_flags_set(fs, group,
> >  						    EXT2_BG_INODE_ZEROED);
> >  				ext2fs_group_desc_csum_set(fs, group);
> >  			}
> >  
> > +			first_free = fs->super->s_inodes_per_group;
> > +			free_array[group] = group_free;
> > +			dir_array[group] = dirs_count;
> >  			group ++;
> >  			inodes = 0;
> >  			skip_group = 0;
> 
> 

-- 
