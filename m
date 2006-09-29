From: Theodore Tso <tytso@mit.edu>
Subject: Re: Bug#389772: e2fsprogs: e2fsck produces broken htree on ppc
Date: Fri, 29 Sep 2006 17:15:56 -0400
Message-ID: <20060929211556.GA11017@thunk.org>
References: <20060927122251.GA732@alea.gnuu.de> <20060929010857.GC11055@thunk.org> <20060929171547.GO22010@schatzie.adilger.int>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: =?utf-8?B?Su+/vXJn?= Sommer <joerg@alea.gnuu.de>,
	389772@bugs.debian.org, paulus@au.ibm.com,
	linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:12780 "EHLO thunker.thunk.org")
	by vger.kernel.org with ESMTP id S1751340AbWI2VQN (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Fri, 29 Sep 2006 17:16:13 -0400
To: Andreas Dilger <adilger@clusterfs.com>
Content-Disposition: inline
In-Reply-To: <20060929171547.GO22010@schatzie.adilger.int>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Fri, Sep 29, 2006 at 11:15:47AM -0600, Andreas Dilger wrote:
> Hmm, except isn't the problem ALREADY that PPC is broken with 8-bit
> chars and htree?  That's what started this problem in the first place.
> Running e2fsck allowed the kernel htree code to find the file, when
> it could not otherwise be looked up...  Need to verify that (my mental
> stack is overflowing).
> 
> IIRC this problem was also reported in the past but no solution was found.
> I think fixing the kernel to specify signed chars for the hash will FIX
> the PPC kernel code.

If the filesystem is empty (or at least no no hashtree directories),
then when the kernel creates new directories and expands to the point
where they become indexed, they will be indexed with the PPC variant
of the hash algorithm.  This will be self consistent, and everything
will work fine --- until the filesystem gets corrupted to the point
where e2fsprogs needs to rebuild one or more hashed directories.  At
that point the directories will be rebuilt using the same conventions
used by all other conventions, but the directories will no longer be
useful on the PPC kernel.

Joerg, can you confirm this?  On a PPC machine, can you create a
smallish ext3 filesystem (say, 4-8 megabytes), create a directory with
enough files in it that it becomes indexed (verify using lsattr), and
show that it works just fine on a PPC.  Now take that image, and
transfer it to an x86 machine; you should find that the kernel can't
look up any of the directories on the x86 machine.  If you then run
e2fsck -fD on that filesystem (running the e2fsck on either x86 or
PPC; it shouldn't make a difference), then the resulting filesystem
should work just fine on the x86, and fail on the PPC.

If I understand this problem correctly, the above experiment should
confirm what I suspect is going on.

						- Ted
