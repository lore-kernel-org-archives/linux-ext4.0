From: Joel Becker <Joel.Becker@oracle.com>
Subject: Re: [Ocfs2-devel] [PATCH 1/3] ext3/ext4: Factor out disk
 addressability check
Date: Thu, 12 Aug 2010 13:15:34 -0700
Message-ID: <20100812201534.GA22777@mail.oracle.com>
References: <874ofr2myq.fsf@patl.com>
 <20100812174215.GC6561@mail.oracle.com>
 <1F3EDC08-AC93-4D4D-8F83-A13C418DFC88@dilger.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "Ted Ts'o" <tytso@mit.edu>, Jan Kara <jack@suse.cz>,
	ocfs2-devel@oss.oracle.com, linux-fsdevel@vger.kernel.org,
	linux-ext4@vger.kernel.org,
	"linux-kernel@vger.kernel.org Patrick J. LoPresti"
	<lopresti@gmail.com>
To: Andreas Dilger <adilger@dilger.ca>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1F3EDC08-AC93-4D4D-8F83-A13C418DFC88@dilger.ca>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Thu, Aug 12, 2010 at 12:45:41PM -0600, Andreas Dilger wrote:
> On 2010-08-12, at 11:42, Joel Becker wrote:
> >> +/**
> >> + * generic_check_addressable - Check addressability of file system
> >> + * @blocksize_bits:	log of file system block size
> >> + * @num_blocks:		number of blocks in file system
> >> + *
> >> + * Determine whether a file system with @num_blocks blocks (and a
> >> + * block size of 2**@blocksize_bits) is addressable by the sector_t
> >> + * and page cache of the system.  Return 0 if so and -EFBIG otherwise.
> >> + */
> >> +int generic_check_addressable(unsigned blocksize_bits, u64 num_blocks)
> >> +{
> >> +	u64 last_fs_block = num_blocks - 1;
> >> +
> >> +	BUG_ON(blocksize_bits < 9);
> >> +	BUG_ON(blocksize_bits > PAGE_CACHE_SHIFT);
> 
> I'd rather not have a BUG_ON() for a "check" function that may be called with on-disk values by some filesystem.  Some filesystems (AFAIR) also handle blocksize > PAGE_SIZE internally, so this helper would not be useful for them.

	Filesystems that handle their own page cache certainly wouldn't
be interested in a generic helper anyway.  All of our pagecache assumes
blocks between 512<->PAGE_CACHE_SIZE.
	If I change the BUG_ON()s to -EINVAL, does that work?  Or do you
have some way you'd like to allow non-pagecache filesystems to use this
as well?

Joel

-- 

"I am working for the time when unqualified blacks, browns, and
 women join the unqualified men in running our government."
	- Sissy Farenthold

Joel Becker
Consulting Software Developer
Oracle
E-mail: joel.becker@oracle.com
Phone: (650) 506-8127
