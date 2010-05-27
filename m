From: "Aneesh Kumar K. V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: [PATCH] ext4: Do not zeroout uninitialized extents beyond i_size
Date: Thu, 27 May 2010 22:49:43 +0530
Message-ID: <87d3whuus0.fsf@linux.vnet.ibm.com>
References: <1270833748-14381-1-git-send-email-dmonakhov@openvz.org> <87och49oly.fsf@linux.vnet.ibm.com> <871ve0qb59.fsf@openvz.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu
To: Dmitry Monakhov <dmonakhov@openvz.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e23smtp08.au.ibm.com ([202.81.31.141]:58658 "EHLO
	e23smtp08.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755504Ab0E0RTu (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 27 May 2010 13:19:50 -0400
Received: from d23relay05.au.ibm.com (d23relay05.au.ibm.com [202.81.31.247])
	by e23smtp08.au.ibm.com (8.14.3/8.13.1) with ESMTP id o4RHJlb9016915
	for <linux-ext4@vger.kernel.org>; Fri, 28 May 2010 03:19:47 +1000
Received: from d23av04.au.ibm.com (d23av04.au.ibm.com [9.190.235.139])
	by d23relay05.au.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id o4RHJmua1515608
	for <linux-ext4@vger.kernel.org>; Fri, 28 May 2010 03:19:48 +1000
Received: from d23av04.au.ibm.com (loopback [127.0.0.1])
	by d23av04.au.ibm.com (8.14.3/8.13.1/NCO v10.0 AVout) with ESMTP id o4RHJmVA018506
	for <linux-ext4@vger.kernel.org>; Fri, 28 May 2010 03:19:48 +1000
In-Reply-To: <871ve0qb59.fsf@openvz.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, 28 Apr 2010 11:38:58 +0400, Dmitry Monakhov <dmonakhov@openvz.org> wrote:
> "Aneesh Kumar K. V" <aneesh.kumar@linux.vnet.ibm.com> writes:
> 
> > On Fri,  9 Apr 2010 21:22:28 +0400, Dmitry Monakhov <dmonakhov@openvz.org> wrote:
> >> Zerrout trick allow us to optimize cases where it is more reasonable
> >> to explicitly zeroout extent and mark it as initialized instead of
> >> splitting to several small ones.
> >> But this optimization is not acceptable is extent is beyond i_size
> >> Because it is not possible to have initialized blocks after i_size.
> >> Fsck treat this as incorrect inode size.
> >> 
> >
> > With commit c8d46e41bc744c8fa0092112af3942fcd46c8b18 if we set
> > EXT4_EOFBLOCKS_FL we should be able to have blocks beyond i_size.
> > May be the zero out path should set the flag instead of doing all these
> > changes. Zero-out is already complex with all the ENOSPC related
> > consideration. I guess we should try to keep it simple.
> For initialized extent beyond i_size? I've check fsck and seems that
> is truly possible. So this optimization allow us to avoid some 
> bad EIO situations. But we have to rework ext_get_blocks( ,create == 1)
> to clear EXT4_EOFBLOCKS_FL if last block of latest_extent is requested.
> I'll handle this.
> >


I thought this patch is going to reworked to use EOFBLOCKS_FL. But i see
Ted sent a pull request with the this patch. Did I miss something ?

-aneesh
