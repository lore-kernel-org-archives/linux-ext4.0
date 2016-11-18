From: Eric Biggers <ebiggers@google.com>
Subject: Re: [PATCH 1/4] ext4: sanity check the block and cluster size at
 mount time
Date: Fri, 18 Nov 2016 12:02:46 -0800
Message-ID: <20161118200246.GB73496@google.com>
References: <20161118183842.25682-1-tytso@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>, kernel@kyup.com,
        bp@alien8.de, stable@vger.kernel.org
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <stable-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20161118183842.25682-1-tytso@mit.edu>
Sender: stable-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Fri, Nov 18, 2016 at 01:38:39PM -0500, Theodore Ts'o wrote:
> @@ -3567,7 +3567,15 @@ static int ext4_fill_super(struct super_block *sb, void *data, int silent)
>  	if (blocksize < EXT4_MIN_BLOCK_SIZE ||
>  	    blocksize > EXT4_MAX_BLOCK_SIZE) {
>  		ext4_msg(sb, KERN_ERR,
> -		       "Unsupported filesystem blocksize %d", blocksize);
> +		       "Unsupported filesystem blocksize %d (%d log_block_size)",
> +			 blocksize, le32_to_cpu(es->s_log_block_size));
> +		goto failed_mount;
> +	}
> +	if (le32_to_cpu(es->s_log_block_size) >
> +	    (EXT4_MAX_BLOCK_LOG_SIZE - EXT4_MIN_BLOCK_LOG_SIZE)) {
> +		ext4_msg(sb, KERN_ERR,
> +			 "Invalid log block size: %u",
> +			 le32_to_cpu(es->s_log_block_size));
>  		goto failed_mount;
>  	}
>  

This isn't validating s_log_block_size until after it's already been used in a
shift, which means the code can have undefined behavior (shift by a value too
large).  Would it make sense to do something like the following instead?
Similarly for the cluster size case.

        blocksize =                                                              
                BLOCK_SIZE << min_t(u32, le32_to_cpu(es->s_log_block_size), 20); 
        if (blocksize < EXT4_MIN_BLOCK_SIZE ||                                   
            blocksize > EXT4_MAX_BLOCK_SIZE) {                                   
                ext4_msg(sb, KERN_ERR,                                           
                        "Unsupported filesystem blocksize %d (%u bits)",         
                         blocksize, le32_to_cpu(es->s_log_block_size));          
                goto failed_mount;                                               
        }                                                                        
