From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: Apparent serious progressive ext4 data corruption bug in 3.6.3
 (and other stable branches?)
Date: Sun, 28 Oct 2012 21:24:19 -0500
Message-ID: <508DE8D3.1050101@redhat.com>
References: <20121026205618.GC8614@thunk.org> <87objpx84k.fsf@spindle.srvr.nix> <20121026211542.GE8614@thunk.org> <87haphx76u.fsf@spindle.srvr.nix> <20121027002258.GB31030@thunk.org> <873910xevu.fsf@spindle.srvr.nix> <20121027175534.GA7783@thunk.org> <87fw4zzra3.fsf@spindle.srvr.nix> <508C4FE5.1030102@redhat.com> <508C633F.4070100@redhat.com> <20121029010012.GE9161@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: "Theodore Ts'o" <tytso@mit.edu>, Nix <nix@esperi.org.uk>,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
	gregkh@linuxfoundation.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:60759 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756261Ab2J2CY1 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 28 Oct 2012 22:24:27 -0400
In-Reply-To: <20121029010012.GE9161@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 10/28/12 8:00 PM, Theodore Ts'o wrote:
> On Sat, Oct 27, 2012 at 05:42:07PM -0500, Eric Sandeen wrote:
>>
>> It looks like the inode_bitmap_bh is being modified outside a transaction:
>>
>>                 ret2 = ext4_test_and_set_bit(ino, inode_bitmap_bh->b_data);
>>
>> It needs a get_write_access / handle_dirty_metadata pair around it.
> 
> Oops.   Nice catch!!
> 
> The patch isn't quite right, though.  

Yeah, I knew it wasn't ;)  I did resend 
[PATCH] ext4: fix unjournaled inode bitmap modification
which is a bit more involved.

> We only want to call
> ext4_journal_get_write_access() when we know that there is an available
> bit in the bitmap.  (We could still lose the race, but in that case
> the winner of the race probably grabbed the bitmap block first.)
> 
> Also, we only need to call ext4_handle_dirty_metadata() if we
> successfully grab the bit in the bitmap.
> 
> So I suggest this patch instead:

That'll get_write_access on the same buffer over and over, I suppose
it's ok, but the patch I sent tries to minimize that, and call
ext4_handle_release_buffer if we're not going to use it (which is
a no-op today anyway and not normally used I guess...)

If ext4_handle_release_buffer() is dead code now, and repeated calls
via repeat_in_this_group: are no big deal, then your version looks fine.

-Eric

> commit 087eda81f1ac6a6a0394f781b44f1d555d8f64c6
> Author: Eric Sandeen <sandeen@redhat.com>
> Date:   Sun Oct 28 20:59:57 2012 -0400
> 
>     ext4: fix unjournaled inode bitmap modification
>     
>     commit 119c0d4460b001e44b41dcf73dc6ee794b98bd31 modified this function
>     such that the inode bitmap was being modified outside a transaction,
>     which could lead to corruption, and was discovered when journal_checksum
>     found a bad checksum in the journal.
>     
>     Reported-by: Nix <nix@esperi.org.uk>
>     Signed-off-by: Eric Sandeen <sandeen@redhat.com>
>     Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
>     Cc: stable@vger.kernel.org
> 
> diff --git a/fs/ext4/ialloc.c b/fs/ext4/ialloc.c
> index 4facdd2..575afac 100644
> --- a/fs/ext4/ialloc.c
> +++ b/fs/ext4/ialloc.c
> @@ -725,6 +725,10 @@ repeat_in_this_group:
>  				   "inode=%lu", ino + 1);
>  			continue;
>  		}
> +		BUFFER_TRACE(inode_bitmap_bh, "get_write_access");
> +		err = ext4_journal_get_write_access(handle, inode_bitmap_bh);
> +		if (err)
> +			goto fail;
>  		ext4_lock_group(sb, group);
>  		ret2 = ext4_test_and_set_bit(ino, inode_bitmap_bh->b_data);
>  		ext4_unlock_group(sb, group);
> @@ -738,6 +742,11 @@ repeat_in_this_group:
>  	goto out;
>  
>  got:
> +	BUFFER_TRACE(inode_bitmap_bh, "call ext4_handle_dirty_metadata");
> +	err = ext4_handle_dirty_metadata(handle, NULL, inode_bitmap_bh);
> +	if (err)
> +		goto fail;
> +
>  	/* We may have to initialize the block bitmap if it isn't already */
>  	if (ext4_has_group_desc_csum(sb) &&
>  	    gdp->bg_flags & cpu_to_le16(EXT4_BG_BLOCK_UNINIT)) {
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

