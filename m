From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 03/74] mke2fs: load configfile blocksize setting before
 64bit checks
Date: Thu, 12 Dec 2013 15:13:25 -0800
Message-ID: <20131212231325.GG10143@birch.djwong.org>
References: <20131211011813.30655.39624.stgit@birch.djwong.org>
 <20131211011837.30655.67812.stgit@birch.djwong.org>
 <2EB0A146-8AAA-4F4A-9B11-29ED1D2B42F2@dilger.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "Theodore Ts'o" <tytso@mit.edu>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>,
	Zheng Liu <wenqing.lz@taobao.com>
To: Andreas Dilger <adilger@dilger.ca>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:46664 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751915Ab3LLXNf (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 12 Dec 2013 18:13:35 -0500
Content-Disposition: inline
In-Reply-To: <2EB0A146-8AAA-4F4A-9B11-29ED1D2B42F2@dilger.ca>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Dec 12, 2013 at 03:28:14PM -0700, Andreas Dilger wrote:
> 
> On Dec 10, 2013, at 6:18 PM, Darrick J. Wong <darrick.wong@oracle.com> wrote:
> 
> > mke2fs has a series of checks to ensure that we don't create a
> > filesystem too big for its blocksize -- if auto-64bit is on, then it
> > turns on 64bit; otherwise it complains.  Unfortunately, it performs
> > these checks before looking in mke2fs.conf for a blocksize, which
> > means that the checks are incorrect if the user specifies a non-4096
> > blocksize in the config file and says nothing on the command line.
> > The bug also has the effect of mandating a 4k block size on any block
> > device larger than 4T in that situation.  Therefore, read the block
> > size from the config file before performing the 64bit checks.
> > 
> > Reviewed-by: Zheng Liu <wenqing.lz@taobao.com>
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > ---
> > misc/mke2fs.c |  134 +++++++++++++++++++++++++++++++--------------------------
> > 1 file changed, 72 insertions(+), 62 deletions(-)
> > 
> > 
> > diff --git a/misc/mke2fs.c b/misc/mke2fs.c
> > index 67c9225..19b6e85 100644
> > --- a/misc/mke2fs.c
> > +++ b/misc/mke2fs.c
> > @@ -1780,15 +1795,67 @@ profile_error:
> > 		}
> > 	}
> > 
> > +	/* Get the hardware sector sizes, if available */
> > +	retval = ext2fs_get_device_sectsize(device_name, &lsector_size);
> > +	if (retval) {
> > +		com_err(program_name, retval,
> > +			_("while trying to determine hardware sector size"));
> > +		exit(1);
> > +	}
> > +	retval = ext2fs_get_device_phys_sectsize(device_name, &psector_size);
> > +	if (retval) {
> > +		com_err(program_name, retval,
> > +			_("while trying to determine physical sector size"));
> > +		exit(1);
> > +	}
> > +
> > +	tmp = getenv("MKE2FS_DEVICE_SECTSIZE");
> > +	if (tmp != NULL)
> > +		lsector_size = atoi(tmp);
> > +	tmp = getenv("MKE2FS_DEVICE_PHYS_SECTSIZE");
> > +	if (tmp != NULL)
> > +		psector_size = atoi(tmp);
> > +
> > +	/* Older kernels may not have physical/logical distinction */
> > +	if (!psector_size)
> > +		psector_size = lsector_size;
> > +
> > +	if (blocksize <= 0) {
> > +		use_bsize = get_int_from_profile(fs_types, "blocksize", 4096);
> > +
> > +		if (use_bsize == -1) {
> > +			use_bsize = sys_page_size;
> > +			if ((linux_version_code < (2*65536 + 6*256)) &&
> 
> Would be nice to have a helper to compute the linux_version_code comparison,
> the above is a bit too much detail for this code.

Hmm, yes, that would be a nice cleanup.

Yikes, there's a test for pre-2.2 kernels elsewhere in mke2fs.c.

How many people still run on Linux 2.0? :D

> 
> > +			    (use_bsize > 4096))
> > +				use_bsize = 4096;
> > +		}
> > +		if (lsector_size && use_bsize < lsector_size)
> > +			use_bsize = lsector_size;
> > +		if ((blocksize < 0) && (use_bsize < (-blocksize)))
> > +			use_bsize = -blocksize;
> > +		blocksize = use_bsize;
> > +		fs_blocks_count /= (blocksize / 1024);
> > +	} else {
> > +		if (blocksize < lsector_size) {			/* Impossible */
> > +			com_err(program_name, EINVAL,
> > +				_("while setting blocksize; too small "
> > +				  "for device\n"));
> > +			exit(1);
> > +		} else if ((blocksize < psector_size) &&
> > +			   (psector_size <= sys_page_size)) {	/* Suboptimal */
> > +			fprintf(stderr, _("Warning: specified blocksize %d is "
> > +				"less than device physical sectorsize %d\n"),
> > +				blocksize, psector_size);
> > +		}
> > +	}
> > +
> > +	fs_param.s_log_block_size =
> > +		int_log2(blocksize >> EXT2_MIN_BLOCK_LOG_SIZE);
> 
> Does it make sense to wrap this whole block size guessing dance into a small
> helper routine, like "figure_fs_blocksize()" or similar?

I suppose it could be cut out into its own helper function, to shrink PRS() a
bit.  I'd have to pass in pointers all the variables that it touches
(blocksize, fs_blocks_count, fs_param, psector_size), which made doing that
less attractive.

--D
> 
> 
> Cheers, Andreas
> 
> 
> 
> 
> 


