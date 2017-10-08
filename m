From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] ext4/026: skip test if kernel does not support the
 ea_inode feature
Date: Mon, 9 Oct 2017 09:40:10 +1100
Message-ID: <20171008224010.GY15067@dastard>
References: <20171008192324.20477-1-tytso@mit.edu>
 <20171008214117.GU15067@dastard>
 <20171008215110.qxhel7nkcsifybu2@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: fstests@vger.kernel.org,
        Ext4 Developers List <linux-ext4@vger.kernel.org>
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <fstests-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20171008215110.qxhel7nkcsifybu2@thunk.org>
Sender: fstests-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Sun, Oct 08, 2017 at 05:51:10PM -0400, Theodore Ts'o wrote:
> On Mon, Oct 09, 2017 at 08:41:17AM +1100, Dave Chinner wrote:
> > On Sun, Oct 08, 2017 at 03:23:24PM -0400, Theodore Ts'o wrote:
> > > Signed-off-by: Theodore Ts'o <tytso@mit.edu>
> > > ---
> > >  tests/ext4/026 | 3 ++-
> > >  1 file changed, 2 insertions(+), 1 deletion(-)
> > > 
> > > diff --git a/tests/ext4/026 b/tests/ext4/026
> > > index 94a737ce..ba77f36e 100755
> > > --- a/tests/ext4/026
> > > +++ b/tests/ext4/026
> > > @@ -53,7 +53,8 @@ _require_attrs
> > >  _require_ext4_mkfs_feature ea_inode
> > >  
> > >  _scratch_mkfs_ext4 -O ea_inode >/dev/null 2>&1
> > > -_scratch_mount
> > > +_scratch_mount >/dev/null 2>&1 \
> > > +	|| _notrun "kernel doesn't support ea_inode feature on $FSTYP"
> > 
> > Needs to be in a _requires check?
> 
> There's only one test currently testing ea_inode at the moment, but
> sure, I can make it into a _requires check.

I note there's a _require_ext4_mkfs_feature check above. Perhaps
just turn that into a _require_ext4_feature that checks both mkfs
and whether the kernel supports the functionality? That's typically
what we've done in the past - one _require rule to check all
aspects of support needed to use the feature...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
