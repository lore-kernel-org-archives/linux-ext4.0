From: Andreas Dilger <adilger@sun.com>
Subject: Re: How were some of the lustre e2fsprogs test cases generated?
Date: Tue, 19 Feb 2008 14:13:46 -0700
Message-ID: <20080219211346.GR3029@webber.adilger.int>
References: <E1JRG0g-0001lz-Ur@closure.thunk.org>
 <20080219114032.GL3029@webber.adilger.int> <20080219122925.GW25098@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7BIT
Cc: linux-ext4@vger.kernel.org
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from sca-es-mail-2.Sun.COM ([192.18.43.133]:58768 "EHLO
	sca-es-mail-2.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752006AbYBSVN4 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 19 Feb 2008 16:13:56 -0500
Received: from fe-sfbay-09.sun.com ([192.18.43.129])
	by sca-es-mail-2.sun.com (8.13.7+Sun/8.12.9) with ESMTP id m1JLDuap028148
	for <linux-ext4@vger.kernel.org>; Tue, 19 Feb 2008 13:13:56 -0800 (PST)
Received: from conversion-daemon.fe-sfbay-09.sun.com by fe-sfbay-09.sun.com
 (Sun Java System Messaging Server 6.2-8.04 (built Feb 28 2007))
 id <0JWI0050187J9M00@fe-sfbay-09.sun.com> (original mail from adilger@sun.com)
 for linux-ext4@vger.kernel.org; Tue, 19 Feb 2008 13:13:56 -0800 (PST)
In-reply-to: <20080219122925.GW25098@mit.edu>
Content-disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Feb 19, 2008  07:29 -0500, Theodore Ts'o wrote:
> On Tue, Feb 19, 2008 at 04:40:32AM -0700, Andreas Dilger wrote:
> > No, it hasn't always been true that we cleared the _hi fields in the
> > kernel code.  But, it has been a year or more since we found this bug,
> > and all CFS e2fsprogs releases since then have cleared the _hi fields,
> > and there has not been any other e2fsprogs that supports extents, so
> > we expect that there are no filesystems left in the field with this
> > issue, and even then the current code will prefer to clear the _hi
> > bits instead of considering the whole extent corrupt.
> 
> I checked again, and it looks like the interim code is indeed clearing
> the _hi bits.  I managed to confuse myself into thinking it didn't for
> index nodes, but I checked again and it seems to be doing the right
> thing.
> 
> The reason why I asked is that the extents code in the 'next' branch
> of e2fsprogs *does* consider the whole extent to be corrupt, since in
> the long run once we start 64-bit block number extent blocks, if the
> physical block number (including the high 16 bits) is greater than
> s_blocks_count, simply masking off the high 16 bits of the 48 bit
> extent block is probably not the right way of dealing with the
> problem.
> 
> I think that's probably a safe thing to do since all of your customers
> who might have had a filesystem with non-zero _hi fields have almost
> certainly run e2fsck to clear the _hi bits at least once; do you
> concur that is a safe assumption?  Or would you prefer that I add some
> code that tries to clear just the _hi bits, perhaps controlled by a
> configuration flag in e2fsck.conf?

I'm OK with either.  We might consider patching e2fsck to return to the
more permissive CFS behaviour with _hi bits for our own releases, or
just leave it.  Checking back in our patches, we fixed the kernel code
in July '06 and the e2fsck code in Jan '07, so I hope people have run
an e2fsck on their filesystems in the last 1.5 years.

Cheers, Andreas
--
Andreas Dilger
Sr. Staff Engineer, Lustre Group
Sun Microsystems of Canada, Inc.
