From: Andreas Dilger <adilger@sun.com>
Subject: Re: [PATCH] fix bogus BUG_ONs in in mballoc code
Date: Fri, 13 Mar 2009 05:09:52 -0600
Message-ID: <20090313110952.GM3199@webber.adilger.int>
References: <49B93E44.8070109@ph.tum.de> <49B958A1.6060805@redhat.com>
 <20090313003855.GM17104@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7BIT
Cc: Eric Sandeen <sandeen@redhat.com>,
	Thiemo Nagel <thiemo.nagel@ph.tum.de>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from sca-es-mail-2.Sun.COM ([192.18.43.133]:35982 "EHLO
	sca-es-mail-2.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751624AbZCMLKL (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 13 Mar 2009 07:10:11 -0400
Received: from fe-sfbay-10.sun.com ([192.18.43.129])
	by sca-es-mail-2.sun.com (8.13.7+Sun/8.12.9) with ESMTP id n2DBA5OS013549
	for <linux-ext4@vger.kernel.org>; Fri, 13 Mar 2009 04:10:07 -0700 (PDT)
Content-disposition: inline
Received: from conversion-daemon.fe-sfbay-10.sun.com by fe-sfbay-10.sun.com
 (Sun Java(tm) System Messaging Server 7.0-5.01 64bit (built Feb 19 2009))
 id <0KGF00700YRH3H00@fe-sfbay-10.sun.com> for linux-ext4@vger.kernel.org; Fri,
 13 Mar 2009 04:10:05 -0700 (PDT)
In-reply-to: <20090313003855.GM17104@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mar 12, 2009  20:38 -0400, Theodore Ts'o wrote:
> On Thu, Mar 12, 2009 at 01:46:57PM -0500, Eric Sandeen wrote:
> > Thiemo Nagel reported that:
> > 
> > # dd if=/dev/zero of=image.ext4 bs=1M count=2
> > # mkfs.ext4 -v -F -b 1024 -m 0 -g 512 -G 4 -I 128 -N 1 \
> >   -O large_file,dir_index,flex_bg,extent,sparse_super image.ext4
> > # mount -o loop image.ext4 mnt/
> > # dd if=/dev/zero of=mnt/file
> > 
> > oopsed, with a BUG_ON in ext4_mb_normalize_request because
> > size == EXT4_BLOCKS_PER_GROUP
> > 
> > It appears to me (esp. after talking to Andreas) that the BUG_ON
> > is bogus; a request of exactly EXT4_BLOCKS_PER_GROUP should
> > be allowed, though larger sizes do indicate a problem.
> 
> Clearly we should make this change to avoid the BUG_ON; but stupid
> question, why shouldn't we allow sizes larger than
> EXT4_BLOCKS_PER_GROUP?  
> 
> Especially with flex_bg, it is possible for an allocation size >
> EXT4_BLOCKS_PER_GROUP to be satisifed, especially if the filesystem
> isn't that full yet, and it might even make sense to request a larger
> allocation for video files that are getting preallocated, for
> example....

There are two reasons that we can't have too-large mballoc allocations:
- mballoc works on a per-group basis, so the most blocks that it can
  allocate at a time is BLOCKS_PER_GROUP.
- the on-disk extent format cannot map more than 128MB at a time, which
  is equal to the group size at 4kB blocksize.

Cheers, Andreas
--
Andreas Dilger
Sr. Staff Engineer, Lustre Group
Sun Microsystems of Canada, Inc.

