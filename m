From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH] ext4: Return error if we fail to allocate block in
	noalloc_get_block_write
Date: Tue, 7 Jul 2009 19:18:07 +0200
Message-ID: <20090707171807.GD24457@duck.suse.cz>
References: <1246441575-20311-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <20090701095636.GB20540@skywalker>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: cmm@us.ibm.com, tytso@mit.edu, sandeen@redhat.com,
	Jan Kara <jack@suse.cz>, linux-ext4@vger.kernel.org
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor.suse.de ([195.135.220.2]:42938 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754909AbZGGRSM (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 7 Jul 2009 13:18:12 -0400
Content-Disposition: inline
In-Reply-To: <20090701095636.GB20540@skywalker>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed 01-07-09 15:26:36, Aneesh Kumar K.V wrote:
> On Wed, Jul 01, 2009 at 03:16:15PM +0530, Aneesh Kumar K.V wrote:
> > block_write_full_page consider a zero return from get_block as success.
> > noalloc_get_block_write returned zero even if we failed to find a mapping
> > blocks. Returning non zero ensures we fallback to the error handling path
> > of block_write_full_page which would properly redirty the page after
> > the below patch is applied.
> > 
> > http://article.gmane.org/gmane.linux.file-systems/33145
> > 
> > Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
> > ---
> > 
> > NOTE: I am not sure whether -EGAIN is the right error to be returned error.
> > This patch should enable us to push the pending ext4 patches in the patch
> > queue without depending on the full series from Jan. Will reply to this
> > email with patch ordering.
> > 
> >  fs/ext4/inode.c |    5 ++++-
> >  1 files changed, 4 insertions(+), 1 deletions(-)
> > 
> > diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
> > index 25638bc..6c814af 100644
> > --- a/fs/ext4/inode.c
> > +++ b/fs/ext4/inode.c
> > @@ -2514,7 +2514,10 @@ static int noalloc_get_block_write(struct inode *inode, sector_t iblock,
> >  	if (ret > 0) {
> >  		bh_result->b_size = (ret << inode->i_blkbits);
> >  		ret = 0;
> > -	}
> > +	} else if (create && ret == 0)
> > +		/* write request on unmapped buffer head. */
> > +		ret = -EAGAIN;
> > +
> >  	return ret;
> >  }
> > 
> 
> The patch ordering I tested this with was
> + stable-boundary
> + stable-boundary-undo.patch
> + jan-kara-dont-clear-dirty-bits-in-block_write_full_page
> + dont-look-at-buffer_heads-outside-i_size
> + fix-mmap-truncate-race-with-subpage-blocksize
> + 01.patch  <=============================================== This is the  above patch
> + fix-mmap-truncate-race-with-nondelalloc
> + move-__ext4_journaled-writepage-function
> + add-WARN_ON-with-unmapped-dirty-bh-in-writepage
> + vfs-jan-kara-page_mkwrite-infrastructure
> + allocate-blocks-correctly-with-subpage-blocksize
> > jan-kara-unmap-underlying-metadata-of-new-buffers-only-when-mapped
> 
> Now with jan-kara-dont-clear-dirty-bits-in-block_write_full_page
> block_write_full_page will redirty the page when get_block fails. That
> would ensure that we don't drop the pages if we find unmapped
> buffer_heads in the writepage callback. The patch 
> fix-mmap-truncate-race-with-subpage-blocksize actually  pass pages with
> unmapped buffer heads to block_write_full_page.
> 
> This also means we can push patches upto
> move-__ext4_journaled-writepage-function to upstream in 2.6.31
> 
> I am yet to run the full patch set on ABAT. So the patches had limited
> testing.
  Yes, this looks as a good solution to me since Nick had some objections
to later patches in my patchset so they probably won't get merged for
2.6.31...

									Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
