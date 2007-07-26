From: Theodore Tso <tytso@mit.edu>
Subject: Re: [PATCH 3/3] e2fsprogs: Support for large inode migration.
Date: Thu, 26 Jul 2007 10:58:57 -0400
Message-ID: <20070726145857.GA12895@thunk.org>
References: <bee58d48110eee4d5cd133167245b99644148d96.1185341470.git.aneesh.kumar@linux.vnet.ibm.com> <3ae4c55b831a13f9fbb9a187efcd65d29434bf09.1185341470.git.aneesh.kumar@linux.vnet.ibm.com> <20070725143209.GA23613@thunk.org> <20070725194625.GR5992@schatzie.adilger.int>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
	linux-ext4@vger.kernel.org
To: Andreas Dilger <adilger@clusterfs.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from THUNK.ORG ([69.25.196.29]:54791 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756625AbXGZO7O (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 26 Jul 2007 10:59:14 -0400
Content-Disposition: inline
In-Reply-To: <20070725194625.GR5992@schatzie.adilger.int>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Wed, Jul 25, 2007 at 01:46:25PM -0600, Andreas Dilger wrote:
> I was just going to write the same things.  However, it should be noted
> that we DO in fact use only the start of each inode table block in
> normal cases.  We did a survey of this across some hundreds of filesystems
> and because all kernels scan each block group's itable from the start of
> the bitmap we only find the beginning of each itable used.

Yep, granted.

> That said, if we were going to follow this approach (which isn't so bad,
> IMHO, because most filesystems are far over-provisioned in terms of
> inodes) then we shouldn't _require_ that the last inodes are unused, but
> rather that < 1/2 of the inodes in each group are unused.  Also, we
> should still keep the inodes in the same block group, and do renumbering
> of the inodes in the directories.  At this point, we have a tool that
> could also allow changing the total number of inodes in the filesystem,
> which is something we've wanted in the past.

The problem is without the block relocation code, all we will be able
to do is shrink the total number of inodes in the filesystem --- and
most of the time, there's not a lot of value in shrinking the size of
the inode table.  Sure, you get a tiny amount of space back, and maybe
e2fsck times speed up, but that's about it.  Most of the time people
who want to change the total number of inodes want to increase it.

> Well, since this isn't exactly a common occurrance, I don't think we
> need to push everything into tune2fs.  Having a separate resize2fs
> seems reasonable (we are resizing the inodes after all), and keeping
> so much complexity out of tune2fs helps ensure that we don't introduce
> bugs into tune2fs itself (which is a far more used and critical tool IMHO).

Well, if you look at resize2fs, the major complexity can roughly be
broken down as follows:

* 30% -- Inode mover (and iterating over directory entries)
* 30% -- Block mover (and iterating over inodes to fix up entries)
* 5% -- Moving the inode table 
* 10% -- Updating the superblock/block group descriptors
* 25% -- Making sure nothing bad happens if resize2fs crashes in the 
      	 	middle (except when moving the inode table; then we cross 
		our fingers and pray)

With the undo I/O manager, the last goes away, and if you need to deal
with iterating over the directory entries, what's left is mostly the
block mover, which really isn't that hard, since the inode mover and
the block mover shares a fair amount of the infrastructure to keep
track what had moved where.

> > My suggestion would be to use something like /var/lib/e2fsprogs as the
> > defalut directory.  And we should also do some tests to make sure
> > something sane happens if we run out of room for the undo file.
> > Presumably the only thing we can do is to abort the run and then back
> > out the chnages using what was written out to the undo file.
> 
> I was going to say /var/tmp, since we don't want to start having to
> manage old versions of these files, add entries to logrotate, etc.

Well, I wanted them in a separate directory so that we could
automatically find the undo files and deal with them automatically.
For example, e2fsck would be able to deal with recovering from an
interrupted resize2fs or tune2fs operation if the system crashed.

In some cases you wouldn't want to automatically reuse them after a
completed operation (i.e., an e2fsck "undo" file would rarely get
used), so we would need to tag the undo file with what program
generated them, and some kind of temporal identifer (i.e., the
superblock last write/mount time).

I also don't think logrotate entries are that bad of an idea....

	    	      	 	 	      	  - Ted
