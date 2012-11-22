From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 4/4] ext3: Warn if mounting rw on a disk requiring stable
 page writes
Date: Fri, 23 Nov 2012 10:15:15 +1100
Message-ID: <20121122231515.GW2591@dastard>
References: <20121121020027.10225.43206.stgit@blackbox.djwong.org>
 <20121121020056.10225.15220.stgit@blackbox.djwong.org>
 <20121121021543.GI10507@quack.suse.cz>
 <20121121211319.GA32202@blackbox.djwong.org>
 <20121121213333.GF30250@quack.suse.cz>
 <20121122084713.69e5b1fc@notabene.brown>
 <20121122014755.GH8740@blackbox.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: NeilBrown <neilb@suse.de>, Jan Kara <jack@suse.cz>,
	axboe@kernel.dk, lucho@ionkov.net, ericvh@gmail.com, tytso@mit.edu,
	rminnich@sandia.gov, viro@zeniv.linux.org.uk,
	martin.petersen@oracle.com, linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, adilger.kernel@dilger.ca,
	bharrosh@panasas.com, jlayton@samba.org,
	v9fs-developer@lists.sourceforge.net, linux-ext4@vger.kernel.org
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20121122014755.GH8740@blackbox.djwong.org>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Wed, Nov 21, 2012 at 05:47:55PM -0800, Darrick J. Wong wrote:
> On Thu, Nov 22, 2012 at 08:47:13AM +1100, NeilBrown wrote:
> > On Wed, 21 Nov 2012 22:33:33 +0100 Jan Kara <jack@suse.cz> wrote:
> > 
> > > On Wed 21-11-12 13:13:19, Darrick J. Wong wrote:
> > > > On Wed, Nov 21, 2012 at 03:15:43AM +0100, Jan Kara wrote:
> > > > > On Tue 20-11-12 18:00:56, Darrick J. Wong wrote:
> > > > > > ext3 doesn't properly isolate pages from changes during writeback.  Since the
> > > > > > recommended fix is to use ext4, for now we'll just print a warning if the user
> > > > > > tries to mount in write mode.
> > > > > > 
> > > > > > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > > > > > ---
> > > > > >  fs/ext3/super.c |    8 ++++++++
> > > > > >  1 file changed, 8 insertions(+)
> > > > > > 
> > > > > > 
> > > > > > diff --git a/fs/ext3/super.c b/fs/ext3/super.c
> > > > > > index 5366393..5b3725d 100644
> > > > > > --- a/fs/ext3/super.c
> > > > > > +++ b/fs/ext3/super.c
> > > > > > @@ -1325,6 +1325,14 @@ static int ext3_setup_super(struct super_block *sb, struct ext3_super_block *es,
> > > > > >  			"forcing read-only mode");
> > > > > >  		res = MS_RDONLY;
> > > > > >  	}
> > > > > > +	if (!read_only &&
> > > > > > +	    queue_requires_stable_pages(bdev_get_queue(sb->s_bdev))) {
> > > > > > +		ext3_msg(sb, KERN_ERR,
> > > > > > +			"error: ext3 cannot safely write data to a disk "
> > > > > > +			"requiring stable pages writes; forcing read-only "
> > > > > > +			"mode.  Upgrading to ext4 is recommended.");
> > > > > > +		res = MS_RDONLY;
> > > > > > +	}
> > > > > >  	if (read_only)
> > > > > >  		return res;
> > > > > >  	if (!(sbi->s_mount_state & EXT3_VALID_FS))
> > > > >   Why this? ext3 should be fixed by your change to
> > > > > filemap_page_mkwrite()... Or does testing show otherwise?
> > > > 
> > > > Yes, it's still broken even with this new set of changes.  Now that I think
> > > > about it a little more, I recall that writeback mode was actually fine, so this
> > > > is a little harsh.
> > > > 
> > > > Hm... looking at the ordered code a little more, it looks like
> > > > ext3_ordered_write_end is calling journal_dirty_data_fn, which (I guess?) tries
> > > > to write mapped buffers back through the journal?  Taking it out seems to fix
> > > > ordered mode, though I have a suspicion that it might very well break ordered
> > > > mode too.
> > >   Oh, right. kjournald writing buffers directly (without setting
> > > PageWriteback) will break things. So please, change warning to:
> 
> Maybe we should just fix this anyway?
> 
> I still have the patch that adds PG_stable (and changes the

Page flags are in short supply. If you need a page flag to fix a bug
in a single filesytem, there's a couple of reserved private page
flags that can be used. i.e PG_owner_priv_1. I don't think using a
glbal page flag for just this purpose will fly, though...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
