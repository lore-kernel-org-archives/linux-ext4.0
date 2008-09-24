From: Theodore Tso <tytso@mit.edu>
Subject: Re: [PATCH, RFC] ext4: Use preallocation when reading from the
	inode table
Date: Wed, 24 Sep 2008 16:35:59 -0400
Message-ID: <20080924203559.GK9929@mit.edu>
References: <48D8DEAE.4080309@redhat.com> <20080924013014.GA9747@mit.edu> <48DA3F56.8090806@redhat.com> <1222266034.7160.191.camel@think.oraclecorp.com> <E1KhvsB-0002Ik-Ex@closure.thunk.org> <20080923101613.58768083@lxorguk.ukuu.org.uk> <20080923115045.GI10950@webber.adilger.int> <48D8DEAE.4080309@redhat.com> <20080924013014.GA9747@mit.edu> <48DA3F56.8090806@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andreas Dilger <adilger@sun.com>,
	Alan Cox <alan@lxorguk.ukuu.org.uk>,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
To: Ric Wheeler <rwheeler@redhat.com>,
	Chris Mason <chris.mason@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from www.church-of-our-saviour.ORG ([69.25.196.31]:44563 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752034AbYIXUgY (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 24 Sep 2008 16:36:24 -0400
Content-Disposition: inline
In-Reply-To: <1222266034.7160.191.camel@think.oraclecorp.com> <48DA3F56.8090806@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Sep 24, 2008 at 09:23:34AM -0400, Ric Wheeler wrote:
>
> That sounds about right for modern S-ATA/SAS drives. I would expect that  
> having this be a tunable knob might help for some types of storage (SSD  
> might not care, but should be faster in any case?).
>

Well, for SSD's, wouldn't seek time not matter, but then the limiting
factor should be the overhead of the read transaction, and the I/O
bandwidth of the SSD.  So prefetching too much might hurt even more
for SSD's, although in comparison with spinning rust platters, it
would probably still be faster.  :-)

So I'm pretty sure that with an SSD we'll want to turn the tunable
down, not up.

On Wed, Sep 24, 2008 at 10:20:34AM -0400, Chris Mason wrote:
>For the test runs being done here, there's a pretty high chance that all
>of the inodes you read ahead will get used before the pages are dropped,
>so we want to find a balance between those and the worst case workloads
>where inode reads are basically random.  

Yep, agreed.

On the other hand, if we take your iop/s and translate them to
milliseconds so we can measure the latency in the case where the
workload is essentialy doing random reads, and then cross correlated
it with my measurements, we get this table:

i/o size iops/s  ms latency  % degredation         % improvement
    	 	    	     of random inodes   of related inodes I/O
   4k	  131       7.634      
   8k	  130	    7.692	0.77%		    11.3%
  16k	  128	    7.813	2.34%		    21.8%
  32k	  126	    7.937	3.97%		    29.6%
  64k	  121	    8.264	8.26%		    35.5%
 128k	  113	    8.850      15.93%		    40.0%
 256k	  100	   10.000      31.00%		    42.4%

Depending on whether you believe that workloads involving random inode
reads are more common compared to related inodes I/O, the sweet spot
is probably somewhere between 32k and 128k.  I'm open to opinions
(preferably backed up with more benchmarks of likely workloads) of
whether we should use a default value of inode_readahead_bits of 4 or
5 (i.e., 64k, my original guess, or 128k, in v2 of the patch).  But
yes, making it tunable is definitely going to be necessary, since for
different workloads (i.e squid vs. git repositories) will have very
different requirements.

The other thought are the one which comes to mind is whether we should
use a similar large readahead if all we are doing writes vs. reads.
For example, if we are just updating a single inode, and we are
reading a block to do a read/modify write cycle, maybe we shouldn't be
doing as much readahead.

						- Ted

P.S.  One caveat is that my numbers were taken from a Laptop SATA, and
if Chris's were taken from a Desktop/Sever SATA drive the numbers
might not be properly comparable.
