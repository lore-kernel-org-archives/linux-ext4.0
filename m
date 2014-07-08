From: =?ISO-8859-15?Q?Luk=E1=A8_Czerner?= <lczerner@redhat.com>
Subject: Re: [PATCH] ext4: fix unjournalled bg descriptor while initializing
 inode bitmap
Date: Tue, 8 Jul 2014 08:46:14 +0200 (CEST)
Message-ID: <alpine.LFD.2.00.1407080845130.2180@localhost.localdomain>
References: <1404592131-29738-1-git-send-email-tytso@mit.edu>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>,
	stable@vger.kernel.org
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:12561 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751931AbaGHGqT (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 8 Jul 2014 02:46:19 -0400
In-Reply-To: <1404592131-29738-1-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sat, 5 Jul 2014, Theodore Ts'o wrote:

> Date: Sat,  5 Jul 2014 16:28:51 -0400
> From: Theodore Ts'o <tytso@mit.edu>
> To: Ext4 Developers List <linux-ext4@vger.kernel.org>
> Cc: Theodore Ts'o <tytso@mit.edu>, stable@vger.kernel.org
> Subject: [PATCH] ext4: fix unjournalled bg descriptor while initializing inode
>      bitmap
> 
> The first time that we allocate from an uninitialized inode allocation
> bitmap, if the block allocation bitmap is also uninitalized, we need
> to get write access to the block group descriptor before we start
> modifying the block group descriptor flags and updating the free block
> count, etc.  Otherwise, there is the potential of a bad journal
> checksum (if journal checksums are enabled), and of the file system
> becoming inconsistent if we crash at exactly the wrong time.

Looks good.

Reviewed-by: Lukas Czerner <lczerner@redhat.com>

> 
> Signed-off-by: Theodore Ts'o <tytso@mit.edu>
> Cc: stable@vger.kernel.org
> ---
>  fs/ext4/ialloc.c | 14 +++++++-------
>  1 file changed, 7 insertions(+), 7 deletions(-)
> 
> diff --git a/fs/ext4/ialloc.c b/fs/ext4/ialloc.c
> index a87455d..0840bf3 100644
> --- a/fs/ext4/ialloc.c
> +++ b/fs/ext4/ialloc.c
> @@ -874,6 +874,13 @@ got:
>  		goto out;
>  	}
>  
> +	BUFFER_TRACE(group_desc_bh, "get_write_access");
> +	err = ext4_journal_get_write_access(handle, group_desc_bh);
> +	if (err) {
> +		ext4_std_error(sb, err);
> +		goto out;
> +	}
> +
>  	/* We may have to initialize the block bitmap if it isn't already */
>  	if (ext4_has_group_desc_csum(sb) &&
>  	    gdp->bg_flags & cpu_to_le16(EXT4_BG_BLOCK_UNINIT)) {
> @@ -910,13 +917,6 @@ got:
>  		}
>  	}
>  
> -	BUFFER_TRACE(group_desc_bh, "get_write_access");
> -	err = ext4_journal_get_write_access(handle, group_desc_bh);
> -	if (err) {
> -		ext4_std_error(sb, err);
> -		goto out;
> -	}
> -
>  	/* Update the relevant bg descriptor fields */
>  	if (ext4_has_group_desc_csum(sb)) {
>  		int free;
> 
