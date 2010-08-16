From: Jan Kara <jack@suse.cz>
Subject: Re: [Ocfs2-devel] [PATCH 1/3] ext3/ext4: Factor out disk
 addressability check
Date: Mon, 16 Aug 2010 21:21:00 +0200
Message-ID: <20100816192100.GD3708@quack.suse.cz>
References: <20100812201534.GA22777@mail.oracle.com>
 <209AEA97-E284-4ADB-8774-50C2630606B9@dilger.ca>
 <20100812222949.GC22777@mail.oracle.com>
 <20100813163006.GB4329@quack.suse.cz>
 <4C6821A8.5080805@redhat.com>
 <20100816025436.GA9061@mail.oracle.com>
 <4C68B244.6080406@redhat.com>
 <20100816092114.GB9061@mail.oracle.com>
 <4C694ED3.5070500@redhat.com>
 <20100816191319.GC5786@mail.oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Eric Sandeen <sandeen@redhat.com>, Jan Kara <jack@suse.cz>,
	Andreas Dilger <adilger@dilger.ca>, Ted Ts'o <tytso@mit.edu>,
	ocfs2-devel@oss.oracle.com, linux-fsdevel@vger.kernel.org,
	linux-ext4@vger.kernel.org,
	"linux-kernel@vger.kernel.org Patrick J. LoPresti"
	<lopresti@gmail.com>
To: Joel Becker <Joel.Becker@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:59954 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755979Ab0HPTVp (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 16 Aug 2010 15:21:45 -0400
Content-Disposition: inline
In-Reply-To: <20100816191319.GC5786@mail.oracle.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon 16-08-10 12:13:19, Joel Becker wrote:
> On Mon, Aug 16, 2010 at 09:44:35AM -0500, Eric Sandeen wrote:
> > Joel Becker wrote:
> > > How about:
> > > 
> > > 	u64 last_fs_page = last_fs_block >> (PAGE_CACHE_SHIFT - blocksize_bits);
> > > 
> > > 	... ||
> > > 	(last_fs_page > (pgoff_t)(~0ULL))) {
> > > 
> > > Is that more readable?
> > 
> > To me, yes.  Maybe do similar for last_fs_sector.
> 
> 	last_fs_sector would be shifting up, which could wrap a really
> large last_fs_blocks.  So I'm going to keep the sector_t check as-is.
> How's this:
> 
> >From 8de5cb9164cdc179ba84a07b282a895d0eb794b0 Mon Sep 17 00:00:00 2001
> >From: Joel Becker <joel.becker@oracle.com>
> Date: Mon, 16 Aug 2010 12:10:17 -0700
> Subject: [PATCH] libfs: Fix shift bug in generic_check_addressable()
> 
> generic_check_addressable() erroneously shifts pages down by a block
> factor when it should be shifting up.  To prevent overflow, we shift
> blocks down to pages.
> 
> Signed-off-by: Joel Becker <joel.becker@oracle.com>
  Looks good.
Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> ---
>  fs/libfs.c |    8 ++++----
>  1 files changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/fs/libfs.c b/fs/libfs.c
> index 8debe7b..62baa03 100644
> --- a/fs/libfs.c
> +++ b/fs/libfs.c
> @@ -925,6 +925,8 @@ EXPORT_SYMBOL(generic_file_fsync);
>  int generic_check_addressable(unsigned blocksize_bits, u64 num_blocks)
>  {
>  	u64 last_fs_block = num_blocks - 1;
> +	u64 last_fs_page =
> +		last_fs_block >> (PAGE_CACHE_SHIFT - blocksize_bits);
>  
>  	if (unlikely(num_blocks == 0))
>  		return 0;
> @@ -932,10 +934,8 @@ int generic_check_addressable(unsigned blocksize_bits, u64 num_blocks)
>  	if ((blocksize_bits < 9) || (blocksize_bits > PAGE_CACHE_SHIFT))
>  		return -EINVAL;
>  
> -	if ((last_fs_block >
> -	     (sector_t)(~0ULL) >> (blocksize_bits - 9)) ||
> -	    (last_fs_block >
> -	     (pgoff_t)(~0ULL) >> (PAGE_CACHE_SHIFT - blocksize_bits))) {
> +	if ((last_fs_block > (sector_t)(~0ULL) >> (blocksize_bits - 9)) ||
> +	    (last_fs_page > (pgoff_t)(~0ULL))) {
>  		return -EFBIG;
>  	}
>  	return 0;
> -- 
> 1.7.1
> 
> -- 
> 
> Life's Little Instruction Book #267
> 
> 	"Lie on your back and look at the stars."
> 
> Joel Becker
> Consulting Software Developer
> Oracle
> E-mail: joel.becker@oracle.com
> Phone: (650) 506-8127
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
