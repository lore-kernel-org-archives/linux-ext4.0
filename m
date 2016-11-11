From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 02/11] ext4: Let S_DAX set only if DAX is really supported
Date: Fri, 11 Nov 2016 11:08:57 +0100
Message-ID: <20161111100857.GC2730@quack2.suse.cz>
References: <1478603297-11793-1-git-send-email-jack@suse.cz>
 <1478603297-11793-3-git-send-email-jack@suse.cz>
 <20161110214639.GB27200@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jan Kara <jack@suse.cz>, Ted Tso <tytso@mit.edu>,
        linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        Christoph Hellwig <hch@infradead.org>
To: Ross Zwisler <ross.zwisler@linux.intel.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:33675 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751566AbcKKKJA (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Fri, 11 Nov 2016 05:09:00 -0500
Content-Disposition: inline
In-Reply-To: <20161110214639.GB27200@linux.intel.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu 10-11-16 14:46:39, Ross Zwisler wrote:
> On Tue, Nov 08, 2016 at 12:08:08PM +0100, Jan Kara wrote:
> > Currently we have S_DAX set inode->i_flags for a regular file whenever
> > ext4 is mounted with dax mount option. However in some cases we cannot
> > really do DAX - e.g. when inode is marked to use data journalling, when
> > inode data is being encrypted, or when inode is stored inline. Make sure
> > S_DAX flag is appropriately set/cleared in these cases.
> > 
> > Signed-off-by: Jan Kara <jack@suse.cz>
> > ---
> <>
> > diff --git a/fs/ext4/super.c b/fs/ext4/super.c
> > index 20da99da0a34..b3108e6fa5f3 100644
> > --- a/fs/ext4/super.c
> > +++ b/fs/ext4/super.c
> > @@ -1126,6 +1126,10 @@ static int ext4_set_context(struct inode *inode, const void *ctx, size_t len,
> >  			ext4_set_inode_flag(inode, EXT4_INODE_ENCRYPT);
> >  			ext4_clear_inode_state(inode,
> >  					EXT4_STATE_MAY_INLINE_DATA);
> > +			/*
> > +			 * Update inode->i_flags - e.g. S_DAX may get disabled
> > +			 */
> > +			ext4_set_inode_flags(inode);
> >  		}
> >  		return res;
> >  	}
> > @@ -1140,6 +1144,7 @@ static int ext4_set_context(struct inode *inode, const void *ctx, size_t len,
> >  			len, 0);
> >  	if (!res) {
> >  		ext4_set_inode_flag(inode, EXT4_INODE_ENCRYPT);
> > +		/* Update inode->i_flags - e.g. S_DAX may get disabled */
> 
> Missing call to ext4_set_inode_flags(inode)?

Yeah, fixed. Thanks!

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
