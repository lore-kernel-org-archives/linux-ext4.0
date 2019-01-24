Return-Path: <SRS0=8KOi=QA=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED,USER_AGENT_MUTT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 857ACC282C3
	for <linux-ext4@archiver.kernel.org>; Thu, 24 Jan 2019 21:25:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 557C8218D2
	for <linux-ext4@archiver.kernel.org>; Thu, 24 Jan 2019 21:25:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727690AbfAXVZ6 (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Thu, 24 Jan 2019 16:25:58 -0500
Received: from ipmail02.adl2.internode.on.net ([150.101.137.139]:34135 "EHLO
        ipmail02.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727665AbfAXVZ6 (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>);
        Thu, 24 Jan 2019 16:25:58 -0500
Received: from ppp59-167-129-252.static.internode.on.net (HELO dastard) ([59.167.129.252])
  by ipmail02.adl2.internode.on.net with ESMTP; 25 Jan 2019 07:55:46 +1030
Received: from dave by dastard with local (Exim 4.80)
        (envelope-from <david@fromorbit.com>)
        id 1gmmVN-00061o-27; Fri, 25 Jan 2019 08:25:45 +1100
Date:   Fri, 25 Jan 2019 08:25:45 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     "Theodore Y. Ts'o" <tytso@mit.edu>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        Christoph Hellwig <hch@infradead.org>,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        Eric Biggers <ebiggers@kernel.org>,
        linux-fscrypt@vger.kernel.org,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net
Subject: Re: Proposal: A new fs-verity interface
Message-ID: <20190124212544.GS6173@dastard>
References: <20190110051500.GA32361@mit.edu>
 <20190114234101.GQ27534@dastard>
 <20190123051017.GA8785@mit.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190123051017.GA8785@mit.edu>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

On Wed, Jan 23, 2019 at 12:10:17AM -0500, Theodore Y. Ts'o wrote:
> Apologies for the delay in getting responding; I've been on vacation
> last week.
> 
> On Tue, Jan 15, 2019 at 10:41:01AM +1100, Dave Chinner wrote:
> > > int ioctl(fd, FS_IOC_ENABLE_VERITY, struct fsverity_arg *arg);
> > > 
> > > struct fsverity_arg {
> > >        int fsv_donor_fd;
> > >        u64 fsv_offset;
> > >        u64 fsv_size;
> > > };
> > > 
> > > fsv_offset and fsz_size must be a multiple of the file system block
> > > size.  If the ioctl comples successfully, as a side effect the
> > > donor_fd will have a hole punch operation on the specified range.  In
> > > other words, the equivalent of operation of fallocate(fsv_donor_fd,
> > > FALLOC_FL_PUNCH_HOLE, fsv_offset, fsv_size), and the file specified by
> > > fd will be protected using fsverity.
> > 
> > makes no sense to me. What's in {offset, size} and why do you need
> > to call this on that specific range? If it is the equivalent of a
> > hole punch, then why wouldn't you just use FALLOC_FL_PUNCH_HOLE?
> 
> This is how we transfer the metadata (e.g., the Merkle tree plus a
> header block) from userspace to the file system. 


> In the original
> interface, the verity metadata was appended end of the data file, and
> then an ioctl would transfer the metadata to the file system.

So how is this different? You still put the data into a file,
then tell the kernel what file it belongs to, and then the
filesystem does "magic" and *consumes* that part of the file?

That's what I'm asking here - what are the semantics of this
ioctl(). I'mnot asking for justification or a unnecessary history
lesson. I'm asking you to describe the behaviour and interface
precisely.

> For
> ext4 and f2fs, we actually store the fsverity metadata after the data
> blocks and simply adjust i_size visible to userspace so the metadata
> blocks are "invisible".

Yes, I know how it's been implemented in ext4 and f2fs. I don't
care about that - I care about what how this new interface works.

> You objected to this interface, because it was too tightly tied to the
> implementation used in ext4 and f2fs.  So what Darrick suggested is
> that it could be conveyed by passing the metadata via a second file
> descriptor.  The offset and size specifies where the metadata can be
> fetched from the second file.

So it's still "file data" that the filesystem has to magically
transform into hidden metadata in some manner. What writes the
merkel tree into a file, and why can't it just write it direct to
the filesystem rather than having to use an intermediate file?

i.e. the proposed API still seems to be bleeding "merkel tree is
held in file data" implementation artifacts through it. That
you can still append the merkle tree to the target file and
then use the hack "donor_fd = fd" to tell it that is where the
merkel tree data is stored seems like a convenient API hack for the
existing implementation, rather than a well thought through, generic
API.

> As in the original interface, the metadata blocks are "consumed" by
> the ioctl, so they disappear from the second file, as if
> FALLOC_FL_PUNCH_HOLE.  It's not that they are deallocated; the blocks
> in question are simply getting transferred to inode which is being
> protected using fs-verity.

But it's not a "hole punch" in your proposal and current
implementation because a) the merkle tree blocks are istill
accounted as user data on the inode the file and hence visible to
userspace (e.g. via stat()) and b) hole punch does not change the
file size. i.e. FALLOC_FL_PUNCH_HOLE is not an equivalent operation
for the behaviour you are talking about, and the blocks aren't
actually "consumed" because they are still accounted to the same
file.

