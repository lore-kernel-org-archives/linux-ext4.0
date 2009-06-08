From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: [PATCH -V2 2/2] ext4: truncate the file properly if we fail to
	copy data from userspace
Date: Tue, 9 Jun 2009 01:50:49 +0530
Message-ID: <20090608202049.GC23723@skywalker>
References: <20090605234458.GG11650@duck.suse.cz> <1244435715-6807-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <1244435715-6807-2-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <20090608162959.GJ23883@mit.edu> <20090608164357.GA23723@skywalker> <20090608191420.GM23883@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: cmm@us.ibm.com, sandeen@redhat.com, linux-ext4@vger.kernel.org,
	Jan Kara <jack@suse.cz>
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e23smtp01.au.ibm.com ([202.81.31.143]:52217 "EHLO
	e23smtp01.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752867AbZFHUVA (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 8 Jun 2009 16:21:00 -0400
Received: from d23relay02.au.ibm.com (d23relay02.au.ibm.com [202.81.31.244])
	by e23smtp01.au.ibm.com (8.13.1/8.13.1) with ESMTP id n58KKDhf013941
	for <linux-ext4@vger.kernel.org>; Tue, 9 Jun 2009 06:20:13 +1000
Received: from d23av01.au.ibm.com (d23av01.au.ibm.com [9.190.234.96])
	by d23relay02.au.ibm.com (8.13.8/8.13.8/NCO v9.2) with ESMTP id n58KL2kR872546
	for <linux-ext4@vger.kernel.org>; Tue, 9 Jun 2009 06:21:02 +1000
Received: from d23av01.au.ibm.com (loopback [127.0.0.1])
	by d23av01.au.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id n58KL1PH027585
	for <linux-ext4@vger.kernel.org>; Tue, 9 Jun 2009 06:21:02 +1000
Content-Disposition: inline
In-Reply-To: <20090608191420.GM23883@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Jun 08, 2009 at 03:14:20PM -0400, Theodore Tso wrote:
> On Mon, Jun 08, 2009 at 10:13:57PM +0530, Aneesh Kumar K.V wrote:
> > I think i both the case Jan's patch
> > allocate-blocks-correctly-with-subpage-blocksize need an update ? Since you have put
> > the patch before Jan's changes.
> 
> OK, here's how I updated Jan's patch.  I'm going to assume that we'll
> submit the ext4 patch queue immediately as soon as the merge window
> opens, since my impression is Jan is still waiting for some mm
> developers to review his patch set.   
> 
> Annesh, does this look good to you?

I just did a quick look. Should we do a block_unlock_hole_extend after
journal_stop. We do a block_lock_hole_extend before journal_start.

> 
> Jan, if we go down this path, you'll need to update your ext4 patch
> with this updated one, to take into account the changes from Aneesh's
> patch.
> 
> (We could do it the other way, but that means even more patches queued
> up behind Jan's patch series, and I didn't realize originally that
> Aneesh intended for these to be queued after Jan's patches.  So it
> seemed easier to just order Aneesh's patches to avoid block allocation
> leaks first, since they are at least functionally (if not
> syntactically) independent of the subpagesize blocksize patches.)

-aneesh
