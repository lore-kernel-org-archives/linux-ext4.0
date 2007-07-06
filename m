From: Mike Waychison <mikew@google.com>
Subject: Re: fallocate support for bitmap-based files
Date: Fri, 06 Jul 2007 14:15:44 -0700
Message-ID: <468EB100.2040109@google.com>
References: <20070629130120.ec0d1c75.akpm@linux-foundation.org> <20070629205525.GD32178@thunk.org> <20070629143818.9f4ac7d7.akpm@linux-foundation.org> <4685829D.2020401@google.com> <20070704231127.GA3854@rainbow>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Theodore Tso <tytso@mit.edu>,
	Andreas Dilger <adilger@clusterfs.com>,
	Sreenivasa Busam <sreenivasac@google.com>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	Mingming Cao <cmm@us.ibm.com>
To: Valerie Henson <val@nmt.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp-out.google.com ([216.239.45.13]:37746 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760297AbXGFVQB (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 6 Jul 2007 17:16:01 -0400
In-Reply-To: <20070704231127.GA3854@rainbow>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Valerie Henson wrote:
> On Fri, Jun 29, 2007 at 06:07:25PM -0400, Mike Waychison wrote:
>> Relying on (a tweaked) reservations code is also somewhat limitting at 
>> this stage given that reservations are lost on close(fd).  Unless we 
>> change the lifetime of the reservations (maybe for the lifetime of the 
>> in-core inode?), crank up the reservation sizes and deal with the 
>> overcommit issues, I can't think of any better way at this time to deal 
>> with the problem.
> 
> While I never ever intended the ext3-to-ext2 reservations port to be
> used :), I think you can make some fairly minor tweaks to it and get
> something that works for your use case.  Move the reservation drop to
> iput() and turn up your inode cache size, or store it in a tree when
> the inode is closed and go look for it again when it's reopened.
> Changing the reservation size seems fairly easy.  I'm not sure how the
> overcommit issues affect your use case; any data you can share on
> that?

The overcommit is speculation on my part.  GFS uses a lot of files on 
the disks and we like to keep the disks near full, especially in large 
GFS configurations.  If we end up with a lot of reservations in-core, 
associated with the inode cache, we begin to rely on memory pressure for 
getting the reserved blocks back.  That memory pressure may not exist 
(leading to ENOSPC).  Unless the code is adapted to cull reservations in 
that case.

> 
> In any case, storing the reservation data on-disk seems like not such
> a great idea.  It adds complexity, disk traffic, and a new set of
> checks for fsck.  I wouldn't want to incur that cost unless absolutely
> necessary.

Ya, I wouldn't want the reservations on disk either unless it came in as 
an explicit pre-allocation request (and was accounted for in statfs 
info).  I'm treating that as a completely different beast at the moment.

Mike Waychison
