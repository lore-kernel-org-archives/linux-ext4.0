From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 2/3] common: Improve _link_output_file to be more
 versatile
Date: Mon, 21 Dec 2015 11:34:23 +1100
Message-ID: <20151221003423.GN19802@dastard>
References: <1448361598-28438-1-git-send-email-jack@suse.cz>
 <1448361598-28438-3-git-send-email-jack@suse.cz>
 <20151207232619.GC3094@thunk.org>
 <20151209122707.GE3137@quack.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Theodore Ts'o <tytso@mit.edu>, fstests@vger.kernel.org,
	linux-ext4@vger.kernel.org, Jan Kara <jack@suse.com>
To: Jan Kara <jack@suse.cz>
Return-path: <fstests-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20151209122707.GE3137@quack.suse.cz>
Sender: fstests-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Wed, Dec 09, 2015 at 01:27:07PM +0100, Jan Kara wrote:
> On Mon 07-12-15 18:26:19, Ted Tso wrote:
> > On Tue, Nov 24, 2015 at 11:39:57AM +0100, Jan Kara wrote:
> > > From: Jan Kara <jack@suse.com>
> > > 
> > > Currently _link_output_file() selects output file suffix based on the
> > > current operating system. Make it more versatile by allowing selection
> > > of output file suffix based on any feature string. The idea is that
> > > in config file ($seq.cfg) there are several lines like:
> > > 
> > > feat1,feat2: suffix
> > > 
> > > The function is passed a feature string (or uses os_name,MOUNT_OPTIONS
> > > if no argument is passed) and selects output file with a suffix for
> > > which all features are present in the feature string. If there is no
> > > matching line, output with 'default' suffix is selected.
> > > 
> > > Update all tests using _link_out_file to the new calling convention.
> > > 
> > > Signed-off-by: Jan Kara <jack@suse.com>
> > 
> > I made a slight change so that if $seqfull.cfg doesn't exist, we use
> > ./common/default.cfg instead.  This avoids the need to create a large
> > number of identical files:
> > 
> > >  tests/generic/088.cfg       |   2 +
> > >  tests/xfs/018.cfg           |   2 +
> > >  tests/xfs/022.cfg           |   2 +
> > >  tests/xfs/023.cfg           |   2 +
> > >  tests/xfs/030.cfg           |   2 +
> > >  tests/xfs/031.cfg           |   2 +
> > >  tests/xfs/035.cfg           |   2 +
> > >  tests/xfs/036.cfg           |   2 +
> > >  tests/xfs/039.cfg           |   2 +
> > >  tests/xfs/043.cfg           |   2 +
> > >  tests/xfs/082.cfg           |   2 +
> > >  tests/xfs/146.cfg           |   2 +
> > 
> > What do you think?
> 
> So I'm somewhat undecided whether this is better or not ;). It certainly
> saves us some churn with identical .cfg files for linux vs irix configs
> but OTOH I don't expect there to be much more .cfg files selecting between
> irix and linux so this is mostly one-time issue. So I guess I'll leave it
> upto Dave and his taste to decide what he finds better.

I'll take the one-time change here, but as Christoph suggested it
really is getting to the point where we should stop considering
xfstests to be a cross-platform test suite. Just another cleanup to
be done...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
