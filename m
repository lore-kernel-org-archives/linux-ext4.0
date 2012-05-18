From: Dave Chinner <david@fromorbit.com>
Subject: Re: Hole punching and mmap races
Date: Fri, 18 May 2012 20:12:10 +1000
Message-ID: <20120518101210.GX25351@dastard>
References: <20120515224805.GA25577@quack.suse.cz>
 <20120516021423.GO25351@dastard>
 <20120516130445.GA27661@quack.suse.cz>
 <20120517074308.GQ25351@dastard>
 <20120517232829.GA31028@quack.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-fsdevel@vger.kernel.org, xfs@oss.sgi.com,
	linux-ext4@vger.kernel.org, Hugh Dickins <hughd@google.com>,
	linux-mm@kvack.org
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ipmail07.adl2.internode.on.net ([150.101.137.131]:33741 "EHLO
	ipmail07.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756991Ab2ERKM1 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Fri, 18 May 2012 06:12:27 -0400
Content-Disposition: inline
In-Reply-To: <20120517232829.GA31028@quack.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, May 18, 2012 at 01:28:29AM +0200, Jan Kara wrote:
> On Thu 17-05-12 17:43:08, Dave Chinner wrote:
> > On Wed, May 16, 2012 at 03:04:45PM +0200, Jan Kara wrote:
> > > On Wed 16-05-12 12:14:23, Dave Chinner wrote:
> > IIRC, it's a rare case (that I consider insane, BTW):  read from a
> > file with into a buffer that is a mmap()d region of the same file
> > that has not been faulted in yet.....
>   With punch hole, the race is less insane - just punching hole in the area
> which is accessed via mmap could race in a bad way AFAICS.

Seems the simple answer to me is to prevent page faults while hole
punching, then....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
