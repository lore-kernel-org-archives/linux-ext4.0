From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] ext4: Only call update_backups if necessary in online
 resize.
Date: Tue, 25 Sep 2012 23:39:35 -0400
Message-ID: <20120926033935.GD11468@thunk.org>
References: <1348498817-3598-1-git-send-email-tm@tao.ma>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Tao Ma <tm@tao.ma>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:52385 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751107Ab2IZDji (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 25 Sep 2012 23:39:38 -0400
Content-Disposition: inline
In-Reply-To: <1348498817-3598-1-git-send-email-tm@tao.ma>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Sep 24, 2012 at 11:00:17PM +0800, Tao Ma wrote:
> @@ -1355,8 +1356,16 @@ exit_journal:
>  			int gdb_num;
>  			gdb_num = group / EXT4_BLOCKS_PER_GROUP(sb);
>  			gdb_bh = sbi->s_group_desc[gdb_num];
> -			update_backups(sb, gdb_bh->b_blocknr, gdb_bh->b_data,
> -				       gdb_bh->b_size);
> +			/*
> +			 * only backup the group descriptor block
> +			 * which hasn't been updated before.
> +			 */
> +			if (old_gdb != gdb_bh->b_blocknr) {
> +				update_backups(sb, gdb_bh->b_blocknr,
> +					       gdb_bh->b_data,
> +					       gdb_bh->b_size);
> +				old_gdb = gdb_bh->b_blocknr;
> +			}
>  		}
>  	}

Don't we also need to add a call to update_backups() at the end of the
loop so we update the backup block descriptors for the very last set
of block groups?

Thanks,

						- Ted
