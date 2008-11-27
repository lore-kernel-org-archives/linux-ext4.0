From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: [PATCH 1/2] ext4: Fix the delalloc writepages to allocate
	blocks at the right offset.
Date: Thu, 27 Nov 2008 11:07:26 +0530
Message-ID: <20081127053726.GC28952@skywalker>
References: <1226050948-32221-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <20081126055321.GF1410@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: cmm@us.ibm.com, sandeen@redhat.com, vallesroc@gmail.com,
	Solofo.Ramangalahy@bull.net, cryptooctoploid@gmail.com,
	linux-ext4@vger.kernel.org
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from E23SMTP02.au.ibm.com ([202.81.18.163]:50919 "EHLO
	e23smtp02.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750890AbYK0Fie (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 27 Nov 2008 00:38:34 -0500
Received: from sd0109e.au.ibm.com (d23rh905.au.ibm.com [202.81.18.225])
	by e23smtp02.au.ibm.com (8.13.1/8.13.1) with ESMTP id mAR5bfrw029071
	for <linux-ext4@vger.kernel.org>; Thu, 27 Nov 2008 16:37:41 +1100
Received: from d23av01.au.ibm.com (d23av01.au.ibm.com [9.190.234.96])
	by sd0109e.au.ibm.com (8.13.8/8.13.8/NCO v9.1) with ESMTP id mAR5cU0b239048
	for <linux-ext4@vger.kernel.org>; Thu, 27 Nov 2008 16:38:30 +1100
Received: from d23av01.au.ibm.com (loopback [127.0.0.1])
	by d23av01.au.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id mAR5cTRh014777
	for <linux-ext4@vger.kernel.org>; Thu, 27 Nov 2008 16:38:30 +1100
Content-Disposition: inline
In-Reply-To: <20081126055321.GF1410@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Nov 26, 2008 at 12:53:21AM -0500, Theodore Tso wrote:
> On Fri, Nov 07, 2008 at 03:12:27PM +0530, Aneesh Kumar K.V wrote:
> > When iterating through the pages with all mapped buffer_heads
> > we failed to update the b_state value. This result in allocating
> > blocks at logical offset 0.
> > 
> > Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
> 
> Hey Aneesh,
> 
> I've been going through patches in the patch queue and I noticed that
> the subsequent patch 
> 
> [PATCH 2/2] ext4: Mark the buffer_heads as dirty and uptodate after prepare_write
> 
> has been merged to mainline, but this one wasn't.  From looking at the
> e-mail record, you said that the second one fixed the rtorrent
> corruption --- but looking at this patch and its description, it looks
> like this one should perhaps get pushed to Linus ASAP as well.  Do you
> remember if both patches were needed to fix the rtorrent corruption
> problem, or only the second one?

Both patches are not needed to fix the rtorrent problem. The second
patch actually fix the rtorrent issue.

-aneesh
