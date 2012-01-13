From: Dave Chinner <david@fromorbit.com>
Subject: Re: working on extent locks for i_mutex
Date: Fri, 13 Jan 2012 15:34:11 +1100
Message-ID: <20120113043411.GH2806@dastard>
References: <4F0F9E97.1090403@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>,
	Lukas Czerner <lczerner@redhat.com>, xfs@oss.sgi.com
To: Allison Henderson <achender@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ipmail06.adl2.internode.on.net ([150.101.137.129]:58452 "EHLO
	ipmail06.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751206Ab2AMEeO (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Thu, 12 Jan 2012 23:34:14 -0500
Content-Disposition: inline
In-Reply-To: <4F0F9E97.1090403@linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Jan 12, 2012 at 08:01:43PM -0700, Allison Henderson wrote:
> Hi All,
> 
> I know this is an old topic, but I am poking it again because I've
> had some work items wrap up, and Im planning on picking up on this
> one again.  I am thinking about implementing extent locks to replace
> i_mutex.  So I just wanted to touch base with folks and see what
> people are working on because I know there were some folks out there
> that were thing about doing similar solutions.

What locking API are you looking at? If you are looking at an
something like:

read_range_{try}lock(lock, off, len)
read_range_unlock(lock, off, len)
write_range_{try}lock(lock, off, len)
write_range_unlock(lock, off, len)

and implementing with an rbtree or a btree for tracking, then I
definitely have a use for it in XFS - replacing the current rwsem
that is used for the iolock. Range locks like this are the only
thing we need to allow concurrent buffered writes to the same file
to maintain the per-write exclusion that posix requires.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
