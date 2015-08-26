From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 15/19] resize2fs: Remove duplicit condition
Date: Wed, 26 Aug 2015 18:12:46 +0200
Message-ID: <20150826161246.GG14012@quack.suse.cz>
References: <1438944689-24562-1-git-send-email-jack@suse.com>
 <1438944689-24562-16-git-send-email-jack@suse.com>
 <F991A313-0FC4-4C42-8196-88050EDDB038@dilger.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jan Kara <jack@suse.com>, linux-ext4@vger.kernel.org,
	Ted Tso <tytso@mit.edu>,
	"Darrick J. Wong" <darrick.wong@oracle.com>
To: Andreas Dilger <adilger@dilger.ca>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:32904 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756899AbbHZQMv (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 26 Aug 2015 12:12:51 -0400
Content-Disposition: inline
In-Reply-To: <F991A313-0FC4-4C42-8196-88050EDDB038@dilger.ca>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri 07-08-15 13:01:13, Andreas Dilger wrote:
> On Aug 7, 2015, at 4:51 AM, Jan Kara <jack@suse.com> wrote:
> > Subject: [PATCH 15/19] resize2fs: Remove duplicit condition
> 
> 
> Minor typo - s/duplicit/duplicate/

Thanks. Fixed.

								Honza

> 
> > Signed-off-by: Jan Kara <jack@suse.com>
> > ---
> > resize/resize2fs.c | 12 +-----------
> > 1 file changed, 1 insertion(+), 11 deletions(-)
> > 
> > diff --git a/resize/resize2fs.c b/resize/resize2fs.c
> > index 9a8be30bbce1..22300836300d 100644
> > --- a/resize/resize2fs.c
> > +++ b/resize/resize2fs.c
> > @@ -682,19 +682,9 @@ static errcode_t adjust_superblock(ext2_resize_t rfs, blk64_t new_size)
> > 	}
> > 
> > 	/*
> > -	 * If we are shrinking the number block groups, we're done and
> > +	 * If we are not increasing the number block groups, we're done and
> > 	 * can exit now.
> > 	 */
> > -	if (rfs->old_fs->group_desc_count > fs->group_desc_count) {
> > -		retval = 0;
> > -		goto errout;
> > -	}
> > -
> > -	/*
> > -	 * If the number of block groups is staying the same, we're
> > -	 * done and can exit now.  (If the number block groups is
> > -	 * shrinking, we had exited earlier.)
> > -	 */
> > 	if (rfs->old_fs->group_desc_count >= fs->group_desc_count) {
> > 		retval = 0;
> > 		goto errout;
> > -- 
> > 2.1.4
> > 
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
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
