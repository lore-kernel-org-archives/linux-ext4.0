From: Joel Becker <Joel.Becker@oracle.com>
Subject: Re: [Ocfs2-devel] [PATCH 1/3] ext3/ext4: Factor out disk
 addressability check
Date: Fri, 13 Aug 2010 15:52:46 -0700
Message-ID: <20100813225246.GC19568@mail.oracle.com>
References: <874ofr2myq.fsf@patl.com>
 <20100812174215.GC6561@mail.oracle.com>
 <1F3EDC08-AC93-4D4D-8F83-A13C418DFC88@dilger.ca>
 <20100812201534.GA22777@mail.oracle.com>
 <209AEA97-E284-4ADB-8774-50C2630606B9@dilger.ca>
 <20100812222949.GC22777@mail.oracle.com>
 <20100813163006.GB4329@quack.suse.cz>
 <20100813204701.GB19568@mail.oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Jan Kara <jack@suse.cz>, Andreas Dilger <adilger@dilger.ca>,
	"Ted Ts'o" <tytso@mit.edu>, ocfs2-devel@oss.oracle.com,
	linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
	"linux-
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from rcsinet10.oracle.com ([148.87.113.121]:17622 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755732Ab0HMWxn (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 13 Aug 2010 18:53:43 -0400
Content-Disposition: inline
In-Reply-To: <20100813204701.GB19568@mail.oracle.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Aug 13, 2010 at 01:47:01PM -0700, Joel Becker wrote:
> On Fri, Aug 13, 2010 at 06:30:07PM +0200, Jan Kara wrote:
> > On Thu 12-08-10 15:29:49, Joel Becker wrote:
> > > +/**
> > > + * generic_check_addressable - Check addressability of file system
> > > + * @blocksize_bits:	log of file system block size
> > > + * @num_blocks:		number of blocks in file system
> > > + *
> > > + * Determine whether a file system with @num_blocks blocks (and a
> > > + * block size of 2**@blocksize_bits) is addressable by the sector_t
> > > + * and page cache of the system.  Return 0 if so and -EFBIG otherwise.
> > > + */
> > > +int generic_check_addressable(unsigned blocksize_bits, u64 num_blocks)
> > > +{
> > > +	u64 last_fs_block = num_blocks - 1;
> > > +
> > > +	if (unlikely(num_blocks == 0))
> > > +		return 0;
> > > +
> > > +	if ((blocksize_bits < 9) || (blocksize_bits > PAGE_CACHE_SHIFT))
> > > +		return -EINVAL;
> > > +
> > > +	if ((last_fs_block >
> > > +	     (sector_t)(~0ULL) >> (blocksize_bits - 9)) ||
> > > +	    (last_fs_block >
> > > +	     (pgoff_t)(~0ULL) >> (PAGE_CACHE_SHIFT - blocksize_bits))) {
> >             ^^^ I don't get the pgoff_t check. Shouldn't it rather be
> > (u64)(pgoff_t)(~0ULL) << (PAGE_CACHE_SHIFT - blocksize_bits)?
> > Because on 32-bit arch we are able to address 16TB device, which is for 1KB
> > blocksize 1<<34 blocks. But your math gives 1<<30 blocks...
> 
> 	This code is directly lifted from ext4.  But that said, I am
> starting to think you're right.  1 page == 4 x 1K blocks, rather than 4
> pages == 1 1K block.

	Wouldn't it rather be:

	    ... ||
	    ((last_fs_block >> (PAGE_CACHE_SHIFT - blocksize_bits)) >
	     (pgoff_t)(!0ULL))) {

Joel

-- 

"What no boss of a programmer can ever understand is that a programmer
 is working when he's staring out of the window"
	- With apologies to Burton Rascoe

Joel Becker
Consulting Software Developer
Oracle
E-mail: joel.becker@oracle.com
Phone: (650) 506-8127
