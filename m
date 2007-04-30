From: Jeff Garzik <jeff@garzik.org>
Subject: Re: 2.6.21-ext4-1
Date: Mon, 30 Apr 2007 13:16:19 -0400
Message-ID: <46362463.5010309@garzik.org>
References: <E1HiXab-0001QX-Sk@candygram.thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org,
	Johann Lombardi <johann.lombardi@bull.net>,
	"Amit K. Arora" <aarora@linux.vnet.ibm.com>,
	Dave Chinner <dgc@sgi.com>, linux-kernel@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	Linus Torvalds <torvalds@linux-foundation.org>
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from srv5.dvmed.net ([207.36.208.214]:41402 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946547AbXD3RQY (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 30 Apr 2007 13:16:24 -0400
In-Reply-To: <E1HiXab-0001QX-Sk@candygram.thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Theodore Ts'o wrote:
> I've respun the ext4 development patchset, with Amit's updated fallocate
> patches.  I've added Dave's patch to add ia64 support to the fallocate
> system call, but *not* the XFS fallocate support patches.  (Probably
> better for them to live in an xfs tree, where they can more easily
> tested and updated.)  Yes, we haven't reached complete closure on the
> fallocate system call calling convention, but it's enough for us to get
> more testing in -mm.
> 
> Also added Johann's jbd2-stats-through-procfs patches; it provides
> useful help in turning the size of the journal, which will be useful in
> benchmarking efforts.  In addition, Alex Tomas's patch to free
> just-allocated patches when there is an error inserting the extent into
> the extent tree has also been included.
> 
> The patches have been compile-tested on x86, and compile/run-tested on
> x86/UML.  Would appreciate reports about testing on other platforms.

Why isn't this stuff going upstream rapidly?

AFAICT nothing much at all has happened upstream besides a mass renaming?

The whole point of having ext4 in the kernel is to do development 
upstream, in the public view, getting new stuff in ASAP (even if that 
means changing or pulling some stuff later).

As it stands now, ext4 in the upstream tree is completely useless -- 
it's the same as ext3, and has been for months (since Oct 11).

Hello?  Upstream development?  Ever heard of it?

	Jeff
