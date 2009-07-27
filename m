From: Andreas Dilger <adilger@sun.com>
Subject: Re: [PATCH] e2freefrag utility
Date: Mon, 27 Jul 2009 12:36:36 -0600
Message-ID: <20090727183636.GN4231@webber.adilger.int>
References: <20090721001750.GD4231@webber.adilger.int>
 <20090722074352.GA21869@mit.edu> <4A67EE3F.4090909@redhat.com>
 <20090723170759.GB4231@webber.adilger.int> <20090724223201.GA6832@mit.edu>
 <20090724231425.GK4231@webber.adilger.int> <20090725001823.GD6832@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; CHARSET=US-ASCII
Content-Transfer-Encoding: 7BIT
Cc: Eric Sandeen <sandeen@redhat.com>, linux-ext4@vger.kernel.org
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from sca-es-mail-1.Sun.COM ([192.18.43.132]:45009 "EHLO
	sca-es-mail-1.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752668AbZG0ShI (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 27 Jul 2009 14:37:08 -0400
Received: from fe-sfbay-09.sun.com ([192.18.43.129])
	by sca-es-mail-1.sun.com (8.13.7+Sun/8.12.9) with ESMTP id n6RIb4Kn008408
	for <linux-ext4@vger.kernel.org>; Mon, 27 Jul 2009 11:37:04 -0700 (PDT)
Content-disposition: inline
Received: from conversion-daemon.fe-sfbay-09.sun.com by fe-sfbay-09.sun.com
 (Sun Java(tm) System Messaging Server 7u2-7.02 64bit (built Apr 16 2009))
 id <0KNG00800E88ZK00@fe-sfbay-09.sun.com> for linux-ext4@vger.kernel.org; Mon,
 27 Jul 2009 11:37:04 -0700 (PDT)
In-reply-to: <20090725001823.GD6832@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Jul 24, 2009  20:18 -0400, Theodore Ts'o wrote:
> On Fri, Jul 24, 2009 at 05:14:25PM -0600, Andreas Dilger wrote:
> > Well, it was important for the hardware RAID setups, to see how many
> > stripe-aligned free chunks are available in the filesystem.  Since
> > mballoc will also try to allocate/align on "chunk" boundaries this
> > is useful to know.  If this chunksize depended on the superblock
> > s_raid_stripe_width then it would be more useful for the general public.
> 
> Yeah, I think what we should try to do is to display the chunk
> information if s_raid_stripe_width if it is set, and otherwise only
> print it if a chunk size is explicitly specified.  Sounds like a plan?

Yes, sounds reasonable.

Cheers, Andreas
--
Andreas Dilger
Sr. Staff Engineer, Lustre Group
Sun Microsystems of Canada, Inc.

