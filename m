From: Jeff Layton <jlayton@redhat.com>
Subject: Re: [xfstests PATCH v3 1/5] generic: add a writeback error handling
 test
Date: Tue, 06 Jun 2017 16:12:58 -0400
Message-ID: <1496779978.3362.4.camel@redhat.com>
References: <20170531130820.17634-1-jlayton@redhat.com>
         <20170531130820.17634-2-jlayton@redhat.com>
         <20170606085855.GN19952@eguan.usersys.redhat.com>
         <1496744157.27183.1.camel@redhat.com>
         <20170606122325.GS19952@eguan.usersys.redhat.com>
         <20170606171703.GA5192@birch.djwong.org>
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
To: "Darrick J. Wong" <darrick.wong@oracle.com>,
        Eryu Guan <eguan@redhat.com>
Return-path: <linux-doc-owner@vger.kernel.org>
In-Reply-To: <20170606171703.GA5192@birch.djwong.org>
Sender: linux-doc-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Tue, 2017-06-06 at 10:17 -0700, Darrick J. Wong wrote:
> On Tue, Jun 06, 2017 at 08:23:25PM +0800, Eryu Guan wrote:
> > On Tue, Jun 06, 2017 at 06:15:57AM -0400, Jeff Layton wrote:
> > > On Tue, 2017-06-06 at 16:58 +0800, Eryu Guan wrote:
> > > > On Wed, May 31, 2017 at 09:08:16AM -0400, Jeff Layton wrote:
> > > > > I'm working on a set of kernel patches to change how writeback errors
> > > > > are handled and reported in the kernel. Instead of reporting a
> > > > > writeback error to only the first fsync caller on the file, I aim
> > > > > to make the kernel report them once on every file description.
> > > > > 
> > > > > This patch adds a test for the new behavior. Basically, open many fds
> > > > > to the same file, turn on dm_error, write to each of the fds, and then
> > > > > fsync them all to ensure that they all get an error back.
> > > > > 
> > > > > To do that, I'm adding a new tools/dmerror script that the C program
> > > > > can use to load the error table. For now, that's all it can do, but
> > > > > we can fill it out with other commands as necessary.
> > > > > 
> > > > > Signed-off-by: Jeff Layton <jlayton@redhat.com>
> > > > 
> > > > Thanks for the new tests! And sorry for the late review..
> > > > 
> > > > It's testing a new behavior on error reporting on writeback, I'm not
> > > > sure if we can call it a new feature or it fixed a bug? But it's more
> > > > like a behavior change, I'm not sure how to categorize it.
> > > > 
> > > > Because if it's testing a new feature, we usually let test do proper
> > > > detection of current test environment (based on actual behavior not
> > > > kernel version) and _notrun on filesystems that don't have this feature
> > > > yet, instead of failing the test; if it's testing a bug fix, we could
> > > > leave the test fail on unfixed filesystems, this also serves as a
> > > > reminder that there's bug to fix.
> > > > 
> > > 
> > > Thanks for the review! I'm not sure how to categorize this either. Since
> > > the plan is to convert all the filesystems piecemeal, maybe we should
> > > just consider it a new feature.
> > 
> > Then we need a new _require rule to properly detect for the 'feature'
> > support. I'm not sure if this is doable, but something like
> > _require_statx, _require_seek_data_hole would be good.
> > 
> > > 
> > > > I pulled your test kernel tree, and test passed on EXT4 but failed on
> > > > other local filesystems (XFS, btrfs). I assume that's expected.
> > > > 
> > > > Besides this kinda high-level question, some minor comments inline.
> > > > 
> > > 
> > > Yes, ext4 should pass on my latest kernel tree, but everything else
> > > should fail. 

Oh, and I should mention that ext2/3 also pass when mounted using ext4
driver. Legacy ext2 driver sort of works, but it reports a few too many
errors because of the way the ext2_error macro works. That shouldn't be
too hard to fix, I just need some guidance on that one.

I had xfs and btrfs working with an earlier iteration of the patches,
but now that we're converting a fs at a time, it's a little more work to
get there. It shouldn't be too hard to do though. I'll probably re-post
in a few days, and will try to take a stab at XFS and btrfs conversion
too.

> > 
> > With the new _require rule, test should _notrun on XFS and btrfs then.
> 
> Frankly I personally prefer that upstream XFS fails until someone fixes it. :)
> (But that's just my opinion.)
> 
> That said, I'm not 100% sure what's required of XFS to play nicely with
> this new mechanism -- glancing at the ext* patches it looks like we'd
> need to set a fs flag and possibly change some or all of the "write
> cached dirty buffers out to disk" calls to their _since variants?

Yeah, that's pretty much the size of it.

In fact, the latter part (changing to the _since variants) is somewhat
optional. We can have the errseq_t based tracking coexist with the
AS_EIO/AS_ENOSPC flags. It's weird but I don't see a real downside to
preserving them until we've got more of this converted over.

In the latest branch I'm working on, I'm breaking up those changes into
different patches so it should be a little clearer for other fs
maintainers to see what I'm doing and why. Stay tuned...

> Metadata writeback errors are handled by retrying writes and/or shutting
> down the fs, so I think the f_md_wb_error case is already covered.

Thanks. I think we do need f_md_wb_err for ext2/4 though, IIUC?

> 
> That said, I agree that it's useful to detect that the kernel simply
> lacks any of the new wb error reporting at all, so therefore we can skip
> the tests.
> 

Suggestions on ways to implement such a check would be welcome. Maybe a
file in /sys or in debugfs?

-- 
Jeff Layton <jlayton@redhat.com>
