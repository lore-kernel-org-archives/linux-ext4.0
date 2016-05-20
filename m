From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH] ext4: correct error value of function verifying dx
 checksum
Date: Thu, 19 May 2016 20:57:04 -0700
Message-ID: <20160520035704.GB4599@birch.djwong.org>
References: <1463702096-11386-1-git-send-email-daeho.jeong@samsung.com>
 <20160520015100.GA4586@birch.djwong.org>
 <B1B2837F-8C07-4CD2-967C-AEA8A51C05C8@dilger.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Daeho Jeong <daeho.jeong@samsung.com>, tytso@mit.edu,
	linux-ext4@vger.kernel.org
To: Andreas Dilger <adilger@dilger.ca>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:31074 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751971AbcETD5N (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 19 May 2016 23:57:13 -0400
Content-Disposition: inline
In-Reply-To: <B1B2837F-8C07-4CD2-967C-AEA8A51C05C8@dilger.ca>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, May 19, 2016 at 09:40:04PM -0600, Andreas Dilger wrote:
> On May 19, 2016, at 7:51 PM, Darrick J. Wong <darrick.wong@oracle.com> wrote:
> > 
> > On Fri, May 20, 2016 at 08:54:56AM +0900, Daeho Jeong wrote:
> >> ext4_dx_csum_verify() returns the success return value in two checksum
> >> verification failure cases. We need to set the return values to zero
> >> as failure like ext4_dirent_csum_verify() returning zero when failing
> >> to find a checksum dirent at the tail.
> 
> It would be useful to add a comment block to this function that describes
> the return values.  Clearly, if the author didn't get the return values
> correct, it seems likely that someone else may be confused in the future.
> The function itself isn't named clearly enough to know whether the return
> of "1" or "0" should be considered an error.  If it were named something
> like "ext4_dx_csum_valid()" then clearly "1" would mean it is valid and
> "0" would mean it is invalid.

<shrug> verify->valid would make the name clearer; maybe the return type
ought to be bool too.

(That said, I think I got them right; it's just my evaluation of what
counts as a soft error and what counts as a hard-error-shut-it-down have
shfited over five years.)

> > ISTR deciding back in 2011 that "can't find the checksums" wasn't a hard enough
> > error to warrant shutting down the FS.  Though, being unable to find the limit
> > and count fields of a dx node /is/ bad enough, I think.
> > 
> > 2016 me is more paranoid about soft errors, so:
> > Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
> 
> My recollection is that there are some cases where adding a checksum to an
> existing directory that didn't have enough space for the tail would leave the
> directory with no checksum?  What does e2fsck do in this case when adding
> checksums to an existing directory?  Skip the tail or split the block?

It rebuilds the entire directory. :)

--D

> 
> Cheers, Andreas
> 
> >> Signed-off-by: Daeho Jeong <daeho.jeong@samsung.com>
> >> ---
> >> fs/ext4/namei.c |    4 ++--
> >> 1 file changed, 2 insertions(+), 2 deletions(-)
> >> 
> >> diff --git a/fs/ext4/namei.c b/fs/ext4/namei.c
> >> index 48e4b89..ec811bb 100644
> >> --- a/fs/ext4/namei.c
> >> +++ b/fs/ext4/namei.c
> >> @@ -446,14 +446,14 @@ static int ext4_dx_csum_verify(struct inode *inode,
> >> 	c = get_dx_countlimit(inode, dirent, &count_offset);
> >> 	if (!c) {
> >> 		EXT4_ERROR_INODE(inode, "dir seems corrupt?  Run e2fsck -D.");
> >> -		return 1;
> >> +		return 0;
> >> 	}
> >> 	limit = le16_to_cpu(c->limit);
> >> 	count = le16_to_cpu(c->count);
> >> 	if (count_offset + (limit * sizeof(struct dx_entry)) >
> >> 	    EXT4_BLOCK_SIZE(inode->i_sb) - sizeof(struct dx_tail)) {
> >> 		warn_no_space_for_csum(inode);
> >> -		return 1;
> >> +		return 0;
> >> 	}
> >> 	t = (struct dx_tail *)(((struct dx_entry *)c) + limit);
> >> 
> >> --
> >> 1.7.9.5
> >> 
> >> --
> >> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> >> the body of a message to majordomo@vger.kernel.org
> >> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> 
> Cheers, Andreas
> 
> 
> 
> 
> 


