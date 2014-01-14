From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: high write latency bug in ext3 / jbd in 3.4
Date: Mon, 13 Jan 2014 22:52:37 -0500
Message-ID: <20140114035237.GA27083@thunk.org>
References: <20140113201320.GD1214@kvack.org>
 <99F82313-71DA-43E6-A071-05507183D481@dilger.ca>
 <20140113211610.GE1214@kvack.org>
 <20140113225219.GD11207@thunk.org>
 <20140114012121.GF1214@kvack.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andreas Dilger <adilger@dilger.ca>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>
To: Benjamin LaHaise <bcrl@kvack.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:48197 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751536AbaANDwk (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 13 Jan 2014 22:52:40 -0500
Content-Disposition: inline
In-Reply-To: <20140114012121.GF1214@kvack.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Jan 13, 2014 at 08:21:21PM -0500, Benjamin LaHaise wrote:
> Another reason for not being able to migrate to extents is that it breaks 
> the ability of our system to be downgraded smoothly.  The previous kernel 
> being used was of 2.6.18 vintage, so this is the first version of our 
> product that supports using ext4.  There were also concerns about testing 
> both the extent and non-extent code paths as well -- regression tests take 
> months to complete, so adding a times 2 multiplier to everything is a hard 
> sell.

Well, you can use ext4 without enabling extents; at that point the
major performance improvement is those related to delayed allocation.
That should address your large latency associated with file system
commits.  That's because we don't allocate blocks until right before
we allocate them.  Hence, we don't have to force those blocks out to
the journal in order to guarantee the data=ordered guarantees.

You can probably also avoid the huge latency spikes you are seeing by
using data=writeback, BTW, but of course then you risk stale data
issues after a crash.

						- Ted
