From: =?ISO-8859-15?Q?Luk=E1=A8_Czerner?= <lczerner@redhat.com>
Subject: Re: [PATCH] ext4: remove unnecessary lock/unlock of
 i_block_reservation_lock
Date: Tue, 24 Mar 2015 15:53:54 +0100 (CET)
Message-ID: <alpine.LFD.2.00.1503241553070.2541@localhost.localdomain>
References: <1427202704-6264-1-git-send-email-mlombard@redhat.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu
To: Maurizio Lombardi <mlombard@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:35535 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752212AbbCXOx5 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 24 Mar 2015 10:53:57 -0400
In-Reply-To: <1427202704-6264-1-git-send-email-mlombard@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, 24 Mar 2015, Maurizio Lombardi wrote:

> Date: Tue, 24 Mar 2015 14:11:44 +0100
> From: Maurizio Lombardi <mlombard@redhat.com>
> To: linux-ext4@vger.kernel.org
> Cc: tytso@mit.edu
> Subject: [PATCH] ext4: remove unnecessary lock/unlock of
>     i_block_reservation_lock
> 
> This is a leftover of commit 71d4f7d032149b935a26eb3ff85c6c837f3714e1

Ah yes, seems we're only now finding missing leftovers from that
commit :)

Reviewed-by: Lukas Czerner <lczerner@redhat.com>

Thanks!
-Lukas

> 
> Signed-off-by: Maurizio Lombardi <mlombard@redhat.com>
> ---
>  fs/ext4/balloc.c | 2 --
>  1 file changed, 2 deletions(-)
> 
> diff --git a/fs/ext4/balloc.c b/fs/ext4/balloc.c
> index 83a6f49..2072c70 100644
> --- a/fs/ext4/balloc.c
> +++ b/fs/ext4/balloc.c
> @@ -641,8 +641,6 @@ ext4_fsblk_t ext4_new_meta_blocks(handle_t *handle, struct inode *inode,
>  	 * fail EDQUOT for metdata, but we do account for it.
>  	 */
>  	if (!(*errp) && (flags & EXT4_MB_DELALLOC_RESERVED)) {
> -		spin_lock(&EXT4_I(inode)->i_block_reservation_lock);
> -		spin_unlock(&EXT4_I(inode)->i_block_reservation_lock);
>  		dquot_alloc_block_nofail(inode,
>  				EXT4_C2B(EXT4_SB(inode->i_sb), ar.len));
>  	}
> 
