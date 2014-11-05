From: Mikulas Patocka <mpatocka@redhat.com>
Subject: Re: [dm-devel] Some thoughts about providing data block checksumming
 for ext4
Date: Tue, 4 Nov 2014 19:27:54 -0500 (EST)
Message-ID: <alpine.LRH.2.02.1411041915430.32105@file01.intranet.prod.int.rdu2.redhat.com>
References: <20141103233308.GA27842@thunk.org> <alpine.LRH.2.02.1411041622490.30941@file01.intranet.prod.int.rdu2.redhat.com> <alpine.LRH.2.02.1411041703590.7145@file01.intranet.prod.int.rdu2.redhat.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: linux-ext4@vger.kernel.org, dm-devel@redhat.com
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:36748 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751421AbaKEA17 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 4 Nov 2014 19:27:59 -0500
In-Reply-To: <alpine.LRH.2.02.1411041703590.7145@file01.intranet.prod.int.rdu2.redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>



On Tue, 4 Nov 2014, Mikulas Patocka wrote:

> 
> 
> > > Recovery after a power fail
> > > ---------------------------
> > > 
> > > If the dm-protected device was not cleanly shut down, then we need to
> > > examine all of the checksum blocks in the Active Area.  For each
> > > checksum block in the AA, the checksums for all of their data blocks
> > > should machine either the checksum found in the AA, or the checksum
> > > found in the checksum block in the checksum group.
> > 
> > ... and if the checksum of the block matches BOTH the checksum in the AA 
> > and the checksum in the checksum group (because of checksum function 
> > collision), you don't know which 4-bit nibble belongs to the data in the 
> > block.
> 
> Though, I realize that you could avoid this problem by selecting the 
> appropriate checksum function - that never results in collision if the 
> 4-bit nibble differs.

Hmm, that is still not sufficient.

Suppose that "a" and "b" is sector content without the 4-bit nibble and 
"x" and "y" are two different nibbles.

Now, we have this situation:

a + x -> checksum1
b + x -> checksum1
a + y -> checksum2
b + y -> checksum2

Suppose that we do crash recovery and we have (x,checksum1) in the 
checksum block and (y,checksum2) in the active area - we can't really tell 
which one is valid.

So you really need cryptographic hashes instead of checksums to avoid the 
collisions.

Mikulas
