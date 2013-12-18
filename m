From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH v3 0/3] Add XIP support to ext4
Date: Wed, 18 Dec 2013 23:33:19 +1100
Message-ID: <20131218123319.GH31386@dastard>
References: <cover.1387307259.git.matthew.r.wilcox@intel.com>
 <20131217223050.GB20579@dastard>
 <20131218023143.GA24491@parisc-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Matthew Wilcox <matthew.r.wilcox@intel.com>,
	linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20131218023143.GA24491@parisc-linux.org>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Tue, Dec 17, 2013 at 07:31:43PM -0700, Matthew Wilcox wrote:
> On Wed, Dec 18, 2013 at 09:30:50AM +1100, Dave Chinner wrote:
> > On Tue, Dec 17, 2013 at 02:18:25PM -0500, Matthew Wilcox wrote:
> > > For v3, we've addressed the problem with unwritten extents that Dave
> > > Chinner pointed out. 
> > 
> > No, you haven't addressed the problem. There is nothing in this
> > patch set that converts an unwritten extent after it is written to.
> > Hence on every subsequent read will return zeros because the block
> > is still marked as unwritten.
> 
> I don't understand.  Here's the path as I understand it:
> 
> xip_file_write -> __xip_file_write -> ext4_get_xip_mem(create=0),
> returns -ENODATA.  So we call ext4_get_xip_mem again, this time with
> create=1 which causes ext4_get_block() to allocate blocks.

Ted has already answered this, so I'll skip it.

> > Also, you haven't address the read vs truncate races I pointed out.
> > That is, buffered read currently serialises against truncate via a
> > combination of inode size checks and page locks. i.e. after each
> > page is locked, it is checked to see if it is beyond EOF before
> > the read proceeds into that page. the XIP path does not have any
> > page locks, nor read IO locks, and so is not in any way serialised
> > against a truncate changing the size of the inode while the read is
> > in progress.
> 
> Umm ... what do you think patch 1/3 does?  If you think it doesn't fix
> the race, I need you to explain why.

That's something that happens with a mmap page fault. I'm talking
about read(2) calls which end up in xip_file_read() ->
do_xip_mapping_read().

do_xip_mapping_read() samples the inode size before the copy loop,
and then never looks at it again. The read doesn't hold any locks,
because the way it's wired up it jumps straight from the .read
method, so it goes:

vfs_read()
  xip_file_read()
    do_xip_mapping_read().

No locks are held, so we can race with a truncate at any point in
time. That will change the inode size, and because
do_xip_mapping_read() is not serialised in any way nor does it
check the inode size on each loop, it never detects that the inode
size has changed and so can be reading from beyond the new EOF.

Now, I have no idea what ext4 does when asked to map blocks beyond
EOF, but that will define the behaviour that do_xip_mapping_read()
has when a truncate race occurs(*). But it the behaviour is most
definitely filesystem dependent, and that is most definitely wrong.

There needs to be serialisation against truncate provided in some
way, and that's what the page cache page locks provide non-XIP
buffered read paths. We don't have them in the XIP infrastructure,
and so there's a problem here.

Holding the i_mutex is not sufficient, as the locks that need to be
held to provide this serialisation are owned by the filesystems, not
the generic code. Hence XIP needs to use the normal .aio_read path
and have the filesystems call do_xip_mapping_read() when the
appropriate locks have been gained.

And, in fact, the XIP write(2) path needs to go through filesystems
to be locked correctly just like the read path. Buffered writes need
to be serialised against reads and other filesystem operations, and
holding the i_mutex is not sufficient for that purpose - again, the
locks tha tneed to be held are defined by the filesystem, not the
XIP infrastructure....

The only saving grace is that XIP is so old it doesn't use the
multi-block mapping code that all filesystems now provide to
mpage_readpages(), and so once the blocks have been removed from the
inode the mapping.

Like I said, the XIP code is needs a heap of infrastructure work
before we can hook a modern filesystem up to it in a sane way.

(*) As a side issue, the XIP ext4 block mapping code now has a call
chain that looks like:

ext4_xip_get_mem
  __ext4_get_block
    ext4_get_block
      _ext4_get_block
        ....

You might want to have a think about some of the names and
abstractions being used, because naming like that is going to make
reading stack traces from kernels compiled without frame pointers
a nightmare....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
