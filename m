From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 1/3] ext4: sanity check the block and cluster size at
 mount time
Date: Fri, 18 Nov 2016 13:00:54 -0500
Message-ID: <20161118180054.g2qcasadx5aqqrva@thunk.org>
References: <5ce3de05-2f37-6758-1178-ecf520c87d4f@kyup.com>
 <20161118042610.13464-1-tytso@mit.edu>
 <DF4FD9C9-580B-4DBE-BD88-6E7067EC69E9@dilger.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>, kernel@kyup.com,
        bp@alien8.de, stable@vger.kernel.org
To: Andreas Dilger <adilger@dilger.ca>
Return-path: <stable-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <DF4FD9C9-580B-4DBE-BD88-6E7067EC69E9@dilger.ca>
Sender: stable-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Fri, Nov 18, 2016 at 01:38:10AM -0700, Andreas Dilger wrote:
> > @@ -3567,7 +3567,15 @@ static int ext4_fill_super(struct super_block *sb, void *data, int silent)
> > 	if (blocksize < EXT4_MIN_BLOCK_SIZE ||
> > 	    blocksize > EXT4_MAX_BLOCK_SIZE) {
> > 		ext4_msg(sb, KERN_ERR,
> > -		       "Unsupported filesystem blocksize %d", blocksize);
> > +		       "Unsupported filesystem blocksize %d (%d)",
> 
> Would be good to indicate what the second value is, like "(%d bits)".

Good idea; I've annotated it as "log_block_size".

					- Ted
