From: "Darrick J. Wong" <djwong@us.ibm.com>
Subject: Re: [RFC] ext4: Don't send extra barrier during fsync if there are
	no dirty pages.
Date: Wed, 4 Aug 2010 11:16:01 -0700
Message-ID: <20100804181601.GB2109@tux1.beaverton.ibm.com>
References: <20100429235102.GC15607@tux1.beaverton.ibm.com> <1272934667.2544.3.camel@mingming-laptop> <4BE02C45.6010608@redhat.com> <20100504154553.GA22777@infradead.org> <20100630124832.GA1333@thunk.org> <4C2B44C0.3090002@redhat.com> <20100630134429.GE1333@thunk.org> <20100721171609.GC1215@atrey.karlin.mff.cuni.cz> <20100803000939.GA2109@tux1.beaverton.ibm.com> <20100803090152.GA6676@infradead.org>
Reply-To: djwong@us.ibm.com
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jan Kara <jack@suse.cz>, tytso@mit.edu,
	Ric Wheeler <rwheeler@redhat.com>,
	Mingming Cao <cmm@us.ibm.com>,
	linux-ext4 <linux-ext4@vger.kernel.org>,
	linux-kernel <linux-kernel@vger.kernel.org>,
	Keith Mannthey <kmannth@us.ibm.com>,
	Mingming Cao <mcao@us.ibm.com>
To: Christoph Hellwig <hch@infradead.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e35.co.us.ibm.com ([32.97.110.153]:51808 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756987Ab0HDSQY (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 4 Aug 2010 14:16:24 -0400
Content-Disposition: inline
In-Reply-To: <20100803090152.GA6676@infradead.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Aug 03, 2010 at 05:01:52AM -0400, Christoph Hellwig wrote:
> On Mon, Aug 02, 2010 at 05:09:39PM -0700, Darrick J. Wong wrote:
> > Well... on my fsync-happy workloads, this seems to cut the barrier count down
> > by about 20%, and speeds it up by about 20%.
> 
> Care to share the test case for this?  I'd be especially interesting on
> how it behaves with non-draining barriers / cache flushes in fsync.

Sure.  When I run blktrace with the ffsb profile, I get these results:

barriers	transactions/sec
16212		206
15625		201
10442		269
10870		266
15658		201

Without Jan's patch:
barriers	transactions/sec
20855		177
20963		177
20340		174
20908		177

The two ~270 results are a little odd... if we ignore them, the net gain with
Jan's patch is about a 25% reduction in barriers issued and about a 15%
increase in tps.  (If we don't, it's ~30% and ~30%, respectively.)  That said,
I was running mkfs between runs, so it's possible that the disk layout could
have shifted a bit.  If I turn off the fsync parts of the ffsb profile, the
barrier counts drop to about a couple every second or so, which means that
Jan's patch doesn't have much of an effect.  But it does help if someone is
hammering on the filesystem with fsync.

The ffsb profile is attached below.

--D

-----------

time=300
alignio=1
directio=1

[filesystem0]
	location=/mnt/
	num_files=100000
	num_dirs=1000

reuse=1
	# File sizes range from 1kB to 1MB.
	size_weight 1KB 10
	size_weight 2KB 15
	size_weight 4KB 16
	size_weight 8KB 16
	size_weight 16KB 15
	size_weight 32KB 10
	size_weight 64KB 8
	size_weight 128KB 4
	size_weight 256KB 3
	size_weight 512KB 2
	size_weight 1MB 1

create_blocksize=1048576
[end0]

[threadgroup0]
	num_threads=64

	readall_weight=4
	create_fsync_weight=2
	delete_weight=1

	append_weight		= 1
	append_fsync_weight	= 1
	stat_weight		= 1
	create_weight		= 1
	writeall_weight		= 1
	writeall_fsync_weight	= 1
	open_close_weight	= 1


	write_size=64KB
	write_blocksize=512KB

	read_size=64KB
	read_blocksize=512KB

	[stats]
		enable_stats=1
		enable_range=1

		msec_range    0.00      0.01
		msec_range    0.01      0.02
		msec_range    0.02      0.05
		msec_range    0.05      0.10
		msec_range    0.10      0.20
		msec_range    0.20      0.50
		msec_range    0.50      1.00
		msec_range    1.00      2.00
		msec_range    2.00      5.00
		msec_range    5.00     10.00
		msec_range   10.00     20.00
		msec_range   20.00     50.00
		msec_range   50.00    100.00
		msec_range  100.00    200.00
		msec_range  200.00    500.00
		msec_range  500.00   1000.00
		msec_range 1000.00   2000.00
		msec_range 2000.00   5000.00
		msec_range 5000.00  10000.00
	[end]
[end0]
