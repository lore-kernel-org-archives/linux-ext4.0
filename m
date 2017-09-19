From: Jeff Layton <jlayton@redhat.com>
Subject: Re: [4.14-rc1 bug] fstests generic/441 failure on ext2
Date: Tue, 19 Sep 2017 11:09:11 -0400
Message-ID: <1505833751.28765.5.camel@redhat.com>
References: <20170918112312.GN8034@eguan.usersys.redhat.com>
         <1505736624.5567.21.camel@redhat.com>
         <20170919145727.GA5540@quack2.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: Eryu Guan <eguan@redhat.com>, linux-fsdevel@vger.kernel.org,
        linux-ext4@vger.kernel.org, Jan Kara <jack@suse.com>
To: Jan Kara <jack@suse.cz>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <20170919145727.GA5540@quack2.suse.cz>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Tue, 2017-09-19 at 16:57 +0200, Jan Kara wrote:
> On Mon 18-09-17 08:10:24, Jeff Layton wrote:
> > On Mon, 2017-09-18 at 19:23 +0800, Eryu Guan wrote:
> > > Hi all,
> > > 
> > > With ext2 driven by ext4 module (or ext4 without journal, I haven't
> > > tested ext2 module, but I guess the result is the same), v4.14-rc1
> > > kernel starts to fail fstests generic/441 as:
> > > 
> > > +First fsync after reopen of fd[0] failed: Input/output error
> > > 
> > > git bisect shows that this is uncovered by commit ffb959bbdf92 ("mm:
> > > remove optimizations based on i_size in mapping writeback waits"), which
> > > removed (i_size == 0) check in filemap_fdatawait().
> > > 
> > > I say "uncovered" because test fails with 4.13 kernel too if we re-open
> > > the test file without O_TRUNC flag in src/fsync-err.c (so file size is
> > > not zero, and fails the i_size == 0 check).
> > > 
> > > The EIO was returned by sync_inode_metadata() in __generic_file_fsync(),
> > > the call trace is like:
> > > 
> > > do_fsync
> > >  vfs_fsync_range
> > >   ext4_sync_file
> > >    __generic_file_fsync
> > >     sync_inode_metadata
> > >      writeback_single_inode
> > >       __writeback_single_inode
> > >        filemap_fdatawait  => EIO here
> > > 
> > > Thanks,
> > > Eryu
> > 
> > (cc'ing Jan and linux-fsdevel)
> > 
> > Thanks for the bug report. The analysis looks spot-on.
> > 
> > So yeah...we have this "legacy" filemap_fdatawait call in
> > __writeback_single_inode, and that is returning -EIO, likely because
> > AS_EIO was set on the inode from the earlier wb errors.
> > 
> > That error return is pretty sketchy since it could be cleared at any
> > time, and pretty much everything we care about here is now using
> > errseq_t for error reporting at fsync. I don't think we really care too
> > much about that flag in this codepath anymore.
> 
> So I agree fsync(2) path is covered but that fdatawait() call is also
> responsible for reporting error e.g. for write_inode_now() calls and there
> we still have some unconverted users. So for now I don't have a better
> solution than to live with this additional somewhat stale EIO error. Or
> possibly we can have truncate to 0 clear writeback error which would mask
> the problem again and kind of makes sense...
> 
> 

Another thought would be to have file_check_and_advance_wb_err (and
maybe filemap_check_wb_err) also clear AS_EIO and AS_ENOSPC. That sort
of makes sense since legacy users would have cleared those flags.

I had a patch that did that at one point, but dropped it since it didn't
seem necessary. That might be the best fix for this though.
-- 
Jeff Layton <jlayton@redhat.com>
