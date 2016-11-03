From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: Re: [PATCH 01/11] ext4: Factor out checks from ext4_file_write_iter()
Date: Thu, 3 Nov 2016 15:04:40 -0600
Message-ID: <20161103210440.GA27351@linux.intel.com>
References: <1478034381-19037-1-git-send-email-jack@suse.cz>
 <1478034381-19037-2-git-send-email-jack@suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        Dave Chinner <david@fromorbit.com>, Ted Tso <tytso@mit.edu>,
        linux-nvdimm@lists.01.org
To: Jan Kara <jack@suse.cz>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1478034381-19037-2-git-send-email-jack@suse.cz>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Tue, Nov 01, 2016 at 10:06:11PM +0100, Jan Kara wrote:
> Factor out checks of 'from' and whether we are overwriting out of
> ext4_file_write_iter() so that the function is easier to follow.
> 
> Signed-off-by: Jan Kara <jack@suse.cz>
> ---
>  fs/ext4/file.c | 97 ++++++++++++++++++++++++++++++----------------------------
>  1 file changed, 50 insertions(+), 47 deletions(-)
> 
> diff --git a/fs/ext4/file.c b/fs/ext4/file.c
> index 2a822d30e73f..a6a7becb9465 100644
> --- a/fs/ext4/file.c
> +++ b/fs/ext4/file.c
> @@ -88,6 +88,51 @@ ext4_unaligned_aio(struct inode *inode, struct iov_iter *from, loff_t pos)
>  	return 0;
>  }
>  
> +/* Is IO overwriting allocated and initialized blocks? */
> +static bool ext4_overwrite_io(struct inode *inode, loff_t pos, loff_t len)
> +{
> +	struct ext4_map_blocks map;
> +	unsigned int blkbits = inode->i_blkbits;
> +	int err, blklen;
> +
> +	if (pos + len > i_size_read(inode))
> +		return false;
> +
> +	map.m_lblk = pos >> blkbits;
> +	map.m_len = EXT4_MAX_BLOCKS(len, pos, blkbits);
> +	blklen = map.m_len;
> +
> +	err = ext4_map_blocks(NULL, inode, &map, 0);
> +	/*
> +	 * 'err==len' means that all of blocks has been preallocated no matter
> +	 * they are initialized or not.  For excluding unwritten extents, we
> +	 * need to check m_flags.

Does it make sense to clean up this comment, since you're moving it anyway?

i.e.:

  'err==len' means that all of the blocks have been preallocated, regardless
  of whether they have been initialized or not.  To exclude unwritten extents
  we need to check m_flags.
