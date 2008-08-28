From: Andreas Dilger <adilger@sun.com>
Subject: Re: Do we need dump for ext4?
Date: Thu, 28 Aug 2008 16:23:48 -0600
Message-ID: <20080828222348.GS3392@webber.adilger.int>
References: <48B6BD02.3080307@redhat.com> <20080828184804.GN26987@mit.edu>
 <48B6F69C.3090700@redhat.com> <20080828200448.GQ3392@webber.adilger.int>
 <20080828203553.GB10082@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7BIT
Cc: Ric Wheeler <rwheeler@redhat.com>,
	Eric Sandeen <sandeen@redhat.com>,
	ext4 development <linux-ext4@vger.kernel.org>
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from sca-es-mail-2.Sun.COM ([192.18.43.133]:45423 "EHLO
	sca-es-mail-2.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752061AbYH1WYI (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 28 Aug 2008 18:24:08 -0400
Received: from fe-sfbay-10.sun.com ([192.18.43.129])
	by sca-es-mail-2.sun.com (8.13.7+Sun/8.12.9) with ESMTP id m7SMO5vK019386
	for <linux-ext4@vger.kernel.org>; Thu, 28 Aug 2008 15:24:06 -0700 (PDT)
Received: from conversion-daemon.fe-sfbay-10.sun.com by fe-sfbay-10.sun.com
 (Sun Java System Messaging Server 6.2-8.04 (built Feb 28 2007))
 id <0K6C002010RDPD00@fe-sfbay-10.sun.com> (original mail from adilger@sun.com)
 for linux-ext4@vger.kernel.org; Thu, 28 Aug 2008 15:24:05 -0700 (PDT)
In-reply-to: <20080828203553.GB10082@mit.edu>
Content-disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Aug 28, 2008  16:35 -0400, Theodore Ts'o wrote:
> Yeah, but that requires dealing with Ulrich and for my own mental
> health I try to avoid that as much as possible.  :-)
> 
> This idea is something that has been in my "if only I had time or some
> minions to dispatch" category for quite some time.  We can actually do
> this in the kernel.
> 
> For small directories which could potentially get converted into htree
> format, we already sucking the entire directory and putting it into an
> rbtree.  We could just do this for all directories less than or equal
> to 32k, but have them returned sorted by inode instead of by hash
> value.  At least on my laptop, this accounts for 99.93% of the
> directories on my root filesystem.

What happens if the directory is grown at that point?  I thought the
reason for keeping it sorted in hash order was to deal with the
telldir headache?  I guess if the whole thing is in memory then it
can be attached to the fd and discarded once read or seeked-on
(and POSIX doesn't require reporting new entries after the start
of the read).

Doing this at the VFS level would also benefit _most_ filesystems,
though maybe not ones like XFS or btrfs that have their own preferred
order.

Cheers, Andreas
--
Andreas Dilger
Sr. Staff Engineer, Lustre Group
Sun Microsystems of Canada, Inc.

