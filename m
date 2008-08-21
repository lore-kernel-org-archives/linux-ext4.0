From: Theodore Tso <tytso@mit.edu>
Subject: Re: ENOSPC returned during writepages
Date: Thu, 21 Aug 2008 11:35:58 -0400
Message-ID: <20080821153558.GJ16634@mit.edu>
References: <20080820054339.GB6381@skywalker> <20080820104644.GA11267@skywalker> <20080820115331.GA9965@mit.edu> <1219269325.7895.45.camel@mingming-laptop> <20080821151815.GD6509@skywalker>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Mingming Cao <cmm@us.ibm.com>,
	ext4 development <linux-ext4@vger.kernel.org>
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from www.church-of-our-saviour.org ([69.25.196.31]:41372 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751500AbYHUPg3 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 21 Aug 2008 11:36:29 -0400
Content-Disposition: inline
In-Reply-To: <20080821151815.GD6509@skywalker>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Aug 21, 2008 at 08:48:15PM +0530, Aneesh Kumar K.V wrote:
> > I have a feeling that we did not try very hard before invalidate the
> > dirty page which fail to map to disks. Perhaps we should try a few more
> > times before give up. Also in that case, perhaps we should turn off
> > delalloc fs wide, so the new writers won't take the subsequently made
> > avaible free blocks away from this unlucky delalloc da writepages.
> 
> How do we try hard ? The mballoc already try had to allocate blocks. So I
> am not sure what do we achieve by requesting for block allocation again.

So here's the problem that we face.  If we have a situation where the
disk fills temporarily, but then subsequently space gets freed up, it
would be preferable if the dirty page isn't invalidated, and so
periodically (or perhaps via "there's-free-space-now notifier") we
retry the delayed allocation so we don't lose data during a transient
disk full situation.  But at the same time, we don't want an fsync()
on the entire filesystem, or a umount on the filesystem, to hang
forever.

						- Ted
