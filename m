From: Andreas Dilger <adilger@clusterfs.com>
Subject: Re: [PATCH 3/3] e2fsprogs: Support for large inode migration.
Date: Wed, 25 Jul 2007 13:46:25 -0600
Message-ID: <20070725194625.GR5992@schatzie.adilger.int>
References: <bee58d48110eee4d5cd133167245b99644148d96.1185341470.git.aneesh.kumar@linux.vnet.ibm.com> <3ae4c55b831a13f9fbb9a187efcd65d29434bf09.1185341470.git.aneesh.kumar@linux.vnet.ibm.com> <20070725143209.GA23613@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
	linux-ext4@vger.kernel.org
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.clusterfs.com ([74.0.229.162]:50481 "EHLO
	mail.clusterfs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933890AbXGYTqb (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 25 Jul 2007 15:46:31 -0400
Content-Disposition: inline
In-Reply-To: <20070725143209.GA23613@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Jul 25, 2007  10:32 -0400, Theodore Tso wrote:
> The problem with your patch is:
> 
> 	* By shrinking the number of inodes, it can constrain the
>           ability of the filesystem to create new files in the future.
> 
> 	* It ruins the inode and block placement algorithms where we
>           try to keep inodes in the same block group as their parent
>           directory, and we try to allocate blocks in the same block
>           group as their containing inode.
> 
> 	* Because when the current patch makes no attempt to relocate
>           inodes, and when it doubles the inode size, it chops the
>           number of inodes in half, there must be no inodes in the
>           last half of the inode table.  That is if there are N block
>           groups, the inode tables in blockgroups N/2 to N-1 must be
>           empty.  But because of the block group spreading algorithm,
>           where new directories get pushed out to new block groups, in
>           any real real-life filesystem, the use of block groups is
>           evenly spread out, which means in practice you won't see
>           case where the last half of the inodes will not be in use.
>           Hence, your patch won't actually work in practice.

I was just going to write the same things.  However, it should be noted
that we DO in fact use only the start of each inode table block in
normal cases.  We did a survey of this across some hundreds of filesystems
and because all kernels scan each block group's itable from the start of
the bitmap we only find the beginning of each itable used.

That said, if we were going to follow this approach (which isn't so bad,
IMHO, because most filesystems are far over-provisioned in terms of
inodes) then we shouldn't _require_ that the last inodes are unused, but
rather that < 1/2 of the inodes in each group are unused.  Also, we
should still keep the inodes in the same block group, and do renumbering
of the inodes in the directories.  At this point, we have a tool that
could also allow changing the total number of inodes in the filesystem,
which is something we've wanted in the past.

> So unfortunately, the right answer *will* require expanding the inode
> tables, and potentially moving blocks out of the way in order to make
> room for it.  A lot of that machinery is in resize2fs, actually, and
> I'm wondering if the right answer is to move resize2fs's functionality
> into tune2fs.  We will also need this to be able to add the resize
> inode after the fact.

Well, since this isn't exactly a common occurrance, I don't think we
need to push everything into tune2fs.  Having a separate resize2fs
seems reasonable (we are resizing the inodes after all), and keeping
so much complexity out of tune2fs helps ensure that we don't introduce
bugs into tune2fs itself (which is a far more used and critical tool IMHO).

> > tune2fs use undo I/O manager when migrating to large
> > inode. This helps in reverting the changes if end results
> > are not correct.The environment variable TUNE2FS_SCRATCH_DIR
> > is used to indicate the  directory within which the tdb
> > file need to be created. The file will be named tune2fs-XXXXXX
> 
> My suggestion would be to use something like /var/lib/e2fsprogs as the
> defalut directory.  And we should also do some tests to make sure
> something sane happens if we run out of room for the undo file.
> Presumably the only thing we can do is to abort the run and then back
> out the chnages using what was written out to the undo file.

I was going to say /var/tmp, since we don't want to start having to
manage old versions of these files, add entries to logrotate, etc.

Cheers, Andreas
--
Andreas Dilger
Principal Software Engineer
Cluster File Systems, Inc.
