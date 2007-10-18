From: Andreas Dilger <adilger@clusterfs.com>
Subject: Re: [GIT PULL] ext4 update
Date: Thu, 18 Oct 2007 00:29:06 -0600
Message-ID: <20071018062906.GP8122@schatzie.adilger.int>
References: <E1Ii0UI-0007TW-IM@closure.thunk.org> <Pine.LNX.4.64.0710162149470.1538@asgard.lang.hm>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Theodore Ts'o <tytso@mit.edu>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
To: david@lang.hm
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1762649AbXJRG3c@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0710162149470.1538@asgard.lang.hm>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Oct 16, 2007  21:51 -0700, david@lang.hm wrote:
> On Wed, 17 Oct 2007, Theodore Ts'o wrote:
> >It has a number random cleanups and bug fixes, and two new features.
> >The first is uninitialized block groups, which allows fast mke2fs
> >operations plus as well as speeding up e2fsck by allowing it to skip
> >parts of the inode tables that haven't been used yet.
> 
> nice feature, is there any work on a tool to go through a well-used 
> filesystem and mark unused block groups as uninitialized? (I would guess 
> that such a tool may want to move files to make this so)

Yes, just set the feature flag via tune2fs and then run e2fsck on it.
The second e2fsck shown below is just a demonstration of the speedup.

    # tune2fs -O uninit_groups /dev/foo
    tune2fs 1.39.cfs9 (7-Apr-2007)

    Please run e2fsck on the filesystem.

    # time e2fsck -fy /dev/foo
    e2fsck 1.39.cfs9 (7-Apr-2007)
    Group descriptor 0 checksum is invalid.  Fix? yes

    {repeats for all groups}

    Pass 1: Checking inodes, blocks, and sizes
    Pass 2: Checking directory structure
    Pass 3: Checking directory connectivity
    Pass 4: Checking reference counts
    Pass 5: Checking group summary information
    lustre-OST0000: 9099/1640160 files (0.4% non-contiguous), 221996/6554520
    blocks

    real    0m17.273s
    user    0m4.930s
    sys     0m1.749s

    # time e2fsck -fy /dev/hda3
    e2fsck 1.39.cfs9 (7-Apr-2007)
    Pass 1: Checking inodes, blocks, and sizes
    Pass 2: Checking directory structure
    Pass 3: Checking directory connectivity
    Pass 4: Checking reference counts
    Pass 5: Checking group summary information
    lustre-OST0000: 9099/1640160 files (0.4% non-contiguous), 221996/6554520
    blocks

    real    0m2.412s
    user    0m0.604s
    sys     0m0.077s


The caveats are:
(a) this is a read-only feature, so you can't mount such a filesystem r/w
    on an older kernel.  You can disable it with "tune2fs -O ^uninit_groups"
    and run a full e2fsck on it again.
(b) I don't think there is an official e2fsprogs release with support for this
    feature yet (it's in the pipe, however).
(c) The actual speedup depends on how full the filesystem is, but since ext*
    usually has way too many inodes, it is generally pretty good.

Cheers, Andreas
--
Andreas Dilger
Principal Software Engineer
Cluster File Systems, Inc.
