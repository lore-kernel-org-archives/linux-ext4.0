From: Carlos Maiolino <cmaiolino@redhat.com>
Subject: Re: [PATCH] ext4: trigger the lazy inode table initialization after
 resize
Date: Mon, 14 Jan 2013 11:04:15 -0200
Message-ID: <20130114130415.GB3906@andromeda.usersys.redhat.com>
References: <20130113133706.GA30477@thunk.org>
 <1358084571-3042-1-git-send-email-tytso@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>,
	esandeen@redhat.com
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:32053 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755712Ab3ANNE0 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 14 Jan 2013 08:04:26 -0500
Content-Disposition: inline
In-Reply-To: <1358084571-3042-1-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi,

> @@ -358,6 +361,7 @@ group_add_out:
>  		ext4_fsblk_t n_blocks_count;
>  		struct super_block *sb = inode->i_sb;
>  		int err = 0, err2 = 0;
> +		ext4_group_t o_group = EXT4_SB(sb)->s_groups_count;
>  
>  		if (EXT4_HAS_RO_COMPAT_FEATURE(sb,
>  			       EXT4_FEATURE_RO_COMPAT_BIGALLOC)) {
> @@ -388,6 +392,11 @@ group_add_out:
>  		if (err == 0)
>  			err = err2;
>  		mnt_drop_write_file(filp);
> +		if (!err && (o_group > EXT4_SB(sb)->s_groups_count) &&

Maybe a n00b question Ted, but can o_group here be bigger than ->s_groups_count
in any chance? 


The patch looks good,

Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>

-- 
Carlos
