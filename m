From: "Aneesh Kumar K. V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: [PATCH -V2] ext4: unmap the underlying metadata when allocating
 blocks via fallocate
Date: Mon, 25 Jan 2010 23:51:06 +0530
Message-ID: <87hbqaoxkd.fsf@linux.vnet.ibm.com>
References: <1262805762-6862-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
	<1262805762-6862-3-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
	<4B4F4DB7.1070501@redhat.com> <87wrzklesd.fsf@linux.vnet.ibm.com>
	<20100124182445.GA4372@thunk.org> <87k4v6py3e.fsf@linux.vnet.ibm.com>
	<20100125090243.GA28459@thunk.org> <4B5DBC15.9030004@redhat.com>
	<20100125175512.GC28459@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: cmm@us.ibm.com, linux-ext4@vger.kernel.org
To: tytso@mit.edu, Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e23smtp01.au.ibm.com ([202.81.31.143]:52159 "EHLO
	e23smtp01.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751248Ab0AYSVS (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 25 Jan 2010 13:21:18 -0500
Received: from d23relay05.au.ibm.com (d23relay05.au.ibm.com [202.81.31.247])
	by e23smtp01.au.ibm.com (8.14.3/8.13.1) with ESMTP id o0PIJN2o019038
	for <linux-ext4@vger.kernel.org>; Tue, 26 Jan 2010 05:19:23 +1100
Received: from d23av04.au.ibm.com (d23av04.au.ibm.com [9.190.235.139])
	by d23relay05.au.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id o0PIGQtG1503330
	for <linux-ext4@vger.kernel.org>; Tue, 26 Jan 2010 05:16:26 +1100
Received: from d23av04.au.ibm.com (loopback [127.0.0.1])
	by d23av04.au.ibm.com (8.14.3/8.13.1/NCO v10.0 AVout) with ESMTP id o0PILG70000759
	for <linux-ext4@vger.kernel.org>; Tue, 26 Jan 2010 05:21:16 +1100
In-Reply-To: <20100125175512.GC28459@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, 25 Jan 2010 12:55:12 -0500, tytso@mit.edu wrote:
> On Mon, Jan 25, 2010 at 09:43:17AM -0600, Eric Sandeen wrote:
> > > Aneesh Kumar K.V (3):
> > >       ext4: Handle -EDQUOT error on write
> > >       ext4: Fix quota accounting error with fallocate
> > >       ext4: Drop EXT4_GET_BLOCKS_UPDATE_RESERVE_SPACE flag
> > 
> > You may wish to add the patch from Jiaying (via me) as well, to handle
> > the blocks-past-eof case, if it's had sufficient review.
> 
> I'm going to merge it, but I only want to push regressions to Linus at
> this stage.  We can add the blocks-past-EOF for the next merge window,
> and mark it for merging via -stable, but it's really late for
> non-regression bug fixes at this point.

I guess we can push i_size corruption with blocks past EOF in this merge
window. The other part of the patch get/set flags via chattr can be
pushed for the next merge window.

-aneesh

