From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [patch 1/2 v2] ext4: simplify some code in read_mmp_block()
Date: Sat, 15 Aug 2015 11:37:13 -0400
Message-ID: <20150815153713.GB22485@thunk.org>
References: <20150814094701.GA14179@mwanda>
 <6D4783E5-BFDB-42E0-800A-DFD18B3E7A64@dilger.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Dan Carpenter <dan.carpenter@oracle.com>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>,
	kernel-janitors@vger.kernel.org
To: Andreas Dilger <adilger@dilger.ca>
Return-path: <kernel-janitors-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <6D4783E5-BFDB-42E0-800A-DFD18B3E7A64@dilger.ca>
Sender: kernel-janitors-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Fri, Aug 14, 2015 at 11:03:46AM -0600, Andreas Dilger wrote:
> > My static check complains because we have:
> > 
> > 	if (!*bh)
> > 		return -ENOMEM;
> > 	if (*bh) {
> > 
> > The second check is unnecessary.
> > 
> > I've simplified this code by moving the "if (!*bh)" checks around.  Also
> > Andreas Dilger says we should probably print a warning if sb_getblk()
> > fails.
> > 
> > Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> 
> Reviewed-by: Andreas Dilger <adilger@dilger.ca>

Applied, thanks.  I've changed the patch slightly to also print a
warning if the MMP magic number and/or checksum for the MMP block
doesn't check out, and to print the error code to disambiguate between
the various failure cases.

One thing, from looking at the function --- it looks like it might be
a good idea if we were to move the call to clear_buffer_uptodate() to
*after* the sb_getblk() call, no?

Otherwise we don't reread the MMP block if it is already in the cache,
and it is the first time read_mmp_block() is called in a function in
fs/ext4/mmp.c.....

							- Ted
