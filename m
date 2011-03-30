From: Joel Becker <jlbec@evilplan.org>
Subject: Re: [LSF/FS TOPIC] Ext4 snapshots status update
Date: Tue, 29 Mar 2011 17:34:35 -0700
Message-ID: <20110330003429.GA32669@noexit>
References: <AANLkTink6o249JivXiETT6JnANNcikNqGGfr8+McDQsM@mail.gmail.com>
 <20110204002043.GA15658@noexit>
 <AANLkTimuR-oOprBR7Xkehx01ojrdxYOmgqdnX7wNbpt6@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: lsf-pc@lists.linuxfoundation.org,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>,
	Theodore Tso <tytso@mit.edu>,
	Chris Mason <chris.mason@oracle.com>
To: Amir Goldstein <amir73il@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from zeniv.linux.org.uk ([195.92.253.2]:43857 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751986Ab1C3AfE (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 29 Mar 2011 20:35:04 -0400
Content-Disposition: inline
In-Reply-To: <AANLkTimuR-oOprBR7Xkehx01ojrdxYOmgqdnX7wNbpt6@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Mar 23, 2011 at 10:19:38PM +0200, Amir Goldstein wrote:
> On Fri, Feb 4, 2011 at 2:20 AM, Joel Becker <jlbec@evilplan.org> wrot=
e:
> > On Fri, Feb 04, 2011 at 12:33:39AM +0200, Amir Goldstein wrote:
> > =A0 =A0 =A0 =A0I've already got a design for a front-end snapshot p=
rogram that
> > implements a policy on top this generic behavior. =A0This design wo=
uld
> > cover both first-class and hidden style snapshots, because it assum=
e
> > snapshots are in a distinct namespace. =A0I haven't gotten around t=
o
> > implementing it yet, but btrfs and other snapshottable filesystems =
were
> > part of the design goal.
>=20
> Any chance of getting a copy of that design of yours, to get a head s=
tart
> for LSF?

	Yeah, I owe it to you.  It wasn't a written-down thing, it was a
hammered-out-in-our-heads thing among some ocfs2 developers.  I'm going
to braindump here to get us going.  First, I'll speak to your points.

> Here are some other generic snapshot related topics we may want to di=
scuss:
>=20
> 1. Collaborating the use of inode flags COW_FL, NOCOW_FL, suggested b=
y Chris.

	I'm unsure where these fit, perhaps because I missed the
discussion between Chris and you.  ocfs2 has the inode flag
OCFS2_REFCOUNTED_FL to signify a refcount tree is attached to the inode=
=2E
This is ocfs2's structure for maintaining extent reference counts.  Is
your COW_FL the same?  Or is it a permission flag?  NOCOW_FL sounds
like: "Set this flag on the inode and it will prevent CoW."

> 2. How to deal with mmap write to COW file, when you get ENOSPC.

	We just fail the write with VM_FAULT_SIGBUS like mmap write to a
hole.  It's what happens for most other CoW filesystems today.  If
you're using CoW, you should be aware of what to expect.

> 3. Adding buffer_remap() flag for buffered I/O code, meaning, there i=
s
> an existing mapping to initialize a page on partial write, but still =
need
> to call get_block() to get a (possibly) new mapping.

	Since ocfs2 doesn't allocate in get_block(), this doesn't affect
us.  We notice the refcounted extent in write_begin() and CoW it right
there.  Same place we clean up unwritten extents.
=20
--snip--

	Now, about my snapshot thoughts as promised.  My understanding
of the snapshots you have implemented in ext4 is that they are like som=
e
SAN snapshots; they are hidden objects not visible unless you use
special access.  They are particular to a given inode and are children
of that inode.  What happens when you remove the visible inode?  Do the
snapshots disappear?  Do you have limitations on how many shapshots a
particular inode can have?  These questions plagued us when we original
set out to design inode snapshots for ocfs2.
	Once we settled on a mechanism for CoW among ocfs2 inodes, we
quickly decided that a snapshot should be visible in the namespace.
This gave rise to the reflink(2) call, though that name is deprecated i=
n
favor of fastcopy(2).  Currently our API is OCFS2_IOC_REFLINK (see,
legacy!), but we eventually want to get the system call upstream.  In
ocfs2-land, we decided to keep policy out of the kernel.
OCFS2_IOC_REFLINK creates a new inode that shares all the extents of th=
e
source in CoW fashion, but once it returns, that new inode is a peer of
the source.  There is no parent->child relationship.
	Thus, for ocfs2 (and forgive the legacy names, the binary hasn't
changed yet), a "snapshot" is just:

    snapshot: reflink source target.snap && chmod 0444 target.snap

You can add "chattr +i target.snap" in there if you like.
	Since there is no "snapshot namespace" stuff for ocfs2 in the
kernel, it was our intention to propose a snapshot(8) binary that works
like mkfs/fsck; snapshot(8) just calls snapshot.<fstype>(8).  Our
plan was to place snapshot policy in snapshot.ocfs2(8).  This
implementation would handle managing the <mountpoint>/.snapshot/...
namespace behind the user:

    ? cd /mnt/ocfs2
    ? snapshot file1  # Creates /mnt/ocfs2/.snapshot/file1.<timestamp>
    <timestamp>
    ? snapshot file1 test  # Creates /mnt/ocfs2/.snapshot/file1.test
    test
    ? snapshot list file1
    Snapshots for file1:
        <timestamp>
        test

Something like that.
	A different snapshot model like ext4 could have snapshot.ext4(8)
call the kernel or whatever mechanism was appropriate.  A filesystem
from a NAS filer could use filer-specific calls.
	Beyond that, I wanted snapshot(8) to handle scheduling of
snapshots.  The usual daily/weekly stuff should be easy to schedule
generically.
	That's my brain dump.  I could enumerate proposed command
syntaxes, but I don't think that's necessary.

Joel

--=20

"Depend on the rabbit's foot if you will, but remember, it didn't
 help the rabbit."
	- R. E. Shay

			http://www.jlbec.org/
			jlbec@evilplan.org
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
