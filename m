From: Andreas Dilger <adilger@sun.com>
Subject: Re: large file system & high object count testing
Date: Mon, 31 Aug 2009 14:56:08 -0600
Message-ID: <20090831205608.GE4197@webber.adilger.int>
References: <4A9BFB88.5030409@redhat.com> <4A9C0220.1040503@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; CHARSET=US-ASCII
Content-Transfer-Encoding: 7BIT
Cc: linux-ext4@vger.kernel.org, "Ted Ts'o" <tytso@thunk.org>
To: Ric Wheeler <rwheeler@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from sca-es-mail-2.Sun.COM ([192.18.43.133]:42662 "EHLO
	sca-es-mail-2.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751039AbZHaU4E (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 31 Aug 2009 16:56:04 -0400
Received: from fe-sfbay-09.sun.com ([192.18.43.129])
	by sca-es-mail-2.sun.com (8.13.7+Sun/8.12.9) with ESMTP id n7VKu63R015124
	for <linux-ext4@vger.kernel.org>; Mon, 31 Aug 2009 13:56:06 -0700 (PDT)
Content-disposition: inline
Received: from conversion-daemon.fe-sfbay-09.sun.com by fe-sfbay-09.sun.com
 (Sun Java(tm) System Messaging Server 7u2-7.04 64bit (built Jul  2 2009))
 id <0KP900C00DF6QL00@fe-sfbay-09.sun.com> for linux-ext4@vger.kernel.org; Mon,
 31 Aug 2009 13:56:06 -0700 (PDT)
In-reply-to: <4A9C0220.1040503@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Aug 31, 2009  13:02 -0400, Ric Wheeler wrote:
> One more note - this file system was filled using fs_mark, but without  
> doing any fsync() calls.
>
> umount:
>
> Aug 31 10:19:27 megadeth kernel: EXT4-fs: mballoc: 2580708130 blocks  
> 516141626 reqs (511081408 success)
> Aug 31 10:19:27 megadeth kernel: EXT4-fs: mballoc: 5060218 extents  
> scanned, 0 goal hits, 5060218 2^N hits, 0 breaks, 0 lost
> Aug 31 10:19:27 megadeth kernel: EXT4-fs: mballoc: 85164 generated and  
> it took 471527376
> Aug 31 10:19:27 megadeth kernel: EXT4-fs: mballoc: 2590831616  
> preallocated, 10120312 discarded
>
> Mount after fsck:
> Aug 31 12:27:12 megadeth kernel: EXT4-fs (dm-75):  
> ext4_check_descriptors: Checksum for group 487 failed (59799!=46827)
> Aug 31 12:27:12 megadeth kernel: EXT4-fs (dm-75): group descriptors  
> corrupted!
>
> The MBALLOC messages are a bit worrying - what exactly gets discarded  
> during an unmount?

The in-memory preallocation areas are discarded.  This is reporting
that of the 2590M preallocation areas it reserved, only 10M of them
were discarded during the lifetime of the filesystem.

Of the other stats:
- 471 seconds were spent in total generating the 85k buddy bitmaps
  (this is done incrementally at runtime)
- 516M calls to mballoc to find a chunk of blocks, 511M calls were able
  to find the requested chunk (not surprising given it is a new filesystem,
  probably the 5M calls that failed were when the fs was nearly full)

Cheers, Andreas
--
Andreas Dilger
Sr. Staff Engineer, Lustre Group
Sun Microsystems of Canada, Inc.

