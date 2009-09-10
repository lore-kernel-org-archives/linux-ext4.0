From: Mingming <cmm@us.ibm.com>
Subject: Re: [PATCH 2/2 V3] allow direct IO to fallocate and holes
Date: Thu, 10 Sep 2009 13:17:00 -0700
Message-ID: <1252613820.7006.8.camel@mingming-laptop>
References: <1252025090.15321.17.camel@mingming-laptop>
	 <20090907215746.GA11748@duck.suse.cz>
	 <1252529462.19097.170.camel@mingming-laptop>
	 <20090910075730.GD8690@skywalker.linux.vnet.ibm.com>
	 <20090910085440.GB607@duck.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
	Theodore Tso <tytso@mit.edu>, linux-ext4@vger.kernel.org,
	Eric Sandeen <sandeen@redhat.com>
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e31.co.us.ibm.com ([32.97.110.149]:41609 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750966AbZIJURD (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 10 Sep 2009 16:17:03 -0400
Received: from d03relay02.boulder.ibm.com (d03relay02.boulder.ibm.com [9.17.195.227])
	by e31.co.us.ibm.com (8.14.3/8.13.1) with ESMTP id n8AKBCCS011006
	for <linux-ext4@vger.kernel.org>; Thu, 10 Sep 2009 14:11:12 -0600
Received: from d03av02.boulder.ibm.com (d03av02.boulder.ibm.com [9.17.195.168])
	by d03relay02.boulder.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id n8AKH6pI252528
	for <linux-ext4@vger.kernel.org>; Thu, 10 Sep 2009 14:17:06 -0600
Received: from d03av02.boulder.ibm.com (loopback [127.0.0.1])
	by d03av02.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id n8AKH3Go004152
	for <linux-ext4@vger.kernel.org>; Thu, 10 Sep 2009 14:17:05 -0600
In-Reply-To: <20090910085440.GB607@duck.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, 2009-09-10 at 10:54 +0200, Jan Kara wrote:
> On Thu 10-09-09 13:27:30, Aneesh Kumar K.V wrote:
> > On Wed, Sep 09, 2009 at 01:51:02PM -0700, Mingming wrote:
> > .....
> > .....
> > 
> > > >   I think fsync() still won't work correctly since it can happen user sees
> > > > AIO completed, calls fsync() that completes, 
> > > 
> > > hmm, does fsync() ensure user sees AIO data completed?
> > >
> > 
> > If we call fsync after getting AIO completion event and crash we should
> > ensure that the data can be read back properly. That is either
> > 
> > a) we should ensure that we convert the extent before returning the io
> >     completion event
> > b) Or the fsync should be able to guarantee that it will force the extent
> >    conversion pending on the file.
>   Exactly.
> 
> a) should happen in the sync-io case where we can afford to do IO from the
> end_io callback (and due to flush_workqueue call, it happens with the
> current Mingming's patch so that is file). But for tha aio case, we have to
> somehow implement b).
> 
> 									Honza


to implement b), I think we need to keep track of a list of completed
IOs from AIO, but not get converted extents, and force fsync to run
flush_queue on those completed IOs?

Mingming

