From: Jeff Layton <jlayton@redhat.com>
Subject: Re: [xfstests PATCH v3 5/5] btrfs: allow it to use $SCRATCH_LOGDEV
Date: Thu, 08 Jun 2017 08:48:07 -0400
Message-ID: <1496926087.12725.1.camel@redhat.com>
References: <20170531130820.17634-1-jlayton@redhat.com>
         <20170531130820.17634-6-jlayton@redhat.com>
         <20170606091930.GR19952@eguan.usersys.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: fstests@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Al Viro <viro@ZenIV.linux.org.uk>, Jan Kara <jack@suse.cz>,
        tytso@mit.edu, axboe@kernel.dk, mawilcox@microsoft.com,
        ross.zwisler@linux.intel.com, corbet@lwn.net, dhowells@redhat.com,
        linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-block@vger.kernel.org,
        linux-doc@vger.kernel.org
To: Eryu Guan <eguan@redhat.com>
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20170606091930.GR19952@eguan.usersys.redhat.com>
Sender: linux-block-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Tue, 2017-06-06 at 17:19 +0800, Eryu Guan wrote:
> On Wed, May 31, 2017 at 09:08:20AM -0400, Jeff Layton wrote:
> > With btrfs, we can't really put the log on a separate device. What we
> > can do however is mirror the metadata across two devices and make the
> > data striped across all devices. When we turn on dmerror then the
> > metadata can fall back to using the other mirror while the data errors
> > out.
> > 
> > Note that the current incarnation of btrfs has a fixed 64k stripe
> > width. If that ever changes or becomes settable, we may need to adjust
> > the amount of data that the test program writes.
> > 
> > Signed-off-by: Jeff Layton <jlayton@redhat.com>
> > ---
> >  common/rc | 2 ++
> >  1 file changed, 2 insertions(+)
> > 
> > diff --git a/common/rc b/common/rc
> > index 83765aacfb06..078270451b53 100644
> > --- a/common/rc
> > +++ b/common/rc
> > @@ -830,6 +830,8 @@ _scratch_mkfs()
> >  		;;
> >  	btrfs)
> >  		mkfs_cmd="$MKFS_BTRFS_PROG"
> > +		[ "$USE_EXTERNAL" = yes -a ! -z "$SCRATCH_LOGDEV" ] && \
> > +			mkfs_cmd="$mkfs_cmd -d raid0 -m raid1 $SCRATCH_LOGDEV"
> 
> I don't think this is the correct way to do it. If btrfs doesn't support
> external log device, then this test doesn't fit btrfs, or we need other
> ways to test btrfs.
> 
> One of the problems of this hack is that raid1 requires all devices are
> in the same size, we have a _require_scratch_dev_pool_equal_size() rule
> to check on it, but this hack doesn't do the proper check and test fails
> if SCRATCH_LOGDEV is smaller or bigger in size.
> 
> If btrfs "-d raid0 -m raid1" is capable to do this writeback error test,
> perhaps you can write a new btrfs test and mkfs with "-d raid0 -m raid1"
> explicitly. e.g.
> 
> ...
> _require_scratch_dev_pool 2
> _require_scratch_dev_pool_equal_size
> ...
> _scratch_mkfs "-d raid0 -m raid1"
> ...
> 
> Thanks,
> Eryu


Yeah, that's probably the right way to do this. It looks like btrfs also
has $SCRATCH_DEV_POOL, and we can probably base it on that. I'll look at
reworking it.

-- 
Jeff Layton <jlayton@redhat.com>
