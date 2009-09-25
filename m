From: Andreas Dilger <adilger@sun.com>
Subject: Re: [PATCH]ext4: Add checks whether two inodes are different
Date: Fri, 25 Sep 2009 04:34:53 -0600
Message-ID: <20090925103453.GR10562@webber.adilger.int>
References: <4ABC7FC5.5070803@rs.jp.nec.com>
Mime-Version: 1.0
Content-Type: text/plain; CHARSET=US-ASCII
Content-Transfer-Encoding: 7BIT
Cc: Theodore Tso <tytso@mit.edu>, linux-ext4@vger.kernel.org
To: Akira Fujita <a-fujita@rs.jp.nec.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from sca-es-mail-2.Sun.COM ([192.18.43.133]:47165 "EHLO
	sca-es-mail-2.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751076AbZIYKe5 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 25 Sep 2009 06:34:57 -0400
Received: from fe-sfbay-10.sun.com ([192.18.43.129])
	by sca-es-mail-2.sun.com (8.13.7+Sun/8.12.9) with ESMTP id n8PAYwpa006987
	for <linux-ext4@vger.kernel.org>; Fri, 25 Sep 2009 03:35:00 -0700 (PDT)
Content-disposition: inline
Received: from conversion-daemon.fe-sfbay-10.sun.com by fe-sfbay-10.sun.com
 (Sun Java(tm) System Messaging Server 7u2-7.04 64bit (built Jul  2 2009))
 id <0KQI00J00VYFA100@fe-sfbay-10.sun.com> for linux-ext4@vger.kernel.org; Fri,
 25 Sep 2009 03:34:57 -0700 (PDT)
In-reply-to: <4ABC7FC5.5070803@rs.jp.nec.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sep 25, 2009  17:31 +0900, Akira Fujita wrote:
> ext4: Add checks whether two inodes are different to move_extent.c
> 
> From: Akira Fujita <a-fujita@rs.jp.nec.com>
> 
> If same inode is set to orig and donor in ext4_move_extensts(),
> this leads to the deadlock in mext_double_down_{read, write}.
> This patch adds checks to mext_double_{down, up}_{read, write}
> and if inodes are same, we take/release one semaphore from them.

Wouldn't it make more sense to just return an error (or no error
but do nothing) in the case of source/target inode being the same?
I don't see how that would be good to "defragment" the inode onto
itself, just like "cp f f" and "rename f f" don't make sense either.

> Signed-off-by: Akira Fujita <a-fujita@rs.jp.nec.com>
> ---
>  fs/ext4/move_extent.c |   14 +++++++++-----
>  1 files changed, 9 insertions(+), 5 deletions(-)
> 
> diff --git a/fs/ext4/move_extent.c b/fs/ext4/move_extent.c
> index c07a291..e1346cb 100644
> --- a/fs/ext4/move_extent.c
> +++ b/fs/ext4/move_extent.c
> @@ -177,7 +177,8 @@ mext_double_down_read(struct inode *orig_inode, struct inode *donor_inode)
>  	}
> 
>  	down_read(&EXT4_I(first)->i_data_sem);
> -	down_read(&EXT4_I(second)->i_data_sem);
> +	if (first != second)
> +		down_read(&EXT4_I(second)->i_data_sem);
>  }
> 
>  /**
> @@ -203,7 +204,8 @@ mext_double_down_write(struct inode *orig_inode, struct inode *donor_inode)
>  	}
> 
>  	down_write(&EXT4_I(first)->i_data_sem);
> -	down_write(&EXT4_I(second)->i_data_sem);
> +	if (first != second)
> +		down_write(&EXT4_I(second)->i_data_sem);
>  }
> 
>  /**
> @@ -217,7 +219,8 @@ static void
>  mext_double_up_read(struct inode *orig_inode, struct inode *donor_inode)
>  {
>  	up_read(&EXT4_I(orig_inode)->i_data_sem);
> -	up_read(&EXT4_I(donor_inode)->i_data_sem);
> +	if (orig_inode != donor_inode)
> +		up_read(&EXT4_I(donor_inode)->i_data_sem);
>  }
> 
>  /**
> @@ -231,7 +234,8 @@ static void
>  mext_double_up_write(struct inode *orig_inode, struct inode *donor_inode)
>  {
>  	up_write(&EXT4_I(orig_inode)->i_data_sem);
> -	up_write(&EXT4_I(donor_inode)->i_data_sem);
> +	if (orig_inode != donor_inode)
> +		up_write(&EXT4_I(donor_inode)->i_data_sem);
>  }
> 
>  /**
> @@ -1002,7 +1006,7 @@ mext_check_arguments(struct inode *orig_inode,
>  	}
> 
>  	/* orig and donor should be different file */
> -	if (orig_inode->i_ino == donor_inode->i_ino) {
> +	if (orig_inode == donor_inode) {
>  		ext4_debug("ext4 move extent: The argument files should not "
>  			"be same file [ino:orig %lu, donor %lu]\n",
>  			orig_inode->i_ino, donor_inode->i_ino);
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

Cheers, Andreas
--
Andreas Dilger
Sr. Staff Engineer, Lustre Group
Sun Microsystems of Canada, Inc.

