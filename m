From: "Darrick J. Wong" <djwong@us.ibm.com>
Subject: Re: [PATCH] ext4: ext4_dx_add_entry should dirty directory
	metadata with the directory inode
Date: Fri, 30 Sep 2011 12:44:17 -0700
Message-ID: <20110930194417.GV12086@tux1.beaverton.ibm.com>
References: <20110811211513.GL20655@tux1.beaverton.ibm.com> <ED0259FB-A818-4CAA-A72A-9164CE3769D9@dilger.ca>
Reply-To: djwong@us.ibm.com
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "Theodore Ts'o" <tytso@mit.edu>,
	linux-kernel <linux-kernel@vger.kernel.org>,
	linux-ext4 <linux-ext4@vger.kernel.org>
To: Andreas Dilger <adilger@dilger.ca>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e38.co.us.ibm.com ([32.97.110.159]:60892 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932073Ab1I3ToS (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 30 Sep 2011 15:44:18 -0400
Content-Disposition: inline
In-Reply-To: <ED0259FB-A818-4CAA-A72A-9164CE3769D9@dilger.ca>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Aug 11, 2011 at 03:41:59PM -0600, Andreas Dilger wrote:
> On 2011-08-11, at 3:15 PM, Darrick J. Wong wrote:
> > ext4_dx_add_entry manipulates bh2 and frames[0].bh, which are two buffer_heads
> > that point to directory blocks assigned to the directory inode.  However, the
> > function calls ext4_handle_dirty_metadata with the inode of the file that's
> > being added to the directory, not the directory inode itself.  Therefore,
> > correct the code to dirty the directory buffers with the directory inode, not
> > the file inode.
> 
> Interesting.  For journaled filesystems this is purely cosmetic, since
> "handle" is valid and "inode" is unused in that case.  For non-journal
> filesystems it actually affects the correctness, since this buffer may
> not be sync'd to disk even when the directory is marked "dirsync".
> 
> You can add my:
> Reviewed-by: Andreas Dilger <adilger@dilger.ca>

Hm.... any thoughts, Ted?  Will this be picked up for 3.1/3.2?

--D
> 
> > Signed-off-by: Darrick J. Wong <djwong@us.ibm.com>
> > ---
> > 
> > fs/ext4/namei.c |    4 ++--
> > 1 files changed, 2 insertions(+), 2 deletions(-)
> > 
> > diff --git a/fs/ext4/namei.c b/fs/ext4/namei.c
> > index b754b77..79ddc43 100644
> > --- a/fs/ext4/namei.c
> > +++ b/fs/ext4/namei.c
> > @@ -1589,7 +1589,7 @@ static int ext4_dx_add_entry(handle_t *handle, struct dentry *dentry,
> > 			dxtrace(dx_show_index("node", frames[1].entries));
> > 			dxtrace(dx_show_index("node",
> > 			       ((struct dx_node *) bh2->b_data)->entries));
> > -			err = ext4_handle_dirty_metadata(handle, inode, bh2);
> > +			err = ext4_handle_dirty_metadata(handle, dir, bh2);
> > 			if (err)
> > 				goto journal_error;
> > 			brelse (bh2);
> > @@ -1615,7 +1615,7 @@ static int ext4_dx_add_entry(handle_t *handle, struct dentry *dentry,
> > 			if (err)
> > 				goto journal_error;
> > 		}
> > -		err = ext4_handle_dirty_metadata(handle, inode, frames[0].bh);
> > +		err = ext4_handle_dirty_metadata(handle, dir, frames[0].bh);
> > 		if (err) {
> > 			ext4_std_error(inode->i_sb, err);
> > 			goto cleanup;
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
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
