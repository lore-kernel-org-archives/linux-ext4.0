From: Andreas Dilger <adilger@sun.com>
Subject: Re: [PATCH] e2freefrag utility
Date: Fri, 24 Jul 2009 17:14:25 -0600
Message-ID: <20090724231425.GK4231@webber.adilger.int>
References: <20090721001750.GD4231@webber.adilger.int>
 <20090722074352.GA21869@mit.edu> <4A67EE3F.4090909@redhat.com>
 <20090723170759.GB4231@webber.adilger.int> <20090724223201.GA6832@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; CHARSET=US-ASCII
Content-Transfer-Encoding: 7BIT
Cc: Eric Sandeen <sandeen@redhat.com>, linux-ext4@vger.kernel.org
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from sca-es-mail-1.Sun.COM ([192.18.43.132]:58397 "EHLO
	sca-es-mail-1.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751927AbZGXXO5 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 24 Jul 2009 19:14:57 -0400
Received: from fe-sfbay-10.sun.com ([192.18.43.129])
	by sca-es-mail-1.sun.com (8.13.7+Sun/8.12.9) with ESMTP id n6ONErgt019876
	for <linux-ext4@vger.kernel.org>; Fri, 24 Jul 2009 16:14:53 -0700 (PDT)
Content-disposition: inline
Received: from conversion-daemon.fe-sfbay-10.sun.com by fe-sfbay-10.sun.com
 (Sun Java(tm) System Messaging Server 7u2-7.02 64bit (built Apr 16 2009))
 id <0KNB00E006VV5500@fe-sfbay-10.sun.com> for linux-ext4@vger.kernel.org; Fri,
 24 Jul 2009 16:14:53 -0700 (PDT)
In-reply-to: <20090724223201.GA6832@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Jul 24, 2009  18:32 -0400, Theodore Ts'o wrote:
> One question --- right now the chunksize (as specified by -c) only
> affects these lines printed by e2freefrag, right?
> 
> Chunksize: 1048576 bytes (256 blocks)
> Total chunks: 71681
> Free chunks: 21657 (30.2%)

Yes, pretty much.

> They are a little confusing since "chunk" as used here is different
> from "chunk" used in the next part of the output:
> 
> Min free chunk: 4 KB 
> Max free chunk: 568232 KB
> Avg free chunk: 188 KB

You're right.  "free extent" is better.

> How useful is it to print the "total chunks / free chunks" in the
> general case?  I'm guessing this relates to Lutsre's chunking and
> chunksize?

Well, it was important for the hardware RAID setups, to see how many
stripe-aligned free chunks are available in the filesystem.  Since
mballoc will also try to allocate/align on "chunk" boundaries this
is useful to know.  If this chunksize depended on the superblock
s_raid_stripe_width then it would be more useful for the general public.

> Would it make sense to only print the "Chunksize / Total
> chunks / Free Chunks" if a chunksize is specified explicitly via the
> -c option, and to do a s/chunk/extent/ in the next part of the output,

I don't have a big objection.  I don't think there are any tools that
depend on this output.

Cheers, Andreas
--
Andreas Dilger
Sr. Staff Engineer, Lustre Group
Sun Microsystems of Canada, Inc.

