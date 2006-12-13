From: Suparna Bhattacharya <suparna@in.ibm.com>
Subject: Re: [RFC][Patch 1/1] Persistent preallocation in ext4
Date: Wed, 13 Dec 2006 21:08:38 +0530
Message-ID: <20061213153838.GB7193@in.ibm.com>
References: <20061205134338.GA1894@amitarora.in.ibm.com> <20061206055822.GA6182@amitarora.in.ibm.com> <1165886895.3939.18.camel@dyn9047017103.beaverton.ibm.com> <20061212062302.GA8280@amitarora.in.ibm.com> <1165969238.3771.34.camel@dyn9047017103.beaverton.ibm.com> <20061213100158.GA6517@amitarora.in.ibm.com> <1166016989.5059.13.camel@kleikamp.austin.ibm.com>
Reply-To: suparna@in.ibm.com
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "Amit K. Arora" <aarora@linux.vnet.ibm.com>,
	Mingming Cao <cmm@US.IBM.COM>, linux-ext4@vger.kernel.org,
	suzuki@in.ibm.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e35.co.us.ibm.com ([32.97.110.153]:59666 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965002AbWLMPem (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 13 Dec 2006 10:34:42 -0500
Received: from westrelay02.boulder.ibm.com (westrelay02.boulder.ibm.com [9.17.195.11])
	by e35.co.us.ibm.com (8.13.8/8.12.11) with ESMTP id kBDFYcrG006493
	for <linux-ext4@vger.kernel.org>; Wed, 13 Dec 2006 10:34:38 -0500
Received: from d03av02.boulder.ibm.com (d03av02.boulder.ibm.com [9.17.195.168])
	by westrelay02.boulder.ibm.com (8.13.6/8.13.6/NCO v8.1.1) with ESMTP id kBDFYcZC540230
	for <linux-ext4@vger.kernel.org>; Wed, 13 Dec 2006 08:34:38 -0700
Received: from d03av02.boulder.ibm.com (loopback [127.0.0.1])
	by d03av02.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id kBDFYbpe029455
	for <linux-ext4@vger.kernel.org>; Wed, 13 Dec 2006 08:34:38 -0700
To: Dave Kleikamp <shaggy@linux.vnet.ibm.com>
Content-Disposition: inline
In-Reply-To: <1166016989.5059.13.camel@kleikamp.austin.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Wed, Dec 13, 2006 at 07:36:29AM -0600, Dave Kleikamp wrote:
> On Wed, 2006-12-13 at 15:31 +0530, Amit K. Arora wrote:
> > On Tue, Dec 12, 2006 at 04:20:38PM -0800, Mingming Cao wrote:
> > > On Tue, 2006-12-12 at 11:53 +0530, Amit K. Arora wrote:
> 
> > > Supporting preallocation for extent based files seems fairly
> > > straightforward.  I agree we should look at this first.  After get this
> > > done, it probably worth re-consider whether to support preallocation for
> > > non-extent based files on ext4. I could imagine user upgrade from ext3
> > > to ext4, and expecting to use preallocation on those existing files....
> 
> I disagree here.  Why add the complexity for what is going to be a rare
> case?  In cases where a user is going to benefit from preallocation,
> she'll probably also benefit from extents, and would be better off
> making a copy of the file, thus converting it to extents.
> 
> > I gave a thought on this initially. But, I was not sure how we should
> > implement preallocation in a non-extent based file. Using extents we can
> > mark a set of blocks as unitialized, but how will we do this for
> > non-extent based files ? If we do not have a way to mark blocks
> > uninitialized, when someone will try to read from a preallocated block,
> > it will return junk/stale data instead of zeroes.
> 
> If anything, the block-based preallocation could initialize all of the
> data to zero.  It would be slow, but it would still provide the correct
> function and result in contiguous allocation.

And posix_fallocate does that already ... 

Regards
Suparna

> 
> Shaggy
> --
> David Kleikamp
> IBM Linux Technology Center
> 
> -
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

-- 
Suparna Bhattacharya (suparna@in.ibm.com)
Linux Technology Center
IBM Software Lab, India
