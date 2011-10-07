From: "Darrick J. Wong" <djwong@us.ibm.com>
Subject: Re: [Ext4 Secure Delete 5/7v4] ext4: Secure Delete: Secure delete
	directory entry
Date: Fri, 7 Oct 2011 10:22:26 -0700
Message-ID: <20111007172226.GF12447@tux1.beaverton.ibm.com>
References: <1317971465-8517-1-git-send-email-achender@linux.vnet.ibm.com> <1317971465-8517-6-git-send-email-achender@linux.vnet.ibm.com>
Reply-To: djwong@us.ibm.com
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org
To: Allison Henderson <achender@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e9.ny.us.ibm.com ([32.97.182.139]:53686 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750753Ab1JGRWf (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 7 Oct 2011 13:22:35 -0400
Content-Disposition: inline
In-Reply-To: <1317971465-8517-6-git-send-email-achender@linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Oct 07, 2011 at 12:11:03AM -0700, Allison Henderson wrote:
> This patch zeros or randomizes a files directory entry when a file
<snip>
> @@ -1669,7 +1672,38 @@ static int ext4_delete_entry(handle_t *handle,
>  				de->inode = 0;
>  			dir->i_version++;
>  			BUFFER_TRACE(bh, "call ext4_handle_dirty_metadata");
> -			err = ext4_handle_dirty_metadata(handle, dir, bh);
> +
> +			/*
> +			 * If the secure remove flag is on, zero
> +			 * or randomize the entry and write it out
> +			 * to the disk
> +			 */
> +			if (flags & EXT4_DEL_ENTRY_ZERO) {
> +				memset(de->name, 0x00, de->name_len);
> +				de->file_type = 0;
> +			} else if (flags & EXT4_DEL_ENTRY_RAND) {
> +				get_random_bytes(de->name, de->name_len);
> +				get_random_bytes(&(de->file_type),
> +					sizeof(de->file_type));

Seeing as name_len and file_type precede name, you could probably reduce this
to one call that zaps all three.  Same for the zero-out case.

Also you might want to make both of these name-erasing calls zap the space
between the end of the name and the end of the record, just in case there's old
filename component still lurking in that space.  (Yes, paranoia...)

> +			}
> +
> +			if (flags & EXT4_DEL_ENTRY_ZERO ||
> +				flags & EXT4_DEL_ENTRY_RAND) {
> +
> +				set_buffer_dirty(bh);
> +				sync_dirty_buffer(bh);
> +				if (buffer_req(bh) && !buffer_uptodate(bh)) {
> +					es->s_last_error_block =
> +						cpu_to_le64(bh->b_blocknr);
> +					ext4_error_inode(dir, __func__,
> +					   __LINE__, bh->b_blocknr,
> +					   "IO error syncing itable block");

itable?

--D
