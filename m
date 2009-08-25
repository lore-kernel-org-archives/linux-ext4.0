From: Theodore Tso <tytso@mit.edu>
Subject: Re: Enable asynchronous commits by default patch revoked?
Date: Mon, 24 Aug 2009 20:15:54 -0400
Message-ID: <20090825001554.GN17684@mit.edu>
References: <200908241033.10527.Christian.Fischer@easterngraphics.com> <20090824133447.GH23677@mit.edu> <20090824183119.GI5931@webber.adilger.int> <20090824201027.GC17684@mit.edu> <4A92F7E0.9010001@redhat.com> <20090824220738.GG17684@mit.edu> <4A93103B.2000909@redhat.com> <20090824232804.GJ17684@mit.edu> <20090824234336.GU5931@webber.adilger.int>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Ric Wheeler <rwheeler@redhat.com>,
	Christian Fischer <Christian.Fischer@easterngraphics.com>,
	linux-ext4@vger.kernel.org
To: Andreas Dilger <adilger@sun.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:49455 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753381AbZHYAP7 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 24 Aug 2009 20:15:59 -0400
Content-Disposition: inline
In-Reply-To: <20090824234336.GU5931@webber.adilger.int>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Aug 24, 2009 at 05:43:36PM -0600, Andreas Dilger wrote:
> Without transaction checksums waiting on all of the blocks together
> is NOT safe.  If the commit record is on disk, but the rest of the
> transaction's blocks are not then during replay it may cause garbage
> to be written from the journal into the filesystem metadata.

Yes, I *said* that we can only wait on all of the blocks together with
the commit record when doing journal checksums.  Sorry if I didn't
make that clear enough.

That's the one optimization we using journal checksums buys us.
Unfortunately it does not allow us to omit the barrier
operation.... and have real-world testing experience that without the
barrier, a power drop can cause significant filesystem corruption and
potential data loss.

Try using Chris Mason's torture-test workload with async-checksums
without this patch; you will get data corruption if you try dropping
power while his torture-test is running.  I know you really don't like
the barrier, but I'm afraid it's not safe to run without it, even with
journal checksums.

						- Ted
