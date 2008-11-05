From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: [RFC PATCH -v2 3/9] ext4: Use EXT4_GROUP_INFO_NEED_INIT_BIT
	during resize
Date: Wed, 5 Nov 2008 20:27:59 +0530
Message-ID: <20081105145759.GA6244@skywalker>
References: <1225733769-23734-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <1225733769-23734-2-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <1225733769-23734-3-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <20081104180044.GO30291@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: cmm@us.ibm.com, sandeen@redhat.com, linux-ext4@vger.kernel.org
To: Theodore Tso <tytso@mit.edu>, g@skywalker
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from E23SMTP02.au.ibm.com ([202.81.18.163]:48667 "EHLO
	e23smtp02.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752106AbYKEO6V (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 5 Nov 2008 09:58:21 -0500
Received: from d23relay03.au.ibm.com (d23relay03.au.ibm.com [202.81.18.234])
	by e23smtp02.au.ibm.com (8.13.1/8.13.1) with ESMTP id mA5EvW7n022209
	for <linux-ext4@vger.kernel.org>; Thu, 6 Nov 2008 01:57:32 +1100
Received: from d23av02.au.ibm.com (d23av02.au.ibm.com [9.190.235.138])
	by d23relay03.au.ibm.com (8.13.8/8.13.8/NCO v9.1) with ESMTP id mA5EwK3h1618010
	for <linux-ext4@vger.kernel.org>; Thu, 6 Nov 2008 01:58:20 +1100
Received: from d23av02.au.ibm.com (loopback [127.0.0.1])
	by d23av02.au.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id mA5EwGq0023912
	for <linux-ext4@vger.kernel.org>; Thu, 6 Nov 2008 01:58:17 +1100
Content-Disposition: inline
In-Reply-To: <20081104180044.GO30291@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Nov 04, 2008 at 01:00:44PM -0500, Theodore Tso wrote:
> On Mon, Nov 03, 2008 at 11:06:03PM +0530, Aneesh Kumar K.V wrote:
> > The new groups added during resize are flagged as
> > need_init group. Make sure we properly initialize these
> > groups. When we have block size < page size and we are adding
> > new groups the page may still be marked uptodate even though
> > we haven't initialized the group.
> 
> Aneesh, can you explain to me again why we can't just call
> ext4_mb_free_blocks().  I thought I heard you say that the buddy
> bitmaps weren't appropriately initialized for the end of the bitmap
> --- but I just went through mballoc.c and I couldn't see the problem.
> What am I missing?
> 

We should be able to use ext4_mb_free_blocks() during resize provided
we fix mb_load_buddy to handle the new block group added. Frederic's 
patch actually did that. The problem is with blocksize less than page
size, we need to be more careful when looking at the uptodate flag of the
page because the new block group added can have its bitmap as a part of
already used/uptodate page. So in short we would need some flags to indicate
that that even though the page is marked as uptodate we would like to
force init the buddy cache(ie, call ext4_mb_init_cache). Which in turn would
require us to make sure no parallel load_buddy is happening.(currently
ensured by alloc_sem in the patch series). This is because we are doing
a reinit of the page. I actually tried to do it that way first. But
found the code to more confusing with all the locking.

-aneesh
