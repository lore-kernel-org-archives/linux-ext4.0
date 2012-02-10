From: Eric Sandeen <esandeen@redhat.com>
Subject: Re: [resend PATCH] ext4: avoid deadlock on sync-mounted ext2 FS
Date: Fri, 10 Feb 2012 16:43:17 -0600
Message-ID: <4F359D85.9070008@redhat.com>
References: <1327941292-3907-1-git-send-email-martin.wilck@ts.fujitsu.com> <1328869917-21492-1-git-send-email-martin.wilck@ts.fujitsu.com>
Reply-To: sandeen@redhat.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu,
	adilger.kernel@dilger.ca, fmayhar@google.com
To: Martin Wilck <martin.wilck@ts.fujitsu.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:40996 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932767Ab2BJWnY (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 10 Feb 2012 17:43:24 -0500
In-Reply-To: <1328869917-21492-1-git-send-email-martin.wilck@ts.fujitsu.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 02/10/2012 04:31 AM, Martin Wilck wrote:
> I don't want to bother, but could someone have a look at this
> patch please?

You have to bother, to get attention ;)

> Martin
> 
> Processes hang forever on a sync-mounted ext2 file system that
> is mounted with the ext4 module (default in Fedora 16).
> 
> I can reproduce this reliably by mounting an ext2 partition with
> "-o sync" and opening a new file an that partition with vim. vim
> will hang in "D" state forever.
> 
> I am attaching a small patch here that solves this issue for me.
> In the sync mounted case, ext4_handle_dirty_metadata() may call
> sync_dirty_buffer(), which can't be called with buffer lock held.
> 
> My knowledge of locking in ext4 is insufficient to judge if this
> patch is correct, but it may serve as starting point for others.

This looks an awful lot like:

b2f49033d80c952a0ffc2d5647bc1a0b8a09c1b3 [PATCH] fix deadlock in ext2

from 2006!  :)

But I'm also eyeballing:

8a2bfdcbfa441d8b0e5cb9c9a7f45f77f80da465 [PATCH] ext[34]: EA block
reference count racing fix

to be sure it doesn't regress anything there.

And I'd really like to know why this only happens on ext2-with-ext4
(ext4 nojournal seems ok... hm, actually, I can't repro it on
ext2 either...)

Ahah.  Ok, makes sense, it has to be mkfs'd with a 128-byte inode, so
that selinux xattrs will go into an external block.  Now I can reproduce
it on ext2.  But still not on ext4, with 128-byte-inodes
and nojournal.  Odd.  I'd like to sort that out.

The patch also unlocks prior to mb_cache_entry_release(), and I think
that might put some of the raciness back?

-Eric


> Signed-off-by: Martin.Wilck@ts.fujitsu.com
> ---
>  fs/ext4/xattr.c |    3 ++-
>  1 files changed, 2 insertions(+), 1 deletions(-)
> 
> diff --git a/fs/ext4/xattr.c b/fs/ext4/xattr.c
> index 93a00d8..eb771ea 100644
> --- a/fs/ext4/xattr.c
> +++ b/fs/ext4/xattr.c
> @@ -487,8 +487,10 @@ ext4_xattr_release_block(handle_t *handle, struct inode *inode,
>  		ext4_free_blocks(handle, inode, bh, 0, 1,
>  				 EXT4_FREE_BLOCKS_METADATA |
>  				 EXT4_FREE_BLOCKS_FORGET);
> +		unlock_buffer(bh);
>  	} else {
>  		le32_add_cpu(&BHDR(bh)->h_refcount, -1);
> +		unlock_buffer(bh);
>  		error = ext4_handle_dirty_metadata(handle, inode, bh);
>  		if (IS_SYNC(inode))
>  			ext4_handle_sync(handle);
> @@ -498,7 +500,6 @@ ext4_xattr_release_block(handle_t *handle, struct inode *inode,
>  		if (ce)
>  			mb_cache_entry_release(ce);
>  	}
> -	unlock_buffer(bh);
>  out:
>  	ext4_std_error(inode->i_sb, error);
>  	return;

