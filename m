From: Ted Ts'o <tytso@mit.edu>
Subject: Re: Large directories and poor order correlation
Date: Tue, 15 Mar 2011 13:18:43 -0400
Message-ID: <20110315171843.GI8120@thunk.org>
References: <4D7E7990.90209@cfl.rr.com>
 <4D7E7C7F.1040509@redhat.com>
 <8239molspy.fsf@mid.bfk.de>
 <4C11D2E5-75CD-4A9F-A534-EEC16CDD836B@mit.edu>
 <20110315133327.GG22577@bitwizard.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Florian Weimer <fweimer@bfk.de>, Eric Sandeen <sandeen@redhat.com>,
	Phillip Susi <psusi@cfl.rr.com>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
To: Rogier Wolff <R.E.Wolff@BitWizard.nl>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:57144 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758053Ab1CORSy (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 15 Mar 2011 13:18:54 -0400
Content-Disposition: inline
In-Reply-To: <20110315133327.GG22577@bitwizard.nl>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Mar 15, 2011 at 02:33:27PM +0100, Rogier Wolff wrote:
> IMHO, the most important part is "up to and including the stat". It
> should be possible to get the directory, and inode info all inside the
> same "16Mb" part of the disk. This would result in (after a few seeks)
> the rest of the accesses coming from the disk's cache.

It depends on your workload.  In the case of dpkg, everything fits in
cache (usually) so after the first operation this is no longer a
concern.  But all of the data blocks of /var/lib/dpkg/info/* is huge,
since not using a real database means that a 4k block is consumed for
300 bytes of data, so fitting all of the data blocks in memory
generally doesn't work, which is why the dpkg folks are sorting by
block number.

> This would mean that you should allocate directory blocks from the end
> PREVIOUS block group.... 

We do something else, which is we group all directory blocks together
at the beginning of each flex_bg.  This tends to reduce free space
fragmentation, and it helps to optimize for large files that are
bigger than a block group, and where you want to have contiguous
regions larger than a bg --- so breaking up the space every bg is not
a great idea.  Again, with general purpose file systems you can't just
optimize for one thing, and life is full of tradeoffs.

      	   	    	    	       	    - Ted
