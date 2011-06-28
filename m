From: Jan Kara <jack@suse.cz>
Subject: Bug#615998: linux-image-2.6.32-5-xen-amd64: Repeatable "kernel BUG at fs/jbd2/commit.c:534" from Postfix on ext4
Date: Tue, 28 Jun 2011 11:36:52 +0200
Message-ID: <20110628093652.GA29978@quack.suse.cz>
References: <BANLkTi=5BLA07tvbv3PFcZ0cc8FmBtg+UA@mail.gmail.com>
 <404FD5CC-8F27-4336-B7D4-10675C53A588@boeing.com>
 <20110624134659.GB26380@quack.suse.cz>
 <2F80BF45-28FA-46D3-9A28-CA9416DC5813@boeing.com>
 <20110624200231.GA32176@quack.suse.cz>
 <alpine.LFD.2.00.1106271312310.3845@dhcp-27-109.brq.redhat.com>
 <20110627140251.GI5597@quack.suse.cz>
 <alpine.LFD.2.00.1106271714350.3845@dhcp-27-109.brq.redhat.com>
 <20110627160140.GC2729@thunk.org>
 <2D8D1A30-C092-4163-B47A-BCEDACE536A3@boeing.com>
Reply-To: Jan Kara <jack@suse.cz>, 615998@bugs.debian.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Ted Ts'o <tytso@mit.edu>, Lukas Czerner <lczerner@redhat.com>,
	Jan Kara <jack@suse.cz>, Sean Ryle <seanbo@gmail.com>,
	"615998@bugs.debian.org" <615998@bugs.debian.org>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	Sachin Sant <sachinp@in.ibm.com>,
	"Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: "Moffett, Kyle D" <Kyle.D.Moffett@boeing.com>
Return-path: <bounce-debian-bugs-dist=glddb-debian-bugs-dist=m.gmane.org@lists.debian.org>
Resent-Message-ID: <handler.615998.B615998.130925382512453@bugs.debian.org>
Content-Disposition: inline
In-Reply-To: <2D8D1A30-C092-4163-B47A-BCEDACE536A3@boeing.com>
List-Post: <mailto:debian-bugs-dist@lists.debian.org>
List-Help: <mailto:debian-bugs-dist-request@lists.debian.org?subject=help>
List-Subscribe: <mailto:debian-bugs-dist-request@lists.debian.org?subject=subscribe>
List-Unsubscribe: <mailto:debian-bugs-dist-request@lists.debian.org?subject=unsubscribe>
List-Id: linux-ext4.vger.kernel.org

On Mon 27-06-11 23:21:17, Moffett, Kyle D wrote:
> On Jun 27, 2011, at 12:01, Ted Ts'o wrote:
> > On Mon, Jun 27, 2011 at 05:30:11PM +0200, Lukas Czerner wrote:
> >>> I've found some. So although data=journal users are minority, there are
> >>> some. That being said I agree with you we should do something about it
> >>> - either state that we want to fully support data=journal - and then we
> >>> should really do better with testing it or deprecate it and remove it
> >>> (which would save us some complications in the code).
> >>> 
> >>> I would be slightly in favor of removing it (code simplicity, less options
> >>> to configure for admin, less options to test for us, some users I've come
> >>> across actually were not quite sure why they are using it - they just
> >>> thought it looks safer).
> > 
> > Hmm...  FYI, I hope to be able to bring on line automated testing for
> > ext4 later this summer (there's a testing person at Google is has
> > signed up to work on setting this up as his 20% project).  The test
> > matrix that I have him included data=journal, so we will be getting
> > better testing in the near future.
> > 
> > At least historically, data=journalling was the *simpler* case, and
> > was the first thing supported by ext4.  (data=ordered required revoke
> > handling which didn't land for six months or so).  So I'm not really
> > that convinced that removing really buys us that much code
> > simplification.
> > 
> > That being siad, it is true that data=journalled isn't necessarily
> > faster.  For heavy disk-bound workloads, it can be slower.  So I can
> > imagine adding some documentation that warns people not to use
> > data=journal unless they really know what they are doing, but at least
> > personally, I'm a bit reluctant to dispense with a bug report like
> > this by saying, "oh, that feature should be deprecated".
> 
> I suppose I should chime in here, since I'm the one who (potentially
> incorrectly) thinks I should be using data=journalled mode.
> 
> My basic impression is that the use of "data=journalled" can help
> reduce the risk (slightly) of serious corruption to some kinds of
> databases when the application does not provide appropriate syncs
> or journalling on its own (IE: such as text-based Wiki database files).
  It depends on the way such programs update the database files. But
