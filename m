From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: Re: [PATCH 02/11] ext4: Let S_DAX set only if DAX is really supported
Date: Fri, 11 Nov 2016 10:56:49 -0700
Message-ID: <20161111175649.GA7958@linux.intel.com>
References: <1478603297-11793-1-git-send-email-jack@suse.cz>
 <1478603297-11793-3-git-send-email-jack@suse.cz>
 <20161110214639.GB27200@linux.intel.com>
 <20161111100857.GC2730@quack2.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Ross Zwisler <ross.zwisler@linux.intel.com>,
        Ted Tso <tytso@mit.edu>, linux-ext4@vger.kernel.org,
        linux-fsdevel@vger.kernel.org,
        Christoph Hellwig <hch@infradead.org>
To: Jan Kara <jack@suse.cz>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20161111100857.GC2730@quack2.suse.cz>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Fri, Nov 11, 2016 at 11:08:57AM +0100, Jan Kara wrote:
> On Thu 10-11-16 14:46:39, Ross Zwisler wrote:
> > On Tue, Nov 08, 2016 at 12:08:08PM +0100, Jan Kara wrote:
> > > Currently we have S_DAX set inode->i_flags for a regular file whenever
> > > ext4 is mounted with dax mount option. However in some cases we cannot
> > > really do DAX - e.g. when inode is marked to use data journalling, when
> > > inode data is being encrypted, or when inode is stored inline. Make sure
> > > S_DAX flag is appropriately set/cleared in these cases.
> > > 
> > > Signed-off-by: Jan Kara <jack@suse.cz>
> > > ---
> > <>
> > > diff --git a/fs/ext4/super.c b/fs/ext4/super.c
> > > index 20da99da0a34..b3108e6fa5f3 100644
> > > --- a/fs/ext4/super.c
> > > +++ b/fs/ext4/super.c
> > > @@ -1126,6 +1126,10 @@ static int ext4_set_context(struct inode *inode, const void *ctx, size_t len,
> > >  			ext4_set_inode_flag(inode, EXT4_INODE_ENCRYPT);
> > >  			ext4_clear_inode_state(inode,
> > >  					EXT4_STATE_MAY_INLINE_DATA);
> > > +			/*
> > > +			 * Update inode->i_flags - e.g. S_DAX may get disabled
> > > +			 */
> > > +			ext4_set_inode_flags(inode);
> > >  		}
> > >  		return res;
> > >  	}
> > > @@ -1140,6 +1144,7 @@ static int ext4_set_context(struct inode *inode, const void *ctx, size_t len,
> > >  			len, 0);
> > >  	if (!res) {
> > >  		ext4_set_inode_flag(inode, EXT4_INODE_ENCRYPT);
> > > +		/* Update inode->i_flags - e.g. S_DAX may get disabled */
> > 
> > Missing call to ext4_set_inode_flags(inode)?
> 
> Yeah, fixed. Thanks!

Cool, you can add:

Reviewed-by: Ross Zwisler <ross.zwisler@linux.intel.com>
