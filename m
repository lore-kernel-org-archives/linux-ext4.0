From: Christian Kujau <lists@nerdbynature.de>
Subject: Re: [Jfs-discussion] benchmark results
Date: Thu, 24 Dec 2009 17:52:34 -0800 (PST)
Message-ID: <alpine.DEB.2.01.0912241739160.3483@bogon.housecafe.de>
References: <alpine.DEB.2.01.0912240205510.3483@bogon.housecafe.de> <19251.26403.762180.228181@tree.ty.sabi.co.uk> <20091224212756.GM21594@thunk.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Peter Grandi <pg_jf2@jf2.for.sabi.co.UK>, xfs@oss.sgi.com,
	reiserfs-devel@vger.kernel.org, linux-ext4@vger.kernel.org,
	linux-btrfs@vger.kernel.org, jfs-discussion@lists.sourceforge.net,
	ext-users <ext3-users@redhat.com>, linux-nilfs@vger.kernel.org
To: tytso@mit.edu
Return-path: <reiserfs-devel-owner@vger.kernel.org>
In-Reply-To: <20091224212756.GM21594@thunk.org>
Sender: reiserfs-devel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Thu, 24 Dec 2009 at 16:27, tytso@mit.edu wrote:
> If you don't do a "sync" after the tar, then in most cases you will be
> measuring the memory bandwidth, because data won't have been written

Well, I do "sync" after each operation, so the data should be on disk, but 
that doesn't mean it'll clear the filesystem buffers - but this doesn't 
happen that often in the real world too. Also, all filesystem were tested 
equally (I hope), yet some filesystem perform better than another - even 
if all the content copied/tar'ed/removed would perfectly well fit into the 
machines RAM.

> Another good example of well done file system benchmarks can be found
> at http://btrfs.boxacle.net

Thanks, I'll have a look at it and perhaps even integrate it in the 
wrapper script.

> benchmarks for a living.  Note that JFS and XFS come off much better
> on a number of the tests

Indeed, I was surpised to see JFS perform that good and XFS of course is 
one of the best too - I just wanted to point out that both of them 
are strangely slow at times (removing or creating many files) - not what I 
expected.

> --- and that there is a *large* number amount
> of variation when you look at different simulated workloads and with a
> varying number of threads writing to the file system at the same time.

True, the TODO list in the script ("different benchmark options") is in 
there for a reason :-)

Christian.
-- 
BOFH excuse #291:

Due to the CDA, we no longer have a root account.
