From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [PATCH] xfstests: enable many tests to run on ext2/3/4
Date: Mon, 25 May 2009 10:31:46 -0500
Message-ID: <4A1AB9E2.9050503@redhat.com>
References: <4A15B649.70801@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
To: xfs mailing list <xfs@oss.sgi.com>,
	ext4 development <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:54938 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751503AbZEYPbs (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 25 May 2009 11:31:48 -0400
In-Reply-To: <4A15B649.70801@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Eric Sandeen wrote:
> This gets many of the tests running on ext4 (and should on ext2/ext3
> as well).
> 
> A few things could still be cleaned up; rather than -xfs, -ext3, -ext4
> etc it'd be better to do --fstype xfs or whatnot, and lose as much of
> the special-casing as possible.  But this gets it going, so maybe
> worth merging now as a first step.
> 
> This creates a new supported_fs "generic" type which should run on
> any generic filesystem (well, assuming it supports acls & xattrs, along
> with general posix-ness).
> 
> It also adds a "generic" group, so you can do:
> 
> ./check -ext4 -g generic
> 
> and that way it'll avoid any fs-specific tests.  They wouldn't
> fail anyway, but it gets noisy to see all the "notrun" tests.

For the uninitiated :)  This applies on top of:

http://git.kernel.org/?p=fs/xfs/xfstests-dev.git

Apply my patch & build it with make... you'll need xfsprogs,
xfsprogs-devel, and xfsprogs-qa-devel (or make install-dev, make
install-qa from the xfsprogs tarball)*  A few other standard devel
packages like e2fsprogs-devel, acl-devel, attr-devel, libaio-devel are
needed too.

edit a local.config file in the top level dir:

TEST_DEV=/dev/sdb1       # device containing TEST PARTITION
TEST_DIR=/mnt/test       # mount point of TEST PARTITION
SCRATCH_DEV=/dev/sdb3    # device containing SCRATCH PARTITION
SCRATCH_MNT=/mnt/scratch # mount point for SCRATCH PARTITION

mkfs.ext4 the $TEST_DEV

./check -ext4 -g generic

-Eric

*another TODO is probably to make ./configure cope with lack of at least
the xfsprogs-qa-devel headers.  There's still some work to make this
cleaner/easier but this at least gets things going.



