From: Andreas Dilger <adilger@sun.com>
Subject: Re: Question on fallocate/ftruncate sequence (and flags)
Date: Thu, 23 Jul 2009 15:53:57 -0600
Message-ID: <20090723215357.GE4231@webber.adilger.int>
References: <6601abe90907200936w61ebda92reae368a2b9efac66@mail.gmail.com>
 <4A64F37D.7020803@redhat.com>
 <1248211771.20743.2.camel@bobble.smo.corp.google.com>
 <20090721215421.GM4231@webber.adilger.int>
 <1248378517.8421.4.camel@bobble.smo.corp.google.com>
 <4A68C9EC.4050301@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; CHARSET=US-ASCII
Content-Transfer-Encoding: 7BIT
Cc: Frank Mayhar <fmayhar@google.com>,
	Curt Wohlgemuth <curtw@google.com>,
	ext4 development <linux-ext4@vger.kernel.org>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from sca-es-mail-2.Sun.COM ([192.18.43.133]:48862 "EHLO
	sca-es-mail-2.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754248AbZGWVy0 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 23 Jul 2009 17:54:26 -0400
Received: from fe-sfbay-09.sun.com ([192.18.43.129])
	by sca-es-mail-2.sun.com (8.13.7+Sun/8.12.9) with ESMTP id n6NLsNKn022892
	for <linux-ext4@vger.kernel.org>; Thu, 23 Jul 2009 14:54:24 -0700 (PDT)
Content-disposition: inline
Received: from conversion-daemon.fe-sfbay-09.sun.com by fe-sfbay-09.sun.com
 (Sun Java(tm) System Messaging Server 7u2-7.02 64bit (built Apr 16 2009))
 id <0KN900F008QIKB00@fe-sfbay-09.sun.com> for linux-ext4@vger.kernel.org; Thu,
 23 Jul 2009 14:54:23 -0700 (PDT)
In-reply-to: <4A68C9EC.4050301@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Jul 23, 2009  15:37 -0500, Eric Sandeen wrote:
> Frank Mayhar wrote:
> > On Tue, 2009-07-21 at 15:54 -0600, Andreas Dilger wrote:
> >> That said, we might need to have some kind of flag in the on-disk
> >> inode to indicate that it was preallocated beyond EOF.  Otherwise,
> >> e2fsck will try and extend the file size to match the block count,
> >> which isn't correct.  We could also use this flag to determine if
> >> truncate needs to be run on the inode even if the new size is the
> >> same.
> > 
> > As it happens there's already a flag, FS_FALLOC_FL, set by ext2 in
> > fallocate().  Unfortunately ext4 is using that bit (0x00040000) for
> > EXT4_HUGE_FILE_FL.  (Ext4 is using another bit as well, 0x00100000, for
> > EXT4_EXT_MIGRATE_FL when fs.h defines it as FS_DIRECTIO_FL.)  I really
> > want to use the FS_FALLOC_FL bit for this purpose but that means
> > reallocating HUGE_FILE_FL to some other big.  Objections?
> 
> I'm confused (again?) :).  I don't see FS_FALLOC_FL in the latest kernel
> source, and ext2 (well, my ext2 anyway) can't do fallocate().  Google
> (well, my google search) can't find it either.  Is this something in
> your tree?

I think I recall Google working on a patch for fallocate on ext2, but
it was vetoed from upstream inclusion because we don't want to flog
a dead horse.  Hence the Google patch to run ext4 w/o a journal.

> As for:
> 
> #define EXT4_EXT_MIGRATE                0x00100000 /* Inode is migrating */
> 
> this is not in the mask that FS_IOC_GETFLAGS can see ... and I don't
> think anyone else uses FS_DIRECTIO_FL.
> 
> I'm not sure if the flags not in FS_FL_USER_VISIBLE are supposed to be
> fs-unique.

Well, they are stored on disk, so we shouldn't have conflicts between
ext2 and ext4 for sure.

Cheers, Andreas
--
Andreas Dilger
Sr. Staff Engineer, Lustre Group
Sun Microsystems of Canada, Inc.

