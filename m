From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: [PATCH 11/12] ext4: simplify parameters of add_new_gdb()
Date: Mon, 18 Jul 2011 00:46:02 -0600
Message-ID: <0A64161B-0BC0-4F64-86EB-50FBBCD7A7AF@dilger.ca>
References: <1310957555-15617-1-git-send-email-xiaoqiangnk@gmail.com> <1310957555-15617-12-git-send-email-xiaoqiangnk@gmail.com>
Mime-Version: 1.0 (Apple Message framework v1084)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>
To: Yongqiang Yang <xiaoqiangnk@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from idcmail-mo2no.shaw.ca ([64.59.134.9]:23251 "EHLO
	idcmail-mo2no.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751082Ab1GRGqD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 18 Jul 2011 02:46:03 -0400
In-Reply-To: <1310957555-15617-12-git-send-email-xiaoqiangnk@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 2011-07-17, at 8:52 PM, Yongqiang Yang wrote:
> add_new_gdb() only needs the no. of a group, there is no need to pass
> a pointer to struct ext4_new_group_data to add_new_gdb().
> 
> static int add_new_gdb(handle_t *handle, struct inode *inode,
> -		       struct ext4_new_group_data *input,
> -		       struct buffer_head **primary)
> +		       ext4_group_t group)

This patch is changing the code in a subtle, but not incorrect way.
At a minimum, the commit comment should also mention why "primary"
can be removed as an argument.  That is because add_new_gdb() is
storing the bh pointer for the new group descriptor block into
s_group_desc[] internally:

> @@ -513,7 +514,7 @@ static int add_new_gdb(handle_t *handle, struct inode *inode,
> 	o_group_desc = EXT4_SB(sb)->s_group_desc;
> 	memcpy(n_group_desc, o_group_desc,
> 	       EXT4_SB(sb)->s_gdb_count * sizeof(struct buffer_head *));
> -	n_group_desc[gdb_num] = *primary;
> +	n_group_desc[gdb_num] = gdb_bh;

Here...

> @@ -843,8 +844,12 @@ int ext4_group_add(struct super_block *sb, struct ext4_new_group_data *input)
> 		if (reserved_gdb && ext4_bg_num_gdb(sb, input->group) &&
> 		    (err = reserve_backup_gdb(handle, inode, input)))
> 			goto exit_journal;
> -	} else if ((err = add_new_gdb(handle, inode, input, &primary)))
> -		goto exit_journal;
> +	} else {
> +		err = add_new_gdb(handle, inode, input->group);
> +		if (err)
> +			goto exit_journal;
> +		primary = sbi->s_group_desc[gdb_num];

and the caller can safely access this after the function returns.  It
would be incorrect to "optimize" this code to consolidate the setting
of "primary" from sbi->s_group_desc[gdb_num] before the if/else clause,
so this should get a comment that this array element is only valid after
add_new_gdb() returns.

Cheers, Andreas





