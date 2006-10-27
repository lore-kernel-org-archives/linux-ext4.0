From: Alex Tomas <alex@clusterfs.com>
Subject: Re: [RFC] Ext3 online defrag
Date: Fri, 27 Oct 2006 11:44:11 +0400
Message-ID: <m3lkn2ryno.fsf@bzzz.home.net>
References: <20061027162326sho@rifu.tnes.nec.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: alex@clusterfs.com, tytso@mit.edu, jack@suse.cz,
	linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from [80.71.248.82] ([80.71.248.82]:25227 "EHLO gw.home.net")
	by vger.kernel.org with ESMTP id S1946227AbWJ0Hmq (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Fri, 27 Oct 2006 03:42:46 -0400
To: sho@tnes.nec.co.jp
In-Reply-To: <20061027162326sho@rifu.tnes.nec.co.jp> (sho@tnes.nec.co.jp's message of "Fri, 27 Oct 2006 16:23:26 +0900")
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org


I've been reworking mballoc with few new features:

1) in-core preallocation
   like existing  reservation, but can preallocate few pieces for a file

2) locality groups
   to maintain groups of related files and flush them together.
   say, two users are unpacking kernel. with delayed allocation
   we've got bunch of files from the both in cache. then we flush
   first set (few MBs) of files from one user, then from another.
   this way write I/Os will be large enough to achieve good
   throughput and files are still quite localized to be used later
   at good read rate.

3) scalable reservation
   required for delayed allocation to avoid -ENOSPC at flush time.
   current version uses per-sb spinlock.

probably we could add something for defragmentation?

thanks, Alex

>>>>> sho  (s) writes:

 s> I am considering the online defrag function for ext4 and thinking
 s> that your following patch set for multi-block allocation is useful
 s> to search contiguous free blocks for the defragmentation.

 s> "[RFC] extents,mballoc,delalloc for 2.6.16.8" 
 s> http://marc.theaimsgroup.com/?l=linux-ext4&m=114669168616780&w=2

 s> I will send the patch of simple defrag implementation for ext4 later.

 s> Cheers, Takashi
