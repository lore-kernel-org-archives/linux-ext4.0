From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: [RFC][PATCH 4/6] delalloc ENOSPC: avoid free blocks  double
	booking
Date: Mon, 2 Jun 2008 13:29:34 +0530
Message-ID: <20080602075934.GA29995@skywalker>
References: <1212363370.4368.67.camel@localhost.localdomain> <20080602065147.GC26379@skywalker> <1212390756.4368.113.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Mingming Cao <cmm@us.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e28smtp01.in.ibm.com ([59.145.155.1]:37944 "EHLO
	e28smtp01.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751723AbYFBH75 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 2 Jun 2008 03:59:57 -0400
Received: from d28relay02.in.ibm.com (d28relay02.in.ibm.com [9.184.220.59])
	by e28smtp01.in.ibm.com (8.13.1/8.13.1) with ESMTP id m527xY0g000483
	for <linux-ext4@vger.kernel.org>; Mon, 2 Jun 2008 13:29:34 +0530
Received: from d28av04.in.ibm.com (d28av04.in.ibm.com [9.184.220.66])
	by d28relay02.in.ibm.com (8.13.8/8.13.8/NCO v8.7) with ESMTP id m527x8cP749732
	for <linux-ext4@vger.kernel.org>; Mon, 2 Jun 2008 13:29:08 +0530
Received: from d28av04.in.ibm.com (loopback [127.0.0.1])
	by d28av04.in.ibm.com (8.13.1/8.13.3) with ESMTP id m527xYNW006635
	for <linux-ext4@vger.kernel.org>; Mon, 2 Jun 2008 13:29:34 +0530
Content-Disposition: inline
In-Reply-To: <1212390756.4368.113.camel@localhost.localdomain>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Jun 02, 2008 at 12:12:36AM -0700, Mingming Cao wrote:
> On Mon, 2008-06-02 at 12:21 +0530, Aneesh Kumar K.V wrote:
> > On Sun, Jun 01, 2008 at 04:36:10PM -0700, Mingming Cao wrote:
> > > ext4: delalloc block reservation avoid double accounting
> > > 
> > > From: Mingming cao <cmm@us.ibm.com>
> > > 
> > > Since fs free blocks counters are already reduced at the block reservation
> > > time, we need to let the underlying block allocation know to avoid
> > > decrease the free blocks counter again when real block allocation finished.
> > > 
> > > Signed-off-by: Mingming cao <cmm@us.ibm.com>
> > > ---
> > >  fs/ext4/dir.c     |    3 ++-
> > >  fs/ext4/ext4.h    |    6 +++++-
> > >  fs/ext4/ext4_i.h  |    1 +
> > >  fs/ext4/extents.c |    2 +-
> > >  fs/ext4/inode.c   |   25 ++++++++++++++++++-------
> > >  fs/ext4/mballoc.c |   13 ++++++++++++-
> > >  fs/ext4/super.c   |    2 ++
> > >  7 files changed, 41 insertions(+), 11 deletions(-)
> > > 
> > 
> > I guess you would need a similar change for balloc.c 
> > 
> 
> I haven't try delaloc on non-extent files yet. that's todo after this
> series is settle down. 

how about mount -o nomballoc ?

-aneesh