IOWs, "du -sh" now reports a significant mismatch between file sizes
and space consumed by the files. We know from experience that this
will confuse users and they'll think it's a bug:

http://xfs.org/index.php/XFS_FAQ#Q:_Why_do_files_on_XFS_use_more_data_blocks_than_expected.3F

So even though Darrick's proposal is /better/ than just appending
data and flipping the inode size to hide it, this API definition
still allows implementation details specific to "storing merkle tree
as user data beyond EOF" implementations right through it.


> 
> > Can you please write the man page for the interface so that the
> > description of what it does and how it should be used is crystal
> > clear and doesn't assume the reader knows "what darrick proposed"...
> 
> I can do that, but I'd like to make sure we have general agreement
> approach first.

This is why we suck so badly at designing new interfaces. We have to
have "agreement" before anyone even tries to flesh out the full
interface and document all aspects of it. But then we get
"agreement" and the next thing that happens is an implementation
lands in the tree and then we find later on it's full of bugs
because "agreement" doesn't mean ithe API was "fully documented,
understood, reviewed and tested".

We need to change the way we design user APIs - if you don't have a
fully documented proposal (i.e. a man page) that describes the
parameters, the behaviour of the API, the implementation
constraints and requirements, the errors that can be returned, etc,
then it isn't an API proposal we can actually review properly.

So, please, if this is the way you want to go, please document the
API properly.

However, I still have issues with the assumption that the user
application generating the merkel tree must first write the fsverity
information to a user data file before the merkel tree is passed to
the filesystem for permanent storage? Why doesn't it write the
merkel tree directly to the kernel so the filesystem can store it
where it wants to store it on the fly?

Linus wanted the fsverity information to be injected at the VFS so
it's the same for everyone, and that implies that the fsverity
information needs to be treated as a data stream rather than a file
in some filesystem. People have suggested an ADS (alternate data
stream) for this, but that's crazy talk. All we need is a file/fd
flag to say we are "writing fsverity information" so the kernel does
the right thing. e.g.

	vfd = openat(AT_FDCWD, filename, O_APPEND|O_WRONLY);
	flags = fcntl(vfd, F_GETFL, NULL);
	fcntl(vfd, F_SETFL, flags | O_FSVERITY);
	while (....) {
		write(vfd, buf, len);
	}

IOWs, we can communicate to the kernel that this data stream is
special "fs verity" metadata, hence allowing the data that to be
written to where-ever the filesystem stores the merkel tree.
Permissions will be required to set this flag.

(Discussion point: maybe should be a FD_ flag that forces FD_CLOEXEC
so that child processes can't write fsverity information)

From the tagged data stream,  we can implement filesystem indepedent
storage for the merkel tree data - it doesn't have be be written by
the filesystem at all. e.g.  the VFS could cut the incoming buffer
up into fsverity headers and 64kB data chunks and store them in
separate named xattrs. The filesystem would be none-the-wiser that
there is even fsverity data on the file - it would just work on all
filesystems. You don't even need flags in the inode to tell the fs
that it is protected by fsverity - the presence of the fsverity
xattrs is sufficient to determine that.

(Discussion point: use separate iovecs for fsverity headers and
opaque data chunks w/ pwritev2(RWF_FSVERITY|RWF_APPEND) as a defined
user/kernel fsverity format instead of just write calls which the
kernel then interprets)

This is largely impossible with the "store the merkel tree data in a
file, then use a special ioctl to swizzle it into place" API because
the filesystem has to know the on-disk format of the fsverity
information to be able to break it up sanely into xattrs or some
other internal storage type. The filesystem also needs on disk
format changes to support non-xattr format fsverity storage, while a
"VFS layer translates to xattrs" approach can be done without
needing any changes to any filesystem. It also makes the fsverity
functionality available to network filesystems as well...

IOWs, it seems to me that the API should be based around writing
fsverity data into the kernel as a defined data stream, not an API
that does "something" with opaque data in a file from
"somewhere" and assumes the filesystem will handle it all....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