generally yeas, data=journal provides a bit more guarantees than other
journaling modes - see below.

> Please correct me if this is horribly horribly wrong:
> 
> no journal:
>   Nothing is journalled
>   + Very fast.
>   + Works well for filesystems that are "mkfs"ed on every boot
>   - Have to fsck after every reboot
Fsck is needed only after a crash / hard powerdown. Otherwise completely
correct. Plus you always have a possibility of exposing uninitialized
(potentially sensitive) data after a fsck.

Actually, normal desktop might be quite happy with non-journaled filesystem
when fsck is fask enough.

> data=writeback:
>   Metadata is journalled, data (to allocated extents) may be written
>   before or after the metadata is updated with a new file size.
>   + Fast (not as fast as unjournalled)
>   + No need to "fsck" after a hard power-down
>   - A crash or power failure in the middle of a write could leave
>     old data on disk at the end of a file.  If security labeling
>     such as SELinux is enabled, this could "contaminate" a file with
>     data from a deleted file that was at a higher sensitivity.
>     Log files (including binary database replication logs) may be
>     effectively corrupted as a result.
Correct.

> data=ordered:
>   Data appended to a file will be written before the metadata
>   extending the length of the file is written, and in certain cases
>   the data will be written before file renames (partial ordering),
>   but the data itself is unjournalled, and may be only partially
>   complete for updates.
>   + Does not write data to the media twice
>   + A crash or power failure will not leave old uninitialized data
>     in files.
>   - Data writes to files may only partially complete in the event
>     of a crash.  No problems for logfiles, or self-journalled
>     application databases, but others may experience partial writes
>     in the event of a crash and need recovery.
Correct, one should also note that noone guarantees order in which data
hits the disk - i.e. when you do write(f,"a"); write(f,"b"); and these are
overwrites it may happen that "b" is written while "a" is not.

> data=journalled:
>   Data and metadata are both journalled, meaning that a given data
>   write will either complete or it will never occur, although the
>   precise ordering is not guaranteed.  This also implies all of the
>   data<=>metadata guarantees of data=ordered.
>   + Direct IO data writes are effectively "atomic", resulting in
>     less likelihood of data loss for application databases which do
>     not do their own journalling.  This means that a power failure
>     or system crash will not result in a partially-complete write.
Well, direct IO is atomic in data=journal the same way as in data=ordered.
It can happen only half of direct IO write is done when you hit power
button at the right moment - note this holds for overwrites.  Extending
writes or writes to holes are all-or-nothing for ext4 (again both in
data=journal and data=ordered mode).

>   - Cached writes are not atomic
>   + For small cached file writes (of only a few filesystem pages)
>     there is a good chance that kernel writeback will queue the
>     entire write as a single I/O and it will be "protected" as a
>     result.  This helps reduce the chance of serious damage to some
>     text-based database files (such as those for some Wikis), but
>     is obviously not a guarantee.
Page sized and page aligned writes are atomic (in both data=journal and
data=ordered modes). When a write spans multiple pages, there are chances
the writes will be merged in a single transaction but no guarantees as you
properly write.

>   - This writes all data to the block device twice (once to the FS
>     journal and once to the data blocks).  This may be especially bad
>     for write-limited Flash-backed devices.
Correct.

To sum up, the only additional guarantee data=journal offers against
data=ordered is a total ordering of all IO operations. That is, if you do a
sequence of data and metadata operations, then you are guaranteed that
after a crash you will see the filesystem in a state corresponding exactly
to your sequence terminated at some (arbitrary) point. Data writes are
disassembled into page-sized & page-aligned sequence of writes for purpose
of this model...

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
