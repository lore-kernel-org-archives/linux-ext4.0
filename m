From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH] fs/ext*,f2fs,jffs2,reiserfs: give comments for acl
 size and count calculation
Date: Mon, 31 Dec 2012 16:45:59 +0100
Message-ID: <20121231154559.GG7564@quack.suse.cz>
References: <50DD20B2.6040204@asianux.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: jack@suse.cz, akpm@linux-foundation.org, adilger.kernel@dilger.ca,
	Theodore Ts'o <tytso@mit.edu>, jaegeuk.kim@samsung.com,
	dwmw2@infradead.org, torvalds@linux-foundation.org,
	linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net,
	linux-mtd@lists.infradead.org, reiserfs-devel@vger.kernel.org
To: Chen Gang <gang.chen@asianux.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:60373 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750958Ab2LaPqH (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 31 Dec 2012 10:46:07 -0500
Content-Disposition: inline
In-Reply-To: <50DD20B2.6040204@asianux.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri 28-12-12 12:31:46, Chen Gang wrote:
> 
>   give comments (by Theodore Ts'o)
> 
>     ACL_USER_OBJ ACL_USER*[1] ACL_GROUP_OBJ ACL_GROUP*[1] ACL_MASK[2] ACL_OTHER
> 
>     [1] Where * is the regexp sense of "0 or more times"
>     [2] Only if there is at least one ACL_USER or ACL_GROUP tag;
>         otherwise skip ACL_MASK.
> 
>   use macro instead of hard code number (by Chen Gang)
> 
> Signed-off-by: Theodore Ts'o <tytso@mit.edu>
> Signed-off-by: Chen Gang <gang.chen@asianux.com>
> ---
...
> diff --git a/include/linux/posix_acl.h b/include/linux/posix_acl.h
> index 7931efe..d75d2f6 100644
> --- a/include/linux/posix_acl.h
> +++ b/include/linux/posix_acl.h
> @@ -26,6 +26,15 @@
>  #define ACL_MASK		(0x10)
>  #define ACL_OTHER		(0x20)
>  
> +/*
> + * ACL_USER_OBJ ACL_USER*[1] ACL_GROUP_OBJ ACL_GROUP*[1] ACL_MASK[2] ACL_OTHER
> + *
> + * [1] Where * is the regexp sense of "0 or more times"
> + * [2] Only if there is at least one ACL_USER or ACL_GROUP tag;
> + *     otherwise skip ACL_MASK.
> + */
> +#define ACL_MAX_SHORT_ENTRY     (4)
> +
  I agree that defining a constant for this makes sence. Just please be
more verbose with the comment. This is hardly readable for anyone not
knowing what's going on in advance. Also braces around 4 are superfluous.
Add something like the comment below before posix_acl_valid():

/*
 * posix_acl_valid() makes sure ACL format is the following:
 * ACL_USER_OBJ ACL_USER*[1] ACL_GROUP_OBJ ACL_GROUP*[1] ACL_MASK[2] ACL_OTHER
 *
 * [1] Where * is the regexp sense of "0 or more times"
 * [2] If ACL_USER or ACL_GROUP is present, then ACL_MASK must be present.
 */

Then add comment before definition of ACL_MAX_SHORT_ENTRY:
/*
 * posix_acl_valid() makes sure that if there are <= 4 ACL entries, then
 * all of them are short. Otherwise exactly 4 entries are short ones and
 * other have full length. See comment before that function for exact ACL
 * format.
 */

								Honza
>  /* permissions in the e_perm field */
>  #define ACL_READ		(0x04)
>  #define ACL_WRITE		(0x02)
> -- 
> 1.7.10.4
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
