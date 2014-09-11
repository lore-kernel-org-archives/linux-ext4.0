From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 2/4] ext4: validate external journal superblock checksum
Date: Thu, 11 Sep 2014 10:11:06 -0700
Message-ID: <20140911171106.GK10351@birch.djwong.org>
References: <20140911002818.10109.51772.stgit@birch.djwong.org>
 <20140911002831.10109.84707.stgit@birch.djwong.org>
 <20140911132554.GC30901@quack.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: tytso@mit.edu, linux-ext4@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:23424 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750999AbaIKRLS (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 11 Sep 2014 13:11:18 -0400
Content-Disposition: inline
In-Reply-To: <20140911132554.GC30901@quack.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Sep 11, 2014 at 03:25:54PM +0200, Jan Kara wrote:
> On Wed 10-09-14 17:28:32, Darrick J. Wong wrote:
> > If the external journal device has metadata_csum enabled, verify
> > that the superblock checksum matches the block before we try to
> > mount.
>   Looks good. You can add:
> Reviewed-by: Jan Kara <jack@suse.cz>
> 
> 								Honza
> 
> PS: On a general note the way we are checking checksums in ext4 seems to be
> a bit arbitrary. It would seem more robust to just have ext4_bread() take
> data type of the buffer and if the buffer doesn't have buffer_verified set,
> it would run appropriate checksum check on the buffer. That way we are sure
> that the buffer is checked whenever it's loaded from disk. ocfs2 and xfs
> are doing it this way...

I agree that the current setup is a rather ad-hoc... but so is ext4.
Directories have to use ext4_bread; the extent tree uses sb_getblk and
bh_submit_read; the bitmaps seem to use submit_bh; and xattrs, mmp, and the
superblock use sb_bread.

That said, if I ever get around to the optimization patch that defers metadata
checksum calculation until journal transactions are being flushed to disk, this
seems like an easy and appropriate cleanup to go along with it.

--D

> 
> > 
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > ---
> >  fs/ext4/super.c |    9 +++++++++
> >  1 file changed, 9 insertions(+)
> > 
> > 
> > diff --git a/fs/ext4/super.c b/fs/ext4/super.c
> > index 7045f1d..222ed5d 100644
> > --- a/fs/ext4/super.c
> > +++ b/fs/ext4/super.c
> > @@ -4372,6 +4372,15 @@ static journal_t *ext4_get_dev_journal(struct super_block *sb,
> >  		goto out_bdev;
> >  	}
> >  
> > +	if ((le32_to_cpu(es->s_feature_ro_compat) &
> > +	     EXT4_FEATURE_RO_COMPAT_METADATA_CSUM) &&
> > +	    es->s_checksum != ext4_superblock_csum(sb, es)) {
> > +		ext4_msg(sb, KERN_ERR, "external journal has "
> > +				       "corrupt superblock");
> > +		brelse(bh);
> > +		goto out_bdev;
> > +	}
> > +
> >  	if (memcmp(EXT4_SB(sb)->s_es->s_journal_uuid, es->s_uuid, 16)) {
> >  		ext4_msg(sb, KERN_ERR, "journal UUID does not match");
> >  		brelse(bh);
> > 
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> -- 
> Jan Kara <jack@suse.cz>
> SUSE Labs, CR
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
