From: "Darrick J. Wong" <djwong@us.ibm.com>
Subject: Re: [PATCH 02/22] ext4: Create a rocompat flag for extended
	metadata checksumming
Date: Mon, 5 Dec 2011 11:24:50 -0800
Message-ID: <20111205192450.GA7137@tux1.beaverton.ibm.com>
References: <20111128232615.19194.80081.stgit@elm3c44.beaverton.ibm.com> <20111128232629.19194.43499.stgit@elm3c44.beaverton.ibm.com> <20111205154133.GA5488@thunk.org>
Reply-To: djwong@us.ibm.com
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: "Ted Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e9.ny.us.ibm.com ([32.97.182.139]:39794 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932126Ab1LETZI (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 5 Dec 2011 14:25:08 -0500
Received: from /spool/local
	by e9.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-ext4@vger.kernel.org> from <djwong@us.ibm.com>;
	Mon, 5 Dec 2011 14:25:07 -0500
Received: from d01av03.pok.ibm.com (d01av03.pok.ibm.com [9.56.224.217])
	by d01relay03.pok.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id pB5JP2UX270016
	for <linux-ext4@vger.kernel.org>; Mon, 5 Dec 2011 14:25:02 -0500
Received: from d01av03.pok.ibm.com (loopback [127.0.0.1])
	by d01av03.pok.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id pB5JOpgB017843
	for <linux-ext4@vger.kernel.org>; Mon, 5 Dec 2011 17:24:52 -0200
Content-Disposition: inline
In-Reply-To: <20111205154133.GA5488@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Dec 05, 2011 at 10:41:33AM -0500, Ted Ts'o wrote:
> (Reviews sent to ext4 list only)
> 
> On Mon, Nov 28, 2011 at 03:26:29PM -0800, Darrick J. Wong wrote:
> > This patch introduces a rocompat feature flag to signal the presence
> > of checksums for metadata blocks.  It also provides storage for a
> > precomputed UUID checksum.
> > 
> > +
> > +	/* Precomputed FS UUID checksum */
> > +	__u32 s_uuid_csum;
> 
> This is really a checksum seed, right?  Calling it a UUID is going to
> be confusing because UUID's are expected to be 128 bits, and something
> which is 32 bits can't possibly be a universally unique.

It's the checksum of the FS UUID, so I guess 'seed' describes it.  I wasn't
trying to call it a UUID.

I also need to clarify the changelog, apparently.  s_uuid_csum is *in-core*
storage for a precomputed UUID checksum.  This piece (and i_uuid_inum_csum) are
computed at load time, just in case the user changed the UUID when the fs was
offline.

> I'd suggest calling this "s_csum_seed", and we explain it as a
> random seed which is selected when the file system is formatted.

Not necessarily random, since you can mkfs.ext4 -U.

> The commit description could also explain that this is used so we can
> detect old metadata blocks left over from a previous use of the
> storage device.

Ok.

--D

