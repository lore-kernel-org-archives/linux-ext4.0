From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 05/23] ext4: Calculate and verify superblock checksum
Date: Fri, 27 Apr 2012 16:05:00 -0400
Message-ID: <20120427200500.GA29481@thunk.org>
References: <20120306204750.1663.96751.stgit@elm3b70.beaverton.ibm.com>
 <20120306204828.1663.39312.stgit@elm3b70.beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andreas Dilger <adilger.kernel@dilger.ca>,
	Sunil Mushran <sunil.mushran@oracle.com>,
	Martin K Petersen <martin.petersen@oracle.com>,
	Greg Freemyer <greg.freemyer@gmail.com>,
	Amir Goldstein <amir73il@gmail.com>,
	linux-kernel <linux-kernel@vger.kernel.org>,
	Andi Kleen <andi@firstfloor.org>,
	Mingming Cao <cmm@us.ibm.com>,
	Joel Becker <jlbec@evilplan.org>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	linux-ext4@vger.kernel.org, Coly Li <colyli@gmail.com>
To: "Darrick J. Wong" <djwong@us.ibm.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20120306204828.1663.39312.stgit@elm3b70.beaverton.ibm.com>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Tue, Mar 06, 2012 at 12:48:28PM -0800, Darrick J. Wong wrote:
> diff --git a/fs/ext4/ext4_jbd2.c b/fs/ext4/ext4_jbd2.c
> index aca1790..90f7c2e 100644
> --- a/fs/ext4/ext4_jbd2.c
> +++ b/fs/ext4/ext4_jbd2.c
> @@ -138,16 +138,23 @@ int __ext4_handle_dirty_metadata(const char *where, unsigned int line,
>  }
>  
>  int __ext4_handle_dirty_super(const char *where, unsigned int line,
> -			      handle_t *handle, struct super_block *sb)
> +			      handle_t *handle, struct super_block *sb,
> +			      int now)
>  {
>  	struct buffer_head *bh = EXT4_SB(sb)->s_sbh;
>  	int err = 0;
>  
>  	if (ext4_handle_valid(handle)) {
> +		ext4_superblock_csum_set(sb,
> +				(struct ext4_super_block *)bh->b_data);
>  		err = jbd2_journal_dirty_metadata(handle, bh);
>  		if (err)
>  			ext4_journal_abort_handle(where, line, __func__,
>  						  bh, handle, err);
> +	} else if (now) {
> +		ext4_superblock_csum_set(sb,
> +				(struct ext4_super_block *)bh->b_data);
> +		mark_buffer_dirty(bh);
>  	} else
>  		sb->s_dirt = 1;
>  	return err;

What's the point of having the ext4_handle_dirty_super_now() variant?

I don't see the point of having this?

						- Ted
