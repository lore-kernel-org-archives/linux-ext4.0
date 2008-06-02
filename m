From: Mingming Cao <cmm@us.ibm.com>
Subject: Re: [RFC][PATCH 4/6] delalloc ENOSPC: avoid free blocks  double
	booking
Date: Mon, 02 Jun 2008 00:12:36 -0700
Message-ID: <1212390756.4368.113.camel@localhost.localdomain>
References: <1212363370.4368.67.camel@localhost.localdomain>
	 <20080602065147.GC26379@skywalker>
Reply-To: cmm@us.ibm.com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e31.co.us.ibm.com ([32.97.110.149]:53213 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753146AbYFBHMm (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 2 Jun 2008 03:12:42 -0400
Received: from d03relay04.boulder.ibm.com (d03relay04.boulder.ibm.com [9.17.195.106])
	by e31.co.us.ibm.com (8.13.8/8.13.8) with ESMTP id m527CgXq029806
	for <linux-ext4@vger.kernel.org>; Mon, 2 Jun 2008 03:12:42 -0400
Received: from d03av04.boulder.ibm.com (d03av04.boulder.ibm.com [9.17.195.170])
	by d03relay04.boulder.ibm.com (8.13.8/8.13.8/NCO v8.7) with ESMTP id m527CgAd074724
	for <linux-ext4@vger.kernel.org>; Mon, 2 Jun 2008 01:12:42 -0600
Received: from d03av04.boulder.ibm.com (loopback [127.0.0.1])
	by d03av04.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m527Cf9M022576
	for <linux-ext4@vger.kernel.org>; Mon, 2 Jun 2008 01:12:42 -0600
In-Reply-To: <20080602065147.GC26379@skywalker>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, 2008-06-02 at 12:21 +0530, Aneesh Kumar K.V wrote:
> On Sun, Jun 01, 2008 at 04:36:10PM -0700, Mingming Cao wrote:
> > ext4: delalloc block reservation avoid double accounting
> > 
> > From: Mingming cao <cmm@us.ibm.com>
> > 
> > Since fs free blocks counters are already reduced at the block reservation
> > time, we need to let the underlying block allocation know to avoid
> > decrease the free blocks counter again when real block allocation finished.
> > 
> > Signed-off-by: Mingming cao <cmm@us.ibm.com>
> > ---
> >  fs/ext4/dir.c     |    3 ++-
> >  fs/ext4/ext4.h    |    6 +++++-
> >  fs/ext4/ext4_i.h  |    1 +
> >  fs/ext4/extents.c |    2 +-
> >  fs/ext4/inode.c   |   25 ++++++++++++++++++-------
> >  fs/ext4/mballoc.c |   13 ++++++++++++-
> >  fs/ext4/super.c   |    2 ++
> >  7 files changed, 41 insertions(+), 11 deletions(-)
> > 
> 
> I guess you would need a similar change for balloc.c 
> 

I haven't try delaloc on non-extent files yet. that's todo after this
series is settle down. 

It first need a similar function to calculate the total number of meta
data blocks to reserve for non extent files, then similar accounting
handling for balloc.

Mingming

