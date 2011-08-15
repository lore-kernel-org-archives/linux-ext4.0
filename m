From: Lukas Czerner <lczerner@redhat.com>
Subject: Re: [PATCH] ext4: don't give the "disabling delalloc" if not explicitly
 specified
Date: Mon, 15 Aug 2011 12:14:24 +0200 (CEST)
Message-ID: <alpine.LFD.2.00.1108151134280.3695@dhcp-27-109.brq.redhat.com>
References: <1313290358-12611-1-git-send-email-tytso@mit.edu>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:23321 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751295Ab1HOKO2 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 15 Aug 2011 06:14:28 -0400
In-Reply-To: <1313290358-12611-1-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sat, 13 Aug 2011, Theodore Ts'o wrote:

> If both delalloc and data=journalled are enabled, then a warning
> message that delalloc will be disabled is displayed at mount time.
> Since delalloc is the default, this means this warning is always
> printed which really isn't necessary.  So disable the warning message
> unless the user explicitly asked for delalloc.

Hi Ted,

that seems a bit confusing. Since delalloc is the default how would the
user know that it will be disabled if data=journalled mode is used ?
That said, if users are complaining about the warning so lets at least
add this information into mount man page, but if they are not I am not
sure that we really need to change that.

Thanks!
-Lukas


> 
> Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
> ---
>  fs/ext4/ext4.h  |    2 ++
>  fs/ext4/super.c |    6 ++++--
>  2 files changed, 6 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
> index be593d5..b98b5a1 100644
> --- a/fs/ext4/ext4.h
> +++ b/fs/ext4/ext4.h
> @@ -916,6 +916,8 @@ struct ext4_inode_info {
>  #define EXT4_MOUNT_DISCARD		0x40000000 /* Issue DISCARD requests */
>  #define EXT4_MOUNT_INIT_INODE_TABLE	0x80000000 /* Initialize uninitialized itables */
>  
> +#define EXT4_MOUNT2_DELALLOC_EXPLICIT	0x00000001 /* specified by user */
> +
>  #define clear_opt(sb, opt)		EXT4_SB(sb)->s_mount_opt &= \
>  						~EXT4_MOUNT_##opt
>  #define set_opt(sb, opt)		EXT4_SB(sb)->s_mount_opt |= \
> diff --git a/fs/ext4/super.c b/fs/ext4/super.c
> index 44d0c8d..447eb45 100644
> --- a/fs/ext4/super.c
> +++ b/fs/ext4/super.c
> @@ -1817,6 +1817,7 @@ set_qf_format:
>  			break;
>  		case Opt_delalloc:
>  			set_opt(sb, DELALLOC);
> +			set_opt2(sb, DELALLOC_EXPLICIT);
>  			break;
>  		case Opt_block_validity:
>  			set_opt(sb, BLOCK_VALIDITY);
> @@ -3681,8 +3682,9 @@ no_journal:
>  
>  	if (test_opt(sb, DELALLOC) &&
>  	    (test_opt(sb, DATA_FLAGS) == EXT4_MOUNT_JOURNAL_DATA)) {
> -		ext4_msg(sb, KERN_WARNING, "Ignoring delalloc option - "
> -			 "requested data journaling mode");
> +		if (test_opt2(sb, DELALLOC_EXPLICIT))
> +			ext4_msg(sb, KERN_WARNING, "Ignoring delalloc option "
> +				 "- requested data journaling mode");
>  		clear_opt(sb, DELALLOC);
>  	}
>  	if (test_opt(sb, DIOREAD_NOLOCK)) {
> 
