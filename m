From: Lukas Czerner <lczerner@redhat.com>
Subject: Re: [PATCH] ext4: handle NULL p_ext in
 ext4_ext_next_allocated_block()
Date: Mon, 10 Oct 2011 09:19:35 +0200 (CEST)
Message-ID: <alpine.LFD.2.00.1110100841380.4851@dhcp-27-109.brq.redhat.com>
References: <1318122074-16056-1-git-send-email-curtw@google.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: tytso@mit.edu, adilger.kernel@dilger.ca, linux-ext4@vger.kernel.org
To: Curt Wohlgemuth <curtw@google.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:53712 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751654Ab1JJHTn (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 10 Oct 2011 03:19:43 -0400
In-Reply-To: <1318122074-16056-1-git-send-email-curtw@google.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sat, 8 Oct 2011, Curt Wohlgemuth wrote:

> In ext4_ext_next_allocated_block(), the path[depth] might
> have a p_ext that is NULL -- see ext4_ext_binsearch().  In
> such a case, dereferencing it will crash the machine.
> 
> This patch checks for p_ext == NULL in
> ext4_ext_next_allocated_block() before dereferencinging it.
> 
> Tested using a hand-crafted an inode with eh_entries == 0 in
> an extent block, verified that running FIEMAP on it crashes
> without this patch, works fine with it.

Hi Curt,

It seems to me that even that the patch fixes the NULL dereference, it
is not a complete solution. Is it possible that in "normal" case p_ext
would be NULL ? I think that this is only possible in extent split/add
case (as noted in ext4_ext_binsearch()) which should be atomic to the
other operations (locked i_mutex?).

However this seems like an inode corruption so we should probably be
more verbose about it and print an appropriate EXT4_ERROR_INODE() or
even better check for the corrupted tree in the ext4_ext_find_extent()
(instead in ext4_ext_map_blocks()), however this will need to distinguish
between the normal and the tree modification case.

Thanks!
-Lukas

> 
> Signed-off-by: Curt Wohlgemuth <curtw@google.com>
> ---
>  fs/ext4/extents.c |    4 +++-
>  1 files changed, 3 insertions(+), 1 deletions(-)
> 
> diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
> index 57cf568..063a5b8 100644
> --- a/fs/ext4/extents.c
> +++ b/fs/ext4/extents.c
> @@ -1395,7 +1395,9 @@ ext4_ext_next_allocated_block(struct ext4_ext_path *path)
>  	while (depth >= 0) {
>  		if (depth == path->p_depth) {
>  			/* leaf */
> -			if (path[depth].p_ext !=
> +			/* p_ext can be NULL */
> +			if (path[depth].p_ext &&
> +				path[depth].p_ext !=
>  					EXT_LAST_EXTENT(path[depth].p_hdr))
>  			  return le32_to_cpu(path[depth].p_ext[1].ee_block);
>  		} else {
> 
