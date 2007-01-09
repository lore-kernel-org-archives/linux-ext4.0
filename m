From: "Amit K. Arora" <aarora@linux.vnet.ibm.com>
Subject: Re: [RFC][Patch 1/2] Persistent preallocation in ext4
Date: Tue, 9 Jan 2007 14:35:30 +0530
Message-ID: <20070109090530.GA19130@amitarora.in.ibm.com>
References: <20061205134338.GA1894@amitarora.in.ibm.com> <20061206055822.GA6182@amitarora.in.ibm.com> <20061215123528.GA24572@amitarora.in.ibm.com> <1167262245.3792.20.camel@dyn9047017103.beaverton.ibm.com> <20070102110409.GB5932@amitarora.in.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, suparna@in.ibm.com, suzuki@in.ibm.com,
	alex@clusterfs.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e2.ny.us.ibm.com ([32.97.182.142]:43363 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751201AbXAIJFo (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 9 Jan 2007 04:05:44 -0500
Received: from d01relay02.pok.ibm.com (d01relay02.pok.ibm.com [9.56.227.234])
	by e2.ny.us.ibm.com (8.13.8/8.12.11) with ESMTP id l0995ZFv027008
	for <linux-ext4@vger.kernel.org>; Tue, 9 Jan 2007 04:05:35 -0500
Received: from d01av03.pok.ibm.com (d01av03.pok.ibm.com [9.56.224.217])
	by d01relay02.pok.ibm.com (8.13.6/8.13.6/NCO v8.1.1) with ESMTP id l0995ZKN261480
	for <linux-ext4@vger.kernel.org>; Tue, 9 Jan 2007 04:05:35 -0500
Received: from d01av03.pok.ibm.com (loopback [127.0.0.1])
	by d01av03.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l0995ZxY007949
	for <linux-ext4@vger.kernel.org>; Tue, 9 Jan 2007 04:05:35 -0500
To: Mingming Cao <cmm@us.ibm.com>
Content-Disposition: inline
In-Reply-To: <20070102110409.GB5932@amitarora.in.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Tue, Jan 02, 2007 at 04:34:09PM +0530, Amit K. Arora wrote:
> On Wed, Dec 27, 2006 at 03:30:44PM -0800, Mingming Cao wrote:
> > Since the API takes the number of bytes to preallocate, at return time,
> > shall we convert the blocks to bytes to the user?
> >
> > Here it returns the number of allocated blocks to the user.   Do we need
> > to worry about the case when dealing with a range with partial hole and
> > partial blocks already allocated? In that case nblocks(the new
> > preallocated blocks) will less than the maxblocks (the number of blocks
> > asked by application).  I am wondering what does other filesystem like
> > xfs do? Maybe we should do the same thing.
> 
> I think xfs just returns 0 on success, and errno on an error. Do we
> want to keep the same behavior here ? Or, should we return the number of
> bytes preallocated ?

We still need to decide on what the ioctl should return. Should it
return zero on success and errno on error, like how posix_fallocate and
xfs behave ?  If yes, then should we undo partial preallocation (if any)
in case of an error (say ENOSPC) ?

If no, then should we return the number of bytes preallocated ? In this
case we have to think about the situation Mingming mentioned above (i.e.
when the preallocation request partially spans through a hole and
partially through few already allocated blocks).

--
Regards,
Amit Arora
