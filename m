From: Andreas Dilger <adilger@sun.com>
Subject: Re: [PATCH 41/49] ext4: Add multi block allocator for ext4
Date: Wed, 23 Jan 2008 16:20:23 -0700
Message-ID: <20080123232023.GA18891@webber.adilger.int>
References: <1200970948-17903-34-git-send-email-tytso@mit.edu>
 <1200970948-17903-35-git-send-email-tytso@mit.edu>
 <1200970948-17903-36-git-send-email-tytso@mit.edu>
 <1200970948-17903-37-git-send-email-tytso@mit.edu>
 <1200970948-17903-38-git-send-email-tytso@mit.edu>
 <1200970948-17903-39-git-send-email-tytso@mit.edu>
 <1200970948-17903-40-git-send-email-tytso@mit.edu>
 <1200970948-17903-41-git-send-email-tytso@mit.edu>
 <1200970948-17903-42-git-send-email-tytso@mit.edu>
 <20080123140727.f47e9c9d.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Theodore Ts'o <tytso@MIT.EDU>, linux-kernel@vger.kernel.org,
	alex@clusterfs.com, adilger@clusterfs.com,
	aneesh.kumar@linux.vnet.ibm.com, sandeen@redhat.com,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from idcmail-mo1so.shaw.ca ([24.71.223.10]:52365 "EHLO
	pd2mo1so.prod.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751878AbYAWXVT (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 23 Jan 2008 18:21:19 -0500
In-reply-to: <20080123140727.f47e9c9d.akpm@linux-foundation.org>
Content-disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Jan 23, 2008  14:07 -0800, Andrew Morton wrote:
> > +#define mb_correct_addr_and_bit(bit, addr)		\
> > +{							\
> > +	bit += ((unsigned long) addr & 3UL) << 3;	\
> > +	addr = (void *) ((unsigned long) addr & ~3UL);	\
> > +}
> 
> Why do these exist?

They seem to be a holdover from when mballoc stored the buddy bitmaps
on disk.  That no longer happens (to avoid bitmap vs. buddy consistency
problems), so I suspect they can be removed.

I can't comment on many of the other issues because Alex wrote most
of the code.

> Gosh what a lot of code.  Is it faster?

Yes, and also importantly it uses a lot less CPU to do a given amount
of allocation, which is critical in our environments where there is
very high disk bandwidth on a single node and CPU becomes the limiting
factor of the IO speed.  This of course also helps any write-intensive
environment where the CPU is doing something "useful".

Some older test results include:
https://ols2006.108.redhat.com/2007/Reprints/mathur-Reprint.pdf (Section 7)

In the linux-ext4 thread "compilebench numbers for ext4":
http://www.mail-archive.com/linux-ext4@vger.kernel.org/msg03834.html

http://oss.oracle.com/~mason/compilebench/ext4/ext-create-compare.png
http://oss.oracle.com/~mason/compilebench/ext4/ext-compile-compare.png
http://oss.oracle.com/~mason/compilebench/ext4/ext-read-compare.png
http://oss.oracle.com/~mason/compilebench/ext4/ext-rm-compare.png

note the ext-read-compare.png graph shows lower read performance, but
a couple of bugs in mballoc were since fixed to have ext4 allocate more
contiguous extents.

In the old linux-ext4 thread "[RFC] delayed allocation testing on node zefir"
http://www.mail-archive.com/linux-ext4@vger.kernel.org/msg00587.html

        : dd2048rw                             
        : REAL   UTIME  STIME  READ    WRITTEN DETAILS
EXT3    : 58.46  23     1491   2572    2097292 17 extents
EXT4    : 44.56  19     1018   12      2097244 19 extents
REISERFS: 56.80  26     1370   2952    2097336 457 extents
JFS     : 45.77  22     984    0       2097216 1 extents
XFS     : 50.97  20     1394   0       2100825 7 extents

        : kernuntar                            
        : REAL   UTIME  STIME  READ    WRITTEN DETAILS
EXT3    : 56.99  5037   651    68      252016  
EXT4    : 55.03  5034   553    36      249884  
REISERFS: 52.55  4996   854    64      238068  
JFS     : 70.15  5057   630    496     288116  
XFS     : 72.84  5052   953    132     316798  

        : kernstat                             
        : REAL   UTIME  STIME  READ    WRITTEN DETAILS
EXT3    : 2.83   8      15     5892    0       
EXT4    : 0.51   9      10     5892    0       
REISERFS: 0.81   7      49     2696    0       
JFS     : 6.19   11     49     12552   0       
XFS     : 2.09   9      61     6504    0       

        : kerncat                              
        : REAL   UTIME  STIME  READ    WRITTEN DETAILS
EXT3    : 9.48   25     213    241624  0       
EXT4    : 6.29   27     197    238560  0       
REISERFS: 14.69  33     230    234744  0       
JFS     : 23.51  23     231    244596  0       
XFS     : 18.24  36     254    238548  0       

        : kernrm                               
        : REAL   UTIME  STIME  READ    WRITTEN DETAILS
EXT3    : 4.82   4      108    9628    4672    
EXT4    : 1.61   5      110    6536    4632    
REISERFS: 3.15   8      276    2768    236     
JFS     : 33.90  7      168    14400   33048   
XFS     : 20.03  8      296    6632    86160   


Cheers, Andreas
--
Andreas Dilger
Sr. Staff Engineer, Lustre Group
Sun Microsystems of Canada, Inc.
