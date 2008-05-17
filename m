From: Theodore Tso <tytso@mit.edu>
Subject: Re: [PATCH 0/4] (RESEND) ext3[34] barrier changes
Date: Fri, 16 May 2008 20:20:30 -0400
Message-ID: <20080517002030.GA7374@mit.edu>
References: <482DDA56.6000301@redhat.com> <20080516130545.845a3be9.akpm@linux-foundation.org> <482DF44B.50204@redhat.com> <20080516220315.GB15334@shareable.org> <482E08E6.4030507@redhat.com> <20080516225304.GG15334@shareable.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Eric Sandeen <sandeen@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20080516225304.GG15334@shareable.org>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Fri, May 16, 2008 at 11:53:04PM +0100, Jamie Lokier wrote:
> > > If you just want to test the block I/O layer and drive itself, don't
> > > use the filesystem, but write a program which just access the block
> > > device, continuously writing with/without barriers every so often, and
> > > after power cycle read back to see what was and wasn't written.
> > 
> > Well, I think it is worth testing through the filesystem, different
> > journaling mechanisms will probably react^wcorrupt in different ways.
> 
> I agree, but intentional tests on the block device will show the
> drives characteristcs on power failure much sooner and more
> consistently.  Then you can concentrate on the worst drivers :-)

I suspect the real reason why we get away with it so much with ext3 is
that the journal is usually contiguous on disk, hence, when you write
to the journal, it's highly unlikely that commit block will be written
and the blocks before the commit block have not.  In addition, because
we are doing physical block journalling, it repairs a huge amount of
damage during the journal replay.  So as we are writing the journal,
the disk drive sees a large contiguous write stream, followed by
singleton writes where the disk blocks end up on disk.  The most
important reason, though, is that the blocks which are dirty don't get
flushed out to disk right away!

They don't have to, since they are in the journal, and the journal
replay will write the correct data to disk.  Before the journal
commit, the buffer heads are pinned, so they can't be written out.
After the journal commit, the buffer heads may be written out, but
they don't get written out right away; the kernel will only write them
out when the periodic buffer cache flush takes place, *or* if the
journal need to wrap, at which point if there are pending writes to an
old commit that haven't been superceded by another journal commit, the
jbd layer has to force them out.  But the point is this is done in an
extremely lazy fashion.

As a result, it's very tough to create a situation where a hard drive
will reorder write requests aggressively enough that we would see a
potential problem.

I suspect if we want to demonstrate the problem, we would need to do a
number of things:

	* create a highly fragmented journal inode, forcing the jbd
	  layer to seek all over the disk while writing out the
	  journal blocks during a commit
	* make the journal small, forcing the journal to wrap very often
	* run with journal=data mode, to put maximal stress on the journal
	* make the workload one which creates and deletes large number
	  of files scattered all over the directory hierarchy, so that
	  we limit the number of blocks which are rewritten, 
       * forcibly crash the system while subjecting the ext3
         filesystem to this torture test

Given that most ext3 filesystems have their journal created at mkfs
time, so it is contiguous, and the journal is generally nice and
large, in practice I suspect it's relatively difficult (I didn't say
impossible) for us to trigger corruption given how far away we are
from the worst case scenario described above.

						- Ted
